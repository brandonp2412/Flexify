param (
    [switch]$n
)

$pubspecContent = Get-Content "pubspec.yaml" -Raw 

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
}
else {
    Write-Host "Failed to update version in pubspec.yaml."
}