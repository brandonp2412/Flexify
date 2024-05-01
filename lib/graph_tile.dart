import 'package:flexify/settings_state.dart';
import 'package:flexify/view_cardio_page.dart';
import 'package:flexify/view_strength_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GraphTile extends StatelessWidget {
  final String name;
  final bool cardio;
  final double duration;
  final double distance;
  final double weight;
  final double reps;
  final DateTime created;
  final String unit;
  final Set<String> selected;
  final Function(String) onSelect;

  const GraphTile(
      {super.key,
      required this.name,
      required this.weight,
      required this.created,
      required this.unit,
      required this.selected,
      required this.onSelect,
      required this.reps,
      required this.cardio,
      required this.duration,
      required this.distance});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return ListTile(
      selected: selected.contains(name),
      title: Text(name),
      subtitle: Text(DateFormat(settings.longDateFormat).format(created)),
      trailing: Text(
        cardio ? "$distance / $duration" : "$reps x $weight$unit",
        style: const TextStyle(fontSize: 16),
      ),
      onTap: () {
        if (selected.isEmpty)
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => cardio
                    ? ViewCardioPage(name: name)
                    : ViewStrengthPage(
                        name: name,
                      )),
          );
        else
          onSelect(name);
      },
      onLongPress: () {
        onSelect(name);
      },
    );
  }
}
