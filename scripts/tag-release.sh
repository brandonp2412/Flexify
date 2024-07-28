#!/bin/bash

IFS='+.' read -r major minor patch build_number <<<"$(yq -r .version pubspec.yaml)"
new_patch=$((patch + 1))
new_build_number=$((build_number + 1))
changelog_number=$((new_build_number * 10 + 3))
new_flutter_version="$major.$minor.$new_patch+$new_build_number"
new_version="$major.$minor.$new_patch"

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

git push
