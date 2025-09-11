import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tab_controller.dart';
import 'mock_tests.dart';

void main() async {
  testWidgets('HistoryPage loads', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: HistoryPage(tabController: MockTabController()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Search...'), findsOne);
    expect(find.text('No entries yet'), findsOne);

    await db.close();
  });

  testWidgets('HistoryPage lists items', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());

    await db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 1,
        weight: 90,
        unit: 'kg',
        created: DateTime.now(),
      ),
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 4,
        weight: 80,
        unit: 'kg',
        created: DateTime.now().subtract(const Duration(minutes: 3)),
      ),
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 8,
        weight: 70,
        unit: 'kg',
        created: DateTime.now().subtract(const Duration(minutes: 6)),
      ),
    ]);

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: HistoryPage(tabController: MockTabController()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Search...'), findsOne);
    expect(find.text('Bench press'), findsNWidgets(3));
    expect(find.text('1 x 90 kg'), findsOne);
    expect(find.text('4 x 80 kg'), findsOne);
    expect(find.text('8 x 70 kg'), findsOne);

    await db.close();
  });

  testWidgets('HistoryPage tap tile', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
    await db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 1,
        weight: 90,
        unit: 'kg',
        created: DateTime.now(),
        cardio: Value(false),
      ),
    ]);

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: HistoryPage(tabController: MockTabController()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Bench press'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Weight (kg)'), findsOne);
    expect(find.textContaining('Reps'), findsOne);
    expect(find.textContaining('Name'), findsOne);

    await db.close();
  });

  testWidgets('HistoryPage settings', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: HistoryPage(tabController: MockTabController()),
        ),
      ),
    );

    final menu = find.byTooltip('Show menu');
    await tester.tap(menu);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOne);

    await db.close();
  });

  testWidgets('HistoryPage selects', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
    await db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 1,
        weight: 90,
        unit: 'kg',
        created: DateTime.now(),
      ),
    ]);

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: HistoryPage(tabController: MockTabController()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.longPress(find.text('1 x 90 kg'));
    await tester.pumpAndSettle();

    expect(find.byTooltip('Delete selected'), findsOne);

    await db.close();
  });

  testWidgets('HistoryPage deletes', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
    await db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 1,
        weight: 90,
        unit: 'kg',
        created: DateTime.now(),
      ),
    ]);

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: HistoryPage(tabController: MockTabController()),
        ),
      ),
    );

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
