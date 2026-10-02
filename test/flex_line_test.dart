import 'package:drafter/drafter.dart';
import 'package:flexify/graph/flex_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

void main() {
  test('line graph gives edge strokes controlled breathing room', () {
    final bounds = FlexLine.calculateYBounds(const [
      FlexChartPoint(0, 10),
      FlexChartPoint(1, 20),
    ]);

    expect(bounds.$1, closeTo(9.8, 0.0001));
    expect(bounds.$2, closeTo(20.2, 0.0001));
  });

  testWidgets('line graph renders through Drafter', (
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
            points: const [FlexChartPoint(0, 10), FlexChartPoint(1, 20)],
            data: const [],
            showTrendLine: false,
            hideBottom: true,
            hideLeft: true,
            tooltipText: (_) => '',
          ),
        ),
      ),
    );

    expect(find.byType(InteractiveChart), findsOneWidget);
  });
}
