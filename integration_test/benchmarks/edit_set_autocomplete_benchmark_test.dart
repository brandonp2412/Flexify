import 'package:flexify/sets/edit_set_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'benchmark_results.dart';

Iterable<String> legacyFilter(Iterable<String> options, String search) {
  final terms = search
      .toLowerCase()
      .split(' ')
      .where((term) => term.isNotEmpty);
  var filtered = options;
  for (final term in terms) {
    filtered = filtered.where((option) => option.toLowerCase().contains(term));
  }
  return filtered;
}

int median(List<int> values) {
  final sorted = List<int>.of(values)..sort();
  return sorted[sorted.length ~/ 2];
}

void main() {
  test('exercise autocomplete filtering benchmark and equivalence', () {
    final options = List.generate(
      5000,
      (i) => 'Exercise $i Bench Press Variation ${i % 37} Accessory ${i % 11}',
    );
    const searches = [
      'bench press variation',
      'EXERCISE 42',
      ' accessory   7 ',
      '',
    ];
    for (final search in searches) {
      expect(
        filterExerciseNameOptions(options, search).toList(),
        legacyFilter(options, search).toList(),
      );
    }

    for (var i = 0; i < 20; i++) {
      legacyFilter(options, 'bench press variation').length;
      filterExerciseNameOptions(options, 'bench press variation').length;
    }

    List<int> measure(Iterable<String> Function() filter) => [
      for (var sample = 0; sample < 9; sample++)
        (() {
          final timer = Stopwatch()..start();
          var checksum = 0;
          for (var i = 0; i < 300; i++) {
            checksum += filter().length;
          }
          timer.stop();
          expect(checksum, 1500000);
          return timer.elapsedMicroseconds;
        })(),
    ];

    final legacySamples = measure(
      () => legacyFilter(options, 'bench press variation'),
    );
    final optimizedSamples = measure(
      () => filterExerciseNameOptions(options, 'bench press variation'),
    );

    recordBenchmark('edit_set_autocomplete_benchmark', {
      'EDIT_SET_AUTOCOMPLETE_LEGACY_US': legacySamples,
      'EDIT_SET_AUTOCOMPLETE_LEGACY_MEDIAN_US': median(legacySamples),
      'EDIT_SET_AUTOCOMPLETE_OPTIMIZED_US': optimizedSamples,
      'EDIT_SET_AUTOCOMPLETE_OPTIMIZED_MEDIAN_US': median(optimizedSamples),
    });
  });
}
