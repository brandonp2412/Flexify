import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'generated_migrations/schema.dart';

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('upgrade from all versions', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    final currentVersion =
        AppDatabase(executor: NativeDatabase.memory()).schemaVersion;

    for (int from = 1; from <= currentVersion; from++) {
      if (from == 8 || from == 9) continue;

      for (int to = from + 1; to <= currentVersion; to++) {
        if (to == 8 || to == 9) continue;
        debugPrint("Migrating from $from to $to");
        final connection = await verifier.startAt(from);
        db = AppDatabase(executor: connection);
        await verifier.migrateAndValidate(db, to);
        await db.close();
      }
    }
  });
}
