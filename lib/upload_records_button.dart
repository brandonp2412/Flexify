import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';

class UploadRecordsButton extends StatelessWidget {
  const UploadRecordsButton({
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
                    title: const Text('Gym sets'),
                    onTap: () async {
                      Navigator.pop(context);
                      String csv = await android.invokeMethod('read');
                      List<List<dynamic>> rows =
                          const CsvToListConverter(eol: "\n").convert(csv);
                      if (rows.isEmpty) return;
                      try {
                        final gymSets = rows.map(
                          (row) => GymSetsCompanion(
                            name: Value(row[1]),
                            reps: Value(row[2]),
                            weight: Value(row[3]),
                            created: Value(parseDate(row[4])),
                            unit: Value(row[5]),
                          ),
                        );
                        await db.batch(
                          (batch) => batch.insertAll(db.gymSets, gymSets),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Uploaded gym sets.')),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to upload csv.')),
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.event),
                    title: const Text('Plans'),
                    onTap: () async {
                      Navigator.of(context).pop();
                      String csv = await android.invokeMethod('read');
                      List<List<dynamic>> rows =
                          const CsvToListConverter(eol: "\n").convert(csv);
                      if (rows.isEmpty) return;
                      try {
                        final plans = rows.map(
                          (row) => PlansCompanion(
                            days: Value(row[1]),
                            exercises: Value(row[2]),
                            title: Value(row.elementAtOrNull(3)),
                          ),
                        );
                        await db.batch(
                          (batch) => batch.insertAll(db.plans, plans),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Uploaded plans.')),
                        );
                      } catch (e) {
                        if (!context.mounted) return;
                        debugPrint(e.toString());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to upload csv.')),
                        );
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(Icons.upload),
        label: const Text('Upload CSV'));
  }
}
