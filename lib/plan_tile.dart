import 'package:flexify/database.dart';
import 'package:flexify/edit_plan_page.dart';
import 'package:flexify/main.dart';
import 'package:flexify/start_plan_page.dart';
import 'package:flutter/material.dart';

class PlanTile extends StatelessWidget {
  const PlanTile({
    super.key,
    required this.plan,
    required this.active,
    required this.index,
  });

  final Plan plan;
  final bool active;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        plan.days.split(',').join(', '),
        style: TextStyle(
          fontWeight: active ? FontWeight.bold : null,
          decoration: active ? TextDecoration.underline : null,
        ),
      ),
      subtitle: Text(plan.exercises.split(',').join(', ')),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StartPlanPage(plan: plan)),
        );
      },
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EditPlanPage(plan: plan.toCompanion(false))),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text(
                              'Are you sure you want to delete this plan?'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                await database
                                    .delete(database.plans)
                                    .delete(plan);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
