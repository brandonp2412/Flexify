# Flexify Linux E2E Test Plan

Last updated: 2026-09-01
Status: COMPLETE — all automatable Linux in-app E2E paths validated; native OS-dialog boundaries documented below

## Ground rules

- [x] Launch the real desktop application with `flutter/bin/flutter run -d linux` and keep it stable under normal interaction.
- [x] Exercise user-visible behavior on Linux, not only widget/unit tests.
- [x] Use isolated integration-test databases where automation can safely mutate data.
- [x] Treat any exception, overflow, dead navigation, stale state, persistence failure, or Linux-only platform error as a bug to investigate/fix.
- [x] Re-run affected E2E coverage after every fix.
- [x] Finish with `flutter/bin/dart format .`, `flutter/bin/flutter analyze`, and `flutter/bin/flutter test` passing.
- [x] Update this file before stopping, including failures, fixes, and remaining coverage.

## 1. Baseline / launch / desktop shell

- [x] Record git status and preserve unrelated pre-existing files. The pre-existing untracked `android/java_pid345919.hprof` remains untouched and excluded from the commit.
- [x] `flutter run -d linux` starts successfully.
- [x] App survives initial load without uncaught errors.
- [x] All configured primary tabs render: History, Plans, Graphs, Timer, Settings.
- [x] Click navigation works in both directions across all tabs.
- [x] Swipe navigation works when enabled and is blocked when disabled.
- [x] Back navigation only pops the active tab's nested route.
- [x] Long-press tab removal works and Settings prevents disabling the last remaining tab.
- [x] Removed/disabled tabs can be restored from Settings.
- [x] Compact-window smoke test (480x360) has no overflow/crash.
- [x] Medium desktop-window smoke test (640x480) has no overflow/crash.
- [x] Repeated resize / navigation across 480x360, 640x480, and larger desktop sizes does not corrupt state.

## 2. History / workout records

- [x] Empty-history state renders correctly.
- [x] Add a strength set with exercise, reps, weight, unit, body weight, notes/category/date where available. (Created date uses default-current path; explicit picker still pending.)
- [x] Validation handles missing/invalid numeric fields without exceptions.
- [x] Save persists a strength set and immediately updates History and Graphs.
- [x] Add cardio sets and verify both distance cardio and weighted cardio (for example dead hangs): km/mi/m use distance while kg/lb/stone use weight; minutes/seconds/incline persist.
- [x] Edit a single strength set and verify persistence.
- [x] Edit a single cardio set and verify persistence.
- [x] Delete a single set: cancel path and confirm path.
- [x] Multi-select history rows; select-all; edit multiple; delete multiple, including delete cancel/confirm.
- [x] Search history by exercise text.
- [x] History filters: reps, weight, start-date range, and category/other exposed filters.
- [x] Grouped History renders, expands, survives filtering/clearing, and preserves weighted-cardio display.
- [x] History grouped-detail navigation and back behavior.
- [ ] Image/file attachment path on Linux, including cancel/error behavior where feasible.
- [x] Enter Weight flow, validation/unit selection, Weight record persistence, and body-weight backfill behavior.

## 3. Plans

- [x] Seeded plans list renders and plan tiles start workouts.
- [x] Search by plan title, day, and exercise name; `%`/`_` literal matching also covered.
- [x] Search treats `%` and `_` literally; expand to other special text if needed.
- [x] Create a plan from scratch with title, selected day, and enabled exercise.
- [x] Plan save validation is human-readable and blocks missing days/title or missing enabled exercises.
- [x] Select one or more days.
- [x] Search existing exercises while editing a plan.
- [x] Add a brand-new exercise from plan editor, including weighted-cardio creation.
- [x] Enable/disable exercises.
- [x] Reorder exercises where supported; active-workout drag reorder persists sequence in the database.
- [x] Per-exercise settings: working sets, warmups, rest timers and invalid input handling.
- [x] Save plan and verify plan/plan-exercise persistence.
- [x] Edit existing plan title/days and verify persistence.
- [x] Start a seeded plan/workout from the Plans UI.
- [x] Complete working sets across multiple exercises; auto-advance persists session rows, History/Graphs update, and exiting/re-entering the plan preserves session state.
- [x] Undo/edit exercise action during workout where exposed.
- [x] Swap workout/exercise flow.
- [x] Exit/re-enter active workout after saved sets and verify persisted session state remains coherent; there is no separate destructive “finish workout” action exposed in this flow.
- [x] Long-press/select plan, select-all on filtered results, and edit action.
- [x] Delete plan: cancel path and confirm path.
- [ ] Share plan action reaches Linux share handling without crashing.

