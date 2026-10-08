import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/sets/edit_sets_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixtures.dart';
import 'support/test_app.dart';

Future<void> _openEditor(
  WidgetTester tester,
  FlexifyTestHarness harness,
  WidgetBuilder builder, {
  Size? surfaceSize,
}) async {
  await harness.pump(
    tester,
    Builder(
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: builder)),
          child: const Text('Open editor'),
        ),
      ),
    ),
    surfaceSize: surfaceSize,
  );
  await tester.tap(find.text('Open editor'));
  await tester.pumpAndSettle();
}

Future<void> _attemptBack(WidgetTester tester, Finder page) async {
  await Navigator.of(tester.element(page)).maybePop();
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('AddExercise tracks non-text changes and save bypasses guard', (
    tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await _openEditor(tester, harness, (_) => const AddExercisePage());

    await tester.tap(find.byType(Switch));
    await tester.pump();
    await _attemptBack(tester, find.byType(AddExercisePage));

    expect(find.text('Unsaved changes'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel('Name'), 'Running');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Open editor'), findsOneWidget);
    expect(find.text('Unsaved changes'), findsNothing);
  });

  testWidgets('EditSet initialization does not create false unsaved changes', (
    tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await _openEditor(
      tester,
      harness,
      (_) => EditSetPage(exerciseSet: exerciseSetModelFixture()),
    );

    await _attemptBack(tester, find.byType(EditSetPage));

    expect(find.text('Open editor'), findsOneWidget);
    expect(find.text('Unsaved changes'), findsNothing);
  });

  testWidgets('EditSet unit changes are treated as unsaved', (tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.settings.update().write(
      testSettings(showUnits: true),
    );
    await _openEditor(
      tester,
      harness,
      (_) => EditSetPage(exerciseSet: exerciseSetModelFixture()),
    );

    final unitDropdown = find.byWidgetPredicate(
      (widget) =>
          widget is DropdownButtonFormField<String> &&
          widget.decoration.labelText == 'Unit',
    );
    await tester.tap(unitDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pounds (lb)').last);
    await tester.pumpAndSettle();

    await _attemptBack(tester, find.byType(EditSetPage));
    expect(find.text('Unsaved changes'), findsOneWidget);
  });

  testWidgets('EditSets cardio changes are treated as unsaved', (tester) async {
    final harness = await FlexifyTestHarness.create();
    final ids = [
      (await insertExerciseSetFixture(
        harness.database,
        'Bench press',
        created: testNow,
      )).id,
      (await insertExerciseSetFixture(
        harness.database,
        'Deadlift',
        created: testNow.add(const Duration(minutes: 1)),
      )).id,
    ];
    await _openEditor(tester, harness, (_) => EditSetsPage(ids: ids));

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await _attemptBack(tester, find.byType(EditSetsPage));

    expect(find.text('Unsaved changes'), findsOneWidget);
  });

  testWidgets('EditGraph async rest initialization stays clean', (
    tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final exercise = await ensureExerciseFixture(
      harness.database,
      'Bench press',
    );
    await (harness.database.exercises.update()
          ..where((row) => row.id.equals(exercise.id)))
        .write(const ExercisesCompanion(defaultRestDurationMs: Value(90000)));

    await _openEditor(
      tester,
      harness,
      (_) =>
          const EditGraphPage(exercise: (name: 'Bench press', category: null)),
    );

    expect(find.bySemanticsLabel('Rest minutes'), findsOneWidget);
    await _attemptBack(tester, find.byType(EditGraphPage));

    expect(find.text('Open editor'), findsOneWidget);
    expect(find.text('Unsaved changes'), findsNothing);
  });

  testWidgets('EditGraph unit changes are treated as unsaved', (tester) async {
    final harness = await FlexifyTestHarness.create();
    await ensureExerciseFixture(harness.database, 'Bench press');
    await _openEditor(
      tester,
      harness,
      (_) =>
          const EditGraphPage(exercise: (name: 'Bench press', category: null)),
    );

    final unitDropdown = find.byWidgetPredicate(
      (widget) =>
          widget is DropdownButtonFormField &&
          widget.decoration.labelText == 'Unit',
    );
    await tester.tap(unitDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pounds (lb)').last);
    await tester.pumpAndSettle();

    await _attemptBack(tester, find.byType(EditGraphPage));
    expect(find.text('Unsaved changes'), findsOneWidget);
  });

  testWidgets('AddExercise name changes are treated as unsaved', (
    tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await _openEditor(tester, harness, (_) => const AddExercisePage());

    await tester.enterText(find.bySemanticsLabel('Name'), 'Bench press');
    await tester.pump();
    await _attemptBack(tester, find.byType(AddExercisePage));

    expect(find.text('Unsaved changes'), findsOneWidget);
  });

  testWidgets('EditSet category changes are treated as unsaved', (
    tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.settings.update().write(
      const SettingsCompanion(showCategories: Value(true)),
    );
    await _openEditor(
      tester,
      harness,
      (_) => EditSetPage(
        exerciseSet: exerciseSetFixture('Bench press', category: 'Chest'),
      ),
    );

    await tester.enterText(find.bySemanticsLabel('Category'), 'Shoulders');
    await tester.pump();
    await _attemptBack(tester, find.byType(EditSetPage));

    expect(find.text('Unsaved changes'), findsOneWidget);
  });

  testWidgets('EditSet date changes are treated as unsaved', (tester) async {
    final harness = await FlexifyTestHarness.create();
    await _openEditor(
      tester,
      harness,
      (_) => EditSetPage(exerciseSet: exerciseSetModelFixture()),
    );

    await tester.tap(find.widgetWithText(ListTile, 'Created date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('16').last);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await _attemptBack(tester, find.byType(EditSetPage));
    expect(find.text('Unsaved changes'), findsOneWidget);
  });
}
