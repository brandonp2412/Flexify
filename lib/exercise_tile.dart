import 'package:drift/drift.dart';
import 'package:flexify/edit_gym_set.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/view_graph_page.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseTile extends StatelessWidget {
  final String exercise;
  final bool isSelected;
  final VoidCallback selectAllReps;
  final int count;
  final int index;
  final bool first;

  const ExerciseTile({
    super.key,
    required this.exercise,
    required this.isSelected,
    required this.selectAllReps,
    required this.count,
    required this.index,
    required this.first,
  });

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsState>();
    return GestureDetector(
      onLongPressStart: (details) async {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.insights),
                  title: const Text('Graphs'),
                  onTap: () async {
                    Navigator.pop(context);
                    DefaultTabController.of(context).animateTo(1);
                    await Future.delayed(kTabScrollDuration);
                    graphsKey.currentState!.push(MaterialPageRoute(
                        builder: (context) => ViewGraphPage(
                              name: exercise,
                            )));
                  },
                ),
                if (count > 0)
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit'),
                    onTap: () async {
                      Navigator.pop(context);
                      final gymSet = await (db.select(db.gymSets)
                            ..where((r) => db.gymSets.name.equals(exercise))
                            ..orderBy([
                              (u) => OrderingTerm(
                                  expression: u.created,
                                  mode: OrderingMode.desc),
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
                      selectAllReps();
                    },
                  ),
                if (count > 0)
                  ListTile(
                    leading: const Icon(Icons.undo),
                    title: const Text('Undo'),
                    onTap: () async {
                      Navigator.pop(context);
                      final gymSet = await (db.select(db.gymSets)
                            ..where((r) => db.gymSets.name.equals(exercise))
                            ..orderBy([
                              (u) => OrderingTerm(
                                  expression: u.created,
                                  mode: OrderingMode.desc),
                            ])
                            ..limit(1))
                          .getSingle();
                      await db.gymSets.deleteOne(gymSet);
                    },
                  ),
              ],
            );
          },
        );
      },
      child: material.Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            onTap: selectAllReps,
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
                    selectAllReps();
                  },
                ),
                Text("$exercise ($count)"),
              ],
            ),
          ),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: (count / 5) - 1, end: count / 5),
            duration: Duration(milliseconds: first ? 0 : 150),
            builder: (context, value, child) => LinearProgressIndicator(
              value: value,
            ),
          ),
        ],
      ),
    );
  }
}
