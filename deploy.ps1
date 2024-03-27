param (
    [switch]$n
)

$pubspecContent = Get-Content "pubspec.yaml" -Raw 

Function GenerateScreenshots{
  param ($deviceType)
  flutter emulator --launch $deviceType
  
  $adbName 
  while ([string]::IsNullOrEmpty($adbName))
  {
    $devices = adb.exe devices
    $devices | select -skip 1 | ForEach {
        "$_".Split(" ") | ForEach {
            $name = adb.exe -s $_ emu avd name
            if ($name -eq $deviceType) {
                if ($_.Contains("offline") -or $_.Contains("authorizing")) {
                    Write-Output "Device is offline"
                } else {
                    $adbName = $_.Replace("device", "").Trim()
                }
            }
        }
    }

    Write-Output "Device not started, trying again in 10 seconds"
    Start-Sleep -Seconds 10
  }

  # Sleep 30 seconds to allow time for emulator to finish boot properly
  Start-Sleep -Seconds 30

  $env:FLEXIFY_DEVICE_TYPE="$deviceType"
  flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_test.dart --dart-define=FLEXIFY_DEVICE_TYPE=$deviceType --profile -d $adbName

  Write-Output "Shutting down $deviceType"
  adb.exe -s $adbName reboot -p
}

if ($pubspecContent -match 'version: (\d+\.\d+\.\d+)\+(\d+)') {
    $versionParts = $matches[1] -split '\.'
    $buildNumber = [int]$matches[2]

    $minorVersion = [int]$versionParts[2] + 1
    $newBuildNumber = $buildNumber + 1

    $flutterVersion = "$($versionParts[0]).$($versionParts[1]).$minorVersion+$newBuildNumber"
    $version = "$($versionParts[0]).$($versionParts[1]).$minorVersion"
    $lastCommit = git log -1 --pretty=%B | Select-Object -First 1

    $pubspecContent = $pubspecContent -replace 'version: (\d+\.\d+\.\d+)\+(\d+)', "version: $flutterVersion"
    Set-Content -Path "pubspec.yaml" -Value $pubspecContent

    GenerateScreenshots "phoneScreenshots"
    GenerateScreenshots "sevenInchScreenshots"
    GenerateScreenshots "tenInchScreenshots"

    git add "pubspec.yaml"
    Set-Content -Path "android\fastlane\metadata\android\en-US\changelogs\$newBuildNumber.txt" -Value "$lastCommit"
    git add "android\fastlane\metadata\android\en-US\changelogs\$newBuildNumber.txt"
    git commit -m "Bump version to $version"
    git tag "$newBuildNumber"

    Set-Location android

    if (!$n) {
        flutter build appbundle
        fastlane supply --skip-upload_screenshots true --skip-upload-images true --aab ..\build\app\outputs\bundle\release\app-release.aab
    }

    flutter build apk
    gh release create "$version" --notes "$lastCommit" ..\build\app\outputs\flutter-apk\app-release.apk
    git push --tags
    git push
    
    Set-Location ..
}
else {
    Write-Host "Failed to update version in pubspec.yaml."
}

