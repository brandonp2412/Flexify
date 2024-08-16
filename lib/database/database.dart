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
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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

        await settings.insertOne(defaultSettings);
      },
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          final gymSets = await schema.gymSets.select().get();
          final plans = await schema.plans.select().get();
          await m.drop(schema.gymSets);
          await m.drop(schema.plans);
          await m.create(schema.gymSets);
          await m.create(schema.plans);

          await schema.gymSets.insertAll(
            gymSets.map(
              (gymSet) => RawValuesInsertable({
                'name': Variable(gymSet.read<String>('name')),
                'reps': Variable(gymSet.read<double>('reps')),
                'weight': Variable(gymSet.read<double>('weight')),
                'unit': Variable(gymSet.read<String>('unit')),
                'created': Variable(gymSet.read<DateTime>('created')),
              }),
            ),
          );
          await schema.plans.insertAll(
            plans.map(
              (plan) => RawValuesInsertable({
                'exercises': Variable(plan.read<String>('workouts')),
                'days': Variable(plan.read<String>('days')),
              }),
            ),
          );

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
        },
        from6To7: (m, schema) async {},
        from7To8: (m, schema) async {
          await m.addColumn(schema.gymSets, schema.gymSets.duration);
          await m.addColumn(schema.gymSets, schema.gymSets.distance);
          await m.addColumn(schema.gymSets, schema.gymSets.cardio);
        },
        from8To10: (Migrator m, Schema10 schema) async {
          await m.addColumn(schema.gymSets, schema.gymSets.restMs);
          await m.addColumn(schema.gymSets, schema.gymSets.maxSets);
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
        from14To15: (Migrator m, Schema15 schema) async {},
        from15To16: (Migrator m, Schema16 schema) async {
          await m.createTable(schema.settings);
          await schema.settings.insertOne(
            RawValuesInsertable({
              'theme_mode': const Variable('ThemeMode.system'),
              'plan_trailing': const Variable('PlanTrailing.reorder'),
              'long_date_format': const Variable('dd/MM/yy'),
              'short_date_format': const Variable('d/M/yy'),
              'timer_duration': Variable(
                const Duration(minutes: 3, seconds: 30).inMilliseconds,
              ),
              'max_sets': const Variable(3),
              'vibrate': const Variable(true),
              'rest_timers': const Variable(true),
              'show_units': const Variable(true),
              'alarm_sound': const Variable(''),
              'cardio_unit': const Variable('km'),
              'curve_lines': const Variable(false),
              'explained_permissions': const Variable(true),
              'group_history': const Variable(true),
              'hide_history_tab': const Variable(false),
              'hide_timer_tab': const Variable(false),
              'hide_weight': const Variable(false),
              'strength_unit': const Variable('kg'),
              'system_colors': const Variable(false),
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
              .getSingleOrNull();

          await m.addColumn(schema.settings, schema.settings.showBodyWeight);
          await m.addColumn(schema.settings, schema.settings.showTimerTab);
          await m.addColumn(schema.settings, schema.settings.showHistoryTab);

          if (result != null)
            await schema.settings.update().write(
                  RawValuesInsertable(
                    {
                      'show_body_weight': Variable(!result.read(hideWeight)!),
                      'show_timer_tab': Variable(!result.read(hideTimerTab)!),
                      'show_history_tab':
                          Variable(!result.read(hideHistoryTab)!),
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
              await (schema.settings.select()..limit(1)).getSingleOrNull();

          if (settings != null) {
            bool showTimer = settings.read('show_timer_tab');
            if (!showTimer) tabs.remove('TimerPage');
            bool showHistory = settings.read('show_history_tab');
            if (!showHistory) tabs.remove('HistoryPage');
          }

          await m.addColumn(schema.settings, schema.settings.tabs);
          await schema.settings.update().write(
                RawValuesInsertable({
                  'tabs': Variable(tabs.join(',')),
                }),
              );

          await m.alterTable(TableMigration(schema.settings));
        },
        from27To28: (Migrator m, Schema28 schema) async {
          await m.addColumn(schema.settings, schema.settings.enableSound);
        },
        from28To29: (Migrator m, Schema29 schema) async {
          await m.database
              .customStatement('DROP INDEX IF EXISTS gym_sets_name_created');
          await m.createIndex(
            Index(
              'gym_sets',
              'CREATE INDEX IF NOT EXISTS gym_sets_name ON gym_sets(name)',
            ),
          );
          await m.createIndex(
            Index(
              'gym_sets',
              'CREATE INDEX IF NOT EXISTS gym_sets_created ON gym_sets(created)',
            ),
          );
          await m.createIndex(
            Index(
              'gym_sets',
              'CREATE INDEX IF NOT EXISTS gym_sets_hidden ON gym_sets(hidden)',
            ),
          );
        },
        from29To30: (Migrator m, Schema30 schema) async {
          await m.createIndex(
            Index(
              'plan_exercises',
              'CREATE INDEX IF NOT EXISTS plan_exercises_plan_id ON plan_exercises(plan_id)',
            ),
          );
          await m.createIndex(
            Index(
              'gym_sets',
              'CREATE INDEX IF NOT EXISTS gym_sets_plan_id ON gym_sets(plan_id)',
            ),
          );
        },
        from30To31: (Migrator m, Schema31 schema) async {
          await m.addColumn(schema.planExercises, schema.planExercises.timers);
        },
      ),
    );
  }

  @override
  int get schemaVersion => 31;
}
