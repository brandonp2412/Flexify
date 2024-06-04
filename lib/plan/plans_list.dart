import 'dart:async';
import 'package:drift/drift.dart' as drift;
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_tile.dart';
import 'package:flutter/material.dart';

class PlansList extends StatelessWidget {
  final List<Plan> plans;
  final Future<void> Function({List<Plan>? plans}) updatePlans;
  final GlobalKey<NavigatorState> navigatorKey;
  final Set<int> selected;
  final Function(int) onSelect;

  const PlansList({
    super.key,
    required this.plans,
    required this.updatePlans,
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
          refresh: updatePlans,
          selected: selected,
          onSelect: (id) => onSelect(id),
        );
      },
      onReorder: (int oldIndex, int newIndex) async {
        if (oldIndex < newIndex) {
          newIndex--;
        }

        final temp = plans[oldIndex];
        plans.removeAt(oldIndex);
        plans.insert(newIndex, temp);

        await updatePlans(plans: plans);
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
  }
}
