# Storage migration #387: end-to-end validation

Tested on 2026-10-10 against baseline `4bdfd848`, the initial storage change
`d837ba77`, and the changes accompanying this report (schema 68).

## Result

Native storage migration, persistence, backup export, Linux backup restoration,
and deletion passed the checks below. Testing exposed a simultaneous Linux
launch race. The accompanying fix serializes migration with a filesystem lock
and gives native SQLite connections a five-second lock wait. Two concurrent
release processes now both start successfully and preserve every database row.

The complete unit/widget/migration suite passes **2,534 tests**; all **seven
Android instrumented resolver/timer tests** also pass. The broader
Linux UI integration suite has **60 passes and 11 failures**, with the identical
11 failures reproduced against the old build. Android backup import remains
blocked by Waydroid's document provider in both old and new apps; web ZIP export has a bug also reproduced
against the old build. These results do not establish 100% coverage.

## Isolation and method

- Existing production Android packages and the physical phone were untouched.
  Waydroid tests used new `com.presley.flexify.storage387*` application IDs.
  APK updates used `adb install -r`; no existing package was uninstalled.
- Linux applications ran as actual GTK/Flutter processes on a private Xvfb
  display with isolated XDG config, data, cache, and Documents directories.
  Old and new release bundles were launched against the same test directories.
- Browser tests used isolated Brave/Playwright profiles and locally served old
  and new production web builds. SQLite was read from the actual IndexedDB blob.
- UI interactions created workouts and exercised real native save/open dialogs,
  Android's Storage Access Framework, and browser downloads/file selection.
  SQLite checks verified the resulting files rather than relying on screenshots.
- Additional lifecycle tests use real disk files, native SQLite, generated v64
  and v66 schemas, and `AppDatabase.persistent()` with isolated path providers.

## Native application checks

| Scenario | Result and evidence |
| --- | --- |
| Waydroid fresh install and cold launch | Support database created in `files/flexify.sqlite`, not `app_flutter`; UI-entered 8 × 42 kg persisted after force-stop/relaunch. |
| Waydroid old-to-new APK update | Old schema-66 Documents database migrated to support/schema 67; UI-entered 7 × 51 kg retained; integrity and foreign keys passed. |
| Waydroid final debug and release updates | Schema 68 opened; UI-entered 12 × 62 kg retained across cold launch and debug-to-release `adb install -r`. |
| Android manual ZIP export | Actual SAF save produced a valid ZIP and SQLite database containing the migrated workout. |
| Android automatic backup | Actual tree permission chooser configured the support database; broadcasting `BackupReceiver` produced a valid ZIP containing current data, including 12 × 62 kg/schema 68 in the final release build. |
| Android background timer notifications | Both instrumented service tests passed against a separate test package and the support-path SQLite fixture. Fixed the old fixture to supply the localized notification labels required by the service. |
| Android native resolver and settings | Five instrumented tests cover fresh support path, pre-migration legacy fallback, support precedence, deletion marker, and settings updates leaving the legacy file unchanged. |
| Android database sharing | Share flow produced the current support database in `cache/share_plus/flexify.sqlite`; inspected SQLite contents. No message was sent. |
| Android deletion and cold relaunch | App deletion removed support data; relaunch showed empty history despite the retained old Documents database. |
| Linux fresh launch and persistence | Isolated XDG support database created; UI-entered workout survived restart. |
| Linux old-to-new release upgrade | All rows in all eight application tables matched the old database exactly; schema upgraded and integrity/foreign keys passed. |
| Linux legacy images and preferences | Existing exercise image, bodyweight photo, notes, settings, plans, and relationships remained available. Legacy image was visibly rendered. |
| Linux manual ZIP export | Actual GTK save dialog produced SQLite plus the image; archived image references were portable. |
| Linux delete and cold relaunch | Empty history and starter data; legacy database remained untouched and was not resurrected. |
| Linux ZIP restoration | Actual GTK open dialog restored workout, notes, bodyweight/photo, and exercise image; imported image references pointed into support and files existed. |
| SQLite v64 and v66 upgrade/reopen | Disk-backed regression tests preserve data and relationships through intervening schema migrations and reopen. |
| Active legacy WAL | Both real release launch and disk-backed tests included committed rows still in the old WAL. |
| Interrupted migration states | Real release launches recovered marker + complete stage and discarded an uncommitted partial stage. These are seeded interruption states, not power-loss experiments. |
| Existing destination precedence | Support workout at 77 kg won over legacy workout at 51 kg. |
| Deliberate deletion marker | Old database did not reappear when support database was absent and marker existed. |
| Corrupt legacy source | Error shown; original bytes preserved; no silent empty replacement. |
| Corrupt existing support database | Error shown; corrupt support bytes and legacy source preserved. |
| Unwritable support directory | Error shown; legacy source preserved and no destination database created. |
| Missing Documents directory | Fresh support database successfully created. |
| Read-only legacy file | Migration succeeded without changing the source bytes. |
| Different filesystems | Legacy source under home storage migrated into tmpfs support; all rows preserved. |
| Apostrophes/spaces in paths | Real migration and SQLite snapshot succeeded. |
| Concurrent cold launches | Initial build reproduced a migration failure; final build started both processes with an 8 MB legacy notes field and preserved all rows, including five repeat runs. |
| Another process holds migration lock | Regression test verifies migration waits, does not publish early, and succeeds after lock release. |

