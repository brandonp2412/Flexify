import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';

class PlanExerciseEntry {
  final PlanExercise planExercise;
  final Exercise exercise;

  const PlanExerciseEntry({required this.planExercise, required this.exercise});
}

Stream<List<PlanExerciseEntry>> watchPlanExerciseEntries(
  AppDatabase database,
  int planId,
) {
  final query =
      database.select(database.planExercises).join([
          innerJoin(
            database.exercises,
            database.exercises.id.equalsExp(database.planExercises.exerciseId),
          ),
        ])
        ..where(
          database.planExercises.planId.equals(planId) &
              database.planExercises.enabled.equals(true),
        )
        ..orderBy([
          OrderingTerm.asc(database.planExercises.sequence),
          OrderingTerm.asc(database.planExercises.id),
        ]);

  return query.watch().map(
    (rows) => rows
        .map(
          (row) => PlanExerciseEntry(
            planExercise: row.readTable(database.planExercises),
            exercise: row.readTable(database.exercises),
          ),
        )
        .toList(),
  );
}

Future<List<PlanExerciseEntry>> getPlanExerciseEntries(
  AppDatabase database,
  int planId,
) => watchPlanExerciseEntries(database, planId).first;

Future<Workout> resumeOrStartWorkout(
  AppDatabase database,
  int planId, {
  DateTime? now,
}) async {
  final existing =
      await (database.workouts.select()
            ..where(
              (workout) =>
                  workout.planId.equals(planId) & workout.endedAt.isNull(),
            )
            ..orderBy([
              (workout) => OrderingTerm.desc(workout.startedAt),
              (workout) => OrderingTerm.desc(workout.id),
            ])
            ..limit(1))
          .getSingleOrNull();
  if (existing != null) return existing;

  return database.workouts.insertReturning(
    WorkoutsCompanion.insert(
      planId: Value(planId),
      startedAt: now ?? DateTime.now(),
    ),
  );
}

Future<void> finishWorkout(
  AppDatabase database,
  int workoutId, {
  DateTime? now,
}) async {
  await (database.workouts.update()..where(
        (workout) => workout.id.equals(workoutId) & workout.endedAt.isNull(),
      ))
      .write(WorkoutsCompanion(endedAt: Value(now ?? DateTime.now())));
}

Future<Workout?> getLatestWorkoutForExercise(
  AppDatabase database, {
  required int planId,
  required int exerciseId,
}) async {
  final workoutId = await database
      .customSelect(
        '''
          SELECT workouts.id AS id
          FROM workouts
          WHERE workouts.plan_id = ?
            AND EXISTS (
              SELECT 1
              FROM exercise_sets
              WHERE exercise_sets.workout_id = workouts.id
                AND exercise_sets.exercise_id = ?
            )
          ORDER BY workouts.started_at DESC, workouts.id DESC
          LIMIT 1
        ''',
        variables: [Variable(planId), Variable(exerciseId)],
        readsFrom: {database.workouts, database.exerciseSets},
      )
      .map((row) => row.read<int>('id'))
      .getSingleOrNull();
  if (workoutId == null) return null;
  return (database.workouts.select()
        ..where((workout) => workout.id.equals(workoutId)))
      .getSingle();
}

Future<ExerciseSet?> getFirstExerciseSetInWorkout(
  AppDatabase database, {
  required int workoutId,
  required int exerciseId,
}) {
  return (database.exerciseSets.select()
        ..where(
          (set) =>
              set.workoutId.equals(workoutId) &
              set.exerciseId.equals(exerciseId),
        )
        ..orderBy([
          (set) => OrderingTerm.asc(set.timestamp),
          (set) => OrderingTerm.asc(set.id),
        ])
        ..limit(1))
      .getSingleOrNull();
}

Future<ExerciseSet?> getLatestManualExerciseSet(
  AppDatabase database,
  int exerciseId,
) {
  return (database.exerciseSets.select()
        ..where(
          (set) => set.exerciseId.equals(exerciseId) & set.workoutId.isNull(),
        )
        ..orderBy([
          (set) => OrderingTerm.desc(set.timestamp),
          (set) => OrderingTerm.desc(set.id),
        ])
        ..limit(1))
      .getSingleOrNull();
}

