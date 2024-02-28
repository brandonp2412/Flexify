import 'package:flexify/database.dart';
import 'package:flutter/material.dart';

class GymSetTile extends StatelessWidget {
  final GymSet gymSet;

  const GymSetTile({Key? key, required this.gymSet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${gymSet.reps} x ${gymSet.weight}${gymSet.unit}"),
      subtitle: Text(gymSet.created.toString()),
    );
  }
}