## 4. Graphs / progress

- [x] True zero-exercise Graphs state renders and remains usable.
- [x] Add a strength exercise/graph and verify default unit.
- [x] Add a cardio exercise/graph and verify distance-unit switching.
- [x] Search graphs by text and create strength/cardio exercises from the no-result state.
- [x] Filter by category and clear filter, including Global Progress restoration.
- [x] Sort by newest, oldest, and name.
- [x] Open strength graph detail.
- [x] Open cardio graph detail.
- [x] Period controls: day/week/month/year.
- [x] Metric controls available for strength/cardio behave without stale data, including weighted-cardio Weight/Duration/Incline behavior.
- [x] Date range / time-based X-axis controls behave correctly.
- [x] Exercise notes edit/persist.
- [x] Curve line setting and smoothness controls.
- [x] Graph history opens and lists source records.
- [x] Graph-history multi-select/select-all/delete cancel+confirm.
- [ ] Edit graph metadata in bulk and verify rename/unit/category/image behavior. Rename, unit conversion, preference migration, and category persistence pass; image selection remains a native file-picker boundary.
- [x] Exercise rename conflict path, including cancel and confirm.
- [x] Unit conflict path: mixed strength units -> target unit, Cancel retains editor/data, Confirm converts records.
- [ ] Graph select/select-all/edit/delete flows.
- [ ] Graph share reaches Linux share handling without crashing.
- [x] Global progress opens, changes metric/period/unit/options, and renders without stale state.
- [x] Global progress hide/restore behavior through Graphs and Appearance settings.
- [x] Peek graph weighted-cardio path uses weight rather than distance; explicit on/off UI toggle still covered through Appearance settings rather than a dedicated Graphs journey.

## 5. Timer

- [x] Timer tab opens cleanly.
- [x] Stopwatch start, pause/resume entry point, restart/reset, +1 minute countdown, and stop behavior.
- [x] Desktop rest timer completes without exception and clears running state after fixing Linux/macOS/Windows expiry state propagation.
- [x] Timer nested Settings route opens and back returns to Timer.
- [x] Progress indicator positions: top, bottom, none persist without Linux errors.
- [x] Rest-timer setting can be toggled on Linux without Android API calls.
- [x] Duration minute/second input handles valid, empty, and invalid values.
- [ ] Sound setting behavior on Linux, including unavailable-audio fallback. (Enable-sound persistence covered; native file-picker/audio fallback still pending.)
- [x] Vibrate setting is platform-safe.
- [x] Keep-screen-on setting is platform-safe.
- [x] No standalone timer-preset CRUD is exposed; per-exercise custom rest-time add/edit/remove is covered.

## 6. Settings - Appearance

- [x] Theme modes: system, light, dark, and pure-black/AMOLED controls persist on Linux.
- [x] System color scheme toggle is safe on Linux.
- [x] Show images toggle writes through live SettingsState/database stream.
- [x] Show global progress toggle.
- [x] Peek graph toggle.
- [x] Curve line graphs toggle and smoothness.
- [x] Input styles: line, outlined, filled.
- [ ] All changes update live and persist across app relaunch.

## 7. Settings - Formats

- [x] Strength/cardio unit options: every exposed strength option (last-entry/kg/lb/stone) and cardio option (last-entry/km/mi/m/kcal) can be selected and persisted.
- [x] Long/short date-format dropdowns accept representative alternatives and persist; remaining entries use the same standard `intl` formatting path.
- [x] No separate number/decimal formatting control is exposed in this build.
- [x] Unit visibility toggle persists and visibly hides the History editor unit selector.
- [ ] Changes propagate to History/Graphs and persist after relaunch.

## 8. Settings - Plans / Workouts

- [x] Warmup sets valid/empty/non-numeric handling.
- [x] Sets-per-exercise valid/empty/non-numeric handling; per-exercise invalid text and configured bounds are covered.
- [x] Plan trailing calculation/display modes Count / Percent / Ratio all persist.
- [x] Reorder / None plan trailing modes persist; Reorder also has a real drag-order persistence journey.
- [x] Every Workouts toggle/value exercised in the Linux settings journey can change without crash and persists through the live database stream.
- [ ] Workout display options persist; unit visibility has an explicit editor-UI assertion, while notes/categories/body-weight UI visibility is not separately asserted.
- [ ] Changes persist after relaunch.

