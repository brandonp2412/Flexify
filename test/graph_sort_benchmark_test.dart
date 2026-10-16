import 'package:flexify/constants.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/graph/graphs_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('graph summary sort benchmark', () {
    final source = List.generate(
      5000,
      (i) => GraphExerciseSummary(
        exerciseId: i,
        bodyWeight: false,
        name: [
          i.isEven ? 'Bench' : 'bENCH',
          'Exercise',
          ((i * 7919) % 5000).toString().padLeft(4, '0'),
          'Variation',
          ((i * 17) % 97).toString(),
        ].join(' '),
        unit: 'kg',
        cardio: false,
        weight: 50,
        reps: 10,
        duration: 0,
        distance: 0,
        created: DateTime(2026, 1, 1).subtract(Duration(minutes: i)),
      ),
    );
    for (var i = 0; i < 5; i++) {
      applyGraphSortToNewestFirstSummaries(List.of(source), GraphSort.dateDesc);
    }
    final descTimer = Stopwatch()..start();
    for (var i = 0; i < 30; i++) {
      applyGraphSortToNewestFirstSummaries(List.of(source), GraphSort.dateDesc);
    }
    descTimer.stop();
    for (var i = 0; i < 5; i++) {
      applyGraphSortToNewestFirstSummaries(List.of(source), GraphSort.name);
    }
    final nameTimer = Stopwatch()..start();
    for (var i = 0; i < 30; i++) {
      applyGraphSortToNewestFirstSummaries(List.of(source), GraphSort.name);
    }
    nameTimer.stop();
    final descending = List.of(source);
    applyGraphSortToNewestFirstSummaries(descending, GraphSort.dateDesc);
    expect(
      descending.map((summary) => summary.exerciseId),
      source.map((summary) => summary.exerciseId),
    );

    final byName = List.of(source)..shuffle();
    applyGraphSortToNewestFirstSummaries(byName, GraphSort.name);
    for (var i = 1; i < byName.length; i++) {
      expect(
        byName[i - 1].name.toLowerCase().compareTo(
          byName[i].name.toLowerCase(),
        ),
        lessThanOrEqualTo(0),
      );
    }

    print(['GRAPH_DESC_US', descTimer.elapsedMicroseconds].join('='));
    print(['GRAPH_NAME_US', nameTimer.elapsedMicroseconds].join('='));
  });
}
