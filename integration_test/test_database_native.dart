import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flex/database/database.dart';

AppDatabase createIntegrationTestDatabase() {
  return AppDatabase(
    DatabaseConnection(
      NativeDatabase.memory(),
      closeStreamsSynchronously: true,
    ),
  );
}
