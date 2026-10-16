import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/plan/plans_list.dart';
import 'package:flexify/plan/workout_sessions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixtures.dart';
import 'support/test_app.dart';

void main() {
  testWidgets('PlanList', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.planExercises.deleteAll();
    await harness.database.plans.deleteAll();

    final planId = await harness.database.plans.insertOne(planFixture(id: 1));
    final planExercise = await insertPlanExerciseFixture(
      harness.database,
      planId: planId,
      exercise: 'Bench press',
    );
    final exercise =
        await (harness.database.exercises.select()
              ..where((row) => row.id.equals(planExercise.exerciseId)))
            .getSingle();

    final scroll = ScrollController();
    addTearDown(scroll.dispose);
    final exercises = [
      PlanExerciseEntry(planExercise: planExercise, exercise: exercise),
    ];
    await harness.pump(
      tester,
      Scaffold(
        body: PlansList(
          scroll: scroll,
          plans: [Plan(days: 'Monday', id: planId, sequence: 2)],
          exercises: exercises,
          onSelect: (value) {},
          selected: const {},
          navKey: GlobalKey(),
          search: '',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsOne);
  });
}
