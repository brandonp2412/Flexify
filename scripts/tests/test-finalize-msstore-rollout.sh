#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
test_dir="$(mktemp -d)"
trap 'rm -rf "$test_dir"' EXIT

cp "$repo_root/scripts/tests/fake-msstore" "$test_dir/msstore"
chmod +x "$test_dir/msstore"

run_case() {
  local scenario="$1"
  local expected_exit="$2"
  local expected_finalize_calls="$3"
  local calls_file="$test_dir/$scenario.calls"

  : > "$calls_file"

  set +e
  PATH="$test_dir:$PATH" \
    MSSTORE_CALLS="$calls_file" \
    MSSTORE_SCENARIO="$scenario" \
    pwsh -NoProfile -File "$repo_root/scripts/finalize-msstore-rollout.ps1" -ProductId TEST-PRODUCT
  local actual_exit=$?
  set -e

  [[ "$actual_exit" -eq "$expected_exit" ]] || {
    printf '%s: expected exit %s, got %s\n' "$scenario" "$expected_exit" "$actual_exit" >&2
    return 1
  }
  local actual_finalize_calls
  actual_finalize_calls="$(grep -c '^submission rollout finalize ' "$calls_file" || true)"
  [[ "$actual_finalize_calls" -eq "$expected_finalize_calls" ]] || {
    printf '%s: expected %s finalize calls, got %s\n' \
      "$scenario" "$expected_finalize_calls" "$actual_finalize_calls" >&2
    return 1
  }

  grep -q '^apps get TEST-PRODUCT ' "$calls_file" || {
    printf '%s: application details were not retrieved\n' "$scenario" >&2
    return 1
  }
}

run_case get-failure 1 0
run_case pending 0 0
run_case ready 0 1
run_case inactive 0 0
run_case complete 0 0
run_case finalize-failure 1 1

printf 'All finalizer behavior tests passed.\n'
