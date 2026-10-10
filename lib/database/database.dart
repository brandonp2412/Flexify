// ignore_for_file: experimental_member_use
import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/body_weights.dart';
import 'package:flexify/database/categories.dart';
import 'package:flexify/database/database.steps.dart';
import 'package:flexify/database/defaults.dart';
import 'package:flexify/database/exercise_sets.dart';
import 'package:flexify/database/exercises.dart';
import 'package:flexify/database/plan_exercises.dart';
import 'package:flexify/database/plans.dart';
import 'package:flexify/database/settings.dart';
import 'package:flexify/database/workouts.dart';
import 'package:flexify/logging.dart';
import 'package:flutter/foundation.dart';

import 'database_connection_web.dart'
    if (dart.library.io) 'database_connection_native.dart';
import 'migrations_web.dart' if (dart.library.io) 'migrations_native.dart';

export 'exercise_set_view.dart';

part 'database.g.dart';

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    if (kIsWeb) return createWebConnection();
    return createNativeConnection();
  });
}

Future<void> _removeOrphanedPlanExercises(AppDatabase database) async {
  await database.customStatement(r'''
    DELETE FROM plan_exercises
    WHERE exercise_id IS NULL
       OR NOT EXISTS (
         SELECT 1
         FROM exercises
         WHERE exercises.id = plan_exercises.exercise_id
       )
       OR NOT EXISTS (
         SELECT 1
         FROM plans
         WHERE plans.id = plan_exercises.plan_id
       )
  ''');
}

Future<void> _backfillExerciseIdentity(AppDatabase database) async {
  await database.customStatement(r'''
    WITH ranked AS (
      SELECT
        gym_sets.*,
        ROW_NUMBER() OVER (
          PARTITION BY gym_sets.name
          ORDER BY gym_sets.hidden DESC, gym_sets.created DESC, gym_sets.id DESC
        ) AS choice_rank
      FROM gym_sets
      WHERE gym_sets.name <> 'Weight'
    ),
    chosen AS (
      SELECT *
      FROM ranked
      WHERE choice_rank = 1
    )
    INSERT INTO exercises (
      name,
      kind,
      display_unit,
      category_id,
      image,
      default_rest_duration_ms,
      notes,
      graph_metric,
      graph_period,
      graph_limit,
      graph_time_based_x_axis,
      archived
    )
    SELECT
      chosen.name,
      CASE WHEN chosen.cardio = 1 THEN 'cardio' ELSE 'strength' END,
      chosen.unit,
      categories.id,
      chosen.image,
      chosen.rest_ms,
      COALESCE(
        graph_preferences.notes,
        CASE
          WHEN chosen.hidden = 1 THEN NULLIF(chosen.notes, '')
          ELSE NULL
        END
      ),
      COALESCE(graph_preferences.metric, 'bestWeight'),
      COALESCE(graph_preferences.period, 'day'),
      COALESCE(graph_preferences."limit", 20),
      COALESCE(graph_preferences.time_based_x_axis, 0),
      0
    FROM chosen
    LEFT JOIN categories ON categories.name = chosen.category
    LEFT JOIN graph_preferences ON graph_preferences.name = chosen.name
    WHERE 1 = 1
    ORDER BY chosen.name COLLATE BINARY
    ON CONFLICT(name) DO UPDATE SET
      kind = excluded.kind,
      display_unit = excluded.display_unit,
      category_id = excluded.category_id,
      image = excluded.image,
      default_rest_duration_ms = excluded.default_rest_duration_ms,
      notes = excluded.notes,
      graph_metric = excluded.graph_metric,
      graph_period = excluded.graph_period,
      graph_limit = excluded.graph_limit,
      graph_time_based_x_axis = excluded.graph_time_based_x_axis,
      archived = excluded.archived
  ''');

  await database.customStatement(r'''
    UPDATE plan_exercises
    SET exercise_id = (
      SELECT exercises.id
      FROM exercises
      WHERE exercises.name = plan_exercises.exercise
    )
    WHERE EXISTS (
      SELECT 1
      FROM exercises
      WHERE exercises.name = plan_exercises.exercise
    )
  ''');
}

