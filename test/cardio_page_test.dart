import 'package:drift/drift.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/cardio_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tab_controller.dart';
import 'support/graph_fixtures.dart';
import 'support/test_app.dart';

Future<void> pumpCardioPage(
  WidgetTester tester,
  FlexifyTestHarness harness,
) async {
  for (final element in graphData) {
    await harness.database
        .into(harness.database.gymSets)
        .insert(
          graphGymSet(
            'Run',
            element.weight,
            reps: element.reps,
            date: element.dateTime,
          ).copyWith(cardio: const Value(true)),
        );
  }

  await harness.pump(
    tester,
    DefaultTabController(
      length: 1,
      child: CardioPage(
        tabCtrl: MockTabController(),
        name: 'Run',
        unit: 'km',
        data: await getCardioData(
          target: 'km',
          name: 'Run',
          metric: CardioMetric.pace,
          period: Period.day,
          start: null,
          end: null,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('CardioPage displays', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpCardioPage(tester, harness);

    expect(find.text('Run'), findsOne);
    expect(find.text('Pace (distance / time)'), findsOne);
    expect(find.byTooltip('Edit'), findsOne);
    expect(find.byType(LineChart), findsOne);

    await tester.tap(find.byTooltip('Options'));
    await tester.pumpAndSettle();
    expect(find.text('Start date'), findsOne);
    expect(find.text('Stop date'), findsOne);
  });

  testWidgets('CardioPage edits', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpCardioPage(tester, harness);

    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();
    expect(find.text('Update all run'), findsOne);
  });

  testWidgets('CardioPage selects metrics', (WidgetTester tester) async {
    final harness = await FlexifyTestHarness.create();
    await pumpCardioPage(tester, harness);

    var currentMetric = 'Pace (distance / time)';
    for (final metric in ['Duration', 'Distance']) {
      await tester.tap(find.text(currentMetric));
      await tester.pumpAndSettle();
      await tester.tap(find.text(metric));
      await tester.pumpAndSettle();
      expect(find.byType(LineChart), findsOne);
      currentMetric = metric;
    }
  });
}
