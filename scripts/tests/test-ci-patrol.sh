#!/usr/bin/env bash

set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
test_root=$(mktemp -d)
trap 'rm -rf "$test_root"' EXIT

mkdir -p "$test_root/bin"
cat >"$test_root/bin/patrol" <<'EOF'
#!/usr/bin/env bash
attempt_file=${PATROL_TEST_ATTEMPT_FILE:?}
attempt=0
if [[ -f $attempt_file ]]; then
  attempt=$(<"$attempt_file")
fi
attempt=$((attempt + 1))
printf '%s\n' "$attempt" >"$attempt_file"

if [[ $attempt -eq 1 ]]; then
  echo "waitUntilVisible() failed with Invalid response: 404 selector"
  echo "Total: 1"
  echo "Successful: 0"
  echo "Failed: 1"
  exit 1
fi

echo "Total: 1"
echo "Successful: 1"
echo "Failed: 0"
EOF
chmod +x "$test_root/bin/patrol"

attempt_file="$test_root/attempt"
PATH="$test_root/bin:$PATH" \
  PATROL_TEST_ATTEMPT_FILE="$attempt_file" \
  "$repo_root/scripts/ci-patrol.sh"

if [[ $(<"$attempt_file") -ne 2 ]]; then
  echo "Expected Patrol to retry once after a transient test failure." >&2
  exit 1
fi
