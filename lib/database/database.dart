import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/defaults.dart';
import 'package:flexify/database/plan_exercises.dart';
import 'package:flexify/database/schema_versions.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/database/settings.dart';
import 'package:flexify/database/plans.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Plans, GymSets, Settings, PlanExercises])
class AppDatabase extends _$AppDatabase {
  AppDatabase({QueryExecutor? executor}) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 18;

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
          batch.insertAll(gymSets, defaultSets);
          batch.insertAll(plans, defaultPlans);
          batch.insertAll(planExercises, defaultPlanExercises);
        });

        await settings.insertOne(
          SettingsCompanion.insert(
            themeMode: material.ThemeMode.system.toString(),
            planTrailing: PlanTrailing.reorder.toString(),
            longDateFormat: 'dd/MM/yy',
            shortDateFormat: 'd/M/yy',
            timerDuration:
                const Duration(minutes: 3, seconds: 30).inMilliseconds,
            maxSets: 3,
            vibrate: true,
            restTimers: true,
            showUnits: true,
            alarmSound: '',
            cardioUnit: 'km',
            curveLines: false,
            explainedPermissions: false,
            groupHistory: true,
            hideHistoryTab: false,
            hideTimerTab: false,
            hideWeight: false,
            strengthUnit: 'kg',
            systemColors: false,
          ),
        );
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
          await batch((batch) => batch.insertAll(gymSets, defaultSets));
        },
        from5To6: (m, schema) async {
          await m.addColumn(schema.gymSets, schema.gymSets.bodyWeight);
          final bodyWeight = await getBodyWeight();
          if (bodyWeight?.weight == null) return;

          await (gymSets.update())
              .write(GymSetsCompanion(bodyWeight: Value(bodyWeight!.weight)));
        },
        from6To7: (m, schema) async {
          final prefs = await SharedPreferences.getInstance();
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
          final prefs = await SharedPreferences.getInstance();
          final timerDuration = prefs.getInt('timerDuration');
          if (timerDuration != null)
            await (gymSets
                .update()
                .write(GymSetsCompanion(restMs: Value(timerDuration))));
          await m.addColumn(schema.gymSets, schema.gymSets.maxSets);
          final maxSets = prefs.getInt('maxSets');
          if (maxSets != null)
            await m.database.customUpdate(
              "UPDATE gym_sets SET max_sets = $maxSets",
            );
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
          await m.database.customUpdate(
            "UPDATE gym_sets SET max_sets = NULL WHERE max_sets = 3",
          );
        },
        from14To15: (Migrator m, Schema15 schema) async {
          final prefs = await SharedPreferences.getInstance();
          final maxSets = prefs.getInt('maxSets');

          if (maxSets != null)
            await m.database.customUpdate(
              "UPDATE gym_sets SET max_sets = NULL WHERE max_sets = $maxSets",
            );
        },
        from15To16: (Migrator m, Schema16 schema) async {
          await m.createTable(schema.settings);
          material.ThemeMode themeMode = material.ThemeMode.system;
          PlanTrailing planTrailing = PlanTrailing.reorder;
          Duration timerDuration = const Duration(minutes: 3, seconds: 30);
          int maxSets = 3;
          String longDateFormat = 'dd/MM/yy';
          String shortDateFormat = 'd/M/yy';
          String? alarmSound;
          String? cardioUnit;
          String? strengthUnit;

          bool vibrate = true;
          bool restTimers = true;
          bool showUnits = true;
          bool systemColors = true;
          bool explainedPermissions = false;
          bool hideTimerTab = false;
          bool hideHistoryTab = false;
          bool curveLines = false;
          bool hideWeight = false;
          bool groupHistory = true;

          final prefs = await SharedPreferences.getInstance();
          alarmSound = prefs.getString('alarmSound');
          cardioUnit = prefs.getString('cardioUnit');
          strengthUnit = prefs.getString('strengthUnit');
          longDateFormat = prefs.getString('longDateFormat') ?? "dd/MM/yy";
          shortDateFormat = prefs.getString('shortDateFormat') ?? "d/M/yy";
          maxSets = prefs.getInt('maxSets') ?? 3;

          final duration = prefs.getInt('timerDuration');
          if (duration != null)
            timerDuration = Duration(milliseconds: duration);
          else
            timerDuration = const Duration(minutes: 3, seconds: 30);

          final theme = prefs.getString('themeMode');
          if (theme == material.ThemeMode.system.toString())
            themeMode = material.ThemeMode.system;
          else if (theme == material.ThemeMode.light.toString())
            themeMode = material.ThemeMode.light;
          else if (theme == material.ThemeMode.dark.toString())
            themeMode = material.ThemeMode.dark;

          final plan = prefs.getString('planTrailing');
          for (final trailing in PlanTrailing.values)
            if (plan == trailing.toString()) planTrailing = trailing;

          systemColors = prefs.getBool("systemColors") ?? true;
          restTimers = prefs.getBool("restTimers") ?? true;
          showUnits = prefs.getBool("showUnits") ?? true;
          hideTimerTab = prefs.getBool("hideTimerTab") ?? false;
          hideHistoryTab = prefs.getBool("hideHistoryTab") ?? false;
          explainedPermissions = prefs.getBool('explainedPermissions') ?? false;
          curveLines = prefs.getBool('curveLines') ?? false;
          vibrate = prefs.getBool('vibrate') ?? true;
          hideWeight = prefs.getBool('hideWeight') ?? false;
          groupHistory = prefs.getBool('groupHistory') ?? true;

          await settings.insertOne(
            SettingsCompanion.insert(
              themeMode: themeMode.toString(),
              planTrailing: planTrailing.toString(),
              longDateFormat: longDateFormat,
              shortDateFormat: shortDateFormat,
              timerDuration: timerDuration.inMilliseconds,
              maxSets: maxSets,
              vibrate: vibrate,
              restTimers: restTimers,
              showUnits: showUnits,
              alarmSound: alarmSound ?? '',
              cardioUnit: cardioUnit ?? 'km',
              curveLines: curveLines,
              explainedPermissions: explainedPermissions,
              groupHistory: groupHistory,
              hideHistoryTab: hideHistoryTab,
              hideTimerTab: hideTimerTab,
              hideWeight: hideWeight,
              strengthUnit: strengthUnit ?? 'kg',
              systemColors: systemColors,
            ),
          );
        },
        from16To17: (Migrator m, Schema17 schema) async {
          await m.addColumn(schema.gymSets, schema.gymSets.planId);
        },
        from17To18: (Migrator m, Schema18 schema) async {
          final plans = await (schema.plans.select()).get();
          const maxSets = CustomExpression<int>('max_sets');
          final gymSets = await (schema.gymSets.selectOnly()
                ..addColumns(
                  [maxSets, schema.gymSets.name],
                )
                ..groupBy([schema.gymSets.name]))
              .get();

          List<PlanExercisesCompanion> pe = [];
          for (final plan in plans) {
            final exercises = plan.read<String>('exercises').split(',');

            for (final exercise in exercises) {
              final gymSet = gymSets.firstWhere(
                (gymSet) => gymSet.read(schema.gymSets.name) == exercise,
              );
              pe.add(
                PlanExercisesCompanion.insert(
                  planId: plan.read('id'),
                  exercise: exercise,
                  enabled: true,
                  maxSets: Value(gymSet.read(maxSets)),
                ),
              );
            }
          }

          await m.createTable(schema.planExercises);
          await planExercises.insertAll(pe);
          await m.alterTable(TableMigration(schema.gymSets));
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
