import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/app_search.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/edit_graph_page.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'graph_tile.dart';

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  createState() => GraphsPageState();
}

class GraphsPageState extends State<GraphsPage> {
  late final Stream<List<GymSetsCompanion>> _stream = watchGraphs();

  final Set<String> _selected = {};
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String _search = '';

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
          builder: (context) => _graphsPage(),
          settings: settings,
        ),
      ),
    );
  }

  Scaffold _graphsPage() {
    return Scaffold(
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          if (snapshot.hasError) return ErrorWidget(snapshot.error.toString());

          final gymSets = snapshot.data!.where((gymSet) {
            final name = gymSet.name.value.toLowerCase();
            final searchText = _search.toLowerCase();
            return name.contains(searchText);
          }).toList();

          return material.Column(
            children: [
              AppSearch(
                onShare: () async {
                  final selected = _selected.toList();
                  setState(() {
                    _selected.clear();
                  });
                  final gymSets = (await _stream.first)
                      .where(
                        (gymSet) => selected.contains(gymSet.name.value),
                      )
                      .toList();
                  final summaries = gymSets
                      .map(
                        (gymSet) =>
                            "${toString(gymSet.reps.value)}x${toString(gymSet.weight.value)}${gymSet.unit.value} ${gymSet.name.value}",
                      )
                      .join(', ');
                  await Share.share("I just did $summaries");
                },
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

                  await (db.delete(db.gymSets)
                        ..where((tbl) => tbl.name.isIn(selectedCopy)))
                      .go();

                  final plans = await db.plans.select().get();
                  for (final plan in plans) {
                    final exercises = plan.exercises.split(',');
                    exercises.removeWhere(
                      (exercise) => selectedCopy.contains(exercise),
                    );
                    final updatedExercises = exercises.join(',');
                    await db
                        .update(db.plans)
                        .replace(plan.copyWith(exercises: updatedExercises));
                  }
                  planState.updatePlans(null);
                },
                onSelect: () => setState(() {
                  _selected.addAll(
                    gymSets.map((gymSet) => gymSet.name.value),
                  );
                }),
                selected: _selected,
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditGraphPage(
                      name: _selected.first,
                    ),
                  ),
                ),
              ),
              if (snapshot.data?.isEmpty == true)
                const ListTile(
                  title: Text("No data yet."),
                  subtitle: Text(
                    "Complete plans for your progress graphs to appear here.",
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: gymSets.length,
                  itemBuilder: (context, index) {
                    final gymSet = gymSets[index];
                    final previousGymSet =
                        index > 0 ? gymSets[index - 1] : null;

                    final previousCreated =
                        previousGymSet?.created.value.toLocal();

                    final showDivider = previousCreated != null &&
                        !isSameDay(previousCreated, gymSet.created.value);

                    return material.Column(
                      children: [
                        if (showDivider) const Divider(),
                        GraphTile(
                          selected: _selected,
                          gymSet: gymSet,
                          onSelect: (name) {
                            if (_selected.contains(name))
                              setState(() {
                                _selected.remove(name);
                              });
                            else
                              setState(() {
                                _selected.add(name);
                              });
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
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
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
