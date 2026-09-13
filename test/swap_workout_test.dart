import 'package:drift/drift.dart';
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
      Scaffold(
        body: SwapWorkout(exercise: original.exercise, planId: plan.id),
      ),
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
    expect(swapped.exercise, 'Arnold press');
    expect(swapped.sequence, original.sequence);
    expect(swapped.enabled, original.enabled);
    expect(swapped.timers, original.timers);
    expect(swapped.maxSets, original.maxSets);
    expect(swapped.warmupSets, original.warmupSets);
  });
}
