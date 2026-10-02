import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('AddExercise', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(tester, const AddExercisePage());

    expect(find.text('Add exercise'), findsOne);
    await tester.enterText(find.bySemanticsLabel('Name'), 'Bench press 2');

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Add exercise'), findsNothing);
  });

  testWidgets('new cardio exercise defaults to a distance unit', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(tester, const AddExercisePage());

    expect(find.text('Kilograms (kg)'), findsOneWidget);
    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(find.text('Kilometers (km)'), findsOneWidget);

    await tester.enterText(find.bySemanticsLabel('Name'), 'Treadmill walking');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final exercise = await (harness.database.select(
      harness.database.exercises,
    )..where((table) => table.name.equals('Treadmill walking'))).getSingle();
    expect(exercise.kind, 'cardio');
    expect(exercise.displayUnit, 'km');
    expect(
      await (harness.database.select(
        harness.database.exerciseSets,
      )..where((set) => set.exerciseId.equals(exercise.id))).get(),
      isEmpty,
    );
  });
}
