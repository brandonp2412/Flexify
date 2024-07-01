import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/unit_selector.dart';
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

  bool cardio = false;
  String? unit;

  @override
  void initState() {
    super.initState();

    final settings = context.read<SettingsState>();

    (db.gymSets.select()
          ..where((tbl) => tbl.name.equals(widget.name))
          ..limit(1))
        .getSingle()
        .then(
          (value) => setState(() {
            cardio = value.cardio;
            unit = value.unit;

            if (value.restMs != null) {
              final duration = Duration(milliseconds: value.restMs!);
              minutesController.text = duration.inMinutes.toString();
              secondsController.text = (duration.inSeconds % 60).toString();
            }

            if (cardio && (unit == 'kg' || unit == 'lb'))
              unit = settings.cardioUnit;
            else if (!cardio && (unit == 'km' || unit == 'mi'))
              unit = settings.strengthUnit;
          }),
        );
  }

  @override
  dispose() {
    nameController.dispose();
    minutesController.dispose();
    secondsController.dispose();
    super.dispose();
  }

  Future<int> _getCount() async {
    final result = await (db.gymSets.selectOnly()
          ..addColumns([db.gymSets.name.count()])
          ..where(db.gymSets.name.equals(nameController.text)))
        .getSingle();
    return result.read(db.gymSets.name.count()) ?? 0;
  }

  Future<bool> _mixedUnits() async {
    final result = await (db.gymSets.selectOnly(distinct: true)
          ..addColumns([db.gymSets.unit])
          ..where(db.gymSets.name.equals(nameController.text)))
        .get();
    return result.length > 1;
  }

  Future<void> _doUpdate() async {
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
        name: Value(nameController.text),
        cardio: Value(cardio),
        unit: unit != null ? Value(unit!) : const Value.absent(),
        restMs: Value(duration?.inMilliseconds),
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

  _save() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name cannot be empty.')),
      );
      Navigator.pop(context);
      return;
    }

    final count = await _getCount();

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
                  await _doUpdate();
                },
              ),
            ],
          );
        },
      );
    else if (await _mixedUnits() && mounted)
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
                  await _doUpdate();
                },
              ),
            ],
          );
        },
      );
    else
      await _doUpdate();

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${widget.name.toLowerCase()}"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: material.Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            if (unit != null)
              UnitSelector(
                value: unit!,
                cardio: cardio,
                onChanged: (value) {
                  setState(() {
                    unit = value;
                  });
                },
              ),
            ListTile(
              leading: cardio
                  ? const Icon(Icons.sports_gymnastics)
                  : const Icon(Icons.fitness_center),
              title: cardio ? const Text('Cardio') : const Text('Strength'),
              onTap: () {
                setState(() {
                  cardio = !cardio;
                  if (cardio)
                    unit = unit == 'kg' ? 'km' : 'mi';
                  else
                    unit = unit == 'km' ? 'kg' : 'lb';
                });
              },
              trailing: Switch(
                value: cardio,
                onChanged: (value) => setState(() {
                  cardio = value;
                }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _save,
        tooltip: "Update all records for this exercise",
        child: const Icon(Icons.save),
      ),
    );
  }
}
