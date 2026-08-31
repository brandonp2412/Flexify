import 'package:drift/drift.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tab_controller.dart';
import 'support/fixtures.dart';
import 'support/test_app.dart';

Future<void> pumpGraphsPage(
  WidgetTester tester,
  FlexifyTestHarness harness, {
  bool withTabController = false,
}) async {
  final page = GraphsPage(tabController: MockTabController());
  await harness.pump(
    tester,
    withTabController ? DefaultTabController(length: 1, child: page) : page,
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('GraphsPage lists items', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpGraphsPage(tester, harness);

    expect(find.text('Search graphs...'), findsOne);
    expect(find.byType(ListTile), findsWidgets);
  });

  testWidgets('GraphsPage taps barbell bench press', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.gymSets.insertOne(
      gymSetFixture(
        'Barbell bench press',
        reps: 10,
        weight: 100,
        created: DateTime.now().toLocal(),
        category: 'Chest',
      ),
    );

    await pumpGraphsPage(tester, harness, withTabController: true);
    await tester.tap(find.text('Barbell bench press'));
    await tester.pumpAndSettle();

    expect(find.text('Best weight'), findsOne);
  });

  testWidgets('GraphsPage taps global progress', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpGraphsPage(tester, harness, withTabController: true);

    await tester.tap(find.text('Global progress'));
    await tester.pumpAndSettle();

    expect(find.text('Best weight'), findsOne);
  });

  testWidgets('GraphsPage settings', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpGraphsPage(tester, harness);

    await tester.tap(find.byTooltip('Show menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOne);
  });

  testWidgets('GraphsPage selects', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.gymSets.insertOne(
      gymSetFixture(
        'Barbell bent-over row',
        reps: 8,
        weight: 80,
        created: DateTime.now().toLocal(),
        category: 'Back',
      ),
    );

    await pumpGraphsPage(tester, harness);
    await tester.longPress(find.text('Barbell bent-over row'));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsOne);
  });

  testWidgets('GraphsPage deletes', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.gymSets.insertOne(
      gymSetFixture(
        'Back extension',
        reps: 12,
        weight: 50,
        created: DateTime.now().toLocal(),
        category: 'Back',
      ),
    );

    await pumpGraphsPage(tester, harness);
    await tester.longPress(find.text('Back extension'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Delete selected'));
    await tester.pumpAndSettle();
    expect(find.text('Confirm Delete'), findsOne);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Back extension'), findsNothing);
  });

  testWidgets('GraphsPage delete also removes plan exercises', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.gymSets.insertOne(
      gymSetFixture(
        'Zz unique test exercise',
        reps: 12,
        weight: 30,
        created: DateTime.now().toLocal().add(const Duration(seconds: 5)),
        category: 'Chest',
      ),
    );

    final planId = await harness.database.plans.insertOne(planFixture());
    await harness.database.planExercises.insertOne(
      planExerciseFixture(planId: planId, exercise: 'Zz unique test exercise'),
    );

    await pumpGraphsPage(tester, harness);
    await tester.longPress(find.text('Zz unique test exercise'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete selected'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    final planExercises =
        await (harness.database.planExercises.select()
              ..where((pe) => pe.exercise.equals('Zz unique test exercise')))
            .get();
    expect(planExercises, isEmpty);
  });
}
