import 'package:drift/drift.dart' as drift;
import 'package:drift/drift.dart';
import 'package:flexify/add_exercise_page.dart';
import 'package:flexify/enter_weight_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/timer_page.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'graph_tile.dart';

class GraphsPage extends StatefulWidget {
  const GraphsPage({super.key});

  @override
  createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  Stream<List<drift.TypedResult>>? stream;
  TextEditingController searchController = TextEditingController();
  String orderBy = 'name';
  String orderDir = 'asc';
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) async {
      final expressionString = prefs.getString('graphsOrderBy');
      final modeString = prefs.getString('graphsOrderDir');
      drift.Expression expression = db.gymSets.name;
      drift.OrderingMode mode = drift.OrderingMode.asc;
      if (expressionString == 'weight')
        expression = db.gymSets.weight.max();
      else if (expressionString == 'created')
        expression = db.gymSets.created.max();
      if (modeString == 'desc') mode = drift.OrderingMode.desc;
      setStream(drift.OrderingTerm(expression: expression, mode: mode));
    });
  }

  void setStream(drift.OrderingTerm term) async {
    setState(() {
      stream = (db.gymSets.selectOnly()
            ..addColumns([
              db.gymSets.name,
              db.gymSets.unit,
              db.gymSets.weight.max(),
              db.gymSets.created.max()
            ])
            ..orderBy([term])
            ..groupBy([db.gymSets.name]))
          .watch();
    });
    SharedPreferences.getInstance().then((prefs) {
      var graphsOrderBy = 'name';
      var graphsOrderDir = 'asc';
      if (term.expression == db.gymSets.weight.max())
        graphsOrderBy = 'weight';
      else if (term.expression == db.gymSets.created.max())
        graphsOrderBy = 'created';
      if (term.mode == drift.OrderingMode.desc) graphsOrderDir = 'desc';
      prefs.setString('graphsOrderBy', graphsOrderBy);
      prefs.setString('graphsOrderDir', graphsOrderDir);
      setState(() {
        orderBy = graphsOrderBy;
        orderDir = graphsOrderDir;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler(
      onPop: () {
        if (navigatorKey.currentState!.canPop() == false) return;
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
      body: material.Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              hintText: "Search...",
              controller: searchController,
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onChanged: (_) {
                setState(() {});
              },
              leading: const Icon(Icons.search),
              trailing: searchController.text.isNotEmpty
                  ? [
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                      )
                    ]
                  : [
                      PopupMenuButton(
                        icon: const Icon(Icons.sort),
                        itemBuilder: (context) => [
                          createdDesc(context),
                          nameAsc(context),
                          nameDesc(context),
                          weightAsc(context),
                          weightDesc(context),
                        ],
                      ),
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          enterWeight(context),
                          timer(context),
                        ],
                      )
                    ],
            ),
          ),
          StreamBuilder<List<drift.TypedResult>>(
            stream: stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              if (snapshot.hasError)
                return ErrorWidget(snapshot.error.toString());
              if (snapshot.data?.isEmpty == true)
                return const ListTile(
                  title: Text("No data yet."),
                  subtitle: Text(
                      "Complete plans for your progress graphs to appear here."),
                );
              final gymSets = snapshot.data!;

              final filteredGymSets = gymSets.where((gymSet) {
                final name = gymSet.read(db.gymSets.name)!.toLowerCase();
                final searchText = searchController.text.toLowerCase();
                return name.contains(searchText);
              }).toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: filteredGymSets.length,
                  itemBuilder: (context, index) {
                    final gymSet = filteredGymSets[index];
                    final name = gymSet.read(db.gymSets.name)!;
                    final weight = gymSet.read(db.gymSets.weight.max())!;
                    final unit = gymSet.read(db.gymSets.unit)!;
                    final created = gymSet.read(db.gymSets.created.max())!;
                    return GraphTile(
                        name: name,
                        weight: weight,
                        unit: unit,
                        created: created);
                  },
                ),
              );
            },
          )
        ],
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

  PopupMenuItem<dynamic> timer(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.timer),
        title: const Text('Timer'),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TimerPage()),
          );
        },
      ),
    );
  }

  PopupMenuItem<dynamic> nameAsc(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.text_increase),
        title: const Text('Name asc'),
        selected: orderBy == 'name' && orderDir == 'asc',
        onTap: () {
          Navigator.of(context).pop();
          setStream(drift.OrderingTerm(
              expression: db.gymSets.name, mode: drift.OrderingMode.asc));
        },
      ),
    );
  }

  PopupMenuItem<dynamic> weightAsc(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.scale_outlined),
        title: const Text('Weight asc'),
        selected: orderBy == 'weight' && orderDir == 'asc',
        onTap: () {
          Navigator.of(context).pop();
          setStream(drift.OrderingTerm(
              expression: db.gymSets.weight.max(),
              mode: drift.OrderingMode.asc));
        },
      ),
    );
  }

  PopupMenuItem<dynamic> createdDesc(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.calendar_today),
        title: const Text('Created desc'),
        selected: orderBy == 'created' && orderDir == 'desc',
        onTap: () {
          Navigator.of(context).pop();
          setStream(drift.OrderingTerm(
              expression: db.gymSets.created.max(),
              mode: drift.OrderingMode.desc));
        },
      ),
    );
  }

  PopupMenuItem<dynamic> weightDesc(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.scale),
        title: const Text('Weight desc'),
        selected: orderBy == 'weight' && orderDir == 'desc',
        onTap: () {
          Navigator.of(context).pop();
          setStream(drift.OrderingTerm(
              expression: db.gymSets.weight.max(),
              mode: drift.OrderingMode.desc));
        },
      ),
    );
  }

  PopupMenuItem<dynamic> nameDesc(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.text_decrease),
        title: const Text('Name desc'),
        selected: orderBy == 'name' && orderDir == 'desc',
        onTap: () {
          Navigator.of(context).pop();
          setStream(drift.OrderingTerm(
              expression: db.gymSets.name, mode: drift.OrderingMode.desc));
        },
      ),
    );
  }

  PopupMenuItem<dynamic> createdAsc(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.calendar_today),
        title: const Text('Created asc'),
        selected: orderBy == 'created' && orderDir == 'asc',
        onTap: () {
          Navigator.of(context).pop();
          setStream(drift.OrderingTerm(
              expression: db.gymSets.created.date,
              mode: drift.OrderingMode.asc));
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
