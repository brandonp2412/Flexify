import 'package:drift/drift.dart' hide isNull;
import 'package:flexify/database/categories.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flexify/plan/swap_workout.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/settings/timer_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tab_controller.dart';
import 'support/fixtures.dart';
import 'support/test_app.dart';

const _back = (name: 'Reverse fly', category: 'Back');
const _shoulders = (name: 'Reverse fly', category: 'Shoulders');

Future<void> _seedReverseFly(FlexifyTestHarness harness) async {
  await insertExerciseSetFixture(
    harness.database,
    'Reverse fly',
    category: 'Back',
    weight: 40,
    reps: 10,
  );
  await insertExerciseSetFixture(
    harness.database,
    'Reverse fly',
    category: 'Shoulders',
    weight: 12,
    reps: 15,
    created: testNow.add(const Duration(days: 1)),
  );
}

Future<void> _showCategories(FlexifyTestHarness harness) {
  return harness.database.settings.update().write(
    const SettingsCompanion(showCategories: Value(true)),
  );
}

void main() {
  testWidgets('set form suggestions tell same-named exercises apart', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await _seedReverseFly(harness);
    await _showCategories(harness);
    await harness.pump(
      tester,
      EditSetPage(exerciseSet: exerciseSetModelFixture()),
    );

    await tester.enterText(find.bySemanticsLabel('Name'), 'Reverse fly');
    await tester.pump();

    expect(find.text('Reverse fly'), findsNWidgets(3));
    expect(find.text('Back'), findsOneWidget);
    expect(find.text('Shoulders'), findsOneWidget);

    await tester.tap(find.text('Shoulders'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final shoulders = await getExerciseSetsForExercise(
      harness.database,
      exercise: _shoulders,
    );
    final back = await getExerciseSetsForExercise(
      harness.database,
      exercise: _back,
    );
    expect(back, hasLength(1));
    expect(shoulders, hasLength(2));
    expect(shoulders.first.weight, 12);
  });

  testWidgets('a typed name without a category reuses the existing exercise', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await createExerciseDefinition(
      name: 'Hip thrust',
      cardio: false,
      displayUnit: 'kg',
      category: 'Legs',
    );
    await harness.pump(
      tester,
      EditSetPage(exerciseSet: exerciseSetModelFixture()),
    );

    await tester.enterText(find.bySemanticsLabel('Name'), 'Hip thrust');
    await tester.enterText(find.bySemanticsLabel('Reps'), '8');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '60');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final exercises = await getExercisesByName('Hip thrust');
    expect(exercises, hasLength(1));
    expect(
      await getExerciseSetsForExercise(
        harness.database,
        exercise: (name: 'Hip thrust', category: 'Legs'),
      ),
      hasLength(1),
    );
  });

  testWidgets('AddExercise rejects a duplicate in the same category', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await _showCategories(harness);
    await createExerciseDefinition(
      name: 'Reverse fly',
      cardio: false,
      displayUnit: 'kg',
      category: 'Back',
    );
    await harness.pump(tester, const AddExercisePage());
    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel('Name'), 'Reverse fly');
    await tester.tap(find.byType(DropdownButtonFormField<String?>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Back').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('This exercise already exists'), findsOneWidget);
    expect(find.text('Add exercise'), findsOneWidget);
    expect(await getExercisesByName('Reverse fly'), hasLength(1));
  });

  testWidgets('AddExercise allows the same name in another category', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await _showCategories(harness);
    await createExerciseDefinition(
      name: 'Reverse fly',
      cardio: false,
      displayUnit: 'kg',
      category: 'Back',
    );
    await createCategory('Shoulders');
    await harness.pump(tester, const AddExercisePage());
    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel('Name'), 'Reverse fly');
    await tester.tap(find.byType(DropdownButtonFormField<String?>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shoulders').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('This exercise already exists'), findsNothing);
    expect(await getExercise(_back), isA<Exercise>());
    expect(await getExercise(_shoulders), isA<Exercise>());
  });

  testWidgets('graph list adds the category only to shared names', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await _seedReverseFly(harness);
    await insertExerciseSetFixture(harness.database, 'Squat', category: 'Legs');
    await harness.pump(tester, GraphsPage(tabController: MockTabController()));
    await tester.pumpAndSettle();

    expect(find.text('Reverse fly (Back)'), findsOneWidget);
    expect(find.text('Reverse fly (Shoulders)'), findsOneWidget);
    expect(find.text('Squat'), findsOneWidget);
  });

  testWidgets('grouped history keeps same-named categories apart', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.database.settings.update().write(
      testSettings(groupHistory: true),
    );
    for (final category in ['Back', 'Shoulders']) {
      await insertExerciseSetFixture(
        harness.database,
        'Reverse fly',
        category: category,
      );
    }
    await harness.pump(tester, HistoryPage(tabController: MockTabController()));
    await tester.pumpAndSettle();

    expect(find.text('Reverse fly (Back) (1)'), findsOneWidget);
    expect(find.text('Reverse fly (Shoulders) (1)'), findsOneWidget);
  });

  testWidgets('swap picker lists each category separately', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final plan = await (harness.database.plans.select()..limit(1)).getSingle();
    final original =
        await (harness.database.planExercises.select()
              ..where((exercise) => exercise.planId.equals(plan.id)))
            .get();
    for (final category in ['Back', 'Shoulders']) {
      await createExerciseDefinition(
        name: 'Reverse fly',
        cardio: false,
        displayUnit: 'kg',
        category: category,
      );
    }
    await harness.pump(
      tester,
      Scaffold(body: SwapWorkout(planExerciseId: original.first.id)),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Reverse');
    await tester.pumpAndSettle();
    expect(find.text('Reverse fly (Back)'), findsOneWidget);
    expect(find.text('Reverse fly (Shoulders)'), findsOneWidget);

    await tester.tap(find.text('Reverse fly (Shoulders)'));
    await tester.pumpAndSettle();

    final swapped =
        await (harness.database.planExercises.select()
              ..where((row) => row.id.equals(original.first.id)))
            .getSingle();
    final shoulders = await getExercise(_shoulders);
    expect(swapped.exerciseId, shoulders!.id);
  });

  testWidgets('custom rest times are edited per exercise, not per name', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    for (final category in ['Back', 'Shoulders']) {
      await createExerciseDefinition(
        name: 'Reverse fly',
        cardio: false,
        displayUnit: 'kg',
        category: category,
        defaultRestDurationMs: 60000,
      );
    }
    await harness.pump(tester, const TimerSettings());
    await tester.pumpAndSettle();

    final card = find.widgetWithText(Card, 'Reverse fly (Shoulders)');
    await tester.scrollUntilVisible(
      card,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(
      find.descendant(of: card, matching: find.widgetWithText(TextField, '1')),
      '3',
    );
    await tester.pumpAndSettle();

    expect((await getExercise(_shoulders))!.defaultRestDurationMs, 180000);
    expect((await getExercise(_back))!.defaultRestDurationMs, 60000);
  });
}
