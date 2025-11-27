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
  List<Plan>? filtered;

  final Set<int> selected = {};
  final scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    state = context.read<PlanState>();
    state?.addListener(_onPlansStateChanged);
    _filterPlans();
  }

  @override
  void dispose() {
    state?.removeListener(_onPlansStateChanged);
    super.dispose();
  }

  void _onPlansStateChanged() {
    _filterPlans();
  }

  Future<void> _filterPlans() async {
    if (state == null) return;

    final allPlans = state!.plans;
    List<Plan> tempFiltered = [];

    for (final plan in allPlans) {
      bool matches = plan.days.toLowerCase().contains(search.toLowerCase());
      if (!matches && search.isNotEmpty) {
        final planExercises = await (db.planExercises.select()
              ..where(
                (tbl) =>
                    tbl.planId.equals(plan.id) & tbl.exercise.like('%$search%'),
              ))
            .get();
        matches = planExercises.isNotEmpty;
      }
      if (matches) {
        tempFiltered.add(plan);
      }
    }

    setState(() {
      filtered = tempFiltered;
    });
  }

  @override
  Widget build(BuildContext context) {
    state = context.watch<PlanState>(); // Watch for changes to rebuild

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

              final summaries = await Future.wait(
                plans.map((plan) async {
                  final days = plan.days.split(',').join(', ');
                  await state?.setExercises(plan.toCompanion(false));
                  final exercises = state?.exercises
                      .where((pe) => pe.enabled.value)
                      .map((pe) => "- ${pe.exercise.value}")
                      .join('\n');

                  return "$days:\n$exercises";
                }),
              );

              await SharePlus.instance
                  .share(ShareParams(text: summaries.join('\n\n')));
              setState(() {
                selected.clear();
              });
            },
            onChange: (value) {
              setState(() {
                search = value;
                _filterPlans(); // Re-filter when search changes
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
}
