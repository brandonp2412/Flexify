import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/graph/strength_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tab_controller.dart';
import 'support/graph_fixtures.dart';
import 'support/test_app.dart';

Future<void> pumpStrengthPage(
  WidgetTester tester,
  FlexifyTestHarness harness, {
  Size? surfaceSize,
  bool bodyWeight = false,
}) async {
  await harness.database.planExercises.deleteAll();
  await harness.database.plans.deleteAll();
  await seedGraphFixtures(harness.database);
  await harness.database.plans.insertAll(screenshotPlans);

  await harness.pump(
    tester,
    DefaultTabController(
      length: 1,
      child: StrengthPage(
        tabCtrl: MockTabController(),
        initialExercise: (name: screenshotExercise, category: 'Arms'),
        initialUnit: 'kg',
        initialData: await getStrengthData(
          target: 'kg',
          exercise: (name: screenshotExercise, category: 'Arms'),
          metric: StrengthMetric.bestWeight,
          period: Period.day,
          start: null,
          end: null,
          limit: 11,
        ),
        bodyWeight: bodyWeight,
      ),
    ),
    surfaceSize: surfaceSize,
  );

  await tester.pumpAndSettle();
}

void main() {
  testWidgets('StrengthPage displays', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpStrengthPage(tester, harness);

    expect(find.text(screenshotExercise), findsOne);
    expect(find.text('Best weight'), findsOne);
    expect(find.byTooltip('Edit'), findsOne);
  });

  testWidgets('StrengthPage exposes options inline on desktop', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(900, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await pumpStrengthPage(tester, harness, surfaceSize: const Size(900, 800));

    expect(find.byTooltip('Options'), findsNothing);
    expect(find.text('Start date'), findsOne);
    expect(find.text('Stop date'), findsOne);
    expect(find.text('Data points'), findsOne);
    expect(find.text('Curve lines'), findsOne);
    expect(tester.takeException(), null);
  });

  testWidgets('Weight graph uses a full-width options button', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    await pumpStrengthPage(tester, harness, bodyWeight: true);

    final optionsButton = find.byKey(const Key('body-weight-options-button'));
    expect(optionsButton, findsOneWidget);
    expect(
      find.descendant(of: optionsButton, matching: find.text('Options')),
      findsOneWidget,
    );
    expect(find.text('Best weight'), findsNothing);

    await tester.tap(optionsButton);
    await tester.pumpAndSettle();

    expect(find.text('Start date'), findsOneWidget);
    expect(find.text('Stop date'), findsOneWidget);
  });

  testWidgets('StrengthPage edits', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpStrengthPage(tester, harness);

    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();

    expect(find.text('Update all dumbbell shoulder press'), findsOne);
  });

  testWidgets('StrengthPage selects metrics', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpStrengthPage(tester, harness);

    var currentMetric = 'Best weight';
    for (final metric in ['Best reps', 'One rep max', 'Volume']) {
      await tester.tap(find.text(currentMetric));
      await tester.pumpAndSettle();
      await tester.tap(find.text(metric));
      await tester.pumpAndSettle();
      expect(find.text(metric), findsOne);
      currentMetric = metric;
    }
  });
}
