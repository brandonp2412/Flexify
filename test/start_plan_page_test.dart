import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('StartPlanPage renders', (WidgetTester tester) async {
    await mockTests();

    final planCompanion = PlansCompanion.insert(
      days: 'Monday,Tuesday,Wednesday',
      exercises: 'Bench press,Barbell row,Squat',
    );
    final id = await (db.plans.insertOne(planCompanion));
    final plan =
        await (db.plans.select()..where((u) => u.id.equals(id))).getSingle();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: StartPlanPage(
            plan: plan,
            refresh: () => Future.value(null),
          ),
        ),
      ),
    );

    expect(find.textContaining("Monday, tuesday, wednesday"), findsOne);
    expect(find.textContaining("Bench press"), findsOne);
    expect(find.textContaining("Barbell row"), findsOne);
    expect(find.textContaining("Squat"), findsOne);

    await db.close();
  });

  testWidgets('StartPlanPage selects', (WidgetTester tester) async {
    await mockTests();

    final planCompanion = PlansCompanion.insert(
      days: 'Monday,Tuesday,Wednesday',
      exercises: 'Bench press,Barbell row,Squat',
    );
    final id = await (db.plans.insertOne(planCompanion));
    final plan =
        await (db.plans.select()..where((u) => u.id.equals(id))).getSingle();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: StartPlanPage(
            plan: plan,
            refresh: () => Future.value(null),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Barbell row'));
    await tester.pumpAndSettle();

    await db.close();
  });

  testWidgets('StartPlanPage saves', (WidgetTester tester) async {
    await mockTests();

    final planCompanion = PlansCompanion.insert(
      days: 'Monday,Tuesday,Wednesday',
      exercises: 'Barbell bench press,Barbell bent-over row,Crunch',
    );
    final id = await (db.plans.insertOne(planCompanion));
    final plan =
        await (db.plans.select()..where((u) => u.id.equals(id))).getSingle();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: StartPlanPage(
            plan: plan,
            refresh: () => Future.value(null),
          ),
        ),
      ),
    );

    await tester.enterText(find.bySemanticsLabel('Reps'), '5');
    await tester.enterText(find.bySemanticsLabel('Weight (kg)'), '50');
    await tester.pumpAndSettle();
    expect(find.text('50'), findsOne);

    final save = find.byTooltip('Save');
    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(find.text("(1 / 3)"), findsWidgets);

    await db.close();
  });
}
