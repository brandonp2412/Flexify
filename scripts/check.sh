#!/usr/bin/env bash
# The single source of truth for "is this app OK": refreshes the akahu
# client, formats, auto-fixes lints, then analyzes and tests. Used by both
# .githooks/pre-push and release.yml's test job, so there's exactly one
# place that defines what passing means.
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

dart run build_runner build

echo "== formatting =="
dart format lib test

echo "== applying auto-fixes =="
dart fix --apply

echo "== analyzing =="
flutter analyze lib test

echo "== testing =="
flutter test
