import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;

import 'backup_database.dart';

const backupDbName = 'flexify.sqlite';

const _imageColumns = <(String, String)>[
  ('exercises', 'image'),
  ('body_weights', 'photo'),
  // Kept for old backups and any pre-release databases that stored an
  // image directly against a exercise set.
  ('exercise_sets', 'image'),
  ('gym_sets', 'image'),
];

/// Signals that an imported backup archive is missing the Flexify database.
final class MissingBackupDatabaseException implements Exception {
  const MissingBackupDatabaseException();
}

void validateBackupDatabaseFile(File file) {
  if (!file.existsSync()) {
    throw const FormatException('Backup database file does not exist');
  }

  BackupDatabase? database;
  try {
    database = openBackupDatabase(file.path);
    final tables = database
        .select(
          "SELECT name FROM sqlite_master WHERE type = 'table' "
          "AND name IN ('plans', 'gym_sets', 'exercises')",
        )
        .map((row) => row['name'])
        .toSet();
    if (!tables.contains('plans') ||
        (!tables.contains('gym_sets') && !tables.contains('exercises')) ||
        database.select('PRAGMA quick_check').single['quick_check'] != 'ok') {
      throw const FormatException(
        'Selected file is not a Flexify database backup',
      );
    }
  } on FormatException {
    rethrow;
  } catch (_) {
    throw const FormatException(
      'Selected file is not a Flexify database backup',
    );
  } finally {
    database?.close();
  }
}

Future<File> prepareBackupDatabase({
  required File selectedFile,
  required Directory workingDirectory,
  required Directory storageDirectory,
}) async {
  if (p.extension(selectedFile.path).toLowerCase() == '.zip') {
    return extractBackupArchive(
      archiveFile: selectedFile,
      workingDirectory: workingDirectory,
      storageDirectory: storageDirectory,
    );
  }

  validateBackupDatabaseFile(selectedFile);
  final snapshot = File(
    p.join(workingDirectory.path, 'imported-$backupDbName'),
  );
  final escapedPath = snapshot.path.replaceAll("'", "''");
  final source = openBackupDatabase(selectedFile.path);
  try {
    source.execute("VACUUM INTO '$escapedPath'");
  } finally {
    source.close();
  }
  return snapshot;
}

Future<File> createBackupArchive({
  required String databasePath,
  required Directory workingDirectory,
}) async {
  final databaseCopy = File(p.join(workingDirectory.path, backupDbName));
  final escapedPath = databaseCopy.path.replaceAll("'", "''");
  final source = openBackupDatabase(databasePath);
  try {
    source.execute("VACUUM INTO '$escapedPath'");
  } finally {
    source.close();
  }

  final imagePaths = <String, String>{};
  final existingImages = <String, String>{};
  final backup = openBackupDatabase(databaseCopy.path);
  try {
    for (final (table, column) in _imageColumns) {
      if (!_hasColumn(backup, table, column)) continue;
      final rows = backup.select(
        'SELECT DISTINCT "$column" AS path FROM "$table" '
        "WHERE \"$column\" IS NOT NULL AND \"$column\" != ''",
      );
      for (final row in rows) {
        final originalPath = row['path'] as String;
        final archivePath = imagePaths.putIfAbsent(
          originalPath,
          () => p.posix.join(
            'images',
            '${imagePaths.length}_${p.basename(originalPath)}',
          ),
        );
        if (File(originalPath).existsSync()) {
          existingImages[originalPath] = archivePath;
        }
        backup.execute(
          'UPDATE "$table" SET "$column" = ? WHERE "$column" = ?',
          [archivePath, originalPath],
        );
      }
    }
  } finally {
    backup.close();
  }

  final archiveFile = File(p.join(workingDirectory.path, 'flexify-backup.zip'));
  final encoder = ZipFileEncoder()..create(archiveFile.path);
  await encoder.addFile(databaseCopy, backupDbName);
  for (final entry in existingImages.entries) {
    await encoder.addFile(File(entry.key), entry.value);
  }
  await encoder.close();
  return archiveFile;
}

Future<File> extractBackupArchive({
  required File archiveFile,
  required Directory workingDirectory,
  required Directory storageDirectory,
}) async {
  final input = InputFileStream(archiveFile.path);
  final archive = ZipDecoder().decodeStream(input);
  try {
    for (final entry in archive) {
      if (!entry.isFile) continue;
      final name = p.posix.normalize(entry.name);
      final isDatabase = name == backupDbName;
      final isImage = p.posix.dirname(name) == 'images';
      if (!isDatabase && !isImage) continue;

      final outputPath = isDatabase
          ? p.join(workingDirectory.path, backupDbName)
          : p.join(storageDirectory.path, p.posix.basename(name));
      final output = OutputFileStream(outputPath);
      output.writeStream(entry.getContent()!);
      await output.close();
      await entry.close();
    }
  } finally {
    await input.close();
  }

  final databaseFile = File(p.join(workingDirectory.path, backupDbName));
  if (!databaseFile.existsSync()) {
    throw const MissingBackupDatabaseException();
  }

  final imported = openBackupDatabase(databaseFile.path);
  try {
    for (final (table, column) in _imageColumns) {
      if (!_hasColumn(imported, table, column)) continue;
      final rows = imported.select(
        'SELECT DISTINCT "$column" AS path FROM "$table" '
        "WHERE \"$column\" LIKE 'images/%'",
      );
      for (final row in rows) {
        final relativePath = row['path'] as String;
        final absolutePath = p.join(
          storageDirectory.path,
          p.posix.basename(relativePath),
        );
        imported.execute(
          'UPDATE "$table" SET "$column" = ? WHERE "$column" = ?',
          [absolutePath, relativePath],
        );
      }
    }
  } finally {
    imported.close();
  }
  return databaseFile;
}

bool _hasColumn(BackupDatabase database, String table, String column) {
  final tableExists = database.select(
    "SELECT 1 FROM sqlite_master WHERE type = 'table' AND name = ?",
    [table],
  );
  if (tableExists.isEmpty) return false;
  return database
      .select('PRAGMA table_info("$table")')
      .any((row) => row['name'] == column);
}
