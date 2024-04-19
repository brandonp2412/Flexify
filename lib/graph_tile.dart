import 'package:flexify/settings_state.dart';
import 'package:flexify/view_graph_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GraphTile extends StatelessWidget {
  final String name;
  final double weight;
  final double reps;
  final DateTime created;
  final String unit;
  final Set<String> selected;
  final Function onSelect;

  const GraphTile(
      {super.key,
      required this.name,
      required this.weight,
      required this.created,
      required this.unit,
      required this.selected,
      required this.onSelect,
      required this.reps});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return ListTile(
      selected: selected.contains(name),
      title: Text(name),
      subtitle: Text(DateFormat(settings.dateFormat).format(created)),
      trailing: Text(
        "$reps x $weight$unit",
        style: const TextStyle(fontSize: 16),
      ),
      onTap: () {
        if (selected.isEmpty)
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewGraphPage(
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
