#!/bin/bash

set -ex

export PUB_SUMMARY_ONLY=true

IFS='+.' read -r major minor patch build_number <<<"$(yq -r .version pubspec.yaml)"
new_patch=$((patch + 1))
new_build_number=$((build_number + 1))
changelog_number=$((new_build_number * 10 + 3))
new_flutter_version="$major.$minor.$new_patch+$new_build_number"
new_version="$major.$minor.$new_patch"
apk=$PWD/build/app/outputs/flutter-apk

IFS='+.' read -r msix_major msix_minor msix_patch msix_zero <<<"$(yq -r .msix_config.msix_version pubspec.yaml)"
new_msix_patch=$((msix_patch + 1))
new_msix_version="$msix_major.$msix_minor.$new_msix_patch.$msix_zero"

changelog_file="fastlane/metadata/android/en-US/changelogs/$changelog_number.txt"
if ! [ -f $changelog_file ]; then
  git --no-pager log --pretty=format:'%s' "$(git describe --tags --abbrev=0)"..HEAD |
    awk '{print "- "$0}' >$changelog_file
fi

nvim "$changelog_file"

if ! [ -f "$changelog_file" ]; then
  echo "No changelog was specified."
  exit 0
fi

changelog=$(cat "$changelog_file")
echo "$changelog" >"$changelog_file"
echo "$changelog" >fastlane/metadata/en-AU/release_notes.txt

if [[ $* == *-t* ]]; then
  echo "Skipping tests..."
else
  flutter test
  dart analyze lib
  dart format --set-exit-if-changed lib
  ./scripts/migrate.sh
  ./scripts/screenshots.sh "phoneScreenshots"
  ./scripts/screenshots.sh "sevenInchScreenshots"
  ./scripts/screenshots.sh "tenInchScreenshots"
fi

yq -yi ".version |= \"$new_flutter_version\"" pubspec.yaml
yq -yi ".msix_config.msix_version |= \"$new_msix_version\"" pubspec.yaml
git add pubspec.yaml
git add fastlane/metadata
git commit -m "$new_version 🚀

$changelog"

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

git push
gh release create "$new_version" --notes "$changelog" \
  "$apk"/app-*-release.apk \
  "$apk/pipeline/linux/x64/release/bundle/$project-linux.zip" \
  "$apk/$project.apk" \
  "$HOME/windows/$project-windows.zip"
git pull

if [[ $* == *-w* ]]; then
  echo "Skipping Windows store..."
else
  ./scripts/msstore.sh "$HOME/windows/$project.msix" || true
fi

if [[ $* == *-p* ]]; then
  echo "Skipping Google play..."
else
  bundle exec fastlane supply --aab \
    build/app/outputs/bundle/release/app-release.aab || true
fi

if [[ $* == *-m* ]]; then
  echo "Skipping MacOS..."
else
  set +x
  # shellcheck disable=SC2029
  ssh macbook "
    set -e
    source .zprofile 
    cd $project 
    git pull 
    security unlock-keychain -p $(pass macbook)
    ./scripts/macos.sh || true
    ./scripts/ios.sh
  "
fi
