import 'package:drift/drift.dart' as drift;
import 'package:flexify/app_search.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/edit_plan_page.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/plan/plans_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => PlansPageState();
}

class PlansPageState extends State<PlansPage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPop: () {
        if (navigatorKey.currentState!.canPop() == false) return;
        if (navigatorKey.currentState?.focusNode.hasFocus == false) return;
        navigatorKey.currentState!.pop();
      },
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => _PlansPageWidget(
            navigatorKey: navigatorKey,
          ),
          settings: settings,
        ),
      ),
    );
  }
}

class _PlansPageWidget extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const _PlansPageWidget({required this.navigatorKey});

  @override
  createState() => _PlansPageWidgetState();
}

class _PlansPageWidgetState extends State<_PlansPageWidget> {
  PlanState? planState;
  final Set<int> selected = {};
  String search = '';

  @override
  Widget build(BuildContext context) {
    planState = context.watch<PlanState>();
    final filtered = planState?.plans
        .where(
          (element) =>
              element.days.toLowerCase().contains(search.toLowerCase()) ||
              element.exercises.toLowerCase().contains(search.toLowerCase()),
        )
        .toList();

    return Scaffold(
      body: Column(
        children: [
          AppSearch(
            onShare: () async {
              final plans = (planState?.plans)!
                  .where(
                    (plan) => selected.contains(plan.id),
                  )
                  .toList();

              final summaries = plans
                  .map(
                    (plan) =>
                        """${plan.days.split(',').join(', ')}:\n${plan.exercises.split(',').map((exercise) => "- $exercise").join('\n')}""",
                  )
                  .join('\n\n');

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
              final planState = context.read<PlanState>();
              final selectedCopy = selected.toList();
              setState(() {
                selected.clear();
              });
              await db.plans.deleteWhere((tbl) => tbl.id.isIn(selectedCopy));
              planState.updatePlans(null);
              await db.planExercises
                  .deleteWhere((tbl) => tbl.planId.isIn(selectedCopy));
            },
            onSelect: () => setState(() {
              selected.addAll(filtered?.map((plan) => plan.id) ?? []);
            }),
            selected: selected,
            onEdit: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPlanPage(
                  plan: planState!.plans
                      .firstWhere(
                        (element) => element.id == selected.first,
                      )
                      .toCompanion(false),
                ),
              ),
            ),
          ),
          Expanded(
            child: PlansList(
              plans: filtered ?? [],
              navigatorKey: widget.navigatorKey,
              selected: selected,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditPlanPage(
                plan: PlansCompanion(
                  days: drift.Value(''),
                  exercises: drift.Value(''),
                ),
              ),
            ),
          );
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
