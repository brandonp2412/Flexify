import 'package:flex/database/exercise_analytics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'benchmark_results.dart';

int median(List<int> values) {
  final sorted = List<int>.of(values)..sort();
  return sorted[sorted.length ~/ 2];
}

void main() {
  test('graph selection membership benchmark', () {
    final summaries = List.generate(
      4000,
      (i) => GraphExerciseSummary(
        exerciseId: i,
        bodyWeight: false,
        name: 'Exercise $i',
        unit: 'kg',
        cardio: false,
        weight: i.toDouble(),
        reps: 10,
        duration: 0,
        distance: 0,
        created: DateTime(2026),
      ),
    );
    final selectedList = [
      for (var i = 0; i < summaries.length; i += 2) summaries[i].selectionKey,
    ];
    final selectedSet = selectedList.toSet();

    List<GraphExerciseSummary> legacy() => [
      for (final summary in summaries)
        if (selectedList.contains(summary.selectionKey)) summary,
    ];
    List<GraphExerciseSummary> proposed() =>
        filterGraphSummariesBySelection(summaries, selectedSet);

    for (var i = 0; i < 3; i++) {
      expect(legacy().length, proposed().length);
    }

    List<int> measure(List<GraphExerciseSummary> Function() fn) {
      return [
        for (var sample = 0; sample < 9; sample++)
          (() {
            final timer = Stopwatch()..start();
            var checksum = 0;
            for (var repeat = 0; repeat < 4; repeat++) {
              checksum += fn().length;
            }
            timer.stop();
            expect(checksum, 8000);
            return timer.elapsedMicroseconds;
          })(),
      ];
    }

    final legacySamples = measure(legacy);
    final setSamples = measure(proposed);

    recordBenchmark('graph_selection_benchmark', {
      'GRAPH_SELECTION_LIST_US': legacySamples,
      'GRAPH_SELECTION_LIST_MEDIAN_US': median(legacySamples),
      'GRAPH_SELECTION_SET_US': setSamples,
      'GRAPH_SELECTION_SET_MEDIAN_US': median(setSamples),
    });
  });
}
