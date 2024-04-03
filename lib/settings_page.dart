import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class WidgetSettings {
  final String key;
  final Widget widget;

  WidgetSettings({required this.key, required this.widget});
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController minutesController;
  late TextEditingController secondsController;
  final downloadController = MenuController();
  final uploadController = MenuController();
  final deleteController = MenuController();
  final searchController = TextEditingController();

  final List<String> formatOptions = [
    'dd/MM/yy',
    'dd/MM/yy h:mm a',
    'EEE h:mm a',
    'h:mm a',
    'yyyy-MM-dd',
    'yyyy-MM-dd h:mm a',
    'yyyy.MM.dd',
  ];

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsState>();
    minutesController = TextEditingController(
        text: settings.timerDuration.inMinutes.toString());
    secondsController = TextEditingController(
        text: (settings.timerDuration.inSeconds % 60).toString());
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();
    List<WidgetSettings> children = [
      WidgetSettings(
        key: 'theme',
        widget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField(
            value: settings.themeMode,
            decoration: const InputDecoration(
              labelStyle: TextStyle(),
              labelText: 'Theme',
            ),
            items: const [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text("System"),
              ),
              DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text("Dark"),
              ),
              DropdownMenuItem(
                value: ThemeMode.light,
                child: Text("Light"),
              ),
            ],
            onChanged: (value) async => await settings.setTheme(value!),
          ),
        ),
      ),
      WidgetSettings(
        key: 'rest minutes seconds',
        widget: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: material.Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration:
                          const InputDecoration(labelText: 'Rest minutes'),
                      controller: minutesController,
                      keyboardType: TextInputType.number,
                      onTap: () async {
                        minutesController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: minutesController.text.length,
                        );
                      },
                      onChanged: (value) async => await settings.setDuration(
                        Duration(
                          minutes: int.parse(value),
                          seconds: settings.timerDuration.inSeconds % 60,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: TextField(
                      decoration:
                          const InputDecoration(labelText: 'Rest seconds'),
                      controller: secondsController,
                      keyboardType: TextInputType.number,
                      onTap: () async {
                        secondsController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: secondsController.text.length,
                        );
                      },
                      onChanged: (value) async => await settings.setDuration(
                        Duration(
                          seconds: int.parse(value),
                          minutes: settings.timerDuration.inMinutes.floor(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      WidgetSettings(
          key: 'date format',
          widget: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: DropdownButtonFormField<String>(
              value: settings.dateFormat,
              items: formatOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                settings.setFormat(newValue!);
              },
              decoration: InputDecoration(
                labelText: 'Date format',
                helperText:
                    'Current date: ${DateFormat(settings.dateFormat).format(DateTime.now())}',
              ),
            ),
          )),
      WidgetSettings(
        key: 'rest timers',
        widget: ListTile(
          title: const Text('Rest timers'),
          onTap: () async => await settings.setTimers(!settings.restTimers),
          trailing: Switch(
            value: settings.restTimers,
            onChanged: (value) async => await settings.setTimers(value),
          ),
        ),
      ),
      WidgetSettings(
        key: 'reorder items',
        widget: ListTile(
          title: const Text('Re-order items'),
          onTap: () async => await settings.setReorder(!settings.showReorder),
          trailing: Switch(
            value: settings.showReorder,
            onChanged: (value) async => await settings.setReorder(value),
          ),
        ),
      ),
      WidgetSettings(
        key: 'show units',
        widget: ListTile(
          title: const Text('Show units'),
          onTap: () async => await settings.setUnits(!settings.showUnits),
          trailing: Switch(
            value: settings.showUnits,
            onChanged: (value) async => await settings.setUnits(value),
          ),
        ),
      ),
      WidgetSettings(
        key: 'system color',
        widget: ListTile(
          title: const Text('System color scheme'),
          onTap: () async => await settings.setSystem(!settings.systemColors),
          trailing: Switch(
            value: settings.systemColors,
            onChanged: (value) async => await settings.setSystem(value),
          ),
        ),
      ),
      WidgetSettings(
          key: 'download csv',
          widget: TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: <Widget>[
                        ListTile(
                            leading: const Icon(Icons.insights),
                            title: const Text('Gym sets'),
                            onTap: () async {
                              Navigator.pop(context);
                              final gymSets = await db.gymSets.select().get();
                              final List<List<dynamic>> csvData = [
                                [
                                  'id',
                                  'name',
                                  'reps',
                                  'weight',
                                  'created',
                                  'unit'
                                ]
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

                              if (!await requestNotificationPermission())
                                return;
                              final csv = const ListToCsvConverter(eol: "\n")
                                  .convert(csvData);
                              android
                                  .invokeMethod('save', ['gym_sets.csv', csv]);
                            }),
                        ListTile(
                          leading: const Icon(Icons.event),
                          title: const Text('Plans'),
                          onTap: () async {
                            Navigator.of(context).pop();
                            final plans = await db.plans.select().get();
                            final List<List<dynamic>> csvData = [
                              ['id', 'days', 'exercises']
                            ];
                            for (var plan in plans) {
                              csvData.add([plan.id, plan.days, plan.exercises]);
                            }

                            if (!await requestNotificationPermission()) return;
                            final csv = const ListToCsvConverter(eol: "\n")
                                .convert(csvData);
                            android.invokeMethod('save', ['plans.csv', csv]);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Download CSV'))),
      WidgetSettings(
          key: 'upload csv',
          widget: TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.insights),
                          title: const Text('Gym sets'),
                          onTap: () async {
                            Navigator.pop(context);
                            String csv = await android.invokeMethod('read');
                            List<List<dynamic>> rows =
                                const CsvToListConverter(eol: "\n")
                                    .convert(csv);
                            if (rows.isEmpty) return;
                            try {
                              final gymSets = rows.map(
                                (row) => GymSetsCompanion(
                                  name: Value(row[1]),
                                  reps: Value(row[2]),
                                  weight: Value(row[3]),
                                  created: Value(parseDate(row[4])),
                                  unit: Value(row[5]),
                                ),
                              );
                              await db.batch(
                                (batch) => batch.insertAll(db.gymSets, gymSets),
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Uploaded gym sets.')),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Failed to upload csv.')),
                              );
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.event),
                          title: const Text('Plans'),
                          onTap: () async {
                            Navigator.of(context).pop();
                            String csv = await android.invokeMethod('read');
                            List<List<dynamic>> rows =
                                const CsvToListConverter(eol: "\n")
                                    .convert(csv);
                            if (rows.isEmpty) return;
                            try {
                              final plans = rows.map(
                                (row) => PlansCompanion(
                                  days: Value(row[1]),
                                  exercises: Value(row[2]),
                                  title: Value(row.elementAtOrNull(3)),
                                ),
                              );
                              await db.batch(
                                (batch) => batch.insertAll(db.plans, plans),
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Uploaded plans.')),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              debugPrint(e.toString());
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Failed to upload csv.')),
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.upload),
              label: const Text('Upload CSV'))),
      WidgetSettings(
          key: 'delete records',
          widget: TextButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.insights),
                          title: const Text('Gym sets'),
                          onTap: () async {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text(
                                      'Are you sure you want to delete all gym sets? This action is not reversible.'),
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
                                        await db.delete(db.gymSets).go();
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Deleted all gym sets.')),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.event),
                          title: const Text('Plans'),
                          onTap: () async {
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
                                        await db.delete(db.plans).go();
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Deleted all plans.')),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete records'))),
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
                SearchBar(
                  hintText: "Search...",
                  controller: searchController,
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  onChanged: (_) {
                    setState(() {});
                  },
                  leading: const Icon(Icons.search),
                )
              ] +
              children
                  .where((element) =>
                      element.key.contains(searchController.text.toLowerCase()))
                  .map((e) => e.widget)
                  .toList(),
        ),
      ),
    );
  }
}
