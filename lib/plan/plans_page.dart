import 'package:drift/drift.dart' as drift;
import 'package:flexify/app_search.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/plans_list.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => PlansPageState();
}

class PlansPageState extends State<PlansPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NavigatorPopHandler(
      onPopWithResult: (result) {
        if (navKey.currentState!.canPop() == false) return;
        final ctrl = DefaultTabController.of(context);
        final settings = context.read<SettingsState>().value;
        final index = settings.tabs.split(',').indexOf('PlansPage');
        if (ctrl.index == index) navKey.currentState!.pop();
      },
      child: Navigator(
        key: navKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => _PlansPageWidget(
            navKey: navKey,
          ),
          settings: settings,
        ),
      ),
    );
  }
}

class _PlansPageWidget extends StatefulWidget {
  final GlobalKey<NavigatorState> navKey;

  const _PlansPageWidget({required this.navKey});

  @override
  createState() => _PlansPageWidgetState();
}

class _PlansPageWidgetState extends State<_PlansPageWidget> {
  PlanState? state;
  final Set<int> selected = {};
  String search = '';

  @override
  Widget build(BuildContext context) {
    final terms =
        search.toLowerCase().split(" ").where((term) => term.isNotEmpty);
    List<Plan>? filtered;
    state = context.watch<PlanState>();

    if (state != null) {
      Iterable<Plan> filter = state!.plans;

      for (final term in terms) {
        filter = filter.where(
          (element) =>
              element.days.toLowerCase().contains(term.toLowerCase()) ||
              element.exercises.toLowerCase().contains(term.toLowerCase()),
        );
      }
      filtered = filter.toList();
    }

    return Scaffold(
      body: Column(
        children: [
          AppSearch(
            onShare: () async {
              final plans = (state?.plans)!
                  .where(
                    (plan) => selected.contains(plan.id),
                  )
                  .toList();

              final summaries = plans.map((plan) {
                final days = plan.days.split(',').join(', ');
                final exercises = plan.exercises
                    .split(',')
                    .map((exercise) => "- $exercise")
                    .join('\n');

                return "$days:\n$exercises";
              }).join('\n\n');

              await Share.share(summaries);
              setState(() {
                selected.clear();
              });
            },
            onChange: (value) {
              setState(() {
                search = value;
              });
            },
            onClear: () => setState(() {
              selected.clear();
            }),
            onDelete: () async {
              final state = context.read<PlanState>();
              final copy = selected.toList();
              setState(() {
                selected.clear();
              });
              await db.plans.deleteWhere((tbl) => tbl.id.isIn(copy));
              state.updatePlans(null);
              await db.planExercises
                  .deleteWhere((tbl) => tbl.planId.isIn(copy));
            },
            onSelect: () => setState(() {
              selected.addAll(filtered?.map((plan) => plan.id) ?? []);
            }),
            selected: selected,
            onEdit: () async {
              final plan = state!.plans
                  .firstWhere(
                    (element) => element.id == selected.first,
                  )
                  .toCompanion(false);
              await state!.setExercises(plan);
              if (context.mounted)
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPlanPage(
                      plan: plan,
                    ),
                  ),
                );
            },
          ),
          Expanded(
            child: PlansList(
              plans: filtered ?? [],
              navKey: widget.navKey,
              selected: selected,
              search: search,
              onSelect: (id) {
                if (selected.contains(id))
                  setState(() {
                    selected.remove(id);
                  });
                else
                  setState(() {
                    selected.add(id);
                  });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          const plan = PlansCompanion(
            days: drift.Value(''),
            exercises: drift.Value(''),
          );
          await state!.setExercises(plan);
          if (context.mounted)
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditPlanPage(
                  plan: plan,
                ),
              ),
            );
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
