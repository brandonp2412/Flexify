import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:flexify/exercise_tile.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

class ExerciseList extends StatelessWidget {
  final List<String> planExercises;
  final AsyncSnapshot<List<TypedResult>> snapshot;
  final int selectedIndex;
  final Function(int) onTap;

  const ExerciseList({
    Key? key,
    required this.planExercises,
    required this.snapshot,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: planExercises.length,
      itemBuilder: (context, index) {
        final exercise = planExercises[index];
        final gymSet = snapshot.data?.firstWhereOrNull(
          (element) => element.read(database.gymSets.name) == exercise,
        );
        var count = 0;
        if (gymSet != null) count = gymSet.read(database.gymSets.name.count())!;
        return ExerciseTile(
          index: index,
          exercise: exercise,
          isSelected: index == selectedIndex,
          count: count,
          onTap: () => onTap(index),
          key: Key(exercise),
        );
      },
    );
  }
}
