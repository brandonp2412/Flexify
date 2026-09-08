import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;

import 'backup_database.dart';

const backupDatabaseName = 'flexify.sqlite';

const _imageColumns = <(String, String)>[('gym_sets', 'image')];

Future<File> createBackupArchive({
  required String databasePath,
  required Directory workingDirectory,
}) async {
  final databaseCopy = File(p.join(workingDirectory.path, backupDatabaseName));
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
  await encoder.addFile(databaseCopy, backupDatabaseName);
  for (final entry in existingImages.entries) {
    await encoder.addFile(File(entry.key), entry.value);
  }
  await encoder.close();
  return archiveFile;
}

Future<File> extractBackupArchive({
  required File archiveFile,
  required Directory workingDirectory,
  required Directory documentsDirectory,
}) async {
  final input = InputFileStream(archiveFile.path);
  final archive = ZipDecoder().decodeStream(input);
  try {
    for (final entry in archive) {
      if (!entry.isFile) continue;
      final name = p.posix.normalize(entry.name);
      final isDatabase = name == backupDatabaseName;
      final isImage = p.posix.dirname(name) == 'images';
      if (!isDatabase && !isImage) continue;

      final outputPath = isDatabase
          ? p.join(workingDirectory.path, backupDatabaseName)
          : p.join(documentsDirectory.path, p.posix.basename(name));
      final output = OutputFileStream(outputPath);
      output.writeStream(entry.getContent()!);
      await output.close();
      await entry.close();
    }
  } finally {
    await input.close();
  }

  final databaseFile = File(p.join(workingDirectory.path, backupDatabaseName));
  if (!databaseFile.existsSync()) {
    throw const FormatException('Backup does not contain flexify.sqlite');
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
          documentsDirectory.path,
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
