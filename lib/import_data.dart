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

      if (!ctx.mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(ctx, rootNavigator: true)
            .pushNamedAndRemoveUntil('/', (_) => false);
      });
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
        Uint8List? fileBytes = result.files.single.bytes;
        if (fileBytes == null) {
          throw Exception('Could not read file data');
        }
        csvContent = String.fromCharCodes(fileBytes);
      } else {
        File file = File(result.files.single.path!);
        if (!await file.exists()) {
          throw Exception('Selected file does not exist');
        }
        csvContent = await file.readAsString();
      }

      List<List<dynamic>> rows =
          const CsvToListConverter(eol: "\n").convert(csvContent);

      if (rows.isEmpty) {
        throw Exception('CSV file is empty');
      }

      if (rows.length <= 1) {
        throw Exception('CSV file must contain at least one data row');
      }

      final columns = rows.first;

      final gymSets = rows.skip(1).map(
        (row) {
          try {
            if (row.length < 6) {
              throw Exception('Row has insufficient columns: ${row.length}');
            }

            Value<double> reps;
            if (row[2] is String) {
              final parsedReps = double.tryParse(row[2]);
              if (parsedReps == null) {
                throw Exception('Invalid reps value: ${row[2]}');
              }
              reps = Value(parsedReps);
            } else if (row[2] is num) {
              reps = Value(row[2].toDouble());
            } else {
              throw Exception('Invalid reps data type: ${row[2].runtimeType}');
            }

            Value<double> weight;
            if (row[3] is String) {
              final parsedWeight = double.tryParse(row[3]);
              if (parsedWeight == null) {
                throw Exception('Invalid weight value: ${row[3]}');
              }
              weight = Value(parsedWeight);
            } else if (row[3] is num) {
              weight = Value(row[3].toDouble());
            } else {
              throw Exception(
                'Invalid weight data type: ${row[3].runtimeType}',
              );
            }

            Value<bool> hidden;
            var bodyWeight = const Value(0.0);
            if (columns.elementAtOrNull(6) == 'hidden') {
              if (row.elementAtOrNull(6) is double)
                hidden = Value(row[6] == 1.0);
              else
                hidden = Value(row[6] == "1");
            } else {
              hidden = const Value(false);
              final bodyWeightValue = row.elementAtOrNull(6);
              if (bodyWeightValue is num) {
                bodyWeight = Value(bodyWeightValue.toDouble());
              } else if (bodyWeightValue is String) {
                bodyWeight = Value(double.tryParse(bodyWeightValue) ?? 0.0);
              } else {
                bodyWeight = const Value(0.0);
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
                try {
                  hidden = Value(bool.parse(hiddenValue.toString()));
                } catch (e) {
                  hidden = const Value(false);
                }
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
          } catch (e) {
            throw Exception(
              'Error processing row ${rows.indexOf(row) + 1}: $e',
            );
          }
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

  Future<void> importPlans(BuildContext context) async {
    Navigator.pop(context);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result == null) return;

      String csvContent;

      if (kIsWeb) {
        Uint8List? fileBytes = result.files.single.bytes;
        if (fileBytes == null) {
          throw Exception('Could not read file data');
        }
        csvContent = String.fromCharCodes(fileBytes);
      } else {
        File file = File(result.files.single.path!);
        if (!await file.exists()) {
          throw Exception('Selected file does not exist');
        }
        csvContent = await file.readAsString();
      }

      List<List<dynamic>> rows =
          const CsvToListConverter(eol: "\n").convert(csvContent);

      if (rows.isEmpty) {
        throw Exception('CSV file is empty');
      }

      if (rows.length <= 1) {
        throw Exception('CSV file must contain at least one data row');
      }

      List<PlansCompanion> plans = [];
      for (final row in rows.skip(1)) {
        try {
          if (row.length < 3) {
            throw Exception('Row has insufficient columns: ${row.length}');
          }

          var sequence = row.elementAtOrNull(4);
          if (sequence is String) {
            final parsedSequence = int.tryParse(sequence);
            sequence = parsedSequence ?? 0;
          } else if (sequence is! int) {
            sequence = 0;
          }

          plans.add(
            PlansCompanion(
              days: Value(row[1]?.toString() ?? ''),
              exercises: Value(row[2]?.toString() ?? ''),
              title: Value(row.elementAtOrNull(3)?.toString()),
              sequence: Value(sequence),
            ),
          );
        } catch (e) {
          throw Exception('Error processing row ${rows.indexOf(row) + 1}: $e');
        }
      }

      await db.plans.deleteAll();
      await db.plans.insertAll(plans);

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
