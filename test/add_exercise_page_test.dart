import 'package:drift/drift.dart' hide isNotNull;
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/exercise_options_view.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixtures.dart';
import 'support/test_app.dart';

/// Opens [page] on top of a host route, the way the app always shows it.
Future<void> pushAddExercise(
  WidgetTester tester,
  FlexifyTestHarness harness,
  AddExercisePage page,
) async {
  await harness.pump(
    tester,
    Builder(
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => page)),
          child: const Text('host'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('host'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('adds an exercise to the chosen category', (tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(tester, const AddExercisePage(category: 'Back'));

    expect(find.text('Add exercise'), findsOne);
    await tester.enterText(find.bySemanticsLabel('Name'), 'Reverse fly');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Add exercise'), findsNothing);
    final template =
        await (harness.database.gymSets.select()
              ..where((tbl) => isExercise(tbl, 'Reverse fly', 'Back')))
            .getSingle();
    expect(template.hidden, isTrue);
  });

  testWidgets('requires a category', (tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(tester, const AddExercisePage());

    await tester.enterText(find.bySemanticsLabel('Name'), 'Reverse fly');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Choose a category'), findsOne);
    expect(find.text('Add exercise'), findsOne);
  });

  testWidgets(
    'refuses a duplicate in the same category and offers to open it',
    (tester) async {
      final harness = await FlexifyTestHarness.create();
      await harness.database.gymSets.insertOne(
        gymSetFixture('Reverse fly', category: 'Back'),
      );
      await pushAddExercise(
        tester,
        harness,
        const AddExercisePage(category: 'Back'),
      );

      await tester.enterText(find.bySemanticsLabel('Name'), 'reverse FLY');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Reverse fly already exists in Back'), findsOne);
      expect(find.widgetWithText(SnackBarAction, 'Open'), findsOne);
      final variants =
          await (harness.database.gymSets.select()
                ..where((tbl) => tbl.category.equals('Back')))
              .get();
      expect(variants.where((set) => set.name.toLowerCase() == 'reverse fly'), [
        isA<Object>(),
      ]);

      await tester.tap(find.widgetWithText(SnackBarAction, 'Open'));
      await tester.pumpAndSettle();

      expect(find.text('Add exercise'), findsNothing);
      expect(find.text('Reverse fly · Back'), findsOne);
    },
  );

  testWidgets(
    'allows the same name in another category and copies its details',
    (tester) async {
      final harness = await FlexifyTestHarness.create();
      await harness.database.gymSets.insertOne(
        gymSetFixture(
          'Reverse fly',
          category: 'Back',
          unit: 'lb',
          cardio: true,
        ).copyWith(restMs: const Value(90000)),
      );
      await harness.pump(tester, const AddExercisePage(category: 'Shoulders'));

      await tester.enterText(find.bySemanticsLabel('Name'), 'Reverse fly');
      await tester.pumpAndSettle();
      final suggestion = find.descendant(
        of: find.byType(ExerciseOptionsView),
        matching: find.widgetWithText(ListTile, 'Reverse fly'),
      );
      expect(suggestion, findsOne);
      expect(
        find.descendant(of: suggestion, matching: find.text('Back')),
        findsOne,
      );
      await tester.tap(suggestion);
      await tester.pumpAndSettle();

      expect(find.text('Cardio'), findsOne);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final copy =
          await (harness.database.gymSets.select()
                ..where((tbl) => isExercise(tbl, 'Reverse fly', 'Shoulders')))
              .getSingle();
      expect(copy.unit, 'lb');
      expect(copy.cardio, isTrue);
      expect(copy.restMs, 90000);
      expect(
        await (harness.database.gymSets.select()
              ..where((tbl) => isExercise(tbl, 'Reverse fly', 'Back')))
            .get(),
        hasLength(1),
      );
    },
  );
}
