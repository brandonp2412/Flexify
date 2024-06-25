import 'package:drift/drift.dart';
import 'package:flexify/app_search.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/edit_set_page.dart';
import 'package:flexify/edit_sets_page.dart';
import 'package:flexify/history_collapsed.dart';
import 'package:flexify/history_list.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPop: () {
        if (navigatorKey.currentState!.canPop() == false) return;
        if (navigatorKey.currentState?.focusNode.hasFocus == false) return;
        navigatorKey.currentState!.pop();
      },
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => _HistoryPageWidget(
            navigatorKey: navigatorKey,
          ),
          settings: settings,
        ),
      ),
    );
  }
}

class _HistoryPageWidget extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const _HistoryPageWidget({required this.navigatorKey});

  @override
  createState() => _HistoryPageWidgetState();
}

class HistoryDay {
  final String name;
  final List<GymSet> gymSets;
  final DateTime day;

  HistoryDay({required this.name, required this.gymSets, required this.day});
}

class _HistoryPageWidgetState extends State<_HistoryPageWidget> {
  late Stream<List<GymSet>> _stream;
  Set<int> _selected = {};
  String _search = '';
  int _limit = 100;

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
                (u) => OrderingTerm(
                      expression: u.created,
                      mode: OrderingMode.desc,
                    ),
              ],
            )
            ..where((tbl) => tbl.name.contains(_search.toLowerCase()))
            ..where((tbl) => tbl.hidden.equals(false))
            ..limit(_limit))
          .watch();
    });
  }

  List<HistoryDay> _getHistoryDays(List<GymSet> gymSets) {
    List<HistoryDay> historyDays = [];
    for (final gymSet in gymSets) {
      final day = DateUtils.dateOnly(gymSet.created);
      final index = historyDays
          .indexWhere((hd) => isSameDay(hd.day, day) && hd.name == gymSet.name);
      if (index == -1)
        historyDays.add(
          HistoryDay(name: gymSet.name, gymSets: [gymSet], day: day),
        );
      else
        historyDays[index].gymSets.add(gymSet);
    }
    return historyDays;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> actions = [];

    if (_selected.isNotEmpty)
      actions.add(
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: Text(
                    'Are you sure you want to delete ${_selected.length} records?',
                  ),
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
          icon: const Icon(Icons.delete),
        ),
      );

    return Scaffold(
      body: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          return material.Column(
            children: [
              AppSearch(
                onShare: () async {
                  final gymSets = snapshot.data!
                      .where(
                        (gymSet) => _selected.contains(gymSet.id),
                      )
                      .toList();
                  final summaries = gymSets
                      .map(
                        (gymSet) =>
                            "${toString(gymSet.reps)}x${toString(gymSet.weight)}${gymSet.unit} ${gymSet.name}",
                      )
                      .join(', ');
                  await Share.share("I just did $summaries");
                  setState(() {
                    _selected.clear();
                  });
                },
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
                  if (snapshot.data == null) return;
                  _selected.addAll(snapshot.data!.map((gymSet) => gymSet.id));
                }),
                selected: _selected,
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditSetsPage(
                      ids: _selected.toList(),
                    ),
                  ),
                ),
              ),
              if (snapshot.data?.isEmpty == true)
                const ListTile(
                  title: Text("No entries yet."),
                  subtitle: Text(
                    "Start inserting data for records to appear here.",
                  ),
                ),
              if (snapshot.hasError)
                Expanded(child: ErrorWidget(snapshot.error.toString())),
              if (snapshot.hasData)
                Expanded(
                  child: Builder(
                    builder: (context) {
                      final settings = context.watch<SettingsState>();

                      if (settings.groupHistory) {
                        final historyDays = _getHistoryDays(snapshot.data!);
                        return HistoryCollapsed(
                          historyDays: historyDays,
                          onSelect: (id) {
                            if (_selected.contains(id))
                              setState(() {
                                _selected.remove(id);
                              });
                            else
                              setState(() {
                                _selected.add(id);
                              });
                          },
                          selected: _selected,
                          onNext: () {
                            setState(() {
                              _limit += 100;
                            });
                            _setStream();
                          },
                        );
                      } else
                        return HistoryList(
                          gymSets: snapshot.data!,
                          onSelect: (id) {
                            if (_selected.contains(id))
                              setState(() {
                                _selected.remove(id);
                              });
                            else
                              setState(() {
                                _selected.add(id);
                              });
                          },
                          selected: _selected,
                          onNext: () {
                            setState(() {
                              _limit += 100;
                            });
                            _setStream();
                          },
                        );
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final settings = context.read<SettingsState>();
          final gymSets = await _stream.first;
          var bodyWeight = 0.0;
          if (!settings.hideWeight)
            bodyWeight = (await getBodyWeight())?.weight ?? 0.0;

          GymSet gymSet = gymSets.firstOrNull ??
              GymSet(
                id: 0,
                bodyWeight: bodyWeight,
                restMs: const Duration(minutes: 3, seconds: 30).inMilliseconds,
                name: '',
                reps: 0,
                created: DateTime.now().toLocal(),
                unit: settings.strengthUnit ?? 'kg',
                weight: 0,
                cardio: false,
                duration: 0,
                distance: 0,
                hidden: false,
                maxSets: 3,
              );
          gymSet = gymSet.copyWith(
            id: 0,
            bodyWeight: bodyWeight,
            created: DateTime.now().toLocal(),
          );

          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditSetPage(
                gymSet: gymSet,
              ),
            ),
          );
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
