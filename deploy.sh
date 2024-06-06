#!/bin/bash

set -ex

./flutter/bin/flutter test

dart run drift_dev schema dump lib/database/database.dart drift_schemas
dart run drift_dev schema steps drift_schemas/ lib/database/schema_versions.dart
dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
if [[ -n "$(git diff --stat)" ]]; then
    echo "There are unstaged changes in the repository:"
    git --no-pager diff
    exit 1
fi

./screenshots.sh "phoneScreenshots"
./screenshots.sh "sevenInchScreenshots"
./screenshots.sh "tenInchScreenshots"

line=$(yq -r .version pubspec.yaml)
build_number=$(cut -d '+' -f 2 <<< "$line")
version=$(cut -d '+' -f 1 <<< "$line")
major=$(cut -d '.' -f 1 <<< "$version")
minor=$(cut -d '.' -f 2 <<< "$version")
patch=$(cut -d '.' -f 3 <<< "$version")
new_patch=$((patch + 1))
new_build_number=$((build_number + 1))

new_flutter_version="$major.$minor.$new_patch+$new_build_number"
new_version="$major.$minor.$new_patch"
yq -yi ".version |= \"$new_flutter_version\"" pubspec.yaml
rest=$(git log -1 --pretty=%B | tail -n +2)
git add pubspec.yaml
last_commits=$(git log --pretty=format:"%s" @{u}..HEAD | awk '{print "- "$0}')
changelog_number=$((new_build_number * 10 + 3))
echo "$last_commits" > "fastlane/metadata/android/en-US/changelogs/$changelog_number.txt"
git add fastlane/metadata

if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
    echo "There are unstaged changes in the repository:"
    git --no-pager diff
    git restore --staged pubspec.yaml fastlane/metadata
    git restore pubspec.yaml fastlane/metadata
    rm "fastlane/metadata/android/en-US/changelogs/$changelog_number.txt"
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

gh release create "$new_version" --notes "$last_commits"  \
  $apk/app-*-release.apk \
  $apk/flexify.apk \
  $apk/pipeline/linux/x64/release/bundle/flexify-linux.zip \
  fastlane/metadata/android/en-US/images/phoneScreenshots/*.png
git pull --tags

echo q | flutter run --release -d 'pixel 5'
