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
  GymSet gymSet,
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

  void addExercise(GymSetsCompanion gymSet) {
    exercises.add(
      PlanExercisesCompanion(
        exercise: Value(gymSet.name.value),
        enabled: const Value(true),
      ),
    );
    exercises.sort((a, b) {
      if (a.enabled.value != b.enabled.value) {
        return b.enabled.value ? 1 : -1;
      }

      return a.exercise.value.compareTo(b.exercise.value);
    });
    notifyListeners();
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

    List<PlanExercisesCompanion> enabled = [];
    List<PlanExercisesCompanion> disabled = [];

    for (final result in results) {
      final pe = PlanExercisesCompanion(
        planId: plan.id,
        id: Value.absentIfNull(result.read(db.planExercises.id)),
        exercise: Value(result.read(db.gymSets.name)!),
        enabled: Value(result.read(db.planExercises.enabled) ?? false),
        maxSets: Value(result.read(db.planExercises.maxSets)),
        warmupSets: Value(result.read(db.planExercises.warmupSets)),
        timers: Value(result.read(db.planExercises.timers) ?? true),
        sequence: Value(result.read(db.planExercises.sequence) ?? 0),
      );
      if (pe.enabled.value)
        enabled.add(pe);
      else
        disabled.add(pe);
    }

    enabled.sort((a, b) => a.sequence.value.compareTo(b.sequence.value));

    exercises = enabled + disabled;
    notifyListeners();
  }

  Future<void> updateDefaults() async {
    final latest = db.gymSets.created.max();
    final sub = Subquery(
      db.select(db.gymSets).join([])
        ..groupBy([db.gymSets.name])
        ..addColumns([db.gymSets.name, latest]),
      'ls',
    );
    final query = db.select(db.gymSets).join(
      [
        innerJoin(
          sub,
          sub.ref(db.gymSets.name).equalsExp(db.gymSets.name) &
              sub.ref(latest).equalsExp(db.gymSets.created),
          useColumns: false,
        ),
      ],
    );
    final rows = await query.get();
    lastSets = rows.map((rows) => rows.readTable(db.gymSets)).toList();
    notifyListeners();
  }

  void updatePlanCounts() {
    getPlanCounts().then((value) {
      planCounts = value;
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
