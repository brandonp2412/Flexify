import 'package:drift/drift.dart';
import 'package:flexify/plan/exercise_modal.dart';
import 'package:flexify/plan/workout_sessions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixtures.dart';
import 'support/test_app.dart';

Future<(FlexifyTestHarness, int)> pumpExerciseModal(WidgetTester tester) async {
  final harness = await FlexifyTestHarness.create();
  final id = await harness.database.plans.insertOne(planFixture());
  final exercise = await ensureExerciseFixture(harness.database, 'Bench press');
  final planExercise = await harness.database.planExercises.insertReturning(
    planExerciseFixture(
      planId: id,
      exercise: exercise.name,
      exerciseId: exercise.id,
    ),
  );
  final workout = await resumeOrStartWorkout(harness.database, id);

  await harness.pump(
    tester,
    Scaffold(
      body: ExerciseModal(
        planExerciseId: planExercise.id,
        exerciseId: exercise.id,
        exerciseName: exercise.name,
        workoutId: workout.id,
        hasData: true,
        onSelect: () {},
      ),
    ),
  );
  await tester.pumpAndSettle();
  return (harness, id);
}

void main() {
  testWidgets(
    'ExerciseModal edit does not crash when exercise has no recorded sets',
    (WidgetTester tester) async {
      await pumpExerciseModal(tester);

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'ExerciseModal undo does not crash when exercise has no recorded sets',
    (WidgetTester tester) async {
      await pumpExerciseModal(tester);

      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
    },
  );
}
