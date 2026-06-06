# Database & Drift

Persistence uses **Drift** (`drift`, `drift_dev`, `sqlite3`) over SQLite. Web uses `sqlite3_web`.

## Key files (lib/database/)
- `database.dart` — `AppDatabase extends _$AppDatabase`, `@DriftDatabase(tables: [...])`,
  `MigrationStrategy`, and **`schemaVersion`** (currently 53 — verify before relying on it).
  Generates `database.g.dart` (`part`) and uses `database.steps.dart` (step-by-step schema).
- Tables (one file each): `plans.dart` (Plans), `gym_sets.dart` (GymSets — the core logged-set
  table), `settings.dart` (Settings — single-row app config), `plan_exercises.dart` (PlanExercises),
  `metadata.dart` (Metadata), `graph_preferences.dart` (GraphPreferences).
- `defaults.dart` — `defaultSets` and default plans inserted in `onCreate`.
- `database_connection_native.dart` / `database_connection_web.dart` — conditional connection.
- `migrations_native.dart` / `migrations_web.dart` — conditional migration helpers.
- `failed_migrations_page.dart` — shown (via `main()`) if the DB fails to open.

## Migration protocol (from CLAUDE.md — MUST follow)
After ANY change to a table or database file:
1. Increment `schemaVersion` in `AppDatabase`.
2. `dart run build_runner build -d`
3. `dart run drift_dev make-migrations`

Migration tests live in `test/generated_migrations/schema_vN.dart`. Schemas exported to
`drift_schemas/`. There are helper scripts `scripts/migrate.sh` / `scripts/migrate.ps1`.

ALWAYS read the Drift docs (https://drift.simonbinder.eu/docs/) before modifying schemas/queries.

`gym_sets` has an index `gym_sets_name_created` on `(name, created)`.
