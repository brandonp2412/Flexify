import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

final _directTextPattern = RegExp(
  r'''(?:const\s+)?(?:Text|SelectableText)\(\s*(["'])([A-Za-z][^"'\n]*)\1''',
);
final _literalUiPropertyPattern = RegExp(
  r'''(?:labelText|hintText|helperText|errorText|tooltip|semanticLabel)\s*:\s*(["'])([A-Za-z][^"'\n]*)\1''',
);
final _richTextPattern = RegExp(
  r'''TextSpan\([^)]*?\btext\s*:\s*(["'])([A-Za-z][^"'\n]*)\1''',
  dotAll: true,
);
final _tooltipMessagePattern = RegExp(
  r'''Tooltip\([^)]*?\bmessage\s*:\s*(["'])([A-Za-z][^"'\n]*)\1''',
  dotAll: true,
);
final _semanticsLabelPattern = RegExp(
  r'''Semantics\([^)]*?\b(?:label|hint|value)\s*:\s*(["'])([A-Za-z][^"'\n]*)\1''',
  dotAll: true,
);
final _stringLabelWidgetPattern = RegExp(
  r'''(?:NavigationDestination|BottomNavigationBarItem|SnackBarAction|DropdownMenuEntry|Tab)\([^)]*?\b(?:label|text)\s*:\s*(["'])([A-Za-z][^"'\n]*)\1''',
  dotAll: true,
);
final _androidNativeLiteralPatterns = <RegExp>[
  RegExp(r'''Toast\.makeText\(\s*[^,\n]+,\s*["'][A-Za-z]''', dotAll: true),
  RegExp(r'''\.setContent(?:Title|Text)\(\s*["'][A-Za-z]'''),
  RegExp(r'''NotificationChannel\(\s*[^,]+,\s*["'][A-Za-z]''', dotAll: true),
  RegExp(r'''\.addAction\(\s*[^,]+,\s*["'][A-Za-z]''', dotAll: true),
  RegExp(r'''\bdescription\s*=\s*["'][A-Za-z]'''),
];

final _placeholderPattern = RegExp(r'\{([A-Za-z][A-Za-z0-9_]*)\s*(?:,|\})');

const _allowedLiteralUiText = <String>{
  'lib/about_page.dart:Brandon Presley',
  'lib/about_page.dart:MIT',
};

const _alwaysEnglishEquivalentKeys = <String>{
  'appTitle',
  'languageNameEnglish',
  'languageNameSpanish',
  'languageNameFrench',
  'languageNameGerman',
  'languageNameItalian',
  'languageNamePortugueseBrazil',
  'languageNameDutch',
  'languageNamePolish',
  'languageNameJapanese',
  'languageNameKorean',
  'languageNameSimplifiedChinese',
  'languageNameTraditionalChinese',
  'languageNameTurkish',
  'languageNameRussian',
  'languageNameHindi',
  'languageNameArabic',
  'languageNameIndonesian',
  'languageNameVietnamese',
  'languageNameBengali',
  'languageNameUrdu',
  'languageNamePersian',
  'languageNameThai',
  'languageNameMalay',
  'stoneUnitShort',
};

