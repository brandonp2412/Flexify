# Codebase Structure

Flutter app, ~78 Dart files under `lib/`. Flat top-level files plus feature subfolders.

## Entry & app shell
- `lib/main.dart` — `main()`, global `AppDatabase db`, `MultiProvider` setup, `App` (MaterialApp,
  theming, dynamic color). `androidChannel` MethodChannel `com.presley.flexify/android`.
  `rootScaffoldMessenger` global key for snackbars.
- `lib/home_page.dart` + `lib/bottom_nav.dart` — main navigation shell (customizable tabs).
- `lib/constants.dart`, `lib/utils.dart` — shared constants and helpers.

## Feature folders under lib/
- `plan/` — `plans_page`, `plan_state` (ChangeNotifier), `edit_plan_page`, `start_plan_page`,
  `start_list`, `session_sets`, `swap_workout`, `exercise_tile`, `exercise_modal`, plan/plans tiles.
- `graph/` — `graphs_page`, `strength_page`/`strength_data`, `cardio_page`/`cardio_data`,
  `global_progress_page`, `edit_graph_page`, `graph_history_page`, `graph_notes_page`, `flex_line`.
- `sets/` — `history_page`, `history_list`, `group_history`, `edit_sets_page`, `edit_set_page`.
- `timer/` — `timer_page`, `timer_state` (ChangeNotifier), `stopwatch_page`, `timer_progress_widgets`.
- `settings/` — `settings_page`, `settings_state` (ChangeNotifier), plus per-section pages:
  `appearance_settings`, `format_settings`, `timer_settings`, `data_settings`, `tab_settings`,
  `plan_settings`, `workout_settings`, `whats_new`.
- `database/` — see `mem:database_and_drift`.

## State management
**provider** package with `ChangeNotifier`. Three app-wide states wired in `main.dart` via
`MultiProvider`: `SettingsState`, `TimerState` (ChangeNotifierProxyProvider off settings),
`PlanState`. `SettingsState.value` is a Drift `Setting` row, kept live via `watchSingle()` stream.

## Tests
- `test/` — widget/unit tests per page (e.g. `plans_page_test.dart`, `gym_sets_test.dart`),
  `mock_tests.dart`, `mock_tab_controller.dart`, `performance_test.dart`, and
  `test/generated_migrations/schema_vN.dart` (Drift-generated, used for migration tests).
- `integration_test/` — `screenshot_test.dart`, `performance_test.dart`.
- `test_driver/` — driver for integration tests.
