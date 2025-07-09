import 'package:drift/drift.dart';
import 'package:drift/web.dart';
import 'package:flutter/foundation.dart';

LazyDatabase createWebConnection() {
  return LazyDatabase(() async {
    return WebDatabase.withStorage(
      await DriftWebStorage.indexedDbIfSupported('flexify_db'),
      logStatements: kDebugMode,
    );
  });
}

// Stub for native function to avoid compilation errors
LazyDatabase createNativeConnection() {
  throw UnsupportedError('Native connection not supported on web');
}
