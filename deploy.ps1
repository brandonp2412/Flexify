$pubspecContent = Get-Content "pubspec.yaml" -Raw 

if ($pubspecContent -match 'version: (\d+\.\d+\.\d+)\+(\d+)') {
    $version = $matches[1]
    $buildNumber = [int]$matches[2]
    $newBuildNumber = $buildNumber + 1
    $newVersion = "version: $version+$newBuildNumber"
    $lastCommit = git log -1 --pretty=%B

    $pubspecContent = $pubspecContent -replace 'version: (\d+\.\d+\.\d+)\+(\d+)', $newVersion
    Set-Content -Path "pubspec.yaml" -Value $pubspecContent

    git add "pubspec.yaml"
    git commit -m "Bump build number to $newBuildNumber"

    flutter build appbundle
    cd android
    fastlane supply --skip-upload_screenshots true --skip-upload-images true --aab ..\build\app\outputs\bundle\release\app-release.aab
    git push

    flutter build apk
    gh release create "$version" --notes "$lastCommit" ..\build\app\outputs\flutter-apk\app-release.apk
} else {
    Write-Host "Failed to update version in pubspec.yaml."
}