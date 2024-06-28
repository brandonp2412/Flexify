#!/bin/bash

set -ex

line=$(yq -r .version pubspec.yaml)
build_number=$(cut -d '+' -f 2 <<< "$line")
version=$(cut -d '+' -f 1 <<< "$line")
major=$(cut -d '.' -f 1 <<< "$version")
minor=$(cut -d '.' -f 2 <<< "$version")
patch=$(cut -d '.' -f 3 <<< "$version")
new_patch=$((patch + 1))
new_build_number=$((build_number + 1))
changelog_number=$((new_build_number * 10 + 3))

nvim "fastlane/metadata/android/en-AU/changelogs/$changelog_number.txt"
changelog=$(cat "fastlane/metadata/android/en-AU/changelogs/$changelog_number.txt")
echo "$changelog" > fastlane/metadata/en-AU/release_notes.txt

./flutter/bin/flutter test
./migrate.sh
./screenshots.sh "phoneScreenshots"
./screenshots.sh "sevenInchScreenshots"
./screenshots.sh "tenInchScreenshots"

new_flutter_version="$major.$minor.$new_patch+$new_build_number"
new_version="$major.$minor.$new_patch"
yq -yi ".version |= \"$new_flutter_version\"" pubspec.yaml
rest=$(git log -1 --pretty=%B | tail -n +2)
git add pubspec.yaml
git add fastlane/metadata

if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    echo "There are unstaged changes in the repository:"
    git --no-pager diff
    exit 1
fi

./flutter/bin/flutter build apk --split-per-abi
./flutter/bin/flutter build apk
apk=build/app/outputs/flutter-apk
(cd $apk/pipeline/linux/x64/release/bundle && zip -r flexify-linux.zip .)
mv $apk/app-release.apk $apk/flexify.apk

last_commit=$(git log -1 --pretty=%B | head -n 1)
git commit --amend -m "$last_commit - $new_version 🚀 
$rest"
git push

gh release create "$new_version" --notes "$changelog"  \
  $apk/app-*-release.apk \
  $apk/flexify.apk \
  $apk/pipeline/linux/x64/release/bundle/flexify-linux.zip
git pull --tags

echo q | flutter run --release -d 'pixel 5'

set +x
ssh macbook "
  set -e
  source .zprofile 
  cd flexify 
  git pull 
  security unlock-keychain -p $(pass macbook)
  ./macos.sh || true
  ./ios.sh
"
