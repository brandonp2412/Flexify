import 'package:drift/drift.dart' as drift;
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

class SwapWorkout extends StatefulWidget {
  final String exercise;
  final String? category;
  final int planId;

  const SwapWorkout({
    super.key,
    required this.exercise,
    this.category,
    required this.planId,
  });

  @override
  State<SwapWorkout> createState() => _SwapWorkoutState();
}

class _SwapWorkoutState extends State<SwapWorkout> {
  late Stream<List<ExerciseKey>> _distinctExercises;
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

    _distinctExercises =
        (db.gymSets.selectOnly(distinct: true)
              ..addColumns([db.gymSets.name, db.gymSets.category])
              ..orderBy([
                drift.OrderingTerm(expression: db.gymSets.name),
                drift.OrderingTerm(expression: db.gymSets.category),
              ]))
            .map(
              (row) => (
                name: row.read(db.gymSets.name)!,
                category: row.read(db.gymSets.category),
              ),
            )
            .watch()
            .map(
              (event) =>
                  event.where((exercise) => exercise.name.isNotEmpty).toList(),
            );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text(context.l10n.swapWorkout)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: context.l10n.searchExercises,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<ExerciseKey>>(
              stream: _distinctExercises,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(context.l10n.unexpectedError));
                }
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final query = _searchQuery.toLowerCase();
                final exercises = snapshot.data!
                    .where(
                      (exercise) =>
                          exercise.name.toLowerCase().contains(query) ||
                          exercise.category?.toLowerCase().contains(query) ==
                              true,
                    )
                    .toList();

                return ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return ListTile(
                      title: Text(exercise.name),
                      subtitle: Text(
                        categoryLabel(context.l10n, exercise.category),
                      ),
                      onTap: () async {
                        final old =
                            await (db.planExercises.select()
                                  ..where(
                                    (tbl) =>
                                        tbl.planId.equals(widget.planId) &
                                        isPlannedExercise(
                                          tbl,
                                          widget.exercise,
                                          widget.category,
                                        ),
                                  )
                                  ..limit(1))
                                .getSingle();
                        await (db.planExercises.update()
                              ..where((tbl) => tbl.id.equals(old.id)))
                            .write(
                              PlanExercisesCompanion(
                                exercise: drift.Value(exercise.name),
                                category: drift.Value(exercise.category),
                              ),
                            );

                        if (!context.mounted) return;
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
