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
    planExerciseFixture(planId: id, exerciseId: exercise.id),
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

  testWidgets('ExerciseModal reports when there is no previous session', (
    WidgetTester tester,
  ) async {
    await pumpExerciseModal(tester);

    await tester.tap(find.text('Previous Time Info'));
    await tester.pumpAndSettle();

    expect(
      find.text(
        'No previous sessions recorded for this exercise before today.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('ExerciseModal shows the sets from the previous day', (
    WidgetTester tester,
  ) async {
    final (harness, _) = await pumpExerciseModal(tester);
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    await insertExerciseSetFixture(
      harness.database,
      'Bench press',
      created: DateTime(yesterday.year, yesterday.month, yesterday.day, 9),
      reps: 8,
      weight: 90,
    );

    await tester.tap(find.text('Previous Time Info'));
    await tester.pumpAndSettle();

    expect(find.text('8 x 90 kg'), findsOneWidget);
    expect(find.text('Set 1'), findsOneWidget);
    expect(find.text('Bench press (1)'), findsOneWidget);
  });
}