Future<void> _backfillExerciseHistory(AppDatabase database) async {
  await database.customStatement(r'''
    INSERT INTO body_weights (timestamp, weight_kg, photo)
    SELECT
      created,
      CASE unit
        WHEN 'lb' THEN weight * 0.45359237
        WHEN 'stone' THEN weight * 6.35029318
        ELSE weight
      END,
      image
    FROM gym_sets
    WHERE hidden = 0
      AND name = 'Weight'
    ORDER BY created, id
  ''');

  // Legacy plan history has no session id. Flexify's plan history already
  // treats same-plan sets on the same local calendar day as one session, so
  // migration keeps that grouping. Observed first/last set times bound the
  // workout; no unobserved start or end time is invented.
  await database.customStatement(r'''
    WITH grouped_workouts AS (
      SELECT
        MIN(gym_sets.id) AS workout_id,
        gym_sets.plan_id AS legacy_plan_id,
        MIN(gym_sets.created) AS started_at,
        MAX(gym_sets.created) AS ended_at
      FROM gym_sets
      WHERE gym_sets.hidden = 0
        AND gym_sets.name <> 'Weight'
        AND gym_sets.plan_id IS NOT NULL
      GROUP BY
        gym_sets.plan_id,
        DATE(gym_sets.created, 'unixepoch', 'localtime')
    )
    INSERT INTO workouts (id, plan_id, started_at, ended_at)
    SELECT
      grouped_workouts.workout_id,
      CASE
        WHEN EXISTS (
          SELECT 1
          FROM plans
          WHERE plans.id = grouped_workouts.legacy_plan_id
        )
        THEN grouped_workouts.legacy_plan_id
        ELSE NULL
      END,
      grouped_workouts.started_at,
      grouped_workouts.ended_at
    FROM grouped_workouts
    ORDER BY grouped_workouts.started_at, grouped_workouts.workout_id
  ''');

  await database.customStatement(r'''
    WITH source_sets AS (
      SELECT
        gym_sets.*,
        exercises.id AS migrated_exercise_id,
        CASE
          WHEN gym_sets.plan_id IS NULL THEN NULL
          ELSE (
            SELECT MIN(session_set.id)
            FROM gym_sets AS session_set
            WHERE session_set.hidden = 0
              AND session_set.name <> 'Weight'
              AND session_set.plan_id = gym_sets.plan_id
              AND DATE(
                session_set.created,
                'unixepoch',
                'localtime'
              ) = DATE(
                gym_sets.created,
                'unixepoch',
                'localtime'
              )
          )
        END AS migrated_workout_id,
        CASE
          WHEN gym_sets.body_weight = 0 THEN NULL
          ELSE COALESCE(
            (
              SELECT weight_entry.unit
              FROM gym_sets AS weight_entry
              WHERE weight_entry.hidden = 0
                AND weight_entry.name = 'Weight'
                AND weight_entry.created <= gym_sets.created
              ORDER BY weight_entry.created DESC, weight_entry.id DESC
              LIMIT 1
            ),
            (
              SELECT weight_entry.unit
              FROM gym_sets AS weight_entry
              WHERE weight_entry.hidden = 0
                AND weight_entry.name = 'Weight'
              ORDER BY weight_entry.created DESC, weight_entry.id DESC
              LIMIT 1
            ),
            'kg'
          )
        END AS body_weight_unit
      FROM gym_sets
      INNER JOIN exercises ON exercises.name = gym_sets.name
      WHERE gym_sets.hidden = 0
        AND gym_sets.name <> 'Weight'
    )
    INSERT INTO exercise_sets (
      exercise_id,
      workout_id,
      timestamp,
      reps,
      load_kg,
      duration_ms,
      distance_metres,
      incline,
      body_weight_kg,
      notes
    )
    SELECT
      source_sets.migrated_exercise_id,
      source_sets.migrated_workout_id,
      source_sets.created,
      source_sets.reps,
      CASE source_sets.unit
        WHEN 'kg' THEN source_sets.weight
        WHEN 'lb' THEN source_sets.weight * 0.45359237
        WHEN 'stone' THEN source_sets.weight * 6.35029318
        ELSE NULL
      END,
      CAST(ROUND(source_sets.duration * 60000.0) AS INTEGER),
      CASE source_sets.unit
        WHEN 'm' THEN source_sets.distance
        WHEN 'km' THEN source_sets.distance * 1000.0
        WHEN 'mi' THEN source_sets.distance * 1609.344
        ELSE NULL
      END,
      source_sets.incline,
      CASE source_sets.body_weight_unit
        WHEN 'lb' THEN source_sets.body_weight * 0.45359237
        WHEN 'stone' THEN source_sets.body_weight * 6.35029318
        WHEN 'kg' THEN source_sets.body_weight
        ELSE NULL
      END,
      source_sets.notes
    FROM source_sets
    ORDER BY source_sets.id
  ''');
}

