import 'package:drift/drift.dart' as drift;
import 'package:flexify/edit_gym_set.dart';
import 'package:flexify/main.dart';
import 'package:flexify/cardio_page.dart';
import 'package:flexify/strength_page.dart';
import 'package:flutter/material.dart';

class ExerciseModal extends StatelessWidget {
  const ExerciseModal({
    super.key,
    required this.exercise,
    required this.hasData,
    required this.onSelect,
  });

  final String exercise;
  final bool hasData;
  final Function() onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.insights),
          title: const Text('Graphs'),
          onTap: () async {
            Navigator.pop(context);

            final gymSet = await (db.gymSets.select()
                  ..where((tbl) => tbl.name.equals(exercise))
                  ..limit(1))
                .getSingle();

            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => gymSet.cardio
                    ? CardioPage(name: exercise)
                    : StrengthPage(
                        name: exercise,
                      ),
              ),
            );
          },
        ),
        if (hasData)
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () async {
              Navigator.pop(context);
              final gymSet = await (db.select(db.gymSets)
                    ..where((r) => db.gymSets.name.equals(exercise))
                    ..orderBy([
                      (u) => drift.OrderingTerm(
                            expression: u.created,
                            mode: drift.OrderingMode.desc,
                          ),
                    ])
                    ..limit(1))
                  .getSingle();
              if (!context.mounted) return;
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditGymSet(gymSet: gymSet),
                ),
              );
              onSelect();
            },
          ),
        if (hasData)
          ListTile(
            leading: const Icon(Icons.undo),
            title: const Text('Undo'),
            onTap: () async {
              Navigator.pop(context);
              final gymSet = await (db.select(db.gymSets)
                    ..where((r) => db.gymSets.name.equals(exercise))
                    ..orderBy([
                      (u) => drift.OrderingTerm(
                            expression: u.created,
                            mode: drift.OrderingMode.desc,
                          ),
                    ])
                    ..limit(1))
                  .getSingle();
              await db.gymSets.deleteOne(gymSet);
              onSelect();
            },
          ),
      ],
    );
  }
}
