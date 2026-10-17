#!/usr/bin/env bash
# Shared quality check used by CI: generate code, format, fix, analyze, and test.
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

# A clean CI checkout has no package configuration. Running build_runner via
# `dart` cannot resolve Flutter SDK dependencies on its own.
flutter pub get
dart run build_runner build

echo "== formatting =="
dart format lib test integration_test

echo "== applying auto-fixes =="
dart fix --apply

echo "== analyzing =="
flutter analyze

echo "== testing =="
flutter test
