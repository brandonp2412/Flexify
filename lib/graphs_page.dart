import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart';
import 'package:flexify/add_exercise_page.dart';
import 'package:flexify/app_search.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'graph_tile.dart';

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  createState() => GraphsPageState();
}

class GraphsPageState extends State<GraphsPage> {
  late Stream<List<drift.TypedResult>> _stream;

  final Set<String> _selected = {};
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  String _search = '';

  @override
  void initState() {
    super.initState();

    _stream = (db.gymSets.selectOnly()
          ..addColumns([
            db.gymSets.name,
            db.gymSets.unit,
            db.gymSets.weight,
            db.gymSets.reps,
            db.gymSets.cardio,
            db.gymSets.duration,
            db.gymSets.distance,
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
      body: StreamBuilder<List<drift.TypedResult>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          if (snapshot.hasError) return ErrorWidget(snapshot.error.toString());

          final gymSets = snapshot.data!.where((gymSet) {
            final name = gymSet.read(db.gymSets.name)!.toLowerCase();
            final searchText = _search.toLowerCase();
            return name.contains(searchText);
          }).toList();

          return material.Column(
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
                onSelect: () => setState(() {
                  _selected.addAll(
                      gymSets.map((gymSet) => gymSet.read(db.gymSets.name)!));
                }),
                selected: _selected,
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditGraphPage(
                            name: _selected.first,
                          )),
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
                  itemCount: gymSets.length,
                  itemBuilder: (context, index) {
                    final gymSet = gymSets[index];
                    final previousGymSet =
                        index > 0 ? gymSets[index - 1] : null;

                    final name = gymSet.read(db.gymSets.name)!;
                    final weight = gymSet.read(db.gymSets.weight)!;
                    final unit = gymSet.read(db.gymSets.unit)!;
                    final reps = gymSet.read(db.gymSets.reps)!;
                    final cardio = gymSet.read(db.gymSets.cardio)!;
                    final duration = gymSet.read(db.gymSets.duration)!;
                    final distance = gymSet.read(db.gymSets.distance)!;
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
                          cardio: cardio,
                          duration: duration,
                          distance: distance,
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
}