Future<GymSet?> _legacyGymSetForExerciseSet(
  AppDatabase database, {
  required Exercise exercise,
  required ExerciseSet exerciseSet,
  required int? planId,
}) {
  final query = database.gymSets.select()
    ..where(
      (set) =>
          set.name.equals(exercise.name) &
          set.hidden.equals(false) &
          set.created.equals(exerciseSet.timestamp) &
          (planId == null ? set.planId.isNull() : set.planId.equals(planId)),
    )
    ..orderBy([(set) => OrderingTerm.asc(set.id)])
    ..limit(1);
  return query.getSingleOrNull();
}

Future<GymSet?> getFirstOfLastPlanWorkout(
  AppDatabase database, {
  required int exerciseId,
  required int planId,
}) async {
  final exercise =
      await (database.exercises.select()
            ..where((row) => row.id.equals(exerciseId)))
          .getSingleOrNull();
  if (exercise == null) return null;

  final workout = await getLatestWorkoutForExercise(
    database,
    planId: planId,
    exerciseId: exerciseId,
  );
  if (workout == null) return null;

  final exerciseSet = await getFirstExerciseSetInWorkout(
    database,
    workoutId: workout.id,
    exerciseId: exerciseId,
  );
  if (exerciseSet == null) return null;

  return _legacyGymSetForExerciseSet(
    database,
    exercise: exercise,
    exerciseSet: exerciseSet,
    planId: planId,
  );
}

Future<GymSet?> getStartPlanPrefillById(
  AppDatabase database, {
  required int exerciseId,
  required int planId,
}) async {
  final planned = await getFirstOfLastPlanWorkout(
    database,
    exerciseId: exerciseId,
    planId: planId,
  );
  if (planned != null) return planned;

  final exercise =
      await (database.exercises.select()
            ..where((row) => row.id.equals(exerciseId)))
          .getSingleOrNull();
  if (exercise == null) return null;
  final manual = await getLatestManualExerciseSet(database, exerciseId);
  if (manual == null) return null;

  return _legacyGymSetForExerciseSet(
    database,
    exercise: exercise,
    exerciseSet: manual,
    planId: null,
  );
}

Stream<List<GymSet>> watchLegacyWorkoutSets(
  AppDatabase database, {
  required int workoutId,
  required int exerciseId,
}) {
  final query = database.exerciseSets.select()
    ..where(
      (set) =>
          set.workoutId.equals(workoutId) & set.exerciseId.equals(exerciseId),
    )
    ..orderBy([
      (set) => OrderingTerm.asc(set.timestamp),
      (set) => OrderingTerm.asc(set.id),
    ]);

  return query.watch().asyncMap((exerciseSets) async {
    if (exerciseSets.isEmpty) return const <GymSet>[];

    final exercise =
        await (database.exercises.select()
              ..where((row) => row.id.equals(exerciseId)))
            .getSingleOrNull();
    final workout =
        await (database.workouts.select()
              ..where((row) => row.id.equals(workoutId)))
            .getSingleOrNull();
    if (exercise == null || workout == null) return const <GymSet>[];

    final legacy =
        await (database.gymSets.select()
              ..where(
                (set) =>
                    set.name.equals(exercise.name) &
                    set.hidden.equals(false) &
                    (workout.planId == null
                        ? set.planId.isNull()
                        : set.planId.equals(workout.planId!)),
              )
              ..orderBy([
                (set) => OrderingTerm.asc(set.created),
                (set) => OrderingTerm.asc(set.id),
              ]))
            .get();

    final remaining = [...legacy];
    final result = <GymSet>[];
    for (final exerciseSet in exerciseSets) {
      final index = remaining.indexWhere(
        (set) => set.created == exerciseSet.timestamp,
      );
      if (index == -1) continue;
      result.add(remaining.removeAt(index));
    }
    return result;
  });
}

