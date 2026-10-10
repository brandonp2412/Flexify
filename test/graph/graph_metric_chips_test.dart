import 'package:flexify/graph/flex_line_chart.dart';
import 'package:flexify/graph/graph_metric_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('metric chips select exactly one series', (tester) async {
    var selected = 'weight';
    var changes = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: GraphMetricChips<String>(
              options: const [('weight', 'Weight'), ('reps', 'Reps')],
              selected: selected,
              onChanged: (next) => setState(() {
                selected = next;
                changes++;
              }),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(ChoiceChip), findsNWidgets(2));
    final weightChip = tester.widget<ChoiceChip>(
      find.byKey(const Key('graph-metric-weight')),
    );
    final repsChip = tester.widget<ChoiceChip>(
      find.byKey(const Key('graph-metric-reps')),
    );
    expect(weightChip.selected, isTrue);
    expect(repsChip.selected, isFalse);
    expect(weightChip.side!.color, isNot(repsChip.side!.color));

    await tester.tap(find.text('Reps'));
    await tester.pump();
    expect(selected, 'reps');
    expect(changes, 1);
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const Key('graph-metric-reps')))
          .selected,
      isTrue,
    );
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const Key('graph-metric-weight')))
          .selected,
      isFalse,
    );

    await tester.tap(find.text('Reps'));
    await tester.pump();
    expect(selected, 'reps');
    expect(changes, 1, reason: 'reselecting the same metric does nothing');
    await tester.tap(find.text('Weight'));
    await tester.pump();
    expect(selected, 'weight');
    expect(changes, 2);
  });

  testWidgets('chips remain centered after wrapping onto multiple rows', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              key: const Key('metric-chips-test-container'),
              width: 260,
              child: GraphMetricChips<String>(
                options: const [
                  ('weight', 'Weight'),
                  ('reps', 'Repetitions'),
                  ('volume', 'Volume'),
                ],
                selected: 'weight',
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      ),
    );
    final wrap = tester.widget<Wrap>(find.byType(Wrap));
    expect(wrap.alignment, WrapAlignment.center);
    final first = tester.getRect(find.byKey(const Key('graph-metric-weight')));
    final last = tester.getRect(find.byKey(const Key('graph-metric-volume')));
    expect(last.top, greaterThan(first.top));
    final container = tester.getRect(
      find.byKey(const Key('metric-chips-test-container')),
    );
    expect(last.center.dx, closeTo(container.center.dx, 8));
  });

  test('single metric uses actual Y-axis values instead of percentages', () {
    final bounds = FlexLineChart.calculateYBounds([
      const FlexLineChartPoint(0, 40),
      const FlexLineChartPoint(1, 60),
    ]);
    expect(bounds.$1, closeTo(39.6, 0.001));
    expect(bounds.$2, closeTo(60.4, 0.001));
  });
}
