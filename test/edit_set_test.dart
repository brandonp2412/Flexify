import 'package:drift/drift.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixtures.dart';
import 'support/test_app.dart';

void main() {
  testWidgets('EditGymSet inserts', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(
      tester,
      EditSetPage(
        gymSet: gymSetModelFixture(bodyWeight: 52, duration: 3, distance: 6),
      ),
    );

    expect(find.bySemanticsLabel('Name'), findsOne);
    final reps = find.bySemanticsLabel('Reps');
    final weight = find.bySemanticsLabel('Weight (kg)');
    expect(reps, findsOne);
    expect(weight, findsOne);

    await tester.enterText(reps, '10');
    await tester.enterText(weight, '50');

    final button = find.text('Save');
    expect(button, findsOne);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsNothing);
  });

  testWidgets('selecting new cardio exercise shows cardio fields', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.gymSets.insertOne(
      gymSetFixture(
        'Running',
        reps: 0,
        weight: 0,
        unit: 'km',
        created: DateTime.now(),
        hidden: true,
        cardio: true,
      ),
    );

    await harness.pump(tester, EditSetPage(gymSet: gymSetModelFixture()));

    expect(find.bySemanticsLabel('Reps'), findsOne);

    await tester.enterText(find.bySemanticsLabel('Name'), 'Running');
    await tester.pump();
    await tester.tap(find.text('Running').last);
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Reps'), findsNothing);
    expect(find.bySemanticsLabel('Distance (km)'), findsOne);
  });

  testWidgets('cardio toggle switches fields', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(tester, EditSetPage(gymSet: gymSetModelFixture()));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Reps'), findsOne);
    expect(find.bySemanticsLabel('Minutes'), findsNothing);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Reps'), findsNothing);
    expect(find.bySemanticsLabel('Minutes'), findsOne);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Reps'), findsOne);
  });

  testWidgets('EditGymSet updates', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(
      tester,
      EditSetPage(
        gymSet: gymSetModelFixture(
          id: 1,
          bodyWeight: 52,
          duration: 3,
          distance: 6,
        ),
      ),
    );

    expect(find.text('Bench press'), findsNWidgets(2));

    final button = find.text('Save');
    expect(button, findsOne);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsNothing);
  });

  testWidgets('switching exercises clears note when new exercise has no note', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();

    await harness.database.gymSets.insertAll([
      gymSetFixture(
        'Bench press',
        reps: 10,
        weight: 100,
        created: DateTime.now(),
        notes: 'bad shoulder',
      ),
      gymSetFixture(
        'Squat',
        reps: 5,
        weight: 80,
        created: DateTime.now().add(const Duration(seconds: 1)),
      ),
    ]);
    await harness.database.settings.update().write(
      testSettings(showNotes: true),
    );

    await harness.pump(
      tester,
      EditSetPage(gymSet: gymSetModelFixture(name: '', reps: 0, weight: 0)),
      surfaceSize: const Size(800, 1600),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel('Name'), 'Bench press');
    await tester.pump();
    await tester.tap(find.text('Bench press').last);
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Notes'), findsOne);
    expect(find.widgetWithText(TextField, 'bad shoulder'), findsOne);

    await tester.enterText(find.bySemanticsLabel('Name'), 'Squat');
    await tester.pump();
    await tester.tap(find.text('Squat').last);
    await tester.pumpAndSettle();

    expect(
      find.widgetWithText(TextField, 'bad shoulder'),
      findsNothing,
      reason: 'Note from Bench press must not persist when Squat has no note',
    );
  });
}
