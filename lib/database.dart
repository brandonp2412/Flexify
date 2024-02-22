import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

class GymSets extends Table {
  TextColumn get name => text()();
  IntColumn get reps => integer()();
  IntColumn get weight => integer()();
  TextColumn get unit => text()();
  DateTimeColumn get created => dateTime()();
}

class Plans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get exercises => text()();
  TextColumn get days => text()();
}

@DriftDatabase(tables: [Plans, GymSets])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'flexify.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;
    return NativeDatabase.createInBackground(file,
        logStatements: kDebugMode ? true : false);
  });
}
