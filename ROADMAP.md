# Flexify Translation Roadmap

This roadmap tracks the complete migration of Flexify from hard-coded English UI copy to Flutter's generated localization system, followed by production-quality translations. The translation worker should treat this file as the durable checkpoint between runs and only tick an item when its implementation and validation are complete.

## Goals

- Keep English (`en`) as the canonical source language and fallback.
- Use Flutter's generated localization support (`gen-l10n`) with ARB files rather than a custom translation framework.
- Preserve placeholders, plurals, units, dates, numbers, exercise data, user-entered content, and database values correctly across locales.
- Follow the system locale by default, while allowing a user-selected language override once the localization foundation is stable.
- Never mark a locale supported until every active message key has a reviewed translation and the required tests pass.
- Keep translation work incremental: one coherent migration or one complete locale per commit whenever practical.

## Initial supported locales

English is the source locale. The first translation wave is:

- Spanish (`es`)
- French (`fr`)
- German (`de`)
- Italian (`it`)
- Portuguese, Brazil (`pt_BR`)
- Dutch (`nl`)
- Polish (`pl`)
- Japanese (`ja`)
- Korean (`ko`)
- Simplified Chinese (`zh_CN`)

Additional locales can be added after the first wave using the same completeness and QA rules. Turkish (`tr`) has since been added and is fully supported.

## 1. Localization foundation

- [x] Add Flutter SDK localization support and enable `generate: true` in `pubspec.yaml`.
- [x] Add `l10n.yaml` with explicit ARB/source/output configuration.
- [x] Create the canonical English ARB file and generated localization entry point.
- [x] Wire generated localization delegates, `supportedLocales`, and application title into `MaterialApp`.
- [x] Add a small context/helper access pattern only if it materially reduces repetitive generated-localization boilerplate; do not introduce a parallel localization abstraction.
- [x] Add localization smoke tests that prove English loads, an alternate locale can load, and locale fallback does not crash.
- [x] Document ARB key naming, placeholder metadata, plural/select usage, and the rule that visible copy must no longer be introduced as hard-coded English.

## 2. Locale preference and settings

- [x] Add an app language preference with `System default` plus every fully supported locale.
- [x] Persist only the locale identifier/override; do not persist translated display strings.
- [x] Apply locale changes without requiring an app restart.
- [x] Display language names in a clear, stable form and ensure the current choice remains understandable if the UI language changes.
- [x] Ensure settings search can find the language setting using the active locale's wording.
- [x] Add tests for system-default behavior, persisted overrides, changing locale at runtime, and invalid/removed stored locale values.

## 3. Migrate all user-facing English strings

Move hard-coded user-visible copy into the canonical English ARB. Preserve non-user-facing identifiers, database enum/storage values, route names, logs, debug diagnostics, API payloads, units used as data, and test fixture internals unless they are directly rendered to users.

### App shell and shared UI

- [x] App title, bottom navigation, drawers/menus, shared dialogs, confirmation actions, generic buttons, empty states, errors, permissions, search, filters, and reusable widgets.
  - [x] Localize bottom navigation, tab-removal UI, version-change toast, and shared app-search actions/dialog copy.
  - [x] Localize reusable history/graph filter controls and render filter dates using the active locale.
  - [x] Localize Android app-access and missing-permission surfaces, including reusable permission actions and status copy.
- [x] Shared date/time, duration, count, set/rep, weight, distance, percentage, and ordinal formatting uses locale-aware APIs where appropriate.
  - [x] Localize reusable weight, distance, and calorie unit labels while preserving stored unit identifiers.
- [x] Snackbar, validation, import/export, file-picker, notification-facing, and failure copy is localized.
  - [x] Localize shared data import/export/delete actions, import validation, and import success/failure snackbars.

### Home, workouts, plans, and sets

- [x] Home page and workout/session flows.
- [x] Plans list, start-plan flow, workout swapping, session sets, and plan editing.
- [x] Set creation/editing, history, set actions, notes, timers, and related confirmation/error states.
- [x] Dynamic messages use placeholders/plurals instead of string concatenation where grammar can vary.

### Graphs, progress, and weight

- [x] Graph pages, graph controls, legends, tooltips, strength/progress views, and global progress UI.
- [x] Weight page, weight statistics, history actions, and related empty/error states.
- [x] Locale-sensitive numeric labels remain parse-safe internally while rendering with locale-aware formatting.

### Settings and supporting pages

- [x] Appearance settings.
- [x] Workout and plan settings.
- [x] Timer and notification settings.
- [x] Data/import/export settings.
- [x] About, permissions, changelog/release-facing in-app UI, and miscellaneous supporting pages.
- [x] Settings search indexes translated labels/descriptions without changing persisted setting identifiers.

### Platform-facing strings

