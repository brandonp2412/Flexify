import 'package:flexify/graph/strength_data.dart';
import 'package:flutter_test/flutter_test.dart';

import 'benchmark_results.dart';

int median(List<int> values) {
  final sorted = List<int>.of(values)..sort();
  return sorted[sorted.length ~/ 2];
}

void main() {
  test('global progress tooltip lookup benchmark', () {
    final start = DateTime(2020);
    final data = List.generate(
      10000,
      (i) => StrengthData(
        created: start.add(Duration(days: i ~/ 25)),
        reps: 10,
        unit: 'kg',
        value: i.toDouble(),
        category: 'Category ${i % 25}',
      ),
    );
    final queries = List.generate(5000, (i) => (i * 7919) % data.length);
    final indexed = indexStrengthDataByCategoryAndDate(data);

    StrengthData legacyLookup(int dataIndex) {
      final target = data[dataIndex];
      return data.firstWhere(
        (row) =>
            row.category == target.category && row.created == target.created,
      );
    }

    StrengthData indexedLookup(int dataIndex) {
      final target = data[dataIndex];
      return indexed[(category: target.category, created: target.created)]!;
    }

    for (var i = 0; i < 3; i++) {
      for (final query in queries) {
        legacyLookup(query);
        indexedLookup(query);
      }
    }

    final samples = <int>[];
    for (var sample = 0; sample < 7; sample++) {
      final timer = Stopwatch()..start();
      var checksum = 0.0;
      for (final query in queries) {
        checksum += legacyLookup(query).value;
      }
      timer.stop();
      expect(checksum, greaterThan(0));
      samples.add(timer.elapsedMicroseconds);
    }

    final indexedSamples = <int>[];
    for (var sample = 0; sample < 7; sample++) {
      final timer = Stopwatch()..start();
      var checksum = 0.0;
      for (final query in queries) {
        checksum += indexedLookup(query).value;
      }
      timer.stop();
      expect(checksum, greaterThan(0));
      indexedSamples.add(timer.elapsedMicroseconds);
    }

    for (final query in queries.take(100)) {
      expect(indexedLookup(query), same(legacyLookup(query)));
    }

    recordBenchmark('global_progress_tooltip_benchmark', {
      'GLOBAL_TOOLTIP_LEGACY_US': samples,
      'GLOBAL_TOOLTIP_LEGACY_MEDIAN_US': median(samples),
      'GLOBAL_TOOLTIP_INDEXED_US': indexedSamples,
      'GLOBAL_TOOLTIP_INDEXED_MEDIAN_US': median(indexedSamples),
    });
  });
}
