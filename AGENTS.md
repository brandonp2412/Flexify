# Android Device Installation

- For physical Android device installs, do not use `flutter run` or `flutter install`.
- Build the APK first, then install or update it with `adb install -r <path-to.apk>` so the existing app data is preserved.
- If `adb install -r` fails because of a signing-key mismatch, version downgrade, or another install error, report the failure and do not uninstall the existing app unless explicitly asked.

# Required Flutter Completion Checks

- Before considering any work complete, run all of the following and ensure they pass:
  1. `dart format .`
  2. `flutter analyze`
  3. `flutter test`

# Drift Database Rules
- **Migration Protocol**: When the persisted database schema changes (tables, columns, constraints, or indexes), or existing data needs a versioned migration:
  1. Increment the `schemaVersion` in the database class.
  2. dart run build_runner build -d
  3. dart run drift_dev make-migrations
- Changes to database paths, connection settings, queries, or other database code do not require a schema version bump unless they include an actual schema or data migration. Do not add empty migrations for those changes.
  
# Git & Version Control
- **Commit Format**: Use the [Conventional Commits](https://www.conventionalcommits.org/) standard (e.g., `feat:`, `fix:`, `chore:`).
- **Commit Message**: Write a concise title (50-72 chars) and a bulleted list in the body if the changes are complex.
# Documentation & Commenting Standards
- **Minimalist Comments**: Avoid comments that describe what the code is doing. If the code is unclear, refactor the code to be self-documenting using descriptive variable and function names.
- **No Dead Code**: Never leave commented-out code blocks. If code is not used, delete it; Git history is the record, not the source file.
