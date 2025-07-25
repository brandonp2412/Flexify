import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
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
  late final TextEditingController name =
      TextEditingController(text: widget.name);
  final TextEditingController minutes = TextEditingController();
  final TextEditingController seconds = TextEditingController();
  final key = GlobalKey<FormState>();

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
        child: Form(
          key: key,
          child: ListView(
            children: [
              TextField(
                controller: name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: "New name"),
                textCapitalization: TextCapitalization.sentences,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: minutes,
                      textInputAction: TextInputAction.next,
                      decoration:
                          const InputDecoration(labelText: "Rest minutes"),
                      keyboardType: material.TextInputType.number,
                      onTap: () => selectAll(minutes),
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        if (int.tryParse(value) == null)
                          return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: seconds,
                      textInputAction: TextInputAction.next,
                      decoration:
                          const InputDecoration(labelText: "Rest seconds"),
                      keyboardType: material.TextInputType.number,
                      onTap: () {
                        selectAll(seconds);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        if (int.tryParse(value) == null)
                          return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Selector<SettingsState, bool>(
                selector: (p0, settings) => settings.value.showCategories,
                builder: (context, showCategories, child) {
                  if (!showCategories) return const SizedBox();
                  return StreamBuilder(
                    stream: categoriesStream,
                    builder: (context, snapshot) {
                      return DropdownButtonFormField(
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                        value: category,
                        items: snapshot.data
                            ?.map(
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
                      );
                    },
                  );
                },
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Unit'),
                value: unit,
                items: const [
                  DropdownMenuItem(
                    value: '',
                    child: Text(""),
                  ),
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
                  title:
                      cardio! ? const Text('Cardio') : const Text('Strength'),
                  onTap: () {
                    setState(() {
                      cardio = !cardio!;
                      if (unit == null || unit?.isEmpty == true) return;
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: save,
        label: const Text("Update"),
        icon: const Icon(Icons.sync),
      ),
    );
  }

  @override
  dispose() {
    name.dispose();
    minutes.dispose();
    seconds.dispose();
    super.dispose();
  }

  Future<void> doUpdate() async {
    Duration? duration;
    if (int.tryParse(minutes.text) != null && int.tryParse(minutes.text)! > 0 ||
        int.tryParse(seconds.text) != null && int.tryParse(seconds.text)! > 0)
      duration = Duration(
        minutes: int.tryParse(minutes.text) ?? 0,
        seconds: int.tryParse(seconds.text) ?? 0,
      );

    await (db.gymSets.update()..where((tbl) => tbl.name.equals(widget.name)))
        .write(
      GymSetsCompanion(
        name: name.text.isEmpty ? const Value.absent() : Value(name.text),
        cardio: Value.absentIfNull(cardio),
        unit: Value.absentIfNull(unit),
        restMs: Value(duration?.inMilliseconds),
        image: Value(image),
        category: Value.absentIfNull(category),
      ),
    );

    await db.customUpdate(
      'UPDATE plans SET exercises = REPLACE(exercises, ?, ?)',
      variables: [
        Variable.withString(widget.name),
        Variable.withString(name.text),
      ],
      updates: {db.plans},
    );

    if (!mounted) return;
    context.read<PlanState>().updatePlans(null);
  }

  Future<int> getCount() async {
    final result = await (db.gymSets.selectOnly()
          ..addColumns([db.gymSets.name.count()])
          ..where(db.gymSets.name.equals(name.text)))
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
              minutes.text = duration.inMinutes.toString();
              seconds.text = (duration.inSeconds % 60).toString();
            }
          }),
        );
  }

  Future<bool> mixedUnits() async {
    final result = await (db.gymSets.selectOnly(distinct: true)
          ..addColumns([db.gymSets.unit])
          ..where(db.gymSets.name.equals(name.text)))
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
    if (!key.currentState!.validate()) return;

    final count = await getCount();

    if (count > 0 && widget.name != name.text && mounted)
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Update conflict'),
            content: Text(
              'Your new name exists already for $count records. Are you sure?',
            ),
            actions: <Widget>[
              TextButton.icon(
                label: const Text('Cancel'),
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton.icon(
                label: const Text('Confirm'),
                icon: const Icon(Icons.check),
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
            content: Text(
              'Not all of your records have the same unit. This will convert all units to $unit. Are you sure?',
            ),
            actions: <Widget>[
              TextButton.icon(
                label: const Text('Cancel'),
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton.icon(
                label: const Text('Confirm'),
                icon: const Icon(Icons.check),
                onPressed: () async {
                  Navigator.pop(context);
                  await convertUnits();
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
    Navigator.pop(context, name.text);
  }

  Future<void> convertUnits() async {
    if (unit == 'kg')
      await db.customUpdate(
        '''
        UPDATE gym_sets SET weight = weight * 0.45359237, 
          unit = 'kg'
        WHERE name = ? AND unit = 'lb';
      ''',
        updates: {db.gymSets},
        variables: [Variable(widget.name)],
      );
    else if (unit == 'lb')
      await db.customUpdate(
        '''
        UPDATE gym_sets SET weight = weight * 2.20462262, 
          unit = 'lb'
        WHERE name = ? AND unit = 'kg';
      ''',
        updates: {db.gymSets},
        variables: [Variable(widget.name)],
      );
    else if (unit == 'km') {
      await db.customUpdate(
        '''
        UPDATE gym_sets SET weight = weight * 1.609, 
          unit = 'km'
        WHERE name = ? AND unit = 'mi';
      ''',
        updates: {db.gymSets},
        variables: [Variable(widget.name)],
      );
      await db.customUpdate(
        '''
        UPDATE gym_sets SET weight = weight / 1000, 
          unit = 'km'
        WHERE name = ? AND unit = 'm';
      ''',
        updates: {db.gymSets},
        variables: [Variable(widget.name)],
      );
    } else if (unit == 'mi') {
      await db.customUpdate(
        '''
        UPDATE gym_sets SET weight = weight / 1.609, 
          unit = 'mi'
        WHERE name = ? AND unit = 'km';
      ''',
        updates: {db.gymSets},
        variables: [Variable(widget.name)],
      );
      await db.customUpdate(
        '''
        UPDATE gym_sets SET weight = weight / 1609.34, 
          unit = 'mi'
        WHERE name = ? AND unit = 'm';
      ''',
        updates: {db.gymSets},
        variables: [Variable(widget.name)],
      );
    } else if (unit == 'm') {
      await db.customUpdate(
        '''
        UPDATE gym_sets SET weight = weight * 1000, 
          unit = 'm'
        WHERE name = ? AND unit = 'km';
      ''',
        updates: {db.gymSets},
        variables: [Variable(widget.name)],
      );
      await db.customUpdate(
        '''
        UPDATE gym_sets SET weight = weight * 1609.34, 
          unit = 'm'
        WHERE name = ? AND unit = 'mi';
      ''',
        updates: {db.gymSets},
        variables: [Variable(widget.name)],
      );
    }
  }
}
