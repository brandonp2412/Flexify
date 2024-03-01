$pubspecContent = Get-Content "pubspec.yaml" -Raw 

if ($pubspecContent -match 'version: (\d+\.\d+\.\d+)\+(\d+)') {
    $version = $matches[1]
    $buildNumber = [int]$matches[2]
    $newBuildNumber = $buildNumber + 1
    $newVersion = "version: $version+$newBuildNumber"

    $pubspecContent = $pubspecContent -replace 'version: (\d+\.\d+\.\d+)\+(\d+)', $newVersion
    Set-Content -Path "pubspec.yaml" -Value $pubspecContent

    git add "pubspec.yaml"
    git commit -m "Bump build number to $newBuildNumber"

    flutter build appbundle
    cd android
    fastlane supply --aab ..\build\app\outputs\bundle\release\app-release.aab
} else {
    Write-Host "Failed to update version in pubspec.yaml."
}