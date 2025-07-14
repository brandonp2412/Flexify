import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/custom_set_indicator.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/exercise_modal.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartList extends StatefulWidget {
  final List<String> exercises;
  final int selected;
  final Future<void> Function(int) onSelect;
  final Function() onMax;
  final Plan plan;

  const StartList({
    super.key,
    required this.exercises,
    required this.selected,
    required this.onSelect,
    required this.plan,
    required this.onMax,
  });

  @override
  State<StartList> createState() => _StartListState();
}

typedef Tapped = ({
  int index,
  DateTime dateTime,
});

class _StartListState extends State<StartList> {
  Tapped lastTap = (index: 0, dateTime: DateTime(0));

  void tap(int index) async {
    widget.onSelect(index);

    if (DateTime.now().difference(lastTap.dateTime) >=
            const Duration(milliseconds: 300) ||
        index != lastTap.index)
      return setState(() {
        lastTap = (index: index, dateTime: DateTime.now());
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
    final max = context
        .select<SettingsState, int>((settings) => settings.value.maxSets);
    final trailing = context.select<SettingsState, PlanTrailing>(
      (settings) => PlanTrailing.values.byName(
        settings.value.planTrailing.replaceFirst('PlanTrailing.', ''),
      ),
    );
    final state = context.watch<PlanState>();
    final counts = state.gymCounts;

    if (trailing == PlanTrailing.reorder)
      return ReorderableListView.builder(
        itemCount: widget.exercises.length,
        padding: const EdgeInsets.only(bottom: 76),
        itemBuilder: (context, index) =>
            itemBuilder(context, index, max, trailing, counts),
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
          final state = context.read<PlanState>();
          state.updatePlans(null);
        },
      );
    else
      return ListView.builder(
        padding: const EdgeInsets.only(bottom: 76),
        itemCount: widget.exercises.length,
        itemBuilder: (context, index) =>
            itemBuilder(context, index, max, trailing, counts),
      );
  }

  Widget itemBuilder(
    BuildContext context,
    int index,
    int maxSets,
    PlanTrailing trailing,
    List<GymCount> counts,
  ) {
    final exercise = widget.exercises[index];
    final idx = counts.indexWhere((element) => element.name == exercise);
    var count = 0;
    int max = maxSets;

    if (idx > -1) {
      count = counts[idx].count;
      max = counts[idx].maxSets ?? maxSets;
    }

    Widget trail = const SizedBox();
    switch (trailing) {
      case PlanTrailing.reorder:
        trail = ReorderableDragStartListener(
          index: index,
          child: const Icon(
            Icons.drag_handle,
            size: 32,
          ),
        );
        break;

      case PlanTrailing.ratio:
        trail = Text(
          "$count / $max",
          style: const TextStyle(fontSize: 16),
        );
        break;

      case PlanTrailing.count:
        trail = Text(
          count.toString(),
          style: const TextStyle(fontSize: 16),
        );
        break;

      case PlanTrailing.percent:
        trail = Text(
          "${(count / max * 100).toStringAsFixed(2)}%",
          style: const TextStyle(fontSize: 16),
        );
        break;

      case PlanTrailing.none:
        trail = const SizedBox();
        break;
    }

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
            trailing: trail,
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
