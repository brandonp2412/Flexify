import 'package:drift/drift.dart';
import 'package:flexify/app_search.dart';
import 'package:flexify/database.dart';
import 'package:flexify/edit_gym_set.dart';
import 'package:flexify/history_list.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  late Stream<List<GymSet>> _stream;
  Set<int> _selected = {};
  String _search = '';
  int _limit = 10;

  @override
  void initState() {
    super.initState();
    _setStream();
  }

  void _setStream() {
    setState(() {
      _stream = (db.gymSets.select()
            ..orderBy(
              [
                (u) =>
                    OrderingTerm(expression: u.created, mode: OrderingMode.desc)
              ],
            )
            ..where((tbl) => tbl.name.contains(_search.toLowerCase()))
            ..where((tbl) => tbl.hidden.equals(false))
            ..limit(_limit))
          .watch();
    });
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
                  _setStream();
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
                    : HistoryList(
                        gymSets: filtered,
                        onSelect: (id) {
                          if (_selected.contains(id))
                            setState(() {
                              _selected.remove(id);
                            });
                          else if (_selected.isNotEmpty)
                            setState(() {
                              _selected.add(id);
                            });
                        },
                        selected: _selected,
                        onNext: () {
                          setState(() {
                            _limit += 10;
                          });
                          _setStream();
                        }),
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
