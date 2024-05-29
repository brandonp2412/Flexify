import 'package:flexify/database.dart';
import 'package:flexify/edit_gym_set.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan_state.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('EditGymSet inserts', (WidgetTester tester) async {
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: EditGymSet(
            gymSet: GymSet(
              id: 0,
              name: "Bench press",
              reps: 2,
              weight: 3,
              unit: 'kg',
              created: DateTime.now(),
              hidden: false,
              bodyWeight: 52,
              duration: 3,
              distance: 6,
              cardio: false,
            ),
          ),
        ),
      ),
    );

    expect(find.text("Bench press"), findsOne);

    final button = find.byTooltip("Save");
    expect(button, findsOne);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsNothing);

    await db.close();
  });

  testWidgets('EditGymSet updates', (WidgetTester tester) async {
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: EditGymSet(
            gymSet: GymSet(
              id: 1,
              name: "Bench press",
              reps: 2,
              weight: 3,
              unit: 'kg',
              created: DateTime.now(),
              hidden: false,
              bodyWeight: 52,
              duration: 3,
              distance: 6,
              cardio: false,
            ),
          ),
        ),
      ),
    );

    expect(find.text("Bench press"), findsOne);

    final button = find.byTooltip("Save");
    expect(button, findsOne);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsNothing);

    await db.close();
  });
}
