import 'package:flutter/material.dart';

class GraphTile extends StatelessWidget {
  final String gymSetName;

  const GraphTile({Key? key, required this.gymSetName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(gymSetName),
    );
  }
}
