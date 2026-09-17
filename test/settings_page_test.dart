import 'package:drift/drift.dart' hide isNull;
import 'package:flexify/database/database.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

Future<FlexifyTestHarness> render(
  WidgetTester tester, {
  Locale? locale,
  Size? surfaceSize,
  TextScaler? textScaler,
}) async {
  final harness = await FlexifyTestHarness.create();
  await harness.pump(
    tester,
    const SettingsPage(),
    locale: locale,
    surfaceSize: surfaceSize,
    textScaler: textScaler,
  );
  await tester.pumpAndSettle();
  return harness;
}

void main() {
  testWidgets('SettingsPage searches', (WidgetTester tester) async {
    await render(tester);
    expect(find.text('Settings'), findsOne);
    expect(find.text('Search...'), findsOne);

    await tester.enterText(find.bySemanticsLabel('Search...'), 'Show units');
    await tester.pumpAndSettle();

    expect(find.textContaining('Appearance'), findsNothing);
    expect(find.widgetWithText(ListTile, 'Show units'), findsOne);
  });

  testWidgets('SettingsPage changes theme', (WidgetTester tester) async {
    await render(tester);

    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    expect(find.text('Light'), findsOne);
  });

  testWidgets('SettingsPage searches and persists language', (
    WidgetTester tester,
  ) async {
    final harness = await render(tester);

    await tester.enterText(find.bySemanticsLabel('Search...'), 'Language');
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ListTile, 'Language'), findsOneWidget);
    expect(find.text('Español'), findsNothing);

    await tester.tap(find.byKey(const Key('language-setting-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    var settings = await (harness.database.settings.select()..limit(1))
        .getSingle();
    expect(settings.localeOverride, 'en');

    await tester.tap(find.byKey(const Key('language-setting-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('System default').last);
    await tester.pumpAndSettle();

    settings = await (harness.database.settings.select()..limit(1)).getSingle();
    expect(settings.localeOverride, isNull);
  });

  testWidgets('SettingsPage renders Spanish at narrow scaled layout', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('es'),
      surfaceSize: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );

    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('Buscar...'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.enterText(find.bySemanticsLabel('Buscar...'), 'Idioma');
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ListTile, 'Idioma'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsPage renders Spanish at desktop width', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('es'),
      surfaceSize: const Size(1200, 800),
    );

    expect(find.text('Ajustes'), findsOneWidget);
    expect(find.text('Buscar...'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsPage renders French at narrow scaled layout', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('fr'),
      surfaceSize: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );

    expect(find.text('Paramètres'), findsOneWidget);
    expect(find.text('Rechercher...'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.enterText(find.bySemanticsLabel('Rechercher...'), 'Langue');
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ListTile, 'Langue'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsPage renders French at desktop width', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('fr'),
      surfaceSize: const Size(1200, 800),
    );

    expect(find.text('Paramètres'), findsOneWidget);
    expect(find.text('Rechercher...'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsPage renders German at narrow scaled layout', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('de'),
      surfaceSize: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );

    expect(find.text('Einstellungen'), findsOneWidget);
    expect(find.text('Suchen...'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.enterText(find.bySemanticsLabel('Suchen...'), 'Sprache');
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ListTile, 'Sprache'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsPage renders German at desktop width', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('de'),
      surfaceSize: const Size(1200, 800),
    );

    expect(find.text('Einstellungen'), findsOneWidget);
    expect(find.text('Suchen...'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsPage renders Italian at narrow scaled layout', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('it'),
      surfaceSize: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );

    expect(find.text('Impostazioni'), findsOneWidget);
    expect(find.text('Cerca...'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.enterText(find.bySemanticsLabel('Cerca...'), 'Lingua');
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ListTile, 'Lingua'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsPage renders Italian at desktop width', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('it'),
      surfaceSize: const Size(1200, 800),
    );

    expect(find.text('Impostazioni'), findsOneWidget);
    expect(find.text('Cerca...'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'SettingsPage renders Brazilian Portuguese at narrow scaled layout',
    (WidgetTester tester) async {
      await render(
        tester,
        locale: const Locale('pt', 'BR'),
        surfaceSize: const Size(320, 640),
        textScaler: const TextScaler.linear(1.5),
      );

      expect(find.text('Configurações'), findsOneWidget);
      expect(find.text('Pesquisar...'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.enterText(find.bySemanticsLabel('Pesquisar...'), 'Idioma');
      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, 'Idioma'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('SettingsPage renders Brazilian Portuguese at desktop width', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('pt', 'BR'),
      surfaceSize: const Size(1200, 800),
    );

    expect(find.text('Configurações'), findsOneWidget);
    expect(find.text('Pesquisar...'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsPage renders Dutch at narrow scaled layout', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('nl'),
      surfaceSize: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );

    expect(find.text('Instellingen'), findsOneWidget);
    expect(find.text('Zoeken...'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.enterText(find.bySemanticsLabel('Zoeken...'), 'Taal');
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ListTile, 'Taal'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsPage renders Dutch at desktop width', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('nl'),
      surfaceSize: const Size(1200, 800),
    );

    expect(find.text('Instellingen'), findsOneWidget);
    expect(find.text('Zoeken...'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsPage shows images', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.settings.update().write(
      const SettingsCompanion(showImages: Value(false)),
    );
    await harness.pump(tester, const SettingsPage());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show images'));
    await tester.pumpAndSettle();

    final settings = await (harness.database.settings.select()..limit(1))
        .getSingle();
    expect(settings.showImages, equals(true));
  });
}
