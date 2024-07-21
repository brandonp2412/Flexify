import 'package:flexify/constants.dart';
import 'package:flexify/custom_set_indicator.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/exercise_modal.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseList extends StatelessWidget {
  final List<String> exercises;
  final int selected;
  final Future<void> Function(int) onSelect;
  final List<GymCount>? counts;
  final bool firstRender;
  final Plan plan;

  const ExerciseList({
    super.key,
    required this.exercises,
    required this.selected,
    required this.onSelect,
    required this.counts,
    required this.firstRender,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    final maxSets = context
        .select<SettingsState, int>((settings) => settings.value.maxSets);
    final planTrailing = context.select<SettingsState, PlanTrailing>(
      (settings) => PlanTrailing.values.byName(
        settings.value.planTrailing.replaceFirst('PlanTrailing.', ''),
      ),
    );

    if (planTrailing == PlanTrailing.reorder)
      return ReorderableListView.builder(
        itemCount: exercises.length + 1,
        itemBuilder: (context, index) =>
            itemBuilder(context, index, maxSets, planTrailing),
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
          if (!context.mounted) return;
          final planState = context.read<PlanState>();
          planState.updatePlans(null);
        },
      );
    else
      return ListView.builder(
        itemCount: exercises.length + 1,
        itemBuilder: (context, index) =>
            itemBuilder(context, index, maxSets, planTrailing),
      );
  }

  Widget itemBuilder(
    BuildContext context,
    int index,
    int maxSets,
    PlanTrailing planTrailing,
  ) {
    if (index >= exercises.length)
      return const SizedBox(
        height: 76,
        key: Key('scroll-placeholder'),
      );
    final exercise = exercises[index];
    final countIndex =
        counts?.indexWhere((element) => element.name == exercise);
    var count = 0;
    int max = maxSets;

    if (countIndex != null && countIndex > -1 && counts != null) {
      count = counts![countIndex].count;
      max = counts![countIndex].maxSets ?? maxSets;
    }

    Widget trailing = const SizedBox();
    switch (planTrailing) {
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
    if (platformIsDesktop() && planTrailing == PlanTrailing.reorder)
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
          CustomSetIndicator(count: count, max: max, firstRender: firstRender),
        ],
      ),
    );
  }
}
