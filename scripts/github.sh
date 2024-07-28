#!/bin/bash

apk=$PWD/build/app/outputs/flutter-apk

flutter build apk --split-per-abi
adb -d install "$apk"/app-arm64-v8a-release.apk || true
flutter build apk
project=$(basename "$PWD")
mv -f "$apk"/app-release.apk "$apk/$project.apk"
flutter build appbundle

mkdir -p build/native_assets/linux
flutter build linux
(cd "$apk/pipeline/linux/x64/release/bundle" && zip --quiet -r "$project-linux.zip" .)

docker start windows
rsync -a --delete --exclude-from=.gitignore ./* .gitignore \
  "$HOME/windows/$project-source"
while ! ssh windows exit; do sleep 1; done
ssh windows "Powershell -ExecutionPolicy bypass -File //host.lan/Data/build-flexify.ps1"
sudo chown -R "$USER" "$HOME/windows/$project"
mv -f "$HOME/windows/$project/$project.msix" "$HOME/windows/$project.msix"
(cd "$HOME/windows/$project" && zip --quiet -r "$HOME/windows/$project-windows.zip" .)
docker stop windows

IFS='+.' read -r major minor patch build_number <<<"$(yq -r .version pubspec.yaml)"
changelog_number=$((build_number * 10 + 3))
changelog=$(cat fastlane/metadata/android/en-US/changelogs/$changelog_number.txt)

gh release create "$major.$minor.$patch" --notes "$changelog" \
  "$apk"/app-*-release.apk \
  "$apk/pipeline/linux/x64/release/bundle/$project-linux.zip" \
  "$apk/$project.apk" \
  "$HOME/windows/$project-windows.zip"
git pull
