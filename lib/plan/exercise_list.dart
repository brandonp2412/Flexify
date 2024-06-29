import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/plan/exercise_modal.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/utils.dart';
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

  Widget _itemBuilder(BuildContext context, int index, SettingsState settings) {
    final exercise = exercises[index];
    final countIndex =
        counts?.indexWhere((element) => element.name == exercise);
    var count = 0;
    int max = settings.maxSets;

    if (countIndex != null && countIndex > -1 && counts != null) {
      count = counts![countIndex].count;
      max = counts![countIndex].maxSets ?? settings.maxSets;
    }

    Widget trailing = const SizedBox();
    switch (settings.planTrailing) {
      case PlanTrailing.reorder:
        trailing = ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle),
        );
        break;

      case PlanTrailing.ratio:
        trailing = Text(
          "$count / $max",
          style: const TextStyle(fontSize: 16),
        );
        break;

      case PlanTrailing.count:
        trailing = Text(
          count.toString(),
          style: const TextStyle(fontSize: 16),
        );
        break;

      case PlanTrailing.percent:
        trailing = Text(
          "${(count / max * 100).toStringAsFixed(2)}%",
          style: const TextStyle(fontSize: 16),
        );
        break;

      case PlanTrailing.none:
        trailing = const SizedBox();
        break;
    }

    // Desktop platform automatically puts the trailing reorder button.
    if (platformIsDesktop() && settings.planTrailing == PlanTrailing.reorder)
      trailing = const SizedBox();

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            onTap: () => onSelect(index),
            trailing: trailing,
            title: Row(
              children: [
                Radio(
                  value: index == selected,
                  groupValue: true,
                  onChanged: (value) {
                    onSelect(index);
                  },
                ),
                Flexible(child: Text(exercise)),
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
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    if (settings.planTrailing == PlanTrailing.reorder)
      return ReorderableListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) => _itemBuilder(context, index, settings),
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
    else
      return ListView.builder(
        itemCount: exercises.length,
        itemBuilder: (context, index) => _itemBuilder(context, index, settings),
      );
  }
}
