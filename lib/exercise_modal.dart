import 'package:drift/drift.dart' as drift;
import 'package:flexify/edit_gym_set.dart';
import 'package:flexify/main.dart';
import 'package:flexify/view_cardio_page.dart';
import 'package:flexify/view_strength_page.dart';
import 'package:flutter/material.dart';

class ExerciseModal extends StatelessWidget {
  const ExerciseModal({
    super.key,
    required this.exercise,
    required this.hasData,
  });

  final String exercise;
  final bool hasData;

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
                        ? ViewCardioPage(name: exercise)
                        : ViewStrengthPage(
                            name: exercise,
                          )));
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
                          expression: u.created, mode: drift.OrderingMode.desc),
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
                          expression: u.created, mode: drift.OrderingMode.desc),
                    ])
                    ..limit(1))
                  .getSingle();
              await db.gymSets.deleteOne(gymSet);
            },
          ),
      ],
    );
  }
}