const _localeSpecificEnglishEquivalentKeys = <String, Set<String>>{
  'de': {
    'stoneUnit',
    'actionOk',
    'cardio',
    'navTimer',
    'actionPause',
    'filter',
    'versionLabel',
    'nameLabel',
    'tabs',
    'themeSystem',
  },
  'es': {'stoneUnit', 'cardio', 'minutesShort', 'errorLabel'},
  'fr': {
    'stoneUnit',
    'actionOk',
    'cardio',
    'minutesShort',
    'volume',
    'actionPause',
    'addOneMinute',
    'distanceCardio',
    'distanceLabel',
    'distanceWithUnit',
    'formats',
    'imageLabel',
    'kilocaloriesUnit',
    'milesUnit',
    'minutesLabel',
    'notesLabel',
    'notifications',
    'options',
    'versionLabel',
  },
  'it': {
    'stoneUnit',
    'actionOk',
    'cardio',
    'minutesShort',
    'volume',
    'navTimer',
    'backupLabel',
    'databaseLabel',
  },
  'ja': {'actionOk'},
  'ko': {},
  'nl': {
    'stoneUnit',
    'actionOk',
    'cardio',
    'minutesShort',
    'volume',
    'navTimer',
    'filter',
    'databaseLabel',
    'filters',
    'periodWeek',
    'setNumber',
    'timers',
  },
  'pl': {'stoneUnit', 'actionOk', 'cardio', 'minutesShort', 'actionStart'},
  'pt': {
    'stoneUnit',
    'actionOk',
    'cardio',
    'minutesShort',
    'volume',
    'backupLabel',
  },
  'pt_BR': {
    'stoneUnit',
    'actionOk',
    'cardio',
    'minutesShort',
    'volume',
    'backupLabel',
  },
  'tr': {'stoneUnit', 'examplePlanExercises'},
  'ru': {},
  'hi': {},
  'ar': {},
  'id': {},
  'vi': {'stoneUnit', 'examplePlanExercises'},
  'bn': {},
  'ur': {},
  'fa': {},
  'th': {},
  'ms': {'actionOk', 'importData'},
  'zh': {},
  'zh_CN': {},
  'zh_TW': {},
};

const _macOsEnglishEquivalentTitles = <String, Set<String>>{
  'de': {},
  'es': {'Zoom'},
  'fr': {'Services', 'Substitutions', 'Transformations', 'Zoom'},
  'it': {'Zoom'},
  'ja': {},
  'ko': {},
  'nl': {'Spelling', 'Zoom', 'Help'},
  'pl': {},
  'pt-BR': {'Zoom'},
  'tr': {},
  'ru': {},
  'hi': {},
  'ar': {},
  'id': {'Zoom'},
  'vi': {'APP_NAME'},
  'bn': {'APP_NAME'},
  'ur': {'APP_NAME'},
  'fa': {'APP_NAME'},
  'th': {'APP_NAME'},
  'ms': {'APP_NAME'},
  'zh-Hans': {},
  'zh-Hant': {},
};

const _postWaveReviewedKeys = <String>{
  'categoryHelper',
  'manageCategories',
  'manageCategoriesDescription',
  'newCategory',
  'renameCategory',
  'mergeCategory',
  'noCategories',
  'categoryNameRequired',
  'categoryUsageCount',
  'deleteCategoryConfirmation',
};

const _playStoreLocaleByAppLocale = <String, String>{
  'de': 'de-DE',
  'es': 'es-ES',
  'fr': 'fr-FR',
  'it': 'it-IT',
  'ja': 'ja-JP',
  'ko': 'ko-KR',
  'nl': 'nl-NL',
  'pl': 'pl-PL',
  'pt_BR': 'pt-BR',
  'tr': 'tr-TR',
  'ru': 'ru-RU',
  'hi': 'hi-IN',
  'zh_CN': 'zh-CN',
  'zh_TW': 'zh-TW',
};

const _appStoreLocaleByAppLocale = <String, String>{
  'de': 'de-DE',
  'es': 'es-ES',
  'fr': 'fr-FR',
  'it': 'it',
  'ja': 'ja',
  'ko': 'ko',
  'nl': 'nl-NL',
  'pl': 'pl',
  'pt_BR': 'pt-BR',
  'tr': 'tr',
  'ru': 'ru',
  'hi': 'hi',
  'zh_CN': 'zh-Hans',
  'zh_TW': 'zh-Hant',
};

const _storeFallbackOnlyAppLocales = <String>{'pt', 'zh'};

// These locales currently ship in-app but do not yet have the complete
// historical store assets required by the full store-localization checks.
const _appOnlyLocales = <String>{
  'ar',
  'id',
  'vi',
  'bn',
  'ur',
  'fa',
  'th',
  'ms',
};

