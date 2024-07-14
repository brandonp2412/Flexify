import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
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
  late final controller = TextEditingController(
    text: widget.planExercise.maxSets.value?.toString(),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Selector<SettingsState, int>(
              selector: (context, settings) => settings.value.maxSets,
              builder: (context, value, child) => TextField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                onTap: () => selectAll(controller),
                onChanged: (value) {
                  final pe = widget.planExercise.copyWith(
                    enabled: const Value(true),
                    maxSets: Value(int.tryParse(controller.text)),
                  );
                  widget.onChange(pe);
                },
                decoration: InputDecoration(
                  labelText: "Sets",
                  border: const OutlineInputBorder(),
                  hintText: value.toString(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onChange(
                  widget.planExercise.copyWith(
                    enabled: Value(!widget.planExercise.enabled.value),
                  ),
                );
              },
              child: Text(
                widget.planExercise.exercise.value,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Switch(
            value: widget.planExercise.enabled.value,
            onChanged: (value) {
              widget.onChange(
                widget.planExercise.copyWith(
                  enabled: Value(value),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
