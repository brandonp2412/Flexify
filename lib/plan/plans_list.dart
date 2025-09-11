import 'package:drift/drift.dart' as drift;
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/plan_tile.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlansList extends StatelessWidget {
  final List<Plan> plans;
  final GlobalKey<NavigatorState> navKey;
  final Set<int> selected;
  final Function(int) onSelect;
  final String search;
  final ScrollController scroll;

  const PlansList({
    super.key,
    required this.plans,
    required this.navKey,
    required this.selected,
    required this.onSelect,
    required this.search,
    required this.scroll,
  });

  @override
  Widget build(BuildContext context) {
    final weekday = weekdays[DateTime.now().weekday - 1];
    final state = context.watch<PlanState>();

    if (plans.isEmpty)
      return ListTile(
        title: const Text("No plans found"),
        subtitle: Text("Tap to create $search"),
        onTap: () async {
          final plan = PlansCompanion(
            days: const drift.Value(''),
            exercises: const drift.Value(''),
            title: drift.Value(search),
          );
          await state.setExercises(plan);
          if (context.mounted)
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPlanPage(
                  plan: plan,
                ),
              ),
            );
        },
      );

    final settings = context.read<SettingsState>();

    if (settings.value.planTrailing == PlanTrailing.reorder.toString())
      return ReorderableListView.builder(
        scrollController: scroll,
        itemCount: plans.length,
        padding: const EdgeInsets.only(bottom: 50, top: 16),
        itemBuilder: (context, index) {
          final plan = plans[index];
          return PlanTile(
            key: Key(plan.id.toString()),
            plan: plan,
            weekday: weekday,
            index: index,
            navigatorKey: navKey,
            selected: selected,
            onSelect: (id) => onSelect(id),
          );
        },
        onReorder: (int old, int idx) async {
          if (old < idx) {
            idx--;
          }

          final temp = plans[old];
          plans.removeAt(old);
          plans.insert(idx, temp);

          final state = context.read<PlanState>();
          state.updatePlans(plans);
          await db.transaction(() async {
            for (int i = 0; i < plans.length; i++) {
              final plan = plans[i];
              final updated =
                  plan.toCompanion(false).copyWith(sequence: drift.Value(i));
              await db.update(db.plans).replace(updated);
            }
          });
        },
      );

    return ListView.builder(
      controller: scroll,
      itemCount: plans.length,
      padding: const EdgeInsets.only(bottom: 50, top: 8),
      itemBuilder: (context, index) {
        final plan = plans[index];

        return PlanTile(
          plan: plan,
          weekday: weekday,
          index: index,
          navigatorKey: navKey,
          selected: selected,
          onSelect: (id) => onSelect(id),
        );
      },
    );
  }
}
