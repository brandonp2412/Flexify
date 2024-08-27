import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

class PlanCount {
  final int planId;
  final int total;
  final int maxSets;

  PlanCount({required this.planId, required this.total, required this.maxSets});
}

typedef GymCount = ({
  int count,
  String name,
  int? maxSets,
  int? restMs,
  int? warmupSets,
  bool timers,
});

class PlanState extends ChangeNotifier {
  List<Plan> plans = [];
  List<GymCount> gymCounts = [];
  List<PlanCount> planCounts = [];
  List<GymSet> lastSets = [];
  List<PlanExercisesCompanion> exercises = [];

  PlanState() {
    updatePlans(null);
    updatePlanCounts();
    updateDefaults();
  }

  Future<void> setExercises(PlansCompanion plan) async {
    var query = db.gymSets.selectOnly()
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

    final results = await query.get();

    List<PlanExercisesCompanion> enabledExercises = [];
    List<PlanExercisesCompanion> disabledExercises = [];

    for (final result in results) {
      final pe = PlanExercisesCompanion(
        planId: plan.id,
        id: Value.absentIfNull(result.read(db.planExercises.id)),
        exercise: Value(result.read(db.gymSets.name)!),
        enabled: Value(result.read(db.planExercises.enabled) ?? false),
        maxSets: Value(result.read(db.planExercises.maxSets)),
        warmupSets: Value(result.read(db.planExercises.warmupSets)),
        timers: Value(result.read(db.planExercises.timers) ?? true),
      );
      if (pe.enabled.value)
        enabledExercises.add(pe);
      else
        disabledExercises.add(pe);
    }

    enabledExercises.sort(
      (a, b) => plan.exercises.value
          .indexOf(a.exercise.value)
          .compareTo(plan.exercises.value.indexOf(b.exercise.value)),
    );

    exercises = enabledExercises + disabledExercises;
    notifyListeners();
  }

  updateDefaults() async {
    final value = await (db.gymSets.select().join([])
          ..orderBy(
            [
              OrderingTerm(
                expression: db.gymSets.created,
                mode: OrderingMode.desc,
              ),
            ],
          )
          ..groupBy([db.gymSets.name])
          ..addColumns(db.gymSets.$columns))
        .get();
    lastSets = value.map((value) => value.readTable(db.gymSets)).toList();
    notifyListeners();
  }

  updatePlanCounts() {
    getPlanCounts().then((value) {
      planCounts = value;
      notifyListeners();
    });
  }

  Future<void> updateGymCounts(int planId) {
    return getGymCounts(planId).then((value) {
      gymCounts = value;
      notifyListeners();
    });
  }

  Future<List<PlanCount>> getPlanCounts() async {
    return (db.customSelect(
      """
        SELECT id, SUM(max_sets) AS max_sets,
          SUM(todays_count) AS todays_count FROM (
            SELECT p.id, pe.exercise AS name,
              COALESCE(pe.max_sets, settings.max_sets) AS max_sets,
              COUNT(
                CASE WHEN p.id = gs.plan_id
                  AND DATE(created, 'unixepoch', 'localtime') =
                    DATE('now', 'localtime')
                  AND hidden = 0
                  THEN 1
                END
              ) as todays_count
            FROM plans p
            LEFT JOIN plan_exercises pe ON p.id = pe.plan_id
              AND pe.enabled = true
            LEFT JOIN settings
            LEFT JOIN gym_sets gs ON pe.exercise = gs.name
            GROUP BY pe.exercise, p.id
        )
        GROUP BY id
      """,
      readsFrom: {db.plans, db.gymSets, db.planExercises, db.settings},
    )).get().then((rows) {
      return rows
          .map(
            (row) => PlanCount(
              maxSets: row.read<int>('max_sets'),
              planId: row.read<int>('id'),
              total: row.read<int>('todays_count'),
            ),
          )
          .toList();
    });
  }

  Future<List<GymCount>> getGymCounts(int planId) async {
    final countColumn = CustomExpression<int>(
      """
      COUNT(
        CASE
          WHEN created >= strftime('%s', 'now', 'localtime', '-24 hours')
               AND hidden = 0
               AND gym_sets.plan_id = $planId
          THEN 1
        END
      )
   """,
    );

    final results = await (db.selectOnly(db.planExercises)
          ..addColumns([
            db.gymSets.name,
            countColumn,
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
          ..where(
            db.planExercises.planId.equals(planId) & db.planExercises.enabled,
          )
          ..groupBy([db.gymSets.name]))
        .get();
    return results
        .map(
          (row) => (
            count: row.read<int>(countColumn)!,
            name: row.read(db.gymSets.name)!,
            maxSets: row.read(db.planExercises.maxSets),
            restMs: row.read(db.gymSets.restMs),
            warmupSets: row.read(db.planExercises.warmupSets),
            timers: row.read(db.planExercises.timers)!,
          ),
        )
        .toList();
  }

  Future<List<Plan>> getPlans() async => await (db.select(db.plans)
        ..orderBy([
          (u) => OrderingTerm(expression: u.sequence),
        ]))
      .get();

  Future<void> updatePlans(List<Plan>? newPlans) async {
    if (newPlans != null)
      plans = newPlans;
    else
      plans = await getPlans();
    notifyListeners();
  }
}
