import 'package:flexify/database/database.dart';
import 'package:flexify/plan/plan_queries.dart';
import 'package:flutter_test/flutter_test.dart';

import 'benchmark_results.dart';

List<PlanExerciseDraft> legacyFilter(
  List<PlanExerciseDraft> exercises,
  String search,
) {
  final match = exercises.where(
    (pe) => pe.exerciseName.toLowerCase().contains(search.toLowerCase()),
  );
  if (match.isEmpty) return const [];
  return match.toList();
}

List<int> measure(
  List<PlanExerciseDraft> exercises,
  List<PlanExerciseDraft> Function(List<PlanExerciseDraft>, String) filter,
) {
  for (var i = 0; i < 20; i++) {
    filter(exercises, 'bench press variation 7');
  }
  final samples = <int>[];
  for (var sample = 0; sample < 7; sample++) {
    final timer = Stopwatch()..start();
    for (var i = 0; i < 100; i++) {
      filter(exercises, 'bench press variation 7');
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
  test('edit plan search benchmark', () {
    final exercises = List.generate(
      20000,
      (i) => PlanExerciseDraft(
        planExercise: const PlanExercisesCompanion(),
        exerciseName: 'Exercise $i Bench Press Variation ${i % 31}',
      ),
    );

    for (final search in ['', 'bench', 'bench press variation 7', 'missing']) {
      expect(
        filterPlanExerciseDrafts(exercises, search),
        legacyFilter(exercises, search),
      );
    }

    final legacySamples = measure(exercises, legacyFilter);
    final optimizedSamples = measure(
      exercises,
      (items, search) => filterPlanExerciseDrafts(items, search),
    );

    recordBenchmark('edit_plan_search_benchmark', {
      'EDIT_PLAN_SEARCH_LEGACY_US': legacySamples,
      'EDIT_PLAN_SEARCH_LEGACY_MEDIAN_US': median(legacySamples),
      'EDIT_PLAN_SEARCH_OPTIMIZED_US': optimizedSamples,
      'EDIT_PLAN_SEARCH_OPTIMIZED_MEDIAN_US': median(optimizedSamples),
    });
  });
}
