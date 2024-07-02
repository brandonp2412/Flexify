import 'package:flexify/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({
    super.key,
    required this.controllers,
    required this.entry,
    required this.add,
    required this.remove,
    required this.on,
  });

  final List<TextEditingController> controllers;
  final MapEntry<int, String> entry;
  final Function(String) add;
  final Function(String) remove;
  final bool on;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Selector<SettingsState, int>(
              selector: (p0, p1) => p1.maxSets,
              builder: (context, value, child) => TextField(
                controller: controllers[entry.key],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                onTap: () => selectAll(controllers[entry.key]),
                onChanged: (value) {
                  if (value.isNotEmpty && !on) add(entry.value);
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
                if (on)
                  remove(entry.value);
                else
                  add(entry.value);
              },
              child: Text(
                entry.value,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          Switch(
            value: on,
            onChanged: (value) {
              if (on)
                remove(entry.value);
              else
                add(entry.value);
            },
          ),
        ],
      ),
    );
  }
}
