import 'package:csv/csv.dart';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/main.dart';
import 'package:flexify/logging.dart';
import 'package:flexify/settings/backup_archive.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
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
    return TextButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          builder: (context) {
            return SafeArea(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.insights),
                    title: const Text('Graphs'),
                    onTap: () async {
                      Navigator.pop(context);
                      if (!await requestNotificationPermission()) return;
                      final gymSets = await db.gymSets.select().get();
                      final List<List<dynamic>> data = [
                        [
                          'id',
                          'name',
                          'reps',
                          'weight',
                          'created',
                          'unit',
                          'bodyWeight',
                          'duration',
                          'distance',
                          'cardio',
                          'hidden',
                          'incline',
                        ],
                      ];
                      for (var gymSet in gymSets) {
                        data.add([
                          gymSet.id,
                          gymSet.name,
                          gymSet.reps,
                          gymSet.weight,
                          gymSet.created.toIso8601String(),
                          gymSet.unit,
                          gymSet.bodyWeight,
                          gymSet.duration,
                          gymSet.distance,
                          gymSet.cardio,
                          gymSet.hidden,
                          gymSet.incline,
                        ]);
                      }
                      final csv = CsvEncoder(lineDelimiter: "\n").convert(data);
                      final bytes = Uint8List.fromList(csv.codeUnits);
                      await FilePicker.saveFile(
                        fileName: 'graphs.csv',
                        bytes: bytes,
                      );
                      talker.info(
                        'Exported ${gymSets.length} graph entries to CSV',
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.event),
                    title: const Text('Plans'),
                    onTap: () async {
                      Navigator.pop(context);
                      final plans = await db.plans.select().get();
                      final List<List<dynamic>> data = [
                        ['id', 'days', 'title', 'sequence', 'exercises'],
                      ];
                      for (var plan in plans) {
                        final planExercises =
                            await (db.planExercises.select()..where(
                                  (u) => u.planId.equals(plan.id) & u.enabled,
                                ))
                                .get();
                        data.add([
                          plan.id,
                          plan.days,
                          plan.title ?? '',
                          plan.sequence ?? '',
                          planExercises.map((e) => e.exercise).join(';'),
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
                    title: const Text('Backup'),
                    onTap: () async {
                      Navigator.pop(context);
                      setState(() => exporting = true);
                      final tempDirectory = await getTemporaryDirectory();
                      final workingDirectory = await tempDirectory.createTemp(
                        'flexify-export-',
                      );
                      try {
                        final dbFolder =
                            await getApplicationDocumentsDirectory();
                        final archive = await createBackupArchive(
                          databasePath: p.join(
                            dbFolder.path,
                            backupDatabaseName,
                          ),
                          workingDirectory: workingDirectory,
                        );
                        await FilePicker.saveFile(
                          fileName: 'flexify-backup.zip',
                          bytes: await archive.readAsBytes(),
                          type: FileType.custom,
                          allowedExtensions: ['zip'],
                        );
                        talker.info('Exported Flexify data and image backup');
                      } finally {
                        await workingDirectory.delete(recursive: true);
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
      icon: const Icon(Icons.download),
      label: exporting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            )
          : const Text('Export data'),
    );
  }
}
