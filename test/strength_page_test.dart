import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/strength_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../integration_test/screenshot_test.dart';
import 'mock_tests.dart';

void main() async {
  testWidgets('StrengthPage displays', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);

    exercisesToPopulateTestDB.forEach(
      (key, value) async => await db.into(db.gymSets).insert(
            generateGymSetCompanion(key, value),
          ),
    );

    for (final element in graphData) {
      await db.into(db.gymSets).insert(
            generateGymSetCompanion(
              "Dumbbell shoulder press",
              element.weight,
              reps: element.reps,
              date: element.dateTime,
            ),
          );
    }

    for (var element in plans) {
      await db.into(db.plans).insert(element);
    }

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: DefaultTabController(
            length: 1,
            child: StrengthPage(
              name: 'Dumbbell shoulder press',
              unit: 'kg',
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Dumbbell shoulder press'), findsOne);
    expect(find.text('Metric'), findsOne);
    expect(find.byTooltip('Edit'), findsOne);
    expect(find.byType(LineChart), findsOne);

    await db.close();
  });

  testWidgets('StrengthPage edits', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);

    exercisesToPopulateTestDB.forEach(
      (key, value) async => await db.into(db.gymSets).insert(
            generateGymSetCompanion(key, value),
          ),
    );

    for (final element in graphData) {
      await db.into(db.gymSets).insert(
            generateGymSetCompanion(
              "Dumbbell shoulder press",
              element.weight,
              reps: element.reps,
              date: element.dateTime,
            ),
          );
    }

    for (var element in plans) {
      await db.into(db.plans).insert(element);
    }

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: DefaultTabController(
            length: 1,
            child: StrengthPage(
              name: 'Dumbbell shoulder press',
              unit: 'kg',
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final edit = find.byTooltip('Edit');
    await tester.tap(edit);
    await tester.pumpAndSettle();
    expect(find.text('Update all dumbbell shoulder press'), findsOne);

    await db.close();
  });

  testWidgets('StrengthPage selects metrics', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);

    exercisesToPopulateTestDB.forEach(
      (key, value) async => await db.into(db.gymSets).insert(
            generateGymSetCompanion(key, value),
          ),
    );

    for (final element in graphData) {
      await db.into(db.gymSets).insert(
            generateGymSetCompanion(
              "Dumbbell shoulder press",
              element.weight,
              reps: element.reps,
              date: element.dateTime,
            ),
          );
    }

    for (var element in plans) {
      await db.into(db.plans).insert(element);
    }

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: DefaultTabController(
            length: 1,
            child: StrengthPage(
              name: 'Dumbbell shoulder press',
              unit: 'kg',
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Best weight'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Best reps'));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOne);

    await tester.tap(find.text('Best reps'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('One rep max'));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOne);

    await tester.tap(find.text('One rep max'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Volume'));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOne);

    await db.close();
  });
}
