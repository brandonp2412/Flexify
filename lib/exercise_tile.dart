import 'package:drift/drift.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exercise;
  final bool isSelected;
  final VoidCallback onTap;
  final int count;
  final int index;

  const ExerciseTile({
    Key? key,
    required this.exercise,
    required this.isSelected,
    required this.onTap,
    required this.count,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (details) async {
        final position = RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          MediaQuery.of(context).size.width - details.globalPosition.dx,
          MediaQuery.of(context).size.height - details.globalPosition.dy,
        );

        await showMenu(
          context: context,
          position: position,
          items: [
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Delete"),
                onTap: () async {
                  Navigator.pop(context);
                  if (count == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No exercises to undo')),
                    );
                    return;
                  }

                  final gymSet = await (database.select(database.gymSets)
                        ..where((r) => database.gymSets.name.equals(exercise))
                        ..orderBy([
                          (u) => OrderingTerm(
                              expression: u.created, mode: OrderingMode.desc),
                        ])
                        ..limit(1))
                      .getSingle();
                  await database.gymSets.deleteOne(gymSet);
                },
              ),
            ),
          ],
        );
      },
      child: ListTile(
        onTap: onTap,
        trailing: ReorderableDragStartListener(
            index: index, child: const Icon(Icons.drag_handle)),
        title: Row(children: [
          Radio(
            value: isSelected,
            groupValue: true,
            onChanged: (value) {
              onTap();
            },
          ),
          Text("$exercise ($count)"),
        ]),
        subtitle: SizedBox(
          child: LinearProgressIndicator(
            value: count / 5,
          ),
        ),
      ),
    );
  }
}
