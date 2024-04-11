import 'package:flexify/exercise_tile.dart';
import 'package:flutter/material.dart';

class ExerciseList extends StatelessWidget {
  final List<String> planExercises;
  final Map<String, int> counts;
  final int selectedIndex;
  final Function(int) selectAllReps;
  final Function(int, int) onReorder;
  final bool first;

  const ExerciseList({
    super.key,
    required this.planExercises,
    required this.selectedIndex,
    required this.selectAllReps,
    required this.onReorder,
    required this.counts,
    required this.first,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: planExercises.length,
      itemBuilder: (context, index) {
        final exercise = planExercises[index];
        final count = counts[exercise] ?? 0;

        return ExerciseTile(
          first: first,
          index: index,
          exercise: exercise,
          isSelected: index == selectedIndex,
          count: count,
          selectAllReps: () => selectAllReps(index),
          key: Key(exercise),
        );
      },
      onReorder: onReorder,
    );
  }
}
