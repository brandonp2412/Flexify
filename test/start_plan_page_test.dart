import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('StartPlanPage renders', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());

    await (db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 2,
        weight: 90,
        unit: 'kg',
        created: DateTime.now(),
        category: Value("Chest"),
      ),
      GymSetsCompanion.insert(
        name: 'Barbell row',
        reps: 5,
        weight: 60,
        unit: 'kg',
        created: DateTime.now(),
        category: Value("Shoulders"),
      ),
      GymSetsCompanion.insert(
        name: 'Squat',
        reps: 7,
        weight: 100,
        unit: 'kg',
        created: DateTime.now(),
        category: Value("Legs"),
      ),
    ]));

    final planCompanion = PlansCompanion.insert(
      days: 'Monday,Tuesday,Wednesday',
    );
    final id = await (db.plans.insertOne(planCompanion));
    await db.planExercises.insertAll([
      PlanExercisesCompanion.insert(
        planId: id,
        exercise: 'Bench press',
        enabled: true,
      ),
      PlanExercisesCompanion.insert(
        planId: id,
        exercise: 'Barbell row',
        enabled: true,
      ),
      PlanExercisesCompanion.insert(
        planId: id,
        exercise: 'Squat',
        enabled: true,
      ),
    ]);
    final plan =
        await (db.plans.select()..where((u) => u.id.equals(id))).getSingle();

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: StartPlanPage(
            plan: plan,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining("Monday, tuesday, wednesday"), findsOne);
    expect(find.textContaining("Bench press"), findsOne);
    expect(find.textContaining("Barbell row"), findsOne);
    expect(find.textContaining("Squat"), findsOne);

    await db.close();
  });

  testWidgets('StartPlanPage selects', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());

    await (db.gymSets.insertAll([
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 2,
        weight: 90,
        unit: 'kg',
        created: DateTime.now(),
        category: Value("Chest"),
      ),
      GymSetsCompanion.insert(
        name: 'Barbell row',
        reps: 5,
        weight: 60,
        unit: 'kg',
        created: DateTime.now(),
        category: Value("Shoulders"),
      ),
      GymSetsCompanion.insert(
        name: 'Squat',
        reps: 7,
        weight: 100,
        unit: 'kg',
        created: DateTime.now(),
        category: Value("Legs"),
      ),
    ]));

    final planCompanion = PlansCompanion.insert(
      days: 'Monday,Tuesday,Wednesday',
    );
    final id = await (db.plans.insertOne(planCompanion));

    await db.planExercises.insertAll([
      PlanExercisesCompanion.insert(
        planId: id,
        exercise: 'Bench press',
        enabled: true,
      ),
      PlanExercisesCompanion.insert(
        planId: id,
        exercise: 'Barbell row',
        enabled: true,
      ),
      PlanExercisesCompanion.insert(
        planId: id,
        exercise: 'Squat',
        enabled: true,
      ),
    ]);

    final plan =
        await (db.plans.select()..where((u) => u.id.equals(id))).getSingle();

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: StartPlanPage(
            plan: plan,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Barbell row'));
    await tester.pumpAndSettle();

    await db.close();
  });

  testWidgets('StartPlanPage saves', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());

    final planCompanion = PlansCompanion.insert(
      days: 'Monday,Tuesday,Wednesday',
    );
    final id = await (db.plans.insertOne(planCompanion));
    final plan =
        await (db.plans.select()..where((u) => u.id.equals(id))).getSingle();

    await db.planExercises.insertAll([
      PlanExercisesCompanion.insert(
        planId: plan.id,
        exercise: 'Barbell bench press',
        enabled: true,
        sequence: Value(0),
      ),
      PlanExercisesCompanion.insert(
        planId: plan.id,
        exercise: 'Barbell bent-over row',
        enabled: true,
        sequence: Value(1),
      ),
      PlanExercisesCompanion.insert(
        planId: plan.id,
        exercise: 'Crunch',
        enabled: true,
        sequence: Value(2),
      ),
    ]);

    await db.settings.update().write(
          SettingsCompanion(explainedPermissions: Value(true)),
        );
    final settings = await (db.settings.select()..limit(1)).getSingle();

    final planState = PlanState();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => SettingsState(settings),
          ),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider.value(value: planState),
        ],
        child: MaterialApp(
          home: StartPlanPage(
            plan: plan,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel('Reps'), '5');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '50');
    await tester.pumpAndSettle();
    expect(find.text('50'), findsOne);

    final save = find.text('Save');
    await tester.tap(save);
    await tester.pumpAndSettle();

    final gymSets = await (db.gymSets.select()
          ..where((u) => u.name.equals('Barbell bench press')))
        .get();

    expect(gymSets.length, equals(2));

    await db.close();
  });
}
