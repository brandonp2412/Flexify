import 'package:flexify/database/database.dart';
import 'package:flexify/plan/plan_queries.dart';
import 'package:flexify/plan/workout_sessions.dart';
import 'package:flutter_test/flutter_test.dart';

List<Plan> legacyFilter(
  List<Plan> plans,
  List<PlanExerciseEntry> exercises,
  String search,
  String Function(String) localizeDay,
) {
  if (search.isEmpty) return plans;

  final normalizedSearch = search.toLowerCase();
  final matchingPlanIds = exercises
      .where(
        (entry) => entry.exercise.name.toLowerCase().contains(normalizedSearch),
      )
      .map((entry) => entry.planExercise.planId)
      .toSet();

  return plans.where((plan) {
    final localizedDays = plan.days
        .split(',')
        .where((day) => day.isNotEmpty)
        .map(localizeDay)
        .join(' ')
        .toLowerCase();
    return plan.title?.toLowerCase().contains(normalizedSearch) == true ||
        plan.days.toLowerCase().contains(normalizedSearch) ||
        localizedDays.contains(normalizedSearch) ||
        matchingPlanIds.contains(plan.id);
  }).toList();
}

int median(List<int> values) {
  final sorted = List<int>.of(values)..sort();
  return sorted[sorted.length ~/ 2];
}

void main() {
  test('plans search baseline benchmark', () {
    const dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final plans = List.generate(
      2000,
      (i) => Plan(
        id: i,
        sequence: i,
        title: 'Strength Plan $i',
        days:
            '${dayNames[i % dayNames.length]},${dayNames[(i + 2) % dayNames.length]}',
      ),
    );
    final entries = <PlanExerciseEntry>[];
    var id = 0;
    for (final plan in plans) {
      for (var exercise = 0; exercise < 10; exercise++) {
        final exerciseId = exercise;
        entries.add(
          PlanExerciseEntry(
            planExercise: PlanExercise(
              enabled: true,
              timers: true,
              exerciseId: exerciseId,
              id: id++,
              planId: plan.id,
              sequence: exercise,
            ),
            exercise: Exercise(
              id: exerciseId,
              name: 'Exercise $exercise Bench Press Variation ${plan.id % 31}',
              kind: 'strength',
              displayUnit: 'kg',
              graphMetric: 'BestWeight',
              graphPeriod: 'All',
              graphLimit: 0,
              graphTimeBasedXAxis: true,
              archived: false,
            ),
          ),
        );
      }
    }

    String localizeDay(String day) => 'Localized $day';

    final index = PlanSearchIndex(
      plans: plans,
      exercises: entries,
      localizeDay: localizeDay,
    );

    for (final search in [
      '',
      'strength plan 123',
      'monday',
      'localized monday',
      'bench press variation 7',
      'missing',
    ]) {
      expect(
        index.filter(search).map((plan) => plan.id),
        legacyFilter(
          plans,
          entries,
          search,
          localizeDay,
        ).map((plan) => plan.id),
      );
    }

    for (var i = 0; i < 10; i++) {
      legacyFilter(plans, entries, 'bench press variation 7', localizeDay);
      index.filter('bench press variation 7');
    }

    List<int> measure(List<Plan> Function() filter) {
      final samples = <int>[];
      for (var sample = 0; sample < 7; sample++) {
        final timer = Stopwatch()..start();
        for (var i = 0; i < 50; i++) {
          expect(filter(), isNotEmpty);
        }
        timer.stop();
        samples.add(timer.elapsedMicroseconds);
      }
      return samples;
    }

    final baselineSamples = measure(
      () =>
          legacyFilter(plans, entries, 'bench press variation 7', localizeDay),
    );
    final optimizedSamples = measure(
      () => index.filter('bench press variation 7'),
    );

    print('PLANS_SEARCH_BASELINE_US=$baselineSamples');
    print('PLANS_SEARCH_BASELINE_MEDIAN_US=${median(baselineSamples)}');
    print('PLANS_SEARCH_OPTIMIZED_US=$optimizedSamples');
    print('PLANS_SEARCH_OPTIMIZED_MEDIAN_US=${median(optimizedSamples)}');
  });
}
