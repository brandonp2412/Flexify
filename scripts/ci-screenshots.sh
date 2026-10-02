#!/usr/bin/env bash

set -euo pipefail

: "${FLEXIFY_DEVICE_TYPE:?FLEXIFY_DEVICE_TYPE must be set}"
: "${EMULATOR_PORT:?EMULATOR_PORT must be set}"

device="emulator-$EMULATOR_PORT"
store_locale="en-US"
screenshot_dir="fastlane/metadata/android/$store_locale/images/${FLEXIFY_DEVICE_TYPE}"
expected_count=8
drive_timeout="${SCREENSHOT_DRIVE_TIMEOUT:-12m}"
drive_log="$(mktemp)"
trap 'rm -f "$drive_log"' EXIT

wait_for_emulator() {
  timeout 60 adb -s "$device" wait-for-device >/dev/null 2>&1 || return 1
  local checks=0
  local state
  local boot_completed
  while (( checks < 30 )); do
    state="$(adb -s "$device" get-state 2>/dev/null || true)"
    boot_completed="$(adb -s "$device" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r' || true)"
    if [[ "$state" == "device" && "$boot_completed" == "1" ]]; then
      return 0
    fi
    sleep 2
    ((checks += 1))
  done
  return 1
}

recover_emulator() {
  echo "Recovering emulator transport before retry" >&2
  adb kill-server >/dev/null 2>&1 || true
  adb start-server >/dev/null 2>&1 || true
  adb reconnect offline >/dev/null 2>&1 || true
  wait_for_emulator
}

collect_diagnostics() {
  adb -s "$device" logcat -d -t 300 >&2 || true
  adb -s "$device" shell dumpsys activity top >&2 || true
  adb -s "$device" shell ps -A >&2 || true
}

screenshot_path() {
  printf '%s/%s_%s.png' "$screenshot_dir" "$1" "$store_locale"
}

screenshots_complete() {
  local number
  for ((number = 1; number <= expected_count; number += 1)); do
    [[ -s "$(screenshot_path "$number")" ]] || return 1
  done
}

if ! wait_for_emulator; then
  recover_emulator || {
    echo "Emulator did not become ready" >&2
    collect_diagnostics
    exit 1
  }
fi

if [[ -n "${SCREENSHOT_SCREEN_SIZE:-}" ]]; then
  if [[ ! "$SCREENSHOT_SCREEN_SIZE" =~ ^[0-9]+x[0-9]+$ ]]; then
    echo "Invalid SCREENSHOT_SCREEN_SIZE: $SCREENSHOT_SCREEN_SIZE" >&2
    exit 1
  fi
  adb -s "$device" shell wm size "$SCREENSHOT_SCREEN_SIZE"
  expected_dimensions="${SCREENSHOT_SCREEN_SIZE/x/ x }"
fi

drive_args=(
  flutter drive
  --profile
  --driver=test_driver/integration_test.dart
  --target=integration_test/screenshot_test.dart
  --no-enable-impeller
  -d "$device"
)

drive_status=1
for attempt in 1 2; do
  rm -rf "$screenshot_dir"
  mkdir -p "$screenshot_dir"
  : >"$drive_log"
  drive_status=0

  echo "Running screenshot drive attempt $attempt with a $drive_timeout timeout"
  timeout --foreground --signal=TERM --kill-after=30s "$drive_timeout" \
    "${drive_args[@]}" >"$drive_log" 2>&1 || drive_status=$?

  cat "$drive_log"

  if screenshots_complete && { [[ "$drive_status" -eq 0 ]] || grep -q "All tests passed!" "$drive_log"; }; then
    break
  fi

  transient_failure=0
  if [[ "$drive_status" -eq 124 || "$drive_status" -eq 137 ]] || grep -Eiq \
    'device offline|Connection reset|Connection refused|Service has disappeared|Connecting to the VM Service is taking longer than expected|VMServiceFlutterDriver: It is taking an unusually long time to connect' \
    "$drive_log"; then
    transient_failure=1
  elif grep -q "All tests passed!" "$drive_log" && ! screenshots_complete; then
    transient_failure=1
  fi

  if [[ "$transient_failure" -ne 1 || "$attempt" -eq 2 ]]; then
    collect_diagnostics
    break
  fi

  echo "Transient emulator failure on screenshot attempt $attempt; retrying once" >&2
  collect_diagnostics
  recover_emulator || break
done

for ((number = 1; number <= expected_count; number += 1)); do
  screenshot="$(screenshot_path "$number")"
  if [[ ! -s "$screenshot" ]]; then
    echo "Missing generated screenshot: $screenshot" >&2
    [[ "$drive_status" -ne 0 ]] && exit "$drive_status"
    exit 1
  fi
  if [[ -n "${SCREENSHOT_SCREEN_SIZE:-}" ]] && ! file "$screenshot" | grep -Fq " $expected_dimensions,"; then
    echo "Screenshot has unexpected dimensions: $(file "$screenshot")" >&2
    exit 1
  fi
done

screenshot_count="$(find "$screenshot_dir" -maxdepth 1 -type f -name '*.png' | wc -l | tr -d ' ')"
if [[ "$screenshot_count" -ne "$expected_count" ]]; then
  echo "Expected exactly $expected_count Google Play screenshots, found $screenshot_count" >&2
  exit 1
fi

if [[ "$drive_status" -ne 0 ]]; then
  if ! grep -q "All tests passed!" "$drive_log"; then
    exit "$drive_status"
  fi
  echo "flutter drive lost the emulator during teardown after all screenshots were generated"
fi
