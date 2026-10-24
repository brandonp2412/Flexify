import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flex/app_permissions_dialog.dart';
import 'package:flex/database/database.dart';
import 'package:flex/database/exercise_catalog.dart';
import 'package:flex/data_portability/graph_csv.dart';
import 'package:flex/data_portability/import_issue.dart';
import 'package:flex/l10n/generated/app_localizations.dart';
import 'package:flex/l10n/l10n.dart';
import 'package:flex/main.dart';
import 'package:flex/logging.dart';
import 'package:flex/settings/backup_archive.dart';
import 'package:flex/storage/app_storage.dart';
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
    return ListTile(
      onTap: () {
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
      leading: const Icon(Icons.upload_outlined),
      title: Text(context.l10n.importData),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }

  Future<void> importDatabase(BuildContext context) async {
    final l10n = ctx.l10n;
    Navigator.pop(context);
    talker.info('Starting Flex database import');

    try {
      if (kIsWeb) {
        await _importDatabaseWeb(l10n);
      } else {
        await _importDatabaseNative(l10n);
      }
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace, 'Failed to import Flex database');
      if (!ctx.mounted) return;
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;

      final url = buildImportIssueUrl(
        kind: 'database',
        error: e,
        stackTrace: stackTrace,
        version: version,
      );

      final displayError = _localizedImportError(e, l10n);
      messengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(l10n.failedToImportDatabase(displayError)),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          action: SnackBarAction(
            label: l10n.actionReport,
            onPressed: () async {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            },
          ),
          duration: Duration(seconds: 10),
          persist: false,
        ),
      );
    }
  }

  Future<void> _importDatabaseNative(AppLocalizations l10n) async {
    final result = await FilePicker.pickFiles();
    if (result.isEmpty) return;

    final selectedFile = File(result.single.path!);
    if (!await selectedFile.exists()) {
      throw _ImportValidationException(l10n.selectedFileDoesNotExist);
    }

    final liveDatabase = await getDatabaseFile();
    final storageDir = liveDatabase.parent;
    final tempDirectory = await getTemporaryDirectory();
    final workDir = await tempDirectory.createTemp('flex-import-');
    try {
      final sourceFile = await prepareBackupDatabase(
        selectedFile: selectedFile,
        workingDirectory: workDir,
        storageDirectory: storageDir,
      );
      validateBackupDatabaseFile(sourceFile);

      final candidateFile = File(
        p.join(workDir.path, 'candidate-$backupDbName'),
      );
      await sourceFile.copy(candidateFile.path);

      final candidateDb = AppDatabase.forPath(candidateFile.path);
      try {
        // Opening the candidate performs every required migration and the
        // migration strategy's foreign-key validation before the live
        // database is touched.
        await candidateDb.customSelect('SELECT 1').get();
        final violations = await candidateDb
            .customSelect('PRAGMA foreign_key_check')
            .get();
        if (violations.isNotEmpty) {
          throw StateError('Foreign key violations in imported database');
        }
      } finally {
        await candidateDb.close();
      }

      final rollbackFile = File(p.join(workDir.path, 'rollback-$backupDbName'));

      await db.close();
      if (await liveDatabase.exists()) {
        await liveDatabase.copy(rollbackFile.path);
      }

      try {
        await candidateFile.copy(liveDatabase.path);
        db = AppDatabase.persistent();
        await db.customSelect('SELECT 1').get();
      } catch (_) {
        try {
          await db.close();
        } catch (_) {}
        if (await rollbackFile.exists()) {
          await rollbackFile.copy(liveDatabase.path);
        } else if (await liveDatabase.exists()) {
          await liveDatabase.delete();
        }
        db = AppDatabase.persistent();
        await db.customSelect('SELECT 1').get();
        rethrow;
      }

      dbVersion.value++;
      talker.info('Imported Flex data and image backup');
    } finally {
      await workDir.delete(recursive: true);
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

    final settings = await (db.settings.select()..limit(1)).getSingle();

    if (!ctx.mounted) return;
    await showAppPermissionsDialog(ctx, required: true, settings: settings);

    if (!ctx.mounted) return;
    Navigator.of(
      ctx,
      rootNavigator: true,
    ).pushNamedAndRemoveUntil('/', (_) => false);
  }

  Future<void> _importDatabaseWeb(AppLocalizations l10n) async {
    final result = await FilePicker.pickFiles();
    if (result.isEmpty) return;

    try {
      await result.single.readAsBytes();
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
      if (result.isEmpty) return;

      final fileBytes = await result.single.readAsBytes();
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
      messengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(l10n.graphDataImported),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          duration: const Duration(seconds: 4),
          persist: false,
        ),
      );
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace, 'Failed to import graph data');
      if (!ctx.mounted) return;

      messengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(
            l10n.failedToImportGraphs(_localizedImportError(e, l10n)),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          duration: Duration(seconds: 10),
          persist: false,
        ),
      );
    }
  }

  Future<void> importPlans(BuildContext context) async {
    final l10n = ctx.l10n;
    Navigator.pop(context);

    try {
      final result = await FilePicker.pickFiles();
      if (result.isEmpty) return;

      String csvContent;
      final fileBytes = await result.single.readAsBytes();
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
      final links = <PlanExercisesCompanion>[];

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
          links.add(
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
      await db.planExercises.insertAll(links);
      talker.info(
        'Imported ${plansToInsert.length} plans and ${links.length} exercises',
      );

      if (!ctx.mounted) return;
      Navigator.pop(ctx);

      messengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(l10n.plansImported),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          duration: const Duration(seconds: 4),
          persist: false,
        ),
      );
    } catch (e, stackTrace) {
      talker.handle(e, stackTrace, 'Failed to import plan data');
      if (!ctx.mounted) return;
      final packageInfo = await PackageInfo.fromPlatform();
      final version = packageInfo.version;

      final url = buildImportIssueUrl(
        kind: 'plans',
        error: e,
        stackTrace: stackTrace,
        version: version,
      );

      messengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(
            l10n.failedToImportPlans(_localizedImportError(e, l10n)),
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          action: SnackBarAction(
            label: l10n.actionReport,
            onPressed: () async {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            },
          ),
          duration: Duration(seconds: 10),
          persist: false,
        ),
      );
    }
  }
}
