import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

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
    await db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 1,
        weight: 90,
        unit: 'kg',
        created: DateTime.now(),
      ),
    ]);

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
    await tester.tap(find.text('Bench press'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('1 x 90 kg'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Name'), findsOne);

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
    await db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 1,
        weight: 90,
        unit: 'kg',
        created: DateTime.now(),
      ),
    ]);

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
    await tester.tap(find.text('Bench press'));
    await tester.pumpAndSettle();

    await tester.longPress(find.text('1 x 90 kg'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOne);

    await db.close();
  });

  testWidgets('HistoryPage deletes', (WidgetTester tester) async {
    await mockTests();
    await db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 1,
        weight: 90,
        unit: 'kg',
        created: DateTime.now(),
      ),
    ]);

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
    await tester.tap(find.text('Bench press'));
    await tester.pumpAndSettle();

    await tester.longPress(find.text('1 x 90 kg'));
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
