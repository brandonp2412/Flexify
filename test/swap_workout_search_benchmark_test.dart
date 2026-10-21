import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

List<Exercise> legacyFilter(
  List<Exercise> exercises,
  Set<int> unavailableExerciseIds,
  String search,
) => exercises
    .where(
      (exercise) =>
          !unavailableExerciseIds.contains(exercise.id) &&
          exercise.name.toLowerCase().contains(search.toLowerCase()),
    )
    .toList();

List<int> measure(
  List<Exercise> exercises,
  Set<int> unavailableExerciseIds,
  List<Exercise> Function(List<Exercise>, Set<int>, String) filter,
) {
  for (var i = 0; i < 20; i++) {
    filter(exercises, unavailableExerciseIds, 'bench press variation 7');
  }
  final samples = <int>[];
  for (var sample = 0; sample < 7; sample++) {
    final timer = Stopwatch()..start();
    for (var i = 0; i < 100; i++) {
      filter(exercises, unavailableExerciseIds, 'bench press variation 7');
    }
    timer.stop();
    samples.add(timer.elapsedMicroseconds);
  }
  return samples;
}

int median(List<int> values) {
  final sorted = List<int>.of(values)..sort();
  return sorted[sorted.length ~/ 2];
}

void main() {
  test('swap workout search baseline benchmark', () {
    final exercises = List.generate(
      10000,
      (i) => Exercise(
        id: i,
        name: 'Exercise $i Bench Press Variation ${i % 31}',
        kind: 'strength',
        displayUnit: 'kg',
        graphMetric: 'weight',
        graphPeriod: 'all',
        graphLimit: 100,
        graphTimeBasedXAxis: true,
        archived: false,
      ),
    );
    final unavailable = {for (var i = 0; i < 10000; i += 5) i};

    for (final search in ['', 'bench', 'bench press variation 7', 'missing']) {
      expect(
        filterExerciseCatalog(exercises, unavailable, search),
        legacyFilter(exercises, unavailable, search),
      );
    }

    final legacySamples = measure(exercises, unavailable, legacyFilter);
    final optimizedSamples = measure(
      exercises,
      unavailable,
      (items, blocked, search) => filterExerciseCatalog(items, blocked, search),
    );
    print('SWAP_SEARCH_LEGACY_US=$legacySamples');
    print('SWAP_SEARCH_LEGACY_MEDIAN_US=${median(legacySamples)}');
    print('SWAP_SEARCH_OPTIMIZED_US=$optimizedSamples');
    print('SWAP_SEARCH_OPTIMIZED_MEDIAN_US=${median(optimizedSamples)}');
  });
}
