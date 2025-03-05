#!/bin/bash

set -ex

apk=$PWD/build/app/outputs/flutter-apk

./flutter/bin/flutter build apk --split-per-abi
adb -d install "$apk"/app-arm64-v8a-release.apk || true
./flutter/bin/flutter build apk
mv -f "$apk"/app-release.apk "$apk/flexify.apk"
./flutter/bin/flutter build appbundle

./flutter/bin/flutter build linux
(cd "$apk/pipeline/linux/x64/release/bundle" && zip --quiet -r "flexify-linux.zip" .)

docker start windows
rsync -a --delete --exclude-from=.gitignore ./* .gitignore \
  "$HOME/windows/flexify-source"
while ! ssh windows exit; do sleep 1; done
ssh windows "Powershell -ExecutionPolicy bypass -File //host.lan/Data/build-flexify.ps1"
sudo chown -R "$USER" "$HOME/windows/flexify"
mv -f "$HOME/windows/flexify/flexify.msix" "$HOME/windows/flexify.msix"
(cd "$HOME/windows/flexify" && zip --quiet -r "$HOME/windows/flexify-windows.zip" .)
docker stop windows

git add pubspec.lock
git commit -m 'Update pubspec.lock from windows build'

IFS='+.' read -r major minor patch build_number <<<"$(yq -r .version pubspec.yaml)"
changelog_number=$((build_number * 10 + 3))
changelog=$(cat fastlane/metadata/android/en-US/changelogs/$changelog_number.txt)

gh release create "$major.$minor.$patch" --notes "$changelog" \
  "$apk"/app-*-release.apk \
  "$apk/pipeline/linux/x64/release/bundle/flexify-linux.zip" \
  "$apk/flexify.apk" \
  "$HOME/windows/flexify-windows.zip"
git pull origin HEAD
