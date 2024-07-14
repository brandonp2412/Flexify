import 'package:drift/drift.dart' as drift;
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/plan_tile.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Count {
  final int planId;
  final int total;
  final int maxSets;

  Count({required this.planId, required this.total, required this.maxSets});
}

class PlansList extends StatelessWidget {
  final List<Plan> plans;
  final GlobalKey<NavigatorState> navigatorKey;
  final Set<int> selected;
  final Function(int) onSelect;

  late final stream = (db.customSelect(
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
  )).watch().map((rows) {
    return rows
        .map(
          (row) => Count(
            maxSets: row.read<int>('max_sets'),
            planId: row.read<int>('id'),
            total: row.read<int>('todays_count'),
          ),
        )
        .toList();
  });

  PlansList({
    super.key,
    required this.plans,
    required this.navigatorKey,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final weekday = weekdays[DateTime.now().weekday - 1];

    if (plans.isEmpty)
      return const ListTile(
        title: Text("No plans yet."),
        subtitle: Text("Tap the plus button in the bottom right to add plans."),
      );

    final settings = context.read<SettingsState>();

    if (settings.value.planTrailing == PlanTrailing.reorder.toString())
      return ReorderableListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return PlanTile(
            key: Key(plan.id.toString()),
            plan: plan,
            weekday: weekday,
            index: index,
            navigatorKey: navigatorKey,
            selected: selected,
            onSelect: (id) => onSelect(id),
            countStream: stream,
          );
        },
        onReorder: (int oldIndex, int newIndex) async {
          if (oldIndex < newIndex) {
            newIndex--;
          }

          final temp = plans[oldIndex];
          plans.removeAt(oldIndex);
          plans.insert(newIndex, temp);

          final planState = context.read<PlanState>();
          planState.updatePlans(plans);
          await db.transaction(() async {
            for (int i = 0; i < plans.length; i++) {
              final plan = plans[i];
              final updatedPlan =
                  plan.toCompanion(false).copyWith(sequence: drift.Value(i));
              await db.update(db.plans).replace(updatedPlan);
            }
          });
        },
      );
    else
      return ListView.builder(
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return PlanTile(
            key: Key(plan.id.toString()),
            plan: plan,
            weekday: weekday,
            index: index,
            navigatorKey: navigatorKey,
            selected: selected,
            onSelect: (id) => onSelect(id),
            countStream: stream,
          );
        },
      );
  }
}
