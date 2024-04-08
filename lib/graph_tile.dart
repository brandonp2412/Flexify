import 'package:drift/drift.dart';
import 'package:flexify/app_state.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/view_graph_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GraphTile extends StatelessWidget {
  final String name;
  final double weight;
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
      required this.onSelect});

  Future<int> getCount() async {
    final result = await (db.gymSets.selectOnly()
          ..addColumns([db.gymSets.name.count()])
          ..where(db.gymSets.name.equals(name)))
        .getSingle();
    return result.read(db.gymSets.name.count()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return ListTile(
      selected: selected.contains(name),
      title: Text(name),
      subtitle: Text(DateFormat(settings.dateFormat).format(created)),
      trailing: Text(
        "$weight$unit",
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
