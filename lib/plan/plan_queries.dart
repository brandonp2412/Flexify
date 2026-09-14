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
  final count = CustomExpression<int>('''
    COUNT(
      CASE
        WHEN DATE(created, 'unixepoch', 'localtime') = DATE('now', 'localtime')
             AND hidden = 0
             AND gym_sets.plan_id = $planId
        THEN 1
      END
    )
  ''');

  final query = db.selectOnly(db.planExercises)
    ..addColumns([
      db.gymSets.name,
      count,
      db.planExercises.maxSets,
      db.gymSets.restMs,
      db.planExercises.warmupSets,
      db.planExercises.timers,
    ])
    ..join([
      innerJoin(
        db.gymSets,
        db.gymSets.name.equalsExp(db.planExercises.exercise),
      ),
    ])
    ..where(db.planExercises.planId.equals(planId) & db.planExercises.enabled)
    ..groupBy([db.gymSets.name]);

  return query.watch().map(
    (rows) => rows
        .map(
          (row) => (
            count: row.read<int>(count)!,
            name: row.read(db.gymSets.name)!,
            maxSets: row.read(db.planExercises.maxSets),
            restMs: row.read(db.gymSets.restMs),
            warmupSets: row.read(db.planExercises.warmupSets),
            timers: row.read(db.planExercises.timers)!,
          ),
        )
        .toList(),
  );
}

Future<List<GymCount>> getGymCounts(int planId) => watchGymCounts(planId).first;

Future<List<PlanExercisesCompanion>> loadPlanExerciseDrafts(
  PlansCompanion plan,
) async {
  final query = db.gymSets.selectOnly()
    ..addColumns([db.gymSets.name])
    ..groupBy([db.gymSets.name])
    ..join([
      leftOuterJoin(
        db.planExercises,
        db.planExercises.planId.equals(plan.id.present ? plan.id.value : 0) &
            db.planExercises.exercise.equalsExp(db.gymSets.name),
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
      exercise: Value(row.read(db.gymSets.name)!),
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