const _playListingLocaleByAppLocale = <String, String>{
  'ar': 'ar',
  'id': 'id',
  'vi': 'vi',
  'bn': 'bn-BD',
  'ur': 'ur',
  'fa': 'fa',
  'th': 'th',
  'ms': 'ms-MY',
};

const _appStoreListingLocaleByAppLocale = <String, String>{
  'ar': 'ar-SA',
  'id': 'id',
  'vi': 'vi',
  'th': 'th',
  'ms': 'ms',
};

final _playStoreLocales = _playStoreLocaleByAppLocale.values.toSet();

// Google Play uses default-language graphics when localized graphics are omitted.
// https://support.google.com/googleplay/android-developer/answer/9844778
const _playStoreScreenshotFallbackLocales = <String>{'zh-TW', 'hi-IN'};

final _changelogCatalogLocales = _playStoreLocaleByAppLocale.keys.toSet();

final _appStoreLocales = <String>{
  'en-AU',
  ..._appStoreLocaleByAppLocale.values,
};

Map<String, dynamic> _readArb(File file) =>
    jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

Set<String> _messageKeys(Map<String, dynamic> arb) =>
    arb.keys.where((key) => !key.startsWith('@')).toSet();

Set<String> _messagePlaceholders(String message) => _placeholderPattern
    .allMatches(message)
    .map((match) => match.group(1)!)
    .toSet();

Set<String> _metadataPlaceholders(Map<String, dynamic> source, String key) {
  final metadata = source['@$key'];
  if (metadata is! Map<String, dynamic>) return const {};
  final placeholders = metadata['placeholders'];
  if (placeholders is! Map<String, dynamic>) return const {};
  return placeholders.keys.toSet();
}

