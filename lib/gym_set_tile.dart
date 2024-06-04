import 'package:flexify/database/database.dart';
import 'package:flutter/material.dart';

class GymSetTile extends StatelessWidget {
  final GymSet gymSet;

  const GymSetTile({super.key, required this.gymSet});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${gymSet.reps} x ${gymSet.weight}${gymSet.unit}"),
      subtitle: Text(gymSet.created.toString()),
    );
  }
}
