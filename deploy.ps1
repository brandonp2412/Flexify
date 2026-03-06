#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "Starting Flexify local build and version process..." -ForegroundColor Cyan

# Helper functions
function Print-Step($msg)    { Write-Host "=== $msg ===" -ForegroundColor Blue }
function Print-Success($msg) { Write-Host "OK $msg" -ForegroundColor Green }
function Print-Warning($msg) { Write-Host "WARNING $msg" -ForegroundColor Yellow }
function Print-Error($msg)   { Write-Host "ERROR $msg" -ForegroundColor Red }

# Check if yq (mikefarah) is installed
Print-Step "Checking for yq"
$yqCmd = Get-Command yq -ErrorAction SilentlyContinue
if (-not $yqCmd) {
    Print-Step "Installing yq (Go version by mikefarah)"
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id MikeFarah.yq -e --source winget
    } elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        choco install yq -y
    } else {
        Print-Error "Please install yq manually: winget install --id MikeFarah.yq -e"
        exit 1
    }
} else {
    $yqVersion = & yq --version 2>&1
    if ($yqVersion -notmatch "mikefarah") {
        Print-Error "Wrong version of yq detected. This script requires mikefarah's Go version of yq."
        Write-Host "You appear to have the Python version installed."
        Write-Host ""
        Write-Host "Please install the correct version:"
        Write-Host "  winget install --id MikeFarah.yq -e"
        Write-Host ""
        Write-Host "Or rename/remove the existing yq command and run this script again."
        exit 1
    }
}

# Calculate new version
Print-Step "Calculating new version"
$currentVersion = & yq e '.version' pubspec.yaml
# Format: major.minor.patch+build
if ($currentVersion -match '^(\d+)\.(\d+)\.(\d+)\+(\d+)$') {
    $major       = $Matches[1]
    $minor       = $Matches[2]
    $patch       = [int]$Matches[3]
    $buildNumber = [int]$Matches[4]
} else {
    Print-Error "Could not parse version from pubspec.yaml: $currentVersion"
    exit 1
}

$newPatch          = $patch + 1
$newBuildNumber    = $buildNumber + 1
$changelogNumber   = $newBuildNumber * 10 + 3
$newFlutterVersion = "$major.$minor.$newPatch+$newBuildNumber"
$newVersion        = "$major.$minor.$newPatch"

$currentMsixVersion = & yq e '.msix_config.msix_version' pubspec.yaml
if ($currentMsixVersion -match '^(\d+)\.(\d+)\.(\d+)\.(\d+)$') {
    $msixMajor = $Matches[1]
    $msixMinor = $Matches[2]
    $msixPatch = [int]$Matches[3]
    $msixZero  = $Matches[4]
} else {
    Print-Error "Could not parse msix_version from pubspec.yaml: $currentMsixVersion"
    exit 1
}

$newMsixPatch   = $msixPatch + 1
$newMsixVersion = "$msixMajor.$msixMinor.$newMsixPatch.$msixZero"

Write-Host "Current version: $currentVersion"
Write-Host "New version: $newFlutterVersion"
Write-Host "MSIX version: $newMsixVersion"
Write-Host "Changelog number: $changelogNumber"

# Generate changelog
Print-Step "Generating changelog"
$changelogFile = "fastlane/metadata/android/en-US/changelogs/$changelogNumber.txt"