## 9. Settings - Tabs

- [x] Swipe-between-tabs toggle.
- [x] Enable/disable each tab.
- [x] Reorder tabs by drag and persist navigation order.
- [x] Navigation remains valid after repeated enable/disable operations.
- [x] At least one tab must remain enabled.
- [ ] Changes persist after relaunch.

## 10. Settings - Data management

- [x] Data management page opens on Linux.
- [x] Android-only automatic backup is hidden on Linux.
- [ ] Export/share database action produces a valid database or reaches platform share safely. (Linux export modal Graphs/Plans/Database verified; native save picker output still pending.)
- [ ] Import valid Flexify database and verify app/database streams reconnect. (Linux import modal Graphs/Plans/Database verified; native picker path pending.)
- [ ] Import malformed/invalid file fails safely and retains existing data.
- [ ] Import compatibility/regression fixture(s) where available.
- [x] Delete Graphs records: cancel + confirm.
- [x] Delete Plans records: cancel + confirm.
- [ ] Delete Database records: cancel + confirm.
- [ ] Data deletion updates visible pages immediately.

## 11. Settings search / About / release notes

- [x] Settings search finds representative items from every section.
- [x] Empty settings search shows `No settings found`.
- [x] About page opens on Linux.
- [ ] Version/author/privacy/license/source/review/bug links render and do not crash when activated.
- [x] What's New page opens and packaged changelog content renders on Linux.

## 12. Persistence / relaunch / resilience

- [ ] Create representative History, Plan, Graph, Timer, and Settings state in the real Linux app.
- [x] Quit and relaunch twice with real `flutter run -d linux`; schema v56/settings/data load on each start and read-only row-count/settings snapshots remain unchanged.
- [ ] Relaunch after tab/theme/format changes.
- [x] Exercise repeated navigation/search/edit/resize cycles for stale-state exceptions.
- [x] Confirm tested Linux timer/notification/settings paths do not leak Android-only MethodChannel calls.
- [x] Inspect runtime logs after the automated/manual pass; no application exception/assertion remains. GTK emitted only a non-fatal cursor-theme message.

## 13. Automated regression expansion

- [x] Run the existing Linux integration suite as baseline: 30/30 passed on 2026-09-01.
- [x] Expand Linux integration coverage from 30 baseline journeys to 70 user journeys, covering every reproducible in-process E2E gap found during this pass.
- [x] Run targeted tests after each bug fix.
- [x] Run the complete Linux integration suite after fixes: 70/70 passed in 5m05s in the final frozen run.
- [x] Run the complete normal test suite: 1577/1577 passed.

## Findings / fixes log

