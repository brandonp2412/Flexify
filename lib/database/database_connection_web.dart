import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart' show DriftWebStorage;

DatabaseConnection createPersistentConnection() => DatabaseConnection.delayed(
  Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'flexify',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
      initializeDatabase: _restoreLegacyDatabase,
    );
    if (result.chosenImplementation == WasmStorageImplementation.inMemory) {
      throw StateError('This browser cannot persist Flexify data.');
    }
    return result.resolvedExecutor;
  }),
);

Future<Uint8List?> _restoreLegacyDatabase() async {
  final storage = await DriftWebStorage.indexedDbIfSupported('flexify_db');
  await storage.open();
  try {
    return await storage.restore();
  } finally {
    await storage.close();
  }
}

QueryExecutor createConnectionForPath(String path) {
  throw UnsupportedError('Path-based database connection not supported on web');
}
