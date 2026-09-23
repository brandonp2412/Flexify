#!/bin/sh

set -u

if [ -z "${FLEXIFY_DEVICE_TYPE:-}" ]; then
  echo "FLEXIFY_DEVICE_TYPE must be set" >&2
  exit 1
fi

if [ -z "${EMULATOR_PORT:-}" ]; then
  echo "EMULATOR_PORT must be set" >&2
  exit 1
fi

screenshot_dir="fastlane/metadata/android/en-US/images/$FLEXIFY_DEVICE_TYPE"
drive_timeout="${SCREENSHOT_DRIVE_TIMEOUT:-12m}"
app_id="com.presley.flexify"
rm -rf "$screenshot_dir"
mkdir -p "$screenshot_dir"

if [ -n "${SCREENSHOT_SCREEN_SIZE:-}" ]; then
  adb -s "emulator-$EMULATOR_PORT" shell wm size "$SCREENSHOT_SCREEN_SIZE"
  expected_dimensions=$(printf '%s' "$SCREENSHOT_SCREEN_SIZE" | sed 's/x/ x /')
fi

run_drive() {
  drive_log=$(mktemp)
  drive_status_file=$(mktemp)
  drive_status=1

  echo "Running screenshot drive with a $drive_timeout timeout"
  {
    timeout --signal=TERM --kill-after=15s "$drive_timeout" \
      flutter drive --profile \
        --no-enable-impeller \
        --driver=test_driver/integration_test.dart \
        --target=integration_test/screenshot_test.dart \
        -d "emulator-$EMULATOR_PORT"
    printf '%s\n' "$?" >"$drive_status_file"
  } 2>&1 | tee "$drive_log"

  if [ -s "$drive_status_file" ]; then
    drive_status=$(cat "$drive_status_file")
  fi
  rm -f "$drive_status_file"

  case "$drive_status" in
    124|137)
      echo "Screenshot drive timed out after $drive_timeout; capturing emulator diagnostics" >&2
      adb -s "emulator-$EMULATOR_PORT" shell dumpsys activity activities 2>/dev/null \
        | grep -m1 'mResumedActivity' >&2 || true
      adb -s "emulator-$EMULATOR_PORT" logcat -d -t 80 >&2 || true
      ;;
  esac
}

screenshots_complete() {
  for number in $(seq 1 8); do
    if [ ! -s "$screenshot_dir/${number}_en-US.png" ]; then
      return 1
    fi
  done
  return 0
}

run_drive

if ! screenshots_complete; then
  echo "Screenshot set incomplete; attempting one clean retry" >&2
  rm -rf "$screenshot_dir"
  mkdir -p "$screenshot_dir"

  adb reconnect offline >/dev/null 2>&1 || true
  timeout 30s adb -s "emulator-$EMULATOR_PORT" wait-for-device >/dev/null 2>&1 || true
  adb -s "emulator-$EMULATOR_PORT" shell am force-stop "$app_id" >/dev/null 2>&1 || true
  sleep 2

  run_drive
fi

for number in $(seq 1 8); do
  if [ ! -s "$screenshot_dir/${number}_en-US.png" ]; then
    echo "Missing generated screenshot: ${number}_en-US.png" >&2
    [ "$drive_status" -ne 0 ] && exit "$drive_status"
    exit 1
  fi
  if [ -n "${SCREENSHOT_SCREEN_SIZE:-}" ] && ! file "$screenshot_dir/${number}_en-US.png" | grep -Fq " $expected_dimensions,"; then
    echo "Screenshot has unexpected dimensions: $(file "$screenshot_dir/${number}_en-US.png")" >&2
    exit 1
  fi
done

if [ "$drive_status" -ne 0 ]; then
  if grep -q "All tests passed!" "$drive_log"; then
    echo "flutter drive lost the emulator during teardown after all screenshots were generated"
  else
    echo "flutter drive exited with status $drive_status after generating the complete validated screenshot set"
  fi
fi
