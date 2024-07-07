#!/bin/sh

set -ex

migrate() {
  dart run drift_dev schema dump lib/database/database.dart drift_schemas
  dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
  dart run drift_dev schema steps drift_schemas/ lib/database/schema_versions.dart
}

if [ "$1" = "--watch" ] || [ "$1" = "-w" ]; then
  find lib -type f | entr -s "
    dart run drift_dev schema dump lib/database/database.dart drift_schemas
    dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
    dart run drift_dev schema steps drift_schemas/ lib/database/schema_versions.dart
  "
  exit 0
fi

migrate

if [ -n "$(git diff --stat '**schema**' '**migration**')" ]; then
  echo "There are unstaged changes in the repository:"
  git --no-pager diff
  exit 1
fi
