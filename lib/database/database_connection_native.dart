import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/storage/app_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

QueryExecutor createConnectionForPath(String path) {
  return NativeDatabase.createInBackground(
    File(path),
    setup: (database) => database.execute('PRAGMA foreign_keys = ON'),
  );
}

LazyDatabase createNativeConnection() {
  return LazyDatabase(() async {
    final file = await getDatabaseFile();

    final cache = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cache;
    return NativeDatabase.createInBackground(
      file,
      setup: (database) => database.execute('PRAGMA foreign_keys = ON'),
    );
  });
}

LazyDatabase createWebConnection() {
  throw UnsupportedError('Web connection not supported on native platforms');
}
