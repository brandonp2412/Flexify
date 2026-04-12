# Drift Database Rules
- ALWAYS read the Drift documentation at https://drift.simonbinder.eu/docs/ before modifying schemas or queries.
- **Migration Protocol**: After any change to a table or database file:
  1. Increment the `schemaVersion` in the database class.
  2. dart run build_runner build -d
  3. dart run drift_dev make-migrations
  
# Documentation & Package Rules
- Do not rely on internal knowledge for third-party packages in `pubspec.yaml`.
- Before implementing features for a package, use the browser tool to read the latest README and API docs on `https://pub.dev/packages/[PACKAGE_NAME]`.
- Note: Your Flutter MCP is for the SDK; use the browser for community packages like Drift, Riverpod, etc.

# Quality Standards (Definition of Done)
- Before completing any task, you MUST ensure these commands pass:
  1. `dart format .`
  2. `flutter analyze`
  3. `flutter test`

# Git & Version Control
- **Completion Protocol**: When a task is successful and all quality checks (tests/analyze) pass, you MUST commit the work.
- **Commit Format**: Use the [Conventional Commits](https://www.conventionalcommits.org/) standard (e.g., `feat:`, `fix:`, `chore:`).
- **Commit Message**: Write a concise title (50-72 chars) and a bulleted list in the body if the changes are complex.
- **The "Give Up" Rule**: If the task fails, or you are unable to resolve the errors after reasonable attempts:
  - DO NOT stage or commit any changes.
  - Leave the files as-is in the working directory for the user to review.
  - Inform the user exactly where you got stuck and why you are stopping.
- **Pre-Commit Check**: Never commit code that breaks `flutter analyze` or `flutter test` unless explicitly told the task is a "work in progress."

# Documentation & Commenting Standards
- **Minimalist Comments**: Avoid comments that describe what the code is doing. If the code is unclear, refactor the code to be self-documenting using descriptive variable and function names.
- **The "External Knowledge" Exception**: Comments are REQUIRED when implementing logic derived from external formulas, non-obvious business rules, or academic papers (e.g., explaining the Brzycki formula in Flexify's 1RM calculations). 
- **Docstrings**: Public API members (classes, mixins, extensions, and top-level functions) should have triple-slash `///` docstrings. These must provide value to the editor's hover-state/IntelliSense, not just repeat the function name.
- **Reference Links**: If a piece of logic is a workaround for a known framework bug or follows a specific StackOverflow/GitHub Issue solution, include the URL in a comment.
- **No Dead Code**: Never leave commented-out code blocks. If code is not used, delete it; Git history is the record, not the source file.