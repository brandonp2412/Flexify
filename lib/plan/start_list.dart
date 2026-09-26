import 'package:drift/drift.dart' hide Column;
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/custom_set_indicator.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/exercise_modal.dart';
import 'package:flexify/plan/plan_queries.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartList extends StatefulWidget {
  final List<PlanExercise> exercises;
  final int selected;
  final Future<void> Function(int) onSelect;
  final List<GymCount> counts;
  final Plan plan;

  const StartList({
    super.key,
    required this.exercises,
    required this.selected,
    required this.onSelect,
    required this.counts,
    required this.plan,
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

    final planned = widget.exercises[index];
    final gymSet =
        await (db.gymSets.select()
              ..where(
                (tbl) => isExercise(tbl, planned.exercise, planned.category),
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
    final counts = widget.counts;
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
      (element) =>
          element.name == exercise.exercise &&
          element.category == exercise.category,
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
        trail = Text(
          "${formatDisplayNumber(context, count, maximumFractionDigits: 0)} / ${formatDisplayNumber(context, max, maximumFractionDigits: 0)}",
          style: const TextStyle(fontSize: 16),
        );
        break;

      case PlanTrailing.count:
        trail = Text(
          formatDisplayNumber(context, count, maximumFractionDigits: 0),
          style: const TextStyle(fontSize: 16),
        );
        break;

      case PlanTrailing.percent:
        trail = Text(
          formatDisplayPercent(context, count / max),
          style: const TextStyle(fontSize: 16),
        );
        break;

      case PlanTrailing.none:
        trail = const SizedBox();
        break;
    }

    final colors = Theme.of(context).colorScheme;
    final selected = index == widget.selected;
    final categoryText = Text(
      categoryLabel(context.l10n, exercise.category),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
    );

    Future<void> showActions() => showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      builder: (context) => SafeArea(
        child: ExerciseModal(
          planId: widget.plan.id,
          exercise: exercise.exercise,
          category: exercise.category,
          hasData: count > 0,
          onSelect: () => widget.onSelect(index),
        ),
      ),
    );

    final content = desktop
        ? Padding(
            key: ValueKey((exercise.exercise, exercise.category)),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
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
                                categoryText,
                              ],
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
                              '${formatDisplayNumber(context, count, maximumFractionDigits: 0)} / ${formatDisplayNumber(context, max, maximumFractionDigits: 0)}',
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
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(exercise.exercise), categoryText],
                      ),
                    ),
                  ],
                ),
              ),
              CustomSetIndicator(count: count, max: max),
            ],
          );

    if (desktop) return content;
    return GestureDetector(
      key: ValueKey((exercise.exercise, exercise.category)),
      onLongPress: showActions,
      child: content,
    );
  }
}
