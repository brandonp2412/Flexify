import 'package:drift/drift.dart';
import 'package:flexify/edit_graph_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/view_graph_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GraphTile extends StatelessWidget {
  final String name;
  final double weight;
  final DateTime created;
  final String unit;

  const GraphTile(
      {super.key,
      required this.name,
      required this.weight,
      required this.created,
      required this.unit});

  Future<int> getCount() async {
    final result = await (db.gymSets.selectOnly()
          ..addColumns([db.gymSets.name.count()])
          ..where(db.gymSets.name.equals(name)))
        .getSingle();
    return result.read(db.gymSets.name.count()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(DateFormat("yyyy-MM-dd hh:mm a").format(created)),
      trailing: Text(
        "$weight$unit",
        style: const TextStyle(fontSize: 16),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewGraphPage(
                    name: name,
                  )),
        );
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditGraphPage(
                          name: name,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: FutureBuilder(
                            future: getCount(),
                            builder: (context, snapshot) => Text(
                                'Are you sure you want to delete all ${snapshot.data} records of $name ?'),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                (db.delete(db.gymSets)
                                      ..where((tbl) => tbl.name.equals(name)))
                                    .go();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
