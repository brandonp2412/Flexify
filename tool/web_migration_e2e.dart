// Browser-only entry point for testing upgrades from DriftWebStorage to WASM.
// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/database_validation_web.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase.persistent();
  try {
    final setting = await database.settings.select().getSingle();
    await validateOpenDatabase(database);
    if (setting.id <= 0) throw StateError('Missing migrated settings');
    final rows = await database
        .customSelect(
          "SELECT name, notes FROM exercises WHERE name = 'Web Migration Sentinel'",
        )
        .get();
    if (rows.length != 1) throw StateError('Legacy exercise was lost');
    final count = await database
        .customSelect(
          'SELECT COUNT(*) AS total FROM exercise_sets WHERE exercise_id = '
          "(SELECT id FROM exercises WHERE name = 'Web Migration Sentinel')",
        )
        .getSingle();
    if (count.read<int>('total') != 1) {
      throw StateError('Legacy exercise set was lost');
    }
    final phase = Uri.base.queryParameters['phase'];
    if (phase == 'initial') {
      await database.customStatement(
        "UPDATE exercises SET notes = 'WASM-persisted marker' "
        "WHERE name = 'Web Migration Sentinel'",
      );
    } else if (phase == 'verify' &&
        rows.single.readNullable<String>('notes') != 'WASM-persisted marker') {
      throw StateError('New WASM data did not survive reload');
    }
    html.document.body!.appendText('MIGRATION_OK:$phase');
  } catch (error, stack) {
    html.document.body!.appendText('MIGRATION_FAILED:$error');
    html.window.console.error('$error\n$stack');
  } finally {
    await database.close();
  }
}
