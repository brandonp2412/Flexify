import 'dart:io';

import 'package:flexify/constants.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/graph/cardio_page.dart';
import 'package:flexify/graph/strength_page.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphTile extends StatelessWidget {
  final GraphExerciseSummary gymSet;
  final Set<String> selected;
  final Function(String) onSelect;
  final TabController tabCtrl;
  final bool timeBasedXAxis; // new flag to control x-axis behaviour

  const GraphTile({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.gymSet,
    required this.tabCtrl,
    this.timeBasedXAxis = false,
  });

  @override
  Widget build(BuildContext context) {
    String trailing;
    final unit = displayMeasurementUnit(context.l10n, gymSet.unit);
    final showImages = context.select<SettingsState, bool>(
      (settings) => settings.value.showImages,
    );

    if (gymSet.cardio) {
      final minutes = gymSet.duration.floor();
      final seconds = ((gymSet.duration * 60) % 60).floor().toString().padLeft(
        2,
        '0',
      );
      final value = _isWeightUnit(gymSet.unit)
          ? gymSet.weight
          : gymSet.distance;
      trailing =
          "${formatDisplayNumber(context, value)} $unit / $minutes:$seconds";
    } else {
      trailing =
          "${formatDisplayNumber(context, gymSet.reps)} x ${formatDisplayNumber(context, gymSet.weight)} $unit";
    }

    Widget? leading;

    if (showImages && gymSet.image?.isNotEmpty == true) {
      leading = GestureDetector(
        onTap: () => onSelect(gymSet.name),
        child: Image.file(
          File(gymSet.image!),
          cacheWidth: 64,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      );
    } else if (showImages) {
      leading = GestureDetector(
        onTap: () => onSelect(gymSet.name),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              gymSet.name.isNotEmpty ? gymSet.name[0].toUpperCase() : '?',
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
      color: selected.contains(gymSet.name)
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
          gymSet.name,
          style: desktop
              ? Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)
              : null,
        ),
        subtitle: Selector<SettingsState, String>(
          selector: (context, settings) => settings.value.longDateFormat,
          builder: (context, dateFormat, child) => Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              dateFormat == 'timeago'
                  ? formatRelativeTime(context, gymSet.created)
                  : formatDisplayDate(context, gymSet.created, dateFormat),
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
        ),
        trailing: Text(
          trailing,
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(fontWeight: FontWeight.w600, color: colors.onSurface),
        ),
        onTap: () async {
          if (selected.isNotEmpty) {
            onSelect(gymSet.name);
            return;
          }

          if (gymSet.cardio) {
            final data = await getCardioData(
              target: gymSet.unit,
              name: gymSet.name,
              metric: _isWeightUnit(gymSet.unit)
                  ? CardioMetric.weight
                  : CardioMetric.pace,
              period: Period.day,
              start: null,
              end: null,
            );
            if (!context.mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CardioPage(
                  tabCtrl: tabCtrl,
                  name: gymSet.name,
                  unit: gymSet.unit,
                  data: data,
                ),
              ),
            );
            return;
          }

          final data = await getStrengthData(
            target: gymSet.unit,
            name: gymSet.name,
            metric: StrengthMetric.bestWeight,
            period: Period.day,
            start: null,
            end: null,
            limit: 20,
          );
          if (!context.mounted) return;

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StrengthPage(
                name: gymSet.name,
                unit: gymSet.unit,
                data: data,
                tabCtrl: tabCtrl,
              ),
            ),
          );
        },
        onLongPress: () {
          onSelect(gymSet.name);
        },
      ),
    );

    if (!desktop) return tile;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: tile,
    );
  }

  bool _isWeightUnit(String unit) =>
      unit == 'kg' || unit == 'lb' || unit == 'stone';
}
