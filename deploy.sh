#!/bin/bash

set -ex

pubspec_content=$(cat pubspec.yaml)

function generate_screenshots() {
    device_type=$1
    export FLEXIFY_DEVICE_TYPE="$device_type"
    flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_test.dart --dart-define=FLEXIFY_DEVICE_TYPE="$device_type" --profile -d "$device_type"
}

line=$(yq -r .version pubspec.yaml)
build_number=$(cut -d '+' -f 2 <<< "$line")
version=$(cut -d '+' -f 1 <<< "$line")
major=$(cut -d '.' -f 1 <<< "$version")
minor=$(cut -d '.' -f 2 <<< "$version")
patch=$(cut -d '.' -f 3 <<< "$version")
new_patch=$((patch + 1))
new_build_number=$((build_number + 1))

last_commit=$(git log -1 --pretty=%B | head -n 1)
yq -yi ".version |= \"$major.$minor.$new_patch+$new_build_number\"" pubspec.yaml
generate_screenshots "phoneScreenshots"

git add pubspec.yaml
git add android/fastlane/metadata

echo "$last_commit" > "android/fastlane/metadata/android/en-US/changelogs/$new_build_number.txt"
git add "android/fastlane/metadata/android/en-US/changelogs/$new_build_number.txt"
git commit -m "Bump version to $version"
git tag "$new_build_number"

cd android

flutter build appbundle
fastlane supply --aab ../build/app/outputs/bundle/release/app-release.aab
flutter build apk
gh release create "$version" --notes "$last_commit" ../build/app/outputs/flutter-apk/app-release.apk
git push --tags
git push

cd ..