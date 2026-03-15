import 'package:drift/drift.dart' as drift;
import 'package:flexify/animated_fab.dart';
import 'package:flexify/app_search.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/plans_list.dart';
import 'package:flexify/selection_controller.dart';
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

  final _selection = SelectionController<int>();
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

    if (search.isEmpty) {
      if (mounted) setState(() => filtered = allPlans.toList());
      return;
    }

    final lowerSearch = search.toLowerCase();

    // Single query to find all plan IDs with a matching exercise
    final matchingIds = await (db.planExercises.selectOnly()
          ..addColumns([db.planExercises.planId])
          ..where(db.planExercises.exercise.like('%$search%')))
        .map((row) => row.read(db.planExercises.planId))
        .get();

    final matchingIdSet = matchingIds.whereType<int>().toSet();

    final tempFiltered = allPlans
        .where(
          (plan) =>
              plan.days.toLowerCase().contains(lowerSearch) ||
              matchingIdSet.contains(plan.id),
        )
        .toList();

    if (mounted) setState(() => filtered = tempFiltered);
  }

  @override
  Widget build(BuildContext context) {
    state = context.watch<PlanState>(); // Watch for changes to rebuild

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          AppSearch(
            controller: _selection,
            onShare: () async {
              final plans = (state?.plans)!
                  .where(
                    (plan) => _selection.contains(plan.id),
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
                _selection.clear();
              });
            },
            onChange: (value) {
              setState(() {
                search = value;
                _filterPlans(); // Re-filter when search changes
              });
            },
            onDelete: () async {
              final state = context.read<PlanState>();
              final copy = _selection.toList();
              setState(() {
                _selection.clear();
              });
              await db.plans.deleteWhere((tbl) => tbl.id.isIn(copy));
              state.updatePlans(null);
              await db.planExercises
                  .deleteWhere((tbl) => tbl.planId.isIn(copy));
            },
            onSelectAll: () => setState(() {
              _selection.setAll(filtered?.map((plan) => plan.id) ?? []);
            }),
            onEdit: () async {
              final plan = state!.plans
                  .firstWhere(
                    (element) => element.id == _selection.first,
                  )
                  .toCompanion(false);
              await state!.setExercises(plan);
              if (context.mounted)
                await Navigator.of(context).push(
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
              plans: filtered,
              navKey: widget.navKey,
              selected: _selection.selected,
              search: search,
              onSelect: (id) {
                setState(() {
                  _selection.toggle(id);
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
            await Navigator.of(context).push(
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
