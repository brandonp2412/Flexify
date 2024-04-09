import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart';
import 'package:flexify/add_exercise_page.dart';
import 'package:flexify/enter_weight_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_page.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';

import 'graph_tile.dart';

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  Stream<List<drift.TypedResult>>? stream;
  TextEditingController searchController = TextEditingController();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Set<String> selected = {};

  @override
  void initState() {
    super.initState();

    stream = (db.gymSets.selectOnly()
          ..addColumns([
            db.gymSets.name,
            db.gymSets.unit,
            db.gymSets.weight.max(),
            db.gymSets.created.max()
          ])
          ..orderBy([
            drift.OrderingTerm(
                expression: db.gymSets.created.max(),
                mode: drift.OrderingMode.desc)
          ])
          ..groupBy([db.gymSets.name]))
        .watch();
  }

  void setStream(drift.OrderingTerm term) async {
    setState(() {});
  }

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
          builder: (context) => graphsPage(),
          settings: settings,
        ),
      ),
    );
  }

  Scaffold graphsPage() {
    return Scaffold(
      body: StreamBuilder<List<drift.TypedResult>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          if (snapshot.hasError) return ErrorWidget(snapshot.error.toString());
          final gymSets = snapshot.data!;

          final filteredGymSets = gymSets.where((gymSet) {
            final name = gymSet.read(db.gymSets.name)!.toLowerCase();
            final searchText = searchController.text.toLowerCase();
            return name.contains(searchText);
          }).toList();

          PopupMenuItem<dynamic> selectAll(BuildContext context) {
            return PopupMenuItem(
              child: ListTile(
                leading: const Icon(Icons.done_all),
                title: const Text('Select all'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final names =
                      filteredGymSets.map((e) => e.read(db.gymSets.name)!);
                  setState(() {
                    selected.addAll(names);
                  });
                },
              ),
            );
          }

          return material.Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchBar(
                  hintText: selected.isEmpty
                      ? "Search..."
                      : "${selected.length} selected",
                  controller: searchController,
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.only(right: 8.0),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                  leading: selected.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 8.0),
                          child: Icon(Icons.search))
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              selected.clear();
                            });
                          },
                          icon: const Icon(Icons.arrow_back),
                          padding: EdgeInsets.zero,
                        ),
                  trailing: [
                    if (selected.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: Text(
                                    'Are you sure you want to delete ${selected.length} gym sets? This action is not reversible.'),
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
                                      await (db.delete(db.gymSets)
                                            ..where((tbl) =>
                                                tbl.name.isIn(selected)))
                                          .go();
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Deleted ${selected.length} gym sets.')),
                                      );
                                      setState(() {
                                        selected.clear();
                                      });
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        if (selected.isEmpty) enterWeight(context),
                        selectAll(context),
                        settingsPage(context)
                      ],
                    ),
                  ],
                ),
              ),
              if (snapshot.data?.isEmpty == true)
                const ListTile(
                  title: Text("No data yet."),
                  subtitle: Text(
                      "Complete plans for your progress graphs to appear here."),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredGymSets.length,
                  itemBuilder: (context, index) {
                    final gymSet = filteredGymSets[index];
                    final previousGymSet =
                        index > 0 ? filteredGymSets[index - 1] : null;

                    final name = gymSet.read(db.gymSets.name)!;
                    final weight = gymSet.read(db.gymSets.weight.max())!;
                    final unit = gymSet.read(db.gymSets.unit)!;
                    final created = gymSet.read(db.gymSets.created.max())!;
                    final previousCreated =
                        previousGymSet?.read(db.gymSets.created.max())!;

                    final showDivider = previousCreated != null &&
                        !isSameDay(previousCreated, created);

                    return material.Column(
                      children: [
                        if (showDivider) const Divider(),
                        GraphTile(
                          selected: selected,
                          name: name,
                          weight: weight,
                          unit: unit,
                          created: created,
                          onSelect: (value) {
                            if (selected.contains(value))
                              setState(() {
                                selected.remove(value);
                              });
                            else
                              setState(() {
                                selected.add(value);
                              });
                          },
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddExercisePage(),
            ),
          );
        },
        tooltip: 'Add exercise',
        child: const Icon(Icons.add),
      ),
    );
  }

  PopupMenuItem<dynamic> settingsPage(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        },
      ),
    );
  }

  PopupMenuItem<dynamic> enterWeight(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.scale),
        title: const Text('Weight'),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EnterWeightPage()),
          );
        },
      ),
    );
  }
}
