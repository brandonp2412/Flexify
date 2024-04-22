import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flexify/constants.dart';
import 'package:flexify/database.dart';
import 'package:flexify/edit_plan_page.dart';
import 'package:flexify/enter_weight_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan_state.dart';
import 'package:flexify/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'plan_tile.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPop: () {
        if (_navigatorKey.currentState!.canPop() == false) return;
        if (_navigatorKey.currentState?.focusNode.hasFocus == false) return;
        _navigatorKey.currentState!.pop();
      },
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => _PlansPageWidget(
            navigatorKey: _navigatorKey,
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
  final TextEditingController _searchController = TextEditingController();

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

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              hintText: "Search...",
              controller: _searchController,
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onChanged: (_) {
                setState(() {});
              },
              leading: const Icon(Icons.search),
              trailing: _searchController.text.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    ]
                  : [
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          _enterWeight(context),
                          _settingsPage(context),
                        ],
                      )
                    ],
            ),
          ),
          _PlanWidget(
            plans: _planState?.plans ?? [],
            searchText: _searchController.text,
            updatePlans: _updatePlans,
            navigatorKey: widget.navigatorKey,
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

  PopupMenuItem<dynamic> _settingsPage(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () async {
          Navigator.of(context).pop();
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
          _updatePlans();
        },
      ),
    );
  }

  PopupMenuItem<dynamic> _enterWeight(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.scale),
        title: const Text('Weight'),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EnterWeightPage()),
          );
        },
      ),
    );
  }
}

class _PlanWidget extends StatelessWidget {
  final String searchText;
  final List<Plan> plans;
  final Future<void> Function({List<Plan>? plans}) updatePlans;
  final GlobalKey<NavigatorState> navigatorKey;

  const _PlanWidget({
    required this.plans,
    required this.searchText,
    required this.updatePlans,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    final weekday = weekdays[DateTime.now().weekday - 1];
    final filtered = plans
        .where((element) =>
            element.days.toLowerCase().contains(searchText) ||
            element.exercises.toLowerCase().contains(searchText))
        .toList();

    if (filtered.isEmpty)
      return const ListTile(
        title: Text("No plans yet."),
        subtitle: Text("Tap the plus button in the bottom right to add plans."),
      );

    return Expanded(
      child: ReorderableListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final plan = filtered[index];
          return PlanTile(
            key: Key(plan.id.toString()),
            plan: plan,
            weekday: weekday,
            index: index,
            navigatorKey: navigatorKey,
            refresh: updatePlans,
          );
        },
        onReorder: (int oldIndex, int newIndex) async {
          if (oldIndex < newIndex) {
            newIndex--;
          }

          final temp = plans[oldIndex];
          plans.removeAt(oldIndex);
          plans.insert(newIndex, temp);

          await updatePlans(plans: plans);
          await db.transaction(() async {
            for (int i = 0; i < plans.length; i++) {
              final plan = plans[i];
              final updatedPlan =
                  plan.toCompanion(false).copyWith(sequence: drift.Value(i));
              await db.update(db.plans).replace(updatedPlan);
            }
          });
        },
      ),
    );
  }
}
