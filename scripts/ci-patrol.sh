#!/usr/bin/env bash

set -uo pipefail

patrol_log=$(mktemp)
trap 'rm -f "$patrol_log"' EXIT

for attempt in 1 2; do
  : >"$patrol_log"
  patrol test -t patrol_test/device_features_test.dart 2>&1 | tee "$patrol_log"
  patrol_status=${PIPESTATUS[0]}

  if [[ $patrol_status -eq 0 ]]; then
    exit 0
  fi

  if grep -Fq "Total: 1" "$patrol_log" &&
    grep -Fq "Successful: 1" "$patrol_log" &&
    grep -Fq "Failed: 0" "$patrol_log"; then
    echo "Patrol reported every test passing despite Gradle returning $patrol_status."
    exit 0
  fi

  if [[ $attempt -eq 1 ]] &&
    grep -Fq "waitUntilVisible() failed with Invalid response: 404 selector" "$patrol_log"; then
    echo "Android's document picker was not visible; retrying Patrol once."
    continue
  fi

  exit "$patrol_status"
done

exit "$patrol_status"
