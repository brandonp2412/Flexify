import 'package:flexify/history_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('HistoryPage lists items', (WidgetTester tester) async {
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: HistoryPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Search...'), findsOne);
    expect(find.byType(ListTile), findsWidgets);

    await db.close();
  });

  testWidgets('HistoryPage add button', (WidgetTester tester) async {
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: HistoryPage(),
        ),
      ),
    );

    final add = find.byTooltip('Add');
    await tester.tap(add);
    await tester.pumpAndSettle();

    await db.close();
  });

  testWidgets('HistoryPage tap tile', (WidgetTester tester) async {
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: HistoryPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final tile = find.byType(ListTile).first;
    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.textContaining('Edit'), findsOne);

    await db.close();
  });

  testWidgets('HistoryPage settings', (WidgetTester tester) async {
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: HistoryPage(),
        ),
      ),
    );

    final menu = find.byTooltip('Show menu');
    await tester.tap(menu);
    await tester.pumpAndSettle();

    final settings = find.text('Settings');
    await tester.tap(settings);
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOne);

    await db.close();
  });

  testWidgets('HistoryPage selects', (WidgetTester tester) async {
    await mockTests();
    SharedPreferences.setMockInitialValues({
      "groupHistory": false,
    });
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: HistoryPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final tile = find.byType(ListTile).first;
    await tester.longPress(tile);
    await tester.pumpAndSettle();
    expect(find.text('1 selected'), findsOne);

    await db.close();
  });

  testWidgets('HistoryPage deletes', (WidgetTester tester) async {
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: HistoryPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final tile = find.byType(ListTile).first;

    await tester.longPress(tile);
    await tester.pumpAndSettle();

    final delete = find.byTooltip('Delete selected');
    await tester.tap(delete);
    await tester.pumpAndSettle();

    expect(find.text('Confirm Delete'), findsOne);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Search...'), findsOne);

    await db.close();
  });
}