The Linux old-build fixture included a UI-created workout, then synthetic notes,
settings, bodyweight/photo, and image references added through SQLite to expand
coverage. Native database checks included `PRAGMA integrity_check`,
`PRAGMA foreign_key_check`, schema version, and complete table comparisons where
no data transformation was expected. Legacy source bytes remained unchanged in
the release migration/failure cases.

Automatic backup was tested by invoking the same receiver used by the scheduled
alarm. The actual overnight alarm timing and notification action delivery were
not tested.

## Web checks

| Scenario | Result |
| --- | --- |
| Fresh UI entry and reload | 9 × 43 kg survived browser reload. |
| Old-to-new build with existing IndexedDB | 11 × 53 kg survived schema 66 → 67 → 68; all table rows matched, integrity passed, no foreign-key violations. |
| Graph/history CSV download | Download contained the UI-entered exercise and workout. |
| Plans CSV download | Download contained the expected plan/exercise columns. |
| CSV import through browser chooser | Successful import notification; resulting IndexedDB SQLite contained the workout and passed integrity. |
| ZIP import | Displayed the existing localized unsupported-on-web message after selecting an actual ZIP; CSV remains the supported workflow. |
| Full database deletion | Unsupported in both builds: old build failed in native path-provider lookup; current build reports that web databases have no filesystem path. The confirmation stays open. |
| ZIP export | Failed in both old and current builds with `MissingPluginException` for `getTemporaryDirectory`; export spinner remained active. This existing bug is not fixed by the storage change. |

## Remaining failures

Waydroid selecting either the app-exported ZIP or the Linux image backup failed
in the new app. A separately installed old-build test package reproduced the same
provider exception when selecting the Linux ZIP. These failures occurred
before FilePicker returned a file to Dart:

```text
PlatformException(unknown_path, Failed to retrieve path., null, null)
MediaProvider / ExternalStorageProvider: NullPointerException
LocalCallingIdentity.getPackageNameInternal → AppOpsManager.checkPackage
```

Database contents remained unchanged after this failure. Linux exercised the
actual ZIP restoration path successfully, but this is not a substitute for a
successful Android picker/import test on a working device/provider.

The existing Linux integration suite failed these same tests in old, initial
migration, and final builds:

- Linux desktop can swipe through every primary tab
- History cardio switch preserves the selected unit
- Disabled swipe keeps tab fixed while click navigation works
- Graph desktop context, curve options, and history actions work
- History cardio entry persists Linux-specific fields
- Plan auto-advances and starts a new workout after exit
- Active plan exercise drag reorder persists sequence
- Graphs zero-exercise state remains usable
- Strength graph metric, period, options, and notes persist
- Weighted cardio uses weight in History and Graphs
- Appearance settings persist every desktop-safe control

Several assertions target old UI controls (for example `TabBarView` and a cardio
switch). The suite uses in-memory databases, so these failures do not exercise
storage migration. They are recorded rather than presented as successful tests.

## Re-running the committed checks

```sh
dart format .
flutter analyze
flutter test
flutter test test/native_storage_lifecycle_test.dart test/app_storage_test.dart
flutter test integration_test/linux_e2e_test.dart -d linux
flutter build linux --release
flutter build web
flutter build apk --release
```

Android instrumentation was built with `:app:assembleDebugAndroidTest` in an
isolated application-ID worktree, then both APKs were installed with
`adb -s <waydroid-serial> install -r`. The explicit runner invocation was:

```sh
adb -s <waydroid-serial> shell am instrument -w -r \
  -e class com.presley.flexify.TimerServiceTest,com.presley.flexify.StoragePathTest \
  com.presley.flexify.storage387timer.test/androidx.test.runner.AndroidJUnitRunner
```

Do not run a command targeting all connected devices: this environment also
has a physical phone, which was excluded from these tests.

Migration generation was run in the required order:
`dart run build_runner build -d`, then `dart run drift_dev make-migrations`.
Schema 68 is a no-op schema step required by the repository's database-change
protocol; it accompanies native connection configuration changes.

Local logs, synthetic database snapshots, ZIPs, and screenshots are under
`/tmp/flexify-e2e-387/`. They are temporary evidence, not committed test fixtures.
macOS, Windows, iOS, a physical Android installation, real power loss, and full
or failing disks were not tested in this environment.
