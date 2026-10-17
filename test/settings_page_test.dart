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

  testWidgets('Workout settings reveal graph options on demand', (
    WidgetTester tester,
  ) async {
    await render(tester);
    await tester.tap(find.text('Workouts'));
    await tester.pumpAndSettle();

    expect(find.text('Show body weight'), findsOneWidget);
    expect(find.text('Default graph metric'), findsNothing);

    await tester.scrollUntilVisible(find.text('Graphs'), 200);
    await Scrollable.ensureVisible(
      tester.element(find.text('Graphs')),
      alignment: 0.5,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Graphs'));
    await tester.pumpAndSettle();

    expect(find.text('Default graph metric'), findsOneWidget);
  });

  testWidgets('Plan warmup setting displays an actual zero', (
    WidgetTester tester,
  ) async {
    await render(tester);
    await tester.enterText(find.bySemanticsLabel('Search...'), 'Warmup sets');
    await tester.pumpAndSettle();
    final field = tester.widget<TextField>(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.labelText == 'Warmup sets',
      ),
    );
    expect(field.controller?.text, '0');
    expect(field.decoration?.hintText, isNull);
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

    expect(find.byKey(const Key('language-setting-dropdown')), findsOneWidget);
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

    expect(find.byKey(const Key('language-setting-dropdown')), findsOneWidget);
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

  testWidgets('SettingsPage renders Polish at narrow scaled layout', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('pl'),
      surfaceSize: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );

    expect(find.text('Ustawienia'), findsOneWidget);
    expect(find.text('Szukaj...'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.enterText(find.bySemanticsLabel('Szukaj...'), 'Język');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('language-setting-dropdown')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsPage renders Polish at desktop width', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('pl'),
      surfaceSize: const Size(1200, 800),
    );

    expect(find.text('Ustawienia'), findsOneWidget);
    expect(find.text('Szukaj...'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsPage renders Japanese at narrow scaled layout', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('ja'),
      surfaceSize: const Size(320, 640),
      textScaler: const TextScaler.linear(1.5),
    );

    expect(find.text('設定'), findsOneWidget);
    expect(find.text('検索...'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.enterText(find.bySemanticsLabel('検索...'), '言語');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('language-setting-dropdown')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SettingsPage renders Japanese at desktop width', (
    WidgetTester tester,
  ) async {
    await render(
      tester,
      locale: const Locale('ja'),
      surfaceSize: const Size(1200, 800),
    );

    expect(find.text('設定'), findsOneWidget);
    expect(find.text('検索...'), findsOneWidget);
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
