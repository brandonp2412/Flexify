import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';

class EditGymSet extends StatefulWidget {
  final GymSet gymSet;

  const EditGymSet({Key? key, required this.gymSet}) : super(key: key);

  @override
  createState() => _EditGymSetState();
}

class _EditGymSetState extends State<EditGymSet> {
  late TextEditingController repsController;
  late TextEditingController weightController;
  late String unit;
  late DateTime created;

  @override
  void initState() {
    super.initState();
    repsController = TextEditingController(text: widget.gymSet.reps.toString());
    weightController =
        TextEditingController(text: widget.gymSet.weight.toString());
    unit = widget.gymSet.unit;
    created = widget.gymSet.created;
  }

  @override
  void dispose() {
    repsController.dispose();
    weightController.dispose();
    super.dispose();
  }

  Future<void> updateGymSet() async {
    Navigator.pop(context);
    final reps = double.parse(repsController.text);
    final weight = double.parse(weightController.text);

    final updatedGymSet = widget.gymSet
        .copyWith(reps: reps, weight: weight, unit: unit, created: created);

    database.update(database.gymSets).replace(updatedGymSet);
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: created,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.gymSet.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: material.Column(
          children: [
            TextField(
              controller: repsController,
              decoration: const InputDecoration(labelText: 'Reps'),
              keyboardType: TextInputType.number,
              onTap: () => repsController.selection = TextSelection(
                  baseOffset: 0, extentOffset: repsController.text.length),
            ),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight ($unit)'),
              keyboardType: TextInputType.number,
              onTap: () => weightController.selection = TextSelection(
                  baseOffset: 0, extentOffset: weightController.text.length),
            ),
            DropdownButtonFormField<String>(
              value: unit,
              decoration: const InputDecoration(labelText: 'Unit'),
              items: ['kg', 'lb'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  unit = newValue!;
                });
              },
            ),
            ListTile(
              title: const Text('Created Date'),
              subtitle: Text(created.toString()),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateGymSet,
        child: const Icon(Icons.save),
      ),
    );
  }
}
