import 'dart:io';

import 'package:flexify/settings/backup_archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

void main() {
  test(
    'backup archive preserves redesigned relationships and image assets',
    () async {
      final root = await Directory.systemTemp.createTemp(
        'flexify-redesign-backup-',
      );
      addTearDown(() => root.delete(recursive: true));

      final documents = Directory(p.join(root.path, 'documents'))..createSync();
      final export = Directory(p.join(root.path, 'export'))..createSync();
      final imported = Directory(p.join(root.path, 'import'))..createSync();
      final databasePath = p.join(root.path, backupDatabaseName);

      final exerciseImage = File(p.join(root.path, 'exercise.jpg'))
        ..writeAsBytesSync([1, 2, 3]);
      final bodyPhoto = File(p.join(root.path, 'body.jpg'))
        ..writeAsBytesSync([4, 5, 6]);
      final setImage = File(p.join(root.path, 'set.jpg'))
        ..writeAsBytesSync([7, 8, 9]);

      final database = sqlite3.open(databasePath);
      database.execute(
        'CREATE TABLE exercises (id INTEGER PRIMARY KEY, image TEXT)',
      );
      database.execute('CREATE TABLE workouts (id INTEGER PRIMARY KEY)');
      database.execute(
        'CREATE TABLE exercise_sets ('
        'id INTEGER PRIMARY KEY, exercise_id INTEGER, workout_id INTEGER, image TEXT)',
      );
      database.execute(
        'CREATE TABLE body_weights (id INTEGER PRIMARY KEY, photo TEXT)',
      );
      database.execute('INSERT INTO exercises (id, image) VALUES (11, ?)', [
        exerciseImage.path,
      ]);
      database.execute('INSERT INTO workouts (id) VALUES (22)');
      database.execute(
        'INSERT INTO exercise_sets (id, exercise_id, workout_id, image) '
        'VALUES (33, 11, 22, ?)',
        [setImage.path],
      );
      database.execute('INSERT INTO body_weights (id, photo) VALUES (44, ?)', [
        bodyPhoto.path,
      ]);
      database.close();

      final archive = await createBackupArchive(
        databasePath: databasePath,
        workingDirectory: export,
      );

      exerciseImage.deleteSync();
      bodyPhoto.deleteSync();
      setImage.deleteSync();

      final restoredFile = await extractBackupArchive(
        archiveFile: archive,
        workingDirectory: imported,
        storageDirectory: documents,
      );

      final restored = sqlite3.open(restoredFile.path);
      final exercise = restored.select('SELECT * FROM exercises').single;
      final set = restored.select('SELECT * FROM exercise_sets').single;
      final weight = restored.select('SELECT * FROM body_weights').single;
      restored.close();

      expect(set['exercise_id'], 11);
      expect(set['workout_id'], 22);

      final restoredExerciseImage = File(exercise['image'] as String);
      final restoredSetImage = File(set['image'] as String);
      final restoredBodyPhoto = File(weight['photo'] as String);
      expect(restoredExerciseImage.readAsBytesSync(), [1, 2, 3]);
      expect(restoredSetImage.readAsBytesSync(), [7, 8, 9]);
      expect(restoredBodyPhoto.readAsBytesSync(), [4, 5, 6]);
      expect(p.dirname(restoredExerciseImage.path), documents.path);
      expect(p.dirname(restoredSetImage.path), documents.path);
      expect(p.dirname(restoredBodyPhoto.path), documents.path);
    },
  );
}
