import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/l10n/locale_preferences.dart';
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flexify/plan/workout_sessions.dart';
import 'package:flexify/stepper_field.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixtures.dart';
import 'support/test_app.dart';

Finder textFieldWithLabel(String label) => find.descendant(
  of: find.byWidgetPredicate(
    (widget) => widget is StepperField && widget.labelText == label,
  ),
  matching: find.byType(EditableText),
);

Finder editableWithSemanticsLabel(String label) => find.descendant(
  of: find.bySemanticsLabel(label),
  matching: find.byType(EditableText),
);

class RecordingTimerState extends TimerState {
  String? lastTitle;

  @override
  Future<void> startTimer(
    String title,
    Duration rest,
    String alarmSound,
    bool vibrate,
    bool enableSound, [
    String target = 'timer',
  ]) async {
    lastTitle = title;
  }
}

void main() {
  testWidgets('StartPlanPage shows its page chrome on the first frame', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(
      planFixture(title: 'Immediate plan'),
    );
    final plan =
        await (database.plans.select()..where((plan) => plan.id.equals(id)))
            .getSingle();

    await harness.pump(tester, StartPlanPage(plan: plan));

    expect(find.text('Immediate plan'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('cached plan exercises render on the first frame', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(
      planFixture(title: 'Cached plan'),
    );
    await insertPlanExerciseFixture(
      database,
      planId: id,
      exercise: 'Instant bench press',
    );
    final plan =
        await (database.plans.select()..where((plan) => plan.id.equals(id)))
            .getSingle();
    final planExercise =
        await (database.planExercises.select()
              ..where((entry) => entry.planId.equals(id))
              ..limit(1))
            .getSingle();
    final exercise =
        await (database.exercises.select()
              ..where((entry) => entry.id.equals(planExercise.exerciseId))
              ..limit(1))
            .getSingle();
    final exercises = [
      PlanExerciseEntry(planExercise: planExercise, exercise: exercise),
    ];

    await harness.pump(
      tester,
      StartPlanPage(plan: plan, initialExercises: exercises),
      surfaceSize: const Size(1200, 800),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Instant bench press'), findsWidgets);
    expect(find.text('Cached plan'), findsOneWidget);
  });

  testWidgets(
    'StartPlanPage rep estimation does not crash when no RPM data for exercise',
    (WidgetTester tester) async {
      final harness = await FlexifyTestHarness.create();
      final database = harness.database;

      final id = await database.plans.insertOne(planFixture());
      await insertPlanExerciseFixture(
        database,
        planId: id,
        exercise: 'Bench press',
      );
      await database.settings.update().write(
        testSettings(
          repEstimation: true,
          explainedPermissions: true,
          notificationPermissionRequested: true,
        ),
      );

      final plan =
          await (database.plans.select()..where((plan) => plan.id.equals(id)))
              .getSingle();
      await harness.pump(tester, StartPlanPage(plan: plan));
      await tester.pumpAndSettle();

      await tester.enterText(textFieldWithLabel('Reps'), '5');
      await tester.enterText(textFieldWithLabel('Weight (kg)'), '50');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
    },
  );

  testWidgets('StartPlanPage with no exercises does not crash on save', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(planFixture());
    await database.settings.update().write(
      testSettings(explainedPermissions: true),
    );
    final plan =
        await (database.plans.select()..where((plan) => plan.id.equals(id)))
            .getSingle();
    await harness.pump(tester, StartPlanPage(plan: plan));
    await tester.pumpAndSettle();

    expect(find.text('Save'), findsNothing);
  });

  testWidgets('StartPlanPage renders', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    await insertExerciseSetFixture(
      database,
      'Bench press',
      reps: 2,
      weight: 90,
      category: 'Chest',
    );
    await insertExerciseSetFixture(
      database,
      'Barbell row',
      reps: 5,
      weight: 60,
      category: 'Shoulders',
    );
    await insertExerciseSetFixture(
      database,
      'Squat',
      reps: 7,
      weight: 100,
      category: 'Legs',
    );

    final id = await database.plans.insertOne(
      planFixture(days: 'Monday,Tuesday,Wednesday'),
    );
    await insertPlanExerciseFixture(
      database,
      planId: id,
      exercise: 'Bench press',
      sequence: 0,
    );
    await insertPlanExerciseFixture(
      database,
      planId: id,
      exercise: 'Barbell row',
      sequence: 1,
    );
    await insertPlanExerciseFixture(
      database,
      planId: id,
      exercise: 'Squat',
      sequence: 2,
    );
    final plan =
        await (database.plans.select()..where((plan) => plan.id.equals(id)))
            .getSingle();
    await harness.pump(
      tester,
      StartPlanPage(plan: plan),
      surfaceSize: const Size(800, 1200),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Bench press'), findsOne);
    expect(find.textContaining('Barbell row'), findsOne);
    expect(find.textContaining('Squat'), findsOne);

    final floatingRow = find.byKey(const Key('start-plan-floating-row'));
    expect(floatingRow, findsOneWidget);
    expect(
      (tester.widget<Padding>(floatingRow).padding as EdgeInsets).bottom,
      bottomNavHeight,
    );

    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();

    expect(
      (tester.widget<Padding>(floatingRow).padding as EdgeInsets).bottom,
      0,
    );
  });

  testWidgets('all translated locales complete the core workout save flow', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    for (final locale in selectableLocales.skip(1)) {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      final l10n = lookupAppLocalizations(locale);
      final exercise = 'User lift ${locale.toLanguageTag()}';
      final id = await database.plans.insertOne(planFixture());
      await insertPlanExerciseFixture(database, planId: id, exercise: exercise);
      await database.settings.update().write(
        testSettings(
          explainedPermissions: true,
          notificationPermissionRequested: true,
        ),
      );
      final plan =
          await (database.plans.select()..where((plan) => plan.id.equals(id)))
              .getSingle();

      await harness.pump(
        tester,
        StartPlanPage(plan: plan),
        locale: locale,
        surfaceSize: const Size(430, 900),
        textScaler: const TextScaler.linear(1.1),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining(exercise), findsOneWidget);
      await tester.enterText(textFieldWithLabel(l10n.repsLabel), '5');
      await tester.enterText(
        textFieldWithLabel(l10n.weightWithUnit('kg')),
        '50',
      );
      await tester.tap(find.text(l10n.actionSave));
      await tester.pumpAndSettle();

      final saved = await getLatestExerciseSet(
        database,
        exerciseName: exercise,
      );
      expect(saved!.name, exercise, reason: locale.toLanguageTag());
      expect(saved.reps, 5, reason: locale.toLanguageTag());
      expect(saved.weight, 50, reason: locale.toLanguageTag());
      expect(tester.takeException(), isNull, reason: locale.toLanguageTag());
    }
  });

  testWidgets('rapid save taps create only one workout set', (
    WidgetTester tester,
  ) async {
    const exercise = 'Rapid tap bench press';
    final l10n = lookupAppLocalizations(const Locale('en'));
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(planFixture());
    await insertPlanExerciseFixture(database, planId: id, exercise: exercise);
    await database.settings.update().write(
      testSettings(
        explainedPermissions: true,
        notificationPermissionRequested: true,
        restTimers: false,
      ),
    );
    final plan =
        await (database.plans.select()..where((plan) => plan.id.equals(id)))
            .getSingle();

    await harness.pump(tester, StartPlanPage(plan: plan));
    await tester.pumpAndSettle();

    await tester.enterText(textFieldWithLabel(l10n.repsLabel), '5');
    await tester.enterText(textFieldWithLabel(l10n.weightWithUnit('kg')), '50');

    await tester.tap(find.text(l10n.actionSave));
    await tester.tap(find.text(l10n.actionSave));
    await tester.pumpAndSettle();

    final saved = await getExerciseSetsForExercise(
      database,
      exerciseName: exercise,
    );
    expect(saved, hasLength(1));
  });

  testWidgets('StartPlanPage saves localized German decimal input', (
    WidgetTester tester,
  ) async {
    const locale = Locale('de');
    const exercise = 'Custom dragon press';
    const planTitle = 'Untranslated custom plan';
    const note = 'Keep tempo 3-1-1';
    final l10n = lookupAppLocalizations(locale);
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(planFixture(title: planTitle));
    await insertPlanExerciseFixture(database, planId: id, exercise: exercise);
    await database.settings.update().write(
      testSettings(
        explainedPermissions: true,
        notificationPermissionRequested: true,
        showNotes: true,
      ),
    );
    final plan =
        await (database.plans.select()..where((plan) => plan.id.equals(id)))
            .getSingle();

    await harness.pump(
      tester,
      StartPlanPage(plan: plan),
      locale: locale,
      surfaceSize: const Size(430, 900),
      textScaler: const TextScaler.linear(1.25),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining(exercise), findsOneWidget);
    expect(find.text(planTitle), findsOneWidget);
    await tester.enterText(textFieldWithLabel(l10n.repsLabel), '5');
    await tester.enterText(
      textFieldWithLabel(l10n.weightWithUnit('kg')),
      '50,5',
    );
    await tester.enterText(find.bySemanticsLabel(l10n.notesLabel), note);
    await tester.tap(find.text(l10n.actionSave));
    await tester.pumpAndSettle();

    final saved = await getLatestExerciseSet(database, exerciseName: exercise);
    expect(saved!.name, exercise);
    expect(saved.notes, note);
    expect(saved.weight, 50.5);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'StartPlanPage renders Japanese without rewriting exercise text',
    (WidgetTester tester) async {
      const locale = Locale('ja');
      const exercise = 'User-defined dragon press';
      final l10n = lookupAppLocalizations(locale);
      final harness = await FlexifyTestHarness.create();
      final database = harness.database;

      final id = await database.plans.insertOne(planFixture());
      await insertPlanExerciseFixture(database, planId: id, exercise: exercise);
      await database.settings.update().write(
        testSettings(explainedPermissions: true),
      );
      final plan =
          await (database.plans.select()..where((plan) => plan.id.equals(id)))
              .getSingle();

      await harness.pump(
        tester,
        StartPlanPage(plan: plan),
        locale: locale,
        surfaceSize: const Size(320, 720),
        textScaler: const TextScaler.linear(1.5),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining(exercise), findsOneWidget);
      expect(textFieldWithLabel(l10n.repsLabel), findsOneWidget);
      expect(textFieldWithLabel(l10n.weightWithUnit('kg')), findsOneWidget);
      expect(find.text(l10n.actionSave), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('StartPlanPage swap immediately loads replacement defaults', (
    WidgetTester tester,
  ) async {
    const originalExercise = 'Machine chest press';
    const replacementExercise = 'Dumbbell chest press';
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final planId = await database.plans.insertOne(
      planFixture(title: 'Chest day'),
    );
    final originalExerciseId = await database.exercises.insertOne(
      exerciseFixture(originalExercise),
    );
    final replacementExerciseId = await database.exercises.insertOne(
      exerciseFixture(replacementExercise),
    );
    await database.planExercises.insertOne(
      planExerciseFixture(planId: planId, exerciseId: originalExerciseId),
    );
    final originalHistory = exerciseSetFixture(
      originalExercise,
      reps: 10,
      weight: 50,
      planId: planId,
      created: testNow.subtract(const Duration(days: 7)),
    );
    final replacementHistory = exerciseSetFixture(
      replacementExercise,
      reps: 8,
      weight: 30,
      created: testNow.subtract(const Duration(days: 2)),
    );
    final oldWorkout = await resumeOrStartWorkout(
      database,
      planId,
      now: originalHistory.created,
    );
    await insertExerciseSet(
      database,
      exerciseSet: originalHistory,
      exerciseId: originalExerciseId,
      workoutId: oldWorkout.id,
    );
    await finishWorkout(
      database,
      oldWorkout.id,
      now: originalHistory.created.add(const Duration(minutes: 30)),
    );
    await insertExerciseSet(
      database,
      exerciseSet: replacementHistory,
      exerciseId: replacementExerciseId,
      workoutId: null,
    );
    await database.settings.update().write(
      testSettings(
        explainedPermissions: true,
        notificationPermissionRequested: true,
      ),
    );
    final plan =
        await (database.plans.select()..where((p) => p.id.equals(planId)))
            .getSingle();
    final initialPrefill = await getStartPlanPrefillById(
      database,
      exerciseId: originalExerciseId,
      planId: planId,
    );
    expect(initialPrefill?.reps, 10);
    expect(initialPrefill?.weight, 50);

    await harness.pump(tester, StartPlanPage(plan: plan));
    await tester.pumpAndSettle();

    expect(
      tester.widget<EditableText>(textFieldWithLabel('Reps')).controller.text,
      '10',
    );
    expect(
      tester
          .widget<EditableText>(textFieldWithLabel('Weight (kg)'))
          .controller
          .text,
      '50',
    );

    await tester.longPress(find.byKey(const Key(originalExercise)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Swap'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), replacementExercise);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ListTile, replacementExercise));
    await tester.pumpAndSettle();

    final swapped =
        await (database.planExercises.select()
              ..where((exercise) => exercise.planId.equals(planId)))
            .getSingle();
    expect(swapped.exerciseId, replacementExerciseId);
    expect(find.text(replacementExercise), findsWidgets);
    expect(
      tester.widget<EditableText>(textFieldWithLabel('Reps')).controller.text,
      '8',
    );
    expect(
      tester
          .widget<EditableText>(textFieldWithLabel('Weight (kg)'))
          .controller
          .text,
      '30',
    );
  });

  testWidgets('StartPlanPage submit focuses notes before saving', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(planFixture());
    await insertPlanExerciseFixture(
      database,
      planId: id,
      exercise: 'Bench press',
    );
    await database.settings.update().write(testSettings(showNotes: true));
    final plan =
        await (database.plans.select()..where((plan) => plan.id.equals(id)))
            .getSingle();

    await harness.pump(tester, StartPlanPage(plan: plan));
    await tester.pumpAndSettle();

    final reps = textFieldWithLabel('Reps');
    final weight = textFieldWithLabel('Weight (kg)');
    final notes = editableWithSemanticsLabel('Notes');

    await tester.tap(reps);
    await tester.showKeyboard(reps);
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();

    expect(tester.widget<EditableText>(weight).focusNode.hasFocus, isTrue);

    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();

    expect(notes, findsOne);
    expect(tester.widget<EditableText>(notes).focusNode.hasFocus, isTrue);
    expect(await getExerciseSets(database, search: 'Bench press'), isEmpty);

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(
      await getExerciseSets(database, search: 'Bench press'),
      hasLength(1),
    );
  });

  testWidgets('StartPlanPage cardio submit follows visible fields then saves', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(planFixture());
    await insertPlanExerciseFixture(
      database,
      planId: id,
      exercise: 'Sled push',
      cardio: true,
      unit: 'kg',
    );

    final plan =
        await (database.plans.select()..where((plan) => plan.id.equals(id)))
            .getSingle();

    await harness.pump(tester, StartPlanPage(plan: plan));
    await tester.pumpAndSettle();

    final minutes = editableWithSemanticsLabel('Minutes');
    final seconds = editableWithSemanticsLabel('Seconds');
    final weight = textFieldWithLabel('Weight (kg)');
    final incline = editableWithSemanticsLabel('Incline %');

    await tester.tap(minutes);
    await tester.showKeyboard(minutes);
    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(tester.widget<EditableText>(seconds).focusNode.hasFocus, isTrue);

    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(tester.widget<EditableText>(weight).focusNode.hasFocus, isTrue);

    await tester.testTextInput.receiveAction(TextInputAction.next);
    await tester.pump();
    expect(tester.widget<EditableText>(incline).focusNode.hasFocus, isTrue);

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final saved = await getExerciseSets(database, search: 'Sled push');
    expect(saved, hasLength(1));
  });

  testWidgets('StartPlanPage compact desktop exercise list does not overflow', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(planFixture());
    final plan =
        await (database.plans.select()..where((row) => row.id.equals(id)))
            .getSingle();
    for (final exercise in const [
      'Barbell bench press',
      'Squat',
      'Lat pull-down',
    ]) {
      await insertPlanExerciseFixture(
        database,
        planId: plan.id,
        exercise: exercise,
      );
    }
    await database.settings.update().write(
      testSettings(
        explainedPermissions: true,
        notificationPermissionRequested: true,
      ),
    );

    await harness.pump(
      tester,
      StartPlanPage(plan: plan),
      surfaceSize: const Size(900, 900),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('StartPlanPage saves', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(
      planFixture(days: 'Monday,Tuesday,Wednesday'),
    );
    final plan =
        await (database.plans.select()..where((plan) => plan.id.equals(id)))
            .getSingle();

    await insertPlanExerciseFixture(
      database,
      planId: plan.id,
      exercise: 'Barbell bench press',
      sequence: 0,
    );
    await insertPlanExerciseFixture(
      database,
      planId: plan.id,
      exercise: 'Barbell bent-over row',
      sequence: 1,
    );
    await insertPlanExerciseFixture(
      database,
      planId: plan.id,
      exercise: 'Crunch',
      sequence: 2,
    );
    await database.settings.update().write(
      testSettings(
        explainedPermissions: true,
        notificationPermissionRequested: true,
      ),
    );
    await harness.pump(tester, StartPlanPage(plan: plan));
    await tester.pumpAndSettle();

    await tester.enterText(textFieldWithLabel('Reps'), '5');
    await tester.enterText(textFieldWithLabel('Weight (kg)'), '50');
    await tester.pumpAndSettle();
    expect(find.text('50'), findsOne);

    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final exerciseSetViews = await getExerciseSets(
      database,
      search: 'Barbell bench press',
    );
    expect(
      exerciseSetViews.where((set) => set.name == 'Barbell bench press'),
      hasLength(1),
    );

    final storedExerciseSets = await database.exerciseSets.select().get();
    expect(storedExerciseSets, hasLength(1));
    expect(storedExerciseSets.single.workoutId, isNotNull);
    final workout =
        await (database.workouts.select()..where(
              (row) => row.id.equals(storedExerciseSets.single.workoutId!),
            ))
            .getSingle();
    expect(workout.planId, plan.id);
  });

  testWidgets(
    'StartPlanPage rest timer title includes current and total sets',
    (WidgetTester tester) async {
      final harness = await FlexifyTestHarness.create();
      final database = harness.database;
      final timerState = RecordingTimerState();

      final id = await database.plans.insertOne(planFixture());
      final plan =
          await (database.plans.select()..where((plan) => plan.id.equals(id)))
              .getSingle();
      await insertPlanExerciseFixture(
        database,
        planId: plan.id,
        exercise: 'Dumbbell rows',
      );
      await database.settings.update().write(
        testSettings(
          restTimers: true,
          explainedPermissions: true,
          notificationPermissionRequested: true,
        ),
      );
      final settings = await (database.settings.select()..limit(1)).getSingle();

      await harness.pump(
        tester,
        StartPlanPage(plan: plan),
        timerState: timerState,
      );
      await tester.pumpAndSettle();

      await tester.enterText(textFieldWithLabel('Reps'), '8');
      await tester.enterText(textFieldWithLabel('Weight (kg)'), '30');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(timerState.lastTitle, 'Dumbbell rows (1/${settings.maxSets})');
      timerState.dispose();
    },
  );

  testWidgets('StartPlanPage shows this-session sets after saving', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(planFixture());
    final plan =
        await (database.plans.select()..where((plan) => plan.id.equals(id)))
            .getSingle();
    await insertPlanExerciseFixture(
      database,
      planId: plan.id,
      exercise: 'Bench press',
    );
    await database.settings.update().write(
      testSettings(
        explainedPermissions: true,
        notificationPermissionRequested: true,
      ),
    );
    await harness.pump(
      tester,
      StartPlanPage(plan: plan),
      surfaceSize: const Size(800, 1200),
    );
    await tester.pumpAndSettle();

    expect(find.text('Set 1'), findsNothing);

    await tester.enterText(textFieldWithLabel('Reps'), '5');
    await tester.enterText(textFieldWithLabel('Weight (kg)'), '50');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Set 1'), findsOne);
    expect(find.text('5 × 50 kg'), findsOne);
  });
}
