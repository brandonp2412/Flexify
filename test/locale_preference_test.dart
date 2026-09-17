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
      expect(localeOverrideFromIdentifier('removed-locale'), isNull);
      expect(canonicalLocaleOverride('en'), 'en');
      expect(canonicalLocaleOverride('es'), 'es');
      expect(canonicalLocaleOverride('fr'), 'fr');
      expect(canonicalLocaleOverride('de'), 'de');
      expect(canonicalLocaleOverride('it'), 'it');
      expect(canonicalLocaleOverride('pt_BR'), 'pt-BR');
      expect(canonicalLocaleOverride('pt'), isNull);
      expect(canonicalLocaleOverride('nl'), 'nl');
      expect(canonicalLocaleOverride('removed-locale'), isNull);
    },
  );

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
      const SettingsCompanion(localeOverride: Value('removed-locale')),
    );
    await tester.pump();
    await tester.pump();

    app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, isNull);
  });
}
