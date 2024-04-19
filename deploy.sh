#!/bin/bash

set -ex

./screenshots.sh "phoneScreenshots" &
phonePid=$!
./screenshots.sh "sevenInchScreenshots" &
sevenPid=$!
./screenshots.sh "tenInchScreenshots" &
tenPid=$!

wait $phonePid $sevenPid $tenPid

line=$(yq -r .version pubspec.yaml)
build_number=$(cut -d '+' -f 2 <<< "$line")
version=$(cut -d '+' -f 1 <<< "$line")
major=$(cut -d '.' -f 1 <<< "$version")
minor=$(cut -d '.' -f 2 <<< "$version")
patch=$(cut -d '.' -f 3 <<< "$version")
new_patch=$((patch + 1))
new_build_number=$((build_number + 1))

changelog="$1"
last_commit=$(git log -1 --pretty=%B | head -n 1)
new_flutter_version="$major.$minor.$new_patch+$new_build_number"
new_version="$major.$minor.$new_patch"
yq -yi ".version |= \"$new_flutter_version\"" pubspec.yaml

flutter build apk --split-per-abi || (git restore pubspec.yaml fastlane/metadata && exit 1)
flutter build appbundle || (git restore pubspec.yaml fastlane/metadata && exit 1)

git add pubspec.yaml
echo "${changelog:-$last_commit}" > "fastlane/metadata/android/en-US/changelogs/$new_build_number.txt"
git add fastlane/metadata
git commit -m "Bump version to $new_version"
git tag "$new_build_number"

gh release create "$new_version" --notes "${changelog:-$last_commit}"  \
  build/app/outputs/flutter-apk/app-*-release.apk

fastlane supply --aab build/app/outputs/bundle/release/app-release.aab
git push --tags
git push
