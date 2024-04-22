import 'package:flexify/edit_gym_set.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:drift/drift.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:provider/provider.dart';

class GraphHistory extends StatefulWidget {
  final String name;

  const GraphHistory({super.key, required this.name});

  @override
  createState() => _GraphHistoryState();
}

class _GraphHistoryState extends State<GraphHistory> {
  late Stream<List<GymSet>> _stream;
  Set<int> _selected = {};

  @override
  void initState() {
    super.initState();
    _stream = (db.gymSets.select()
          ..orderBy(
            [
              (u) =>
                  OrderingTerm(expression: u.created, mode: OrderingMode.desc)
            ],
          )
          ..where((tbl) => tbl.name.equals(widget.name))
          ..where((tbl) => tbl.hidden.equals(false)))
        .watch();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (_selected.isNotEmpty)
      actions.add(IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: Text(
                      'Are you sure you want to delete ${_selected.length} records?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('Delete'),
                      onPressed: () async {
                        Navigator.pop(context);
                        (db.delete(db.gymSets)
                              ..where((tbl) => tbl.id.isIn(_selected)))
                            .go();
                        setState(() {
                          _selected = {};
                        });
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: const Icon(Icons.delete)));

    final settings = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(
        title: _selected.isEmpty
            ? Text(widget.name)
            : Text("${_selected.length} selected"),
        actions: actions,
      ),
      body: StreamBuilder<List<GymSet>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          if (snapshot.hasError) return ErrorWidget(snapshot.error.toString());
          if (snapshot.data?.isEmpty == true)
            return ListTile(
              title: Text("No entries yet for ${widget.name}"),
              subtitle: const Text(
                  "Start completing plans for records to appear here."),
            );

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final gymSet = snapshot.data![index];
              final previousGymSet =
                  index > 0 ? snapshot.data![index - 1] : null;

              final bool showDivider = previousGymSet != null &&
                  !isSameDay(gymSet.created, previousGymSet.created);

              return material.Column(
                children: [
                  if (showDivider) const Divider(),
                  ListTile(
                    title: Text(gymSet.name),
                    subtitle: Text(DateFormat(settings.longDateFormat)
                        .format(gymSet.created)),
                    trailing: Text(
                        "${gymSet.reps} x ${gymSet.weight} ${gymSet.unit}",
                        style: const TextStyle(fontSize: 16)),
                    selected: _selected.contains(gymSet.id),
                    onLongPress: () {
                      setState(() {
                        _selected.add(gymSet.id);
                      });
                    },
                    onTap: () {
                      if (_selected.contains(gymSet.id))
                        setState(() {
                          _selected.remove(gymSet.id);
                        });
                      else if (_selected.isNotEmpty)
                        setState(() {
                          _selected.add(gymSet.id);
                        });
                      else
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditGymSet(gymSet: gymSet.toCompanion(false)),
                            ));
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
