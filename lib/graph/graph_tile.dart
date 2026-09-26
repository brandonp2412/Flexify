import 'dart:io';

import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/cardio_page.dart';
import 'package:flexify/graph/strength_page.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphTile extends StatelessWidget {
  final GymSetsCompanion gymSet;
  final Set<ExerciseKey> selected;
  final Function(ExerciseKey) onSelect;
  final TabController tabCtrl;

  const GraphTile({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.gymSet,
    required this.tabCtrl,
  });

  ExerciseKey get _exercise =>
      (name: gymSet.name.value, category: gymSet.category.value);

  @override
  Widget build(BuildContext context) {
    String trailing;
    final unit = displayMeasurementUnit(context.l10n, gymSet.unit.value);
    final showImages = context.select<SettingsState, bool>(
      (settings) => settings.value.showImages,
    );

    if (gymSet.cardio.value) {
      final minutes = gymSet.duration.value.floor();
      final seconds = ((gymSet.duration.value * 60) % 60)
          .floor()
          .toString()
          .padLeft(2, '0');
      final value = _isWeightUnit(gymSet.unit.value)
          ? gymSet.weight.value
          : gymSet.distance.value;
      trailing =
          "${formatDisplayNumber(context, value)} $unit / $minutes:$seconds";
    } else {
      trailing =
          "${formatDisplayNumber(context, gymSet.reps.value)} x ${formatDisplayNumber(context, gymSet.weight.value)} $unit";
    }

    Widget? leading;

    if (showImages && gymSet.image.value?.isNotEmpty == true) {
      leading = GestureDetector(
        onTap: () => onSelect(_exercise),
        child: Image.file(
          File(gymSet.image.value!),
          cacheWidth: 64,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      );
    } else if (showImages) {
      leading = GestureDetector(
        onTap: () => onSelect(_exercise),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              gymSet.name.value.isNotEmpty
                  ? gymSet.name.value[0].toUpperCase()
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
      color: selected.contains(_exercise)
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
          gymSet.name.value,
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
              context.l10n.categoryAndDate(
                categoryLabel(context.l10n, gymSet.category.value),
                dateFormat == 'timeago'
                    ? formatRelativeTime(context, gymSet.created.value)
                    : formatDisplayDate(
                        context,
                        gymSet.created.value,
                        dateFormat,
                      ),
              ),
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
            onSelect(_exercise);
            return;
          }

          await openExerciseGraph(
            Navigator.of(context),
            name: gymSet.name.value,
            category: gymSet.category.value,
            unit: gymSet.unit.value,
            cardio: gymSet.cardio.value,
            tabCtrl: tabCtrl,
          );
        },
        onLongPress: () {
          onSelect(_exercise);
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

/// Opens the progress graph for the exercise [name] within [category] on
/// [navigator].
Future<void> openExerciseGraph(
  NavigatorState navigator, {
  required String name,
  required String? category,
  required String unit,
  required bool cardio,
  TabController? tabCtrl,
}) async {
  if (cardio) {
    final weighted = unit == 'kg' || unit == 'lb' || unit == 'stone';
    final data = await getCardioData(
      target: unit,
      name: name,
      category: category,
      metric: weighted ? CardioMetric.weight : CardioMetric.pace,
      period: Period.day,
      start: null,
      end: null,
    );
    await navigator.push(
      MaterialPageRoute(
        builder: (context) => CardioPage(
          tabCtrl: tabCtrl,
          name: name,
          category: category,
          unit: unit,
          data: data,
        ),
      ),
    );
    return;
  }

  final data = await getStrengthData(
    target: unit,
    name: name,
    category: category,
    metric: StrengthMetric.bestWeight,
    period: Period.day,
    start: null,
    end: null,
    limit: 20,
  );
  await navigator.push(
    MaterialPageRoute(
      builder: (context) => StrengthPage(
        name: name,
        category: category,
        unit: unit,
        data: data,
        tabCtrl: tabCtrl,
      ),
    ),
  );
}
