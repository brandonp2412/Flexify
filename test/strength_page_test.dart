import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/strength_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tab_controller.dart';
import 'support/graph_fixtures.dart';
import 'support/test_app.dart';

Future<void> pumpStrengthPage(
  WidgetTester tester,
  FlexifyTestHarness harness,
) async {
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
        name: screenshotExercise,
        unit: 'kg',
        data: await getStrengthData(
          target: 'kg',
          name: screenshotExercise,
          metric: StrengthMetric.bestWeight,
          period: Period.day,
          start: null,
          end: null,
          limit: 11,
        ),
      ),
    ),
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
    expect(find.byType(LineChart), findsOne);
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
      expect(find.byType(LineChart), findsOne);
      currentMetric = metric;
    }
  });
}
