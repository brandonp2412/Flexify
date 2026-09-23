#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
policy_file="$repo_root/android/signing-policy.properties"

expected=$(
  sed -n 's/^githubReleaseCertificateSha256=//p' "$policy_file" \
    | tr '[:upper:]' '[:lower:]' \
    | tr -cd '0-9a-f'
)

if [[ ${#expected} -ne 64 ]]; then
  echo "Invalid githubReleaseCertificateSha256 in $policy_file" >&2
  exit 2
fi

find_apksigner() {
  if command -v apksigner >/dev/null 2>&1; then
    command -v apksigner
    return
  fi

  local sdk
  for sdk in "${ANDROID_SDK_ROOT:-}" "${ANDROID_HOME:-}" /opt/android-sdk; do
    [[ -n "$sdk" && -d "$sdk/build-tools" ]] || continue
    find "$sdk/build-tools" -mindepth 2 -maxdepth 2 -type f -name apksigner -print \
      | sort -V \
      | tail -n 1
  done | tail -n 1
}

apksigner_bin=$(find_apksigner)
if [[ -z "$apksigner_bin" ]]; then
  echo "Could not find apksigner" >&2
  exit 2
fi

if [[ $# -eq 0 ]]; then
  echo "Usage: $0 <apk> [apk ...]" >&2
  exit 2
fi

for apk in "$@"; do
  [[ -f "$apk" ]] || {
    echo "APK not found: $apk" >&2
    exit 2
  }

  actual=$(
    "$apksigner_bin" verify --print-certs "$apk" \
      | sed -n 's/.*certificate SHA-256 digest: //p' \
      | head -n 1 \
      | tr '[:upper:]' '[:lower:]' \
      | tr -cd '0-9a-f'
  )

  if [[ "$actual" != "$expected" ]]; then
    echo "Wrong signer for $apk" >&2
    echo "  expected: $expected" >&2
    echo "  actual:   ${actual:-<missing>}" >&2
    exit 1
  fi

  echo "Verified release signer: $apk ($actual)"
done
