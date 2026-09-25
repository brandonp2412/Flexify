import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';

/// Locales that are fully translated and may be selected explicitly.
///
/// Generated localizations can include language-only fallback locales, such as
/// `pt`, that are needed for platform locale resolution but are not separate
/// choices in Flexify's language setting.
const selectableLocales = <Locale>[
  Locale('en'),
  Locale('es'),
  Locale('fr'),
  Locale('de'),
  Locale('it'),
  Locale('pt', 'BR'),
  Locale('nl'),
  Locale('pl'),
  Locale('ja'),
  Locale('ko'),
  Locale('zh', 'CN'),
  Locale('zh', 'TW'),
  Locale('tr'),
  Locale('ru'),
  Locale('hi'),
  Locale('ar'),
  Locale('id'),
  Locale('vi'),
  Locale('bn'),
  Locale('ur'),
];

/// Returns the canonical identifier persisted for a supported [locale].
String localeIdentifier(Locale locale) => locale.toLanguageTag();

/// Resolves a stored locale identifier to a currently supported locale.
///
/// A null, empty, invalid, or no-longer-supported identifier means that the
/// application should follow the system locale.
Locale? localeOverrideFromIdentifier(String? identifier) {
  if (identifier == null || identifier.trim().isEmpty) return null;

  final normalized = identifier.trim().replaceAll('_', '-').toLowerCase();
  for (final locale in selectableLocales) {
    if (locale.toLanguageTag().toLowerCase() == normalized) return locale;
  }

  return null;
}

/// Returns the valid canonical stored identifier, or null for system default.
String? canonicalLocaleOverride(String? identifier) =>
    localeOverrideFromIdentifier(identifier)?.toLanguageTag();

/// Returns a stable display name for a locale exposed by Flexify.
String localeDisplayName(AppLocalizations l10n, Locale locale) {
  return switch (locale.toLanguageTag()) {
    'en' => l10n.languageNameEnglish,
    'es' => l10n.languageNameSpanish,
    'fr' => l10n.languageNameFrench,
    'de' => l10n.languageNameGerman,
    'it' => l10n.languageNameItalian,
    'pt-BR' => l10n.languageNamePortugueseBrazil,
    'nl' => l10n.languageNameDutch,
    'pl' => l10n.languageNamePolish,
    'ja' => l10n.languageNameJapanese,
    'ko' => l10n.languageNameKorean,
    'zh-CN' => l10n.languageNameSimplifiedChinese,
    'zh-TW' => l10n.languageNameTraditionalChinese,
    'tr' => l10n.languageNameTurkish,
    'ru' => l10n.languageNameRussian,
    'hi' => l10n.languageNameHindi,
    'ar' => l10n.languageNameArabic,
    'id' => l10n.languageNameIndonesian,
    'vi' => l10n.languageNameVietnamese,
    'bn' => l10n.languageNameBengali,
    'ur' => l10n.languageNameUrdu,
    _ => locale.toLanguageTag(),
  };
}
