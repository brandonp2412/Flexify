param(
    [string]$deviceType = "desktop"
)

Write-Host "Running screenshot tests with Chrome..."

# Check if ChromeDriver is running on port 4444
$chromeDriverRunning = $false
try {
    $connection = Test-NetConnection -ComputerName "127.0.0.1" -Port 4444 -InformationLevel Quiet -WarningAction SilentlyContinue
    $chromeDriverRunning = $connection
} catch {
    $chromeDriverRunning = $false
}

# Start ChromeDriver if not running
if (-not $chromeDriverRunning) {
    Write-Host "Starting ChromeDriver..."
    
    # Check if chromedriver exists
    if (Test-Path "chromedriver-win64\chromedriver.exe") {
        $chromeDriverProcess = Start-Process -FilePath "chromedriver-win64\chromedriver.exe" -ArgumentList "--port=4444" -WindowStyle Hidden -PassThru
        Write-Host "ChromeDriver started with PID: $($chromeDriverProcess.Id)"
        
        # Wait a moment for ChromeDriver to start
        Start-Sleep -Seconds 2
    } else {
        Write-Host "ChromeDriver not found. Please run the setup first."
        exit 1
    }
} else {
    Write-Host "ChromeDriver is already running on port 4444"
}

# Set environment variable for device type
$env:FLEXIFY_DEVICE_TYPE = $deviceType

try {
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
} finally {
    # Optionally stop ChromeDriver if we started it
    # Uncomment the next lines if you want to auto-stop ChromeDriver
    # if ($chromeDriverProcess) {
    #     Stop-Process -Id $chromeDriverProcess.Id -Force
    #     Write-Host "ChromeDriver stopped"
    # }
}
