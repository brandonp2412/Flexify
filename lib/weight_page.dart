import 'package:drift/drift.dart' as drift;
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/unit_selector.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  final TextEditingController valueController = TextEditingController();
  String yesterdaysWeight = "";
  String? unit;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Weight')),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              TextFormField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Weight'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
                autofocus: true,
              ),
              Selector<SettingsState, String>(
                selector: (context, settings) => settings.value.strengthUnit,
                builder: (context, value, child) => UnitSelector(
                  value: unit ?? value,
                  cardio: false,
                  onChanged: (String? newValue) {
                    setState(() {
                      unit = newValue!;
                    });
                  },
                ),
              ),
              TextFormField(
                controller: TextEditingController(text: yesterdaysWeight),
                decoration: const InputDecoration(labelText: 'Previous weight'),
                enabled: false,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!formKey.currentState!.validate()) return;

          final settings = context.read<SettingsState>().value;
          Navigator.pop(context);

          db.gymSets.insertOne(
            GymSetsCompanion.insert(
              created: DateTime.now().toLocal(),
              name: "Weight",
              reps: 1,
              unit: unit ?? settings.strengthUnit,
              weight: double.parse(valueController.text),
            ),
          );
          (db.gymSets.update()..where((tbl) => tbl.bodyWeight.equals(0))).write(
            GymSetsCompanion(
              bodyWeight: drift.Value(double.parse(valueController.text)),
            ),
          );
        },
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    valueController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsState>().value;

    getBodyWeight().then(
      (value) => setState(() {
        yesterdaysWeight =
            "${value?.weight ?? 0} ${value?.unit ?? settings.strengthUnit}";
        unit = value?.unit;
      }),
    );
  }
}
