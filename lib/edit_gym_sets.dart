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

class EditGymSets extends StatefulWidget {
  final List<int> ids;

  const EditGymSets({super.key, required this.ids});

  @override
  createState() => _EditGymSetsState();
}

class _EditGymSetsState extends State<EditGymSets> {
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _bodyWeightController = TextEditingController();
  final _distanceController = TextEditingController();
  final _minutesController = TextEditingController();
  final _secondsController = TextEditingController();
  final _inclineController = TextEditingController();
  final _nameController = TextEditingController();
  late SettingsState _settings;

  String? _unit;
  DateTime? _created;
  bool? _cardio;
  int? _restMs;
  String? _oldNames;
  String? _oldReps;
  String? _oldWeights;
  String? _oldBodyWeights;
  String? _oldCreateds;
  String? _oldDistances;
  String? _oldMinutes;
  String? _oldSeconds;
  String? _oldInclines;

  @override
  void initState() {
    super.initState();
    _settings = context.read<SettingsState>();
    (db.gymSets.select()..where((u) => u.id.isIn(widget.ids)))
        .get()
        .then((gymSets) {
      setState(() {
        _cardio = gymSets.first.cardio;
        _oldNames = gymSets.map((gymSet) => gymSet.name).join(', ');
        _oldReps = gymSets.map((gymSet) => gymSet.reps).join(', ');
        _oldWeights = gymSets.map((gymSet) => gymSet.weight).join(', ');
        _oldBodyWeights = gymSets.map((gymSet) => gymSet.bodyWeight).join(', ');
        _oldCreateds = gymSets
            .map(
              (gymSet) =>
                  DateFormat(_settings.longDateFormat).format(gymSet.created),
            )
            .join(', ');
        _oldDistances = gymSets.map((gymSet) => gymSet.distance).join(', ');
        _oldMinutes =
            gymSets.map((gymSet) => gymSet.duration.floor()).join(', ');
        _oldSeconds = gymSets
            .map((gymSet) => ((gymSet.duration * 60) % 60).floor())
            .join(', ');
        _oldInclines = gymSets.map((gymSet) => gymSet.incline).join(', ');
      });
    });
  }

  @override
  void dispose() {
    _repsController.dispose();
    _weightController.dispose();
    _bodyWeightController.dispose();
    _distanceController.dispose();
    _minutesController.dispose();
    _secondsController.dispose();
    _inclineController.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    Navigator.pop(context);
    final reps = double.tryParse(_repsController.text);
    final weight = double.tryParse(_weightController.text);
    final bodyWeight = double.tryParse(_bodyWeightController.text);
    final distance = double.tryParse(_distanceController.text);
    final minutes = int.tryParse(_minutesController.text);
    final seconds = int.tryParse(_secondsController.text);
    final duration = (seconds ?? 0) / 60 + (minutes ?? 0);
    final incline = int.tryParse(_inclineController.text);

    final gymSet = GymSetsCompanion(
      name: _nameController.text != ''
          ? Value(_nameController.text)
          : const Value.absent(),
      unit: _unit != null ? Value(_unit!) : const Value.absent(),
      created: _created != null ? Value(_created!) : const Value.absent(),
      cardio: _cardio != null ? Value(_cardio!) : const Value.absent(),
      restMs: _restMs != null ? Value(_restMs!) : const Value.absent(),
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
      initialDate: _created,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      _selectTime(pickedDate);
    }
  }

  Future<void> _selectTime(DateTime pickedDate) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_created ?? DateTime.now()),
    );

    if (pickedTime != null) {
      setState(() {
        _created = DateTime(
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
    _settings = context.watch<SettingsState>();

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
              controller: _nameController,
              decoration:
                  InputDecoration(labelText: "Name", hintText: _oldNames),
              textCapitalization: TextCapitalization.sentences,
            ),
            if (_cardio == true) ...[
              TextField(
                controller: _distanceController,
                decoration: InputDecoration(
                  labelText: 'Distance',
                  hintText: _oldDistances,
                ),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(_distanceController),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _minutesController,
                      decoration: InputDecoration(
                        labelText: 'Minutes',
                        hintText: _oldMinutes,
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      onTap: () => selectAll(_minutesController),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextField(
                      controller: _secondsController,
                      decoration: InputDecoration(
                        labelText: 'Seconds',
                        hintText: _oldSeconds,
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: false),
                      onTap: () => selectAll(_secondsController),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _inclineController,
                decoration: InputDecoration(
                  labelText: 'Incline',
                  hintText: _oldInclines,
                ),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(_inclineController),
              ),
            ],
            if (_cardio == false || _cardio == null) ...[
              TextField(
                controller: _repsController,
                decoration:
                    InputDecoration(labelText: 'Reps', hintText: _oldReps),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(_repsController),
              ),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText:
                      _nameController.text == 'Weight' ? 'Value' : 'Weight',
                  hintText: _oldWeights,
                ),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(_weightController),
              ),
            ],
            if (_nameController.text != 'Weight' && !_settings.hideWeight)
              TextField(
                controller: _bodyWeightController,
                decoration: InputDecoration(
                  labelText: 'Body weight',
                  hintText: _oldBodyWeights,
                ),
                keyboardType: TextInputType.number,
                onTap: () => selectAll(_bodyWeightController),
              ),
            UnitSelector(
              value: _unit ?? 'kg',
              onChanged: (String? newValue) {
                setState(() {
                  _unit = newValue!;
                });
              },
              cardio: _cardio ?? false,
            ),
            ListTile(
              title: const Text('Created Date'),
              subtitle: Text(
                _created != null
                    ? DateFormat(_settings.longDateFormat).format(_created!)
                    : _oldCreateds ?? "",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(),
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
