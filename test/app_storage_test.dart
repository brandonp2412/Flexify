import 'dart:io';

import 'package:flexify/storage/app_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:sqlite3/sqlite3.dart';

import 'mock_tests.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory root;
  late Directory documents;
  late Directory support;
  late PathProviderPlatform originalProvider;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('flexify-storage-');
    documents = await Directory(p.join(root.path, 'documents')).create();
    support = Directory(p.join(root.path, 'data-home', 'flexify'));
    originalProvider = PathProviderPlatform.instance;
    PathProviderPlatform.instance = FakePathProviderPlatform(
      documents.path,
      supportPath: support.path,
    );
  });

  tearDown(() async {
    PathProviderPlatform.instance = originalProvider;
    await root.delete(recursive: true);
  });

  File databaseFile(Directory folder) =>
      File(p.join(folder.path, 'flexify.sqlite'));

  void seed(File file, String value) {
    final database = sqlite3.open(file.path);
    try {
      database.execute('CREATE TABLE records (value TEXT)');
      database.execute('INSERT INTO records VALUES (?)', [value]);
    } finally {
      database.close();
    }
  }

  String readValue(File file) {
    final database = sqlite3.open(file.path);
    try {
      return database.select('SELECT value FROM records').single['value']
          as String;
    } finally {
      database.close();
    }
  }

  test('fresh installs use the support directory', () async {
    final file = await getDatabaseFile();
    expect(file.path, databaseFile(support).path);
    expect(await support.exists(), isTrue);
    expect(await file.exists(), isFalse);
    expect(await databaseFile(documents).exists(), isFalse);
  });

  test('fresh installs work without a documents directory', () async {
    PathProviderPlatform.instance = _MissingDocumentsProvider(support.path);
    final file = await getDatabaseFile();
    expect(file.path, databaseFile(support).path);
    expect(await file.exists(), isFalse);
  });

  test('migration preserves data and existing absolute image paths', () async {
    final image = File(p.join(documents.path, 'photo.jpg'));
    await image.writeAsBytes([1, 2, 3]);
    final legacy = databaseFile(documents);
    seed(legacy, image.path);

    final file = await getDatabaseFile();
    expect(readValue(file), image.path);
    expect(await image.readAsBytes(), [1, 2, 3]);
    expect(readValue(legacy), image.path);
    expect((await getDatabaseFile()).path, file.path);
  });

  test('migration includes committed data still in the WAL', () async {
    final legacy = databaseFile(documents);
    final writer = sqlite3.open(legacy.path);
    try {
      writer.execute('PRAGMA journal_mode = WAL');
      writer.execute('PRAGMA wal_autocheckpoint = 0');
      writer.execute('CREATE TABLE records (value TEXT)');
      writer.execute("INSERT INTO records VALUES ('pending WAL data')");
      expect(await File('${legacy.path}-wal').length(), greaterThan(0));

      final file = await getDatabaseFile();
      expect(readValue(file), 'pending WAL data');
    } finally {
      writer.close();
    }
  });

  test('an existing support database takes precedence', () async {
    await support.create(recursive: true);
    seed(databaseFile(documents), 'legacy');
    seed(databaseFile(support), 'current');
    await File(
      '${databaseFile(support).path}.migrating',
    ).writeAsString('stale');

    final file = await getDatabaseFile();
    expect(readValue(file), 'current');
    expect(await File('${file.path}.migrating').exists(), isFalse);
  });

  test('deleting a migrated database never restores the legacy copy', () async {
    seed(databaseFile(documents), 'legacy');
    final file = await getDatabaseFile();
    await file.delete();

    expect(await (await getDatabaseFile()).exists(), isFalse);
    expect(readValue(databaseFile(documents)), 'legacy');
  });

  test('an interrupted publication resumes its committed snapshot', () async {
    await support.create(recursive: true);
    seed(databaseFile(documents), 'legacy');
    final staged = File('${databaseFile(support).path}.migrating');
    seed(staged, 'snapshot');
    await File(
      p.join(support.path, '.flexify-storage-migrated'),
    ).writeAsString('');

    expect(readValue(await getDatabaseFile()), 'snapshot');
    expect(await staged.exists(), isFalse);
  });

  test('an uncommitted partial snapshot is replaced on retry', () async {
    await support.create(recursive: true);
    seed(databaseFile(documents), 'legacy');
    await File(
      '${databaseFile(support).path}.migrating',
    ).writeAsString('partial snapshot');

    expect(readValue(await getDatabaseFile()), 'legacy');
  });

  test(
    'migration failure keeps the source and does not create a database',
    () async {
      final legacy = databaseFile(documents);
      await legacy.writeAsString('invalid sqlite database');

      await expectLater(getDatabaseFile(), throwsA(isA<SqliteException>()));
      expect(await legacy.readAsString(), 'invalid sqlite database');
      expect(await databaseFile(support).exists(), isFalse);
      expect(
        await File(p.join(support.path, '.flexify-storage-migrated')).exists(),
        isFalse,
      );

      await legacy.delete();
      seed(legacy, 'repaired');
      expect(readValue(await getDatabaseFile()), 'repaired');
    },
  );

  test('concurrent callers share migration', () async {
    seed(databaseFile(documents), 'legacy');
    final files = await Future.wait(List.generate(5, (_) => getDatabaseFile()));
    expect(files.map((file) => file.path).toSet(), {
      databaseFile(support).path,
    });
    expect(readValue(files.first), 'legacy');
  });

  test(
    'identical documents and support directories keep the existing file',
    () async {
      PathProviderPlatform.instance = FakePathProviderPlatform(documents.path);
      final legacy = databaseFile(documents);
      seed(legacy, 'same location');

      expect((await getDatabaseFile()).path, legacy.path);
      expect(readValue(legacy), 'same location');
    },
  );
}

class _MissingDocumentsProvider extends FakePathProviderPlatform {
  _MissingDocumentsProvider(super.documentsPath);

  @override
  Future<String?> getApplicationDocumentsPath() async => null;
}
