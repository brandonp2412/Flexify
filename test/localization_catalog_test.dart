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
  'languageNameTurkish',
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
  'zh': {},
  'zh_CN': {},
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

const _playStoreLocales = <String>{
  'de-DE',
  'es-ES',
  'fr-FR',
  'it-IT',
  'ja-JP',
  'ko-KR',
  'nl-NL',
  'pl-PL',
  'pt-BR',
  'tr-TR',
  'zh-CN',
};

const _changelogCatalogLocales = <String>{
  'de',
  'es',
  'fr',
  'it',
  'ja',
  'ko',
  'nl',
  'pl',
  'pt_BR',
  'tr',
  'zh_CN',
};

const _appStoreLocales = <String>{
  'en-AU',
  'de-DE',
  'es-ES',
  'fr-FR',
  'it',
  'ja',
  'ko',
  'nl-NL',
  'pl',
  'pt-BR',
  'tr',
  'zh-Hans',
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

  test('Play Store phone screenshots cover every shipped locale', () {
    const screenshotLocales = {'en-US', ..._playStoreLocales};

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

  test('current in-app changelog is localized for every shipped locale', () {
    final changelogFiles =
        Directory('assets/changelogs')
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.txt'))
            .toList()
          ..sort((a, b) {
            final aName = int.parse(a.uri.pathSegments.last.split('.').first);
            final bName = int.parse(b.uri.pathSegments.last.split('.').first);
            return bName.compareTo(aName);
          });

    expect(changelogFiles, isNotEmpty);
    final latestFile = changelogFiles.first;
    final latestKey = latestFile.uri.pathSegments.last.split('.').first;
    final english = latestFile.readAsStringSync().trim();

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
        catalog[latestKey],
        isA<String>(),
        reason: '$locale is missing the current changelog $latestKey.',
      );
      expect(
        (catalog[latestKey] as String).trim(),
        allOf(isNotEmpty, isNot(equals(english))),
        reason: '$locale must localize the current in-app changelog.',
      );
    }

    final sourceKeys = changelogFiles
        .map((file) => file.uri.pathSegments.last.split('.').first)
        .toSet();
    for (final locale in _changelogCatalogLocales) {
      final catalog =
          jsonDecode(
                File('assets/changelogs/l10n/$locale.json').readAsStringSync(),
              )
              as Map<String, dynamic>;
      expect(
        catalog.keys.toSet(),
        sourceKeys,
        reason: '$locale historical changelog catalog must be complete.',
      );
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

  test('macOS native menu covers every supported non-English locale', () {
    final baseMenu = File(
      'macos/Runner/Base.lproj/MainMenu.xib',
    ).readAsLinesSync();
    final idPattern = RegExp(r'\bid="([^"]+)"');
    final titleIds = baseMenu
        .where((line) => line.contains('title=') && line.contains('id='))
        .map((line) => idPattern.firstMatch(line)?.group(1))
        .whereType<String>()
        .toSet();
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
      'tr',
    ];
    final localizedTitlePattern = RegExp(r'^"([^"]+)\.title"\s*=');

    for (final locale in localeFolders) {
      final file = File('macos/Runner/$locale.lproj/MainMenu.strings');
      expect(file.existsSync(), isTrue, reason: 'Missing macOS $locale menu.');
      final localizedIds = file
          .readAsLinesSync()
          .map((line) => localizedTitlePattern.firstMatch(line)?.group(1))
          .whereType<String>()
          .toSet();
      expect(
        localizedIds,
        titleIds,
        reason: '$locale must translate every native macOS menu title.',
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
