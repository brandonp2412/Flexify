import 'package:drift/drift.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exercise;
  final bool isSelected;
  final VoidCallback onTap;
  final double progress;

  const ExerciseTile({
    Key? key,
    required this.exercise,
    required this.isSelected,
    required this.onTap,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      onLongPress: () async {
        if (progress == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No $exercise yet')),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleting last $exercise')),
        );
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
      title: Row(children: [
        Radio(
          value: isSelected,
          groupValue: true,
          onChanged: (value) {
            onTap();
          },
        ),
        Text(exercise),
      ]),
      subtitle: SizedBox(
        child: LinearProgressIndicator(
          value: progress,
        ),
      ),
    );
  }
}
