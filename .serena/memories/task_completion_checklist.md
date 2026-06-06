# Task Completion Checklist

From project CLAUDE.md — follow exactly.

## Before completing ANY task, these MUST pass:
1. `dart format lib test`
2. `flutter analyze`
3. `flutter test`

## If the task touched a Drift table or database file, also:
1. Bump `schemaVersion` in `lib/database/database.dart`.
2. `dart run build_runner build -d`
3. `dart run drift_dev make-migrations`
(Read https://drift.simonbinder.eu/docs/ first.)

## Git / completion protocol
- On success (all checks pass), you MUST commit using **Conventional Commits**
  (`feat:`, `fix:`, `chore:`, `style:`, etc.). Concise 50–72 char title; bulleted body if complex.
- Never commit code that breaks `flutter analyze` or `flutter test` unless explicitly told it's WIP.

## The "Give Up" rule
If the task fails or errors can't be resolved after reasonable attempts:
- Do NOT stage or commit anything.
- Leave files as-is for the user to review.
- Tell the user exactly where you got stuck and why you're stopping.
