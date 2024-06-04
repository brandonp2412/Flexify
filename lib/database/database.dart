import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/schema_versions.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flexify/database/plans.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Plans, GymSets])
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor}) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 14;

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
        await m.createIndex(
          Index(
            'GymSets',
            "CREATE INDEX IF NOT EXISTS gym_sets_name_created ON gym_sets(name, created);",
          ),
        );
        await batch((batch) {
          batch.insertAll(gymSets, _defaultSets);
          batch.insertAll(plans, defaultPlans);
        });
      },
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await m.alterTable(TableMigration(schema.gymSets));
          await m.alterTable(TableMigration(schema.plans));
          await m.createIndex(
            Index(
              'GymSets',
              "CREATE INDEX IF NOT EXISTS gym_sets_name_created ON gym_sets(name, created);",
            ),
          );
        },
        from2To3: (m, schema) async {
          await m.addColumn(schema.plans, schema.plans.sequence);
        },
        from3To4: (m, schema) async {
          await m.addColumn(schema.plans, schema.plans.title);
        },
        from4To5: (m, schema) async {
          await m.addColumn(schema.gymSets, schema.gymSets.hidden);
          await batch((batch) => batch.insertAll(gymSets, _defaultSets));
        },
        from5To6: (m, schema) async {
          await m.addColumn(schema.gymSets, schema.gymSets.bodyWeight);
          final bodyWeight = await getBodyWeight();
          if (bodyWeight?.weight == null) return;

          await (gymSets.update())
              .write(GymSetsCompanion(bodyWeight: Value(bodyWeight!.weight)));
        },
        from6To7: (m, schema) async {
          final dateFormat = prefs.getString('dateFormat');
          if (dateFormat == null) return;
          prefs.setString('longDateFormat', dateFormat);
        },
        from7To8: (m, schema) async {
          await m.addColumn(schema.gymSets, schema.gymSets.duration);
          await m.addColumn(schema.gymSets, schema.gymSets.distance);
          await m.addColumn(schema.gymSets, schema.gymSets.cardio);
        },
        from8To10: (Migrator m, Schema10 schema) async {
          await m.addColumn(schema.gymSets, schema.gymSets.restMs);
          final timerDuration = prefs.getInt('timerDuration');
          if (timerDuration != null)
            await (gymSets
                .update()
                .write(GymSetsCompanion(restMs: Value(timerDuration))));
          await m.addColumn(schema.gymSets, schema.gymSets.maxSets);
          final maxSets = prefs.getInt('maxSets');
          if (maxSets != null)
            await (gymSets
                .update()
                .write(GymSetsCompanion(maxSets: Value(maxSets))));
        },
        from10To11: (m, schema) async {
          await m.addColumn(schema.gymSets, schema.gymSets.incline);
        },
        from11To12: (m, schema) async {
          await m.createIndex(
            Index(
              'GymSets',
              "CREATE INDEX IF NOT EXISTS gym_sets_name_created ON gym_sets(name, created);",
            ),
          );
        },
        from12To13: (m, schema) async {
          await m.alterTable(TableMigration(schema.gymSets));
          (gymSets.update()
                ..where(
                  (u) => u.restMs.equals(
                    const Duration(minutes: 3, seconds: 30).inMilliseconds,
                  ),
                ))
              .write(
            const GymSetsCompanion(
              restMs: Value(null),
            ),
          );
        },
        from13To14: (m, schema) async {
          await m.alterTable(TableMigration(schema.gymSets));
          (gymSets.update()
                ..where(
                  (u) => u.maxSets.equals(3),
                ))
              .write(
            const GymSetsCompanion(
              maxSets: Value(null),
            ),
          );
        },
      ),
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
