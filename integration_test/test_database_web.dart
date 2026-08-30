import 'package:drift/drift.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';
import 'package:flexify/database/database.dart';

AppDatabase createIntegrationTestDatabase() {
  return AppDatabase(
    LazyDatabase(() async {
      return WebDatabase.withStorage(
        await DriftWebStorage.indexedDbIfSupported('flexify_integration_test'),
      );
    }),
  );
}
