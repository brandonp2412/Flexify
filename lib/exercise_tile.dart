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
