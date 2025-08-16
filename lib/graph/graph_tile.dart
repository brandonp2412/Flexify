import 'dart:io';

import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/graph/cardio_page.dart';
import 'package:flexify/graph/strength_page.dart';
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

  const GraphTile({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.gymSet,
  });

  @override
  Widget build(BuildContext context) {
    String trailing;
    final showImages = context
        .select<SettingsState, bool>((settings) => settings.value.showImages);

    if (gymSet.cardio.value) {
      final minutes = gymSet.duration.value.floor();
      final seconds = ((gymSet.duration.value * 60) % 60)
          .floor()
          .toString()
          .padLeft(2, '0');
      trailing =
          "${toString(gymSet.distance.value)} ${gymSet.unit.value} / $minutes:$seconds";
    } else {
      trailing =
          "${toString(gymSet.reps.value)} x ${toString(gymSet.weight.value)} ${gymSet.unit.value}";
    }

    Widget? leading = SizedBox(
      height: 24,
      width: 24,
      child: Checkbox(
        value: selected.contains(gymSet.name.value),
        onChanged: (value) {
          onSelect(gymSet.name.value);
        },
      ),
    );

    if (selected.isEmpty &&
        showImages &&
        gymSet.image.value?.isNotEmpty == true) {
      leading = GestureDetector(
        onTap: () => onSelect(gymSet.name.value),
        child: Image.file(
          File(gymSet.image.value!),
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      );
    } else if (selected.isEmpty) {
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

    leading = AnimatedSwitcher(
      duration: const Duration(milliseconds: 150),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: leading,
    );

    return ListTile(
      leading: leading,
      selected: selected.contains(gymSet.name.value),
      title: Text(gymSet.name.value),
      subtitle: Selector<SettingsState, String>(
        selector: (context, settings) => settings.value.longDateFormat,
        builder: (context, dateFormat, child) => Text(
          dateFormat == 'timeago'
              ? timeago.format(gymSet.created.value)
              : DateFormat(dateFormat).format(gymSet.created.value),
        ),
      ),
      trailing: Text(
        trailing,
        style: const TextStyle(fontSize: 16),
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
            metric: CardioMetric.pace,
            period: Period.day,
            start: null,
            end: null,
          );
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardioPage(
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

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StrengthPage(
              name: gymSet.name.value,
              unit: gymSet.unit.value,
              data: data,
            ),
          ),
        );
      },
      onLongPress: () {
        onSelect(gymSet.name.value);
      },
    );
  }
}
