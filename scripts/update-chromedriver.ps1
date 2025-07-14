param(
    [string]$chromeVersion = ""
)

Write-Host "ChromeDriver Update Script"
Write-Host "========================="

# Get Chrome version if not provided
if ([string]::IsNullOrEmpty($chromeVersion)) {
    try {
        $chromeExePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
        if (Test-Path $chromeExePath) {
            $chromeVersionOutput = & $chromeExePath --version 2>$null
            if ($chromeVersionOutput -match "(\d+\.\d+\.\d+\.\d+)") {
                $chromeVersion = $matches[1]
                Write-Host "Detected Chrome version: $chromeVersion"
            }
        }
    } catch {
        Write-Host "Could not detect Chrome version automatically."
    }
}

if ([string]::IsNullOrEmpty($chromeVersion)) {
    Write-Host "Please provide Chrome version as parameter: .\update-chromedriver.ps1 -chromeVersion '138.0.7204.101'"
    exit 1
}

# Check current ChromeDriver version
$currentVersion = ""
if (Test-Path "chromedriver-win64\chromedriver.exe") {
    try {
        $versionOutput = & "chromedriver-win64\chromedriver.exe" --version 2>$null
        if ($versionOutput -match "ChromeDriver (\d+\.\d+\.\d+\.\d+)") {
            $currentVersion = $matches[1]
            Write-Host "Current ChromeDriver version: $currentVersion"
        }
    } catch {
        Write-Host "Could not get current ChromeDriver version."
    }
}

# Check if update is needed
if ($currentVersion -eq $chromeVersion) {
    Write-Host "ChromeDriver is already up to date!"
    exit 0
}

Write-Host "Updating ChromeDriver from $currentVersion to $chromeVersion..."

# Stop any running ChromeDriver processes
try {
    Get-Process -Name "chromedriver" -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "Stopped existing ChromeDriver processes."
} catch {
    # No processes to stop
}

# Download new ChromeDriver
$downloadUrl = "https://storage.googleapis.com/chrome-for-testing-public/$chromeVersion/win64/chromedriver-win64.zip"
$zipFile = "chromedriver-$chromeVersion.zip"

Write-Host "Downloading ChromeDriver $chromeVersion..."
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipFile
    Write-Host "Download completed."
} catch {
    Write-Host "Failed to download ChromeDriver. Please check if version $chromeVersion is available."
    exit 1
}

# Extract and replace
Write-Host "Extracting and installing..."
try {
    # Create temp directory
    $tempDir = "temp-chromedriver"
    if (Test-Path $tempDir) {
        Remove-Item -Recurse -Force $tempDir
    }
    New-Item -ItemType Directory -Path $tempDir | Out-Null
    
    # Extract
    Expand-Archive -Path $zipFile -DestinationPath $tempDir -Force
    
    # Copy new ChromeDriver
    Copy-Item "$tempDir\chromedriver-win64\chromedriver.exe" "chromedriver-win64\chromedriver.exe" -Force
    
    # Cleanup
    Remove-Item -Recurse -Force $tempDir
    Remove-Item $zipFile
    
    Write-Host "ChromeDriver updated successfully!"
    
    # Verify new version
    $newVersionOutput = & "chromedriver-win64\chromedriver.exe" --version 2>$null
    Write-Host "New version: $newVersionOutput"
    
} catch {
    Write-Host "Failed to extract and install ChromeDriver: $_"
    exit 1
}

Write-Host "Update completed successfully!"
