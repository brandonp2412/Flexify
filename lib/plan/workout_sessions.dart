import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/performed_sets.dart';

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

Stream<List<PlanExerciseEntry>> watchAllPlanExerciseEntries(
  AppDatabase database,
) {
  final query =
      database.select(database.planExercises).join([
        innerJoin(
          database.exercises,
          database.exercises.id.equalsExp(database.planExercises.exerciseId),
        ),
      ])..orderBy([
        OrderingTerm.asc(database.planExercises.planId),
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

Future<PerformedSetView?> getFirstOfLastPlanWorkout(
  AppDatabase database, {
  required int exerciseId,
  required int planId,
}) async {
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
  return getPerformedSetById(database, exerciseSet.id);
}

Future<PerformedSetView?> getStartPlanPrefillById(
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

  final manual = await getLatestManualExerciseSet(database, exerciseId);
  if (manual == null) return null;
  return getPerformedSetById(database, manual.id);
}

Stream<List<PerformedSetView>> watchLegacyWorkoutSets(
  AppDatabase database, {
  required int workoutId,
  required int exerciseId,
}) {
  return watchWorkoutPerformedSets(
    database,
    workoutId: workoutId,
    exerciseId: exerciseId,
  );
}

Future<PerformedSetView?> getLatestLegacyWorkoutSet(
  AppDatabase database, {
  required int workoutId,
  required int exerciseId,
}) {
  return getLatestWorkoutPerformedSet(
    database,
    workoutId: workoutId,
    exerciseId: exerciseId,
  );
}

double? canonicalLoadKg(String unit, double value) {
  return switch (unit) {
    'kg' => value,
    'lb' => value * 0.45359237,
    'stone' => value * 6.35029318,
    _ => null,
  };
}

Future<int> insertExerciseSetMirror(
  AppDatabase database, {
  required PerformedSetView performedSet,
  required int exerciseId,
  required int? workoutId,
  double? bodyWeightKg,
}) async {
  final inserted = await insertPerformedSet(
    database,
    performedSet: performedSet,
    exerciseId: exerciseId,
    workoutId: workoutId,
    bodyWeightKg: bodyWeightKg,
  );
  return inserted.id;
}
