import 'package:drift/drift.dart' as drift;
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SwapWorkout extends StatefulWidget {
  final String exercise;
  final int planId;

  const SwapWorkout({super.key, required this.exercise, required this.planId});

  @override
  State<SwapWorkout> createState() => _SwapWorkoutState();
}

class _SwapWorkoutState extends State<SwapWorkout> {
  late Stream<List<String>> _distinctExercises;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });

    _distinctExercises = (db.gymSets.selectOnly(distinct: true)
          ..addColumns([db.gymSets.name])
          ..orderBy([
            drift.OrderingTerm(expression: db.gymSets.name),
          ]))
        .map((row) => row.read(db.gymSets.name)!)
        .watch()
        .map((event) => event.where((name) => name.isNotEmpty).toList());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PlanState>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Swap workout'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Exercises',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: _distinctExercises,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final exercises = snapshot.data!
                    .where(
                      (name) => name
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()),
                    )
                    .toList();

                return ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return ListTile(
                      title: Text(exercise),
                      onTap: () async {
                        await (db.planExercises.update()
                              ..where(
                                (tbl) =>
                                    tbl.planId.equals(widget.planId) &
                                    tbl.exercise.equals(widget.exercise),
                              ))
                            .write(
                          const PlanExercisesCompanion(
                            enabled: drift.Value(false),
                          ),
                        );

                        await (db.planExercises.update()
                              ..where(
                                (tbl) =>
                                    tbl.planId.equals(widget.planId) &
                                    tbl.exercise.equals(exercise),
                              ))
                            .write(
                          const PlanExercisesCompanion(
                            enabled: drift.Value(true),
                          ),
                        );

                        final plan = await (db.plans.select()
                              ..where((tbl) => tbl.id.equals(widget.planId)))
                            .getSingle();

                        late List<String> exercisesList;
                        await state.setExercises(plan.toCompanion(false));
                        exercisesList = state.exercises
                            .where((pe) => pe.enabled.value)
                            .map((exercise) => exercise.exercise.value)
                            .toList();
                        final oldExerciseIndex =
                            exercisesList.indexOf(widget.exercise);

                        if (oldExerciseIndex != -1) {
                          exercisesList[oldExerciseIndex] = exercise;
                        }

                        final newExercisesString = exercisesList.join(',');

                        await (db.plans.update()
                              ..where((tbl) => tbl.id.equals(widget.planId)))
                            .write(
                          PlansCompanion(
                            exercises: drift.Value(newExercisesString),
                          ),
                        );

                        if (!context.mounted) return;

                        state.updatePlans(null);
                        Navigator.pop(context, true);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
