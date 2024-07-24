import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/defaults.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/database/plan_exercises.dart';
import 'package:flexify/database/plans.dart';
import 'package:flexify/database/schema_versions.dart';
import 'package:flexify/database/settings.dart';
import 'package:flexify/utils.dart';
import 'package:flutter/material.dart' as material;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

LazyDatabase openConnection(bool logStatements) {
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
      logStatements: logStatements,
    );
  });
}

@DriftDatabase(tables: [Plans, GymSets, Settings, PlanExercises])
class AppDatabase extends _$AppDatabase {
  final bool logStatements;

  AppDatabase({QueryExecutor? executor, required this.logStatements})
      : super(executor ?? openConnection(logStatements));

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
            showBodyWeight: const Value(true),
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
          await schema.gymSets.insertAll(
            defaultSets.map(
              (set) => RawValuesInsertable({
                'name': Variable(set.name.value),
                'reps': Variable(set.reps.value),
                'weight': Variable(set.weight.value),
                'unit': Variable(set.unit.value),
                'created': Variable(set.created.value),
                'hidden': const Variable(true),
              }),
            ),
          );
        },
        from5To6: (m, schema) async {
          await m.addColumn(schema.gymSets, schema.gymSets.bodyWeight);
          final bodyWeight = await getBodyWeight();
          if (bodyWeight?.weight == null) return;

          await (schema.gymSets.update()).write(
            RawValuesInsertable(
              {"body_weight": Variable(bodyWeight!.weight)},
            ),
          );
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
          final ms = const Duration(minutes: 3, seconds: 30).inMilliseconds;
          await m.database.customUpdate(
            "UPDATE gym_sets SET rest_ms = null WHERE rest_ms = $ms",
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

          await schema.settings.insertOne(
            RawValuesInsertable({
              'theme_mode': Variable(themeMode.toString()),
              'plan_trailing': Variable(planTrailing.toString()),
              'long_date_format': Variable(longDateFormat),
              'short_date_format': Variable(shortDateFormat),
              'timer_duration': Variable(timerDuration.inMilliseconds),
              'max_sets': Variable(maxSets),
              'vibrate': Variable(vibrate),
              'rest_timers': Variable(restTimers),
              'show_units': Variable(showUnits),
              'alarm_sound': Variable(alarmSound ?? ''),
              'cardio_unit': Variable(cardioUnit ?? 'km'),
              'curve_lines': Variable(curveLines),
              'explained_permissions': Variable(explainedPermissions),
              'group_history': Variable(groupHistory),
              'hide_history_tab': Variable(hideHistoryTab),
              'hide_timer_tab': Variable(hideTimerTab),
              'hide_weight': Variable(hideWeight),
              'strength_unit': Variable(strengthUnit ?? 'kg'),
              'system_colors': Variable(systemColors),
            }),
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

          List<Insertable<QueryRow>> pe = [];
          for (final plan in plans) {
            final exercises = plan.read<String>('exercises').split(',');

            for (final exercise in exercises) {
              final index = gymSets.indexWhere(
                (gymSet) => gymSet.read(schema.gymSets.name) == exercise,
              );
              if (index == -1) continue;

              final gymSet = gymSets[index];
              pe.add(
                RawValuesInsertable({
                  'plan_id': Variable(plan.read<int>('id')),
                  'exercise': Variable(exercise),
                  'enabled': const Variable(true),
                  'max_sets': Variable(gymSet.read(maxSets)),
                }),
              );
            }
          }

          await m.createTable(schema.planExercises);
          await schema.planExercises.insertAll(pe);
          await m.alterTable(TableMigration(schema.gymSets));
        },
        from18To19: (Migrator m, Schema19 schema) async {
          await m.addColumn(schema.settings, schema.settings.showImages);
          await m.addColumn(schema.gymSets, schema.gymSets.image);
        },
        from19To20: (Migrator m, Schema20 schema) async {
          await m.addColumn(schema.gymSets, schema.gymSets.category);
        },
        from20To21: (Migrator m, Schema21 schema) async {
          await m.addColumn(schema.settings, schema.settings.warmupSets);
          await m.addColumn(
            schema.planExercises,
            schema.planExercises.warmupSets,
          );
        },
        from21To22: (Migrator m, Schema22 schema) async {
          await m.addColumn(schema.settings, schema.settings.repEstimation);
        },
        from22To23: (Migrator m, Schema23 schema) async {
          await m.addColumn(
            schema.settings,
            schema.settings.durationEstimation,
          );
        },
        from23To24: (Migrator m, Schema24 schema) async {
          const hideWeight = CustomExpression<bool>('hide_weight');
          const hideTimerTab = CustomExpression<bool>('hide_timer_tab');
          const hideHistoryTab = CustomExpression<bool>('hide_history_tab');

          final result = await (schema.settings.selectOnly()
                ..addColumns([hideWeight, hideTimerTab, hideHistoryTab]))
              .getSingle();

          await m.addColumn(schema.settings, schema.settings.showBodyWeight);
          await m.addColumn(schema.settings, schema.settings.showTimerTab);
          await m.addColumn(schema.settings, schema.settings.showHistoryTab);

          await schema.settings.update().write(
                RawValuesInsertable(
                  {
                    'show_body_weight': Variable(!result.read(hideWeight)!),
                    'show_timer_tab': Variable(!result.read(hideTimerTab)!),
                    'show_history_tab': Variable(!result.read(hideHistoryTab)!),
                  },
                ),
              );
          await m.alterTable(TableMigration(schema.settings));
        },
        from24To25: (Migrator m, Schema25 schema) async {
          await m.addColumn(schema.settings, schema.settings.automaticBackups);
        },
        from25To26: (Migrator m, Schema26 schema) async {
          await m.addColumn(schema.settings, schema.settings.backupPath);
        },
        from26To27: (Migrator m, Schema27 schema) async {
          var tabs = ['HistoryPage', 'PlansPage', 'GraphsPage', 'TimerPage'];
          final settings =
              await (schema.settings.select()..limit(1)).getSingle();

          bool showTimer = settings.read('show_timer_tab');
          if (!showTimer) tabs.remove('TimerPage');
          bool showHistory = settings.read('show_history_tab');
          if (!showHistory) tabs.remove('HistoryPage');

          await m.addColumn(schema.settings, schema.settings.tabs);
          await schema.settings.update().write(
                RawValuesInsertable({
                  'tabs': Variable(tabs.join(',')),
                }),
              );

          await m.alterTable(TableMigration(schema.settings));
        },
      ),
    );
  }

  @override
  int get schemaVersion => 27;
}
