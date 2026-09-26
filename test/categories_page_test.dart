import 'package:drift/drift.dart' hide isNotNull;
import 'package:flexify/category/categories_page.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tab_controller.dart';
import 'support/fixtures.dart';
import 'support/test_app.dart';

const _tall = Size(800, 2400);

void main() {
  testWidgets('lists categories with how many exercises each has', (
    tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.gymSets.insertAll([
      gymSetFixture('Reverse fly', category: 'Back'),
      gymSetFixture('Reverse fly', category: 'Shoulders'),
      gymSetFixture('Mystery lift'),
    ]);

    await harness.pump(
      tester,
      CategoriesPage(tabController: MockTabController()),
      surfaceSize: _tall,
    );
    await tester.pumpAndSettle();

    expect(find.text('Categories'), findsOne);
    expect(
      find.widgetWithText(ListTile, 'Uncategorized'),
      findsOne,
      reason: 'Exercises without a category are listed separately.',
    );
    expect(find.text('Biceps'), findsOne);
    expect(
      find.descendant(
        of: find.widgetWithText(ListTile, 'Uncategorized'),
        matching: find.text('1 exercise'),
      ),
      findsOne,
    );
  });

  testWidgets('opening a category shows only its exercises', (tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.gymSets.insertAll([
      gymSetFixture('Reverse fly', category: 'Back'),
      gymSetFixture('Face pull', category: 'Shoulders'),
    ]);

    await harness.pump(
      tester,
      CategoriesPage(tabController: MockTabController()),
      surfaceSize: _tall,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Reverse fly'), findsOne);
    expect(find.text('Face pull'), findsNothing);
    expect(find.text('Deadlift'), findsOne, reason: 'Starter exercise.');
  });

  testWidgets('adding from a category preselects it', (tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(
      tester,
      CategoriesPage(tabController: MockTabController()),
      surfaceSize: _tall,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Glutes'));
    await tester.pumpAndSettle();

    expect(find.text('No exercises in Glutes yet'), findsOne);
    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();

    final page = tester.widget<AddExercisePage>(find.byType(AddExercisePage));
    expect(page.category, 'Glutes');
  });

  testWidgets('creates a new category', (tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(
      tester,
      CategoriesPage(tabController: MockTabController()),
      surfaceSize: _tall,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FloatingActionButton, 'Add'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Rear delts');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();

    final categories = await harness.database.categories.select().get();
    expect(categories.map((category) => category.name), contains('Rear delts'));
  });
}
