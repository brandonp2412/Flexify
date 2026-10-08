import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_key.dart';
import 'package:flexify/main.dart';

class PlanExerciseDraft {
  const PlanExerciseDraft({
    required this.planExercise,
    required this.exerciseName,
  });

  final PlanExercisesCompanion planExercise;
  final String exerciseName;

  PlanExerciseDraft copyWithPlanExercise(PlanExercisesCompanion value) =>
      PlanExerciseDraft(planExercise: value, exerciseName: exerciseName);
}

class PlanCount {
  final int planId;
  final int total;
  final int maxSets;

  const PlanCount({
    required this.planId,
    required this.total,
    required this.maxSets,
  });
}

typedef GymCount = ({
  int exerciseId,
  int count,
  String name,
  int? maxSets,
  int? restMs,
  int? warmupSets,
  bool timers,
});

Stream<List<Plan>> watchPlans() {
  return (db.select(
    db.plans,
  )..orderBy([(plan) => OrderingTerm(expression: plan.sequence)])).watch();
}

Stream<List<PlanCount>> watchPlanCounts() {
  return db
      .customSelect(
        '''
          SELECT
            plans.id AS id,
            COALESCE(
              (
                SELECT SUM(COALESCE(pe.max_sets, settings.max_sets))
                FROM plan_exercises AS pe
                CROSS JOIN settings
                WHERE pe.plan_id = plans.id
                  AND pe.enabled = 1
              ),
              0
            ) AS max_sets,
            COUNT(exercise_sets.id) AS session_count
          FROM plans
          LEFT JOIN workouts
            ON workouts.id = (
              SELECT active.id
              FROM workouts AS active
              WHERE active.plan_id = plans.id
                AND active.ended_at IS NULL
              ORDER BY active.started_at DESC, active.id DESC
              LIMIT 1
            )
          LEFT JOIN exercise_sets
            ON exercise_sets.workout_id = workouts.id
          GROUP BY plans.id
        ''',
        readsFrom: {
          db.plans,
          db.planExercises,
          db.settings,
          db.workouts,
          db.exerciseSets,
        },
      )
      .watch()
      .map(
        (rows) => rows
            .map(
              (row) => PlanCount(
                maxSets: row.read<int>('max_sets'),
                planId: row.read<int>('id'),
                total: row.read<int>('session_count'),
              ),
            )
            .toList(),
      );
}

Stream<Plan?> watchPlan(int planId) =>
    (db.plans.select()..where((plan) => plan.id.equals(planId)))
        .watchSingleOrNull();

Stream<List<GymCount>> watchGymCounts(int planId, int workoutId) {
  return db
      .customSelect(
        '''
          SELECT
            exercises.id AS exercise_id,
            exercises.name AS name,
            COUNT(exercise_sets.id) AS session_count,
            plan_exercises.max_sets AS max_sets,
            exercises.default_rest_duration_ms AS rest_ms,
            plan_exercises.warmup_sets AS warmup_sets,
            plan_exercises.timers AS timers
          FROM plan_exercises
          INNER JOIN exercises
            ON exercises.id = plan_exercises.exercise_id
          LEFT JOIN exercise_sets
            ON exercise_sets.exercise_id = exercises.id
            AND exercise_sets.workout_id = ?
          WHERE plan_exercises.plan_id = ?
            AND plan_exercises.enabled = 1
          GROUP BY plan_exercises.id, exercises.id
          ORDER BY plan_exercises.sequence, plan_exercises.id
        ''',
        variables: [Variable(workoutId), Variable(planId)],
        readsFrom: {
          db.planExercises,
          db.exercises,
          db.exerciseSets,
          db.workouts,
        },
      )
      .watch()
      .map(
        (rows) => rows
            .map(
              (row) => (
                exerciseId: row.read<int>('exercise_id'),
                count: row.read<int>('session_count'),
                name: row.read<String>('name'),
                maxSets: row.readNullable<int>('max_sets'),
                restMs: row.readNullable<int>('rest_ms'),
                warmupSets: row.readNullable<int>('warmup_sets'),
                timers: row.read<int>('timers') != 0,
              ),
            )
            .toList(),
      );
}

Future<List<GymCount>> getGymCounts(int planId, int workoutId) =>
    watchGymCounts(planId, workoutId).first;

Future<List<PlanExerciseDraft>> loadPlanExerciseDrafts(
  PlansCompanion plan,
) async {
  final query = db.exercises.selectOnly()
    ..addColumns([db.exercises.id, db.exercises.name, db.categories.name])
    ..where(db.exercises.archived.equals(false))
    ..join([
      leftOuterJoin(
        db.categories,
        db.categories.id.equalsExp(db.exercises.categoryId),
      ),
      leftOuterJoin(
        db.planExercises,
        db.planExercises.planId.equals(plan.id.present ? plan.id.value : 0) &
            db.planExercises.exerciseId.equalsExp(db.exercises.id),
      ),
    ])
    ..addColumns(db.planExercises.$columns);

  final rows = await query.get();
  final enabled = <PlanExerciseDraft>[];
  final disabled = <PlanExerciseDraft>[];
  ExerciseKey keyOf(TypedResult row) => (
    name: row.read(db.exercises.name)!,
    category: row.read(db.categories.name),
  );
  final sharedNames = sharedExerciseNames(rows.map(keyOf));

  for (final row in rows) {
    final planExercise = PlanExercisesCompanion(
      planId: plan.id,
      id: Value.absentIfNull(row.read(db.planExercises.id)),
      exerciseId: Value(row.read(db.exercises.id)!),
      enabled: Value(row.read(db.planExercises.enabled) ?? false),
      maxSets: Value(row.read(db.planExercises.maxSets)),
      warmupSets: Value(row.read(db.planExercises.warmupSets)),
      timers: Value(row.read(db.planExercises.timers) ?? true),
      sequence: Value(row.read(db.planExercises.sequence) ?? 0),
    );
    final draft = PlanExerciseDraft(
      planExercise: planExercise,
      exerciseName: exerciseLabel(keyOf(row), sharedNames),
    );
    (planExercise.enabled.value ? enabled : disabled).add(draft);
  }

  enabled.sort(
    (a, b) =>
        a.planExercise.sequence.value.compareTo(b.planExercise.sequence.value),
  );
  return [...enabled, ...disabled];
}