Future<GymSet?> getLatestLegacyWorkoutSet(
  AppDatabase database, {
  required int workoutId,
  required int exerciseId,
}) async {
  final sets = await watchLegacyWorkoutSets(
    database,
    workoutId: workoutId,
    exerciseId: exerciseId,
  ).first;
  return sets.isEmpty ? null : sets.last;
}

double? canonicalLoadKg(String unit, double value) {
  return switch (unit) {
    'kg' => value,
    'lb' => value * 0.45359237,
    'stone' => value * 6.35029318,
    _ => null,
  };
}

double? canonicalDistanceMetres(String unit, double value) {
  return switch (unit) {
    'm' => value,
    'km' => value * 1000,
    'mi' => value * 1609.344,
    _ => null,
  };
}

Future<int> insertExerciseSetMirror(
  AppDatabase database, {
  required GymSet gymSet,
  required int exerciseId,
  required int? workoutId,
  double? bodyWeightKg,
}) {
  return database.exerciseSets.insertOne(
    ExerciseSetsCompanion.insert(
      exerciseId: exerciseId,
      workoutId: Value(workoutId),
      timestamp: gymSet.created,
      reps: Value(gymSet.reps),
      loadKg: Value(canonicalLoadKg(gymSet.unit, gymSet.weight)),
      durationMs: Value((gymSet.duration * 60000).round()),
      distanceMetres: Value(
        canonicalDistanceMetres(gymSet.unit, gymSet.distance),
      ),
      incline: Value(gymSet.incline?.toDouble()),
      bodyWeightKg: Value(bodyWeightKg),
      notes: Value(gymSet.notes),
    ),
  );
}

Future<ExerciseSet?> findExerciseSetMirror(
  AppDatabase database,
  GymSet gymSet,
) async {
  final exercise =
      await (database.exercises.select()
            ..where((row) => row.name.equals(gymSet.name)))
          .getSingleOrNull();
  if (exercise == null) return null;

  final candidates =
      await (database.exerciseSets.select()
            ..where(
              (set) =>
                  set.exerciseId.equals(exercise.id) &
                  set.timestamp.equals(gymSet.created),
            )
            ..orderBy([(set) => OrderingTerm.asc(set.id)]))
          .get();
  for (final candidate in candidates) {
    if (gymSet.planId == null && candidate.workoutId == null) return candidate;
    final workoutId = candidate.workoutId;
    if (gymSet.planId == null || workoutId == null) continue;
    final workout =
        await (database.workouts.select()
              ..where((row) => row.id.equals(workoutId)))
            .getSingleOrNull();
    if (workout?.planId == gymSet.planId) return candidate;
  }
  return null;
}

Future<void> updateExerciseSetMirror(
  AppDatabase database, {
  required GymSet originalGymSet,
  required GymSet gymSet,
  required int exerciseId,
}) async {
  final existing = await findExerciseSetMirror(database, originalGymSet);
  if (existing == null) {
    await insertExerciseSetMirror(
      database,
      gymSet: gymSet,
      exerciseId: exerciseId,
      workoutId: null,
    );
    return;
  }

  await (database.exerciseSets.update()
        ..where((set) => set.id.equals(existing.id)))
      .write(
        ExerciseSetsCompanion(
          exerciseId: Value(exerciseId),
          timestamp: Value(gymSet.created),
          reps: Value(gymSet.reps),
          loadKg: Value(canonicalLoadKg(gymSet.unit, gymSet.weight)),
          durationMs: Value((gymSet.duration * 60000).round()),
          distanceMetres: Value(
            canonicalDistanceMetres(gymSet.unit, gymSet.distance),
          ),
          incline: Value(gymSet.incline?.toDouble()),
          notes: Value(gymSet.notes),
        ),
      );
}

Future<void> deleteExerciseSetMirror(
  AppDatabase database,
  GymSet gymSet,
) async {
  final existing = await findExerciseSetMirror(database, gymSet);
  if (existing != null) await database.exerciseSets.deleteOne(existing);
}
