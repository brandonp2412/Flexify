import 'package:drift/drift.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';
import 'package:flutter/foundation.dart';

LazyDatabase createWebConnection() {
  return LazyDatabase(() async {
    return WebDatabase.withStorage(
      await DriftWebStorage.indexedDbIfSupported('flexify_db'),
      logStatements: kDebugMode,
      setup: (database) => database.run('PRAGMA foreign_keys = ON'),
    );
  });
}

LazyDatabase createNativeConnection() {
  throw UnsupportedError('Native connection not supported on web');
}
