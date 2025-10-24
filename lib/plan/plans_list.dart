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
  State<PlansList> createState() => _PlansListState();
}

class _PlansListState extends State<PlansList> {
  Map<int, String>? exercisesMap;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  @override
  void didUpdateWidget(PlansList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.plans != oldWidget.plans) {
      _loadExercises();
    }
  }

  Future<void> _loadExercises() async {
    final tempMap = <int, String>{};

    // 1. Iterate through plans and generate the exercise summary string.
    for (final plan in widget.plans) {
      // 2. Query PlanExercises table directly for the current plan ID.
      // This is the essential part: querying the DB for the summary without
      // touching the PlanState's 'exercises' list or calling notifyListeners.
      final planExercises = await (db.planExercises.select()
            ..where(
              (tbl) => tbl.planId.equals(plan.id) & tbl.enabled.equals(true),
            ))
          .get();

      tempMap[plan.id] =
          planExercises.map((pe) => pe.exercise).toList().join(', ');
    }

    // 3. Update the UI only once all data is ready
    if (mounted) {
      setState(() {
        exercisesMap = tempMap;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final weekday = weekdays[DateTime.now().weekday - 1];
    final state = context.watch<PlanState>();

    if (widget.plans.isEmpty)
      return ListTile(
        title: const Text("No plans found"),
        subtitle: Text("Tap to create ${widget.search}"),
        onTap: () async {
          final plan = PlansCompanion(
            days: const drift.Value(''),
            exercises: const drift.Value(''),
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

    final settings = context.read<SettingsState>();

    if (settings.value.planTrailing == PlanTrailing.reorder.toString())
      return ReorderableListView.builder(
        scrollController: widget.scroll,
        itemCount: widget.plans.length,
        padding: const EdgeInsets.only(bottom: 96, top: 16),
        itemBuilder: (context, index) {
          final plan = widget.plans[index];

          return PlanTile(
            key: Key(plan.id.toString()),
            plan: plan,
            weekday: weekday,
            index: index,
            navigatorKey: widget.navKey,
            selected: widget.selected,
            exercises: exercisesMap![plan.id] ?? '',
            onSelect: (id) => widget.onSelect(id),
          );
        },
        onReorder: (int old, int idx) async {
          if (old < idx) {
            idx--;
          }

          final temp = widget.plans[old];
          widget.plans.removeAt(old);
          widget.plans.insert(idx, temp);

          final state = context.read<PlanState>();
          state.updatePlans(widget.plans);
          await _loadExercises();
          await db.transaction(() async {
            for (int i = 0; i < widget.plans.length; i++) {
              final plan = widget.plans[i];
              final updated =
                  plan.toCompanion(false).copyWith(sequence: drift.Value(i));
              await db.update(db.plans).replace(updated);
            }
          });
        },
      );

    return ListView.builder(
      controller: widget.scroll,
      itemCount: widget.plans.length,
      padding: const EdgeInsets.only(bottom: 96, top: 8),
      itemBuilder: (context, index) {
        final plan = widget.plans[index];

        return PlanTile(
          plan: plan,
          weekday: weekday,
          index: index,
          navigatorKey: widget.navKey,
          selected: widget.selected,
          exercises: exercisesMap![plan.id] ?? '',
          onSelect: (id) => widget.onSelect(id),
        );
      },
    );
  }
}
