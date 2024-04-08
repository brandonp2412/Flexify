#!/bin/bash

set -e

pubspec_content=$(cat pubspec.yaml)

function generate_screenshots() {
    devices=$(adb devices | grep emulator)

    while read line
    do
      emulator_id=$(echo $line | awk '{print $1}')
      name=$(adb -s $emulator_id emu avd name | head -n 1) 
      [ "$name" = "$1" ] && break
    done < <(echo $devices)

    export FLEXIFY_DEVICE_TYPE="$1"
    flutter drive --driver=test_driver/integration_test.dart --target=integration_test/screenshot_test.dart --dart-define=FLEXIFY_DEVICE_TYPE="$1" --profile -d "$emulator_id"
}

generate_screenshots "phoneScreenshots"
generate_screenshots "sevenInchScreenshots"
generate_screenshots "tenInchScreenshots"

line=$(yq -r .version pubspec.yaml)
build_number=$(cut -d '+' -f 2 <<< "$line")
version=$(cut -d '+' -f 1 <<< "$line")
major=$(cut -d '.' -f 1 <<< "$version")
minor=$(cut -d '.' -f 2 <<< "$version")
patch=$(cut -d '.' -f 3 <<< "$version")
new_patch=$((patch + 1))
new_build_number=$((build_number + 1))

last_commit=$(git log -1 --pretty=%B | head -n 1)
new_version="$major.$minor.$new_patch+$new_build_number"
yq -yi ".version |= \"$new_version\"" pubspec.yaml

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
gh release create "$new_version" --notes "$last_commit" ../build/app/outputs/flutter-apk/app-release.apk
git push --tags
git push

cd ..