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
  testWidgets('EditPlanPage inserts', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory());
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: EditPlanPage(
            plan: PlansCompanion(
              days: Value(''),
              exercises: Value(''),
              sequence: Value(0),
              title: Value(''),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining("Title"), findsOne);

    await tester.tap(find.text('Monday'));
    await tester.tap(find.text('Wednesday'));
    await tester.tap(find.text('Sunday'));
    await tester.enterText(find.byType(SearchBar), 'Squat');
    await tester.tap(find.text('Squat'));
    await tester.pumpAndSettle();

    final button = find.byTooltip("Save");
    expect(button, findsOne);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.textContaining('Title'), findsNothing);

    await db.close();
  });

  testWidgets('EditPlanPage searches', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(executor: NativeDatabase.memory());
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
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

    await tester.enterText(find.byType(SearchBar), 'Squat');
    await tester.pumpAndSettle();
    expect(find.text('Squat'), findsOne);
    expect(find.text('Dumbbell shoulder press'), findsNothing);

    await db.close();
  });
}
