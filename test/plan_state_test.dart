import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_queries.dart';
import 'package:flexify/plan/workout_sessions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';
import 'support/fixtures.dart';

void main() {
  setUp(() {
    db = testDb();
  });

  test(
    'plan runtime identity comes from exercise_id, not compatibility text',
    () async {
      final planId = await db.plans.insertOne(planFixture());
      final exercise = await ensureExerciseFixture(db, 'Bench press');
      await db.planExercises.insertOne(
        planExerciseFixture(
          planId: planId,
          exercise: 'stale legacy name',
          exerciseId: exercise.id,
        ),
      );
      final workout = await resumeOrStartWorkout(db, planId);
      await db.exerciseSets.insertOne(
        ExerciseSetsCompanion.insert(
          exerciseId: exercise.id,
          workoutId: Value(workout.id),
          timestamp: testNow,
          reps: const Value(5),
          loadKg: const Value(100),
        ),
      );

      final counts = await getGymCounts(planId, workout.id);

      expect(counts, hasLength(1));
      expect(counts.single.exerciseId, exercise.id);
      expect(counts.single.name, 'Bench press');
      expect(counts.single.count, 1);
    },
  );

  test('session counts are isolated to the actual workout', () async {
    final planId = await db.plans.insertOne(planFixture());
    final exercise = await ensureExerciseFixture(db, 'Bench press');
    await db.planExercises.insertOne(
      planExerciseFixture(
        planId: planId,
        exercise: exercise.name,
        exerciseId: exercise.id,
      ),
    );
    final first = await db.workouts.insertReturning(
      WorkoutsCompanion.insert(
        planId: Value(planId),
        startedAt: testNow.subtract(const Duration(hours: 2)),
        endedAt: Value(testNow.subtract(const Duration(hours: 1))),
      ),
    );
    final active = await resumeOrStartWorkout(db, planId, now: testNow);
    await db.exerciseSets.insertAll([
      ExerciseSetsCompanion.insert(
        exerciseId: exercise.id,
        workoutId: Value(first.id),
        timestamp: first.startedAt,
        reps: const Value(5),
      ),
      ExerciseSetsCompanion.insert(
        exerciseId: exercise.id,
        workoutId: Value(active.id),
        timestamp: active.startedAt,
        reps: const Value(6),
      ),
    ]);

    final counts = await getGymCounts(planId, active.id);

    expect(counts.single.count, 1);
  });

  test(
    'loadPlanExerciseDrafts matches an existing plan row by exercise_id',
    () async {
      final planId = await db.plans.insertOne(planFixture(title: 'Push'));
      final exercise = await ensureExerciseFixture(db, 'Stable press');
      await db.planExercises.insertOne(
        planExerciseFixture(
          planId: planId,
          exercise: 'old renamed text',
          exerciseId: exercise.id,
        ),
      );

      final drafts = await loadPlanExerciseDrafts(
        PlansCompanion(id: Value(planId)),
      );

      final draft = drafts.singleWhere(
        (candidate) => candidate.exerciseId.value == exercise.id,
      );
      expect(draft.enabled.value, isTrue);
      expect(draft.exercise.value, exercise.name);
    },
  );
}
