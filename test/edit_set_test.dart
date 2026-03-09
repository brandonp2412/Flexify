import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  testWidgets('EditGymSet inserts', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: EditSetPage(
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

    expect(find.bySemanticsLabel("Name"), findsOne);
    final reps = find.bySemanticsLabel('Reps');
    final weight = find.bySemanticsLabel('Weight (kg)');
    expect(reps, findsOne);
    expect(weight, findsOne);

    await tester.enterText(reps, '10');
    await tester.enterText(weight, '50');

    final button = find.text("Save");
    expect(button, findsOne);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsNothing);

    await db.close();
  });

  testWidgets('selecting new cardio exercise shows cardio fields',
      (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());

    // Insert a hidden set representing a cardio exercise definition
    // (as edit_graph_page does when creating/editing an exercise as cardio)
    await db.into(db.gymSets).insert(
          GymSetsCompanion.insert(
            name: 'Running',
            reps: 0,
            weight: 0,
            unit: 'km',
            created: DateTime.now(),
            hidden: const Value(true),
            cardio: const Value(true),
          ),
        );

    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: EditSetPage(
            gymSet: GymSet(
              id: 0,
              name: "Bench press",
              reps: 2,
              weight: 3,
              unit: 'kg',
              created: DateTime.now(),
              hidden: false,
              bodyWeight: 0,
              duration: 0,
              distance: 0,
              cardio: false,
            ),
          ),
        ),
      ),
    );

    // Initially shows strength fields
    expect(find.bySemanticsLabel('Reps'), findsOne);

    // Type the cardio exercise name in the autocomplete
    await tester.enterText(find.bySemanticsLabel('Name'), 'Running');
    await tester.pump();

    // Select 'Running' from the autocomplete dropdown
    await tester.tap(find.text('Running').last);
    await tester.pumpAndSettle();

    // Should now show cardio fields (Distance), not strength fields (Reps)
    expect(find.bySemanticsLabel('Reps'), findsNothing);
    expect(find.bySemanticsLabel('Distance (km)'), findsOne);

    await db.close();
  });

  testWidgets('EditGymSet updates', (WidgetTester tester) async {
    await mockTests();
    db = AppDatabase(NativeDatabase.memory());
    final settings = await (db.settings.select()..limit(1)).getSingle();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState(settings)),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: EditSetPage(
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

    expect(find.text("Bench press"), findsNWidgets(2));

    final button = find.text("Save");
    expect(button, findsOne);

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Bench press'), findsNothing);

    await db.close();
  });
}
