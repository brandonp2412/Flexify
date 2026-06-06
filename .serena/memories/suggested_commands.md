# Suggested Commands

Platform: Linux (Arch), zsh shell. Flutter project; an `fvm`/`flutter` setup is present.

## Quality gates — Definition of Done (from CLAUDE.md, MUST pass before completing/committing)
```
dart format lib test
flutter analyze
flutter test
```

## Build / codegen (Drift)
```
dart run build_runner build -d          # regenerate *.g.dart after schema/table changes
dart run drift_dev make-migrations      # generate migration steps + test schemas
```
After ANY table/db change, also bump `schemaVersion` in lib/database/database.dart first.

## Run
```
flutter run                             # default device
flutter run -d linux | chrome | <id>
flutter devices
```

## Test variants
```
flutter test                            # all unit/widget tests
flutter test test/<file>_test.dart      # single test file
flutter test integration_test/          # integration tests
```

## Misc scripts (scripts/)
`macos.sh`, `screenshots-android.sh`, `screenshots-chrome-auto.ps1`, `migrate.sh`, `migrate.ps1`.

## System utils (Arch/Linux)
Standard GNU tools: `git`, `rg`/`grep`, `fd`/`find`, `ls`, `cat`. Note: user has **RTK** hook that
transparently rewrites commands (e.g. `git status` -> `rtk git status`) for token savings.
