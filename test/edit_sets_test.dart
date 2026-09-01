import 'package:drift/drift.dart';
import 'package:flexify/sets/edit_sets_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixtures.dart';
import 'support/test_app.dart';

void main() {
  testWidgets('EditSetsPage cardio toggle switches fields', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final ids = [
      await harness.database.gymSets.insertOne(
        gymSetFixture(
          'Bench press',
          reps: 2,
          weight: 90,
          created: DateTime.now(),
        ),
      ),
      await harness.database.gymSets.insertOne(
        gymSetFixture(
          'Deadlift',
          reps: 5,
          weight: 100,
          created: DateTime.now(),
        ),
      ),
    ];

    await harness.pump(tester, EditSetsPage(ids: ids));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Reps'), findsOne);
    expect(find.bySemanticsLabel('Distance'), findsNothing);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Reps'), findsNothing);
    expect(find.bySemanticsLabel('Weight'), findsOne);
    expect(find.bySemanticsLabel('Distance'), findsNothing);

    final unitDropdown = find.byWidgetPredicate(
      (widget) =>
          widget is DropdownButtonFormField<String> &&
          widget.decoration.labelText == 'Unit',
    );
    await tester.tap(unitDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kilometers (km)').last);
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Weight'), findsNothing);
    expect(find.bySemanticsLabel('Distance'), findsOne);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.bySemanticsLabel('Reps'), findsOne);
  });

  testWidgets('EditGymSets', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    final ids = [
      await harness.database.gymSets.insertOne(
        gymSetFixture(
          'Bench press',
          reps: 2,
          weight: 90,
          created: DateTime.now(),
          category: 'Chest',
        ),
      ),
      await harness.database.gymSets.insertOne(
        gymSetFixture(
          'Shoulder press',
          reps: 5,
          weight: 60,
          created: DateTime.now(),
          category: 'Shoulders',
        ),
      ),
      await harness.database.gymSets.insertOne(
        gymSetFixture(
          'Deadlift',
          reps: 7,
          weight: 100,
          created: DateTime.now(),
          category: 'Legs',
        ),
      ),
    ];

    await harness.pump(tester, EditSetsPage(ids: ids));

    expect(find.text('Edit 3 sets'), findsOne);
    expect(find.bySemanticsLabel('Name'), findsOne);
    expect(find.bySemanticsLabel('Reps'), findsOne);

    await tester.enterText(find.bySemanticsLabel('Name'), 'New name');
    await tester.pump();
    await tester.enterText(find.bySemanticsLabel('Reps'), '9');
    await tester.pump();
    await tester.enterText(find.bySemanticsLabel('Weight'), '200');
    await tester.pump();
    final unitDropdown = find.byWidgetPredicate(
      (widget) =>
          widget is DropdownButtonFormField<String> &&
          widget.decoration.labelText == 'Unit',
    );
    await tester.tap(unitDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pounds (lb)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Update'));
    await tester.pumpAndSettle();

    expect(find.text('Edit 3 sets'), findsNothing);
    final gymSets =
        await (harness.database.gymSets.select()
              ..where((set) => set.id.isIn(ids))
              ..where((set) => set.reps.equals(9))
              ..where((set) => set.weight.equals(200))
              ..where((set) => set.name.equals('New name')))
            .get();
    expect(gymSets.length, equals(3));
  });
}
