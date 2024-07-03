import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
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
  String? oldNames;
  String? oldReps;
  String? oldWeights;
  String? oldBodyWeights;
  String? oldCreateds;
  String? oldDistances;
  String? oldMinutes;
  String? oldSeconds;
  String? oldInclines;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsState>();

    (db.gymSets.select()..where((u) => u.id.isIn(widget.ids)))
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
      });
    });
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

  Future<void> _save() async {
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
      name: nameController.text != ''
          ? Value(nameController.text)
          : const Value.absent(),
      unit: unit != null ? Value(unit!) : const Value.absent(),
      created: created != null ? Value(created!) : const Value.absent(),
      cardio: cardio != null ? Value(cardio!) : const Value.absent(),
      restMs: restMs != null ? Value(restMs!) : const Value.absent(),
      incline: incline != null ? Value(incline) : const Value.absent(),
      reps: reps != null ? Value(reps) : const Value.absent(),
      weight: weight != null ? Value(weight) : const Value.absent(),
      bodyWeight: bodyWeight != null ? Value(bodyWeight) : const Value.absent(),
      distance: distance != null ? Value(distance) : const Value.absent(),
      duration: Value(duration),
    );

    (db.gymSets.update()..where((u) => u.id.isIn(widget.ids))).write(gymSet);
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
                  labelText: 'Incline',
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
                builder: (context, hideWeight, child) => Visibility(
                  visible: !hideWeight,
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
                selector: (p0, p1) => p1.hideWeight,
              ),
            Selector<SettingsState, bool>(
              builder: (context, showUnits, child) => Visibility(
                visible: showUnits,
                child: UnitSelector(
                  value: unit ?? 'kg',
                  onChanged: (String? newValue) {
                    setState(() {
                      unit = newValue!;
                    });
                  },
                  cardio: cardio ?? false,
                ),
              ),
              selector: (p0, p1) => p1.showUnits,
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
              selector: (p0, p1) => p1.longDateFormat,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        tooltip: "Save",
        child: const Icon(Icons.save),
      ),
    );
  }
}
