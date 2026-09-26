import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/app_permissions_dialog.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/logging.dart';
import 'package:flexify/settings/backup_archive.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

final class _ImportValidationException implements Exception {
  const _ImportValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}

String _localizedImportError(Object error, AppLocalizations l10n) {
  if (error is MissingBackupDatabaseException) {
    return l10n.backupArchiveMissingDatabase;
  }
  if (error is _ImportValidationException) return error.message;
  return l10n.unexpectedError;
}

class ImportData extends StatelessWidget {
  final BuildContext ctx;

  const ImportData({super.key, required this.ctx});

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
                    onTap: () => importGraphs(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.event),
                    title: Text(context.l10n.navPlans),
                    onTap: () => importPlans(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.storage),
                    title: Text(context.l10n.backupLabel),
                    onTap: () => importDatabase(context),
                  ),
                ],
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.upload),
      label: Text(context.l10n.importData),
    );
  }

  Future<void> importDatabase(BuildContext context) async {
    final l10n = ctx.l10n;
    Navigator.pop(context);
    talker.info('Starting Flexify database import');

    try {
      if (kIsWeb) {
        await _importDatabaseWeb(l10n);
      } else {
        await _importDatabaseNative(l10n);
      }
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace, 'Failed to import Flexify database');
      if (!ctx.mounted) return;
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;

      final title = Uri.encodeComponent(
        'Import failed: ${e.toString().split('\n').first}',
      );
      final body = Uri.encodeComponent('''
# Describe the bug
Failed to import a database.

# Error
```
${e.toString()}
```

# Stack trace
```
${stackTrace.toString()}
```

# App version
$version

# Steps to reproduce
1. Go to import database
2. Select file
3. See error
''');

      final url =
          'https://github.com/brandonp2412/Flexify/issues/new?title=$title&body=$body';

      final displayError = _localizedImportError(e, l10n);
      toast(
        l10n.failedToImportDatabase(displayError),
        duration: Duration(seconds: 10),
        action: SnackBarAction(
          label: l10n.actionReport,
          onPressed: () async {
            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      );
    }
  }

  Future<void> _importDatabaseNative(AppLocalizations l10n) async {
    final result = await FilePicker.pickFiles();
    if (result == null) return;

    final selectedFile = File(result.files.single.path!);
    if (!await selectedFile.exists()) {
      throw _ImportValidationException(l10n.selectedFileDoesNotExist);
    }

    final dbFolder = await getApplicationDocumentsDirectory();
    final tempDirectory = await getTemporaryDirectory();
    final workingDirectory = await tempDirectory.createTemp('flexify-import-');
    try {
      final sourceFile = p.extension(selectedFile.path).toLowerCase() == '.zip'
          ? await extractBackupArchive(
              archiveFile: selectedFile,
              workingDirectory: workingDirectory,
              documentsDirectory: dbFolder,
            )
          : selectedFile;

      await db.close();
      try {
        await sourceFile.copy(p.join(dbFolder.path, backupDatabaseName));
      } finally {
        db = AppDatabase.persistent();
      }
      dbVersion.value++;
      talker.info('Imported Flexify data and image backup');
    } finally {
      await workingDirectory.delete(recursive: true);
    }

    // Permission state belongs to this Android install, not to the imported
    // database. Force a fresh, single checklist for the imported settings.
    await (db.settings.update()).write(
      const SettingsCompanion(
        alarmSound: Value(''),
        explainedPermissions: Value(false),
        notificationPermissionRequested: Value(false),
      ),
    );

    final importedSettings = await (db.settings.select()..limit(1)).getSingle();

    if (!ctx.mounted) return;
    await showAppPermissionsDialog(
      ctx,
      required: true,
      settings: importedSettings,
    );

    if (!ctx.mounted) return;
    Navigator.of(
      ctx,
      rootNavigator: true,
    ).pushNamedAndRemoveUntil('/', (_) => false);
  }

  Future<void> _importDatabaseWeb(AppLocalizations l10n) async {
    FilePickerResult? result = await FilePicker.pickFiles();
    if (result == null) return;

    try {
      await result.files.single.readAsBytes();
    } catch (_) {
      throw _ImportValidationException(l10n.couldNotReadFileData);
    }

    throw _ImportValidationException(l10n.databaseImportWebUnsupported);
  }

  Future<void> importGraphs(BuildContext context) async {
    final l10n = ctx.l10n;
    Navigator.pop(context);

    try {
      FilePickerResult? result = await FilePicker.pickFiles();
      if (result == null) return;

      String csvContent;
      final fileBytes = await result.files.single.readAsBytes();
      if (kIsWeb) {
        csvContent = String.fromCharCodes(fileBytes);
      } else {
        try {
          csvContent = utf8.decode(fileBytes, allowMalformed: false);
        } catch (e) {
          csvContent = latin1.decode(fileBytes);
        }
      }

      final rows = CsvDecoder().convert(csvContent);

      if (rows.isEmpty) throw _ImportValidationException(l10n.csvFileEmpty);
      if (rows.length <= 1)
        throw _ImportValidationException(l10n.csvNeedsDataRow);

      final columns = rows.first;

      final gymSets = rows.skip(1).map((row) {
        if (row.length < 6) {
          throw _ImportValidationException(
            l10n.csvRowInsufficientColumns(rows.indexOf(row) + 1, row.length),
          );
        }

        final reps = _parseDouble(
          row[2],
          l10n.repsLabel,
          rows.indexOf(row) + 1,
          l10n,
        );
        final weight = _parseDouble(
          row[3],
          l10n.weightLabel,
          rows.indexOf(row) + 1,
          l10n,
        );

        Value<bool> hidden;
        var bodyWeight = const Value(0.0);

        if (columns.elementAtOrNull(6) == 'hidden') {
          hidden = Value(
            row.elementAtOrNull(6) == 1.0 || row.elementAtOrNull(6) == "1",
          );
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
            bodyWeight = Value(
              double.tryParse(bodyWeightValue.toString()) ?? 0,
            );
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
          created: Value(_parseDate(row[4], rows.indexOf(row) + 1, l10n)),
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
          category: columns.elementAtOrNull(12) == 'category'
              ? Value(normalizeCategory(row.elementAtOrNull(12)?.toString()))
              : const Value.absent(),
        );
      });

      await db.gymSets.deleteAll();
      await db.gymSets.insertAll(gymSets);
      talker.info('Imported ${gymSets.length} graph entries');

      final weightSet = await getBodyWeight();
      if (weightSet != null) {
        (db.gymSets.update()..where((tbl) => tbl.bodyWeight.equals(0))).write(
          GymSetsCompanion(bodyWeight: Value(weightSet.weight)),
        );
      }

      if (!ctx.mounted) return;
      Navigator.pop(ctx);

      toast(l10n.graphDataImported);
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace, 'Failed to import graph data');
      if (!ctx.mounted) return;

      toast(
        l10n.failedToImportGraphs(_localizedImportError(e, l10n)),
        duration: Duration(seconds: 10),
      );
    }
  }

  DateTime _parseDate(dynamic value, int rowNumber, AppLocalizations l10n) {
    try {
      return parseDate(value.toString());
    } on FormatException {
      throw _ImportValidationException(
        l10n.invalidCsvValue(l10n.createdDate, rowNumber, value.toString()),
      );
    }
  }

  Value<double> _parseDouble(
    dynamic value,
    String fieldName,
    int rowNumber,
    AppLocalizations l10n,
  ) {
    if (value is num) return Value(value.toDouble());
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed == null) {
        throw _ImportValidationException(
          l10n.invalidCsvValue(fieldName, rowNumber, value.toString()),
        );
      }
      return Value(parsed);
    }
    throw _ImportValidationException(
      l10n.invalidCsvDataType(
        fieldName,
        rowNumber,
        value.runtimeType.toString(),
      ),
    );
  }

  Future<void> importPlans(BuildContext context) async {
    final l10n = ctx.l10n;
    Navigator.pop(context);

    try {
      FilePickerResult? result = await FilePicker.pickFiles();
      if (result == null) return;

      String csvContent;
      final fileBytes = await result.files.single.readAsBytes();
      if (kIsWeb) {
        csvContent = String.fromCharCodes(fileBytes);
      } else {
        try {
          csvContent = utf8.decode(fileBytes, allowMalformed: false);
        } catch (e) {
          csvContent = latin1.decode(fileBytes);
        }
      }

      final csvList = CsvDecoder().convert(csvContent);

      if (csvList.isEmpty) throw _ImportValidationException(l10n.csvFileEmpty);
      if (csvList.length <= 1)
        throw _ImportValidationException(l10n.csvNeedsDataRow);

      final plansToInsert = <PlansCompanion>[];
      final planExercisesToInsert = <PlanExercisesCompanion>[];
      final hasCategories = csvList.first.elementAtOrNull(5) == 'categories';
      final knownCategories = await _knownCategoriesByExercise();

      for (final row in csvList.skip(1)) {
        final idStr = row[0].toString().trim();
        final id = int.tryParse(idStr);
        if (id == null) {
          throw _ImportValidationException(l10n.expectedIntegerPlanId(idStr));
        }
        plansToInsert.add(
          PlansCompanion.insert(
            id: Value(id),
            days: row[1].toString().trim(),
            title: Value(row[2].toString().trim()),
            sequence: Value(int.tryParse(row[3].toString().trim())),
          ),
        );

        final exerciseNames = row[4].toString().trim().split(';');
        final categories = hasCategories
            ? (row.elementAtOrNull(5)?.toString() ?? '').split(';')
            : const <String>[];
        for (final (index, exerciseName) in exerciseNames.indexed) {
          final name = exerciseName.trim();
          final known = knownCategories[name];
          final category = hasCategories
              ? normalizeCategory(categories.elementAtOrNull(index))
              : known?.length == 1
              ? known!.single
              : null;
          planExercisesToInsert.add(
            PlanExercisesCompanion.insert(
              planId: id,
              exercise: name,
              category: Value(category),
              enabled: true,
              timers: const Value(true),
            ),
          );
        }
      }

      await db.plans.deleteAll();
      await db.planExercises.deleteAll();
      await db.plans.insertAll(plansToInsert);
      await db.planExercises.insertAll(planExercisesToInsert);
      talker.info(
        'Imported ${plansToInsert.length} plans and ${planExercisesToInsert.length} exercises',
      );

      if (!ctx.mounted) return;
      Navigator.pop(ctx);

      toast(l10n.plansImported);
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace, 'Failed to import plan data');
      if (!ctx.mounted) return;
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;

      final title = Uri.encodeComponent(
        'Import failed: ${e.toString().split('\n').first}',
      );
      final body = Uri.encodeComponent('''
# Describe the bug
Failed to import plans.

# Error
```
${e.toString()}
```

# Stack trace
```
${stackTrace.toString()}
```

# App version
$version

# Steps to reproduce
1. Go to import plans
2. Select file
3. See error
''');

      final url =
          'https://github.com/brandonp2412/Flexify/issues/new?title=$title&body=$body';

      toast(
        l10n.failedToImportPlans(_localizedImportError(e, l10n)),
        duration: Duration(seconds: 10),
        action: SnackBarAction(
          label: l10n.actionReport,
          onPressed: () async {
            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      );
    }
  }

  /// Maps each exercise name to the categories it is logged under, so plans
  /// exported before categories existed can still find their exercise.
  Future<Map<String, Set<String?>>> _knownCategoriesByExercise() async {
    final rows = await (db.gymSets.selectOnly(
      distinct: true,
    )..addColumns([db.gymSets.name, db.gymSets.category])).get();
    final known = <String, Set<String?>>{};
    for (final row in rows) {
      known
          .putIfAbsent(row.read(db.gymSets.name)!, () => {})
          .add(row.read(db.gymSets.category));
    }
    return known;
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
