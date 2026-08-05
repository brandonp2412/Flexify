#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/screenshot-names.sh"

device="${1:?Usage: screenshots-android.sh <device-id> [device-type] [screenshot]}"
device_type="${2:-phoneScreenshots}"
only="${3:-}"

echo "Running screenshot tests on Android device $device..."

# Clean stale Kotlin compilation state that can cause
# "cannot find symbol" errors for plugin classes in GeneratedPluginRegistrant.java
(cd android && ./gradlew clean)

export FLEXIFY_DEVICE_TYPE="$device_type"

dart_define=()
if [ -n "$only" ]; then
    only="$(screenshot_name "$only")"
    dart_define=(--dart-define=SCREENSHOT_ONLY="$only")
    echo "Capturing only: $only"
fi

# --profile is required: Flutter's framework-level assertion bug in
# PipelineOwner.flushSemantics can fire spuriously during integration tests.
# Profile mode skips Dart asserts, bypassing it.
flutter drive --profile \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/screenshot_test.dart \
    "${dart_define[@]}" \
    -d "$device"

echo "Screenshot tests completed successfully!"
