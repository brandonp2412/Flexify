import 'package:flexify/app_state.dart';
import 'package:flexify/edit_gym_set.dart';
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
  final ScrollController _scrollController = ScrollController();
  late Stream<List<GymSet>> stream;
  Set<int> selected = {};

  @override
  void initState() {
    super.initState();
    stream = (db.gymSets.select()
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

    if (selected.isNotEmpty)
      actions.add(IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: Text(
                      'Are you sure you want to delete ${selected.length} records?'),
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
                              ..where((tbl) => tbl.id.isIn(selected)))
                            .go();
                        setState(() {
                          selected = {};
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
        title: selected.isEmpty
            ? Text(widget.name)
            : Text("${selected.length} selected"),
        actions: actions,
      ),
      body: StreamBuilder<List<GymSet>>(
        stream: stream,
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
            controller: _scrollController,
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
                    subtitle: Text(
                        DateFormat(settings.dateFormat).format(gymSet.created)),
                    trailing: Text(
                        "${gymSet.reps} x ${gymSet.weight} ${gymSet.unit}",
                        style: const TextStyle(fontSize: 16)),
                    selected: selected.contains(gymSet.id),
                    onLongPress: () {
                      setState(() {
                        selected.add(gymSet.id);
                      });
                    },
                    onTap: () {
                      if (selected.contains(gymSet.id))
                        setState(() {
                          selected.remove(gymSet.id);
                        });
                      else if (selected.isNotEmpty)
                        setState(() {
                          selected.add(gymSet.id);
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

  // Function to check if two DateTime objects represent the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
