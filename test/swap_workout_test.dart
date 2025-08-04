import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/swap_workout.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('SwapWorkout', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
    final settings = await (db.settings.select()..limit(1)).getSingle();
    final plans = await (db.plans.select()).get();
    final exercise = plans.first.exercises.split(',').first;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SwapWorkout(exercise: exercise, planId: plans.first.id),
          ),
        ),
      ),
    );

    expect(find.text('Swap workout'), findsOne);

    await tester.pumpAndSettle();
    expect(find.text('Arnold press'), findsOne);

    await tester.tap(find.text('Arnold press'));
    await tester.pumpAndSettle();
    expect(find.text('Swap workout'), findsNothing);

    await db.close();
  });
}
