import 'package:drift/drift.dart' as drift;
import 'package:flexify/animated_fab.dart';
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
  final TabController tabController;

  const PlansPage({super.key, required this.tabController});

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
        final settings = context.read<SettingsState>().value;
        final index = settings.tabs.split(',').indexOf('PlansPage');
        if (widget.tabController.index == index) navKey.currentState!.pop();
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
  String search = '';

  final Set<int> selected = {};
  final scroll = ScrollController();

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
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          AppSearch(
            onShare: () async {
              final plans = (state?.plans)!
                  .where(
                    (plan) => selected.contains(plan.id),
                  )
                  .toList();

              final summaries = plans.map((plan) async {
                final days = plan.days.split(',').join(', ');
                await state?.setExercises(plan.toCompanion(false));
                final exercises = state?.exercises
                    .where((pe) => pe.enabled.value)
                    .map((exercise) => "- $exercise")
                    .join('\n');

                return "$days:\n$exercises";
              }).join('\n\n');

              await SharePlus.instance.share(ShareParams(text: summaries));
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
              scroll: scroll,
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
      floatingActionButton: AnimatedFab(
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
        label: Text('Add'),
        icon: Icon(Icons.add),
        scroll: scroll,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
