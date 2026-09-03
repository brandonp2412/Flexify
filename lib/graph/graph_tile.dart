import 'dart:io';

import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/cardio_page.dart';
import 'package:flexify/graph/strength_page.dart';
import 'package:flexify/responsive.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class GraphTile extends StatelessWidget {
  final GymSetsCompanion gymSet;
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
      trailing = "${toString(value)} ${gymSet.unit.value} / $minutes:$seconds";
    } else {
      trailing =
          "${toString(gymSet.reps.value)} x ${toString(gymSet.weight.value)} ${gymSet.unit.value}";
    }

    Widget? leading;

    if (showImages && gymSet.image.value?.isNotEmpty == true) {
      leading = GestureDetector(
        onTap: () => onSelect(gymSet.name.value),
        child: Image.file(
          File(gymSet.image.value!),
          cacheWidth: 64,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      );
    } else if (showImages) {
      leading = GestureDetector(
        onTap: () => onSelect(gymSet.name.value),
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
      color: selected.contains(gymSet.name.value)
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
              dateFormat == 'timeago'
                  ? timeago.format(gymSet.created.value)
                  : DateFormat(dateFormat).format(gymSet.created.value),
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
            onSelect(gymSet.name.value);
            return;
          }

          if (gymSet.cardio.value) {
            final data = await getCardioData(
              target: gymSet.unit.value,
              name: gymSet.name.value,
              metric: _isWeightUnit(gymSet.unit.value)
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
                  name: gymSet.name.value,
                  unit: gymSet.unit.value,
                  data: data,
                ),
              ),
            );
            return;
          }

          final data = await getStrengthData(
            target: gymSet.unit.value,
            name: gymSet.name.value,
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
                name: gymSet.name.value,
                unit: gymSet.unit.value,
                data: data,
                tabCtrl: tabCtrl,
              ),
            ),
          );
        },
        onLongPress: () {
          onSelect(gymSet.name.value);
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
