import 'package:drift/drift.dart' hide Column;
import 'package:flexify/database/database.dart';
import 'package:flexify/l10n/l10n.dart';
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
  late final _max = TextEditingController(
    text: widget.planExercise.maxSets.value?.toString(),
  );
  late final _warmup = TextEditingController(
    text: widget.planExercise.warmupSets.value?.toString(),
  );

  @override
  void dispose() {
    _max.dispose();
    _warmup.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        tooltip: context.l10n.navSettings,
        icon: const Icon(Icons.settings),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              bool timers = widget.planExercise.timers.present
                  ? widget.planExercise.timers.value
                  : true;

              return AlertDialog.adaptive(
                title: Text(widget.planExercise.exercise.value),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Selector<SettingsState, int?>(
                        selector: (context, settings) =>
                            settings.value.warmupSets,
                        builder: (context, value, child) => TextField(
                          controller: _warmup,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                          ),
                          onTap: () => selectAll(_warmup),
                          onChanged: (value) {
                            final pe = widget.planExercise.copyWith(
                              enabled: const Value(true),
                              warmupSets: Value(int.tryParse(_warmup.text)),
                            );
                            widget.onChange(pe);
                          },
                          decoration: InputDecoration(
                            labelText: context.l10n.warmupSets,
                            border: const OutlineInputBorder(),
                            hintText: (value ?? 0).toString(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Selector<SettingsState, int>(
                        selector: (context, settings) => settings.value.maxSets,
                        builder: (context, value, child) => TextField(
                          controller: _max,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                          ),
                          onTap: () => selectAll(_max),
                          onChanged: (value) {
                            final parsed = int.tryParse(_max.text);
                            if (parsed != null && parsed > 0 && parsed <= 20) {
                              final pe = widget.planExercise.copyWith(
                                enabled: const Value(true),
                                maxSets: Value(parsed),
                              );
                              widget.onChange(pe);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: context.l10n.workingSetsMax,
                            border: const OutlineInputBorder(),
                            hintText: value.toString(),
                          ),
                        ),
                      ),
                      StatefulBuilder(
                        builder: (context, setState) => ListTile(
                          title: Text(context.l10n.restTimers),
                          trailing: Switch(
                            value: timers,
                            onChanged: (value) {
                              setState(() {
                                timers = value;
                              });
                              widget.onChange(
                                widget.planExercise.copyWith(
                                  timers: Value(value),
                                ),
                              );
                            },
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
                    label: Text(context.l10n.actionOk),
                    icon: const Icon(Icons.check),
                  ),
                ],
              );
            },
          );
        },
      ),
      title: Text(widget.planExercise.exercise.value),
      trailing: Switch(
        value: widget.planExercise.enabled.value,
        onChanged: (value) {
          widget.onChange(widget.planExercise.copyWith(enabled: Value(value)));
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
