import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditGraphPage extends StatefulWidget {
  final String name;

  const EditGraphPage({required this.name, super.key});

  @override
  createState() => _EditGraphPageState();
}

class _EditGraphPageState extends State<EditGraphPage> {
  late final TextEditingController nameController =
      TextEditingController(text: widget.name);
  final TextEditingController minutesController = TextEditingController();
  final TextEditingController secondsController = TextEditingController();

  bool? cardio;
  String? unit;
  String? image;
  String? category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update all ${widget.name.toLowerCase()}"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: "New name"),
              textCapitalization: TextCapitalization.sentences,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minutesController,
                    textInputAction: TextInputAction.next,
                    decoration:
                        const InputDecoration(labelText: "Rest minutes"),
                    keyboardType: material.TextInputType.number,
                    onTap: () => selectAll(minutesController),
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: TextField(
                    controller: secondsController,
                    textInputAction: TextInputAction.next,
                    decoration:
                        const InputDecoration(labelText: "Rest seconds"),
                    keyboardType: material.TextInputType.number,
                    onTap: () {
                      selectAll(secondsController);
                    },
                  ),
                ),
              ],
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Category'),
              value: category,
              items: categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Unit'),
              value: unit,
              items: const [
                DropdownMenuItem(
                  value: 'kg',
                  child: Text("kg"),
                ),
                DropdownMenuItem(
                  value: 'lb',
                  child: Text("lb"),
                ),
                DropdownMenuItem(
                  value: 'km',
                  child: Text("km"),
                ),
                DropdownMenuItem(
                  value: 'mi',
                  child: Text("mi"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  unit = value!;
                });
              },
            ),
            if (cardio != null)
              ListTile(
                leading: cardio!
                    ? const Icon(Icons.sports_gymnastics)
                    : const Icon(Icons.fitness_center),
                title: cardio! ? const Text('Cardio') : const Text('Strength'),
                onTap: () {
                  setState(() {
                    cardio = !cardio!;
                    if (cardio!)
                      unit = unit == 'kg' ? 'km' : 'mi';
                    else
                      unit = unit == 'km' ? 'kg' : 'lb';
                  });
                },
                trailing: Switch(
                  value: cardio!,
                  onChanged: (value) => setState(() {
                    cardio = value;
                  }),
                ),
              ),
            Selector<SettingsState, bool>(
              builder: (context, showImages, child) {
                return Visibility(
                  visible: showImages,
                  child: material.Column(
                    children: [
                      if (image == null)
                        TextButton.icon(
                          onPressed: pick,
                          label: const Text('Image'),
                          icon: const Icon(Icons.image),
                        ),
                      if (image != null) ...[
                        const SizedBox(height: 8),
                        Tooltip(
                          message: 'Long-press to delete',
                          child: GestureDetector(
                            onTap: () => pick(),
                            onLongPress: () => setState(() {
                              image = null;
                            }),
                            child: Image.file(
                              File(image!),
                              errorBuilder: (context, error, stackTrace) =>
                                  TextButton.icon(
                                label: const Text('Image error'),
                                icon: const Icon(Icons.error),
                                onPressed: () => pick(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
              selector: (context, settings) => settings.value.showImages,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: save,
        tooltip: "Update all records for this exercise",
        child: const Icon(Icons.save),
      ),
    );
  }

  @override
  dispose() {
    nameController.dispose();
    minutesController.dispose();
    secondsController.dispose();
    super.dispose();
  }

  Future<void> doUpdate() async {
    final minutes = int.tryParse(minutesController.text);
    final seconds = int.tryParse(secondsController.text);

    Duration? duration;
    if (minutes != null && minutes > 0 || seconds != null && seconds > 0)
      duration = Duration(
        minutes: minutes ?? 0,
        seconds: seconds ?? 0,
      );

    await (db.gymSets.update()..where((tbl) => tbl.name.equals(widget.name)))
        .write(
      GymSetsCompanion(
        name: nameController.text.isEmpty
            ? const Value.absent()
            : Value(nameController.text),
        cardio: Value.absentIfNull(cardio),
        unit: Value.absentIfNull(unit),
        restMs: Value(duration?.inMilliseconds),
        image: Value.absentIfNull(image),
        category: Value.absentIfNull(category),
      ),
    );

    await db.customUpdate(
      'UPDATE plans SET exercises = REPLACE(exercises, ?, ?)',
      variables: [
        Variable.withString(widget.name),
        Variable.withString(nameController.text),
      ],
      updates: {db.plans},
    );

    if (!mounted) return;
    context.read<PlanState>().updatePlans(null);
  }

  Future<int> getCount() async {
    final result = await (db.gymSets.selectOnly()
          ..addColumns([db.gymSets.name.count()])
          ..where(db.gymSets.name.equals(nameController.text)))
        .getSingle();
    return result.read(db.gymSets.name.count()) ?? 0;
  }

  @override
  void initState() {
    super.initState();

    (db.gymSets.select()
          ..where((tbl) => tbl.name.equals(widget.name))
          ..limit(1))
        .getSingle()
        .then(
          (gymSet) => setState(() {
            image = gymSet.image;
            cardio = gymSet.cardio;
            category = gymSet.category;

            if (gymSet.restMs != null) {
              final duration = Duration(milliseconds: gymSet.restMs!);
              minutesController.text = duration.inMinutes.toString();
              secondsController.text = (duration.inSeconds % 60).toString();
            }
          }),
        );
  }

  Future<bool> mixedUnits() async {
    final result = await (db.gymSets.selectOnly(distinct: true)
          ..addColumns([db.gymSets.unit])
          ..where(db.gymSets.name.equals(nameController.text)))
        .get();
    return result.length > 1;
  }

  void pick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result?.files.single == null) return;

    setState(() {
      image = result?.files.single.path;
    });
  }

  save() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty.')),
      );
      Navigator.pop(context);
      return;
    }

    final count = await getCount();

    if (count > 0 && widget.name != nameController.text && mounted)
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update conflict'),
            content: Text(
              'Your new name exists already for $count records. Are you sure?',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () async {
                  Navigator.pop(context);
                  await doUpdate();
                },
              ),
            ],
          );
        },
      );
    else if (unit != null && await mixedUnits() && mounted)
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Units conflict'),
            content: const Text(
              'Not all of your records are the same unit. Are you sure?',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () async {
                  Navigator.pop(context);
                  await doUpdate();
                },
              ),
            ],
          );
        },
      );
    else
      await doUpdate();

    if (!mounted) return;
    Navigator.pop(context);
  }
}
