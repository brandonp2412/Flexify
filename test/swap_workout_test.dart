import 'package:drift/drift.dart';
import 'package:flexify/plan/swap_workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('SwapWorkout', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    final plan = await (harness.database.plans.select()..limit(1)).getSingle();
    final planExercises = await (harness.database.planExercises.select()
          ..where((exercise) => exercise.planId.equals(plan.id)))
        .get();

    await harness.pump(
      tester,
      Scaffold(
        body: SwapWorkout(
          exercise: planExercises.first.exercise,
          planId: plan.id,
        ),
      ),
    );

    expect(find.text('Swap workout'), findsOne);

    await tester.pumpAndSettle();
    expect(find.text('Arnold press'), findsOne);

    await tester.tap(find.text('Arnold press'));
    await tester.pumpAndSettle();
    expect(find.text('Swap workout'), findsNothing);
  });
}
