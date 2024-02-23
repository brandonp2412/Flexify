import 'package:flexify/view_graph_page.dart';
import 'package:flutter/material.dart';

class GraphTile extends StatelessWidget {
  final String gymSetName;

  const GraphTile({Key? key, required this.gymSetName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(gymSetName),
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
