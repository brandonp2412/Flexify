import 'package:flexify/database/exercise_analytics.dart';
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
          gymSet: GraphExerciseSummary(
            exerciseId: 1,
            name: 'Bench press',
            created: DateTime.now(),
            reps: 5,
            weight: 20,
            cardio: false,
            unit: 'kg',
            duration: 0,
            distance: 0,
          ),
        ),
      ),
    );

    expect(find.text('Bench press'), findsOne);
    expect(find.text('5 x 20 kg'), findsOne);
  });
}
