import 'package:drift/drift.dart' hide isNull;
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/locale_preferences.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';

void main() {
  test(
    'locale override accepts supported identifiers and rejects stale ones',
    () {
      expect(localeOverrideFromIdentifier(null), isNull);
      expect(localeOverrideFromIdentifier(''), isNull);
      expect(localeOverrideFromIdentifier('en'), const Locale('en'));
      expect(localeOverrideFromIdentifier('EN'), const Locale('en'));
      expect(localeOverrideFromIdentifier('es'), const Locale('es'));
      expect(localeOverrideFromIdentifier('ES'), const Locale('es'));
      expect(localeOverrideFromIdentifier('fr'), const Locale('fr'));
      expect(localeOverrideFromIdentifier('FR'), const Locale('fr'));
      expect(localeOverrideFromIdentifier('de'), const Locale('de'));
      expect(localeOverrideFromIdentifier('DE'), const Locale('de'));
      expect(localeOverrideFromIdentifier('it'), const Locale('it'));
      expect(localeOverrideFromIdentifier('IT'), const Locale('it'));
      expect(localeOverrideFromIdentifier('pt-BR'), const Locale('pt', 'BR'));
      expect(localeOverrideFromIdentifier('pt_BR'), const Locale('pt', 'BR'));
      expect(localeOverrideFromIdentifier('PT-br'), const Locale('pt', 'BR'));
      expect(localeOverrideFromIdentifier('pt'), isNull);
      expect(localeOverrideFromIdentifier('nl'), const Locale('nl'));
      expect(localeOverrideFromIdentifier('NL'), const Locale('nl'));
      expect(localeOverrideFromIdentifier('pl'), const Locale('pl'));
      expect(localeOverrideFromIdentifier('PL'), const Locale('pl'));
      expect(localeOverrideFromIdentifier('ja'), const Locale('ja'));
      expect(localeOverrideFromIdentifier('JA'), const Locale('ja'));
      expect(localeOverrideFromIdentifier('ko'), const Locale('ko'));
      expect(localeOverrideFromIdentifier('KO'), const Locale('ko'));
      expect(localeOverrideFromIdentifier('tr'), const Locale('tr'));
      expect(localeOverrideFromIdentifier('TR'), const Locale('tr'));
      expect(localeOverrideFromIdentifier('ru'), const Locale('ru'));
      expect(localeOverrideFromIdentifier('RU'), const Locale('ru'));
      expect(localeOverrideFromIdentifier('hi'), const Locale('hi'));
      expect(localeOverrideFromIdentifier('HI'), const Locale('hi'));
      expect(localeOverrideFromIdentifier('ar'), const Locale('ar'));
      expect(localeOverrideFromIdentifier('AR'), const Locale('ar'));
      expect(localeOverrideFromIdentifier('zh-CN'), const Locale('zh', 'CN'));
      expect(localeOverrideFromIdentifier('zh_CN'), const Locale('zh', 'CN'));
      expect(localeOverrideFromIdentifier('ZH-cn'), const Locale('zh', 'CN'));
      expect(localeOverrideFromIdentifier('zh-TW'), const Locale('zh', 'TW'));
      expect(localeOverrideFromIdentifier('zh_TW'), const Locale('zh', 'TW'));
      expect(localeOverrideFromIdentifier('ZH-tw'), const Locale('zh', 'TW'));
      expect(localeOverrideFromIdentifier('zh'), isNull);
      expect(localeOverrideFromIdentifier('removed-locale'), isNull);
      expect(canonicalLocaleOverride('en'), 'en');
      expect(canonicalLocaleOverride('es'), 'es');
      expect(canonicalLocaleOverride('fr'), 'fr');
      expect(canonicalLocaleOverride('de'), 'de');
      expect(canonicalLocaleOverride('it'), 'it');
      expect(canonicalLocaleOverride('pt_BR'), 'pt-BR');
      expect(canonicalLocaleOverride('pt'), isNull);
      expect(canonicalLocaleOverride('nl'), 'nl');
      expect(canonicalLocaleOverride('pl'), 'pl');
      expect(canonicalLocaleOverride('ja'), 'ja');
      expect(canonicalLocaleOverride('ko'), 'ko');
      expect(canonicalLocaleOverride('tr'), 'tr');
      expect(canonicalLocaleOverride('ru'), 'ru');
      expect(canonicalLocaleOverride('hi'), 'hi');
      expect(canonicalLocaleOverride('ar'), 'ar');
      expect(canonicalLocaleOverride('zh_CN'), 'zh-CN');
      expect(canonicalLocaleOverride('zh_TW'), 'zh-TW');
      expect(canonicalLocaleOverride('zh'), isNull);
      expect(canonicalLocaleOverride('removed-locale'), isNull);
      expect(selectableLocales.map((locale) => locale.toLanguageTag()), [
        'en',
        'es',
        'fr',
        'de',
        'it',
        'pt-BR',
        'nl',
        'pl',
        'ja',
        'ko',
        'zh-CN',
        'zh-TW',
        'tr',
        'ru',
        'hi',
        'ar',
      ]);
    },
  );

  testWidgets('all translated locale choices survive app provider restart', (
    tester,
  ) async {
    await mockTests();
    final database = testDb();
    db = database;
    addTearDown(database.close);
    final localeCases = <String, Locale>{
      'es': const Locale('es'),
      'fr': const Locale('fr'),
      'de': const Locale('de'),
      'it': const Locale('it'),
      'pt-BR': const Locale('pt', 'BR'),
      'nl': const Locale('nl'),
      'pl': const Locale('pl'),
      'ja': const Locale('ja'),
      'ko': const Locale('ko'),
      'tr': const Locale('tr'),
      'ru': const Locale('ru'),
      'hi': const Locale('hi'),
      'ar': const Locale('ar'),
      'zh-CN': const Locale('zh', 'CN'),
      'zh-TW': const Locale('zh', 'TW'),
    };

    for (final entry in localeCases.entries) {
      await database.settings.update().write(
        SettingsCompanion(localeOverride: Value(entry.key)),
      );
      final reloaded = await (database.settings.select()..limit(1)).getSingle();
      expect(reloaded.localeOverride, entry.key);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      await tester.pumpWidget(appProviders(reloaded));
      await tester.pump();

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.locale, entry.value, reason: entry.key);
    }
  });

  testWidgets('app applies persisted locale changes without restart', (
    tester,
  ) async {
    await mockTests();
    final database = testDb();
    db = database;
    addTearDown(database.close);

    final initial = await (database.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(appProviders(initial));
    await tester.pump();

    MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, isNull);

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('es')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('es'));
    expect(
      (await (database.settings.select()..limit(1)).getSingle()).localeOverride,
      'es',
    );

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('fr')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('fr'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('de')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('de'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('it')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('it'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('pt-BR')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('pt', 'BR'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('nl')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('nl'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('pl')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('pl'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('ja')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('ja'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('ko')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('ko'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('zh-CN')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('zh', 'CN'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('zh-TW')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('zh', 'TW'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('tr')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('tr'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('ru')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('ru'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('hi')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, const Locale('hi'));

    await database.settings.update().write(
      const SettingsCompanion(localeOverride: Value('removed-locale')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, isNull);
  });
}