- [x] Android notification channel names, notification titles/bodies, permission rationale copy, and native strings that users can see.
- [x] Review iOS, Windows, Linux, macOS, and web user-visible platform strings; localize those that participate in the app experience without renaming package IDs, executable names, or protocol identifiers.
  - [x] Localize the native macOS application menu for every supported locale, including Turkish and standard Edit, Find, spelling, window, and help commands.
- [x] Ensure native timer/notification code receives already-localized or locale-safe values where Flutter is the source of truth.

### Migration completion gate

- [x] Audit `lib/`, native platform code, and user-facing tests for remaining hard-coded English UI strings.
- [x] Add a lightweight regression check or documented review rule that makes newly introduced hard-coded UI copy easy to detect.
  - [x] Cover rich text, tooltip messages, custom semantics, and string-label Flutter widgets in the hard-coded-English audit.
- [x] English UI behavior and layout remain functionally unchanged apart from localization plumbing.

## 4. Translation wave 1

For every locale below: translate every active ARB key from the canonical English source, preserve placeholders/ICU syntax exactly, use natural gym/fitness terminology, avoid literal translations that change meaning, run generation/analyze/tests, and inspect representative narrow/wide layouts for clipping or overflow before ticking the locale complete.

- [x] Spanish (`es`)
- [x] French (`fr`)
- [x] German (`de`)
- [x] Italian (`it`)
- [x] Portuguese, Brazil (`pt_BR`)
- [x] Dutch (`nl`)
- [x] Polish (`pl`)
- [x] Japanese (`ja`)
- [x] Korean (`ko`)
- [x] Simplified Chinese (`zh_CN`)

### Additional supported locales

- [x] Turkish (`tr`)

## 5. Translation quality and layout QA

- [x] Add automated ARB completeness validation: every supported locale has the same active keys as English and valid placeholder metadata/ICU syntax.
  - [x] Keep language-only `pt` and `zh` fallback catalogs synchronized with the reviewed `pt_BR` and `zh_CN` regional catalogs.
- [x] Test representative singular/plural/count messages in languages with different plural behavior.
- [x] Test locale-aware dates, decimal/group separators, durations, percentages, weights, and distances without changing stored numeric values.
  - [x] Keep language-only Portuguese and Chinese system-locale fallbacks localized for relative-time formatting.
- [x] Exercise text scaling and long-string layouts on phone and desktop widths; fix clipping/overflow by improving layouts rather than shortening translations unnaturally.
- [x] Verify dialogs, segmented controls, chips, navigation labels, settings rows, graph labels, timer UI, and notification copy with long translations.
- [x] Verify CJK rendering and font fallback on Android and desktop.
  - [x] Exercise Japanese, Korean, and Simplified Chinese navigation/title rendering through the real app on Linux and Android integration targets without bundled fonts, validating platform font fallback.
- [x] Verify screen-reader semantics use localized labels/hints where custom semantics are present.
- [x] Confirm user-entered exercise/plan/note text is never translated or rewritten.

## 6. Tests, metadata, and release readiness

- [x] Update widget tests that depend on English labels to use generated localizations or explicitly pin English where the test is not testing localization.
- [x] Add focused tests for at least one Latin-script alternate locale and one CJK locale across core navigation/settings/workout flows.
- [x] Ensure integration tests remain deterministic by explicitly selecting or pinning a locale where necessary.
- [x] Localize Play Store metadata for every supported locale when the in-app translation for that locale is complete; do not advertise a locale before the app ships it.
- [x] Localize App Store description, keywords, and release notes for every supported locale using Fastlane metadata folders.
- [x] Add translated store screenshots only when practical; English screenshots may remain shared where store rules permit.
  - [x] Generate all eight Play Store phone screenshots for every first-wave non-English store locale, while keeping English as the default screenshot pipeline and shared tablet/desktop artwork where appropriate.
- [x] Update contributor documentation with the workflow for adding/changing English strings and updating all locale ARBs.
- [x] Run the full required completion checks: `dart format .`, `flutter analyze`, and `flutter test`.
- [x] Run relevant Android/integration smoke coverage for locale switching and a non-English workout flow.
  - [x] Run `integration_test/localization_smoke_test.dart` on Linux and Android, covering runtime Japanese-to-German switching and saving a German-localized workout with locale-aware decimal input.
- [x] Perform a final hard-coded-English audit and ARB completeness check.
- [x] Confirm all first-wave locales are selectable, persist correctly, survive restart, and can complete core Flexify flows.

## Definition of done

Translation work is complete when every checkbox above is satisfied, every supported locale has complete reviewed ARBs and store metadata, locale switching is stable, core layouts tolerate translated text, required tests pass, and no known user-facing English string remains outside the localization system without a documented reason.
