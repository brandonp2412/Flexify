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

    await database.plans.deleteAll();
    await database.planExercises.deleteAll();
    await database.plans.insertOne(plan);
    await database.planExercises.insertAll([
      planExerciseFixture(planId: 1, exercise: 'Arnold press'),
      planExerciseFixture(planId: 1, exercise: 'Back extension'),
      planExerciseFixture(planId: 1, exercise: 'Barbell bench press'),
    ]);

    await harness.planState.setExercises(plan);
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
    await database.planExercises.insertAll([
      planExerciseFixture(planId: 1, exercise: 'Arnold press'),
      planExerciseFixture(planId: 1, exercise: 'Back extension'),
      planExerciseFixture(planId: 1, exercise: 'Barbell bench press'),
    ]);

    await harness.planState.setExercises(plan);
    await harness.pump(tester, EditPlanPage(plan: plan));

    await scrollTo(tester, find.text('Arnold press'));
    await tester.enterText(find.byType(SearchBar), 'Back extension');
    await tester.pumpAndSettle();

    expect(find.text('Back extension'), findsNWidgets(2));
    expect(find.text('Arnold press'), findsNothing);
  });
}
