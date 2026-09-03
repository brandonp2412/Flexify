import 'package:drift/drift.dart' hide Column;
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/custom_set_indicator.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/exercise_modal.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartList extends StatefulWidget {
  final List<PlanExercise> exercises;
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

typedef Tapped = ({int index, DateTime dateTime});

class _StartListState extends State<StartList> {
  // bottomNavHeight clears the FAB; the extra 80 clears the SessionSets
  // chip row that renders above this list on the currently selected
  // exercise.
  static const _bottomPadding = bottomNavHeight + 80.0;

  Tapped lastTap = (index: 0, dateTime: DateTime(0));

  void tap(int index, List<GymCount> counts) async {
    widget.onSelect(index);
    final count = counts.elementAtOrNull(index);
    if (count == null) return;
    if (counts.elementAtOrNull(index)?.count == 0) return;

    if (DateTime.now().difference(lastTap.dateTime) >=
            const Duration(milliseconds: 300) ||
        index != lastTap.index)
      return setState(() {
        lastTap = (index: index, dateTime: DateTime.now());
      });

    final gymSet =
        await (db.gymSets.select()
              ..where(
                (tbl) => tbl.name.equals(widget.exercises[index].exercise),
              )
              ..orderBy([
                (u) => OrderingTerm(
                  expression: u.created,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(1))
            .getSingle();
    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EditSetPage(gymSet: gymSet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final max = context.select<SettingsState, int>(
      (settings) => settings.value.maxSets,
    );
    final trailing = context.select<SettingsState, PlanTrailing>(
      (settings) => PlanTrailing.values.byName(
        settings.value.planTrailing.replaceFirst('PlanTrailing.', ''),
      ),
    );
    final state = context.watch<PlanState>();
    final counts = state.gymCounts;
    final desktop = isDesktopLayout(context);

    if (trailing == PlanTrailing.reorder)
      return ReorderableListView.builder(
        itemCount: widget.exercises.length,
        buildDefaultDragHandles: !desktop,
        padding: EdgeInsets.only(bottom: desktop ? 24 : _bottomPadding),
        itemBuilder: (context, index) =>
            itemBuilder(context, index, max, trailing, counts),
        onReorderItem: (oldIndex, newIndex) async {
          final item = widget.exercises.removeAt(oldIndex);
          widget.exercises.insert(newIndex, item);

          await db.batch((batch) {
            for (var i = 0; i < widget.exercises.length; i++) {
              batch.update(
                db.planExercises,
                PlanExercisesCompanion(sequence: Value(i)),
                where: (pe) => pe.id.equals(widget.exercises[i].id),
              );
            }
          });

          if (!context.mounted) return;
          final state = context.read<PlanState>();
          state.setExercises(widget.plan.toCompanion(false));
          state.updatePlans(null);
        },
      );
    else
      return ListView.builder(
        padding: EdgeInsets.only(bottom: desktop ? 24 : _bottomPadding),
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
    final idx = counts.indexWhere(
      (element) => element.name == exercise.exercise,
    );
    var count = 0;
    int max = maxSets;

    if (idx > -1) {
      count = counts[idx].count;
      max = counts[idx].maxSets ?? maxSets;
    }

    final desktop = isDesktopLayout(context);
    Widget trail = const SizedBox();
    switch (trailing) {
      case PlanTrailing.reorder:
        trail = ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle, size: 32),
        );
        break;

      case PlanTrailing.ratio:
        trail = Text("$count / $max", style: const TextStyle(fontSize: 16));
        break;

      case PlanTrailing.count:
        trail = Text(count.toString(), style: const TextStyle(fontSize: 16));
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

    final colors = Theme.of(context).colorScheme;
    final selected = index == widget.selected;

    Future<void> showActions() => showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      builder: (context) => SafeArea(
        child: ExerciseModal(
          planId: widget.plan.id,
          exercise: exercise.exercise,
          hasData: count > 0,
          onSelect: () => widget.onSelect(index),
          onMax: widget.onMax,
        ),
      ),
    );

    final content = desktop
        ? Padding(
            key: Key(exercise.exercise),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Material(
              color: selected
                  ? colors.primary.withValues(alpha: .12)
                  : colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => tap(index, counts),
                onLongPress: showActions,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final showProgress = constraints.maxWidth >= 420;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selected
                                ? Icons.radio_button_checked_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: selected
                                ? colors.primary
                                : colors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              exercise.exercise,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (showProgress) ...[
                            SizedBox(
                              width: 150,
                              child: CustomSetIndicator(count: count, max: max),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (trailing == PlanTrailing.reorder ||
                              trailing == PlanTrailing.none) ...[
                            Text(
                              '$count / $max',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                            const SizedBox(width: 10),
                          ],
                          trail,
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                onTap: () => tap(index, counts),
                trailing: trail,
                title: Row(
                  children: [
                    RadioGroup<bool>(
                      groupValue: true,
                      onChanged: (value) {
                        widget.onSelect(index);
                      },
                      child: Radio<bool>(value: selected),
                    ),
                    Flexible(child: Text(exercise.exercise)),
                  ],
                ),
              ),
              CustomSetIndicator(count: count, max: max),
            ],
          );

    if (desktop) return content;
    return GestureDetector(
      key: Key(exercise.exercise),
      onLongPress: showActions,
      child: content,
    );
  }
}
