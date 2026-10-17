import 'dart:io';

import 'package:archive/archive_io.dart';

import 'package:flexify/settings/backup_archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('backup archive restores database and referenced images', () async {
    final root = await Directory.systemTemp.createTemp('flexify-backup-test-');
    addTearDown(() => root.delete(recursive: true));

    final storageDirectory = Directory(p.join(root.path, 'documents'))
      ..createSync();
    final exportDirectory = Directory(p.join(root.path, 'export'))
      ..createSync();
    final importDirectory = Directory(p.join(root.path, 'import'))
      ..createSync();
    final databasePath = p.join(root.path, backupDatabaseName);
    final image = File(p.join(root.path, 'progress.jpg'))
      ..writeAsBytesSync([1, 2, 3, 4]);

    final database = sqlite3.open(databasePath);
    database.execute(
      'CREATE TABLE gym_sets (id INTEGER PRIMARY KEY, image TEXT)',
    );
    database.execute('INSERT INTO gym_sets (image) VALUES (?)', [image.path]);
    database.close();

    final archive = await createBackupArchive(
      databasePath: databasePath,
      workingDirectory: exportDirectory,
    );
    expect(archive.existsSync(), isTrue);

    image.deleteSync();
    final restoredDatabase = await extractBackupArchive(
      archiveFile: archive,
      workingDirectory: importDirectory,
      storageDirectory: storageDirectory,
    );

    final restored = sqlite3.open(restoredDatabase.path);
    final restoredImagePath =
        restored.select('SELECT image FROM gym_sets').single['image'] as String;
    restored.close();

    expect(restoredImagePath, p.join(storageDirectory.path, '0_progress.jpg'));
    expect(File(restoredImagePath).readAsBytesSync(), [1, 2, 3, 4]);
  });
  test('backup includes committed records in a live WAL database', () async {
    final root = await Directory.systemTemp.createTemp('flexify-wal-backup-');
    addTearDown(() => root.delete(recursive: true));
    final databasePath = p.join(root.path, backupDatabaseName);
    final exportDirectory = await Directory(
      p.join(root.path, 'export'),
    ).create();
    final importDirectory = await Directory(
      p.join(root.path, 'import'),
    ).create();
    final storageDirectory = await Directory(
      p.join(root.path, 'storage'),
    ).create();

    final writer = sqlite3.open(databasePath);
    try {
      writer.execute(
        'CREATE TABLE workout (id INTEGER PRIMARY KEY, name TEXT)',
      );
      writer.execute("INSERT INTO workout (name) VALUES ('initial')");
      writer.execute('PRAGMA journal_mode = WAL');
      writer.execute('PRAGMA wal_autocheckpoint = 0');
      writer.execute("INSERT INTO workout (name) VALUES ('latest')");

      final archive = await createBackupArchive(
        databasePath: databasePath,
        workingDirectory: exportDirectory,
      );
      final restored = await extractBackupArchive(
        archiveFile: archive,
        workingDirectory: importDirectory,
        storageDirectory: storageDirectory,
      );
      final imported = sqlite3.open(restored.path);
      try {
        expect(
          imported
              .select('SELECT name FROM workout ORDER BY id')
              .map((row) => row['name'])
              .toList(),
          ['initial', 'latest'],
        );
      } finally {
        imported.close();
      }
    } finally {
      writer.close();
    }
  });

  test('missing database in backup uses typed validation error', () async {
    final root = await Directory.systemTemp.createTemp(
      'flexify-backup-invalid-',
    );
    addTearDown(() => root.delete(recursive: true));

    final storageDirectory = Directory(p.join(root.path, 'documents'))
      ..createSync();
    final importDirectory = Directory(p.join(root.path, 'import'))
      ..createSync();
    final unrelatedFile = File(p.join(root.path, 'readme.txt'))
      ..writeAsStringSync('not a database');
    final archiveFile = File(p.join(root.path, 'backup.zip'));
    final encoder = ZipFileEncoder()..create(archiveFile.path);
    await encoder.addFile(unrelatedFile, 'readme.txt');
    await encoder.close();

    expect(
      () => extractBackupArchive(
        archiveFile: archiveFile,
        workingDirectory: importDirectory,
        storageDirectory: storageDirectory,
      ),
      throwsA(isA<MissingBackupDatabaseException>()),
    );
  });
}
