import 'package:drift/drift.dart' as drift;
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/plan_tile.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlansList extends StatelessWidget {
  final List<Plan> plans;
  final GlobalKey<NavigatorState> navigatorKey;
  final Set<int> selected;
  final Function(int) onSelect;

  const PlansList({
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
        padding: const EdgeInsets.only(bottom: 50),
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

    return ListView.builder(
      itemCount: plans.length,
      padding: const EdgeInsets.only(bottom: 50),
      itemBuilder: (context, index) {
        final plan = plans[index];

        return PlanTile(
          plan: plan,
          weekday: weekday,
          index: index,
          navigatorKey: navigatorKey,
          selected: selected,
          onSelect: (id) => onSelect(id),
        );
      },
    );
  }
}
