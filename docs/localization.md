# Localization

Flexify uses Flutter `gen-l10n` with English as the canonical source. User-visible copy belongs in `lib/l10n/app_en.arb`; generated Dart files are written to `lib/l10n/generated/` and must not be edited by hand.

## Message keys

Use descriptive lowerCamelCase keys based on meaning, not widget position. Prefer names such as `deleteWorkoutTitle` or `restTimerSecondsRemaining` over generic names such as `dialogText1`. Reuse a key only when the message has the same meaning in every context.

Every English message must include an `@key` resource attribute with a useful `description`. Dynamic values must be declared as placeholders in that metadata and referenced by the ARB message. Keep placeholder names stable across every locale.

Example:

```json
{
  "setsCompleted": "{count, plural, =0{No sets completed} =1{1 set completed} other{{count} sets completed}}",
  "@setsCompleted": {
    "description": "Number of sets completed in the current workout.",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

Use ICU plural/select messages whenever grammar depends on a count or category. Avoid building visible sentences from localized fragments or string concatenation. Preserve placeholder names, types, and meaning in every translated ARB.

## Visible copy rule

New user-visible English copy in Flutter UI must be added to `app_en.arb` and accessed through `context.l10n` (the thin `BuildContext` extension over generated `AppLocalizations`). Logs, route names, database identifiers, persisted enum values, API/storage values, package identifiers, and user-entered content remain unchanged unless they are separately rendered as UI copy.

Do not add a locale to the app or store metadata until its active ARB contains every English message with reviewed translations and matching ICU/placeholders. English extraction is completed before the first translation wave.

## Validation

`test/localization_catalog_test.dart` enforces the localization catalog contract. It checks that English placeholder metadata matches the source messages, every translated ARB has the same active keys and placeholders as English, and obvious literal English passed directly to common Flutter text/label APIs is rejected unless it is a documented non-translatable proper name.

Run `flutter gen-l10n` after changing any ARB, then run the normal analyzer and test suite. Generated localization files are committed so CI and release builds use the same catalog that was validated locally.

## Store screenshots

Android screenshot generation defaults to the existing English (`en-US`) listing. To generate translated Play Store screenshots, set `FLEXIFY_SCREENSHOT_LOCALES` to a comma-separated list of store locale identifiers before running `scripts/screenshots-android.sh` or `scripts/screenshots-waydroid.sh`, for example `de-DE,ja-JP,zh-CN`. The integration harness maps each store locale to Flexify's persisted app locale and writes screenshots under that locale's `fastlane/metadata/android/<locale>/images/` directory.

Keep user-entered fixture content unchanged in screenshots. Locale selection applies only to Flexify-owned interface copy, formatting, and semantics.
