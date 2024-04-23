import 'package:drift/drift.dart';
import 'package:flexify/edit_gym_set.dart';
import 'package:flexify/main.dart';
import 'package:flexify/settings_state.dart';
import 'package:flexify/view_graph_page.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExerciseList extends StatelessWidget {
  final List<String> planExercises;
  final Map<String, int> counts;
  final int selectedIndex;
  final Function(int) selectAllReps;
  final Function(int, int) onReorder;
  final bool first;

  const ExerciseList({
    super.key,
    required this.planExercises,
    required this.selectedIndex,
    required this.selectAllReps,
    required this.onReorder,
    required this.counts,
    required this.first,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return ReorderableListView.builder(
      itemCount: planExercises.length,
      itemBuilder: (context, index) {
        final exercise = planExercises[index];
        final count = counts[exercise] ?? 0;

        return GestureDetector(
          key: Key(exercise),
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
                                builder: (context) => EditGymSet(
                                    gymSet: gymSet.toCompanion(false)),
                              ));
                          selectAllReps(index);
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
                onTap: () => selectAllReps(index),
                trailing: Visibility(
                  visible: settings.showReorder,
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
                      value: index == selectedIndex,
                      groupValue: true,
                      onChanged: (value) {
                        selectAllReps(index);
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
      },
      onReorder: onReorder,
    );
  }
}
