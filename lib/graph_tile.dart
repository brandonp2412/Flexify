import 'package:flexify/database.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/view_cardio_page.dart';
import 'package:flexify/view_strength_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    final settings = context.watch<SettingsState>();

    return ListTile(
      selected: selected.contains(gymSet.name.value),
      title: Text(gymSet.name.value),
      subtitle: Text(
        DateFormat(settings.longDateFormat).format(gymSet.created.value),
      ),
      trailing: Text(
        gymSet.cardio.value
            ? "${gymSet.distance.value} / ${gymSet.duration.value}"
            : "${gymSet.reps.value} x ${gymSet.weight.value} ${gymSet.unit.value}",
        style: const TextStyle(fontSize: 16),
      ),
      onTap: () {
        if (selected.isEmpty)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => gymSet.cardio.value
                  ? ViewCardioPage(name: gymSet.name.value)
                  : ViewStrengthPage(
                      name: gymSet.name.value,
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
