import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/cardio_page.dart';
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
  testWidgets('CardioPage displays', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory());
    for (final element in graphData) {
      await db.into(db.gymSets).insert(
            generateGymSetCompanion(
              "Run",
              element.weight,
              reps: element.reps,
              date: element.dateTime,
            ).copyWith(cardio: const Value(true)),
          );
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
          home: CardioPage(
            name: 'Run',
            unit: 'km',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Run'), findsOne);
    expect(find.text('Pace (distance / time)'), findsOne);
    expect(find.text('Start date'), findsOne);
    expect(find.text('Stop date'), findsOne);
    expect(find.byTooltip('Edit'), findsOne);
    expect(find.byType(LineChart), findsOne);

    await db.close();
  });

  testWidgets('CardioPage edits', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory());
    for (final element in graphData) {
      await db.into(db.gymSets).insert(
            generateGymSetCompanion(
              "Run",
              element.weight,
              reps: element.reps,
              date: element.dateTime,
            ).copyWith(cardio: const Value(true)),
          );
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
          home: CardioPage(
            name: 'Run',
            unit: 'km',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    final edit = find.byTooltip('Edit');
    await tester.tap(edit);
    await tester.pumpAndSettle();
    expect(find.text('Edit run'), findsOne);

    await db.close();
  });

  testWidgets('CardioPage selects metrics', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory());
    for (final element in graphData) {
      await db.into(db.gymSets).insert(
            generateGymSetCompanion(
              "Run",
              element.weight,
              reps: element.reps,
              date: element.dateTime,
            ).copyWith(cardio: const Value(true)),
          );
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
          home: CardioPage(
            name: 'Run',
            unit: 'km',
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Pace (distance / time)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duration'));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOne);

    await tester.tap(find.text('Duration'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Distance'));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOne);

    await db.close();
  });
}
