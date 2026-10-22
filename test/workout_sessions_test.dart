import 'dart:async';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/workout_sessions.dart';
import 'package:flexify/plan/start_plan_data.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';
import '../integration_test/support/fixtures.dart';

Future<ExerciseSetView> addMirroredSet({
  required int exerciseId,
  required String exerciseName,
  required int? planId,
  required int? workoutId,
  required DateTime created,
  required double weight,
}) {
  return insertExerciseSet(
    db,
    exerciseSet: exerciseSetFixture(
      exerciseName,
      planId: planId,
      created: created,
      weight: weight,
    ),
    exerciseId: exerciseId,
    workoutId: workoutId,
  );
}

void main() {
  setUp(() {
    db = testDb();
  });

  test('start page distinguishes an empty plan from a deleted plan', () async {
    final planId = await db.plans.insertOne(planFixture());
    final page = await watchStartPlanData(db, planId).first;
    expect(page.plan?.id, planId);
    expect(page.exercises, isEmpty);
    final stream = StreamIterator(watchStartPlanData(db, planId));
    await stream.moveNext();
    await (db.plans.delete()..where((plan) => plan.id.equals(planId))).go();
    await stream.moveNext();
    expect(stream.current.plan, isNull);
    expect(stream.current.exercises, isEmpty);
    await stream.cancel();
  });

  test('workout resumes until finished, then starts a new session', () async {
    final planId = await db.plans.insertOne(planFixture());
    final started = DateTime(2026, 1, 1, 10);
    final first = await resumeOrStartWorkout(db, planId, now: started);
    final resumed = await resumeOrStartWorkout(
      db,
      planId,
      now: started.add(const Duration(hours: 1)),
    );

    expect(resumed.id, first.id);
    expect(resumed.startedAt, first.startedAt);

    final ended = started.add(const Duration(hours: 2));
    await finishWorkout(db, first.id, now: ended);
    final finished =
        await (db.workouts.select()..where((row) => row.id.equals(first.id)))
            .getSingle();
    expect(finished.endedAt, ended);

    final next = await resumeOrStartWorkout(
      db,
      planId,
      now: started.add(const Duration(hours: 3)),
    );
    expect(next.id, isNot(first.id));
  });

  test('stale paused workouts do not leak into a later training day', () async {
    final planId = await db.plans.insertOne(planFixture());
    final startedAt = DateTime(2026, 1, 1, 10);
    final paused = await resumeOrStartWorkout(db, planId, now: startedAt);
    final nextTime = startedAt.add(const Duration(hours: 19));
    final next = await resumeOrStartWorkout(db, planId, now: nextTime);

    expect(next.id, isNot(paused.id));
    final old =
        await (db.workouts.select()
              ..where((workout) => workout.id.equals(paused.id)))
            .getSingle();
    expect(old.endedAt, nextTime);
    expect(next.endedAt, isNull);
  });

  test('concurrent starts keep one active workout per plan', () async {
    final planId = await db.plans.insertOne(planFixture());

    final started = await Future.wait([
      for (var i = 0; i < 12; i++)
        resumeOrStartWorkout(db, planId, now: DateTime(2026, 1, 1, 10, i)),
    ]);

    expect(started.map((workout) => workout.id).toSet(), hasLength(1));
    final active =
        await (db.workouts.select()..where(
              (workout) =>
                  workout.planId.equals(planId) & workout.endedAt.isNull(),
            ))
            .get();
    expect(active, hasLength(1));
  });

  test('last-session prefill uses the actual workout and same plan', () async {
    final planA = await db.plans.insertOne(planFixture(title: 'A'));
    final planB = await db.plans.insertOne(planFixture(title: 'B'));
    final exercise = await ensureExerciseFixture(db, 'Bench press');

    final aOld = await db.workouts.insertReturning(
      WorkoutsCompanion.insert(
        planId: Value(planA),
        startedAt: DateTime(2026, 1, 1, 8),
        endedAt: Value(DateTime(2026, 1, 1, 9)),
      ),
    );
    final bLater = await db.workouts.insertReturning(
      WorkoutsCompanion.insert(
        planId: Value(planB),
        startedAt: DateTime(2026, 1, 3, 8),
        endedAt: Value(DateTime(2026, 1, 3, 9)),
      ),
    );
    final aLatest = await db.workouts.insertReturning(
      WorkoutsCompanion.insert(
        planId: Value(planA),
        startedAt: DateTime(2026, 1, 2, 23, 55),
        endedAt: Value(DateTime(2026, 1, 3, 0, 15)),
      ),
    );

    await addMirroredSet(
      exerciseId: exercise.id,
      exerciseName: exercise.name,
      planId: planA,
      workoutId: aOld.id,
      created: DateTime(2026, 1, 1, 8, 5),
      weight: 30,
    );
    await addMirroredSet(
      exerciseId: exercise.id,
      exerciseName: exercise.name,
      planId: planB,
      workoutId: bLater.id,
      created: DateTime(2026, 1, 3, 8, 5),
      weight: 90,
    );
    await addMirroredSet(
      exerciseId: exercise.id,
      exerciseName: exercise.name,
      planId: planA,
      workoutId: aLatest.id,
      created: DateTime(2026, 1, 2, 23, 58),
      weight: 40,
    );
    await addMirroredSet(
      exerciseId: exercise.id,
      exerciseName: exercise.name,
      planId: planA,
      workoutId: aLatest.id,
      created: DateTime(2026, 1, 3, 0, 5),
      weight: 45,
    );

    await resumeOrStartWorkout(db, planA, now: DateTime(2026, 1, 4, 8));
    final prefill = await getStartPlanPrefillById(
      db,
      exerciseId: exercise.id,
      planId: planA,
    );

    expect(prefill, isNotNull);
    expect(prefill!.planId, planA);
    expect(prefill.weight, 40);

    await insertPlanExerciseFixture(db, planId: planA, exercise: exercise.name);
    final page = await watchStartPlanData(db, planA).first;
    expect(page.defaults[exercise.id]?.id, prefill.id);
    expect(page.sets[exercise.id], isNull);
    expect(page.previous[exercise.id]?.sets.map((set) => set.weight), [45, 90]);
    final saved = await addMirroredSet(
      exerciseId: exercise.id,
      exerciseName: exercise.name,
      planId: planA,
      workoutId: page.workout.id,
      created: DateTime.now(),
      weight: 50,
    );
    final updated = await watchStartPlanData(db, planA).first;
    expect(updated.defaults[exercise.id]?.id, saved.id);
    expect(updated.sets[exercise.id]?.map((set) => set.id), [saved.id]);
  });

  test(
    'manual history remains workout_id null and is fallback prefill',
    () async {
      final planId = await db.plans.insertOne(planFixture());
      final exercise = await ensureExerciseFixture(db, 'Manual press');
      final manual = await addMirroredSet(
        exerciseId: exercise.id,
        exerciseName: exercise.name,
        planId: null,
        workoutId: null,
        created: testNow,
        weight: 55,
      );

      final stable = await db.exerciseSets.select().getSingle();
      expect(stable.workoutId, isNull);

      final prefill = await getStartPlanPrefillById(
        db,
        exerciseId: exercise.id,
        planId: planId,
      );
      expect(prefill?.id, manual.id);
      await insertPlanExerciseFixture(
        db,
        planId: planId,
        exercise: exercise.name,
      );
      final page = await watchStartPlanData(db, planId).first;
      expect(page.defaults[exercise.id]?.id, manual.id);
    },
  );
}
