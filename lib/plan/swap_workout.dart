import 'package:drift/drift.dart' as drift;
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/database/exercise_key.dart';
import 'package:flexify/graph/add_exercise_page.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';

class SwapWorkout extends StatefulWidget {
  final int planExerciseId;

  const SwapWorkout({super.key, required this.planExerciseId});

  @override
  State<SwapWorkout> createState() => _SwapWorkoutState();
}

class _SwapWorkoutState extends State<SwapWorkout> {
  late Stream<List<({Exercise exercise, String? category})>> _distinctExercises;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Set<int> _unavailableExerciseIds = const {};

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });

    _distinctExercises = watchExerciseCatalogEntries();
    _loadUnavailableExercises();
  }

  Future<void> _loadUnavailableExercises() async {
    final source =
        await (db.planExercises.select()
              ..where((row) => row.id.equals(widget.planExerciseId)))
            .getSingle();
    final enabled =
        await (db.planExercises.select()..where(
              (row) =>
                  row.planId.equals(source.planId) & row.enabled.equals(true),
            ))
            .get();

    if (!mounted) return;
    setState(() {
      _unavailableExerciseIds = enabled
          .where((row) => row.id != source.id)
          .map((row) => row.exerciseId)
          .toSet();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _swapToExercise(Exercise exercise) async {
    final didSwap = await db.transaction(() async {
      final source =
          await (db.planExercises.select()
                ..where((row) => row.id.equals(widget.planExerciseId)))
              .getSingle();
      final existing =
          await (db.planExercises.select()..where(
                (row) =>
                    row.planId.equals(source.planId) &
                    row.exerciseId.equals(exercise.id),
              ))
              .getSingleOrNull();

      if (existing?.id == source.id) return true;
      if (existing?.enabled == true) return false;

      if (existing != null) {
        await (db.planExercises.delete()
              ..where((row) => row.id.equals(existing.id)))
            .go();
      }
      await (db.planExercises.update()
            ..where((row) => row.id.equals(source.id)))
          .write(PlanExercisesCompanion(exerciseId: drift.Value(exercise.id)));
      return true;
    });

    if (!mounted || !didSwap) return;
    Navigator.pop(context, true);
  }

  Future<void> _createAndSwap() async {
    final exercise = await Navigator.of(context).push<Exercise>(
      FlexPageRoute(builder: (context) => AddExercisePage(name: _searchQuery)),
    );
    if (exercise == null || !mounted) return;
    await _swapToExercise(exercise);
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
          ListTile(
            key: const Key('create-swap-exercise'),
            leading: const Icon(Icons.add_rounded),
            title: Text(
              _searchQuery.isEmpty
                  ? context.l10n.addExercise
                  : context.l10n.addNamed(_searchQuery),
            ),
            onTap: _createAndSwap,
          ),
          Expanded(
            child: StreamBuilder<List<({Exercise exercise, String? category})>>(
              stream: _distinctExercises,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(context.l10n.unexpectedError));
                }
                if (!snapshot.hasData) {
                  return const SizedBox();
                }

                final sharedNames = sharedExerciseNames(
                  snapshot.data!.map(
                    (entry) =>
                        (name: entry.exercise.name, category: entry.category),
                  ),
                );
                final exercises = snapshot.data!
                    .where(
                      (entry) =>
                          !_unavailableExerciseIds.contains(
                            entry.exercise.id,
                          ) &&
                          entry.exercise.name.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ),
                    )
                    .toList();

                return ListView.builder(
                  itemCount: exercises.length,
                  itemBuilder: (context, index) {
                    final entry = exercises[index];
                    return ListTile(
                      title: Text(
                        exerciseLabel((
                          name: entry.exercise.name,
                          category: entry.category,
                        ), sharedNames),
                      ),
                      onTap: () => _swapToExercise(entry.exercise),
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
