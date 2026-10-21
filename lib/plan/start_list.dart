import 'package:drift/drift.dart' hide Column;
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/custom_set_indicator.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/exercise_modal.dart';
import 'package:flexify/plan/plan_queries.dart';
import 'package:flexify/plan/workout_sessions.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartList extends StatefulWidget {
  final List<PlanExerciseEntry> exercises;
  final int selected;
  final Future<void> Function(int) onSelect;
  final List<GymCount> counts;
  final Map<int, PreviousExerciseDay> previous;
  final Plan plan;
  final int? workoutId;

  const StartList({
    super.key,
    required this.exercises,
    required this.selected,
    required this.onSelect,
    required this.counts,
    required this.previous,
    required this.plan,
    required this.workoutId,
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

    final workoutId = widget.workoutId;
    if (workoutId == null) return;
    final exerciseSet = await getLatestWorkoutExerciseSet(
      db,
      workoutId: workoutId,
      exerciseId: widget.exercises[index].exercise.id,
    );
    if (exerciseSet == null) return;
    if (!mounted) return;

    Navigator.of(context).push(
      FlexPageRoute(
        builder: (context) => EditSetPage(exerciseSet: exerciseSet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final max = context.select<Setting, int>((settings) => settings.maxSets);
    final trailing = context.select<Setting, PlanTrailing>(
      (settings) => PlanTrailing.values.byName(
        settings.planTrailing.replaceFirst('PlanTrailing.', ''),
      ),
    );
    final shortDateFormat = context.select<Setting, String>(
      (settings) => settings.shortDateFormat,
    );
    final counts = widget.counts;
    final desktop = isDesktopLayout(context);

    if (trailing == PlanTrailing.reorder)
      return ReorderableListView.builder(
        itemCount: widget.exercises.length,
        buildDefaultDragHandles: !desktop,
        padding: EdgeInsets.only(bottom: desktop ? 24 : _bottomPadding),
        itemBuilder: (context, index) =>
            itemBuilder(context, index, max, trailing, counts, shortDateFormat),
        onReorderItem: (oldIndex, newIndex) async {
          final item = widget.exercises.removeAt(oldIndex);
          widget.exercises.insert(newIndex, item);

          await db.batch((batch) {
            for (var i = 0; i < widget.exercises.length; i++) {
              batch.update(
                db.planExercises,
                PlanExercisesCompanion(sequence: Value(i)),
                where: (pe) =>
                    pe.id.equals(widget.exercises[i].planExercise.id),
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
            itemBuilder(context, index, max, trailing, counts, shortDateFormat),
      );
  }

  Widget itemBuilder(
    BuildContext context,
    int index,
    int maxSets,
    PlanTrailing trailing,
    List<GymCount> counts,
    String shortDateFormat,
  ) {
    final exercise = widget.exercises[index];
    final idx = counts.indexWhere(
      (element) => element.exerciseId == exercise.exercise.id,
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
          "${formatDisplayNumber(context, count, maxDigits: 0)} / ${formatDisplayNumber(context, max, maxDigits: 0)}",
          style: const TextStyle(fontSize: 16),
        );
        break;

      case PlanTrailing.count:
        trail = Text(
          formatDisplayNumber(context, count, maxDigits: 0),
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
    final previous = widget.previous[exercise.exercise.id];
    final previousText = previous == null || previous.sets.isEmpty
        ? null
        : _previousSummary(context, previous, shortDateFormat);
    final previousStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant);

    Future<void> showActions() => showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      builder: (context) => SafeArea(
        child: ExerciseModal(
          planExerciseId: exercise.planExercise.id,
          exerciseId: exercise.exercise.id,
          exerciseName: exercise.exercise.name,
          workoutId: widget.workoutId,
          hasData: count > 0,
          onSelect: () => widget.onSelect(index),
        ),
      ),
    );

    final content = desktop
        ? Padding(
            key: Key(exercise.exercise.name),
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Material(
              color: selected
                  ? colors.primary.withValues(alpha: .12)
                  : colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.none,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => tap(index, counts),
                onLongPress: null,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 260;
                    final showProgress = constraints.maxWidth >= 420;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          if (!compact) ...[
                            Icon(
                              selected
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color: selected
                                  ? colors.primary
                                  : colors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  exercise.exercise.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: selected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                      ),
                                ),
                                if (previousText != null)
                                  Text(
                                    previousText,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: previousStyle,
                                  ),
                              ],
                            ),
                          ),
                          if (!compact) const SizedBox(width: 12),
                          if (showProgress) ...[
                            SizedBox(
                              width: 150,
                              child: CustomSetIndicator(count: count, max: max),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (!compact &&
                              (trailing == PlanTrailing.reorder ||
                                  trailing == PlanTrailing.none)) ...[
                            Text(
                              '${formatDisplayNumber(context, count, maxDigits: 0)} / ${formatDisplayNumber(context, max, maxDigits: 0)}',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                            const SizedBox(width: 10),
                          ],
                          trail,
                          const SizedBox(width: 4),
                          IconButton(
                            tooltip: MaterialLocalizations.of(
                              context,
                            ).moreButtonTooltip,
                            onPressed: showActions,
                            icon: const Icon(Icons.more_horiz_rounded),
                          ),
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
                subtitle: previousText == null
                    ? null
                    : Text(
                        previousText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: previousStyle,
                      ),
                title: Row(
                  children: [
                    RadioGroup<bool>(
                      groupValue: true,
                      onChanged: (value) {
                        widget.onSelect(index);
                      },
                      child: Radio<bool>(value: selected),
                    ),
                    Flexible(child: Text(exercise.exercise.name)),
                  ],
                ),
              ),
              CustomSetIndicator(count: count, max: max),
            ],
          );

    if (desktop) return content;
    return GestureDetector(
      key: Key(exercise.exercise.name),
      onLongPress: showActions,
      child: content,
    );
  }
}

String _previousSummary(
  BuildContext context,
  PreviousExerciseDay previous,
  String shortDateFormat,
) {
  final date = formatDisplayDate(context, previous.day, shortDateFormat);
  return context.l10n.previousPerformance(
    date,
    _previousSets(context, previous.sets),
  );
}

String _previousSets(BuildContext context, List<PreviousExerciseSet> sets) {
  final unit = displayMeasurementUnit(context.l10n, sets.first.unit);
  final values = sets
      .map((set) {
        final weight = formatDisplayNumber(context, set.weight);
        if (set.cardio) {
          final minutes = set.duration.floor();
          final seconds = ((set.duration * 60) % 60).floor().toString().padLeft(
            2,
            '0',
          );
          final value =
              set.unit == 'kg' || set.unit == 'lb' || set.unit == 'stone'
              ? '$weight $unit'
              : '${formatDisplayNumber(context, set.distance)} $unit';
          final incline = set.incline != null && set.incline! > 0
              ? ' @ ${formatDisplayPercent(context, set.incline! / 100, maxDigits: 0)}'
              : '';
          return '$value / $minutes:$seconds$incline';
        }
        return '${formatDisplayNumber(context, set.reps)}×$weight';
      })
      .join(', ');
  return sets.first.cardio ? values : '$values $unit';
}