void main() {
  final sourceFile = File('lib/l10n/app_en.arb');
  final source = _readArb(sourceFile);
  final sourceKeys = _messageKeys(source);

  test('English ARB metadata declares every message placeholder', () {
    for (final key in sourceKeys) {
      final message = source[key] as String;
      expect(
        _metadataPlaceholders(source, key),
        _messagePlaceholders(message),
        reason: 'Placeholder metadata mismatch for English key "$key".',
      );
    }
  });

  test('translated ARBs match English keys and placeholders', () {
    final localeFiles =
        Directory('lib/l10n')
            .listSync()
            .whereType<File>()
            .where(
              (file) =>
                  file.path.endsWith('.arb') &&
                  !file.path.endsWith('app_en.arb'),
            )
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));

    for (final file in localeFiles) {
      final translated = _readArb(file);
      expect(
        _messageKeys(translated),
        sourceKeys,
        reason: '${file.path} must contain every active English message key.',
      );

      for (final key in sourceKeys) {
        expect(
          _messagePlaceholders(translated[key] as String),
          _metadataPlaceholders(source, key),
          reason: '${file.path} has different placeholders for "$key".',
        );
      }
    }
  });

  test('translated ARBs do not silently fall back to English', () {
    final localeFiles =
        Directory('lib/l10n')
            .listSync()
            .whereType<File>()
            .where(
              (file) =>
                  file.path.endsWith('.arb') &&
                  !file.path.endsWith('app_en.arb'),
            )
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));

    for (final file in localeFiles) {
      final translated = _readArb(file);
      final locale = translated['@@locale'] as String;
      final allowedEnglishEquivalentKeys = <String>{
        ..._alwaysEnglishEquivalentKeys,
        ...?_localeSpecificEnglishEquivalentKeys[locale],
      };
      final accidentalEnglishKeys =
          sourceKeys
              .where(
                (key) =>
                    translated[key] == source[key] &&
                    !allowedEnglishEquivalentKeys.contains(key),
              )
              .toList()
            ..sort();

      expect(
        accidentalEnglishKeys,
        isEmpty,
        reason:
            '${file.path} has English-equivalent values that have not been explicitly reviewed.',
      );
    }
  });

  test('post-wave feature strings stay translated', () {
    final localeFiles = Directory('lib/l10n')
        .listSync()
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('.arb') && !file.path.endsWith('app_en.arb'),
        );

    for (final file in localeFiles) {
      final translated = _readArb(file);
      for (final key in _postWaveReviewedKeys) {
        expect(
          translated[key],
          isNot(source[key]),
          reason: '${file.path} still uses English for "$key".',
        );
      }
    }
  });

  test('store locale mappings cover every shipped translated locale', () {
    final translatedAppLocales =
        Directory('lib/l10n')
            .listSync()
            .whereType<File>()
            .where(
              (file) =>
                  file.path.endsWith('.arb') &&
                  !file.path.endsWith('app_en.arb'),
            )
            .map((file) => _readArb(file)['@@locale'] as String)
            .toSet()
          ..removeAll({..._storeFallbackOnlyAppLocales, ..._appOnlyLocales});

    expect(
      _playStoreLocaleByAppLocale.keys.toSet(),
      translatedAppLocales,
      reason:
          'Every shipped translated app locale must map to Google Play metadata.',
    );
    expect(
      _appStoreLocaleByAppLocale.keys.toSet(),
      translatedAppLocales,
      reason:
          'Every shipped translated app locale must map to App Store metadata.',
    );
  });

  test('listing-only locale store copy is localized and release-ready', () {
    const playListingFiles = <String, int>{
      'title.txt': 30,
      'short_description.txt': 80,
      'full_description.txt': 4000,
    };
    for (final entry in _playListingLocaleByAppLocale.entries) {
      final directory = Directory('fastlane/metadata/android/${entry.value}');
      for (final fileEntry in playListingFiles.entries) {
        final localized = File('${directory.path}/${fileEntry.key}');
        final english = File(
          'fastlane/metadata/android/en-US/${fileEntry.key}',
        ).readAsStringSync().trim();
        expect(
          localized.existsSync(),
          isTrue,
          reason: '${entry.value} must provide ${fileEntry.key}.',
        );
        final value = localized.readAsStringSync().trim();
        expect(value, allOf(isNotEmpty, isNot(equals(english))));
        expect(
          value.runes.length,
          lessThanOrEqualTo(fileEntry.value),
          reason: '${entry.value}/${fileEntry.key} exceeds the store limit.',
        );
      }

      final releaseNotes = File('${directory.path}/changelogs/4393.txt');
      expect(
        releaseNotes.existsSync(),
        isTrue,
        reason: '${entry.value} must localize the current Play release notes.',
      );
      expect(
        releaseNotes.readAsStringSync().trim(),
        isNot(
          equals(
            File(
              'fastlane/metadata/android/en-US/changelogs/4393.txt',
            ).readAsStringSync().trim(),
          ),
        ),
      );
    }

    for (final entry in _appStoreListingLocaleByAppLocale.entries) {
      final directory = Directory('fastlane/metadata/${entry.value}');
      for (final filename in const [
        'name.txt',
        'keywords.txt',
        'description.txt',
        'release_notes.txt',
        'support_url.txt',
        'marketing_url.txt',
        'privacy_url.txt',
      ]) {
        final file = File('${directory.path}/$filename');
        expect(
          file.existsSync(),
          isTrue,
          reason: '${entry.value} must provide $filename.',
        );
        expect(
          file.readAsStringSync().trim(),
          isNotEmpty,
          reason: '${entry.value}/$filename must not be empty.',
        );
      }
      expect(
        File('${directory.path}/description.txt').readAsStringSync().trim(),
        isNot(
          equals(
            File(
              'fastlane/metadata/en-AU/description.txt',
            ).readAsStringSync().trim(),
          ),
        ),
      );
      expect(
        File('${directory.path}/release_notes.txt').readAsStringSync().trim(),
        isNot(
          equals(
            File(
              'fastlane/metadata/en-AU/release_notes.txt',
            ).readAsStringSync().trim(),
          ),
        ),
      );
    }
  });

  test('Play Store metadata covers every shipped non-English locale', () {
    for (final locale in _playStoreLocales) {
      final directory = Directory('fastlane/metadata/android/$locale');
      expect(
        directory.existsSync(),
        isTrue,
        reason: 'Missing Play Store metadata directory for $locale.',
      );

      for (final filename in const [
        'title.txt',
        'short_description.txt',
        'full_description.txt',
      ]) {
        final file = File('${directory.path}/$filename');
        expect(
          file.existsSync(),
          isTrue,
          reason: 'Missing $filename for Play Store locale $locale.',
        );
        final localized = file.readAsStringSync().trim();
        final english = File(
          'fastlane/metadata/android/en-US/$filename',
        ).readAsStringSync().trim();
        expect(
          localized,
          allOf(isNotEmpty, isNot(equals(english))),
          reason: '$filename for $locale must be localized.',
        );
      }
    }
  });

  test('Play Store localized screenshot sets are complete', () {
    expect(
      _playStoreScreenshotFallbackLocales.difference(_playStoreLocales),
      isEmpty,
    );
    final screenshotLocales = {
      'en-US',
      ..._playStoreLocales.difference(_playStoreScreenshotFallbackLocales),
    };

    for (final locale in screenshotLocales) {
      final directory = Directory(
        'fastlane/metadata/android/$locale/images/phoneScreenshots',
      );
      expect(
        directory.existsSync(),
        isTrue,
        reason: 'Missing Play Store phone screenshots for $locale.',
      );

      for (var index = 1; index <= 8; index++) {
        expect(
          File('${directory.path}/${index}_$locale.png').existsSync(),
          isTrue,
          reason: 'Missing Play Store screenshot $index for $locale.',
        );
      }
    }
  });

  test('App Store metadata covers every shipped locale', () {
    for (final locale in _appStoreLocales) {
      final directory = Directory('fastlane/metadata/$locale');
      expect(
        directory.existsSync(),
        isTrue,
        reason: 'Missing App Store metadata directory for $locale.',
      );

      for (final filename in const [
        'name.txt',
        'keywords.txt',
        'description.txt',
        'release_notes.txt',
        'support_url.txt',
        'marketing_url.txt',
        'privacy_url.txt',
      ]) {
        final file = File('${directory.path}/$filename');
        expect(
          file.existsSync(),
          isTrue,
          reason: 'Missing $filename for App Store locale $locale.',
        );
        expect(
          file.readAsStringSync().trim(),
          isNotEmpty,
          reason: '$filename for $locale must not be empty.',
        );
      }
    }
  });

  test('App Store textual metadata is localized where English has copy', () {
    const translatedFiles = <String>[
      'description.txt',
      'keywords.txt',
      'release_notes.txt',
      'subtitle.txt',
      'promotional_text.txt',
    ];

    for (final filename in translatedFiles) {
      final english = File(
        'fastlane/metadata/en-AU/$filename',
      ).readAsStringSync().trim();
      if (english.isEmpty) continue;

      for (final locale in _appStoreLocales.where(
        (locale) => locale != 'en-AU',
      )) {
        final localized = File(
          'fastlane/metadata/$locale/$filename',
        ).readAsStringSync().trim();
        expect(
          localized,
          allOf(isNotEmpty, isNot(equals(english))),
          reason: '$filename for App Store locale $locale must be localized.',
        );
      }
    }
  });

  test('in-app changelog history is localized for every shipped locale', () {
    final changelogFiles =
        Directory('assets/changelogs')
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.txt'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    expect(changelogFiles, isNotEmpty);

    final englishByKey = <String, String>{
      for (final file in changelogFiles)
        file.uri.pathSegments.last.split('.').first: file
            .readAsStringSync()
            .trim(),
    };
    final expectedKeys = englishByKey.keys.toSet();

    for (final locale in _changelogCatalogLocales) {
      final file = File('assets/changelogs/l10n/$locale.json');
      expect(
        file.existsSync(),
        isTrue,
        reason: 'Missing in-app changelog catalog for $locale.',
      );

      final catalog =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      expect(
        catalog.keys.toSet(),
        expectedKeys,
        reason: '$locale historical changelog catalog must be complete.',
      );

      for (final entry in englishByKey.entries) {
        final localized = catalog[entry.key];
        expect(
          localized,
          isA<String>(),
          reason: '$locale changelog ${entry.key} must contain text.',
        );

        final english = entry.value;
        if (english.isEmpty || english == 'last_commit') continue;
        expect(
          (localized as String).trim(),
          allOf(isNotEmpty, isNot(equals(english))),
          reason: '$locale must localize in-app changelog ${entry.key}.',
        );
      }
    }
  });

  test('Play Store changelog history is localized for every locale', () {
    final englishFiles =
        Directory('fastlane/metadata/android/en-US/changelogs')
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.txt'))
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    expect(englishFiles, isNotEmpty);

    final englishByName = <String, String>{
      for (final file in englishFiles)
        file.uri.pathSegments.last: file.readAsStringSync().trim(),
    };
    final expectedNames = englishByName.keys.toSet();

    for (final locale in _playStoreLocales) {
      final directory = Directory(
        'fastlane/metadata/android/$locale/changelogs',
      );
      expect(
        directory.existsSync(),
        isTrue,
        reason: 'Missing Play Store changelog directory for $locale.',
      );

      final localizedFiles = directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.txt'))
          .toList();
      final localizedNames = localizedFiles
          .map((file) => file.uri.pathSegments.last)
          .toSet();
      expect(
        localizedNames,
        expectedNames,
        reason:
            '$locale must mirror the complete English Play changelog history.',
      );

      for (final file in localizedFiles) {
        final filename = file.uri.pathSegments.last;
        final english = englishByName[filename]!;
        final localized = file.readAsStringSync().trim();
        if (english.isEmpty || english == 'last_commit') continue;
        expect(
          localized,
          allOf(isNotEmpty, isNot(equals(english))),
          reason: '$locale must localize Play Store changelog $filename.',
        );
      }
    }
  });

  test(
    'App Store release notes are localized for every non-English locale',
    () {
      final english = File(
        'fastlane/metadata/en-AU/release_notes.txt',
      ).readAsStringSync().trim();

      for (final locale in _appStoreLocales.where(
        (locale) => locale != 'en-AU',
      )) {
        final notes = File(
          'fastlane/metadata/$locale/release_notes.txt',
        ).readAsStringSync().trim();
        expect(
          notes,
          allOf(isNotEmpty, isNot(equals(english))),
          reason: '$locale must localize current App Store release notes.',
        );
      }
    },
  );

  test('regional fallback ARBs stay in sync', () {
    const fallbackLocales = {'pt': 'pt_BR', 'zh': 'zh_CN'};

    for (final entry in fallbackLocales.entries) {
      final fallback = Map<String, dynamic>.of(
        _readArb(File('lib/l10n/app_${entry.key}.arb')),
      )..remove('@@locale');
      final regional = Map<String, dynamic>.of(
        _readArb(File('lib/l10n/app_${entry.value}.arb')),
      )..remove('@@locale');

      expect(
        fallback,
        regional,
        reason:
            '${entry.key} is the language fallback for ${entry.value} and must mirror its reviewed translations.',
      );
    }
  });

  test('Flutter UI avoids obvious hard-coded English literals', () {
    final violations = <String>[];
    final dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('.dart') &&
              !file.path.contains('/l10n/generated/'),
        );

    for (final file in dartFiles) {
      final relativePath = file.path.replaceFirst(
        '${Directory.current.path}/',
        '',
      );
      final sourceText = file.readAsStringSync();
      for (final pattern in [
        _directTextPattern,
        _literalUiPropertyPattern,
        _richTextPattern,
        _tooltipMessagePattern,
        _semanticsLabelPattern,
        _stringLabelWidgetPattern,
      ]) {
        for (final match in pattern.allMatches(sourceText)) {
          final literal = match.group(2)!;
          if (_allowedLiteralUiText.contains('$relativePath:$literal'))
            continue;
          final line =
              '\n'.allMatches(sourceText.substring(0, match.start)).length + 1;
          violations.add('$relativePath:$line: $literal');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Move user-facing literals into app_en.arb, or document a true non-translatable exception.',
    );
  });

  test('Android native UI avoids hard-coded English literals', () {
    final violations = <String>[];
    final nativeFiles = Directory('android/app/src/main')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) => file.path.endsWith('.kt') || file.path.endsWith('.java'),
        );

    for (final file in nativeFiles) {
      final relativePath = file.path.replaceFirst(
        '${Directory.current.path}/',
        '',
      );
      final sourceText = file.readAsStringSync();
      for (final pattern in _androidNativeLiteralPatterns) {
        for (final match in pattern.allMatches(sourceText)) {
          final line =
              '\n'.allMatches(sourceText.substring(0, match.start)).length + 1;
          violations.add('$relativePath:$line: ${match.group(0)}');
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason:
          'Pass Android user-visible text through localized Flutter/native values instead of hard-coded English.',
    );
  });

  test('macOS native menu covers every supported non-English locale', () {
    final baseMenu = File(
      'macos/Runner/Base.lproj/MainMenu.xib',
    ).readAsLinesSync();
    final idPattern = RegExp(r'\bid="([^"]+)"');
    final titlePattern = RegExp(r'\btitle="([^"]*)"');
    final baseTitles = <String, String>{};
    for (final line in baseMenu) {
      final id = idPattern.firstMatch(line)?.group(1);
      final title = titlePattern.firstMatch(line)?.group(1);
      if (id != null && title != null) baseTitles[id] = title;
    }
    final titleIds = baseTitles.keys.toSet();
    expect(titleIds, isNotEmpty);

    const localeFolders = <String>[
      'es',
      'fr',
      'de',
      'it',
      'pt-BR',
      'nl',
      'pl',
      'ja',
      'ko',
      'zh-Hans',
      'zh-Hant',
      'tr',
      'ru',
      'hi',
      'ar',
      'id',
      'vi',
      'bn',
      'ur',
      'fa',
      'th',
      'ms',
    ];
    final localizedTitlePattern = RegExp(r'^"([^"]+)\.title"\s*=\s*"(.*)";$');

    for (final locale in localeFolders) {
      final file = File('macos/Runner/$locale.lproj/MainMenu.strings');
      expect(file.existsSync(), isTrue, reason: 'Missing macOS $locale menu.');
      final localizedTitles = <String, String>{};
      for (final line in file.readAsLinesSync()) {
        final match = localizedTitlePattern.firstMatch(line.trim());
        if (match != null) {
          localizedTitles[match.group(1)!] = match.group(2)!;
        }
      }
      expect(
        localizedTitles.keys.toSet(),
        titleIds,
        reason: '$locale must translate every native macOS menu title.',
      );

      final allowedEnglishTitles =
          _macOsEnglishEquivalentTitles[locale] ?? const <String>{};
      final accidentalEnglishTitles = localizedTitles.entries
          .where(
            (entry) =>
                baseTitles[entry.key] == entry.value &&
                !allowedEnglishTitles.contains(entry.value),
          )
          .map((entry) => entry.value)
          .toSet();
      expect(
        accidentalEnglishTitles,
        isEmpty,
        reason:
            '$locale has English-equivalent macOS menu titles that have not been explicitly reviewed.',
      );
    }

    final project = File(
      'macos/Runner.xcodeproj/project.pbxproj',
    ).readAsStringSync();
    final knownRegions = RegExp(
      r'knownRegions = \(([\s\S]*?)\);',
    ).firstMatch(project)?.group(1);
    expect(knownRegions, isNotNull);
    for (final locale in localeFolders) {
      expect(project, contains('$locale.lproj/MainMenu.strings'));
      expect(knownRegions, contains(locale));
    }
  });
}
