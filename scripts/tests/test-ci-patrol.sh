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
  case ${PATROL_TEST_MODE:-selector} in
    timeout)
      sleep 2
      exit 1
      ;;
    picker)
      echo "Bad state: Android document picker did not appear within 0:00:15.000000"
      ;;
    selector)
      echo "waitUntilVisible() failed with Invalid response: 404 selector"
      ;;
  esac

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
if PATH="$test_root/bin:$PATH" \
  PATROL_TEST_ATTEMPT_FILE="$attempt_file" \
  "$repo_root/scripts/ci-patrol.sh"; then
  echo "Expected a native selector failure to fail without a retry." >&2
  exit 1
fi

if [[ $(<"$attempt_file") -ne 1 ]]; then
  echo "Expected a native selector failure to run only once." >&2
  exit 1
fi

rm -f "$attempt_file"
PATH="$test_root/bin:$PATH" \
  PATROL_TEST_ATTEMPT_FILE="$attempt_file" \
  PATROL_TEST_MODE=picker \
  "$repo_root/scripts/ci-patrol.sh"

if [[ $(<"$attempt_file") -ne 2 ]]; then
  echo "Expected Patrol to retry once when Android's document picker does not appear." >&2
  exit 1
fi

rm -f "$attempt_file"
PATH="$test_root/bin:$PATH" \
  PATROL_TEST_ATTEMPT_FILE="$attempt_file" \
  PATROL_TEST_MODE=timeout \
  PATROL_TIMEOUT=0.1s \
  "$repo_root/scripts/ci-patrol.sh"

if [[ $(<"$attempt_file") -ne 2 ]]; then
  echo "Expected Patrol to retry once after a timeout." >&2
  exit 1
fi
