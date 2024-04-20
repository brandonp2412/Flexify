import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:flexify/main.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';

class DownloadRecordsButton extends StatelessWidget {
  const DownloadRecordsButton({
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
                        final gymSets = await db.gymSets.select().get();
                        final List<List<dynamic>> csvData = [
                          [
                            'id',
                            'name',
                            'reps',
                            'weight',
                            'created',
                            'unit',
                            'bodyWeight'
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
                          ]);
                        }

                        if (!await requestNotificationPermission()) return;
                        final csv = const ListToCsvConverter(eol: "\n")
                            .convert(csvData);
                        android.invokeMethod('save', ['graphs.csv', csv]);
                      }),
                  ListTile(
                    leading: const Icon(Icons.event),
                    title: const Text('Plans'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      final plans = await db.plans.select().get();
                      final List<List<dynamic>> csvData = [
                        ['id', 'days', 'exercises', 'title', 'sequence']
                      ];
                      for (var plan in plans) {
                        csvData.add([
                          plan.id,
                          plan.days,
                          plan.exercises,
                          plan.title ?? '',
                          plan.sequence ?? ''
                        ]);
                      }

                      if (!await requestNotificationPermission()) return;
                      final csv =
                          const ListToCsvConverter(eol: "\n").convert(csvData);
                      android.invokeMethod('save', ['plans.csv', csv]);
                    },
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(Icons.download),
        label: const Text('Export data'));
  }
}
