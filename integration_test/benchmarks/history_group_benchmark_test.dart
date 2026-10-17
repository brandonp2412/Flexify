import 'package:flexify/database/database.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'benchmark_results.dart';

void main() {
  test('repeated history grouping benchmark', () {
    final items = List.generate(
      1000,
      (i) => ExerciseSetView(
        id: i,
        name: 'Exercise ${i % 20}',
        reps: 10,
        weight: 50,
        unit: 'kg',
        cardio: false,
        duration: 0,
        distance: 0,
        bodyWeight: 0,
        restMs: 0,
        created: DateTime(2026, 10, 16).subtract(Duration(days: i ~/ 20)),
      ),
    );
    final grouped = getHistoryDayGroups(items);
    expect(grouped.length, 50);
    expect(grouped.first.exercises.length, 20);
    expect(grouped.first.exercises.first.exerciseSets.first.id, 0);
    expect(grouped.last.exercises.last.exerciseSets.last.id, 999);
    final cache = HistoryGroupingCache();
    for (var i = 0; i < 50; i++) {
      cache.get(items);
    }
    final first = cache.get(items);
    expect(identical(first, cache.get(items)), isTrue);
    final changed = List<ExerciseSetView>.of(items)..removeLast();
    expect(identical(first, cache.get(changed)), isFalse);
    cache.get(items);
    final timer = Stopwatch()..start();
    for (var i = 0; i < 1000; i++) {
      cache.get(items);
    }
    timer.stop();

    final uncached = Stopwatch()..start();
    for (var i = 0; i < 1000; i++) {
      getHistoryDayGroups(items);
    }
    uncached.stop();

    recordBenchmark('history_group_benchmark', {
      'GROUP_BENCHMARK_US': timer.elapsedMicroseconds,
      'GROUP_UNCACHED_US': uncached.elapsedMicroseconds,
    });
  });
}
