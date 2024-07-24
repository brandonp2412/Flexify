import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('AddExercise', (WidgetTester tester) async {
    db = AppDatabase(executor: NativeDatabase.memory(), logStatements: false);
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await mockTests();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: const MaterialApp(
          home: AddExercisePage(),
        ),
      ),
    );

    expect(find.text("Add exercise"), findsOne);
    await tester.enterText(find.bySemanticsLabel('Name'), 'Bench press 2');

    final button = find.byTooltip("Save");
    expect(button, findsOne);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.textContaining('Add exercise'), findsNothing);

    await db.close();
  });
}
