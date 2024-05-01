import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flexify/database.dart';
import 'package:flexify/edit_plan_page.dart';
import 'package:flexify/enter_weight_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan_state.dart';
import 'package:flexify/plans_list.dart';
import 'package:flexify/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final Set<int> _selected = {};

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
            element.days.toLowerCase().contains(_searchController.text) ||
            element.exercises.toLowerCase().contains(_searchController.text))
        .toList();

    PopupMenuItem<dynamic> selectAll(BuildContext context) {
      return PopupMenuItem(
        child: ListTile(
          leading: const Icon(Icons.done_all),
          title: const Text('Select all'),
          onTap: () async {
            Navigator.pop(context);
            final ids = filtered?.map((e) => e.id);
            if (ids == null) return;

            setState(() {
              _selected.addAll(ids);
            });
          },
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              hintText: _selected.isEmpty
                  ? "Search..."
                  : "${_selected.length} selected",
              controller: _searchController,
              padding: MaterialStateProperty.all(
                const EdgeInsets.only(right: 8.0),
              ),
              onChanged: (_) {
                setState(() {});
              },
              leading: _selected.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 8.0),
                      child: Icon(Icons.search))
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _selected.clear();
                        });
                      },
                      icon: const Icon(Icons.arrow_back),
                      padding: EdgeInsets.zero,
                    ),
              trailing: [
                if (_selected.isNotEmpty) _deletePlans(context),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  itemBuilder: (context) => [
                    selectAll(context),
                    if (_selected.isNotEmpty) _edit(context),
                    if (_selected.isNotEmpty) _clear(context),
                    if (_selected.isEmpty) _enterWeight(context),
                    if (_selected.isEmpty) _settingsPage(context)
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: PlansList(
              plans: filtered ?? [],
              searchText: _searchController.text,
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

  PopupMenuItem<dynamic> _settingsPage(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () async {
          Navigator.pop(context);
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
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EnterWeightPage()),
          );
        },
      ),
    );
  }

  IconButton _deletePlans(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: Text(
                  'Are you sure you want to delete ${_selected.length} plans? This action is not reversible.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () async {
                    final planState = context.read<PlanState>();
                    final selectedCopy = _selected.toList();
                    Navigator.pop(context);

                    setState(() {
                      _selected.clear();
                    });

                    await db.plans
                        .deleteWhere((tbl) => tbl.id.isIn(selectedCopy));
                    planState.updatePlans(null);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  PopupMenuItem<dynamic> _edit(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.edit),
        title: const Text('Edit'),
        onTap: () async {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditPlanPage(
                      plan: _planState!.plans
                          .firstWhere(
                              (element) => element.id == _selected.first)
                          .toCompanion(false),
                    )),
          );
        },
      ),
    );
  }

  PopupMenuItem<dynamic> _clear(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.clear),
        title: const Text('Clear'),
        onTap: () async {
          Navigator.pop(context);
          setState(() {
            _selected.clear();
          });
        },
      ),
    );
  }
}
