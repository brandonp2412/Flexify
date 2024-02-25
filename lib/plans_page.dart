import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart' as drift;
import 'package:file_picker/file_picker.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database.dart';
import 'package:flexify/edit_plan_page.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

import 'plan_tile.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({Key? key}) : super(key: key);

  @override
  createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  late Stream<List<Plan>> stream;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    stream = database.select(database.plans).watch();
  }

  @override
  Widget build(BuildContext context) {
    final weekday = weekdays[DateTime.now().weekday - 1];
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
          StreamBuilder<List<Plan>>(
            stream: stream,
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
                    final active = plan.days.contains(weekday);
                    return PlanTile(plan: plan, active: active, index: index);
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

  PopupMenuItem<dynamic> deleteAll(BuildContext context) {
    return PopupMenuItem(
      child: ListTile(
        leading: const Icon(Icons.delete),
        title: const Text('Delete all plans'),
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
          final result = await FilePicker.platform.pickFiles(
            type: FileType.any,
          );
          if (result == null) return;

          final file = File(result.files.single.path!);
          final input = file.openRead();
          final fields = await input
              .transform(utf8.decoder)
              .transform(const CsvToListConverter(eol: "\r\n"))
              .skip(1)
              .toList();
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
        title: const Text('Export to CSV'),
        onTap: () async {
          Navigator.pop(context);

          final plans = await database.plans.select().get();
          final List<List<dynamic>> csvData = [
            ['id', 'days', 'exercises']
          ];
          for (var plan in plans) {
            csvData.add([plan.id, plan.days, plan.exercises]);
          }

          final result = await FilePicker.platform.getDirectoryPath();
          if (result == null) return;

          final permission = await Permission.manageExternalStorage.request();
          if (!permission.isGranted) return;
          final file = File("$result/plans.csv");
          await file.writeAsString(const ListToCsvConverter().convert(csvData));
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
      'Exported plans.csv',
      null,
      platformChannelSpecifics,
      payload: file.path,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        final file = File(details.payload!);
        await OpenFile.open(file.parent.path);
      },
    );
  }
}
