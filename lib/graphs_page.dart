import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/view_graph_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'graph_tile.dart';

class GraphsPage extends StatefulWidget {
  const GraphsPage({Key? key}) : super(key: key);

  @override
  createState() => _GraphsPageState();
}

class _GraphsPageState extends State<GraphsPage> {
  late Stream<List<drift.TypedResult>> stream;
  TextEditingController searchController = TextEditingController();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    stream = (database.gymSets.selectOnly(distinct: true)
          ..addColumns([database.gymSets.name, database.gymSets.weight.max()])
          ..groupBy([database.gymSets.name]))
        .watch();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciseSelectionModel>(
      builder: (context, value, child) {
        if (value.selectedExercise?.isNotEmpty == true)
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                  builder: (context) => ViewGraphPage(
                        name: value.selectedExercise!,
                      )),
            );
          });

        return NavigatorPopHandler(
          onPop: () {
            navigatorKey.currentState!.pop();
          },
          child: Navigator(
            key: navigatorKey,
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => graphsPage(), settings: settings),
          ),
        );
      },
    );
  }

  Scaffold graphsPage() {
    return Scaffold(
      body: Column(
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
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          exportCsv(context),
                          uploadCsv(context),
                          deleteAll(context),
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
              final gymSets = snapshot.data!;

              final filteredGymSets = gymSets.where((gymSet) {
                final name = gymSet.read(database.gymSets.name)!.toLowerCase();
                final searchText = searchController.text.toLowerCase();
                return name.contains(searchText);
              }).toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: filteredGymSets.length,
                  itemBuilder: (context, index) {
                    final gymSet = filteredGymSets[index];
                    final name = gymSet.read(database.gymSets.name)!;
                    final weight = gymSet.read(database.gymSets.weight.max())!;
                    return GraphTile(
                      gymSetName: name,
                      weight: weight,
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }

  PopupMenuItem<dynamic> deleteAll(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.delete),
        title: const Text('Delete all'),
        onTap: () {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Delete'),
                content: const Text(
                    'Are you sure you want to delete all records? This action is not reversible.'),
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
                      await database.delete(database.gymSets).go();
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

  PopupMenuItem<dynamic> uploadCsv(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.upload),
        title: const Text('Upload CSV'),
        onTap: () async {
          Navigator.pop(context);
          final fields = await readCsv();
          if (fields.isEmpty) return;
          final gymSets = fields.map(
            (row) => GymSetsCompanion(
              name: drift.Value(row[1]),
              reps: drift.Value(row[2]),
              weight: drift.Value(row[3]),
              created: drift.Value(parseDate(row[4])),
              unit: drift.Value(row[5]),
            ),
          );
          await database.batch(
            (batch) => batch.insertAll(database.gymSets, gymSets),
          );
        },
      ),
    );
  }

  PopupMenuItem<dynamic> exportCsv(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.download),
        title: const Text('Download CSV'),
        onTap: () async {
          Navigator.pop(context);

          final gymSets = await database.gymSets.select().get();
          final List<List<dynamic>> csvData = [
            ['id', 'name', 'reps', 'weight', 'created', 'unit']
          ];
          for (var gymSet in gymSets) {
            csvData.add([
              gymSet.id,
              gymSet.name,
              gymSet.reps,
              gymSet.weight,
              gymSet.created.toIso8601String(),
              gymSet.unit,
            ]);
          }

          final file = await writeCsv(csvData, "gym_sets.csv");
          postNotification(file);
        },
      ),
    );
  }

  void postNotification(File file) async {
    final permission = await Permission.notification.request();
    if (!permission.isGranted) return;
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const android =
        AndroidInitializationSettings('@drawable/baseline_arrow_downward_24');
    const initializationSettings = InitializationSettings(android: android);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'downloads',
      'Downloads',
    );
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Downloaded gym_sets.csv',
      null,
      platformChannelSpecifics,
      payload: file.path,
    );
  }
}
