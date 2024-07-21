import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseTile extends StatefulWidget {
  final PlanExercisesCompanion planExercise;
  final Function(PlanExercisesCompanion) onChange;

  const ExerciseTile({
    super.key,
    required this.onChange,
    required this.planExercise,
  });

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  late final maxSets = TextEditingController(
    text: widget.planExercise.maxSets.value?.toString(),
  );
  late final warmupSets = TextEditingController(
    text: widget.planExercise.warmupSets.value?.toString(),
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog.adaptive(
              title: Text(widget.planExercise.exercise.value),
              content: SingleChildScrollView(
                child: material.Column(
                  children: [
                    Selector<SettingsState, int?>(
                      selector: (context, settings) =>
                          settings.value.warmupSets,
                      builder: (context, value, child) => TextField(
                        controller: warmupSets,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                        ),
                        onTap: () => selectAll(warmupSets),
                        onChanged: (value) {
                          final pe = widget.planExercise.copyWith(
                            enabled: const Value(true),
                            warmupSets: Value(int.tryParse(warmupSets.text)),
                          );
                          widget.onChange(pe);
                        },
                        decoration: InputDecoration(
                          labelText: "Warmup sets",
                          border: const OutlineInputBorder(),
                          hintText: (value ?? 0).toString(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Selector<SettingsState, int>(
                      selector: (context, settings) => settings.value.maxSets,
                      builder: (context, value, child) => TextField(
                        controller: maxSets,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                        ),
                        onChanged: (value) {
                          if (int.parse(maxSets.text) > 0 &&
                              int.parse(maxSets.text) <= 20) {
                            final pe = widget.planExercise.copyWith(
                              enabled: const Value(true),
                              maxSets: Value(int.parse(maxSets.text)),
                            );
                            widget.onChange(pe);
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Working sets (max: 20)",
                          border: const OutlineInputBorder(),
                          hintText: value.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: const Text("OK"),
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
          );
        },
      ),
      title: Text(widget.planExercise.exercise.value),
      trailing: Switch(
        value: widget.planExercise.enabled.value,
        onChanged: (value) {
          widget.onChange(
            widget.planExercise.copyWith(
              enabled: Value(value),
            ),
          );
        },
      ),
      onTap: () {
        widget.onChange(
          widget.planExercise.copyWith(
            enabled: Value(!widget.planExercise.enabled.value),
          ),
        );
      },
    );
  }
}
