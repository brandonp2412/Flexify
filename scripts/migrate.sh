#!/bin/bash

set -ex

./flutter/bin/dart run build_runner build -d
./flutter/bin/dart run drift_dev make-migrations
./flutter/bin/dart run drift_dev schema generate drift_schemas/ test/generated_migrations/

if [ -n "$(git diff --stat '**schema**' '**migration**')" ]; then
  echo "There are unstaged changes in the repository:"
  git --no-pager diff
  exit 1
fi
