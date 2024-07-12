import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  render(WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory());
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('SettingsPage searches', (WidgetTester tester) async {
    await render(tester);
    expect(find.text('Settings'), findsOne);
    expect(find.text('Search...'), findsOne);

    await tester.enterText(find.bySemanticsLabel('Search...'), 'Show units');
    await tester.pumpAndSettle();

    expect(find.textContaining('Appearance'), findsNothing);
    expect(find.widgetWithText(ListTile, 'Show units'), findsOne);

    await db.close();
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

    await db.close();
  });

  testWidgets('SettingsPage shows images', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(executor: NativeDatabase.memory());
    await (db.settings.update())
        .write(const SettingsCompanion(showImages: Value(false)));
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Appearance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Show images'));
    await tester.pumpAndSettle();
    final settings = await (db.settings.select()..limit(1)).getSingle();
    expect(settings.showImages, equals(true));

    await db.close();
  });
}
