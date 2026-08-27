import 'package:drift/drift.dart';
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixtures.dart';
import 'support/test_app.dart';

Finder textFieldWithLabel(String label) => find.byWidgetPredicate(
  (widget) =>
      widget is TextFormField && widget.decoration.labelText == label,
);

void main() {
  testWidgets(
    'StartPlanPage rep estimation does not crash when no RPM data for exercise',
    (WidgetTester tester) async {
      final harness = await FlexifyTestHarness.create();
      final database = harness.database;

      final id = await database.plans.insertOne(planFixture());
      await database.planExercises.insertOne(
        planExerciseFixture(planId: id, exercise: 'Bench press'),
      );
      await database.settings.update().write(
        testSettings(
          repEstimation: true,
          explainedPermissions: true,
          notificationPermissionRequested: true,
        ),
      );

      final plan = await (database.plans.select()
            ..where((plan) => plan.id.equals(id)))
          .getSingle();
      await harness.planState.updateGymCounts(plan.id);
      await harness.pump(tester, StartPlanPage(plan: plan));
      await tester.pumpAndSettle();

      await tester.enterText(textFieldWithLabel('Reps'), '5');
      await tester.enterText(textFieldWithLabel('Weight (kg)'), '50');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
    },
  );

  testWidgets('StartPlanPage with no exercises does not crash on save', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(planFixture());
    await database.settings.update().write(
      testSettings(explainedPermissions: true),
    );
    final plan = await (database.plans.select()
          ..where((plan) => plan.id.equals(id)))
        .getSingle();
    await harness.planState.updateGymCounts(plan.id);

    await harness.pump(tester, StartPlanPage(plan: plan));
    await tester.pumpAndSettle();

    expect(find.text('Save'), findsNothing);
  });

  testWidgets('StartPlanPage renders', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    await database.gymSets.insertAll([
      gymSetFixture(
        'Bench press',
        reps: 2,
        weight: 90,
        category: 'Chest',
      ),
      gymSetFixture(
        'Barbell row',
        reps: 5,
        weight: 60,
        category: 'Shoulders',
      ),
      gymSetFixture('Squat', reps: 7, weight: 100, category: 'Legs'),
    ]);

    final id = await database.plans.insertOne(
      planFixture(days: 'Monday,Tuesday,Wednesday'),
    );
    await database.planExercises.insertAll([
      planExerciseFixture(planId: id, exercise: 'Bench press'),
      planExerciseFixture(planId: id, exercise: 'Barbell row'),
      planExerciseFixture(planId: id, exercise: 'Squat'),
    ]);
    final plan = await (database.plans.select()
          ..where((plan) => plan.id.equals(id)))
        .getSingle();

    await harness.pump(
      tester,
      StartPlanPage(plan: plan),
      surfaceSize: const Size(800, 1200),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOne);
    expect(find.textContaining('Bench press'), findsOne);
    expect(find.textContaining('Barbell row'), findsOne);
    expect(find.textContaining('Squat'), findsOne);
  });

  testWidgets('StartPlanPage saves', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(
      planFixture(days: 'Monday,Tuesday,Wednesday'),
    );
    final plan = await (database.plans.select()
          ..where((plan) => plan.id.equals(id)))
        .getSingle();

    await database.planExercises.insertAll([
      planExerciseFixture(
        planId: plan.id,
        exercise: 'Barbell bench press',
        sequence: 0,
      ),
      planExerciseFixture(
        planId: plan.id,
        exercise: 'Barbell bent-over row',
        sequence: 1,
      ),
      planExerciseFixture(
        planId: plan.id,
        exercise: 'Crunch',
        sequence: 2,
      ),
    ]);
    await database.settings.update().write(
      testSettings(
        explainedPermissions: true,
        notificationPermissionRequested: true,
      ),
    );
    await harness.planState.updateGymCounts(plan.id);

    await harness.pump(tester, StartPlanPage(plan: plan));
    await tester.pumpAndSettle();

    await tester.enterText(textFieldWithLabel('Reps'), '5');
    await tester.enterText(textFieldWithLabel('Weight (kg)'), '50');
    await tester.pumpAndSettle();
    expect(find.text('50'), findsOne);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final gymSets = await (database.gymSets.select()
          ..where((set) => set.name.equals('Barbell bench press')))
        .get();
    expect(gymSets.length, equals(2));
  });

  testWidgets('StartPlanPage shows this-session sets after saving', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(planFixture());
    final plan = await (database.plans.select()
          ..where((plan) => plan.id.equals(id)))
        .getSingle();
    await database.planExercises.insertOne(
      planExerciseFixture(planId: plan.id, exercise: 'Bench press'),
    );
    await database.settings.update().write(
      testSettings(
        explainedPermissions: true,
        notificationPermissionRequested: true,
      ),
    );
    await harness.planState.updateGymCounts(plan.id);

    await harness.pump(
      tester,
      StartPlanPage(plan: plan),
      surfaceSize: const Size(800, 1200),
    );
    await tester.pumpAndSettle();

    expect(find.text('Set 1'), findsNothing);

    await tester.enterText(textFieldWithLabel('Reps'), '5');
    await tester.enterText(textFieldWithLabel('Weight (kg)'), '50');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Set 1'), findsOne);
    expect(find.text('50 kg × 5'), findsOne);
  });
}
