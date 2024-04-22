import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart';
import 'package:flexify/add_exercise_page.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/enter_weight_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan_state.dart';
import 'package:flexify/settings_page.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'graph_tile.dart';

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  Stream<List<drift.TypedResult>>? _stream;
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();

    _stream = (db.gymSets.selectOnly()
          ..addColumns([
            db.gymSets.name,
            db.gymSets.unit,
            db.gymSets.weight,
            db.gymSets.reps,
            db.gymSets.created.max()
          ])
          ..orderBy([
            drift.OrderingTerm(
                expression: db.gymSets.created.max(),
                mode: drift.OrderingMode.desc)
          ])
          ..groupBy([db.gymSets.name]))
        .watch();
  }

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
          builder: (context) => _graphsPage(),
          settings: settings,
        ),
      ),
    );
  }

  Scaffold _graphsPage() {
    return Scaffold(
      body: StreamBuilder<List<drift.TypedResult>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          if (snapshot.hasError) return ErrorWidget(snapshot.error.toString());
          final gymSets = snapshot.data!;

          final filteredGymSets = gymSets.where((gymSet) {
            final name = gymSet.read(db.gymSets.name)!.toLowerCase();
            final searchText = _searchController.text.toLowerCase();
            return name.contains(searchText);
          }).toList();

          PopupMenuItem<dynamic> selectAll(BuildContext context) {
            return PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.done_all),
                title: const Text('Select all'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final names =
                      filteredGymSets.map((e) => e.read(db.gymSets.name)!);
                  setState(() {
                    _selected.addAll(names);
                  });
                },
              ),
            );
          }

          return material.Column(
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
                    if (_selected.isNotEmpty) _deleteGraphs(context),
                    if (_selected.length == 1) _editGraph(context),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        selectAll(context),
                        if (_selected.isNotEmpty) _clear(context),
                        if (_selected.isEmpty) _enterWeight(context),
                        if (_selected.isEmpty) _settingsPage(context)
                      ],
                    ),
                  ],
                ),
              ),
              if (snapshot.data?.isEmpty == true)
                const ListTile(
                  title: Text("No data yet."),
                  subtitle: Text(
                      "Complete plans for your progress graphs to appear here."),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredGymSets.length,
                  itemBuilder: (context, index) {
                    final gymSet = filteredGymSets[index];
                    final previousGymSet =
                        index > 0 ? filteredGymSets[index - 1] : null;

                    final name = gymSet.read(db.gymSets.name)!;
                    final weight = gymSet.read(db.gymSets.weight)!;
                    final unit = gymSet.read(db.gymSets.unit)!;
                    final reps = gymSet.read(db.gymSets.reps)!;
                    final created = gymSet.read(db.gymSets.created.max())!;
                    final previousCreated =
                        previousGymSet?.read(db.gymSets.created.max())!;

                    final showDivider = previousCreated != null &&
                        !isSameDay(previousCreated, created);

                    return material.Column(
                      children: [
                        if (showDivider) const Divider(),
                        GraphTile(
                          selected: _selected,
                          name: name,
                          weight: weight,
                          unit: unit,
                          reps: reps,
                          created: created,
                          onSelect: (value) {
                            if (_selected.contains(value))
                              setState(() {
                                _selected.remove(value);
                              });
                            else
                              setState(() {
                                _selected.add(value);
                              });
                          },
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddExercisePage(),
            ),
          );
        },
        tooltip: 'Add exercise',
        child: const Icon(Icons.add),
      ),
    );
  }

  IconButton _deleteGraphs(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: Text(
                  'Are you sure you want to delete ${_selected.length} graphs? This action is not reversible.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Delete'),
                  onPressed: () async {
                    final planState = context.read<PlanState>();
                    final selectedCopy = _selected.toList();
                    Navigator.of(context).pop();
                    setState(() {
                      _selected.clear();
                    });

                    await (db.delete(db.gymSets)
                          ..where((tbl) => tbl.name.isIn(selectedCopy)))
                        .go();
                    final plans = await db.plans.select().get();
                    for (final plan in plans) {
                      final exercises = plan.exercises.split(',');
                      exercises.removeWhere(
                          (exercise) => selectedCopy.contains(exercise));
                      final updatedExercises = exercises.join(',');
                      await db
                          .update(db.plans)
                          .replace(plan.copyWith(exercises: updatedExercises));
                    }
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

  IconButton _editGraph(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      tooltip: 'Edit graph',
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditGraphPage(
                    name: _selected.first,
                  )),
        );
      },
    );
  }

  PopupMenuItem<dynamic> _settingsPage(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        },
      ),
    );
  }

  PopupMenuItem<dynamic> _enterWeight(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.scale),
        title: const Text('Enter weight'),
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

  PopupMenuItem<dynamic> _clear(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.clear),
        title: const Text('Clear'),
        onTap: () async {
          Navigator.of(context).pop();
          setState(() {
            _selected.clear();
          });
        },
      ),
    );
  }
}
