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

class PlansList extends StatefulWidget {
  final List<Plan>? plans;
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
  State<PlansList> createState() => _PlansListState();
}

class _PlansListState extends State<PlansList> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<PlanState>();

    final noneFound = ListTile(
      title: const Text("No plans found"),
      subtitle: Text("Tap to create ${widget.search}"),
      onTap: () async {
        final plan = PlansCompanion(
          days: const drift.Value(''),
          title: drift.Value(widget.search),
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

    if (widget.plans == null) return noneFound;

    final weekday = weekdays[DateTime.now().weekday - 1];

    final filteredPlans = widget.plans!.where((plan) {
      final term = widget.search.toLowerCase();
      return plan.title?.toLowerCase().contains(term) == true ||
          plan.days.toLowerCase().contains(term);
    }).toList();

    if (widget.plans!.isEmpty || filteredPlans.isEmpty) return noneFound;

    final settings = context.read<SettingsState>();

    if (settings.value.planTrailing == PlanTrailing.reorder.toString())
      return ReorderableListView.builder(
        scrollController: widget.scroll,
        itemCount: filteredPlans.length,
        padding: const EdgeInsets.only(bottom: 96, top: 16),
        itemBuilder: (context, index) {
          final plan = filteredPlans[index];

          return PlanTile(
            key: Key(plan.id.toString()),
            plan: plan,
            weekday: weekday,
            index: index,
            navigatorKey: widget.navKey,
            selected: widget.selected,
            onSelect: (id) => widget.onSelect(id),
          );
        },
        onReorder: (int old, int idx) async {
          if (old < idx) {
            idx--;
          }

          final temp = filteredPlans[old];
          filteredPlans.removeAt(old);
          filteredPlans.insert(idx, temp);

          final state = context.read<PlanState>();
          state.updatePlans(filteredPlans);
          await db.transaction(() async {
            for (int i = 0; i < filteredPlans.length; i++) {
              final plan = filteredPlans[i];
              final updated =
                  plan.toCompanion(false).copyWith(sequence: drift.Value(i));
              await db.update(db.plans).replace(updated);
            }
          });
        },
      );

    return ListView.builder(
      controller: widget.scroll,
      itemCount: filteredPlans.length,
      padding: const EdgeInsets.only(bottom: 96, top: 8),
      itemBuilder: (context, index) {
        final plan = filteredPlans[index];

        return PlanTile(
          plan: plan,
          weekday: weekday,
          index: index,
          navigatorKey: widget.navKey,
          selected: widget.selected,
          onSelect: (id) => widget.onSelect(id),
        );
      },
    );
  }
}
