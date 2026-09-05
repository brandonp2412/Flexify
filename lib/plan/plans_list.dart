import 'package:drift/drift.dart' as drift;
import 'package:flexify/app_search.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/empty_state.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/plan_tile.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/foundation.dart' show listEquals;
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
  List<Plan> _filteredPlans = [];

  @override
  void initState() {
    super.initState();
    _updateFilteredPlans();
  }

  @override
  void didUpdateWidget(PlansList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.plans, widget.plans) ||
        oldWidget.search != widget.search) {
      _updateFilteredPlans();
    }
  }

  void _updateFilteredPlans() {
    _filteredPlans = widget.plans?.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final searchLabel = widget.search.trim();
    final noneFound = Padding(
      padding: const EdgeInsets.only(top: appSearchHeight),
      child: AppEmptyState(
        icon: searchLabel.isEmpty
            ? Icons.fitness_center_rounded
            : Icons.search_off_rounded,
        title: searchLabel.isEmpty ? 'No plans yet' : 'No matching plans',
        message: searchLabel.isEmpty
            ? 'Create your first training plan to get started.'
            : 'Nothing matches “$searchLabel”. You can create it as a new plan.',
        actionLabel: searchLabel.isEmpty
            ? 'Create plan'
            : 'Create “$searchLabel”',
        actionIcon: Icons.add_rounded,
        onAction: () async {
          final plan = PlansCompanion(
            days: const drift.Value(''),
            title: drift.Value(searchLabel),
          );
          await context.read<PlanState>().setExercises(plan);
          if (context.mounted)
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditPlanPage(plan: plan)),
            );
        },
      ),
    );

    if (widget.plans == null) return noneFound;

    final weekday = weekdays[DateTime.now().weekday - 1];

    final filteredPlans = _filteredPlans;

    if (widget.plans!.isEmpty || filteredPlans.isEmpty) return noneFound;

    final settings = context.read<SettingsState>();

    if (settings.value.planTrailing == PlanTrailing.reorder.toString())
      return ReorderableListView.builder(
        scrollController: widget.scroll,
        buildDefaultDragHandles: !isDesktopLayout(context),
        itemCount: filteredPlans.length,
        padding: const EdgeInsets.only(
          bottom: bottomNavHeight,
          top: appSearchHeight + 8,
        ),
        itemBuilder: (context, index) {
          final plan = filteredPlans[index];

          return ResponsiveContent(
            key: Key(plan.id.toString()),
            child: PlanTile(
              plan: plan,
              weekday: weekday,
              index: index,
              navigatorKey: widget.navKey,
              selected: widget.selected,
              onSelect: (id) => widget.onSelect(id),
            ),
          );
        },
        onReorderItem: (int old, int idx) async {
          final temp = filteredPlans[old];
          filteredPlans.removeAt(old);
          filteredPlans.insert(idx, temp);

          final state = context.read<PlanState>();
          state.updatePlans(filteredPlans);
          await db.transaction(() async {
            for (int i = 0; i < filteredPlans.length; i++) {
              final plan = filteredPlans[i];
              final updated = plan
                  .toCompanion(false)
                  .copyWith(sequence: drift.Value(i));
              await db.update(db.plans).replace(updated);
            }
          });
        },
      );

    return ListView.builder(
      controller: widget.scroll,
      itemCount: filteredPlans.length,
      padding: const EdgeInsets.only(
        bottom: bottomNavHeight,
        top: appSearchHeight + 8,
      ),
      itemBuilder: (context, index) {
        final plan = filteredPlans[index];

        return ResponsiveContent(
          child: PlanTile(
            plan: plan,
            weekday: weekday,
            index: index,
            navigatorKey: widget.navKey,
            selected: widget.selected,
            onSelect: (id) => widget.onSelect(id),
          ),
        );
      },
    );
  }
}
