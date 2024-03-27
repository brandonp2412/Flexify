import 'package:flexify/exercise_tile.dart';
import 'package:flutter/material.dart';

class ExerciseList extends StatelessWidget {
  final List<String> planExercises;
  final Map<String, int> counts;
  final int selectedIndex;
  final Function(int) onTap;
  final Function(int, int) onReorder;

  const ExerciseList({
    super.key,
    required this.planExercises,
    required this.selectedIndex,
    required this.onTap,
    required this.onReorder,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: planExercises.length,
      itemBuilder: (context, index) {
        final exercise = planExercises[index];
        final count = counts[exercise] ?? 0;

        return ExerciseTile(
          index: index,
          exercise: exercise,
          isSelected: index == selectedIndex,
          count: count,
          onTap: () => onTap(index),
          key: Key(exercise),
        );
      },
      onReorder: onReorder,
    );
  }
}
