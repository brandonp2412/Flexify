import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plans.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Plans, GymSets])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 11;

  final _defaultSets = defaultExercises.map(
    (exercise) => GymSetsCompanion(
      created: Value(DateTime.now().toLocal()),
      name: Value(exercise),
      reps: const Value(0),
      weight: const Value(0),
      hidden: const Value(true),
      unit: const Value('kg'),
    ),
  );

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await db.batch((batch) {
          batch.insertAll(gymSets, _defaultSets);
          batch.insertAll(plans, defaultPlans);
        });
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createIndex(
            Index(
              'GymSets',
              "CREATE INDEX gym_sets_name_created ON gym_sets(name, created);",
            ),
          );
        }

        if (from < 3) {
          await m.addColumn(plans, plans.sequence);
        }
        if (from < 4) {
          await m.addColumn(plans, plans.title);
        }

        if (from < 5) {
          await m.addColumn(gymSets, gymSets.hidden);
          await db.batch((batch) => batch.insertAll(gymSets, _defaultSets));
        }

        if (from < 6) {
          await m.addColumn(gymSets, gymSets.bodyWeight);
          final bodyWeight = await getBodyWeight();
          if (bodyWeight?.weight == null) return;

          await (gymSets.update())
              .write(GymSetsCompanion(bodyWeight: Value(bodyWeight!.weight)));
        }

        if (from < 7) {
          final dateFormat = prefs.getString('dateFormat');
          if (dateFormat == null) return;
          prefs.setString('longDateFormat', dateFormat);
        }

        if (from < 8) {
          await m.addColumn(gymSets, gymSets.duration);
          await m.addColumn(gymSets, gymSets.distance);
          await m.addColumn(gymSets, gymSets.cardio);
        }

        if (from < 9) {
          await m.addColumn(gymSets, gymSets.restMs);
          final timerDuration = prefs.getInt('timerDuration');
          if (timerDuration != null)
            await (gymSets
                .update()
                .write(GymSetsCompanion(restMs: Value(timerDuration))));
        }

        if (from < 10) {
          await m.addColumn(gymSets, gymSets.maxSets);
          final maxSets = prefs.getInt('maxSets');
          if (maxSets != null)
            await (gymSets
                .update()
                .write(GymSetsCompanion(maxSets: Value(maxSets))));
        }

        if (from < 11) {
          await m.addColumn(gymSets, gymSets.incline);
        }
      },
    );
  }
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
    return NativeDatabase.createInBackground(
      file,
      logStatements: kDebugMode ? true : false,
    );
  });
}
