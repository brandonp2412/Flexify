import 'package:flexify/app_search.dart';
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

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  late Stream<List<GymSet>> _stream;
  Set<int> _selected = {};
  String _search = '';

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
      body: StreamBuilder<List<GymSet>>(
        stream: _stream,
        builder: (context, snapshot) {
          final filtered = snapshot.data
                  ?.where((gymSet) =>
                      gymSet.name.toLowerCase().contains(_search.toLowerCase()))
                  .toList() ??
              [];

          return material.Column(
            children: [
              AppSearch(
                onChange: (value) {
                  setState(() {
                    _search = value;
                  });
                },
                onClear: () => setState(() {
                  _selected.clear();
                }),
                onDelete: () {
                  (db.delete(db.gymSets)
                        ..where((tbl) => tbl.id.isIn(_selected)))
                      .go();
                  setState(() {
                    _selected.clear();
                  });
                },
                onSelect: () => setState(() {
                  _selected.addAll(filtered.map((gymSet) => gymSet.id));
                }),
                selected: _selected,
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditGymSet(
                            gymSet: snapshot.data!
                                .firstWhere(
                                    (element) => element.id == _selected.first)
                                .toCompanion(false),
                          )),
                ),
              ),
              Expanded(
                child: snapshot.data?.isEmpty == true
                    ? const ListTile(
                        title: Text("No entries yet."),
                        subtitle: Text(
                            "Start inserting data for records to appear here."),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final gymSet = filtered[index];
                          final previousGymSet =
                              index > 0 ? filtered[index - 1] : null;

                          final bool showDivider = previousGymSet != null &&
                              !isSameDay(
                                  gymSet.created, previousGymSet.created);

                          return material.Column(
                            children: [
                              if (showDivider) const Divider(),
                              ListTile(
                                title: Text(gymSet.name),
                                subtitle: Text(
                                    DateFormat(settings.longDateFormat)
                                        .format(gymSet.created)),
                                trailing: Text(
                                    gymSet.cardio
                                        ? "${gymSet.distance}${gymSet.unit} / ${gymSet.duration}"
                                        : "${gymSet.reps} x ${gymSet.weight} ${gymSet.unit}",
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
                                          builder: (context) => EditGymSet(
                                              gymSet:
                                                  gymSet.toCompanion(false)),
                                        ));
                                },
                              ),
                            ],
                          );
                        },
                      ),
              ),
              if (!snapshot.hasData) const SizedBox(),
              if (snapshot.hasError) ErrorWidget(snapshot.error.toString()),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditGymSet(
                gymSet: GymSetsCompanion.insert(
                  name: '',
                  reps: 0,
                  created: DateTime.now(),
                  unit: 'kg',
                  weight: 0,
                  bodyWeight: const Value(0),
                  cardio: const Value(false),
                  duration: const Value(0),
                  distance: const Value(0),
                  hidden: const Value(false),
                ),
              ),
            ),
          );
        },
        tooltip: 'Add gym set',
        child: const Icon(Icons.add),
      ),
    );
  }
}
