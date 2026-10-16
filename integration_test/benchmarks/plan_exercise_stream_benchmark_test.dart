import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/plan/workout_sessions.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test/mock_tests.dart';

int median(List<int> values) {
  final sorted = List<int>.of(values)..sort();
  return sorted[sorted.length ~/ 2];
}

void main() {
  test('plan exercise stream query benchmark', () async {
    final database = testDb();
    addTearDown(database.close);

    final exerciseIds = <int>[];
    for (var i = 0; i < 8; i++) {
      exerciseIds.add(
        await database.exercises.insertOne(
          ExercisesCompanion.insert(
            name: 'Exercise $i',
            kind: 'strength',
            displayUnit: 'kg',
          ),
        ),
      );
    }

    final planIds = <int>[];
    for (var plan = 0; plan < 40; plan++) {
      final planId = await database.plans.insertOne(
        PlansCompanion.insert(days: 'Monday'),
      );
      planIds.add(planId);
      await database.batch((batch) {
        for (var exercise = 0; exercise < exerciseIds.length; exercise++) {
          batch.insert(
            database.planExercises,
            PlanExercisesCompanion.insert(
              planId: planId,
              exerciseId: exerciseIds[exercise],
              enabled: true,
              sequence: Value(exercise),
            ),
          );
        }
      });
    }

    final planIdSet = planIds.toSet();

    Future<int> legacy() async {
      final rows = await Future.wait(
        planIds.map(
          (planId) => watchPlanExerciseEntries(database, planId).first,
        ),
      );
      return rows.fold<int>(0, (sum, entries) => sum + entries.length);
    }

    Future<int> shared() async {
      final rows = await watchAllPlanExerciseEntries(database).first;
      final grouped = groupEnabledPlanExercisesByPlan(rows);
      return planIdSet.fold<int>(
        0,
        (sum, planId) => sum + (grouped[planId]?.length ?? 0),
      );
    }

    for (var i = 0; i < 2; i++) {
      expect(await legacy(), 320);
      expect(await shared(), 320);
    }

    Future<List<int>> measure(Future<int> Function() fn) async {
      final samples = <int>[];
      for (var sample = 0; sample < 7; sample++) {
        final timer = Stopwatch()..start();
        expect(await fn(), 320);
        timer.stop();
        samples.add(timer.elapsedMicroseconds);
      }
      return samples;
    }

    final legacySamples = await measure(legacy);
    final sharedSamples = await measure(shared);

    print('PLAN_STREAM_PER_TILE_US=$legacySamples');
    print('PLAN_STREAM_PER_TILE_MEDIAN_US=${median(legacySamples)}');
    print('PLAN_STREAM_SHARED_US=$sharedSamples');
    print('PLAN_STREAM_SHARED_MEDIAN_US=${median(sharedSamples)}');
  });
}
