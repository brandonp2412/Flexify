import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditSetPage extends StatefulWidget {
  final GymSet gymSet;

  const EditSetPage({super.key, required this.gymSet});

  @override
  createState() => _EditSetPageState();
}

class _EditSetPageState extends State<EditSetPage> {
  final repsController = TextEditingController();
  final weightController = TextEditingController();
  final bodyWeightController = TextEditingController();
  final distanceController = TextEditingController();
  final minutesController = TextEditingController();
  final secondsController = TextEditingController();
  final inclineController = TextEditingController();
  final repsNode = FocusNode();

  late String unit;
  late DateTime created;
  late bool cardio;
  late String name;
  int? restMs;
  String? image;

  TextEditingController? nameController;
  List<String> nameOptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.gymSet.id > 0 ? widget.gymSet.name : 'Add set',
        ),
        actions: [
          if (widget.gymSet.id > 0)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: Text(
                        'Are you sure you want to delete ${widget.gymSet.name}?',
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            await db.delete(db.gymSets).delete(widget.gymSet);
                            if (context.mounted) Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Autocomplete<String>(
              optionsBuilder: (textEditingValue) {
                return nameOptions.where(
                  (option) => option
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()),
                );
              },
              onSelected: (option) async {
                final last = await (db.gymSets.select()
                      ..where((tbl) => tbl.name.equals(option))
                      ..limit(1))
                    .getSingleOrNull();
                if (last == null) return;

                if (!context.mounted) return;
                final hideWeight = context.select<SettingsState, bool>(
                  (value) => value.hideWeight,
                );

                if (hideWeight)
                  updateFields(
                    last.copyWith(
                      created: DateTime.now().toLocal(),
                    ),
                  );
                else {
                  final bodyWeight = await getBodyWeight();
                  updateFields(
                    last.copyWith(
                      bodyWeight: bodyWeight?.weight,
                      created: DateTime.now().toLocal(),
                    ),
                  );
                }
                repsNode.requestFocus();
                selectAll(repsController);
              },
              initialValue: TextEditingValue(text: name),
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                nameController = textEditingController;
                return TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: textEditingController,
                  textInputAction: TextInputAction.next,
                  onTap: () {
                    selectAll(textEditingController);
                  },
                  focusNode: focusNode,
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                  onChanged: (value) => setState(() {
                    name = value;
                  }),
                );
              },
            ),
            if (cardio) ...[
              TextField(
                controller: distanceController,
                decoration: const InputDecoration(labelText: 'Distance'),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(distanceController),
                textInputAction: TextInputAction.next,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: minutesController,
                      decoration: const InputDecoration(labelText: 'Minutes'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      onTap: () => selectAll(minutesController),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: secondsController,
                      decoration: const InputDecoration(labelText: 'Seconds'),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      onTap: () => selectAll(secondsController),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: inclineController,
                decoration: const InputDecoration(labelText: 'Incline'),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(inclineController),
              ),
            ],
            if (!cardio) ...[
              TextField(
                controller: repsController,
                focusNode: repsNode,
                decoration: const InputDecoration(labelText: 'Reps'),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(repsController),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => selectAll(weightController),
              ),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: name == 'Weight' ? 'Value ' : 'Weight ',
                ),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(weightController),
                textInputAction: TextInputAction.next,
              ),
            ],
            Selector<SettingsState, bool>(
              builder: (context, hideWeight, child) => Visibility(
                visible: !hideWeight,
                child: TextField(
                  controller: bodyWeightController,
                  decoration: const InputDecoration(
                    labelText: 'Body weight during set ',
                  ),
                  keyboardType: TextInputType.number,
                  onTap: () => selectAll(bodyWeightController),
                ),
              ),
              selector: (p0, p1) => p1.hideWeight,
            ),
            Selector<SettingsState, bool>(
              builder: (context, showUnits, child) => Visibility(
                visible: showUnits,
                child: UnitSelector(
                  value: unit,
                  onChanged: (String? newValue) {
                    setState(() {
                      unit = newValue!;
                    });
                  },
                  cardio: cardio,
                ),
              ),
              selector: (p0, p1) => p1.showUnits,
            ),
            Selector<SettingsState, String>(
              builder: (context, longDateFormat, child) => ListTile(
                title: const Text('Created date'),
                subtitle: Text(DateFormat(longDateFormat).format(created)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(),
              ),
              selector: (p0, p1) => p1.longDateFormat,
            ),
            Selector<SettingsState, bool>(
              builder: (context, showImages, child) {
                return Visibility(
                  visible: showImages,
                  child: material.Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();
                              setState(() {
                                image = result?.files.single.path;
                              });
                            },
                            label: const Text('Image'),
                            icon: const Icon(Icons.image),
                          ),
                          if (image != null)
                            TextButton.icon(
                              onPressed: () async {
                                setState(() {
                                  image = null;
                                });
                              },
                              label: const Text('Delete'),
                              icon: const Icon(Icons.delete),
                            ),
                        ],
                      ),
                      if (image != null) ...[
                        const SizedBox(height: 8),
                        Image.file(File(image!)),
                      ],
                    ],
                  ),
                );
              },
              selector: (p0, p1) => p1.showImages,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: save,
        tooltip: "Save",
        child: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    repsController.dispose();
    repsNode.dispose();
    weightController.dispose();
    bodyWeightController.dispose();
    distanceController.dispose();
    minutesController.dispose();
    inclineController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    updateFields(widget.gymSet);
    (db.gymSets.selectOnly(distinct: true)..addColumns([db.gymSets.name]))
        .get()
        .then((results) {
      final names = results.map((result) => result.read(db.gymSets.name)!);
      setState(() {
        nameOptions = names.toList();
      });
    });
  }

  Future<void> selectTime(DateTime pickedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(created),
    );

    if (pickedTime != null) {
      setState(() {
        created = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  void updateFields(GymSet gymSet) {
    nameController?.text = gymSet.name;

    setState(() {
      image = gymSet.image;
      name = gymSet.name;
      repsController.text = toString(gymSet.reps);
      weightController.text = toString(gymSet.weight);
      bodyWeightController.text = toString(gymSet.bodyWeight);
      minutesController.text = gymSet.duration.floor().toString();
      secondsController.text = ((gymSet.duration * 60) % 60).floor().toString();
      distanceController.text = toString(gymSet.distance);
      unit = gymSet.unit;
      created = gymSet.created;
      cardio = gymSet.cardio;
      restMs = gymSet.restMs;
      inclineController.text = gymSet.incline?.toString() ?? "";
    });
  }

  Future<void> save() async {
    Navigator.pop(context);
    final minutes = int.tryParse(minutesController.text);
    final seconds = int.tryParse(secondsController.text);
    final duration = (seconds ?? 0) / 60 + (minutes ?? 0);

    final gymSet = widget.gymSet.copyWith(
      name: name,
      unit: unit,
      created: created,
      reps: double.tryParse(repsController.text),
      weight: double.tryParse(weightController.text),
      bodyWeight: double.tryParse(bodyWeightController.text),
      distance: double.tryParse(distanceController.text),
      duration: duration,
      cardio: cardio,
      restMs: Value(restMs),
      incline: Value(int.tryParse(inclineController.text)),
      image: Value(image),
    );

    if (widget.gymSet.id > 0)
      db.update(db.gymSets).replace(gymSet);
    else {
      var insert = gymSet.toCompanion(false).copyWith(id: const Value.absent());
      db.into(db.gymSets).insert(insert);
      final settings = context.read<SettingsState>();
      if (!settings.restTimers || !platformSupportsTimer()) return;
      final timer = context.read<TimerState>();
      if (restMs != null)
        timer.startTimer(
          name,
          Duration(milliseconds: restMs!),
          settings.alarmSound,
          settings.vibrate,
        );
      else
        timer.startTimer(
          name,
          settings.timerDuration,
          settings.alarmSound,
          settings.vibrate,
        );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: created,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      selectTime(pickedDate);
    }
  }
}
