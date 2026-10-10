import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/settings/backup_archive.dart';
import 'package:flexify/storage/app_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'drift/db/generated/schema_v64.dart' as v64;
import 'drift/db/generated/schema_v66.dart' as v66;
import 'mock_tests.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late Directory root;
  late Directory documents;
  late Directory support;
  late File legacyFile;
  late File image;
  late PathProviderPlatform originalProvider;
  final openDatabases = <GeneratedDatabase>[];

  setUp(() async {
    root = await Directory.systemTemp.createTemp('flexify-storage-lifecycle-');
    documents = await Directory(p.join(root.path, 'documents')).create();
    support = Directory(p.join(root.path, 'support'));
    legacyFile = File(p.join(documents.path, backupDatabaseName));
    image = File(p.join(documents.path, 'progress.jpg'));
    await image.writeAsBytes([1, 2, 3, 4]);
    originalProvider = PathProviderPlatform.instance;
    PathProviderPlatform.instance = _StoragePathProvider(
      documents.path,
      supportPath: support.path,
      temporaryPath: root.path,
    );
  });

  tearDown(() async {
    for (final database in openDatabases.reversed) {
      await database.close();
    }
    openDatabases.clear();
    PathProviderPlatform.instance = originalProvider;
    await root.delete(recursive: true);
  });

  AppDatabase openPersistent() {
    final database = AppDatabase.persistent();
    openDatabases.add(database);
    return database;
  }

  Future<GeneratedDatabase> seedLegacy({
    int version = 66,
    bool wal = false,
  }) async {
    final executor = NativeDatabase(legacyFile);
    final database = version == 64
        ? v64.DatabaseAtV64(executor)
        : v66.DatabaseAtV66(executor);
    openDatabases.add(database);
    if (wal) {
      await database.customStatement('PRAGMA journal_mode = WAL');
      await database.customStatement('PRAGMA wal_autocheckpoint = 0');
    }
    await database.customStatement('PRAGMA foreign_keys = ON');
    await database.customStatement(
      "INSERT INTO categories (id, name) VALUES (1, 'Storage category')",
    );
    await database.customStatement(
      "INSERT INTO plans (id, days, title) VALUES (1, 'Monday', 'Storage plan')",
    );
    await database.customStatement(
      'INSERT INTO exercises '
      '(id, name, kind, display_unit, category_id, image, notes) '
      "VALUES (1, 'Storage bench', 'strength', 'kg', 1, ?, 'Exercise notes')",
      [image.path],
    );
    await database.customStatement(
      'INSERT INTO exercises (id, name, kind, display_unit, category_id) '
      "VALUES (2, 'Storage run', 'cardio', 'km', 1)",
    );
    await database.customStatement(
      'INSERT INTO workouts (id, plan_id, started_at, ended_at) '
      'VALUES (1, 1, 1768478400, 1768482000)',
    );
    await database.customStatement(
      'INSERT INTO exercise_sets '
      '(exercise_id, workout_id, timestamp, reps, load_kg, notes) '
      "VALUES (1, 1, 1768478500, 7, 51, 'Strength set notes')",
    );
    await database.customStatement(
      'INSERT INTO exercise_sets '
      '(exercise_id, workout_id, timestamp, reps, load_kg, duration_ms, distance_metres, '
      'incline, body_weight_kg, notes) '
      "VALUES (2, 1, 1768478600, 0, 0, 90000, 2300, 4, 78.25, 'Cardio set notes')",
    );
    await database.customStatement(
      'INSERT INTO body_weights (timestamp, weight_kg, photo) '
      'VALUES (1768478400, 78.25, ?)',
      [image.path],
    );
    await database.customStatement(
      'INSERT INTO settings '
      '(alarm_sound, cardio_unit, curve_lines, explained_permissions, '
      'group_history, long_date_format, max_sets, plan_trailing, rest_timers, '
      'short_date_format, show_units, strength_unit, system_colors, theme_mode, '
      'timer_duration, vibrate) '
      "VALUES ('', 'km', 0, 1, 0, 'dd/MM/yyyy', 3, 'PlanTrailing.reorder', 0, "
      "'dd/MM', 1, 'kg', 0, 'ThemeMode.dark', 90000, 0)",
    );
    await database.customStatement(
      "UPDATE settings SET locale_override = 'en', show_notes = 1, "
      'show_images = 1, show_body_weight = 1',
    );
    await database.customStatement(
      'INSERT INTO plan_exercises (enabled, exercise_id, plan_id, sequence) '
      'VALUES (1, 1, 1, 0), (1, 2, 1, 1)',
    );
    return database;
  }

  Future<Map<String, List<Map<String, Object?>>>> snapshot(
    GeneratedDatabase database,
  ) async {
    final tables = await database
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' "
          "AND name NOT LIKE 'sqlite_%' ORDER BY name",
        )
        .get();
    return {
      for (final table in tables)
        table.read<String>('name'): [
          for (final row
              in await database
                  .customSelect(
                    'SELECT * FROM "${table.read<String>('name')}" ORDER BY rowid',
                  )
                  .get())
            row.data,
        ],
    };
  }

  Future<void> expectHealthy(AppDatabase database) async {
    expect(
      (await database.customSelect('PRAGMA integrity_check').getSingle())
          .data
          .values
          .single,
      'ok',
    );
    expect(
      await database.customSelect('PRAGMA foreign_key_check').get(),
      isEmpty,
    );
    expect(
      (await database.customSelect('PRAGMA foreign_keys').getSingle())
          .data
          .values
          .single,
      1,
    );
    expect(
      (await database.customSelect('PRAGMA user_version').getSingle())
          .data
          .values
          .single,
      database.schemaVersion,
    );
  }

  test('migration waits for a lock held by another process', () async {
    final legacy = await seedLegacy();
    await legacy.close();
    await support.create();
    final script = File(p.join(root.path, 'hold_lock.dart'));
    await script.writeAsString('''
import 'dart:io';
Future<void> main(List<String> args) async {
  final lock = await File(args.single).open(mode: FileMode.append);
  await lock.lock(FileLock.blockingExclusive);
  stdout.writeln('locked');
  await stdin.first;
  await lock.close();
}
''');
    final process = await Process.start('dart', [
      script.path,
      p.join(support.path, '.flexify-storage.lock'),
    ]);
    addTearDown(() async {
      process.kill();
      await process.exitCode;
    });
    expect(
      await process.stdout.transform(utf8.decoder).first,
      contains('locked'),
    );
    var finished = false;
    final migration = getDatabaseFile().then((file) {
      finished = true;
      return file;
    });
    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(finished, isFalse);
    expect(
      await File(p.join(support.path, backupDatabaseName)).exists(),
      isFalse,
    );
    process.stdin.writeln('release');
    await process.stdin.flush();
    expect(await process.exitCode, 0);
    expect(await (await migration).exists(), isTrue);
    await expectHealthy(openPersistent());
  });

  test(
    'fresh persistent databases survive close and reopen in support',
    () async {
      final database = openPersistent();
      await database.settings.select().getSingle();
      await database.bodyWeights.insertOne(
        BodyWeightsCompanion.insert(timestamp: testNow, weightKg: 79.5),
      );
      final expected = await snapshot(database);
      await database.close();

      final reopened = openPersistent();
      expect(await snapshot(reopened), expected);
      await expectHealthy(reopened);
      expect(await legacyFile.exists(), isFalse);
      expect((await getDatabaseFile()).parent.path, support.path);
    },
  );

  test(
    'v66 migration preserves every row and relationship across reopen',
    () async {
      final legacy = await seedLegacy();
      final expected = await snapshot(legacy);
      await legacy.close();

      final database = openPersistent();
      expect(await snapshot(database), expected);
      await expectHealthy(database);
      expect(await image.readAsBytes(), [1, 2, 3, 4]);
      await database.close();

      final reopened = openPersistent();
      expect(await snapshot(reopened), expected);
      await expectHealthy(reopened);
      final source = sqlite.sqlite3.open(
        legacyFile.path,
        mode: sqlite.OpenMode.readOnly,
      );
      try {
        expect(source.userVersion, 66);
      } finally {
        source.close();
      }
    },
  );

  test(
    'v64 storage migration also performs the intervening schema upgrades',
    () async {
      final legacy = await seedLegacy(version: 64);
      final expected = await snapshot(legacy);
      await legacy.close();

      final database = openPersistent();
      final actual = await snapshot(database);
      for (final table in expected.keys.where((name) => name != 'settings')) {
        expect(actual[table], expected[table], reason: table);
      }
      final settings = await database.settings.select().getSingle();
      expect(settings.localeOverride, 'en');
      expect(settings.showImages, isTrue);
      await expectHealthy(database);
    },
  );

  test(
    'migration snapshots a live legacy WAL database without losing records',
    () async {
      final legacy = await seedLegacy(wal: true);
      final expected = await snapshot(legacy);
      expect(await File('${legacyFile.path}-wal').length(), greaterThan(0));

      final database = openPersistent();
      expect(await snapshot(database), expected);
      await expectHealthy(database);
      expect(await snapshot(legacy), expected);
    },
  );

  test(
    'post-migration edits persist without changing the retained legacy copy',
    () async {
      final legacy = await seedLegacy();
      await legacy.close();
      final legacyBytes = await legacyFile.readAsBytes();
      final database = openPersistent();
      await database.customStatement(
        "UPDATE exercise_sets SET load_kg = 61, notes = 'Updated' "
        'WHERE exercise_id = 1',
      );
      await database.bodyWeights.insertOne(
        BodyWeightsCompanion.insert(timestamp: testNow, weightKg: 80),
      );
      final expected = await snapshot(database);
      await database.close();

      final reopened = openPersistent();
      expect(await snapshot(reopened), expected);
      expect(await legacyFile.readAsBytes(), legacyBytes);
      await expectHealthy(reopened);
    },
  );

  test(
    'backup round-trip restores data and images into support storage',
    () async {
      final legacy = await seedLegacy();
      await legacy.close();
      final database = openPersistent();
      await database.settings.select().getSingle();
      final file = await getDatabaseFile();
      final export = await Directory(p.join(root.path, 'export')).create();
      final archive = await createBackupArchive(
        databasePath: file.path,
        workingDirectory: export,
      );
      await database.close();
      await file.delete();
      await image.delete();

      final work = await Directory(p.join(root.path, 'import')).create();
      final candidate = await extractBackupArchive(
        archiveFile: archive,
        workingDirectory: work,
        storageDirectory: support,
      );
      final validator = AppDatabase.forPath(candidate.path);
      openDatabases.add(validator);
      await expectHealthy(validator);
      await validator.close();
      await candidate.copy(file.path);

      final restored = openPersistent();
      expect(await restored.exerciseSets.select().get(), hasLength(2));
      expect(await restored.workouts.select().get(), hasLength(1));
      expect(await restored.planExercises.select().get(), hasLength(2));
      final photo = (await restored.bodyWeights.select().getSingle()).photo!;
      expect(p.dirname(photo), support.path);
      expect(await File(photo).readAsBytes(), [1, 2, 3, 4]);
      final exercise =
          await (restored.exercises.select()
                ..where((row) => row.name.equals('Storage bench')))
              .getSingle();
      expect(exercise.image, photo);
      expect(exercise.notes, 'Exercise notes');
      await expectHealthy(restored);
    },
  );

  test(
    'deletion followed by a persistent reopen cannot resurrect legacy data',
    () async {
      final legacy = await seedLegacy();
      await legacy.close();
      final database = openPersistent();
      expect(await database.exerciseSets.select().get(), hasLength(2));
      final file = await getDatabaseFile();
      await database.close();
      await file.delete();

      final fresh = openPersistent();
      expect(await fresh.exerciseSets.select().get(), isEmpty);
      expect(await fresh.bodyWeights.select().get(), isEmpty);
      expect(await fresh.plans.select().get(), isNotEmpty);
      expect(await legacyFile.exists(), isTrue);
      await expectHealthy(fresh);
    },
  );

  test(
    'a corrupt legacy file fails startup without creating an empty database',
    () async {
      await legacyFile.writeAsString('not a SQLite database');
      final database = openPersistent();
      await expectLater(
        database.settings.select().get(),
        throwsA(isA<sqlite.SqliteException>()),
      );
      openDatabases.remove(database);
      await expectLater(
        database.close(),
        throwsA(isA<sqlite.SqliteException>()),
      );
      expect(await legacyFile.readAsString(), 'not a SQLite database');
      expect(
        await File(p.join(support.path, backupDatabaseName)).exists(),
        isFalse,
      );
    },
  );
}

final testNow = DateTime(2026, 1, 15, 12);

class _StoragePathProvider extends FakePathProviderPlatform {
  _StoragePathProvider(
    super.documentsPath, {
    required super.supportPath,
    required this.temporaryPath,
  });

  final String temporaryPath;

  @override
  Future<String?> getTemporaryPath() async => temporaryPath;
}
