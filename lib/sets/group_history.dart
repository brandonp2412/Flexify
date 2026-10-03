import 'dart:io';

import 'package:flexify/app_search.dart';
import 'package:flexify/bottom_nav.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/sets/edit_set_page.dart';
import 'package:flexify/sets/history_page.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _GroupedHistoryContextAction { edit, delete }

class GroupHistory extends StatefulWidget {
  final List<HistoryDay> days;
  final ScrollController scroll;
  final Function(int) onSelect;
  final Set<int> selected;
  final Function onNext;
  const GroupHistory({
    super.key,
    required this.days,
    required this.onSelect,
    required this.selected,
    required this.onNext,
    required this.scroll,
  });

  @override
  State<GroupHistory> createState() => _GroupHistoryState();
}

class _GroupHistoryState extends State<GroupHistory> {
  bool _goingNext = false;

  Future<void> _showContextMenu(
    BuildContext context,
    TapDownDetails details,
    ExerciseSetView exerciseSet,
  ) async {
    final action = await showDesktopContextMenu<_GroupedHistoryContextAction>(
      context,
      details.globalPosition,
      [
        PopupMenuItem(
          value: _GroupedHistoryContextAction.edit,
          child: ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(context.l10n.actionEdit),
          ),
        ),
        PopupMenuItem(
          value: _GroupedHistoryContextAction.delete,
          child: ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(context.l10n.actionDelete),
          ),
        ),
      ],
    );
    if (!context.mounted) return;

    switch (action) {
      case _GroupedHistoryContextAction.edit:
        await Navigator.of(context).push(
          FlexPageRoute(
            builder: (context) => EditSetPage(exerciseSet: exerciseSet),
          ),
        );
        break;
      case _GroupedHistoryContextAction.delete:
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(context.l10n.confirmDelete),
            content: Text(context.l10n.deleteSetConfirmation(exerciseSet.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(context.l10n.actionCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(context.l10n.actionDelete),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          await deleteExerciseSets(db, [exerciseSet.id]);
        }
        break;
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final showImages = context.select<SettingsState, bool>(
      (settings) => settings.value.showImages,
    );

    return ListView.builder(
      itemCount: widget.days.length,
      padding: EdgeInsets.only(
        bottom: isDesktopLayout(context) ? 32 : floatingActionButtonListPadding,
        top: appSearchHeight + 8,
      ),
      controller: widget.scroll,
      itemBuilder: (context, index) {
        final history = widget.days[index];

        return Column(
          children: historyChildren(
            history,
            context,
            showImages,
            widget.selected,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.scroll.removeListener(scrollListener);
    super.dispose();
  }

  List<Widget> historyChildren(
    HistoryDay history,
    BuildContext context,
    bool showImages,
    Set<int> selected,
  ) {
    return [
      ExpansionTile(
        title: Text(
          "${history.name} (${formatDisplayNumber(context, history.exerciseSets.length, maximumFractionDigits: 0)})",
        ),
        subtitle: Selector<SettingsState, String>(
          selector: (context, settings) => settings.value.shortDateFormat,
          builder: (context, value, child) => Text(
            formatDisplayDate(
              context,
              history.exerciseSets.first.created,
              value,
            ),
          ),
        ),
        shape: const Border.symmetric(),
        children: history.exerciseSets.map((exerciseSet) {
          final minutes = exerciseSet.duration.floor();
          final seconds = ((exerciseSet.duration * 60) % 60)
              .floor()
              .toString()
              .padLeft(2, '0');
          final distance = formatDisplayNumber(context, exerciseSet.distance);
          final reps = formatDisplayNumber(context, exerciseSet.reps);
          final weight = formatDisplayNumber(context, exerciseSet.weight);
          final unit = displayMeasurementUnit(context.l10n, exerciseSet.unit);
          String incline = '';
          if (exerciseSet.incline != null && exerciseSet.incline! > 0) {
            incline =
                '@ ${formatDisplayPercent(context, exerciseSet.incline! / 100, maximumFractionDigits: 0)}';
          }

          Widget? leading;

          if (showImages && exerciseSet.image != null) {
            leading = GestureDetector(
              onTap: () => widget.onSelect(exerciseSet.id),
              child: Image.file(
                File(exerciseSet.image!),
                cacheWidth: 64,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            );
          } else if (showImages) {
            leading = GestureDetector(
              onTap: () => widget.onSelect(exerciseSet.id),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    exerciseSet.name.isNotEmpty
                        ? exerciseSet.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            );
          }

          String title = "$reps x $weight $unit";
          if (exerciseSet.cardio &&
              (exerciseSet.unit == 'kg' ||
                  exerciseSet.unit == 'lb' ||
                  exerciseSet.unit == 'stone')) {
            title = "$weight $unit / $minutes:$seconds $incline";
          } else if (exerciseSet.cardio &&
              (exerciseSet.unit == 'km' ||
                  exerciseSet.unit == 'mi' ||
                  exerciseSet.unit == 'kcal')) {
            title = "$distance $unit / $minutes:$seconds $incline";
          }

          final tile = Material(
            color: widget.selected.contains(exerciseSet.id)
                ? Theme.of(context).colorScheme.primary.withValues(alpha: .18)
                : Colors.transparent,
            child: ListTile(
              leading: leading,
              title: Text(title),
              subtitle: Selector<SettingsState, String>(
                selector: (context, settings) => settings.value.longDateFormat,
                builder: (context, dateFormat, child) => Text(
                  dateFormat == 'timeago'
                      ? formatRelativeTime(context, exerciseSet.created)
                      : formatDisplayDate(
                          context,
                          exerciseSet.created,
                          dateFormat,
                        ),
                ),
              ),
              onLongPress: isDesktopLayout(context)
                  ? null
                  : () {
                      widget.onSelect(exerciseSet.id);
                    },
              onTap: () {
                if (widget.selected.isNotEmpty)
                  widget.onSelect(exerciseSet.id);
                else
                  Navigator.of(context).push(
                    FlexPageRoute(
                      builder: (context) =>
                          EditSetPage(exerciseSet: exerciseSet),
                    ),
                  );
              },
            ),
          );
          if (!isDesktopLayout(context)) return tile;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onSecondaryTapDown: (details) =>
                _showContextMenu(context, details, exerciseSet),
            child: tile,
          );
        }).toList(),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    widget.scroll.addListener(scrollListener);
  }

  void scrollListener() {
    if (widget.scroll.position.pixels <
            widget.scroll.position.maxScrollExtent - 200 ||
        _goingNext)
      return;
    _goingNext = true;
    widget.onNext();
    setState(() {
      _goingNext = false;
    });
  }
}
