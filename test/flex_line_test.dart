import 'package:fl_chart/fl_chart.dart';
import 'package:flexify/graph/flex_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  testWidgets('line graph gives edge strokes controlled breathing room', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();

    await harness.pump(
      tester,
      Scaffold(
        body: SizedBox(
          width: 300,
          height: 200,
          child: FlexLine(
            spots: const [FlSpot(0, 10), FlSpot(1, 20)],
            data: const [],
            showTrendLine: false,
            hideBottom: true,
            hideLeft: true,
            tooltipData: () => LineTouchTooltipData(),
          ),
        ),
      ),
    );

    final chart = tester.widget<LineChart>(find.byType(LineChart));
    final chartData = chart.data;

    expect(chartData.clipData.top, isTrue);
    expect(chartData.clipData.bottom, isTrue);
    expect(chartData.clipData.left, isFalse);
    expect(chartData.clipData.right, isFalse);
    expect(chartData.minY, closeTo(9.8, 0.0001));
    expect(chartData.maxY, closeTo(20.2, 0.0001));
  });
}
