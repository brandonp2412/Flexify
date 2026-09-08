import 'dart:io';

import 'package:flexify/settings/backup_archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('backup archive restores database and referenced images', () async {
    final root = await Directory.systemTemp.createTemp('flexify-backup-test-');
    addTearDown(() => root.delete(recursive: true));

    final documentsDirectory = Directory(p.join(root.path, 'documents'))
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
      documentsDirectory: documentsDirectory,
    );

    final restored = sqlite3.open(restoredDatabase.path);
    final restoredImagePath =
        restored.select('SELECT image FROM gym_sets').single['image'] as String;
    restored.close();

    expect(
      restoredImagePath,
      p.join(documentsDirectory.path, '0_progress.jpg'),
    );
    expect(File(restoredImagePath).readAsBytesSync(), [1, 2, 3, 4]);
  });
}