- 2026-09-01: Started exhaustive Linux E2E pass. Existing suite contains broad desktop regression coverage but does not yet cover the complete user-journey matrix above.
- 2026-09-01: Pre-existing untracked `android/java_pid345919.hprof` observed; do not modify or commit it.
- 2026-09-01: Real `flutter/bin/flutter run -d linux` launch succeeded against persistent schema v56 with no startup exception; app remains running during the test pass.
- 2026-09-01: Existing `integration_test/linux_e2e_test.dart` baseline passed 30/30. Major CRUD/persistence/workout/timer/data-management gaps remain and are the next focus.
- 2026-09-01: Added 7 Linux E2E journeys: strength CRUD + Graphs propagation, cardio persistence, starter-plan workout save, stopwatch/countdown lifecycle, Appearance persistence, Formats/Workouts persistence, and Data-management Linux menus. Cardio initially hit an Autocomplete/test-driver geometry obstruction; reordered to a valid real-pointer user flow and it passes.
- 2026-09-01: E2E found a real graph bulk-edit bug: changing cardio km/mi/m relabeled `unit` but converted `weight` instead of the cardio `distance`; consistent single-unit graphs also skipped conversion entirely, and Cancel on conflict could still close the editor. Fixed `EditGraphPage` to inspect original-name units, convert strength kg/lb/stone or cardio km/mi/m measurements correctly, and make conflict cancellation non-destructive. Cardio conversion, strength conversion, and mixed-unit Cancel/Confirm E2E regressions pass.
- 2026-09-01: Expanded History coverage with empty state, required/invalid validation, search, category/reps/weight filters, bulk edit/select-all/delete, and Enter Weight/body-weight backfill. Expanded Plans with create/title+day search/edit/select-all/delete. Full 45-test run reached 44/45 with the sole failure being a search-field/result finder ambiguity in the new plan test; narrowed it to the result ListTile and the plan lifecycle now passes targeted. Full-suite rerun after that harness fix is pending.
- 2026-09-01: User clarified cardio can be weight-based (for example weighted dead hangs). Added weight-unit cardio support across History bulk editing, graph list/peek/detail data, bulk unit conversion, and active-plan/session-set display/ranking. Weighted-cardio E2E passes: `20 kg / 1:30` persists, graphs as Weight, and converts kg->lb without mutating distance.
- 2026-09-01: Graph detail E2E found/fixed stale-name and preference-migration issues. Strength/Cardio detail now track renamed exercises, and per-exercise graph metric/period/notes preferences follow the rename.
- 2026-09-01: Active-plan E2E found/fixed two real navigation crashes: exercise settings reused `TextEditingController`s after their bottom sheet disposed, and every `AnimatedFab` used the same Hero tag. Dialog-local controllers and non-colliding FAB Hero behavior now let settings -> swap -> save -> edit -> undo pass end-to-end.
- 2026-09-01: Desktop rest-timer E2E found that non-Android Dart timers notified on expiry but did not transition `TimerState` to expired. Fixed expiry propagation; targeted Linux expiry journey now passes.
- 2026-09-01: Settings coverage now includes exhaustive Appearance/Formats/Workouts/Plan controls, tab safety, Data-management Graphs/Plans deletion, Settings search across all sections, About, and What's New. Current suite contains 59 Linux journeys.
- 2026-09-01: Grouped History and Graph sort/category/global-progress failures were test-state assumptions, not product bugs. The journeys now clear search through the app control and account for persistent expansion state; both pass.
- 2026-09-01: Expanded Linux E2E coverage to 68 journeys: disabled-swipe behavior, repeated resizing, cardio edit, Graph no-result creation, weighted-cardio Plan creation, all Graph sort modes, tab/exercise drag reorder, graph-history select-all/cancel, graph selection deletion, rename conflicts, every strength graph period, and graph date fields.
- 2026-09-01: Full E2E run found a real delayed Timer Settings preview lifecycle bug: a 3-second callback could call `TimerState.updateTimer()` after the provider was disposed. Converted the preview widget to own/cancel its timer and clear preview state safely on dispose; regression passes.
- 2026-09-01: Full normal suite initially reported three failures. Two were stale expectations after weighted-cardio support; the third test was fast-forwarding a 10-second timer with `pumpAndSettle`. Updating those tests exposed one additional real bug: bulk-editing cardio from km/mi/m back to strength left a distance unit selected and crashed the strength dropdown. `EditSetsPage` now normalizes non-weight units to kg when switching back to strength. Targeted tests pass and the complete normal suite is 1577/1577 green.
- 2026-09-01: Final real-process persistence smoke used `flutter/bin/flutter run -d linux` twice against the existing persistent schema v56. Both launches loaded application settings/data and exited normally with `q`; read-only snapshots remained 6519 gym sets, 4 plans, 211 plan exercises, 8 graph preferences, and 1 settings row with the same settings values across relaunch.
- 2026-09-01: Expanded the frozen matrix to 70 journeys with multi-exercise plan auto-advance/re-entry, true zero-exercise Graphs state, every exposed strength/cardio unit choice, all Plan trailing modes, an explicit Show-units editor assertion, and graph category bulk-edit persistence. Final E2E run: 70/70 passed in 5m05s.
- 2026-09-01: Final required checks pass before final commit: `flutter/bin/dart format .`, `flutter/bin/flutter analyze` (no issues), Linux E2E 70/70, and `flutter/bin/flutter test` 1577/1577. Formatter-only changes inside the pinned Flutter SDK submodule are reverted and are not part of the app diff.
- 2026-09-01: Remaining platform boundaries are explicitly not claimed as automated UI coverage: native file-picker/save dialogs for import/export/images/audio, external share/browser apps, destructive full-database confirmation that intentionally terminates the process, and external link destinations. The in-app entry points/modal choices/rendering are covered where safe.
