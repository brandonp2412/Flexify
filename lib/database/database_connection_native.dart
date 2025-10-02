import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:flutter/foundation.dart';

LazyDatabase createNativeConnection() {
  return LazyDatabase(() async {
    return SqfliteQueryExecutor.inDatabaseFolder(
      path: 'flexify.sqlite',
      logStatements: kDebugMode,
    );
  });
}

LazyDatabase createWebConnection() {
  throw UnsupportedError('Web connection not supported on native platforms');
}