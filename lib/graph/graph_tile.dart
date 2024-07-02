import 'package:flexify/database/database.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/graph/cardio_page.dart';
import 'package:flexify/graph/strength_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flexify/utils.dart';

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

    return ListTile(
      selected: selected.contains(gymSet.name.value),
      title: Text(gymSet.name.value),
      subtitle: Selector<SettingsState, String>(
        selector: (p0, p1) => p1.longDateFormat,
        builder: (context, value, child) => Text(
          DateFormat(value).format(gymSet.created.value),
        ),
      ),
      trailing: Text(
        trailing,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: () {
        if (selected.isEmpty)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => gymSet.cardio.value
                  ? CardioPage(
                      name: gymSet.name.value,
                      unit: gymSet.unit.value,
                    )
                  : StrengthPage(
                      name: gymSet.name.value,
                      unit: gymSet.unit.value,
                    ),
            ),
          );
        else
          onSelect(gymSet.name.value);
      },
      onLongPress: () {
        onSelect(gymSet.name.value);
      },
    );
  }
}
