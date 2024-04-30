import 'package:flexify/database.dart';
import 'package:flexify/exercise_modal.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseList extends StatelessWidget {
  final List<String> exercises;
  final Future<void> Function() refresh;
  final int selected;
  final Future<void> Function(int) onSelect;
  final Map<String, int> counts;
  final bool firstRender;
  final Plan plan;

  const ExerciseList(
      {super.key,
      required this.exercises,
      required this.refresh,
      required this.selected,
      required this.onSelect,
      required this.counts,
      required this.firstRender,
      required this.plan});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return ReorderableListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final exercise = exercises[index];
          final count = counts[exercise] ?? 0;

          return GestureDetector(
            key: Key(exercise),
            onLongPressStart: (details) async {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ExerciseModal(exercise: exercise, hasData: count > 0);
                },
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  onTap: () => onSelect(index),
                  trailing: Visibility(
                    visible: settings.showReorder,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ReorderableDragStartListener(
                          index: index,
                          child: const Icon(Icons.drag_handle),
                        )
                      ],
                    ),
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
                      Text("$exercise ($count)"),
                    ],
                  ),
                ),
                TweenAnimationBuilder(
                  tween: Tween<double>(
                      begin: (count / settings.maxSets) - 1,
                      end: count / settings.maxSets),
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
        });
  }
}
