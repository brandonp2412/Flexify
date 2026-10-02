import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';

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
          SELECT id, SUM(max_sets) AS max_sets,
            SUM(todays_count) AS todays_count FROM (
              SELECT p.id, pe.exercise AS name,
                COALESCE(pe.max_sets, settings.max_sets) AS max_sets,
                COUNT(
                  CASE WHEN gs.id IS NOT NULL
                    AND DATE(gs.created, 'unixepoch', 'localtime') = DATE('now', 'localtime')
                    AND gs.hidden = 0
                  THEN 1
                  END
                ) AS todays_count
              FROM plans p
              LEFT JOIN plan_exercises pe ON p.id = pe.plan_id
                AND pe.enabled = true
              LEFT JOIN settings
              LEFT JOIN gym_sets gs ON pe.exercise = gs.name
                AND gs.plan_id = p.id
              GROUP BY pe.exercise, p.id
            )
          GROUP BY id
        ''',
        readsFrom: {db.plans, db.gymSets, db.planExercises, db.settings},
      )
      .watch()
      .map(
        (rows) => rows
            .map(
              (row) => PlanCount(
                maxSets: row.read<int>('max_sets'),
                planId: row.read<int>('id'),
                total: row.read<int>('todays_count'),
              ),
            )
            .toList(),
      );
}

Stream<Plan?> watchPlan(int planId) =>
    (db.plans.select()..where((plan) => plan.id.equals(planId)))
        .watchSingleOrNull();

Stream<List<GymCount>> watchGymCounts(int planId) {
  return db
      .customSelect(
        '''
          SELECT
            COALESCE(exercises.name, plan_exercises.exercise) AS name,
            COUNT(
              CASE
                WHEN DATE(gym_sets.created, 'unixepoch', 'localtime') =
                     DATE('now', 'localtime')
                  AND gym_sets.hidden = 0
                  AND gym_sets.plan_id = ?
                THEN 1
              END
            ) AS todays_count,
            plan_exercises.max_sets AS max_sets,
            COALESCE(
              exercises.default_rest_duration_ms,
              MAX(gym_sets.rest_ms)
            ) AS rest_ms,
            plan_exercises.warmup_sets AS warmup_sets,
            plan_exercises.timers AS timers
          FROM plan_exercises
          LEFT JOIN exercises
            ON exercises.id = plan_exercises.exercise_id
            OR (
              plan_exercises.exercise_id IS NULL
              AND exercises.name = plan_exercises.exercise
            )
          LEFT JOIN gym_sets
            ON gym_sets.name = COALESCE(exercises.name, plan_exercises.exercise)
          WHERE plan_exercises.plan_id = ?
            AND plan_exercises.enabled = 1
          GROUP BY plan_exercises.id, exercises.id
          ORDER BY plan_exercises.sequence
        ''',
        variables: [Variable(planId), Variable(planId)],
        readsFrom: {db.planExercises, db.exercises, db.gymSets},
      )
      .watch()
      .map(
        (rows) => rows
            .map(
              (row) => (
                count: row.read<int>('todays_count'),
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

Future<List<GymCount>> getGymCounts(int planId) => watchGymCounts(planId).first;

Future<List<PlanExercisesCompanion>> loadPlanExerciseDrafts(
  PlansCompanion plan,
) async {
  final query = db.exercises.selectOnly()
    ..addColumns([db.exercises.id, db.exercises.name])
    ..where(db.exercises.archived.equals(false))
    ..join([
      leftOuterJoin(
        db.planExercises,
        db.planExercises.planId.equals(plan.id.present ? plan.id.value : 0) &
                db.planExercises.exerciseId.equalsExp(db.exercises.id) |
            (db.planExercises.exerciseId.isNull() &
                db.planExercises.exercise.equalsExp(db.exercises.name)),
      ),
    ])
    ..addColumns(db.planExercises.$columns);

  final rows = await query.get();
  final enabled = <PlanExercisesCompanion>[];
  final disabled = <PlanExercisesCompanion>[];

  for (final row in rows) {
    final exercise = PlanExercisesCompanion(
      planId: plan.id,
      id: Value.absentIfNull(row.read(db.planExercises.id)),
      exercise: Value(row.read(db.exercises.name)!),
      exerciseId: Value(row.read(db.exercises.id)),
      enabled: Value(row.read(db.planExercises.enabled) ?? false),
      maxSets: Value(row.read(db.planExercises.maxSets)),
      warmupSets: Value(row.read(db.planExercises.warmupSets)),
      timers: Value(row.read(db.planExercises.timers) ?? true),
      sequence: Value(row.read(db.planExercises.sequence) ?? 0),
    );
    (exercise.enabled.value ? enabled : disabled).add(exercise);
  }

  enabled.sort((a, b) => a.sequence.value.compareTo(b.sequence.value));
  return [...enabled, ...disabled];
}
