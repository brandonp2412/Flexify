#!/usr/bin/env bash

set -euo pipefail

version="${1:?Expected pinned Android NDK version}"
sdk_root="${ANDROID_SDK_ROOT:-${ANDROID_HOME:?ANDROID_HOME or ANDROID_SDK_ROOT must be set}}"
sdkmanager="$sdk_root/cmdline-tools/latest/bin/sdkmanager"
ndk_dir="$sdk_root/ndk/$version"

ndk_installed() {
  [[ -f "$ndk_dir/source.properties" ]] &&
    grep -Fxq "Pkg.Revision = $version" "$ndk_dir/source.properties"
}

if ndk_installed; then
  echo "Android NDK $version is already installed"
  exit 0
fi

for attempt in 1 2 3; do
  echo "Installing Android NDK $version (attempt $attempt/3)"
  if "$sdkmanager" --sdk_root="$sdk_root" --install "ndk;$version" && ndk_installed; then
    echo "Verified Android NDK $version"
    exit 0
  fi

  echo "Android NDK $version download or validation failed (attempt $attempt/3)" >&2
  # A truncated ZIP can leave a partial NDK which Gradle attempts to reuse.
  rm -rf -- "$ndk_dir"
done

echo "Unable to install and verify Android NDK $version after 3 attempts" >&2
exit 1
