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

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swap Workout'),
      ),
      body: StreamBuilder<List<String>>(
        stream: _distinctExercises,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final exercises = snapshot.data!;
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
                    PlanExercisesCompanion(
                      exercise: drift.Value(exercise),
                    ),
                  );

                  final updatedPlanExercises = await (db.planExercises.select()
                        ..where(
                          (tbl) =>
                              tbl.planId.equals(widget.planId) &
                              tbl.enabled.equals(true),
                        ))
                      .get();

                  final newExercisesString =
                      updatedPlanExercises.map((pe) => pe.exercise).join(',');

                  await (db.plans.update()
                        ..where((tbl) => tbl.id.equals(widget.planId)))
                      .write(
                    PlansCompanion(
                      exercises: drift.Value(newExercisesString),
                    ),
                  );

                  if (!context.mounted) return;

                  final state = context.read<PlanState>();
                  state.updatePlans(null);
                  Navigator.pop(context, true);
                },
              );
            },
          );
        },
      ),
    );
  }
}
