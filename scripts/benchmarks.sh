#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
for benchmark in integration_test/benchmarks/*_test.dart; do
  flutter test -d linux "$benchmark" "$@"
done
