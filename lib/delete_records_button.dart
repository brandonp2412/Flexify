import 'dart:io';

import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DeleteRecordsButton extends StatelessWidget {
  final BuildContext ctx;

  const DeleteRecordsButton({super.key, required this.ctx});

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
                    title: Text(context.l10n.navGraphs),
                    onTap: () async {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(context.l10n.confirmDelete),
                            content: Text(
                              context.l10n.deleteAllGraphsConfirmation,
                            ),
                            actions: <Widget>[
                              TextButton.icon(
                                label: Text(context.l10n.actionCancel),
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton.icon(
                                label: Text(context.l10n.actionDelete),
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await (db.delete(
                                    db.gymSets,
                                  )..where((u) => u.hidden.equals(false))).go();
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
                    title: Text(context.l10n.navPlans),
                    onTap: () async {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(context.l10n.confirmDelete),
                            content: Text(
                              context.l10n.deleteAllPlansConfirmation,
                            ),
                            actions: <Widget>[
                              TextButton.icon(
                                label: Text(context.l10n.actionCancel),
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton.icon(
                                label: Text(context.l10n.actionDelete),
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await db.delete(db.plans).go();
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
                    title: Text(context.l10n.databaseLabel),
                    onTap: () async {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(context.l10n.confirmDelete),
                            content: Text(
                              context.l10n.deleteDatabaseConfirmation,
                            ),
                            actions: <Widget>[
                              TextButton.icon(
                                label: Text(context.l10n.actionCancel),
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton.icon(
                                label: Text(context.l10n.actionDelete),
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
      label: Text(context.l10n.deleteRecords),
    );
  }
}
