#!/bin/bash

set -e

device_type="${1:-desktop}"

echo "Running screenshot tests with Chrome..."

# Set environment variable for device type
export FLEXIFY_DEVICE_TYPE="$device_type"

# Run Flutter drive command targeting Chrome
flutter drive --profile --driver=test_driver/integration_test.dart \
    --target=integration_test/screenshot_test.dart \
    --dart-define=FLEXIFY_DEVICE_TYPE="$device_type" \
    -d chrome

echo "Screenshot tests completed successfully!"
