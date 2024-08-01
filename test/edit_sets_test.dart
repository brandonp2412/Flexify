import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/sets/edit_sets_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('EditGymSets', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);

    await (db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 2,
        weight: 90,
        unit: 'kg',
        created: DateTime.now(),
      ),
      GymSetsCompanion.insert(
        name: 'Shoulder press',
        reps: 5,
        weight: 60,
        unit: 'kg',
        created: DateTime.now(),
      ),
      GymSetsCompanion.insert(
        name: 'Deadlift',
        reps: 7,
        weight: 100,
        unit: 'kg',
        created: DateTime.now(),
      ),
    ]));

    final ids = (await (db.gymSets.select()..limit(3)).get())
        .map((gymSet) => gymSet.id)
        .toList();

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: getTestProviders(settings),
        child: MaterialApp(
          home: EditSetsPage(
            ids: ids,
          ),
        ),
      ),
    );

    expect(find.text("Edit 3 sets"), findsOne);
    expect(find.bySemanticsLabel('Name'), findsOne);
    expect(find.bySemanticsLabel('Reps'), findsOne);

    await tester.enterText(find.bySemanticsLabel('Name'), 'New name');
    await tester.pump();
    await tester.enterText(find.bySemanticsLabel('Reps'), '9');
    await tester.pump();
    await tester.enterText(find.bySemanticsLabel('Weight'), '200');
    await tester.pump();
    await tester.tap(find.bySemanticsLabel('Unit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pounds'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip("Save"));
    await tester.pumpAndSettle();

    expect(find.text("Edit 3 sets"), findsNothing);
    final gymSets = await (db.gymSets.select()
          ..where((u) => u.reps.equals(9))
          ..where((u) => u.weight.equals(200))
          ..where((u) => u.name.equals('New name')))
        .get();
    expect(gymSets.length, equals(3));

    await db.close();
  });
}
