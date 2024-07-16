#!/bin/bash

set -ex

# Sets the window title
echo -ne "\\033]0;Deploying flexify...\\007"

IFS='+.' read -r major minor patch build_number <<<"$(yq -r .version pubspec.yaml)"
new_patch=$((patch + 1))
new_build_number=$((build_number + 1))
changelog_number=$((new_build_number * 10 + 3))
new_flutter_version="$major.$minor.$new_patch+$new_build_number"
new_version="$major.$minor.$new_patch"

changelog_file="fastlane/metadata/android/en-US/changelogs/$changelog_number.txt"
if ! [ -f $changelog_file ]; then
    git --no-pager log --pretty=format:'%s' "$(git describe --tags --abbrev=0)"..HEAD |
        awk '{print "- "$0}' >$changelog_file
fi

nvim $changelog_file
changelog=$(cat $changelog_file)
echo "$changelog" >fastlane/metadata/en-AU/release_notes.txt

dart analyze lib
dart format --set-exit-if-changed lib
./flutter/bin/flutter test
./scripts/migrate.sh
./scripts/screenshots.sh "phoneScreenshots"
./scripts/screenshots.sh "sevenInchScreenshots"
./scripts/screenshots.sh "tenInchScreenshots"

yq -yi ".version |= \"$new_flutter_version\"" pubspec.yaml
git add pubspec.yaml
git add fastlane/metadata
git commit -m "$new_version 🚀

$changelog"

./flutter/bin/flutter build apk --split-per-abi
./flutter/bin/flutter build apk
./flutter/bin/flutter build linux
apk=build/app/outputs/flutter-apk
(cd $apk/pipeline/linux/x64/release/bundle && zip -r flexify-linux.zip .)
mv $apk/app-release.apk $apk/flexify.apk

git push
gh release create "$new_version" --notes "$changelog" \
    $apk/app-*-release.apk \
    $apk/flexify.apk \
    $apk/pipeline/linux/x64/release/bundle/flexify-linux.zip
git pull --tags

echo q | flutter run --release -d 'pixel 5'

set +x
# shellcheck disable=SC2029
ssh macbook "
  set -e
  source .zprofile
  cd flexify
  git pull
  security unlock-keychain -p $(pass macbook)
  ./scripts/macos.sh || true
  ./scripts/ios.sh
"
