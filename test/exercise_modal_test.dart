import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/exercise_modal.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() {
  testWidgets(
    'ExerciseModal edit does not crash when exercise has no recorded sets',
    (WidgetTester tester) async {
      await mockTests();
      db = AppDatabase(NativeDatabase.memory());

      final id = await db.plans.insertOne(
        PlansCompanion.insert(days: 'Monday'),
      );
      await db.planExercises.insertOne(
        PlanExercisesCompanion.insert(
          planId: id,
          exercise: 'Bench press',
          enabled: true,
        ),
      );
      // No gym sets inserted — getSingle() would throw before fix

      final settings = await (db.settings.select()..limit(1)).getSingle();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => SettingsState(settings),
            ),
            ChangeNotifierProvider(create: (context) => TimerState()),
            ChangeNotifierProvider(create: (context) => PlanState()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ExerciseModal(
                exercise: 'Bench press',
                hasData: true, // true, but no actual sets in DB
                planId: id,
                onSelect: () {},
                onMax: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap Edit — before fix: throws StateError from getSingle()
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();

      await db.close();
    },
  );

  testWidgets(
    'ExerciseModal undo does not crash when exercise has no recorded sets',
    (WidgetTester tester) async {
      await mockTests();
      db = AppDatabase(NativeDatabase.memory());

      final id = await db.plans.insertOne(
        PlansCompanion.insert(days: 'Monday'),
      );
      await db.planExercises.insertOne(
        PlanExercisesCompanion.insert(
          planId: id,
          exercise: 'Bench press',
          enabled: true,
        ),
      );

      final settings = await (db.settings.select()..limit(1)).getSingle();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => SettingsState(settings),
            ),
            ChangeNotifierProvider(create: (context) => TimerState()),
            ChangeNotifierProvider(create: (context) => PlanState()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ExerciseModal(
                exercise: 'Bench press',
                hasData: true,
                planId: id,
                onSelect: () {},
                onMax: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap Undo — before fix: throws StateError from getSingle()
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();

      await db.close();
    },
  );
}