if (Test-Path $changelogFile) {
    Print-Warning "Using existing changelog file: $changelogFile"
    Get-Content $changelogFile
    $changelog = Get-Content $changelogFile -Raw
    New-Item -ItemType Directory -Force -Path "fastlane/metadata/en-AU" | Out-Null
    Set-Content "fastlane/metadata/en-AU/release_notes.txt" $changelog -NoNewline
} else {
    New-Item -ItemType Directory -Force -Path (Split-Path $changelogFile) | Out-Null

    $lastTag = & git describe --tags --abbrev=0 2>$null
    Print-Step "Generating changelog from git commits since $lastTag"

    $commits = & git --no-pager log --pretty=format:'%s' "${lastTag}..HEAD" 2>$null |
        Sort-Object -Unique |
        Where-Object { $_ -notmatch '^Merge ' } |
        Where-Object { $_ -notmatch '^Release ' } |
        Where-Object { $_ -notmatch '^Bump ' } |
        Where-Object { $_ -notmatch '^Update ' } |
        Where-Object { $_ -notmatch '^\d+\.\d+\.\d+' } |
        Select-Object -First 10 |
        ForEach-Object { "• $_" }

    $commits | Set-Content $changelogFile
    $changelog = Get-Content $changelogFile -Raw
    New-Item -ItemType Directory -Force -Path "fastlane/metadata/en-AU" | Out-Null
    Set-Content "fastlane/metadata/en-AU/release_notes.txt" $changelog -NoNewline

    # Open editor
    if (Get-Command nvim -ErrorAction SilentlyContinue) {
        & nvim $changelogFile
    } elseif (Get-Command vim -ErrorAction SilentlyContinue) {
        & vim $changelogFile
    } else {
        Start-Process notepad -ArgumentList $changelogFile -Wait
    }
}

# Setup Flutter
Print-Step "Setting up Flutter from submodule"
if (-not (Test-Path "flutter")) {
    Print-Warning "Flutter submodule not found, initializing..."
    & git submodule update --init --recursive flutter
} else {
    & git submodule update --recursive flutter
}

$env:PATH = "$PWD\flutter\bin;$env:PATH"

# Run tests and analysis
Print-Step "Running tests and analysis"
& flutter test
Print-Success "Tests passed"

& dart analyze lib
Print-Success "Analysis passed"

& dart format --set-exit-if-changed lib
Print-Success "Code formatting verified"

# Update versions in pubspec.yaml
Print-Step "Updating versions in pubspec.yaml"
& yq e ".version |= `"$newFlutterVersion`"" -i pubspec.yaml
& yq e ".msix_config.msix_version |= `"$newMsixVersion`"" -i pubspec.yaml
Print-Success "Updated pubspec.yaml versions"

# Copy changelogs with timestamps
Print-Step "Copying changelogs with timestamps"
New-Item -ItemType Directory -Force -Path "assets/changelogs" | Out-Null

Get-ChildItem "fastlane/metadata/android/en-US/changelogs/*.txt" -ErrorAction SilentlyContinue | ForEach-Object {
    $file = $_
    $timestamp = [int][double]::Parse(
        (Get-Date $file.CreationTimeUtc -UFormat %s)
    )
    if ($timestamp -eq 0) {
        $timestamp = [int][double]::Parse(
            (Get-Date $file.LastWriteTimeUtc -UFormat %s)
        )
    }
    $targetFile = "assets/changelogs/$timestamp.txt"
    Copy-Item $file.FullName $targetFile
}

# Check if Android emulator is available
Print-Step "Checking for Android emulator"
$androidAvailable = $false
if (Get-Command flutter -ErrorAction SilentlyContinue) {
    Write-Host "Flutter found, checking Android setup..."
    $doctorOutput = & flutter doctor 2>&1 | Out-String
    if ($doctorOutput -match "Android toolchain" -and $doctorOutput -notmatch "\[!\].*Android toolchain") {
        Write-Host "Android toolchain appears to be configured"
        $androidAvailable = $true
    } else {
        Write-Host "Android toolchain not properly configured"
    }
} else {
    Write-Host "Flutter not found in PATH"
}

