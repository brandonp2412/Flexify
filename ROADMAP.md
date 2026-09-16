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

Additional locales can be added after the first wave using the same completeness and QA rules.

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

- [ ] App title, bottom navigation, drawers/menus, shared dialogs, confirmation actions, generic buttons, empty states, errors, permissions, search, filters, and reusable widgets.
- [ ] Shared date/time, duration, count, set/rep, weight, distance, percentage, and ordinal formatting uses locale-aware APIs where appropriate.
- [ ] Snackbar, validation, import/export, file-picker, notification-facing, and failure copy is localized.

### Home, workouts, plans, and sets

- [ ] Home page and workout/session flows.
- [ ] Plans list, start-plan flow, workout swapping, session sets, and plan editing.
- [ ] Set creation/editing, history, set actions, notes, timers, and related confirmation/error states.
- [ ] Dynamic messages use placeholders/plurals instead of string concatenation where grammar can vary.

### Graphs, progress, and weight

- [ ] Graph pages, graph controls, legends, tooltips, strength/progress views, and global progress UI.
- [ ] Weight page, weight statistics, history actions, and related empty/error states.
- [ ] Locale-sensitive numeric labels remain parse-safe internally while rendering with locale-aware formatting.

### Settings and supporting pages

- [ ] Appearance settings.
- [ ] Workout and plan settings.
- [ ] Timer and notification settings.
- [ ] Data/import/export settings.
- [ ] About, permissions, changelog/release-facing in-app UI, and miscellaneous supporting pages.
- [ ] Settings search indexes translated labels/descriptions without changing persisted setting identifiers.

### Platform-facing strings

- [ ] Android notification channel names, notification titles/bodies, permission rationale copy, and native strings that users can see.
- [ ] Review iOS, Windows, Linux, macOS, and web user-visible platform strings; localize those that participate in the app experience without renaming package IDs, executable names, or protocol identifiers.
- [ ] Ensure native timer/notification code receives already-localized or locale-safe values where Flutter is the source of truth.

### Migration completion gate

- [ ] Audit `lib/`, native platform code, and user-facing tests for remaining hard-coded English UI strings.
- [ ] Add a lightweight regression check or documented review rule that makes newly introduced hard-coded UI copy easy to detect.
- [ ] English UI behavior and layout remain functionally unchanged apart from localization plumbing.

## 4. Translation wave 1

For every locale below: translate every active ARB key from the canonical English source, preserve placeholders/ICU syntax exactly, use natural gym/fitness terminology, avoid literal translations that change meaning, run generation/analyze/tests, and inspect representative narrow/wide layouts for clipping or overflow before ticking the locale complete.

- [ ] Spanish (`es`)
- [ ] French (`fr`)
- [ ] German (`de`)
- [ ] Italian (`it`)
- [ ] Portuguese, Brazil (`pt_BR`)
- [ ] Dutch (`nl`)
- [ ] Polish (`pl`)
- [ ] Japanese (`ja`)
- [ ] Korean (`ko`)
- [ ] Simplified Chinese (`zh_CN`)

## 5. Translation quality and layout QA

- [ ] Add automated ARB completeness validation: every supported locale has the same active keys as English and valid placeholder metadata/ICU syntax.
- [ ] Test representative singular/plural/count messages in languages with different plural behavior.
- [ ] Test locale-aware dates, decimal/group separators, durations, percentages, weights, and distances without changing stored numeric values.
- [ ] Exercise text scaling and long-string layouts on phone and desktop widths; fix clipping/overflow by improving layouts rather than shortening translations unnaturally.
- [ ] Verify dialogs, segmented controls, chips, navigation labels, settings rows, graph labels, timer UI, and notification copy with long translations.
- [ ] Verify CJK rendering and font fallback on Android and desktop.
- [ ] Verify screen-reader semantics use localized labels/hints where custom semantics are present.
- [ ] Confirm user-entered exercise/plan/note text is never translated or rewritten.

## 6. Tests, metadata, and release readiness

- [ ] Update widget tests that depend on English labels to use generated localizations or explicitly pin English where the test is not testing localization.
- [ ] Add focused tests for at least one Latin-script alternate locale and one CJK locale across core navigation/settings/workout flows.
- [ ] Ensure integration/Patrol tests remain deterministic by explicitly selecting or pinning a locale where necessary.
- [ ] Localize Play Store metadata for supported locales when the in-app translation for that locale is complete; do not advertise a locale before the app ships it.
- [ ] Add translated store screenshots only when practical; English screenshots may remain shared where store rules permit.
- [ ] Update contributor documentation with the workflow for adding/changing English strings and updating all locale ARBs.
- [ ] Run the full required completion checks: `flutter/bin/dart format .`, `flutter/bin/flutter analyze`, and `flutter/bin/flutter test`.
- [ ] Run relevant Android/integration smoke coverage for locale switching and a non-English workout flow.
- [ ] Perform a final hard-coded-English audit and ARB completeness check.
- [ ] Confirm all first-wave locales are selectable, persist correctly, survive restart, and can complete core Flexify flows.

## Definition of done

Translation work is complete when every checkbox above is satisfied, all first-wave locales have complete reviewed ARBs, locale switching is stable, core layouts tolerate translated text, required tests pass, and no known user-facing English string remains outside the localization system without a documented reason.
