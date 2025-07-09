param(
    [string]$deviceType = "desktop"
)

Write-Host "Running screenshot tests with Chrome..."

# Set environment variable for device type
$env:FLEXIFY_DEVICE_TYPE = $deviceType

# Run Flutter drive command targeting Chrome
flutter drive --profile --driver=test_driver/integration_test.dart `
    --target=integration_test/screenshot_test.dart `
    --dart-define=FLEXIFY_DEVICE_TYPE="$deviceType" `
    -d chrome

if ($LASTEXITCODE -eq 0) {
    Write-Host "Screenshot tests completed successfully!"
} else {
    Write-Host "Screenshot tests failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}
