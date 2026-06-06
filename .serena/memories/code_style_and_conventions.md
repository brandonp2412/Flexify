# Code Style & Conventions

Dart/Flutter. Lints via `flutter_lints` (`analysis_options.yaml`). Always `dart format lib test`.

## From project CLAUDE.md (authoritative)
- **Minimalist comments**: don't describe *what* code does; refactor to self-document with
  descriptive names instead.
- **External-knowledge exception**: comments REQUIRED for logic from external formulas / non-obvious
  business rules / papers (e.g. the Brzycki 1RM formula). Include reference URLs for workarounds to
  framework bugs or solutions taken from StackOverflow/GitHub issues.
- **Docstrings**: public API members (classes, mixins, extensions, top-level functions) get `///`
  docstrings that add IntelliSense value — not restatements of the name.
- **No dead code**: never leave commented-out code; delete it (git is the record).

## Patterns observed in the codebase
- State: `provider` + `ChangeNotifier`. Feature state classes named `<Feature>State`
  (e.g. `SettingsState`, `TimerState`, `PlanState`); read with `context.select`/`context.watch`.
- Settings are a single Drift `Setting` row exposed as `SettingsState.value`, watched via a stream.
- Conditional imports for web vs native (database connection & migrations).
- File naming: `snake_case.dart`, one widget/page per file, grouped into feature folders.
- Generated files (`*.g.dart`, `database.steps.dart`, `test/generated_migrations/`) are NOT
  hand-edited — regenerate via build_runner / drift_dev.

## Third-party packages
Do NOT rely on internal knowledge for pubspec packages. Read latest docs on
`https://pub.dev/packages/<name>` (and Drift docs) before implementing. Flutter MCP is for the SDK
only; use the browser for community packages (Drift, Provider, fl_chart, etc.).
