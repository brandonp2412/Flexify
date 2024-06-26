import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/plan/exercise_modal.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseList extends StatelessWidget {
  final List<String> exercises;
  final Future<void> Function() refresh;
  final int selected;
  final Future<void> Function(int) onSelect;
  final List<GymCount>? counts;
  final bool firstRender;
  final Plan plan;

  const ExerciseList({
    super.key,
    required this.exercises,
    required this.refresh,
    required this.selected,
    required this.onSelect,
    required this.counts,
    required this.firstRender,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return ReorderableListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        final countIndex =
            counts?.indexWhere((element) => element.name == exercise);
        var count = 0;
        int max = settings.maxSets;

        if (countIndex != null && countIndex > -1 && counts != null) {
          count = counts![countIndex].count;
          max = counts![countIndex].maxSets ?? settings.maxSets;
        }

        return GestureDetector(
          key: Key(exercise),
          onLongPressStart: (details) async {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return ExerciseModal(
                  exercise: exercise,
                  hasData: count > 0,
                  onSelect: () => onSelect(index),
                );
              },
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                onTap: () => onSelect(index),
                trailing: Builder(
                  builder: (context) {
                    switch (settings.planTrailing) {
                      case PlanTrailing.reorder:
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ReorderableDragStartListener(
                              index: index,
                              child: const Icon(Icons.drag_handle),
                            ),
                          ],
                        );

                      case PlanTrailing.ratio:
                        return Text(
                          "$count / $max",
                          style: const TextStyle(fontSize: 16),
                        );

                      case PlanTrailing.count:
                        return Text(
                          count.toString(),
                          style: const TextStyle(fontSize: 16),
                        );

                      case PlanTrailing.percent:
                        return Text(
                          "${(count / max * 100).toStringAsFixed(2)}%",
                          style: const TextStyle(fontSize: 16),
                        );

                      case PlanTrailing.none:
                        return const SizedBox();
                    }
                  },
                ),
                title: Row(
                  children: [
                    Radio(
                      value: index == selected,
                      groupValue: true,
                      onChanged: (value) {
                        onSelect(index);
                      },
                    ),
                    Text(exercise),
                  ],
                ),
              ),
              TweenAnimationBuilder(
                tween: Tween<double>(
                  begin: (count / max) - 1,
                  end: count / max,
                ),
                duration: Duration(milliseconds: firstRender ? 0 : 150),
                builder: (context, value, child) => LinearProgressIndicator(
                  value: value,
                ),
              ),
            ],
          ),
        );
      },
      onReorder: (oldIndex, newIndex) async {
        if (oldIndex < newIndex) {
          newIndex--;
        }

        final temp = exercises[oldIndex];
        exercises.removeAt(oldIndex);
        exercises.insert(newIndex, temp);
        await db
            .update(db.plans)
            .replace(plan.copyWith(exercises: exercises.join(',')));
        refresh();
      },
    );
  }
}
