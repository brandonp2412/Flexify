import 'package:drift/drift.dart';
import 'package:flexify/main.dart';
import 'package:flutter/material.dart';

class ExerciseTile extends StatefulWidget {
  final String exercise;
  final bool isSelected;
  final VoidCallback onTap;

  const ExerciseTile({
    Key? key,
    required this.exercise,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  late Stream<TypedResult> stream;

  @override
  void initState() {
    super.initState();
    var countExp = database.gymSets.name.count();
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    final startOfTomorrow = startOfToday.add(const Duration(days: 1));

    stream = (database.selectOnly(database.gymSets)
          ..addColumns([countExp, database.gymSets.name])
          ..where(database.gymSets.created.isBiggerOrEqualValue(startOfToday))
          ..where(database.gymSets.created.isSmallerThanValue(startOfTomorrow))
          ..where(database.gymSets.name.equals(widget.exercise)))
        .watchSingle();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(children: [
        Radio(
          value: widget.isSelected,
          groupValue: true,
          onChanged: (value) {
            widget.onTap();
          },
        ),
        Text(widget.exercise),
      ]),
      subtitle: SizedBox(
        child: StreamBuilder<TypedResult>(
          stream: stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return const LinearProgressIndicator(value: 0);
            var countExp = database.gymSets.name.count();
            final count = snapshot.data!.read(countExp) ?? 0;
            return LinearProgressIndicator(
              value: count / 5,
            );
          },
        ),
      ),
    );
  }
}
