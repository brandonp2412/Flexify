import 'package:drift/drift.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/plan/swap_workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('SwapWorkout', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    final plan = await (harness.database.plans.select()..limit(1)).getSingle();
    final planExercises =
        await (harness.database.planExercises.select()
              ..where((exercise) => exercise.planId.equals(plan.id)))
            .get();
    final original = planExercises.first;

    await harness.pump(
      tester,
      Scaffold(body: SwapWorkout(planExerciseId: original.id)),
    );

    expect(find.text('Swap workout'), findsOne);

    await tester.pumpAndSettle();
    expect(find.text('Arnold press'), findsOne);

    await tester.tap(find.text('Arnold press'));
    await tester.pumpAndSettle();
    expect(find.text('Swap workout'), findsNothing);

    final updatedPlanExercises =
        await (harness.database.planExercises.select()
              ..where((exercise) => exercise.planId.equals(plan.id)))
            .get();
    expect(updatedPlanExercises, hasLength(planExercises.length));
    final swapped = updatedPlanExercises.singleWhere(
      (exercise) => exercise.id == original.id,
    );
    final arnoldPress =
        await (harness.database.exercises.select()
              ..where((exercise) => exercise.name.equals('Arnold press')))
            .getSingle();
    expect(swapped.exerciseId, arnoldPress.id);
    expect(swapped.sequence, original.sequence);
    expect(swapped.enabled, original.enabled);
    expect(swapped.timers, original.timers);
    expect(swapped.maxSets, original.maxSets);
    expect(swapped.warmupSets, original.warmupSets);
  });

  testWidgets('SwapWorkout can create and select a new exercise', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final plan = await (harness.database.plans.select()..limit(1)).getSingle();
    final original =
        await (harness.database.planExercises.select()
              ..where((exercise) => exercise.planId.equals(plan.id))
              ..limit(1))
            .getSingle();

    await harness.pump(
      tester,
      Scaffold(body: SwapWorkout(planExerciseId: original.id)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Cable reverse fly');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('create-swap-exercise')));
    await tester.pumpAndSettle();

    expect(find.byType(AddExercisePage), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(find.byType(TextFormField).first)
          .controller!
          .text,
      'Cable reverse fly',
    );

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Swap workout'), findsNothing);
    final created =
        await (harness.database.exercises.select()
              ..where((exercise) => exercise.name.equals('Cable reverse fly')))
            .getSingle();
    final swapped =
        await (harness.database.planExercises.select()
              ..where((exercise) => exercise.id.equals(original.id)))
            .getSingle();
    expect(swapped.exerciseId, created.id);
  });
}
