import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

Future<FlexifyTestHarness> render(WidgetTester tester) async {
  final harness = await FlexifyTestHarness.create();
  await harness.pump(tester, const SettingsPage());
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
