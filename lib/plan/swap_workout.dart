import 'package:drift/drift.dart' as drift;
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

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

    _distinctExercises =
        (db.gymSets.selectOnly(distinct: true)
              ..addColumns([db.gymSets.name])
              ..orderBy([drift.OrderingTerm(expression: db.gymSets.name)]))
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
            child: StreamBuilder<List<String>>(
              stream: _distinctExercises,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      context.l10n.errorWithMessage('${snapshot.error}'),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final exercises = snapshot.data!
                    .where(
                      (name) => name.toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      ),
                    )
                    .toList();

                return ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = exercises[index];
                    return ListTile(
                      title: Text(exercise),
                      onTap: () async {
                        final old =
                            await (db.planExercises.select()
                                  ..where(
                                    (tbl) =>
                                        tbl.planId.equals(widget.planId) &
                                        tbl.exercise.equals(widget.exercise),
                                  )
                                  ..limit(1))
                                .getSingle();
                        await (db.planExercises.update()
                              ..where((tbl) => tbl.id.equals(old.id)))
                            .write(
                              PlanExercisesCompanion(
                                exercise: drift.Value(exercise),
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
