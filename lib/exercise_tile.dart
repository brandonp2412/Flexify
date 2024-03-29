import 'package:drift/drift.dart';
import 'package:flexify/edit_gym_set.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class ExerciseTile extends StatelessWidget {
  final String exercise;
  final bool isSelected;
  final VoidCallback onTap;
  final int count;
  final int index;

  const ExerciseTile({
    super.key,
    required this.exercise,
    required this.isSelected,
    required this.onTap,
    required this.count,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsState>();
    return GestureDetector(
      onLongPressStart: (details) async {
        if (count == 0) return;
        final position = RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy - 40,
          MediaQuery.of(context).size.width - details.globalPosition.dx,
          MediaQuery.of(context).size.height - details.globalPosition.dy - 40,
        );

        await showMenu(
          context: context,
          position: position,
          items: [
            PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Edit"),
                onTap: () async {
                  Navigator.pop(context);
                  final gymSet = await (db.select(db.gymSets)
                        ..where((r) => db.gymSets.name.equals(exercise))
                        ..orderBy([
                          (u) => OrderingTerm(
                              expression: u.created, mode: OrderingMode.desc),
                        ])
                        ..limit(1))
                      .getSingle();
                  if (!context.mounted) return;
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditGymSet(gymSet: gymSet.toCompanion(false)),
                      ));
                  onTap();
                },
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Delete"),
                onTap: () async {
                  Navigator.pop(context);

                  final gymSet = await (db.select(db.gymSets)
                        ..where((r) => db.gymSets.name.equals(exercise))
                        ..orderBy([
                          (u) => OrderingTerm(
                              expression: u.created, mode: OrderingMode.desc),
                        ])
                        ..limit(1))
                      .getSingle();
                  await db.gymSets.deleteOne(gymSet);
                },
              ),
            ),
          ],
        );
      },
      child: material.Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            onTap: onTap,
            trailing: Visibility(
              visible: settingsState.showReorder,
              child: material.Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  )
                ],
              ),
            ),
            title: Row(
              children: [
                Radio(
                  value: isSelected,
                  groupValue: true,
                  onChanged: (value) {
                    onTap();
                  },
                ),
                Text("$exercise ($count)"),
              ],
            ),
          ),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: (count / 5) - 1, end: count / 5),
            duration: const Duration(milliseconds: 150),
            builder: (context, value, child) => LinearProgressIndicator(
              value: value,
            ),
          ),
        ],
      ),
    );
  }
}
