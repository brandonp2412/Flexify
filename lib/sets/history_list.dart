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
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _HistoryContextAction { edit, delete }

class HistoryList extends StatefulWidget {
  final List<ExerciseSetView> sets;
  final ScrollController scroll;
  final Function(int) onSelect;
  final Set<int> selected;
  final Function onNext;

  const HistoryList({
    super.key,
    required this.sets,
    required this.onSelect,
    required this.selected,
    required this.onNext,
    required this.scroll,
  });

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  bool _goingNext = false;
  List<ExerciseSetView> _current = [];

  Future<void> _showContextMenu(
    BuildContext context,
    TapDownDetails details,
    ExerciseSetView exerciseSet,
  ) async {
    final action = await showDesktopContextMenu<_HistoryContextAction>(
      context,
      details.globalPosition,
      [
        PopupMenuItem(
          value: _HistoryContextAction.edit,
          child: ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: Text(context.l10n.actionEdit),
          ),
        ),
        PopupMenuItem(
          value: _HistoryContextAction.delete,
          child: ListTile(
            leading: const Icon(Icons.delete_outline),
            title: Text(context.l10n.actionDelete),
          ),
        ),
      ],
    );
    if (!context.mounted) return;

    switch (action) {
      case _HistoryContextAction.edit:
        await Navigator.of(context).push(
          FlexPageRoute(
            builder: (context) => EditSetPage(exerciseSet: exerciseSet),
          ),
        );
        break;
      case _HistoryContextAction.delete:
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
  void initState() {
    super.initState();
    widget.scroll.addListener(scrollListener);
    _current = List.from(widget.sets);
  }

  @override
  void didUpdateWidget(HistoryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.sets, widget.sets)) {
      setState(() {
        _current = List.from(widget.sets);
      });
    }
  }

  Widget _buildListItem(
    ExerciseSetView exerciseSet,
    int index,
    bool showImages,
  ) {
    final previousExerciseSet = index > 0
        ? _current.elementAtOrNull(index - 1)
        : null;
    final bool showDivider =
        previousExerciseSet != null &&
        !isSameDay(exerciseSet.created, previousExerciseSet.created);

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
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
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

    String trailing = "$reps x $weight $unit";
    if (exerciseSet.cardio &&
        (exerciseSet.unit == 'kg' ||
            exerciseSet.unit == 'lb' ||
            exerciseSet.unit == 'stone'))
      trailing = "$weight $unit / $minutes:$seconds $incline";
    else if (exerciseSet.cardio &&
        (exerciseSet.unit == 'km' ||
            exerciseSet.unit == 'mi' ||
            exerciseSet.unit == 'kcal'))
      trailing = "$distance $unit / $minutes:$seconds $incline";

    return Column(
      children: [
        if (showDivider)
          Container(
            color:
                (widget.selected.contains(exerciseSet.id) &&
                    widget.selected.contains(previousExerciseSet.id))
                ? Theme.of(context).colorScheme.primary.withValues(alpha: .18)
                : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Expanded(child: Divider()),
                  const Icon(Icons.today),
                  const SizedBox(width: 4),
                  Selector<SettingsState, String>(
                    selector: (context, settings) =>
                        settings.value.shortDateFormat,
                    builder: (context, value, child) => Text(
                      formatDisplayDate(
                        context,
                        previousExerciseSet.created,
                        value,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Expanded(child: Divider()),
                ],
              ),
            ),
          ),
        Builder(
          builder: (context) {
            final desktop = isDesktopLayout(context);
            final colors = Theme.of(context).colorScheme;
            final tile = Material(
              color: widget.selected.contains(exerciseSet.id)
                  ? colors.primary.withValues(alpha: .18)
                  : desktop
                  ? colors.surfaceContainerLow
                  : Colors.transparent,
              borderRadius: desktop ? BorderRadius.circular(16) : null,
              clipBehavior: desktop ? Clip.antiAlias : Clip.none,
              child: ListTile(
                contentPadding: desktop
                    ? const EdgeInsets.symmetric(horizontal: 20, vertical: 9)
                    : null,
                leading: leading,
                title: Text(
                  exerciseSet.name,
                  style: desktop
                      ? Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        )
                      : null,
                ),
                subtitle: Selector<SettingsState, String>(
                  selector: (context, settings) =>
                      settings.value.longDateFormat,
                  builder: (context, dateFormat, child) => Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      dateFormat == 'timeago'
                          ? formatRelativeTime(context, exerciseSet.created)
                          : formatDisplayDate(
                              context,
                              exerciseSet.created,
                              dateFormat,
                            ),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                trailing: Text(
                  trailing,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                onLongPress: desktop
                    ? null
                    : () => widget.onSelect(exerciseSet.id),
                onTap: () {
                  if (widget.selected.isNotEmpty) {
                    widget.onSelect(exerciseSet.id);
                  } else {
                    Navigator.of(context).push(
                      FlexPageRoute(
                        builder: (context) =>
                            EditSetPage(exerciseSet: exerciseSet),
                      ),
                    );
                  }
                },
              ),
            );
            if (!desktop) return tile;
            return ResponsiveContent(
              maxWidth: desktopDataContentMaxWidth,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onSecondaryTapDown: (details) =>
                    _showContextMenu(context, details, exerciseSet),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  child: tile,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final showImages = context.select<SettingsState, bool>(
      (settings) => settings.value.showImages,
    );

    return ListView.builder(
      padding: EdgeInsets.only(
        bottom: isDesktopLayout(context) ? 32 : floatingActionButtonListPadding,
        top: appSearchHeight + 8,
      ),
      controller: widget.scroll,
      itemCount: _current.length,
      itemBuilder: (context, index) {
        return _buildListItem(_current[index], index, showImages);
      },
    );
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

  @override
  void dispose() {
    widget.scroll.removeListener(scrollListener);
    super.dispose();
  }
}
