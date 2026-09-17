import 'package:drift/drift.dart' hide isNull;
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/l10n/locale_preferences.dart';
import 'package:flexify/plan/start_plan_page.dart';
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
  testWidgets(
    'StartPlanPage rep estimation does not crash when no RPM data for exercise',
    (WidgetTester tester) async {
      final harness = await FlexifyTestHarness.create();
      final database = harness.database;

      final id = await database.plans.insertOne(planFixture());
      await database.planExercises.insertOne(
        planExerciseFixture(planId: id, exercise: 'Bench press'),
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

    await database.gymSets.insertAll([
      gymSetFixture('Bench press', reps: 2, weight: 90, category: 'Chest'),
      gymSetFixture('Barbell row', reps: 5, weight: 60, category: 'Shoulders'),
      gymSetFixture('Squat', reps: 7, weight: 100, category: 'Legs'),
    ]);

    final id = await database.plans.insertOne(
      planFixture(days: 'Monday,Tuesday,Wednesday'),
    );
    await database.planExercises.insertAll([
      planExerciseFixture(planId: id, exercise: 'Bench press'),
      planExerciseFixture(planId: id, exercise: 'Barbell row'),
      planExerciseFixture(planId: id, exercise: 'Squat'),
    ]);
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
      await database.planExercises.insertOne(
        planExerciseFixture(planId: id, exercise: exercise),
      );
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

      final saved =
          await (database.gymSets.select()
                ..where((set) => set.name.equals(exercise))
                ..orderBy([(set) => OrderingTerm.desc(set.created)])
                ..limit(1))
              .getSingle();
      expect(saved.name, exercise, reason: locale.toLanguageTag());
      expect(saved.reps, 5, reason: locale.toLanguageTag());
      expect(saved.weight, 50, reason: locale.toLanguageTag());
      expect(tester.takeException(), isNull, reason: locale.toLanguageTag());
    }
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
    await database.planExercises.insertOne(
      planExerciseFixture(planId: id, exercise: exercise),
    );
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

    final saved =
        await (database.gymSets.select()
              ..where((set) => set.name.equals(exercise))
              ..orderBy([(set) => OrderingTerm.desc(set.created)])
              ..limit(1))
            .getSingle();
    expect(saved.name, exercise);
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
      await database.planExercises.insertOne(
        planExerciseFixture(planId: id, exercise: exercise),
      );
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

  testWidgets('StartPlanPage saves', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final id = await database.plans.insertOne(
      planFixture(days: 'Monday,Tuesday,Wednesday'),
    );
    final plan =
        await (database.plans.select()..where((plan) => plan.id.equals(id)))
            .getSingle();

    await database.planExercises.insertAll([
      planExerciseFixture(
        planId: plan.id,
        exercise: 'Barbell bench press',
        sequence: 0,
      ),
      planExerciseFixture(
        planId: plan.id,
        exercise: 'Barbell bent-over row',
        sequence: 1,
      ),
      planExerciseFixture(planId: plan.id, exercise: 'Crunch', sequence: 2),
    ]);
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

    final gymSets =
        await (database.gymSets.select()
              ..where((set) => set.name.equals('Barbell bench press')))
            .get();
    expect(gymSets.length, equals(2));
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
      await database.planExercises.insertOne(
        planExerciseFixture(planId: plan.id, exercise: 'Dumbbell rows'),
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
    await database.planExercises.insertOne(
      planExerciseFixture(planId: plan.id, exercise: 'Bench press'),
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
    expect(find.text('50 kg × 5'), findsOne);
  });

  test('StartPlanPage prefill lookup uses the same plan only', () async {
    final harness = await FlexifyTestHarness.create();
    final database = harness.database;

    final currentPlanId = await database.plans.insertOne(
      planFixture(title: 'Current plan'),
    );
    final otherPlanId = await database.plans.insertOne(
      planFixture(title: 'Other plan'),
    );
    final currentSessionStart = testNow.subtract(const Duration(days: 2));
    await database.gymSets.insertAll([
      gymSetFixture(
        'Bench press',
        reps: 5,
        weight: 50,
        planId: currentPlanId,
        created: currentSessionStart,
      ),
      gymSetFixture(
        'Bench press',
        reps: 4,
        weight: 55,
        planId: currentPlanId,
        created: currentSessionStart.add(const Duration(minutes: 5)),
      ),
      gymSetFixture(
        'Bench press',
        reps: 1,
        weight: 100,
        planId: otherPlanId,
        created: testNow.subtract(const Duration(days: 1)),
      ),
    ]);

    final first = await getFirstOfLastPlanSession(
      database,
      'Bench press',
      currentPlanId,
    );

    expect(first == null, false);
    expect(first!.planId, currentPlanId);
    expect(first.reps, 5);
    expect(first.weight, 50);
  });
}
