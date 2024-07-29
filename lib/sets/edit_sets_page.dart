import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditSetsPage extends StatefulWidget {
  final List<int> ids;

  const EditSetsPage({super.key, required this.ids});

  @override
  createState() => _EditSetsPageState();
}

class _EditSetsPageState extends State<EditSetsPage> {
  final repsController = TextEditingController();
  final weightController = TextEditingController();
  final bodyWeightController = TextEditingController();
  final distanceController = TextEditingController();
  final minutesController = TextEditingController();
  final secondsController = TextEditingController();
  final inclineController = TextEditingController();
  final nameController = TextEditingController();

  String? unit;
  DateTime? created;
  bool? cardio;
  int? restMs;
  String? category;
  String? oldNames;
  String? oldReps;
  String? oldWeights;
  String? oldBodyWeights;
  String? oldCreateds;
  String? oldDistances;
  String? oldMinutes;
  String? oldSeconds;
  String? oldInclines;
  String? oldCategories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit ${widget.ids.length} sets',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: Text(
                      'Are you sure you want to delete ${widget.ids.length} entries?',
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
                          await db.gymSets
                              .deleteWhere((u) => u.id.isIn(widget.ids));
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
        child: material.Column(
          children: [
            TextField(
              controller: nameController,
              decoration:
                  InputDecoration(labelText: "Name", hintText: oldNames),
              textCapitalization: TextCapitalization.sentences,
            ),
            if (cardio == true) ...[
              TextField(
                controller: distanceController,
                decoration: InputDecoration(
                  labelText: 'Distance',
                  hintText: oldDistances,
                ),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(distanceController),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: minutesController,
                      decoration: InputDecoration(
                        labelText: 'Minutes',
                        hintText: oldMinutes,
                      ),
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
                      decoration: InputDecoration(
                        labelText: 'Seconds',
                        hintText: oldSeconds,
                      ),
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
                decoration: InputDecoration(
                  labelText: 'Incline %',
                  hintText: oldInclines,
                ),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(inclineController),
              ),
            ],
            if (cardio == false || cardio == null) ...[
              TextField(
                controller: repsController,
                decoration:
                    InputDecoration(labelText: 'Reps', hintText: oldReps),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(repsController),
              ),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText:
                      nameController.text == 'Weight' ? 'Value' : 'Weight',
                  hintText: oldWeights,
                ),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(weightController),
              ),
            ],
            if (nameController.text != 'Weight')
              Selector<SettingsState, bool>(
                builder: (context, showBodyWeight, child) => Visibility(
                  visible: showBodyWeight,
                  child: TextField(
                    controller: bodyWeightController,
                    decoration: InputDecoration(
                      labelText: 'Body weight',
                      hintText: oldBodyWeights,
                    ),
                    keyboardType: TextInputType.number,
                    onTap: () => selectAll(bodyWeightController),
                  ),
                ),
                selector: (context, settings) => settings.value.showBodyWeight,
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
                  cardio: cardio ?? false,
                ),
              ),
              selector: (context, settings) => settings.value.showUnits,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Category',
                hintText: oldCategories,
              ),
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
            Selector<SettingsState, String>(
              builder: (context, longDateFormat, child) => ListTile(
                title: const Text('Created Date'),
                subtitle: Text(
                  created != null
                      ? DateFormat(longDateFormat).format(created!)
                      : oldCreateds ?? "",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(),
              ),
              selector: (context, settings) => settings.value.longDateFormat,
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
    weightController.dispose();
    bodyWeightController.dispose();
    distanceController.dispose();
    minutesController.dispose();
    secondsController.dispose();
    inclineController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsState>().value;

    (db.gymSets.select()
          ..where((u) => u.id.isIn(widget.ids))
          ..limit(3))
        .get()
        .then((gymSets) {
      setState(() {
        cardio = gymSets.first.cardio;
        oldNames = gymSets.map((gymSet) => gymSet.name).join(', ');
        oldReps = gymSets.map((gymSet) => gymSet.reps).join(', ');
        oldWeights = gymSets.map((gymSet) => gymSet.weight).join(', ');
        oldBodyWeights = gymSets.map((gymSet) => gymSet.bodyWeight).join(', ');
        oldCreateds = gymSets
            .map(
              (gymSet) =>
                  DateFormat(settings.longDateFormat).format(gymSet.created),
            )
            .join(', ');
        oldDistances = gymSets.map((gymSet) => gymSet.distance).join(', ');
        oldMinutes =
            gymSets.map((gymSet) => gymSet.duration.floor()).join(', ');
        oldSeconds = gymSets
            .map((gymSet) => ((gymSet.duration * 60) % 60).floor())
            .join(', ');
        oldInclines = gymSets.map((gymSet) => gymSet.incline).join(', ');
        oldCategories = gymSets.map((gymSet) => gymSet.category).join(', ');
      });
    });
  }

  Future<void> selectTime(DateTime pickedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(created ?? DateTime.now()),
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

  Future<void> save() async {
    Navigator.pop(context);
    final reps = double.tryParse(repsController.text);
    final weight = double.tryParse(weightController.text);
    final bodyWeight = double.tryParse(bodyWeightController.text);
    final distance = double.tryParse(distanceController.text);
    final minutes = int.tryParse(minutesController.text);
    final seconds = int.tryParse(secondsController.text);
    final duration = (seconds ?? 0) / 60 + (minutes ?? 0);
    final incline = int.tryParse(inclineController.text);

    final gymSet = GymSetsCompanion(
      name: nameController.text.isNotEmpty
          ? Value(nameController.text)
          : const Value.absent(),
      unit: Value.absentIfNull(unit),
      created: Value.absentIfNull(created),
      cardio: Value.absentIfNull(cardio),
      restMs: Value.absentIfNull(restMs),
      incline: Value.absentIfNull(incline),
      reps: Value.absentIfNull(reps),
      weight: Value.absentIfNull(weight),
      bodyWeight: Value.absentIfNull(bodyWeight),
      distance: Value.absentIfNull(distance),
      duration: seconds == null && minutes == null
          ? const Value.absent()
          : Value(duration),
      category: Value.absentIfNull(category),
    );

    await (db.gymSets.update()..where((u) => u.id.isIn(widget.ids)))
        .write(gymSet);
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
