import 'package:flexify/database/performed_sets.dart';
import 'package:flexify/sets/edit_sets_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixtures.dart';
import 'support/test_app.dart';

import 'package:drift/drift.dart';

void main() {
  testWidgets('EditSetsPage cardio toggle switches fields', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.settings.update().write(
      testSettings(showUnits: true),
    );
    final ids = [
      (await insertPerformedSetFixture(
        harness.database,
        'Bench press',
        reps: 2,
        weight: 90,
        created: DateTime.now(),
      )).id,
      (await insertPerformedSetFixture(
        harness.database,
        'Deadlift',
        reps: 5,
        weight: 100,
        created: DateTime.now(),
      )).id,
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
    await harness.database.settings.update().write(
      testSettings(showUnits: true),
    );
    final ids = [
      (await insertPerformedSetFixture(
        harness.database,
        'Bench press',
        reps: 2,
        weight: 90,
        created: DateTime.now(),
        category: 'Chest',
      )).id,
      (await insertPerformedSetFixture(
        harness.database,
        'Shoulder press',
        reps: 5,
        weight: 60,
        created: DateTime.now(),
        category: 'Shoulders',
      )).id,
      (await insertPerformedSetFixture(
        harness.database,
        'Deadlift',
        reps: 7,
        weight: 100,
        created: DateTime.now(),
        category: 'Legs',
      )).id,
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
    final performedSets = (await getPerformedSets(harness.database))
        .where(
          (set) =>
              ids.contains(set.id) &&
              set.reps == 9 &&
              set.weight == 200 &&
              set.name == 'New name',
        )
        .toList();
    expect(performedSets.length, equals(3));
  });
}
