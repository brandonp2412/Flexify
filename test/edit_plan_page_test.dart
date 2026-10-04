import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixtures.dart';
import 'support/test_app.dart';

Future<void> scrollTo(WidgetTester tester, FinderBase<Element> finder) {
  return tester.scrollUntilVisible(
    finder,
    400,
    scrollable: find.byType(Scrollable).first,
  );
}

void main() {
  testWidgets('EditPlanPage updates', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;
    final plan = planFixture(
      id: 1,
      days: 'Monday,Tuesday,Wednesday',
      title: 'Test title',
      sequence: 1,
    );

    await database.planExercises.deleteAll();
    await database.plans.deleteAll();
    await database.plans.insertOne(plan);
    for (final exercise in const [
      'Arnold press',
      'Back extension',
      'Barbell bench press',
    ]) {
      await insertPlanExerciseFixture(database, planId: 1, exercise: exercise);
    }

    await harness.pump(tester, EditPlanPage(plan: plan));

    expect(find.text('Test title'), findsOne);
    expect(find.text('Mon'), findsOne);
    expect(find.text('Tue'), findsOne);
    expect(find.text('Wed'), findsOne);
    expect(find.text('Save'), findsOne);

    await tester.tap(find.text('Mon'));
    await tester.tap(find.text('Thu'));
    await scrollTo(tester, find.text('Arnold press'));
    await tester.tap(find.text('Arnold press'));
    await tester.tap(find.text('Barbell biceps curl'));

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Title'), findsNothing);
  });

  testWidgets('EditPlanPage preserves active workout progress', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;
    final plan = planFixture(
      id: 1,
      days: 'Monday',
      title: 'In progress',
      sequence: 1,
    );

    await database.planExercises.deleteAll();
    await database.plans.deleteAll();
    await database.plans.insertOne(plan);
    final planExercise = await insertPlanExerciseFixture(
      database,
      planId: 1,
      exercise: 'Arnold press',
    );
    final workout = await database.workouts.insertReturning(
      WorkoutsCompanion.insert(
        planId: const Value(1),
        startedAt: DateTime(2026, 10, 5, 8),
      ),
    );
    await database.exerciseSets.insertOne(
      ExerciseSetsCompanion.insert(
        exerciseId: planExercise.exerciseId,
        workoutId: Value(workout.id),
        timestamp: DateTime(2026, 10, 5, 8, 30),
        reps: const Value(8),
        loadKg: const Value(20),
      ),
    );

    await harness.pump(tester, EditPlanPage(plan: plan));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final preservedWorkout =
        await (database.workouts.select()
              ..where((row) => row.id.equals(workout.id)))
            .getSingle();
    expect(preservedWorkout.planId, 1);

    final preservedSet = await database.exerciseSets.select().getSingle();
    expect(preservedSet.workoutId, workout.id);

    final preservedPlanExercise =
        await (database.planExercises.select()
              ..where((row) => row.exerciseId.equals(planExercise.exerciseId)))
            .getSingle();
    expect(preservedPlanExercise.id, planExercise.id);
  });

  testWidgets('EditPlanPage searches', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;
    final plan = planFixture(
      id: 1,
      days: 'Monday,Tuesday,Wednesday',
      title: 'Test title',
      sequence: 1,
    );

    await database.planExercises.deleteAll();
    await database.plans.deleteAll();
    await database.plans.insertOne(plan);
    for (final exercise in const [
      'Arnold press',
      'Back extension',
      'Barbell bench press',
    ]) {
      await insertPlanExerciseFixture(database, planId: 1, exercise: exercise);
    }

    await harness.pump(tester, EditPlanPage(plan: plan));

    await scrollTo(tester, find.text('Arnold press'));
    await tester.enterText(find.byType(SearchBar), 'Back extension');
    await tester.pumpAndSettle();

    expect(find.text('Back extension'), findsNWidgets(2));
    expect(find.text('Arnold press'), findsNothing);
  });

  testWidgets('EditPlanPage confirms before discarding changes', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;
    final plan = planFixture(
      id: 1,
      days: 'Monday',
      title: 'Test title',
      sequence: 1,
    );
    await database.planExercises.deleteAll();
    await database.plans.deleteAll();
    await database.plans.insertOne(plan);
    await insertPlanExerciseFixture(
      database,
      planId: 1,
      exercise: 'Arnold press',
    );

    await harness.pump(
      tester,
      Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => EditPlanPage(plan: plan))),
            child: const Text('Open editor'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open editor'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Changed title');
    await tester.pump();
    expect(find.text('Changed title'), findsOneWidget);
    await Navigator.of(tester.element(find.byType(EditPlanPage))).maybePop();
    await tester.pumpAndSettle();

    expect(find.text('Unsaved changes'), findsOneWidget);
    expect(find.text('Discard your unsaved changes?'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Changed title'), findsOneWidget);

    await Navigator.of(tester.element(find.byType(EditPlanPage))).maybePop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();

    expect(find.text('Open editor'), findsOneWidget);
  });
}
