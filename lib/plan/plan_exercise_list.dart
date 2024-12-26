import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/custom_set_indicator.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/exercise_modal.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanExerciseList extends StatefulWidget {
  final List<String> exercises;
  final int selected;
  final Future<void> Function(int) onSelect;
  final Function() onMax;
  final Plan plan;

  const PlanExerciseList({
    super.key,
    required this.exercises,
    required this.selected,
    required this.onSelect,
    required this.plan,
    required this.onMax,
  });

  @override
  State<PlanExerciseList> createState() => _PlanExerciseListState();
}

class _PlanExerciseListState extends State<PlanExerciseList> {
  DateTime lastTap = DateTime(0);

  void tap(int index) async {
    widget.onSelect(index);

    if (DateTime.now().difference(lastTap) >= const Duration(milliseconds: 300))
      return setState(() {
        lastTap = DateTime.now();
      });

    final gymSet = await (db.gymSets.select()
          ..where((tbl) => tbl.name.equals(widget.exercises[index]))
          ..orderBy(
            [
              (u) =>
                  OrderingTerm(expression: u.created, mode: OrderingMode.desc),
            ],
          )
          ..limit(1))
        .getSingle();
    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EditSetPage(gymSet: gymSet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxSets = context
        .select<SettingsState, int>((settings) => settings.value.maxSets);
    final planTrailing = context.select<SettingsState, PlanTrailing>(
      (settings) => PlanTrailing.values.byName(
        settings.value.planTrailing.replaceFirst('PlanTrailing.', ''),
      ),
    );
    final planState = context.watch<PlanState>();
    final counts = planState.gymCounts;

    if (planTrailing == PlanTrailing.reorder)
      return ReorderableListView.builder(
        itemCount: widget.exercises.length,
        padding: const EdgeInsets.only(bottom: 76),
        itemBuilder: (context, index) =>
            itemBuilder(context, index, maxSets, planTrailing, counts),
        onReorder: (oldIndex, newIndex) async {
          if (oldIndex < newIndex) {
            newIndex--;
          }

          final temp = widget.exercises[oldIndex];
          widget.exercises.removeAt(oldIndex);
          widget.exercises.insert(newIndex, temp);
          await db.update(db.plans).replace(
                widget.plan.copyWith(exercises: widget.exercises.join(',')),
              );
          if (!context.mounted) return;
          final planState = context.read<PlanState>();
          planState.updatePlans(null);
        },
      );
    else
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 76),
        itemCount: widget.exercises.length,
        itemBuilder: (context, index) =>
            itemBuilder(context, index, maxSets, planTrailing, counts),
      );
  }

  Widget itemBuilder(
    BuildContext context,
    int index,
    int maxSets,
    PlanTrailing planTrailing,
    List<GymCount> counts,
  ) {
    final exercise = widget.exercises[index];
    final countIndex = counts.indexWhere((element) => element.name == exercise);
    var count = 0;
    int max = maxSets;

    if (countIndex > -1) {
      count = counts[countIndex].count;
      max = counts[countIndex].maxSets ?? maxSets;
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
              planId: widget.plan.id,
              exercise: exercise,
              hasData: count > 0,
              onSelect: () => widget.onSelect(index),
              onMax: widget.onMax,
            );
          },
        );
      },
      child: material.Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            onTap: () => tap(index),
            trailing: trailing,
            title: Row(
              children: [
                Radio(
                  value: index == widget.selected,
                  groupValue: true,
                  onChanged: (value) {
                    widget.onSelect(index);
                  },
                ),
                Flexible(child: Text(exercise)),
              ],
            ),
          ),
          CustomSetIndicator(count: count, max: max),
        ],
      ),
    );
  }
}
