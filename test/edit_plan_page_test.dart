import 'package:drift/drift.dart';
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
  testWidgets('EditPlanPage inserts', (WidgetTester tester) async {
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: EditPlanPage(
            plan: PlansCompanion(
              days: Value('Monday,Tuesday,Wednesday'),
              exercises: Value('Bench press,Row,Bicep curl'),
              sequence: Value(1),
              title: Value('Test title'),
            ),
          ),
        ),
      ),
    );

    expect(find.textContaining("Title"), findsOne);

    final button = find.byTooltip("Save");
    expect(button, findsOne);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.textContaining('Title'), findsNothing);

    await db.close();
  });

  testWidgets('EditPlanPage searches', (WidgetTester tester) async {
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: EditPlanPage(
            plan: PlansCompanion(
              days: Value('Monday,Tuesday,Wednesday'),
              exercises: Value('Bench press,Row,Bicep curl'),
              sequence: Value(1),
              title: Value('Test title'),
            ),
          ),
        ),
      ),
    );

    expect(find.textContaining("Title"), findsOne);

    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.bySemanticsLabel('Search...'), "Bench press");
    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsOne);
    expect(find.text('Dumbbell shoulder press'), findsNothing);

    await db.close();
  });
}
