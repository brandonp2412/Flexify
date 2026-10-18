import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flexify/database/database.dart';

AppDatabase createIntegrationTestDatabase() {
  return AppDatabase(
    DatabaseConnection.delayed(
      Future(() async {
        final result = await WasmDatabase.open(
          databaseName: 'flexify_integration_test',
          sqlite3Uri: Uri.parse('sqlite3.wasm'),
          driftWorkerUri: Uri.parse('drift_worker.dart.js'),
        );
        return result.resolvedExecutor;
      }),
    ),
  );
}
