import 'package:drift/drift.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';

LazyDatabase createWebConnection() {
  return LazyDatabase(() async {
    return WebDatabase.withStorage(
      await DriftWebStorage.indexedDbIfSupported('flexify_db'),
      setup: (database) => database.run('PRAGMA foreign_keys = ON'),
    );
  });
}

QueryExecutor createConnectionForPath(String path) {
  throw UnsupportedError('Path-based database connection not supported on web');
}

LazyDatabase createNativeConnection() {
  throw UnsupportedError('Native connection not supported on web');
}
