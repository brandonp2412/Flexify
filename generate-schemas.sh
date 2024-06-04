#!/bin/sh

set -ex

for commit in $(git log -G'schemaVersion' --pretty=format:'%H' -- lib/database.dart); do
    git restore pubspec.lock
    git checkout "$commit"
    flutter clean
    dart pub get
    dart run drift_dev schema dump lib/database.dart drift_schemas
done

git restore pubspec.lock
git checkout main
dart run drift_dev schema steps drift_schemas/ lib/database/schema_versions.dart
dart run drift_dev schema generate drift_schemas/ test/generated_migrations/
