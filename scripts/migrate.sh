#!/bin/bash

set -ex

database=lib/database/database.dart

dart run --verbosity=error build_runner build -d
dart run --verbosity=error drift_dev schema dump $database drift_schemas
dart run --verbosity=error drift_dev schema generate drift_schemas/ test/generated_migrations/
dart run --verbosity=error drift_dev schema steps drift_schemas/ lib/database/schema_versions.dart

if [ -n "$(git diff --stat '**schema**' '**migration**')" ]; then
  echo "There are unstaged changes in the repository:"
  git --no-pager diff
  exit 1
fi
