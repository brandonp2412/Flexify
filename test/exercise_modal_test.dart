import 'package:drift/drift.dart';
import 'package:flexify/plan/exercise_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixtures.dart';
import 'support/test_app.dart';

Future<(FlexifyTestHarness, int)> pumpExerciseModal(
  WidgetTester tester,
) async {
  final harness = await FlexifyTestHarness.create();
  final id = await harness.database.plans.insertOne(planFixture());
  await harness.database.planExercises.insertOne(
    planExerciseFixture(planId: id, exercise: 'Bench press'),
  );

  await harness.pump(
    tester,
    Scaffold(
      body: ExerciseModal(
        exercise: 'Bench press',
        hasData: true,
        planId: id,
        onSelect: () {},
        onMax: () {},
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
