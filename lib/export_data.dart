import 'dart:convert';

import 'package:csv/csv.dart';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flex/data_portability/graph_csv.dart';
import 'package:flex/l10n/l10n.dart';
import 'package:flex/main.dart';
import 'package:flex/logging.dart';
import 'package:flex/plan/workout_sessions.dart';
import 'package:flex/settings/backup_archive.dart';
import 'package:flex/utils.dart';
import 'package:flex/storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ExportData extends StatefulWidget {
  const ExportData({super.key});

  @override
  State<ExportData> createState() => _ExportDataState();
}

class _ExportDataState extends State<ExportData> {
  bool exporting = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          builder: (context) {
            return SafeArea(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.insights),
                    title: Text(context.l10n.navGraphs),
                    onTap: () async {
                      Navigator.pop(context);
                      if (!await requestNotificationPermission()) return;
                      final csv = await exportGraphCsv(db);
                      final bytes = Uint8List.fromList(utf8.encode(csv));
                      await FilePicker.saveFile(
                        fileName: 'graphs.csv',
                        bytes: bytes,
                      );
                      talker.info('Exported redesigned graph/history CSV');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.event),
                    title: Text(context.l10n.navPlans),
                    onTap: () async {
                      Navigator.pop(context);
                      final plans = await db.plans.select().get();
                      final List<List<dynamic>> data = [
                        ['id', 'days', 'title', 'sequence', 'exercises'],
                      ];
                      for (var plan in plans) {
                        final planExercises = await getPlanExerciseEntries(
                          db,
                          plan.id,
                        );
                        data.add([
                          plan.id,
                          plan.days,
                          plan.title ?? '',
                          plan.sequence ?? '',
                          planExercises.map((e) => e.exercise.name).join(';'),
                        ]);
                      }

                      if (!await requestNotificationPermission()) return;

                      final csv = CsvEncoder(lineDelimiter: "\n").convert(data);
                      final bytes = Uint8List.fromList(csv.codeUnits);
                      await FilePicker.saveFile(
                        fileName: 'plans.csv',
                        bytes: bytes,
                        type: FileType.custom,
                        allowedExtensions: ['csv'],
                      );
                      talker.info('Exported ${plans.length} plans to CSV');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.storage),
                    title: Text(context.l10n.backupLabel),
                    onTap: () async {
                      Navigator.pop(context);
                      setState(() => exporting = true);
                      final tempDirectory = await getTemporaryDirectory();
                      final workDir = await tempDirectory.createTemp(
                        'flex-export-',
                      );
                      try {
                        final databaseFile = await getDatabaseFile();
                        final archive = await createBackupArchive(
                          databasePath: databaseFile.path,
                          workingDirectory: workDir,
                        );
                        await FilePicker.saveFile(
                          fileName: 'flex-backup.zip',
                          bytes: await archive.readAsBytes(),
                          type: FileType.custom,
                          allowedExtensions: ['zip'],
                        );
                        talker.info('Exported Flex data and image backup');
                      } finally {
                        await workDir.delete(recursive: true);
                        if (mounted) setState(() => exporting = false);
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      leading: exporting
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.download_outlined),
      title: Text(context.l10n.exportData),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}
