#!/bin/bash

set -e

device="${1:?Usage: screenshots-android.sh <device-id> [device-type]}"
device_type="${2:-phoneScreenshots}"

echo "Running screenshot tests on Android device $device..."

# Clean stale Kotlin compilation state that can cause
# "cannot find symbol" errors for plugin classes in GeneratedPluginRegistrant.java
(cd android && ./gradlew clean)

export FLEXIFY_DEVICE_TYPE="$device_type"

# --profile is required: Flutter 3.41.x has a framework-level
# assertion bug in PipelineOwner.flushSemantics that fires spuriously
# during integration tests. Profile mode skips Dart asserts, bypassing it.
flutter drive --profile \
    --driver=test_driver/integration_test.dart \
    --target=integration_test/screenshot_test.dart \
    -d "$device"

echo "Screenshot tests completed successfully!"
