import 'package:flexify/view_graph_page.dart';
import 'package:flutter/material.dart';

class GraphTile extends StatelessWidget {
  final String gymSetName;
  final double weight;

  const GraphTile({Key? key, required this.gymSetName, required this.weight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(gymSetName),
      subtitle: Text(weight.toString()),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewGraphPage(
                    name: gymSetName,
                  )),
        );
      },
    );
  }
}
