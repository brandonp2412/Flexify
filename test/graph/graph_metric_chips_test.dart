import 'package:flexify/graph/flex_line_chart.dart';
import 'package:flexify/graph/graph_metric_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('chips enable and disable overlapping metric series', (
    tester,
  ) async {
    var selected = <String>{'weight'};
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: GraphMetricChips<String>(
              options: const [('weight', 'Weight'), ('reps', 'Reps')],
              selected: selected,
              onChanged: (next) => setState(() => selected = next),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(FilterChip), findsNWidgets(2));
    await tester.tap(find.text('Reps'));
    await tester.pump();
    expect(selected, {'weight', 'reps'});
    await tester.tap(find.text('Weight'));
    await tester.pump();
    expect(selected, {'reps'});
    await tester.tap(find.text('Reps'));
    await tester.pump();
    expect(selected, {'reps'}, reason: 'a chart needs at least one metric');
  });

  test('independent scaling retains x positions and columns', () {
    final original = [
      const FlexLineChartPoint(10, 20, column: 3),
      const FlexLineChartPoint(20, 30, column: 4),
      const FlexLineChartPoint(30, 40, column: 5),
    ];
    final normalized = normalizeGraphMetricPoints(original);
    expect(normalized.map((p) => p.y), [0, 50, 100]);
    expect(normalized.map((p) => p.x), [10, 20, 30]);
    expect(normalized.map((p) => p.column), [3, 4, 5]);
    expect(original.first.y, 20);
  });

  test('constant metric remains visible instead of dividing by zero', () {
    final normalized = normalizeGraphMetricPoints([
      const FlexLineChartPoint(0, 25),
      const FlexLineChartPoint(1, 25),
    ]);
    expect(normalized.map((p) => p.y), [50, 50]);
    expect(normalizeGraphMetricPoints([]), isEmpty);
  });
}
