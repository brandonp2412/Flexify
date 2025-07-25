import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

LazyDatabase createNativeConnection() {
  return LazyDatabase(() async {
    final folder = await getApplicationDocumentsDirectory();
    final file = File(p.join(folder.path, 'flexify.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cache = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cache;
    return NativeDatabase.createInBackground(
      file,
      logStatements: kDebugMode,
    );
  });
}

LazyDatabase createWebConnection() {
  throw UnsupportedError('Web connection not supported on native platforms');
}
