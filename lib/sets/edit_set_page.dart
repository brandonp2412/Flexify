import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/timer/timer_state.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditSetPage extends StatefulWidget {
  final GymSet gymSet;

  const EditSetPage({super.key, required this.gymSet});

  @override
  createState() => _EditSetPageState();
}

class _EditSetPageState extends State<EditSetPage> {
  final reps = TextEditingController();
  final weight = TextEditingController();
  final oneRepMax = TextEditingController();
  final bodyWeight = TextEditingController();
  final distance = TextEditingController();
  final minutes = TextEditingController();
  final seconds = TextEditingController();
  final incline = TextEditingController();
  final notes = TextEditingController();
  final repsNode = FocusNode();
  final distanceNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  late String unit;
  late DateTime created;
  late bool cardio;
  late String name;
  int? restMs;
  String? image;
  String? category;

  TextEditingController? nameController;
  List<String> nameOptions = [];

  void onSelected(String option, bool showBodyWeight) async {
    final last = await (db.gymSets.select()
          ..where((tbl) => tbl.name.equals(option))
          ..orderBy(
            [
              (u) => OrderingTerm(
                    expression: u.created,
                    mode: OrderingMode.desc,
                  ),
            ],
          )
          ..limit(1))
        .getSingleOrNull();
    if (last == null) return;

    if (showBodyWeight)
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

    if (cardio) {
      distanceNode.requestFocus();
      selectAll(distance);
    } else {
      repsNode.requestFocus();
      selectAll(reps);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showBodyWeight = context.select<SettingsState, bool>(
      (settings) => settings.value.showBodyWeight,
    );

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
                        TextButton.icon(
                          label: const Text('Cancel'),
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                        ),
                        TextButton.icon(
                          label: const Text('Delete'),
                          icon: const Icon(Icons.delete),
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
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              autocomplete(showBodyWeight),
              if (!cardio) ...[
                if (name != 'Weight')
                  TextFormField(
                    controller: reps,
                    focusNode: repsNode,
                    decoration: const InputDecoration(labelText: 'Reps'),
                    keyboardType: TextInputType.number,
                    onTap: () => selectAll(reps),
                    onChanged: (value) => setORM(),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => selectAll(weight),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Required';
                      if (double.tryParse(value) == null)
                        return 'Invalid number';
                      return null;
                    },
                  ),
                TextFormField(
                  controller: weight,
                  decoration: InputDecoration(
                    labelText: name == 'Weight' ? 'Value ' : 'Weight ($unit)',
                  ),
                  keyboardType: TextInputType.number,
                  onTap: () => selectAll(weight),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => setORM(),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (double.tryParse(value) == null) return 'Invalid number';
                    return null;
                  },
                ),
                if (widget.gymSet.id > 0 && name != 'Weight')
                  TextField(
                    controller: oneRepMax,
                    decoration: const InputDecoration(
                      labelText: 'One rep max (estimate)',
                    ),
                    enabled: false,
                  ),
              ],
              if (cardio) ...[
                TextFormField(
                  controller: distance,
                  focusNode: distanceNode,
                  decoration: InputDecoration(
                    labelText:
                        unit == 'kcal' ? 'Amount ($unit)' : 'Distance ($unit)',
                  ),
                  keyboardType: TextInputType.number,
                  onTap: () => selectAll(distance),
                  onFieldSubmitted: (value) => selectAll(minutes),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (double.tryParse(value) == null) return 'Invalid number';
                    return null;
                  },
                ),
                duration(),
                TextFormField(
                  controller: incline,
                  decoration: const InputDecoration(labelText: 'Incline %'),
                  keyboardType: TextInputType.number,
                  onTap: () => selectAll(incline),
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (int.tryParse(value) == null) return 'Invalid number';
                    return null;
                  },
                ),
              ],
              Visibility(
                visible: showBodyWeight && name != 'Weight',
                child: TextFormField(
                  controller: bodyWeight,
                  decoration: const InputDecoration(
                    labelText: 'Body weight (during set)',
                  ),
                  keyboardType: TextInputType.number,
                  onTap: () => selectAll(bodyWeight),
                  validator: (value) {
                    if (value == null) return null;
                    if (double.tryParse(value) == null) return 'Invalid number';
                    return null;
                  },
                ),
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
                  ),
                ),
                selector: (context, settings) => settings.value.showUnits,
              ),
              Selector<SettingsState, bool>(
                selector: (p0, settings) => settings.value.showCategories,
                builder: (context, showCategories, child) {
                  if (showCategories && name != 'Weight')
                    return StreamBuilder(
                      stream: categoriesStream,
                      builder: (context, snapshot) {
                        return Autocomplete<String>(
                          initialValue: TextEditingValue(
                            text: widget.gymSet.category ?? "",
                          ),
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (snapshot.data == null) return [];
                            if (textEditingValue.text == '') {
                              return snapshot.data!;
                            }
                            return snapshot.data!.where((String option) {
                              return option.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase(),
                                  );
                            });
                          },
                          onSelected: (String selection) {
                            setState(() {
                              category = selection;
                            });
                          },
                          fieldViewBuilder: (
                            BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted,
                          ) {
                            return TextFormField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                labelText: 'Category',
                              ),
                              onChanged: (value) => setState(() {
                                category = value;
                              }),
                            );
                          },
                        );
                      },
                    );
                  return const SizedBox();
                },
              ),
              Selector<SettingsState, bool>(
                builder: (context, showNotes, child) => Visibility(
                  visible: showNotes,
                  child: TextField(
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Notes'),
                    controller: notes,
                  ),
                ),
                selector: (p0, settingsState) => settingsState.value.showNotes,
              ),
              Selector<SettingsState, String>(
                builder: (context, longDateFormat, child) => ListTile(
                  title: const Text('Created date'),
                  subtitle: Text(DateFormat(longDateFormat).format(created)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(),
                ),
                selector: (context, settings) => settings.value.longDateFormat,
              ),
              imageField(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: save,
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }

  Selector<SettingsState, bool> imageField() {
    return Selector<SettingsState, bool>(
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
    );
  }

  material.Row duration() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: minutes,
            decoration: const InputDecoration(labelText: 'Minutes'),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: false,
            ),
            onTap: () => selectAll(minutes),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) => selectAll(seconds),
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              if (int.tryParse(value) == null) return 'Invalid number';
              return null;
            },
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: TextFormField(
            controller: seconds,
            decoration: const InputDecoration(labelText: 'Seconds'),
            keyboardType: const TextInputType.numberWithOptions(
              decimal: false,
            ),
            onTap: () => selectAll(seconds),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) => selectAll(incline),
            validator: (value) {
              if (value == null || value.isEmpty) return null;
              if (int.tryParse(value) == null) return 'Invalid number';
              return null;
            },
          ),
        ),
      ],
    );
  }

  material.Autocomplete<String> autocomplete(bool showBodyWeight) {
    return Autocomplete<String>(
      optionsBuilder: (textEditingValue) {
        return nameOptions.where(
          (option) => option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase()),
        );
      },
      onSelected: (option) => onSelected(option, showBodyWeight),
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
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            return null;
          },
        );
      },
    );
  }

  @override
  void dispose() {
    reps.dispose();
    repsNode.dispose();
    weight.dispose();
    bodyWeight.dispose();
    distance.dispose();
    minutes.dispose();
    incline.dispose();

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

  void pick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result?.files.single == null) return;

    setState(() {
      image = result?.files.single.path;
    });
  }

  save() async {
    if (!formKey.currentState!.validate()) return;

    Navigator.pop(context);

    final gymSet = widget.gymSet.copyWith(
      name: name,
      unit: unit,
      created: created,
      reps: double.tryParse(reps.text),
      weight: double.tryParse(weight.text),
      bodyWeight: double.tryParse(bodyWeight.text),
      distance: double.tryParse(distance.text),
      duration: (int.tryParse(seconds.text) ?? 0) / 60 +
          (int.tryParse(minutes.text) ?? 0),
      cardio: cardio,
      restMs: Value(restMs),
      incline: Value(int.tryParse(incline.text)),
      image: Value(image),
      notes: Value(notes.text),
      category: Value(category),
    );

    final settings = context.read<SettingsState>().value;
    if (settings.notifications) {
      final best = await isBest(gymSet);
      if (best) {
        final random = Random();
        final randomMessage =
            positiveReinforcement[random.nextInt(positiveReinforcement.length)];
        if (mounted) toast(context, randomMessage);
      }
    }

    if (widget.gymSet.id > 0) {
      await db.update(db.gymSets).replace(gymSet);
      if (image != null)
        (db.update(db.gymSets)..where((u) => u.name.equals(name)))
            .write(GymSetsCompanion(image: Value(image)));
      return;
    }

    var insert = gymSet.toCompanion(false).copyWith(id: const Value.absent());
    db.into(db.gymSets).insert(insert);

    if (!settings.restTimers || !mounted) return;
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
        Duration(milliseconds: settings.timerDuration),
        settings.alarmSound,
        settings.vibrate,
      );
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

  void setORM() {
    oneRepMax.text =
        "${(double.parse(weight.text) / (1.0278 - (0.0278 * double.parse(reps.text)))).toStringAsFixed(2)} $unit";
  }

  void updateFields(GymSet gymSet) {
    nameController?.text = gymSet.name;

    reps.text = toString(gymSet.reps);
    weight.text = toString(gymSet.weight);
    bodyWeight.text = toString(gymSet.bodyWeight);
    minutes.text = gymSet.duration.floor().toString();
    seconds.text = ((gymSet.duration * 60) % 60).floor().toString();
    distance.text = toString(gymSet.distance);
    incline.text = gymSet.incline?.toString() ?? "";
    if (widget.gymSet.id > 0) notes.text = gymSet.notes ?? '';

    setState(() {
      category = gymSet.category;
      image = gymSet.image;
      name = gymSet.name;
      unit = gymSet.unit;
      created = gymSet.created;
      cardio = gymSet.cardio;
      restMs = gymSet.restMs;
    });

    setORM();
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
