import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flexify/app_search.dart';
import 'package:flexify/database.dart';
import 'package:flexify/edit_plan_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan_state.dart';
import 'package:flexify/plans_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  PlanState? _planState;
  final Set<int> _selected = {};
  String _search = '';

  @override
  void initState() {
    super.initState();
    _updatePlans();
  }

  Future<void> _updatePlans({List<Plan>? plans}) async {
    _planState?.updatePlans(plans);
  }

  @override
  Widget build(BuildContext context) {
    _planState = context.watch<PlanState>();
    final filtered = _planState?.plans
        .where((element) =>
            element.days.toLowerCase().contains(_search.toLowerCase()) ||
            element.exercises.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return Scaffold(
      body: Column(
        children: [
          AppSearch(
            onChange: (value) {
              setState(() {
                _search = value;
              });
            },
            onClear: () => setState(() {
              _selected.clear();
            }),
            onDelete: () async {
              final planState = context.read<PlanState>();
              final selectedCopy = _selected.toList();
              setState(() {
                _selected.clear();
              });
              await db.plans.deleteWhere((tbl) => tbl.id.isIn(selectedCopy));
              planState.updatePlans(null);
            },
            onSelect: () => setState(() {
              _selected.addAll(filtered?.map((plan) => plan.id) ?? []);
            }),
            selected: _selected,
            onEdit: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditPlanPage(
                        plan: _planState!.plans
                            .firstWhere(
                                (element) => element.id == _selected.first)
                            .toCompanion(false),
                      )),
            ),
            onRefresh: () => _updatePlans(),
          ),
          Expanded(
            child: PlansList(
              plans: filtered ?? [],
              updatePlans: _updatePlans,
              navigatorKey: widget.navigatorKey,
              selected: _selected,
              onSelect: (id) {
                if (_selected.contains(id))
                  setState(() {
                    _selected.remove(id);
                  });
                else
                  setState(() {
                    _selected.add(id);
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
          await _updatePlans();
        },
        tooltip: 'Add plan',
        child: const Icon(Icons.add),
      ),
    );
  }
}
