import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flexify/app_permissions_dialog.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/data_portability/graph_csv.dart';
import 'package:flexify/l10n/generated/app_localizations.dart';
import 'package:flexify/l10n/l10n.dart';
import 'package:flexify/main.dart';
import 'package:flexify/logging.dart';
import 'package:flexify/settings/backup_archive.dart';
import 'package:flexify/utils.dart';
import 'package:flexify/storage/app_storage.dart';
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
  if (error is GraphCsvImportException) return error.message;
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

    final liveDatabase = await getDatabaseFile();
    final storageDirectory = liveDatabase.parent;
    final tempDirectory = await getTemporaryDirectory();
    final workingDirectory = await tempDirectory.createTemp('flexify-import-');
    try {
      final sourceFile = p.extension(selectedFile.path).toLowerCase() == '.zip'
          ? await extractBackupArchive(
              archiveFile: selectedFile,
              workingDirectory: workingDirectory,
              storageDirectory: storageDirectory,
            )
          : selectedFile;

      final candidateDatabase = File(
        p.join(workingDirectory.path, 'candidate-$backupDatabaseName'),
      );
      await sourceFile.copy(candidateDatabase.path);

      final candidateDb = AppDatabase.forPath(candidateDatabase.path);
      try {
        // Opening the candidate performs every required migration and the
        // migration strategy's foreign-key validation before the live
        // database is touched.
        await candidateDb.customSelect('SELECT 1').get();
        final foreignKeyViolations = await candidateDb
            .customSelect('PRAGMA foreign_key_check')
            .get();
        if (foreignKeyViolations.isNotEmpty) {
          throw StateError('Foreign key violations in imported database');
        }
      } finally {
        await candidateDb.close();
      }

      final rollbackDatabase = File(
        p.join(workingDirectory.path, 'rollback-$backupDatabaseName'),
      );

      await db.close();
      if (await liveDatabase.exists()) {
        await liveDatabase.copy(rollbackDatabase.path);
      }

      try {
        await candidateDatabase.copy(liveDatabase.path);
        db = AppDatabase.persistent();
        await db.customSelect('SELECT 1').get();
      } catch (_) {
        try {
          await db.close();
        } catch (_) {}
        if (await rollbackDatabase.exists()) {
          await rollbackDatabase.copy(liveDatabase.path);
        } else if (await liveDatabase.exists()) {
          await liveDatabase.delete();
        }
        db = AppDatabase.persistent();
        await db.customSelect('SELECT 1').get();
        rethrow;
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
      final result = await FilePicker.pickFiles();
      if (result == null) return;

      final fileBytes = await result.files.single.readAsBytes();
      String csvContent;
      if (kIsWeb) {
        csvContent = String.fromCharCodes(fileBytes);
      } else {
        try {
          csvContent = utf8.decode(fileBytes, allowMalformed: false);
        } catch (_) {
          csvContent = latin1.decode(fileBytes);
        }
      }

      final imported = await importGraphCsv(db, csvContent);
      final exercises = imported.exercises;
      final workouts = imported.workouts;
      final sets = imported.exerciseSets;
      final bodyWeights = imported.bodyWeights;
      talker.info(
        'Imported graph/history CSV: exercises=$exercises, '
        'workouts=$workouts, sets=$sets, bodyWeights=$bodyWeights',
      );

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
        for (final rawExerciseName in exerciseNames) {
          final exerciseName = rawExerciseName.trim();
          if (exerciseName.isEmpty) continue;
          var exercise = await getExerciseByName(exerciseName);
          exercise ??= await createExerciseDefinition(
            name: exerciseName,
            cardio: false,
            displayUnit: 'kg',
          );
          planExercisesToInsert.add(
            PlanExercisesCompanion.insert(
              planId: id,
              exerciseId: exercise.id,
              enabled: true,
              timers: const Value(true),
            ),
          );
        }
      }

      await db.planExercises.deleteAll();
      await db.plans.deleteAll();
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
