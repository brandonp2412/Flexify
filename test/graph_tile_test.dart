import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/graph_tile.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mock_tests.dart';

void main() async {
  await mockTests();

  testWidgets('GraphTile', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsState()),
          ChangeNotifierProvider(create: (context) => TimerState()),
          ChangeNotifierProvider(create: (context) => PlanState()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: GraphTile(
              onSelect: (value) => null,
              selected: const {},
              gymSet: GymSetsCompanion(
                name: const Value("Bench press"),
                created: Value(DateTime.now()),
                reps: const Value(5),
                weight: const Value(20),
                cardio: const Value(false),
                unit: const Value('kg'),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Bench press'), findsOne);
    expect(find.text('5 x 20 kg'), findsOne);
  });
}
