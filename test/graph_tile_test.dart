import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/graph/graph_tile.dart';
import 'package:flutter/gestures.dart';
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
          exerciseSet: GraphExerciseSummary(
            exerciseId: 1,
            bodyWeight: false,
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

  testWidgets('GraphTile formats body weight value', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await harness.pump(
      tester,
      Scaffold(
        body: GraphTile(
          tabCtrl: MockTabController(),
          onSelect: (value) => null,
          selected: const {},
          exerciseSet: GraphExerciseSummary(
            exerciseId: null,
            bodyWeight: true,
            name: 'Weight',
            created: DateTime.now(),
            reps: 1,
            weight: 82.5,
            cardio: false,
            unit: 'kg',
            duration: 0,
            distance: 0,
          ),
        ),
      ),
    );

    expect(find.text('Weight'), findsOneWidget);
    expect(find.text('82.5 kg'), findsOneWidget);
    expect(find.textContaining('formatDisplayNumber'), findsNothing);
  });

  testWidgets('GraphTile exposes desktop actions on secondary click', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    var edited = false;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await harness.pump(
      tester,
      Scaffold(
        body: GraphTile(
          tabCtrl: MockTabController(),
          onSelect: (value) => null,
          onEdit: () => edited = true,
          onDelete: () async {},
          selected: const {},
          exerciseSet: GraphExerciseSummary(
            exerciseId: 1,
            bodyWeight: false,
            name: 'Desktop bench press',
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
      surfaceSize: const Size(1200, 800),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Desktop bench press')),
      kind: PointerDeviceKind.mouse,
      buttons: kSecondaryMouseButton,
    );
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(edited, isTrue);
  });
}
