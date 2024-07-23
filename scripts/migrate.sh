#!/bin/bash

set -ex

database=lib/database/database.dart

if git ls-files --error-unmatch $database >/dev/null 2>&1; then
  staged=$(git diff --staged HEAD -- $database)
  unstaged=$(git diff HEAD -- $database)
  changes="$staged$unstaged"

  if echo "$changes" | grep -q "schemaVersion"; then
    echo "Schema version already bumped! nice."
  else
    old=$(grep -oP 'schemaVersion => \K\d+' $database)
    new=$((old + 1))
    sed -i "s/schemaVersion => $old/schemaVersion => $new/" $database
  fi
fi

dart run build_runner build -d
dart run drift_dev schema dump $database drift_schemas
dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
dart run drift_dev schema steps drift_schemas/ lib/database/schema_versions.dart

if [ -n "$(git diff --stat '**schema**' '**migration**')" ]; then
  echo "There are unstaged changes in the repository:"
  git --no-pager diff
  exit 1
fi
