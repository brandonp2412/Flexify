Any contributions are welcome.

PRs to do with performance make me the happiest.

## Localization

Flexify uses Flutter `gen-l10n`, with `lib/l10n/app_en.arb` as the canonical source for user-visible text. Add or change English messages there first, including `@key` metadata and placeholder definitions, then update every supported locale ARB with the same active keys and placeholders. Keep storage values, route names, package identifiers, logs, and user-entered content untranslated.

After changing localization resources, run `flutter gen-l10n`, `dart format .`, `flutter analyze`, and `flutter test`. The catalog validation in `test/localization_catalog_test.dart` checks locale completeness, placeholders, and obvious hard-coded UI literals. See `docs/localization.md` for the full workflow and message-key conventions.
