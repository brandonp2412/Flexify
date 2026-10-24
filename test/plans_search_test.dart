import 'package:flex/database/database.dart';
import 'package:flex/plan/plan_queries.dart';
import 'package:flex/plan/workout_sessions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('plans search matches titles, days, and exercise names', () {
    const dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final plans = List.generate(
      3,
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

    for (final (search, expectedIds) in [
      ('', [0, 1, 2]),
      ('STRENGTH PLAN 1', [1]),
      ('monday', [0]),
      ('localized monday', [0]),
      ('BENCH PRESS VARIATION 2', [2]),
      ('missing', <int>[]),
    ]) {
      expect(
        filterPlans(plans, entries, search, localizeDay).map((plan) => plan.id),
        expectedIds,
      );
    }
  });
  test('plan search treats percent and underscore literally', () {
    const special = Plan(
      id: 1,
      title: '100%_strength',
      days: 'Monday',
      sequence: 0,
    );
    const plain = Plan(id: 2, title: 'Strength', days: 'Monday', sequence: 1);
    final plans = [special, plain];
    String localizeDay(String day) => day;

    expect(filterPlans(plans, [], '%', localizeDay), [special]);
    expect(filterPlans(plans, [], '_', localizeDay), [special]);
    expect(filterPlans(plans, [], '100%_', localizeDay), [special]);
  });
}