function Generate-Screenshots($avdName) {
    Print-Step "Generating screenshots for AVD '$avdName'"

    if (-not (Get-Command emulator -ErrorAction SilentlyContinue)) {
        Print-Warning "emulator command not found"
        return $false
    }

    $avdList = & emulator -list-avds 2>$null
    if ($avdList -notcontains $avdName) {
        Print-Warning "AVD '$avdName' not found"
        Write-Host "Available AVDs:"
        $avdList | ForEach-Object { Write-Host "  $_" }
        return $false
    }

    Print-Step "Starting emulator '$avdName'"
    $emulatorProc = Start-Process emulator -ArgumentList "-avd $avdName -no-window -gpu swiftshader_indirect -noaudio -no-boot-anim -camera-back none" -PassThru

    Write-Host "Waiting for emulator to boot..."
    $timeout = 300
    $elapsed = 0
    $emulatorId = ""

    while ($elapsed -lt $timeout) {
        $devices = & adb devices 2>$null | Select-String "emulator-" | Where-Object { $_ -match "device$" }
        if ($devices) {
            $emulatorId = ($devices[0] -split '\s+')[0]
            Print-Success "Emulator '$avdName' booted with ID: $emulatorId"
            break
        }

        if ($emulatorProc.HasExited) {
            Print-Error "Emulator process died during startup"
            exit 1
        }

        Start-Sleep 5
        $elapsed += 5
        Write-Host "Waiting... ($elapsed/${timeout}s)"
    }

    if (-not $emulatorId) {
        Print-Error "Emulator '$avdName' failed to boot within timeout"
        Stop-Process -Id $emulatorProc.Id -ErrorAction SilentlyContinue
        exit 1
    }

    Start-Sleep 15

    $currentDevices = & adb devices 2>$null | Out-String
    if ($currentDevices -notmatch "$emulatorId.*device") {
        Print-Error "Emulator $emulatorId disappeared"
        Stop-Process -Id $emulatorProc.Id -ErrorAction SilentlyContinue
        exit 1
    }

    Print-Step "Running screenshot tests on $emulatorId for device type '$avdName'"
    $env:FLEXIFY_DEVICE_TYPE = $avdName

    & flutter drive --profile --driver=test_driver/integration_test.dart `
        "--dart-define=FLEXIFY_DEVICE_TYPE=$avdName" `
        --target=integration_test/screenshot_test.dart -d $emulatorId

    if ($LASTEXITCODE -eq 0) {
        Print-Success "Screenshots generated successfully for '$avdName'"
    } else {
        Print-Error "Screenshot generation failed for '$avdName'"
        & adb -s $emulatorId emu kill 2>$null
        Stop-Process -Id $emulatorProc.Id -ErrorAction SilentlyContinue
        exit 1
    }

    Print-Step "Stopping emulator '$avdName'"
    & adb -s $emulatorId emu kill 2>$null
    Stop-Process -Id $emulatorProc.Id -ErrorAction SilentlyContinue
    Start-Sleep 5
    Print-Success "Emulator '$avdName' stopped"
}

if ($args -contains "-n") {
    Print-Warning "Skipping screenshots"
} elseif ($androidAvailable) {
    Generate-Screenshots "phoneScreenshots"
    Generate-Screenshots "sevenInchScreenshots"
    Generate-Screenshots "tenInchScreenshots"
} else {
    Print-Warning "Android SDK not properly configured. Skipping screenshot generation."
    Write-Host "Make sure Android SDK and emulator tools are in your PATH"
}

# Commit changes and create tag
Print-Step "Committing version bump and creating tag"
$diffOutput = & git diff HEAD -- pubspec.yaml fastlane/metadata pubspec.lock assets 2>&1
if ($diffOutput) {
    & git add pubspec.yaml fastlane/metadata pubspec.lock assets
    & git commit -m "Release $newVersion"
    Print-Success "Committed version bump"

    & git tag $newVersion
    Print-Success "Created tag: $newVersion"

    Write-Host ""
    Print-Step "Next steps:"
    Write-Host "1. Push changes: git push origin main"
    Write-Host "2. Push tag: git push origin $newVersion"
    Write-Host "3. The GitHub Action will handle deployment automatically"
    Write-Host ""
    Print-Success "Local build process completed successfully!"
    Write-Host "Version: $newVersion"
    Write-Host "Tag: $newVersion"
} else {
    Print-Warning "No changes detected in tracked files"
}

# Build locally
Print-Step "Building locally"
Write-Host "Building for Windows..."
& flutter build windows
Print-Success "Windows build completed"

Write-Host "Building for Web..."
& flutter config --enable-web
& flutter build web --release
Print-Success "Web build completed"

Write-Host ""
Print-Success "All done!"
& git pull origin main
& git push
& git push origin $newVersion
