import 'dart:io';

import 'package:flexify/constants.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/graph/cardio_page.dart';
import 'package:flexify/graph/strength_page.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/platform_page_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _GraphContextAction { edit, delete }

class GraphTile extends StatelessWidget {
  final GraphExerciseSummary exerciseSet;
  final String? label;
  final Set<String> selected;
  final Function(String) onSelect;
  final TabController tabCtrl;
  final bool timeBasedXAxis; // new flag to control x-axis behaviour
  final VoidCallback? onEdit;
  final Future<void> Function()? onDelete;

  const GraphTile({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.exerciseSet,
    this.label,
    required this.tabCtrl,
    this.timeBasedXAxis = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    String trailing;
    final unit = displayMeasurementUnit(context.l10n, exerciseSet.unit);
    final showImages = context.select<SettingsState, bool>(
      (settings) => settings.value.showImages,
    );

    if (exerciseSet.bodyWeight) {
      trailing = "${formatDisplayNumber(context, exerciseSet.weight)} $unit";
    } else if (exerciseSet.cardio) {
      final minutes = exerciseSet.duration.floor();
      final seconds = ((exerciseSet.duration * 60) % 60)
          .floor()
          .toString()
          .padLeft(2, '0');
      final value = _isWeightUnit(exerciseSet.unit)
          ? exerciseSet.weight
          : exerciseSet.distance;
      trailing =
          "${formatDisplayNumber(context, value)} $unit / $minutes:$seconds";
    } else {
      trailing =
          "${formatDisplayNumber(context, exerciseSet.reps)} x ${formatDisplayNumber(context, exerciseSet.weight)} $unit";
    }

    Widget? leading;

    if (showImages && exerciseSet.image?.isNotEmpty == true) {
      leading = GestureDetector(
        onTap: () => onSelect(exerciseSet.selectionKey),
        child: Image.file(
          File(exerciseSet.image!),
          cacheWidth: 64,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      );
    } else if (showImages) {
      leading = GestureDetector(
        onTap: () => onSelect(exerciseSet.selectionKey),
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

    final desktop = isDesktopLayout(context);
    final colors = Theme.of(context).colorScheme;
    final tile = Material(
      color: selected.contains(exerciseSet.selectionKey)
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
          label ?? exerciseSet.name,
          style: desktop
              ? Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)
              : null,
        ),
        subtitle: Selector<SettingsState, String>(
          selector: (context, settings) => settings.value.longDateFormat,
          builder: (context, dateFormat, child) => Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              dateFormat == 'timeago'
                  ? formatRelativeTime(context, exerciseSet.created)
                  : formatDisplayDate(context, exerciseSet.created, dateFormat),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
        ),
        trailing: Text(
          trailing,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        onTap: () async {
          if (selected.isNotEmpty) {
            onSelect(exerciseSet.selectionKey);
            return;
          }

          final exercise = exerciseSet.exercise;

          if (exerciseSet.bodyWeight) {
            final data = await getBodyWeightData(
              target: exerciseSet.unit,
              period: Period.day,
              start: null,
              end: null,
              limit: 20,
            );
            if (!context.mounted) return;
            Navigator.of(context).push(
              FlexPageRoute(
                builder: (context) => StrengthPage(
                  initialExercise: exercise,
                  initialUnit: exerciseSet.unit,
                  initialData: data,
                  tabCtrl: tabCtrl,
                  bodyWeight: true,
                ),
              ),
            );
            return;
          }

          if (exerciseSet.cardio) {
            final data = await getCardioData(
              target: exerciseSet.unit,
              exercise: exercise,
              metric: _isWeightUnit(exerciseSet.unit)
                  ? CardioMetric.weight
                  : CardioMetric.pace,
              period: Period.day,
              start: null,
              end: null,
            );
            if (!context.mounted) return;
            Navigator.of(context).push(
              FlexPageRoute(
                builder: (context) => CardioPage(
                  tabCtrl: tabCtrl,
                  initialExercise: exercise,
                  initialUnit: exerciseSet.unit,
                  initialData: data,
                ),
              ),
            );
            return;
          }

          final data = await getStrengthData(
            target: exerciseSet.unit,
            exercise: exercise,
            metric: StrengthMetric.bestWeight,
            period: Period.day,
            start: null,
            end: null,
            limit: 20,
          );
          if (!context.mounted) return;

          Navigator.of(context).push(
            FlexPageRoute(
              builder: (context) => StrengthPage(
                initialExercise: exercise,
                initialUnit: exerciseSet.unit,
                initialData: data,
                tabCtrl: tabCtrl,
              ),
            ),
          );
        },
        onLongPress: desktop
            ? null
            : () {
                onSelect(exerciseSet.selectionKey);
              },
      ),
    );

    if (!desktop) return tile;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onSecondaryTapDown: (details) async {
        final action = await showDesktopContextMenu<_GraphContextAction>(
          context,
          details.globalPosition,
          [
            if (onEdit != null)
              PopupMenuItem(
                value: _GraphContextAction.edit,
                child: ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(context.l10n.actionEdit),
                ),
              ),
            if (onDelete != null)
              PopupMenuItem(
                value: _GraphContextAction.delete,
                child: ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: Text(context.l10n.actionDelete),
                ),
              ),
          ],
        );
        if (!context.mounted) return;
        switch (action) {
          case _GraphContextAction.edit:
            onEdit?.call();
            break;
          case _GraphContextAction.delete:
            await onDelete?.call();
            break;
          case null:
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: tile,
      ),
    );
  }

  bool _isWeightUnit(String unit) =>
      unit == 'kg' || unit == 'lb' || unit == 'stone';
}
