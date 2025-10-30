import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('EditPlanPage updates', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
    final settings = await (db.settings.select()..limit(1)).getSingle();
    final planState = PlanState();

    const plan = PlansCompanion(
      days: Value('Monday,Tuesday,Wednesday'),
      sequence: Value(1),
      title: Value('Test title'),
      id: Value(1),
    );
    final planExercises = [
      PlanExercisesCompanion.insert(
        enabled: true,
        exercise: 'Arnold press',
        planId: 1,
      ),
      PlanExercisesCompanion.insert(
        enabled: true,
        exercise: 'Back extension',
        planId: 1,
      ),
      PlanExercisesCompanion.insert(
        enabled: true,
        exercise: 'Barbell bench press',
        planId: 1,
      ),
    ];

    await db.plans.deleteAll();
    await db.planExercises.deleteAll();
    await db.plans.insertOne(plan);
    await db.planExercises.insertAll(planExercises);

    planState.setExercises(plan);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => planState),
        ],
        child: const MaterialApp(
          home: EditPlanPage(
            plan: plan,
          ),
        ),
      ),
    );

    expect(find.text("Test title"), findsOne);
    expect(find.text("Mon"), findsOne);
    expect(find.text("Tue"), findsOne);
    expect(find.text("Wed"), findsOne);
    expect(find.text("Save"), findsOne);

    await tester.tap(find.text('Mon'));
    await tester.tap(find.text('Thu'));
    await scroll(tester, find.text('Arnold press'));
    await tester.tap(find.text('Arnold press'));
    await tester.tap(find.text('Barbell biceps curl'));

    await tester.tap(find.text("Save"));
    await tester.pumpAndSettle();
    expect(find.textContaining('Title'), findsNothing);

    await db.close();
  });

  testWidgets('EditPlanPage searches', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
    final settings = await (db.settings.select()..limit(1)).getSingle();

    const plan = PlansCompanion(
      days: Value('Monday,Tuesday,Wednesday'),
      sequence: Value(1),
      title: Value('Test title'),
      id: Value(1),
    );
    final planExercises = [
      PlanExercisesCompanion.insert(
        enabled: true,
        exercise: 'Arnold press',
        planId: 1,
      ),
      PlanExercisesCompanion.insert(
        enabled: true,
        exercise: 'Back extension',
        planId: 1,
      ),
      PlanExercisesCompanion.insert(
        enabled: true,
        exercise: 'Barbell bench press',
        planId: 1,
      ),
    ];

    await db.plans.insertOne(plan);
    await db.planExercises.insertAll(planExercises);

    final planState = PlanState();
    await planState.setExercises(plan);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => planState),
        ],
        child: const MaterialApp(
          home: EditPlanPage(
            plan: plan,
          ),
        ),
      ),
    );

    await scroll(tester, find.text('Arnold press'));
    await tester.enterText(find.byType(SearchBar), 'Back extension');
    await tester.pumpAndSettle();
    expect(find.text('Back extension'), findsNWidgets(2));
    expect(find.text('Arnold press'), findsNothing);

    await db.close();
  });
}
