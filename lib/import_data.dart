import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flexify/settings/settings_state.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
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
          useRootNavigator: true,
          context: context,
          builder: (context) {
            return SafeArea(
              child: Wrap(
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
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.upload),
      label: const Text('Import data'),
    );
  }

  Future<void> importDatabase(BuildContext context) async {
    Navigator.pop(context);

    try {
      if (kIsWeb) {
        await _importDatabaseWeb(context);
      } else {
        await _importDatabaseNative(context);
      }
    } catch (e) {
      if (!ctx.mounted) return;
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Failed to import database: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _importDatabaseNative(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    File sourceFile = File(result.files.single.path!);

    if (!await sourceFile.exists()) {
      throw Exception('Selected file does not exist');
    }

    final dbFolder = await getApplicationDocumentsDirectory();
    await db.close();

    try {
      await sourceFile.copy(p.join(dbFolder.path, 'flexify.sqlite'));
      db = AppDatabase();

      await (db.settings.update())
          .write(const SettingsCompanion(alarmSound: Value('')));

      if (!ctx.mounted) return;
      final settingsState = ctx.read<SettingsState>();
      await settingsState.init();
      // if (!ctx.mounted) return;
      // final planState = ctx.read<PlanState>();
      // planState.updatePlans(null);

      if (!ctx.mounted) return;
      Navigator.of(ctx, rootNavigator: true)
          .pushNamedAndRemoveUntil('/', (_) => false);
    } catch (e) {
      db = AppDatabase();
      rethrow;
    }
  }

  Future<void> _importDatabaseWeb(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    Uint8List? fileBytes = result.files.single.bytes;
    if (fileBytes == null) {
      throw Exception('Could not read file data');
    }

    throw Exception(
      'Database import on web requires manual data migration. Please export your data as CSV files and import those instead.',
    );
  }

  Future<void> importGraphs(BuildContext context) async {
    Navigator.pop(context);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null) return;

      String csvContent;
      if (kIsWeb) {
        final fileBytes = result.files.single.bytes;
        if (fileBytes == null) throw Exception('Could not read file data');
        csvContent = String.fromCharCodes(fileBytes);
      } else {
        final file = File(result.files.single.path!);
        if (!await file.exists())
          throw Exception('Selected file does not exist');

        try {
          csvContent = await file.readAsString();
        } on FormatException {
          csvContent = await file.readAsString(encoding: latin1);
        }
      }

      final rows = const CsvToListConverter(eol: "\n").convert(csvContent);

      if (rows.isEmpty) throw Exception('CSV file is empty');
      if (rows.length <= 1)
        throw Exception('CSV file must contain at least one data row');

      final columns = rows.first;

      final gymSets = rows.skip(1).map((row) {
        if (row.length < 6) {
          throw Exception(
              'Row ${rows.indexOf(row) + 1} has insufficient columns: ${row.length}');
        }

        final reps = _parseDouble(row[2], 'reps', rows.indexOf(row) + 1);
        final weight = _parseDouble(row[3], 'weight', rows.indexOf(row) + 1);

        Value<bool> hidden;
        var bodyWeight = const Value(0.0);

        if (columns.elementAtOrNull(6) == 'hidden') {
          hidden = Value(
              row.elementAtOrNull(6) == 1.0 || row.elementAtOrNull(6) == "1");
        } else {
          hidden = const Value(false);
          final bodyWeightValue = row.elementAtOrNull(6);
          if (bodyWeightValue is num) {
            bodyWeight = Value(bodyWeightValue.toDouble());
          } else if (bodyWeightValue is String) {
            bodyWeight = Value(double.tryParse(bodyWeightValue) ?? 0.0);
          }
        }

        if (columns.elementAtOrNull(7) == 'bodyWeight') {
          final bodyWeightValue = row.elementAtOrNull(7);
          if (bodyWeightValue != null) {
            bodyWeight =
                Value(double.tryParse(bodyWeightValue.toString()) ?? 0);
          }
        }

        if (columns.elementAtOrNull(10) == 'hidden') {
          final hiddenValue = row.elementAtOrNull(10);
          if (hiddenValue != null) {
            hidden = Value(hiddenValue.toString().toLowerCase() == 'true');
          }
        }

        return GymSetsCompanion(
          name: Value(row[1]?.toString() ?? ''),
          reps: reps,
          weight: weight,
          created: Value(parseDate(row[4])),
          unit: Value(row[5]?.toString() ?? ''),
          hidden: hidden,
          bodyWeight: bodyWeight,
          duration: columns.elementAtOrNull(7) == 'duration'
              ? Value(double.tryParse(row[7]?.toString() ?? '0') ?? 0)
              : const Value(0),
          distance: columns.elementAtOrNull(8) == 'distance'
              ? Value(double.tryParse(row[8]?.toString() ?? '0') ?? 0)
              : const Value(0),
          cardio: columns.elementAtOrNull(9) == 'cardio'
              ? Value(parseBool(row[9]))
              : const Value(false),
          incline: columns.elementAtOrNull(11) == 'incline'
              ? Value(int.tryParse(row[11]?.toString() ?? ''))
              : const Value(null),
        );
      });

      await db.gymSets.deleteAll();
      await db.gymSets.insertAll(gymSets);

      final weightSet = await getBodyWeight();
      if (weightSet != null) {
        (db.gymSets.update()..where((tbl) => tbl.bodyWeight.equals(0)))
            .write(GymSetsCompanion(bodyWeight: Value(weightSet.weight)));
      }

      if (!ctx.mounted) return;
      Navigator.pop(ctx);

      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Graphs data imported successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!ctx.mounted) return;
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Failed to import graphs: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Value<double> _parseDouble(dynamic value, String fieldName, int rowNumber) {
    if (value is num) return Value(value.toDouble());
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed == null) {
        throw Exception('Invalid $fieldName value in row $rowNumber: $value');
      }
      return Value(parsed);
    }
    throw Exception(
        'Invalid $fieldName data type in row $rowNumber: ${value.runtimeType}');
  }

  Future<void> importPlans(BuildContext context) async {
    Navigator.pop(context);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null) return;

      String csvContent;
      if (kIsWeb) {
        final fileBytes = result.files.single.bytes;
        if (fileBytes == null) throw Exception('Could not read file data');
        csvContent = String.fromCharCodes(fileBytes);
      } else {
        final file = File(result.files.single.path!);
        if (!await file.exists())
          throw Exception('Selected file does not exist');

        try {
          csvContent = await file.readAsString();
        } on FormatException {
          csvContent = await file.readAsString(encoding: latin1);
        }
      }

      final csvList = const CsvToListConverter(eol: "\n").convert(csvContent);

      if (csvList.isEmpty) throw Exception('CSV file is empty');
      if (csvList.length <= 1)
        throw Exception('CSV file must contain at least one data row');

      final plansToInsert = <PlansCompanion>[];
      final planExercisesToInsert = <PlanExercisesCompanion>[];

      for (final row in csvList.skip(1)) {
        plansToInsert.add(
          PlansCompanion.insert(
            id: Value(int.parse(row[0].toString())),
            days: row[1].toString(),
            title: Value(row[2].toString()),
            sequence: Value(int.parse(row[3].toString())),
          ),
        );

        final exerciseNames = row[4].toString().split(';');
        planExercisesToInsert.addAll(
          exerciseNames.map((exerciseName) {
            return PlanExercisesCompanion.insert(
              planId: int.parse(row[0].toString()),
              exercise: exerciseName,
              enabled: true,
              timers: const Value(true),
            );
          }),
        );
      }

      await db.plans.deleteAll();
      await db.planExercises.deleteAll();
      await db.plans.insertAll(plansToInsert);
      await db.planExercises.insertAll(planExercisesToInsert);

      if (!ctx.mounted) return;
      ctx.read<PlanState>().updatePlans(null);
      Navigator.pop(ctx);

      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Plans imported successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!ctx.mounted) return;
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Failed to import plans: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  bool parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == 'true' || lower == '1';
    }
    if (value is num) return value != 0;
    return false;
  }
}
