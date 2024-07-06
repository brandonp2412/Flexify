#!/bin/bash

set -ex

dart run drift_dev schema dump lib/database/database.dart drift_schemas
dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
dart run drift_dev schema steps drift_schemas/ lib/database/schema_versions.dart

if [[ -n "$(git diff --stat drift_schemas lib/database/schema_versions.dart test/generated_migrations)" ]]; then
  echo "There are unstaged changes in the repository:"
  git --no-pager diff
  exit 1
fi
