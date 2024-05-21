import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/main.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ExportData extends StatelessWidget {
  const ExportData({
    super.key,
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
                    if (!await requestNotificationPermission()) return;
                    final gymSets = await db.gymSets.select().get();
                    final List<List<dynamic>> csvData = [
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
                      ]
                    ];
                    for (var gymSet in gymSets) {
                      csvData.add([
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
                    final csv =
                        const ListToCsvConverter(eol: "\n").convert(csvData);
                    final bytes = Uint8List.fromList(csv.codeUnits);
                    await FilePicker.platform.saveFile(
                      fileName: 'graphs.csv',
                      bytes: bytes,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Plans'),
                  onTap: () async {
                    Navigator.pop(context);
                    final plans = await db.plans.select().get();
                    final List<List<dynamic>> csvData = [
                      ['id', 'days', 'exercises', 'title', 'sequence'],
                    ];
                    for (var plan in plans) {
                      csvData.add([
                        plan.id,
                        plan.days,
                        plan.exercises,
                        plan.title ?? '',
                        plan.sequence ?? '',
                      ]);
                    }

                    if (!await requestNotificationPermission()) return;

                    final csv =
                        const ListToCsvConverter(eol: "\n").convert(csvData);
                    final bytes = Uint8List.fromList(csv.codeUnits);
                    await FilePicker.platform.saveFile(
                      fileName: 'plans.csv',
                      bytes: bytes,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('Database'),
                  onTap: () async {
                    Navigator.pop(context);
                    final dbFolder = await getApplicationDocumentsDirectory();
                    final file = File(p.join(dbFolder.path, 'flexify.sqlite'));
                    final bytes = await file.readAsBytes();
                    await FilePicker.platform.saveFile(
                      fileName: 'flexify.sqlite',
                      bytes: bytes,
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.download),
      label: const Text('Export data'),
    );
  }
}
