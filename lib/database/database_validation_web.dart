import 'package:drift/drift.dart';

Future<void> validateOpenDatabase(GeneratedDatabase database) async {
  final integrity = await database.customSelect('PRAGMA integrity_check').get();
  if (integrity.length != 1 ||
      integrity.single.read<String>('integrity_check') != 'ok') {
    throw StateError(
      'Flex browser database failed integrity check: $integrity',
    );
  }
  final violations = await database
      .customSelect('PRAGMA foreign_key_check')
      .get();
  if (violations.isNotEmpty) {
    throw StateError(
      'Flex browser database has foreign key violations: $violations',
    );
  }
}
