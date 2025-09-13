import 'dart:io';

import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class DeleteRecordsButton extends StatelessWidget {
  final BuildContext ctx;

  const DeleteRecordsButton({
    super.key,
    required this.ctx,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        showModalBottomSheet(
          useRootNavigator: true,
          context: context,
          builder: (context) {
            return SafeArea(
              child: Wrap(
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
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton.icon(
                                label: const Text('Delete'),
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await (db.delete(db.gymSets)
                                        ..where((u) => u.hidden.equals(false)))
                                      .go();
                                  if (!ctx.mounted) return;
                                  Navigator.pop(ctx);
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
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton.icon(
                                label: const Text('Delete'),
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final planState = ctx.read<PlanState>();
                                  Navigator.pop(context);
                                  await db.delete(db.plans).go();
                                  planState.updatePlans(null);
                                  if (!ctx.mounted) return;
                                  Navigator.pop(ctx);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.storage),
                    title: const Text('Database'),
                    onTap: () async {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                              'Are you sure you want to delete your database? This action is not reversible and will destroy all your data.',
                            ),
                            actions: <Widget>[
                              TextButton.icon(
                                label: const Text('Cancel'),
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton.icon(
                                label: const Text('Delete'),
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final dbFolder =
                                      await getApplicationDocumentsDirectory();
                                  final file = File(
                                    p.join(dbFolder.path, 'flexify.sqlite'),
                                  );
                                  await db.close();
                                  await db.executor.close();
                                  await file.delete();
                                  if (defaultTargetPlatform ==
                                          TargetPlatform.iOS ||
                                      defaultTargetPlatform ==
                                          TargetPlatform.android)
                                    SystemNavigator.pop();
                                  else
                                    exit(0);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.delete),
      label: const Text('Delete records'),
    );
  }
}
