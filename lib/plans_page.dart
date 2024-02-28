import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:flexify/constants.dart';
import 'package:flexify/database.dart';
import 'package:flexify/edit_plan_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/enter_weight_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'plan_tile.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({Key? key}) : super(key: key);

  @override
  createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  late Stream<List<Plan>> planStream;
  late Stream<List<drift.TypedResult>> countStream;
  TextEditingController searchController = TextEditingController();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    planStream = database.select(database.plans).watch();
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));
    countStream = (database.selectOnly(database.gymSets)
          ..addColumns([
            database.gymSets.name.count(),
            database.gymSets.name,
          ])
          ..where(database.gymSets.created.isBiggerOrEqualValue(startOfToday))
          ..where(database.gymSets.created.isSmallerThanValue(startOfTomorrow))
          ..groupBy([database.gymSets.name]))
        .watch();
  }

  @override
  Widget build(BuildContext context) {
    final weekday = weekdays[DateTime.now().weekday - 1];
    return NavigatorPopHandler(
      onPop: () {
        if (navigatorKey.currentState!.canPop() == false) return;
        Provider.of<ExerciseSelectionModel>(context, listen: false)
            .selectExercise("");
        navigatorKey.currentState!.pop();
      },
      child: Navigator(
          key: navigatorKey,
          onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => plansPage(weekday, context),
                settings: settings,
              )),
    );
  }

  Scaffold plansPage(String weekday, BuildContext context) {
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
                          enterWeight(context),
                          exportCsv(context),
                          uploadCsv(context),
                          deleteAll(context),
                        ],
                      )
                    ],
            ),
          ),
          StreamBuilder<List<Plan>>(
            stream: planStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              if (snapshot.hasError)
                return ErrorWidget(snapshot.error.toString());
              final plans = snapshot.data!;
              final filtered = plans
                  .where((element) =>
                      element.days
                          .toLowerCase()
                          .contains(searchController.text) ||
                      element.exercises
                          .toLowerCase()
                          .contains(searchController.text))
                  .toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final plan = filtered[index];
                    return PlanTile(
                      plan: plan,
                      weekday: weekday,
                      index: index,
                      countStream: countStream,
                      navigatorKey: navigatorKey,
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const EditPlanPage(
                    plan: PlansCompanion(
                        days: drift.Value(''), exercises: drift.Value('')))),
          );
        },
        tooltip: 'Add plan',
        child: const Icon(Icons.add),
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
                    'Are you sure you want to delete all plans? This action is not reversible.'),
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
                      await database.delete(database.plans).go();
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
          final plans = fields.map(
            (row) => PlansCompanion(
              days: drift.Value(row[1]),
              exercises: drift.Value(row[2]),
            ),
          );
          await database.batch(
            (batch) => batch.insertAll(database.plans, plans),
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

          final plans = await database.plans.select().get();
          final List<List<dynamic>> csvData = [
            ['id', 'days', 'exercises']
          ];
          for (var plan in plans) {
            csvData.add([plan.id, plan.days, plan.exercises]);
          }

          final file = await writeCsv(csvData, "plans.csv");
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
      'Downloaded plans.csv',
      null,
      platformChannelSpecifics,
      payload: file.path,
    );
  }
}
