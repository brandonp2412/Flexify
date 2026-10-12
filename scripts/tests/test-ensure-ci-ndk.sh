#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../.." && pwd)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

sdk_root="$tmp/android-sdk"
sdkmanager="$sdk_root/cmdline-tools/latest/bin/sdkmanager"
mkdir -p "$(dirname "$sdkmanager")"

cat > "$sdkmanager" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
count_file="$ANDROID_SDK_ROOT/count"
count=0
[[ ! -f "$count_file" ]] || count="$(<"$count_file")"
count=$((count + 1))
printf '%s' "$count" > "$count_file"
[[ "$*" == *"ndk;28.2.13676358"* ]]
if [[ "$count" -eq 1 ]]; then
  mkdir -p "$ANDROID_SDK_ROOT/ndk/28.2.13676358"
  printf 'broken' > "$ANDROID_SDK_ROOT/ndk/28.2.13676358/partial.zip"
  exit 1
fi
[[ ! -e "$ANDROID_SDK_ROOT/ndk/28.2.13676358/partial.zip" ]]
mkdir -p "$ANDROID_SDK_ROOT/ndk/28.2.13676358"
printf 'Pkg.Revision = 28.2.13676358\n' > "$ANDROID_SDK_ROOT/ndk/28.2.13676358/source.properties"
SH
chmod +x "$sdkmanager"

export ANDROID_SDK_ROOT="$sdk_root"
bash "$repo_root/scripts/ensure-ci-ndk.sh" 28.2.13676358
[[ "$(<"$sdk_root/count")" == 2 ]]
bash "$repo_root/scripts/ensure-ci-ndk.sh" 28.2.13676358
[[ "$(<"$sdk_root/count")" == 2 ]]

echo 'Pinned NDK recovery and verification tests passed'
