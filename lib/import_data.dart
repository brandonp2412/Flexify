import 'dart:io';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ImportData extends StatelessWidget {
  final BuildContext ctx;

  const ImportData({
    super.key,
    required this.ctx,
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
                  onTap: () => importGraphs(context),
                ),
                ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Plans'),
                  onTap: () => importPlans(context),
                ),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('Database'),
                  onTap: () => importDatabase(context),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.upload),
      label: const Text('Import data'),
    );
  }

  importDatabase(BuildContext context) async {
    Navigator.pop(context);
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    File sourceFile = File(result.files.single.path!);
    final dbFolder = await getApplicationDocumentsDirectory();
    await db.close();
    await sourceFile.copy(p.join(dbFolder.path, 'flexify.sqlite'));
    db = AppDatabase();
    await (db.settings.update())
        .write(const SettingsCompanion(alarmSound: Value('')));
    if (!ctx.mounted) return;
    final settingsState = ctx.read<SettingsState>();
    await settingsState.init();
    if (!ctx.mounted) return;
    Navigator.pushNamedAndRemoveUntil(ctx, '/', (_) => false);
  }

  importGraphs(BuildContext context) async {
    Navigator.pop(context);
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    File file = File(result.files.single.path!);
    var csv = await file.readAsString();
    List<List<dynamic>> rows = const CsvToListConverter(eol: "\n").convert(csv);

    if (rows.length <= 1) return;

    final columns = rows.first;

    final gymSets = rows.skip(1).map(
      (row) {
        Value<double> reps;
        if (row[2] is String)
          reps = Value(double.parse(row[2]));
        else
          reps = Value(row[2]);

        Value<double> weight;
        if (row[3] is String)
          weight = Value(double.parse(row[3]));
        else
          weight = Value(row[3]);

        Value<bool> hidden;
        var bodyWeight = const Value(0.0);
        if (columns.elementAtOrNull(6) == 'hidden') {
          if (row.elementAtOrNull(6) is double)
            hidden = Value(row[6] == 1.0);
          else
            hidden = Value(row[6] == "1");
        } else {
          hidden = const Value(false);
          bodyWeight = Value(row.elementAtOrNull(6) ?? 0);
        }

        if (columns.elementAtOrNull(7) == 'bodyWeight')
          bodyWeight = Value(double.tryParse(row.elementAtOrNull(7)) ?? 0);

        if (columns.elementAtOrNull(10) == 'hidden')
          hidden = Value(bool.parse(row[10]));

        return GymSetsCompanion(
          name: Value(row[1]),
          reps: reps,
          weight: weight,
          created: Value(parseDate(row[4])),
          unit: Value(row[5]),
          hidden: hidden,
          bodyWeight: bodyWeight,
          duration: columns.elementAtOrNull(7) == 'duration'
              ? Value(row[7])
              : const Value(0),
          distance: columns.elementAtOrNull(8) == 'distance'
              ? Value(row[8])
              : const Value(0),
          cardio: columns.elementAtOrNull(9) == 'cardio'
              ? Value(bool.parse(row[9]))
              : const Value(false),
          incline: columns.elementAtOrNull(11) == 'incline'
              ? Value(int.tryParse(row[9]))
              : const Value(null),
        );
      },
    );

    await db.gymSets.deleteAll();
    await db.gymSets.insertAll(gymSets);

    final weightSet = await getBodyWeight();
    if (weightSet != null)
      (db.gymSets.update()..where((tbl) => tbl.bodyWeight.equals(0)))
          .write(GymSetsCompanion(bodyWeight: Value(weightSet.weight)));

    if (!ctx.mounted) return;
    Navigator.pop(ctx);
  }

  importPlans(BuildContext context) async {
    Navigator.pop(context);
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    File file = File(result.files.single.path!);
    var csv = await file.readAsString();
    List<List<dynamic>> rows = const CsvToListConverter(eol: "\n").convert(csv);

    if (rows.length <= 1) return;
    List<PlansCompanion> plans = [];
    for (final row in rows.skip(1)) {
      var sequence = row.elementAtOrNull(4);
      if (sequence is String) sequence = 0;
      plans.add(
        PlansCompanion(
          days: Value(row[1]),
          exercises: Value(row[2]),
          title: Value(row.elementAtOrNull(3)),
          sequence: Value(sequence),
        ),
      );
    }

    await db.plans.deleteAll();
    await db.plans.insertAll(plans);
    if (!ctx.mounted) return;
    ctx.read<PlanState>().updatePlans(null);
    Navigator.pop(ctx);
  }
}
