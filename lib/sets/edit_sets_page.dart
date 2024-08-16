import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flexify/utils.dart';
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
  final reps = TextEditingController();
  final weight = TextEditingController();
  final bodyWeight = TextEditingController();
  final distance = TextEditingController();
  final minutes = TextEditingController();
  final seconds = TextEditingController();
  final incline = TextEditingController();
  final name = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextField(
                controller: name,
                decoration:
                    InputDecoration(labelText: "Name", hintText: oldNames),
                textCapitalization: TextCapitalization.sentences,
              ),
              if (cardio == true) ...[
                TextFormField(
                  controller: distance,
                  decoration: InputDecoration(
                    labelText: 'Distance',
                    hintText: oldDistances,
                  ),
                  keyboardType: TextInputType.number,
                  onTap: () => selectAll(distance),
                  validator: (value) {
                    if (value == null) return null;
                    if (double.tryParse(value) == null) return 'Invalid number';
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: minutes,
                        decoration: InputDecoration(
                          labelText: 'Minutes',
                          hintText: oldMinutes,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                        ),
                        onTap: () => selectAll(minutes),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          if (int.tryParse(value) == null)
                            return 'Invalid number';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        controller: seconds,
                        decoration: InputDecoration(
                          labelText: 'Seconds',
                          hintText: oldSeconds,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                        ),
                        onTap: () => selectAll(seconds),
                        textInputAction: TextInputAction.next,
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
                TextFormField(
                  controller: incline,
                  decoration: InputDecoration(
                    labelText: 'Incline %',
                    hintText: oldInclines,
                  ),
                  keyboardType: TextInputType.number,
                  onTap: () => selectAll(incline),
                  validator: (value) {
                    if (value == null) return null;
                    if (double.tryParse(value) == null) return 'Invalid number';
                    return null;
                  },
                ),
              ],
              if (cardio == false || cardio == null) ...[
                TextFormField(
                  controller: reps,
                  decoration:
                      InputDecoration(labelText: 'Reps', hintText: oldReps),
                  keyboardType: TextInputType.number,
                  onTap: () => selectAll(reps),
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (double.tryParse(value) == null) return 'Invalid number';
                    return null;
                  },
                ),
                TextFormField(
                  controller: weight,
                  decoration: InputDecoration(
                    labelText: name.text == 'Weight' ? 'Value' : 'Weight',
                    hintText: oldWeights,
                  ),
                  keyboardType: TextInputType.number,
                  onTap: () => selectAll(weight),
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (double.tryParse(value) == null) return 'Invalid number';
                    return null;
                  },
                ),
              ],
              if (name.text != 'Weight')
                Selector<SettingsState, bool>(
                  builder: (context, showBodyWeight, child) => Visibility(
                    visible: showBodyWeight,
                    child: TextFormField(
                      controller: bodyWeight,
                      decoration: InputDecoration(
                        labelText: 'Body weight',
                        hintText: oldBodyWeights,
                      ),
                      keyboardType: TextInputType.number,
                      onTap: () => selectAll(bodyWeight),
                      validator: (value) {
                        if (value == null || value.isEmpty) return null;
                        if (double.tryParse(value) == null)
                          return 'Invalid number';
                        return null;
                      },
                    ),
                  ),
                  selector: (context, settings) =>
                      settings.value.showBodyWeight,
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: save,
        label: const Text("Update"),
        icon: const Icon(Icons.sync),
      ),
    );
  }

  @override
  void dispose() {
    reps.dispose();
    weight.dispose();
    bodyWeight.dispose();
    distance.dispose();
    minutes.dispose();
    seconds.dispose();
    incline.dispose();

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
    if (!formKey.currentState!.validate()) return;

    Navigator.pop(context);

    final gymSet = GymSetsCompanion(
      name: name.text.isNotEmpty ? Value(name.text) : const Value.absent(),
      unit: Value.absentIfNull(unit),
      created: Value.absentIfNull(created),
      cardio: Value.absentIfNull(cardio),
      restMs: Value.absentIfNull(restMs),
      incline: Value.absentIfNull(int.tryParse(incline.text)),
      reps: Value.absentIfNull(double.tryParse(reps.text)),
      weight: Value.absentIfNull(double.tryParse(weight.text)),
      bodyWeight: Value.absentIfNull(double.tryParse(bodyWeight.text)),
      distance: Value.absentIfNull(double.tryParse(distance.text)),
      duration: int.tryParse(seconds.text) == null &&
              int.tryParse(minutes.text) == null
          ? const Value.absent()
          : Value(
              (int.tryParse(seconds.text) ?? 0) / 60 +
                  (int.tryParse(minutes.text) ?? 0),
            ),
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
