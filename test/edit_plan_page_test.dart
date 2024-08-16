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
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
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
              exercises:
                  Value('Arnold press,Back extension,Barbell bench press'),
              sequence: Value(1),
              title: Value('Test title'),
              id: Value(1),
            ),
          ),
        ),
      ),
    );

    expect(find.text("Test title"), findsOne);
    expect(find.text("Monday"), findsOne);
    expect(find.text("Tuesday"), findsOne);
    expect(find.text("Wednesday"), findsOne);
    expect(find.text("Save"), findsOne);

    await tester.tap(find.text('Monday'));
    await tester.tap(find.text('Thursday'));
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
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();

    const plan = PlansCompanion(
      days: Value('Monday,Tuesday,Wednesday'),
      exercises: Value('Arnold press,Back extension,Barbell bench press'),
      sequence: Value(1),
      title: Value('Test title'),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
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
