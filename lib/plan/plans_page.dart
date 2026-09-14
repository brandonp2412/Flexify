import 'package:drift/drift.dart' as drift;
import 'package:flexify/animated_fab.dart';
import 'package:flexify/app_search.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/plan_queries.dart';
import 'package:flexify/plan/plans_list.dart';
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/selection_controller.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class _PlansNavigatorObserver extends NavigatorObserver {
  String? currentRouteName;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRouteName = route.settings.name;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentRouteName = previousRoute?.settings.name;
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    currentRouteName = newRoute?.settings.name;
  }
}

class PlansPage extends StatefulWidget {
  final TabController tabController;

  const PlansPage({super.key, required this.tabController});

  @override
  State<PlansPage> createState() => PlansPageState();
}

class PlansPageState extends State<PlansPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  final _routeObserver = _PlansNavigatorObserver();

  @override
  bool get wantKeepAlive => true;

  /// Opens [plan] unless that workout is already the active Plans route.
  Future<void> openPlanFromNotification(Plan plan) async {
    final navigator = navKey.currentState;
    if (navigator == null) return;

    final routeName = 'start-plan:${plan.id}';
    if (_routeObserver.currentRouteName == routeName) return;

    await navigator.push(
      MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) => StartPlanPage(plan: plan),
      ),
    );
  }

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
        observers: [_routeObserver],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => _PlansPageWidget(navKey: navKey),
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
  State<_PlansPageWidget> createState() => _PlansPageWidgetState();
}

class _PlansPageWidgetState extends State<_PlansPageWidget> {
  String _search = '';
  late Stream<List<Plan>> _plansStream;
  late Stream<List<PlanExercise>> _planExercisesStream;

  final _selection = SelectionController<int>();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _createStreams();
    dbVersion.addListener(_onDatabaseChanged);
  }

  @override
  void dispose() {
    dbVersion.removeListener(_onDatabaseChanged);
    _scroll.dispose();
    super.dispose();
  }

  void _createStreams() {
    _plansStream = watchPlans();
    _planExercisesStream = db.planExercises.select().watch();
  }

  void _onDatabaseChanged() {
    if (!mounted) return;
    setState(_createStreams);
  }

  List<Plan> _filterPlans(List<Plan> plans, List<PlanExercise> exercises) {
    if (_search.isEmpty) return plans;

    final search = _search.toLowerCase();
    final matchingPlanIds = exercises
        .where((exercise) => exercise.exercise.toLowerCase().contains(search))
        .map((exercise) => exercise.planId)
        .toSet();

    return plans
        .where(
          (plan) =>
              plan.title?.toLowerCase().contains(search) == true ||
              plan.days.toLowerCase().contains(search) ||
              matchingPlanIds.contains(plan.id),
        )
        .toList();
  }

  Future<void> _addPlan() async {
    const plan = PlansCompanion(days: drift.Value(''));
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EditPlanPage(plan: plan)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final desktop = isDesktopLayout(context);

    return StreamBuilder<List<Plan>>(
      stream: _plansStream,
      builder: (context, plansSnapshot) => StreamBuilder<List<PlanExercise>>(
        stream: _planExercisesStream,
        builder: (context, exercisesSnapshot) {
          final plans = plansSnapshot.data ?? const <Plan>[];
          final exercises = exercisesSnapshot.data ?? const <PlanExercise>[];
          final filtered = _filterPlans(plans, exercises);

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: desktop
                ? AppBar(
                    title: const Text('Plans'),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: FilledButton.icon(
                          onPressed: _addPlan,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('New plan'),
                        ),
                      ),
                    ],
                  )
                : null,
            body: Stack(
              children: [
                Positioned.fill(
                  child: PlansList(
                    scroll: _scroll,
                    plans: plansSnapshot.hasData ? filtered : null,
                    navKey: widget.navKey,
                    selected: _selection.selected,
                    search: _search,
                    onSelect: (id) {
                      setState(() => _selection.toggle(id));
                    },
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppSearch(
                    hintText: 'Search plans...',
                    controller: _selection,
                    onShare: () async {
                      final selectedPlans = plans
                          .where((plan) => _selection.contains(plan.id))
                          .toList();

                      final summaries = await Future.wait(
                        selectedPlans.map((plan) async {
                          final days = plan.days.split(',').join(', ');
                          final planExercises =
                              await (db.planExercises.select()
                                    ..where(
                                      (tbl) =>
                                          tbl.planId.equals(plan.id) &
                                          tbl.enabled,
                                    )
                                    ..orderBy([
                                      (u) => drift.OrderingTerm(
                                        expression: u.sequence,
                                      ),
                                    ]))
                                  .get();
                          final exerciseSummary = planExercises
                              .map((exercise) => '- ${exercise.exercise}')
                              .join('\n');
                          return '$days:\n$exerciseSummary';
                        }),
                      );

                      await SharePlus.instance.share(
                        ShareParams(text: summaries.join('\n\n')),
                      );
                      if (mounted) setState(_selection.clear);
                    },
                    onChange: (value) => setState(() => _search = value),
                    onDelete: () async {
                      final selectedIds = _selection.toList();
                      setState(_selection.clear);
                      await db.planExercises.deleteWhere(
                        (tbl) => tbl.planId.isIn(selectedIds),
                      );
                      await db.plans.deleteWhere(
                        (tbl) => tbl.id.isIn(selectedIds),
                      );
                    },
                    onSelectAll: () => setState(() {
                      _selection.setAll(filtered.map((plan) => plan.id));
                    }),
                    onEdit: () async {
                      final plan = plans
                          .firstWhere((plan) => plan.id == _selection.first)
                          .toCompanion(false);
                      if (!context.mounted) return;
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => EditPlanPage(plan: plan),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: desktop
                ? null
                : AnimatedFab(
                    onPressed: _addPlan,
                    label: const Text('Add'),
                    icon: const Icon(Icons.add),
                    scroll: _scroll,
                  ),
          );
        },
      ),
    );
  }
}
