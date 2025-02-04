#!/bin/bash

set -ex

dart run --verbosity=error build_runner build -d
dart run --verbosity=error drift_dev make-migrations

if [ -n "$(git diff --stat '**schema**' '**migration**')" ]; then
  echo "There are unstaged changes in the repository:"
  git --no-pager diff
  exit 1
fi
