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
    super.key,
    required this.planExercises,
    required this.snapshot,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: planExercises.length,
      itemBuilder: (context, index) {
        final exercise = planExercises[index];
        final gymSetIndex = snapshot.data?.indexWhere(
          (element) => element.read(db.gymSets.name) == exercise,
        );
        var count = 0;
        if (gymSetIndex != -1)
          count = snapshot.data![gymSetIndex!].read(db.gymSets.name.count())!;
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
