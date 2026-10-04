import 'dart:math';

import 'package:drafter/drafter.dart';
import 'package:flexify/graph/flex_line_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/test_app.dart';

double _contrastRatio(Color foreground, Color background) {
  final foregroundLuminance = foreground.computeLuminance();
  final backgroundLuminance = background.computeLuminance();
  final lighter = max(foregroundLuminance, backgroundLuminance);
  final darker = min(foregroundLuminance, backgroundLuminance);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  test('line graph gives edge strokes controlled breathing room', () {
    final bounds = FlexLineChart.calculateYBounds(const [
      FlexLineChartPoint(0, 10),
      FlexLineChartPoint(1, 20),
    ]);

    expect(bounds.$1, closeTo(9.8, 0.0001));
    expect(bounds.$2, closeTo(20.2, 0.0001));
  });

  test('axis labels keep readable contrast and type emphasis', () {
    for (final theme in [DrafterThemeColors.light, DrafterThemeColors.dark]) {
      final color = FlexLineChart.axisLabelColor(theme);
      expect(_contrastRatio(color, theme.surface), greaterThanOrEqualTo(9));
    }

    expect(FlexLineChart.axisLabelFontSize, 12);
    expect(FlexLineChart.axisLabelFontWeight, FontWeight.w600);
  });

  testWidgets('dark Material theme supplies dark Drafter colors to the chart', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();

    await harness.pump(
      tester,
      Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          body: SizedBox(
            width: 300,
            height: 200,
            child: FlexLineChart(
              points: const [
                FlexLineChartPoint(0, 10),
                FlexLineChartPoint(1, 20),
              ],
              showTrendLine: false,
              tooltipText: (_) => '',
            ),
          ),
        ),
      ),
    );

    final drafterTheme = tester.widget<DrafterTheme>(
      find.descendant(
        of: find.byType(FlexLineChart),
        matching: find.byType(DrafterTheme),
      ),
    );

    expect(drafterTheme.colors, DrafterThemeColors.dark);
    expect(
      _contrastRatio(
        FlexLineChart.axisLabelColor(drafterTheme.colors),
        drafterTheme.colors.surface,
      ),
      greaterThanOrEqualTo(9),
    );
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
          child: FlexLineChart(
            points: const [
              FlexLineChartPoint(0, 10),
              FlexLineChartPoint(1, 20),
            ],
            showTrendLine: false,
            hideBottom: true,
            hideLeft: true,
            tooltipText: (_) => '',
          ),
        ),
      ),
    );

    expect(find.byType(FlexLineChart), findsOneWidget);
  });

  testWidgets('touch anywhere vertically activates nearest time-based point', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final tooltipIndexes = <int>[];
    final selectedIndexes = <int>[];

    await harness.pump(
      tester,
      Scaffold(
        body: SizedBox(
          width: 300,
          height: 200,
          child: FlexLineChart(
            points: const [
              FlexLineChartPoint(1000, 10, column: 0),
              FlexLineChartPoint(4000, 20, column: 1),
              FlexLineChartPoint(10000, 15, column: 2),
            ],
            showTrendLine: false,
            hideBottom: true,
            hideLeft: true,
            timeBasedXAxis: true,
            tooltipText: (index) {
              tooltipIndexes.add(index);
              return 'Point $index';
            },
            onPointSelected: selectedIndexes.add,
          ),
        ),
      ),
    );

    final finder = find.byType(FlexLineChart);
    final topLeft = tester.getTopLeft(finder);

    final gesture = await tester.startGesture(topLeft + const Offset(103, 180));
    await tester.pump();

    expect(tooltipIndexes, contains(1));
    expect(selectedIndexes, contains(1));

    await gesture.up();
    await tester.pump();
  });

  testWidgets('tooltip stays active when selection rebuilds its parent', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final tooltipIndexes = <int>[];

    await harness.pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => Scaffold(
          body: SizedBox(
            width: 300,
            height: 200,
            child: FlexLineChart(
              points: const [
                FlexLineChartPoint(0, 10, column: 0),
                FlexLineChartPoint(1, 20, column: 1),
                FlexLineChartPoint(2, 15, column: 2),
              ],
              showTrendLine: false,
              hideBottom: true,
              hideLeft: true,
              tooltipText: (index) {
                tooltipIndexes.add(index);
                return 'Point $index';
              },
              onPointSelected: (_) => setState(() {}),
            ),
          ),
        ),
      ),
    );

    final finder = find.byType(FlexLineChart);
    final topLeft = tester.getTopLeft(finder);
    tooltipIndexes.clear();

    final gesture = await tester.startGesture(topLeft + const Offset(150, 180));
    await tester.pump();

    expect(tooltipIndexes, contains(1));

    await gesture.up();
    await tester.pump();
  });

  testWidgets('drag does not scrub until the long press activates', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final tooltipIndexes = <int>[];

    await harness.pump(
      tester,
      Scaffold(
        body: SizedBox(
          width: 300,
          height: 200,
          child: FlexLineChart(
            points: const [
              FlexLineChartPoint(0, 10, column: 0),
              FlexLineChartPoint(1, 20, column: 1),
              FlexLineChartPoint(2, 15, column: 2),
              FlexLineChartPoint(3, 25, column: 3),
            ],
            showTrendLine: false,
            hideBottom: true,
            hideLeft: true,
            tooltipText: (index) {
              tooltipIndexes.add(index);
              return 'Point $index';
            },
          ),
        ),
      ),
    );

    final finder = find.byType(FlexLineChart);
    final topLeft = tester.getTopLeft(finder);
    final gesture = await tester.startGesture(topLeft + const Offset(16, 180));
    await tester.pump();

    tooltipIndexes.clear();
    await gesture.moveTo(topLeft + const Offset(105, 180));
    await tester.pump();

    expect(tooltipIndexes, isNot(contains(1)));

    await gesture.up();
    await tester.pump();
  });

  testWidgets('long press scrub wins against horizontal page swiping', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final tooltipIndexes = <int>[];

    final pageController = PageController();
    addTearDown(pageController.dispose);

    await harness.pump(
      tester,
      Scaffold(
        body: PageView(
          controller: pageController,
          children: [
            Center(
              child: SizedBox(
                width: 300,
                height: 200,
                child: FlexLineChart(
                  points: const [
                    FlexLineChartPoint(0, 10, column: 0),
                    FlexLineChartPoint(1, 20, column: 1),
                    FlexLineChartPoint(2, 15, column: 2),
                  ],
                  showTrendLine: false,
                  hideBottom: true,
                  hideLeft: true,
                  tooltipText: (index) {
                    tooltipIndexes.add(index);
                    return 'Point $index';
                  },
                ),
              ),
            ),
            const Center(child: Text('Second page')),
          ],
        ),
      ),
    );

    final finder = find.byType(FlexLineChart);
    final topLeft = tester.getTopLeft(finder);
    final gesture = await tester.startGesture(topLeft + const Offset(284, 180));
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 10));

    tooltipIndexes.clear();
    await gesture.moveTo(topLeft + const Offset(16, 180));
    await tester.pump();

    expect(tooltipIndexes, contains(0));
    expect(pageController.page, closeTo(0, 0.001));

    await gesture.up();
    await tester.pumpAndSettle();

    expect(pageController.page, closeTo(0, 0.001));
  });

  testWidgets('long press then horizontal drag scrubs the tooltip', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final tooltipIndexes = <int>[];

    await harness.pump(
      tester,
      Scaffold(
        body: SizedBox(
          width: 300,
          height: 200,
          child: FlexLineChart(
            points: const [
              FlexLineChartPoint(0, 10, column: 0),
              FlexLineChartPoint(1, 20, column: 1),
              FlexLineChartPoint(2, 15, column: 2),
            ],
            showTrendLine: false,
            hideBottom: true,
            hideLeft: true,
            tooltipText: (index) {
              tooltipIndexes.add(index);
              return 'Point $index';
            },
          ),
        ),
      ),
    );

    final finder = find.byType(FlexLineChart);
    final topLeft = tester.getTopLeft(finder);
    final gesture = await tester.startGesture(topLeft + const Offset(16, 180));
    await tester.pump(kLongPressTimeout + const Duration(milliseconds: 10));

    tooltipIndexes.clear();
    await gesture.moveTo(topLeft + const Offset(284, 180));
    await tester.pump();

    expect(tooltipIndexes, contains(2));

    await gesture.up();
    await tester.pump();
  });

  testWidgets('grouped graph touch activates all rows at nearest column', (
    WidgetTester tester,
  ) async {
    final harness = await FlexifyTestHarness.create();
    final tooltipIndexes = <(int, int)>[];

    await harness.pump(
      tester,
      Scaffold(
        body: SizedBox(
          width: 300,
          height: 200,
          child: FlexGroupedLineChart(
            series: const [
              FlexLineChartSeries(
                points: [
                  FlexLineChartPoint(0, 10, column: 0),
                  FlexLineChartPoint(1, 20, column: 1),
                ],
                color: Colors.blue,
                name: 'A',
              ),
              FlexLineChartSeries(
                points: [
                  FlexLineChartPoint(0, 15, column: 0),
                  FlexLineChartPoint(1, 25, column: 1),
                ],
                color: Colors.green,
                name: 'B',
              ),
            ],
            xLabels: const ['First', 'Second'],
            tooltipText: (seriesIndex, xIndex) {
              tooltipIndexes.add((seriesIndex, xIndex));
              return '$seriesIndex:$xIndex';
            },
          ),
        ),
      ),
    );

    final finder = find.byType(FlexGroupedLineChart);
    final gesture = await tester.startGesture(
      tester.getTopLeft(finder) + const Offset(284, 180),
    );
    await tester.pump();

    expect(tooltipIndexes, contains((0, 1)));
    expect(tooltipIndexes, contains((1, 1)));

    await gesture.up();
    await tester.pump();
  });
}
