#!/usr/bin/env bash
set -euo pipefail

version=$(sed -n 's/^version: *//p' pubspec.yaml)
build_number=${version##*+}
out="dist/fastforge-pilot/$version"
fastforge_apk="$out/flexify-$version-android.apk"
fastforge_aab="$out/flexify-$version-android.aab"
test -s "$fastforge_apk"
test -s "$fastforge_aab"

# Verify Fastforge does not alter the Flutter-generated universal package.
flutter/bin/flutter build apk --release
cmp "$fastforge_apk" build/app/outputs/flutter-apk/app-release.apk

# F-Droid's upstream build recipe uses precisely these three commands.
flutter/bin/flutter build apk --release --split-per-abi --target-platform android-x64
flutter/bin/flutter build apk --release --split-per-abi --target-platform android-arm
flutter/bin/flutter build apk --release --split-per-abi --target-platform android-arm64

package_id=$(sed -n 's/^productionApplicationId=//p' android/signing-policy.properties)
aapt=$(find "${ANDROID_HOME:?ANDROID_HOME missing}/build-tools" -mindepth 2 -maxdepth 2 -type f -name aapt | sort -V | tail -n 1)
test -x "$aapt"

for entry in 'x86_64:1' 'armeabi-v7a:2' 'arm64-v8a:3'; do
  abi=${entry%:*}
  suffix=${entry#*:}
  apk="build/app/outputs/flutter-apk/app-$abi-release.apk"
  test -s "$apk"
  metadata=$("$aapt" dump badging "$apk" | head -n 1)
  expected_code=$((10#$build_number * 100 + suffix))
  [[ "$metadata" == *"name='$package_id'"* ]] || { echo "Unexpected app ID: $metadata" >&2; exit 1; }
  [[ "$metadata" == *"versionCode='$expected_code'"* ]] || { echo "Unexpected F-Droid version code: $metadata" >&2; exit 1; }
  cp "$apk" "$out/"
done

./scripts/verify-android-release-signing.sh "$fastforge_apk" "$out"/app-*-release.apk
sha256sum "$fastforge_apk" "$fastforge_aab" "$out"/app-*-release.apk
printf 'Fastforge APK matches Flutter APK; F-Droid ABI/version/signing checks passed.\n'
