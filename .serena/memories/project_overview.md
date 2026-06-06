# Flexify — Project Overview

**Flexify** is an offline-first gym/workout tracker built with **Flutter** (Dart SDK `>=3.2.6 <4.0.0`).

- Package name: `flexify`, app id `com.presley.flexify`. Author: Brandon Presley / Frisbee Software.
- Tagline: "Track gym progress, visualize graphs, enjoy offline support & timers."
- **No internet usage at all** — fully offline. All data is local (SQLite via Drift).
- Distributed on Google Play, F-Droid, and Microsoft Store.

## Platforms
Cross-platform: Android, iOS, Linux, macOS, Windows, and Web. Database connection is conditionally
imported per platform (`database_connection_native.dart` vs `database_connection_web.dart`,
`migrations_native.dart` vs `migrations_web.dart`).

## Core domains (each maps to a `lib/` subfolder)
- **plan/** — workout plans, plan exercises, starting/running a workout session.
- **graph/** — progress graphs (strength, cardio, global progress), built on `fl_chart`.
- **sets/** — gym set history and editing (the actual logged reps/weight/cardio entries).
- **timer/** — rest timers and stopwatch, with native timer integration + local notifications.
- **settings/** — extensive user-configurable settings (appearance, format, tabs, data, etc.).
- **database/** — Drift schema, tables, migrations, defaults.

## Key features
Strength logging (reps/weight), cardio, progress graphs, rest timers w/ alarms & vibration,
1RM estimation (Brzycki formula — see CLAUDE.md), CSV import/export, automatic backups,
dynamic/Material You color, AMOLED theme, customizable tabs.
