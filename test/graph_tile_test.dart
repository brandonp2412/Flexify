import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/graph_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tab_controller.dart';
import 'support/test_app.dart';

void main() {
  testWidgets('GraphTile', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(
      tester,
      Scaffold(
        resizeToAvoidBottomInset: false,
        body: GraphTile(
          tabCtrl: MockTabController(),
          onSelect: (value) => null,
          selected: const {},
          gymSet: GymSetsCompanion(
            name: const Value('Bench press'),
            created: Value(DateTime.now()),
            reps: const Value(5),
            weight: const Value(20),
            cardio: const Value(false),
            unit: const Value('kg'),
          ),
        ),
      ),
    );

    expect(find.text('Bench press'), findsOne);
    expect(find.text('5 x 20 kg'), findsOne);
  });
}