@DriftDatabase(
  tables: [
    Categories,
    Plans,
    Exercises,
    Workouts,
    ExerciseSets,
    BodyWeights,
    Settings,
    PlanExercises,
  ],
)
class AppDatabase extends _$AppDatabase {
  Stream<Setting> watchSettings() => (select(settings)..limit(1)).watchSingle();

  /// Creates a database backed by the provided [executor].
  AppDatabase(super.executor);

  /// Opens a native database at [path], primarily for validating imports.
  AppDatabase.forPath(String path) : super(createConnectionForPath(path));

  /// Opens Flexify's persistent application database.
  AppDatabase.persistent() : super(openConnection());

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
        talker.debug('Opening Flexify database schema v${details.versionNow}');
        if (kDebugMode) await validateDatabaseSchema();
      },
      onCreate: (Migrator m) async {
        talker.info('Creating Flexify database');
        await m.createAll();

        for (final categoryName
            in defaultExercises.map((entry) => entry.$2).toSet()) {
          await categories.insertOne(
            CategoriesCompanion.insert(name: categoryName),
            mode: InsertMode.insertOrIgnore,
          );
        }
        final defaultCategoryIds = {
          for (final category in await categories.select().get())
            category.name: category.id,
        };
        await batch((batch) {
          batch.insertAll(
            exercises,
            defaultExercises.map(
              (entry) => ExercisesCompanion.insert(
                name: entry.$1,
                kind: 'strength',
                displayUnit: 'kg',
                categoryId: Value(defaultCategoryIds[entry.$2]),
              ),
            ),
          );
          batch.insertAll(plans, defaultPlans);
        });
        final defaultExerciseIds = {
          for (final exercise in await exercises.select().get())
            exercise.name: exercise.id,
        };
        await planExercises.insertAll(
          defaultPlanExerciseNames.map(
            (entry) => PlanExercisesCompanion.insert(
              planId: entry.$1,
              exerciseId: defaultExerciseIds[entry.$2]!,
              enabled: true,
            ),
          ),
        );

        await settings.insertOne(defaultSettings);
        talker.info(
          'Created Flexify database with starter plans and exercises',
        );
      },
      onUpgrade: (m, from, to) async {
        await customStatement('PRAGMA foreign_keys = OFF');
        try {
          final upgrade = stepByStep(
            from1To2: (m, schema) async {
              final legacyRows = await schema.gymSets.select().get();
              final plans = await schema.plans.select().get();
              await m.drop(schema.gymSets);
              await m.drop(schema.plans);
              await m.create(schema.gymSets);
              await m.create(schema.plans);

              await schema.gymSets.insertAll(
                legacyRows.map(
                  (legacyRow) => RawValuesInsertable({
                    'name': Variable(legacyRow.read<String>('name')),
                    'reps': Variable(legacyRow.read<double>('reps')),
                    'weight': Variable(legacyRow.read<double>('weight')),
                    'unit': Variable(legacyRow.read<String>('unit')),
                    'created': Variable(legacyRow.read<DateTime>('created')),
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
                defaultExercises.map(
                  (exercise) => RawValuesInsertable({
                    'name': Variable(exercise.$1),
                    'reps': const Variable(0.0),
                    'weight': const Variable(0.0),
                    'unit': const Variable('kg'),
                    'created': Variable(DateTime.now().toLocal()),
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
              final legacyRows =
                  await (schema.gymSets.selectOnly()
                        ..addColumns([maxSets, schema.gymSets.name])
                        ..groupBy([schema.gymSets.name]))
                      .get();

              List<Insertable<QueryRow>> pe = [];
              for (final plan in plans) {
                final exercises = plan.read<String>('exercises').split(',');

                for (final exercise in exercises) {
                  final index = legacyRows.indexWhere(
                    (legacyRow) =>
                        legacyRow.read(schema.gymSets.name) == exercise.trim(),
                  );
                  if (index == -1) continue;

                  final legacyRow = legacyRows[index];
                  pe.add(
                    RawValuesInsertable({
                      'plan_id': Variable(plan.read<int>('id')),
                      'exercise': Variable(exercise),
                      'enabled': const Variable(true),
                      'max_sets': Variable(legacyRow.read(maxSets)),
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

              final result =
                  await (schema.settings.selectOnly()..addColumns([
                        hideWeight,
                        hideTimerTab,
                        hideHistoryTab,
                      ]))
                      .getSingleOrNull();

              await m.addColumn(
                schema.settings,
                schema.settings.showBodyWeight,
              );
              await m.addColumn(schema.settings, schema.settings.showTimerTab);
              await m.addColumn(
                schema.settings,
                schema.settings.showHistoryTab,
              );

              if (result != null)
                await schema.settings.update().write(
                  RawValuesInsertable({
                    'show_body_weight': Variable(!result.read(hideWeight)!),
                    'show_timer_tab': Variable(!result.read(hideTimerTab)!),
                    'show_history_tab': Variable(!result.read(hideHistoryTab)!),
                  }),
                );

              await m.alterTable(TableMigration(schema.settings));
            },
            from24To25: (Migrator m, Schema25 schema) async {
              await m.addColumn(
                schema.settings,
                schema.settings.automaticBackups,
              );
            },
            from25To26: (Migrator m, Schema26 schema) async {
              await m.addColumn(schema.settings, schema.settings.backupPath);
            },
            from26To27: (Migrator m, Schema27 schema) async {
              var tabs = [
                'HistoryPage',
                'PlansPage',
                'GraphsPage',
                'TimerPage',
              ];
              final settings = await (schema.settings.select()..limit(1))
                  .getSingleOrNull();

              if (settings != null) {
                bool showTimer = settings.read('show_timer_tab');
                if (!showTimer) tabs.remove('TimerPage');
                bool showHistory = settings.read('show_history_tab');
                if (!showHistory) tabs.remove('HistoryPage');
              }

              await m.addColumn(schema.settings, schema.settings.tabs);
              await schema.settings.update().write(
                RawValuesInsertable({'tabs': Variable(tabs.join(','))}),
              );

              await m.alterTable(TableMigration(schema.settings));
            },
            from27To28: (Migrator m, Schema28 schema) async {
              await m.addColumn(schema.settings, schema.settings.enableSound);
            },
            from28To29: (Migrator m, Schema29 schema) async {
              await m.database.customStatement(
                'DROP INDEX IF EXISTS gym_sets_name_created',
              );
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
              await m.addColumn(
                schema.planExercises,
                schema.planExercises.timers,
              );
            },
            from31To32: (Migrator m, Schema32 schema) async {
              await schema.settings.update().write(
                const RawValuesInsertable({'rep_estimation': Variable(false)}),
              );
              await schema.settings.update().write(
                const RawValuesInsertable({
                  'duration_estimation': Variable(false),
                }),
              );
            },
            from32To33: (Migrator m, Schema33 schema) async {
              await m.addColumn(schema.settings, schema.settings.peekGraph);
            },
            from33To34: (Migrator m, Schema34 schema) async {
              await m
                  .addColumn(schema.settings, schema.settings.curveSmoothness)
                  .catchError((e) {});
              await m
                  .addColumn(schema.settings, schema.settings.notifications)
                  .catchError((e) {});
            },
            from34To35: (Migrator m, Schema35 schema) async {},
            from35To36: (Migrator m, Schema36 schema) async {
              await m.addColumn(
                schema.settings,
                schema.settings.showCategories,
              );
            },
            from36To37: (Migrator m, Schema37 schema) async {
              await m.addColumn(schema.settings, schema.settings.showNotes);
            },
            from37To38: (Migrator m, Schema38 schema) async {
              await m.addColumn(schema.gymSets, schema.gymSets.notes);
            },
            from38To39: (Migrator m, Schema39 schema) async {
              await m.addColumn(
                schema.settings,
                schema.settings.showGlobalProgress,
              );
            },
            from39To40: (Migrator m, Schema40 schema) async {
              await m.createTable(schema.metadata);
            },
            from40To41: (Migrator m, Schema41 schema) async {
              await schema.settings.update().write(
                const RawValuesInsertable({
                  'strength_unit': Variable("last-entry"),
                  'cardio_unit': Variable("last-entry"),
                }),
              );
            },
            from41To42: (Migrator m, Schema42 schema) async {
              await m.alterTable(TableMigration(schema.settings));
              await schema.settings.update().write(
                const RawValuesInsertable({'rep_estimation': Variable(false)}),
              );
            },
            from42To43: (Migrator m, Schema43 schema) async {
              await m.addColumn(
                schema.settings,
                schema.settings.scrollableTabs,
              );
            },
            from43To44: (Migrator m, Schema44 schema) async {
              final plans = await (schema.plans.select()).get();
              await batch((b) {
                for (final plan in plans) {
                  final planId = plan.read<int>('id');

                  String sql;
                  sql =
                      '''
                DELETE FROM plan_exercises
                WHERE plan_id = $planId
                AND enabled = false;
                ''';

                  b.customStatement(sql);
                }
              });
            },
            from44To45: (Migrator m, Schema45 schema) async {
              await m.alterTable(TableMigration(schema.plans));
            },
            from45To46: (Migrator m, Schema46 schema) async {
              await m.addColumn(
                schema.planExercises,
                schema.planExercises.sequence,
              );
              await schema.database.customStatement('''
            UPDATE plan_exercises 
            SET sequence = (
              SELECT COUNT(*) 
              FROM plan_exercises pe2 
              WHERE pe2.plan_id = plan_exercises.plan_id 
                AND pe2.id < plan_exercises.id
            )
          ''');
            },
            from46To47: (Migrator m, Schema47 schema) async {
              await schema.database.customStatement('''
            UPDATE settings
            SET cardio_unit = 'last-entry'
            WHERE cardio_unit = 'km'
          ''');
              await schema.database.customStatement('''
            UPDATE settings
            SET strength_unit = 'last-entry'
            WHERE strength_unit = 'kg'
          ''');
            },
            from47To48: (Migrator m, Schema48 schema) async {
              final cols = await schema.database
                  .customSelect("PRAGMA table_info(settings)")
                  .get();
              final existing = cols.map((r) => r.read<String>('name')).toSet();
              if (!existing.contains('show_graph_x_axis'))
                await m.addColumn(
                  schema.settings,
                  schema.settings.showGraphXAxis,
                );
              if (!existing.contains('show_graph_limit'))
                await m.addColumn(
                  schema.settings,
                  schema.settings.showGraphLimit,
                );
            },
            from48To49: (Migrator m, Schema49 schema) async {
              final cols = await schema.database
                  .customSelect("PRAGMA table_info(settings)")
                  .get();
              final existing = cols.map((r) => r.read<String>('name')).toSet();
              if (!existing.contains('progress_position'))
                await m.addColumn(
                  schema.settings,
                  schema.settings.progressPosition,
                );
            },
            from49To50: (Migrator m, Schema50 schema) async {
              await m.addColumn(
                schema.settings,
                schema.settings.defaultGraphMetric,
              );
              await m.addColumn(
                schema.settings,
                schema.settings.defaultGraphPeriod,
              );
              await m.addColumn(
                schema.settings,
                schema.settings.defaultGraphLimit,
              );
              await m.addColumn(
                schema.settings,
                schema.settings.defaultGraphTimeBasedXAxis,
              );
            },
            from50To51: (Migrator m, Schema51 schema) async {
              await m.createTable(schema.graphPreferences);
            },
            from51To52: (Migrator m, Schema52 schema) async {
              await m.addColumn(schema.settings, schema.settings.keepScreenOn);
              await schema.settings.update().write(
                const RawValuesInsertable({'keep_screen_on': Variable(true)}),
              );
            },
            from52To53: (Migrator m, Schema53 schema) async {
              await m.addColumn(schema.settings, schema.settings.inputStyle);
            },
            from53To54: (Migrator m, Schema54 schema) async {
              final rows = await schema.database
                  .customSelect('SELECT id, tabs FROM settings')
                  .get();
              for (final row in rows) {
                final tabs = row.read<String>('tabs');
                final cleaned = tabs
                    .split(',')
                    .where((tab) => tab != 'StopwatchPage')
                    .join(',');
                if (cleaned == tabs) continue;
                await schema.database.customStatement(
                  'UPDATE settings SET tabs = ? WHERE id = ?',
                  [
                    cleaned.isEmpty ? 'HistoryPage' : cleaned,
                    row.read<int>('id'),
                  ],
                );
              }
            },
            from54To55: (Migrator m, Schema55 schema) async {
              await m.database.customStatement(
                'DROP INDEX IF EXISTS gym_sets_name',
              );
              await m.database.customStatement(
                'DROP INDEX IF EXISTS gym_sets_hidden',
              );
              await m.createIndex(
                Index(
                  'gym_sets',
                  'CREATE INDEX IF NOT EXISTS gym_sets_name_hidden_created ON gym_sets(name, hidden, created)',
                ),
              );
            },
            from55To56: (Migrator m, Schema56 schema) async {
              await m.addColumn(
                schema.settings,
                schema.settings.notificationPermissionRequested,
              );
            },
            from56To57: (Migrator m, Schema57 schema) async {
              await m.addColumn(
                schema.settings,
                schema.settings.localeOverride,
              );
            },
            from57To58: (Migrator m, Schema58 schema) async {
              await m.createTable(schema.categories);
              await m.database.customStatement('''
            INSERT OR IGNORE INTO categories (name)
            SELECT DISTINCT category FROM gym_sets
            WHERE category IS NOT NULL AND TRIM(category) != ''
          ''');
            },
            from58To59: (Migrator m, Schema59 schema) async {
              await m.createTable(schema.exercises);
              await m.createTable(schema.workouts);
              await m.createTable(schema.exerciseSets);
              await m.createTable(schema.bodyWeights);
              await m.addColumn(
                schema.planExercises,
                schema.planExercises.exerciseId,
              );
            },
            from59To60: (Migrator m, Schema60 schema) async {
              await _backfillExerciseIdentity(this);
            },
            from60To61: (Migrator m, Schema61 schema) async {
              await _backfillExerciseIdentity(this);
              await _backfillExerciseHistory(this);
            },
            from61To62: (Migrator m, Schema62 schema) async {
              await m.alterTable(TableMigration(schema.planExercises));
            },
            from62To63: (m, schema) async {
              await m.addColumn(schema.settings, schema.settings.buildNumber);
              await customStatement('''
            UPDATE settings
            SET build_number = (
              SELECT build_number
              FROM metadata
              LIMIT 1
            )
            WHERE build_number IS NULL
          ''');

              await _removeOrphanedPlanExercises(this);
              await m.alterTable(TableMigration(schema.planExercises));

              await customStatement(
                'DROP INDEX IF EXISTS gym_sets_name_hidden_created',
              );
              await customStatement('DROP INDEX IF EXISTS gym_sets_created');
              await customStatement('DROP INDEX IF EXISTS gym_sets_plan_id');
              await customStatement('DROP INDEX IF EXISTS gym_sets_name');
              await customStatement('DROP INDEX IF EXISTS gym_sets_hidden');
              await customStatement('DROP TABLE IF EXISTS graph_preferences');
              await customStatement('DROP TABLE IF EXISTS gym_sets');
              await customStatement('DROP TABLE IF EXISTS metadata');
            },
            from63To64: (m, schema) async {
              await m.createIndex(schema.exerciseSetsTimestamp);
            },
            from64To65: (m, schema) async {
              await customStatement('''
                WITH ranked AS (
                  SELECT
                    id,
                    ROW_NUMBER() OVER (
                      PARTITION BY plan_id, exercise_id
                      ORDER BY enabled DESC, sequence ASC, id ASC
                    ) AS duplicate_rank
                  FROM plan_exercises
                )
                UPDATE plan_exercises
                SET
                  enabled = (
                    SELECT MAX(other.enabled)
                    FROM plan_exercises AS other
                    WHERE other.plan_id = plan_exercises.plan_id
                      AND other.exercise_id = plan_exercises.exercise_id
                  ),
                  max_sets = COALESCE(
                    plan_exercises.max_sets,
                    (
                      SELECT other.max_sets
                      FROM plan_exercises AS other
                      WHERE other.plan_id = plan_exercises.plan_id
                        AND other.exercise_id = plan_exercises.exercise_id
                        AND other.max_sets IS NOT NULL
                      ORDER BY
                        other.enabled DESC,
                        other.sequence ASC,
                        other.id ASC
                      LIMIT 1
                    )
                  ),
                  warmup_sets = COALESCE(
                    plan_exercises.warmup_sets,
                    (
                      SELECT other.warmup_sets
                      FROM plan_exercises AS other
                      WHERE other.plan_id = plan_exercises.plan_id
                        AND other.exercise_id = plan_exercises.exercise_id
                        AND other.warmup_sets IS NOT NULL
                      ORDER BY
                        other.enabled DESC,
                        other.sequence ASC,
                        other.id ASC
                      LIMIT 1
                    )
                  ),
                  sequence = (
                    SELECT MIN(other.sequence)
                    FROM plan_exercises AS other
                    WHERE other.plan_id = plan_exercises.plan_id
                      AND other.exercise_id = plan_exercises.exercise_id
                  )
                WHERE id IN (
                  SELECT id
                  FROM ranked
                  WHERE duplicate_rank = 1
                )
              ''');

              await customStatement('''
                WITH ranked AS (
                  SELECT
                    id,
                    ROW_NUMBER() OVER (
                      PARTITION BY plan_id, exercise_id
                      ORDER BY enabled DESC, sequence ASC, id ASC
                    ) AS duplicate_rank
                  FROM plan_exercises
                )
                DELETE FROM plan_exercises
                WHERE id IN (
                  SELECT id
                  FROM ranked
                  WHERE duplicate_rank > 1
                )
              ''');

              await customStatement('''
                WITH ranked AS (
                  SELECT
                    id,
                    started_at,
                    ROW_NUMBER() OVER (
                      PARTITION BY plan_id
                      ORDER BY started_at DESC, id DESC
                    ) AS active_rank,
                    MAX(started_at) OVER (
                      PARTITION BY plan_id
                    ) AS latest_started_at
                  FROM workouts
                  WHERE plan_id IS NOT NULL
                    AND ended_at IS NULL
                )
                UPDATE workouts
                SET ended_at = (
                  SELECT
                    CASE
                      WHEN latest_started_at > started_at
                      THEN latest_started_at
                      ELSE started_at
                    END
                  FROM ranked
                  WHERE ranked.id = workouts.id
                )
                WHERE id IN (
                  SELECT id
                  FROM ranked
                  WHERE active_rank > 1
                )
              ''');

              await customStatement(
                'DROP INDEX IF EXISTS exercise_sets_exercise_timestamp',
              );
              await customStatement(
                'DROP INDEX IF EXISTS exercise_sets_workout_exercise',
              );
              await customStatement(
                'DROP INDEX IF EXISTS workouts_plan_ended_started',
              );
              await customStatement(
                'DROP INDEX IF EXISTS body_weights_timestamp',
              );
              await customStatement(
                'DROP INDEX IF EXISTS plan_exercises_plan_id',
              );

              await m.createIndex(schema.exercisesCategoryId);
              await m.createIndex(schema.exerciseSetsExerciseTimestamp);
              await m.createIndex(schema.exerciseSetsWorkoutExercise);
              await m.createIndex(schema.workoutsPlanEndedStarted);
              await m.createIndex(schema.workoutsActivePlan);
              await m.createIndex(schema.bodyWeightsTimestamp);
              await m.createIndex(schema.planExercisesPlanExercise);
              await m.createIndex(schema.planExercisesExerciseId);
            },
            from65To66: (m, schema) async {
              await m.addColumn(schema.settings, schema.settings.keepRinging);
            },
            from66To67: (m, schema) async {},
            from67To68: (m, schema) async {},
            from68To69: (Migrator m, Schema69 schema) async {
              await m.alterTable(TableMigration(schema.settings));
              await customStatement(
                'UPDATE settings SET default_graph_limit = 30 WHERE default_graph_limit = 20',
              );
            },
          );
          await transaction(() async {
            await upgrade(m, from, to);

            if (to == schemaVersion) {
              final foreignKeyViolations = await customSelect(
                'PRAGMA foreign_key_check',
              ).get();
              if (foreignKeyViolations.isNotEmpty) {
                throw StateError('Foreign key violations after migration');
              }
            }
          });
        } finally {
          await customStatement('PRAGMA foreign_keys = ON');
        }
      },
    );
  }

  @override
  int get schemaVersion => 69;
}
