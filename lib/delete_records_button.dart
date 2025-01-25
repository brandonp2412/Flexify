import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteRecordsButton extends StatelessWidget {
  final BuildContext pageContext;

  const DeleteRecordsButton({
    super.key,
    required this.pageContext,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.insights),
                  title: const Text('Graphs'),
                  onTap: () async {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text(
                            'Are you sure you want to delete all graphs? This action is not reversible.',
                          ),
                          actions: <Widget>[
                            TextButton.icon(
                              label: const Text('Cancel'),
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton.icon(
                              label: const Text('Delete'),
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                Navigator.pop(context);
                                await db.delete(db.gymSets).go();
                                if (!pageContext.mounted) return;
                                Navigator.pop(pageContext);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Plans'),
                  onTap: () async {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text(
                            'Are you sure you want to delete all plans? This action is not reversible.',
                          ),
                          actions: <Widget>[
                            TextButton.icon(
                              label: const Text('Cancel'),
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton.icon(
                              label: const Text('Delete'),
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                final planState = pageContext.read<PlanState>();
                                Navigator.pop(context);
                                await db.delete(db.plans).go();
                                planState.updatePlans(null);
                                if (!pageContext.mounted) return;
                                Navigator.pop(pageContext);
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
      icon: const Icon(Icons.delete),
      label: const Text('Delete records'),
    );
  }
}
