import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flexify/database/database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v15.dart' as v15;
import 'generated/schema_v16.dart' as v16;
import 'generated/schema_v17.dart' as v17;
import 'generated/schema_v18.dart' as v18;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;
import 'generated/schema_v4.dart' as v4;
import 'generated/schema_v47.dart' as v47;
import 'generated/schema_v5.dart' as v5;
import 'generated/schema_v53.dart' as v53;
import 'generated/schema_v59.dart' as v59;
import 'generated/schema_v60.dart' as v60;
import 'generated/schema_v62.dart' as v62;
import 'generated/schema_v64.dart' as v64;
import 'generated/schema_v65.dart' as v65;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test('migration from v1 to v2 does not corrupt data', () async {
    final testDate = DateTime(2024, 1, 1);

    final oldPlansData = <v1.PlansData>[
      v1.PlansData(
        workouts: 'Push-ups,Squats,Pull-ups',
        days: 'Monday,Wednesday,Friday',
      ),
    ];
    final expectedNewPlansData = <v2.PlansData>[
      v2.PlansData(
        id: 1,
        exercises: 'Push-ups,Squats,Pull-ups',
        days: 'Monday,Wednesday,Friday',
      ),
    ];

    final oldGymSetsData = <v1.GymSetsData>[
      v1.GymSetsData(
        name: 'Push-ups',
        reps: 10,
        weight: 0,
        unit: 'kg',
        created: testDate,
      ),
    ];
    final expectedNewGymSetsData = <v2.GymSetsData>[
      v2.GymSetsData(
        id: 1,
        name: 'Push-ups',
        reps: 10.0,
        weight: 0.0,
        unit: 'kg',
        created: testDate,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.plans, oldPlansData);
        batch.insertAll(oldDb.gymSets, oldGymSetsData);
      },
      validateItems: (newDb) async {
        expect(expectedNewPlansData, await newDb.select(newDb.plans).get());
        expect(expectedNewGymSetsData, await newDb.select(newDb.gymSets).get());
      },
    );
  });

  test('migration from v2 to v3 adds sequence column', () async {
    final testDate = DateTime(2024, 1, 1);

    final oldPlansData = <v2.PlansData>[
      v2.PlansData(
        id: 1,
        exercises: 'Push-ups,Squats',
        days: 'Monday,Wednesday',
      ),
    ];
    final expectedNewPlansData = <v3.PlansData>[
      v3.PlansData(
        id: 1,
        sequence: null,
        exercises: 'Push-ups,Squats',
        days: 'Monday,Wednesday',
      ),
    ];

    final oldGymSetsData = <v2.GymSetsData>[
      v2.GymSetsData(
        id: 1,
        name: 'Push-ups',
        reps: 15.0,
        weight: 0.0,
        unit: 'kg',
        created: testDate,
      ),
    ];
    final expectedNewGymSetsData = <v3.GymSetsData>[
      v3.GymSetsData(
        id: 1,
        name: 'Push-ups',
        reps: 15.0,
        weight: 0.0,
        unit: 'kg',
        created: testDate,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 2,
      newVersion: 3,
      createOld: v2.DatabaseAtV2.new,
      createNew: v3.DatabaseAtV3.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.plans, oldPlansData);
        batch.insertAll(oldDb.gymSets, oldGymSetsData);
      },
      validateItems: (newDb) async {
        expect(expectedNewPlansData, await newDb.select(newDb.plans).get());
        expect(expectedNewGymSetsData, await newDb.select(newDb.gymSets).get());
      },
    );
  });

  test('migration from v3 to v4 adds title column', () async {
    final oldPlansData = <v3.PlansData>[
      v3.PlansData(
        id: 1,
        sequence: 1,
        exercises: 'Bench Press,Squats',
        days: 'Monday,Friday',
      ),
    ];
    final expectedNewPlansData = <v4.PlansData>[
      v4.PlansData(
        id: 1,
        sequence: 1,
        exercises: 'Bench Press,Squats',
        days: 'Monday,Friday',
        title: null,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 3,
      newVersion: 4,
      createOld: v3.DatabaseAtV3.new,
      createNew: v4.DatabaseAtV4.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.plans, oldPlansData);
      },
      validateItems: (newDb) async {
        expect(expectedNewPlansData, await newDb.select(newDb.plans).get());
      },
    );
  });

  test('migration from v4 to v5 adds hidden column to gym sets', () async {
    final testDate = DateTime(2024, 1, 1);

    final oldGymSetsData = <v4.GymSetsData>[
      v4.GymSetsData(
        id: 1,
        name: 'Deadlift',
        reps: 5.0,
        weight: 100.0,
        unit: 'kg',
        created: testDate,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 4,
      newVersion: 5,
      createOld: v4.DatabaseAtV4.new,
      createNew: v5.DatabaseAtV5.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.gymSets, oldGymSetsData);
      },
      validateItems: (newDb) async {
        final gymSets = await newDb.select(newDb.gymSets).get();
        final userSet = gymSets.firstWhere(
          (set) => set.name == 'Deadlift' && set.reps == 5.0,
        );
        expect(userSet.hidden, false);
        expect(userSet.weight, 100.0);
        expect(userSet.created, testDate);
      },
    );
  });

  test(
    'migration from v5 to v15 preserves data through multiple schema changes',
    () async {
      final testDate = DateTime(2024, 1, 1);

      final oldPlansData = <v5.PlansData>[
        v5.PlansData(
          id: 1,
          sequence: 1,
          exercises: 'Overhead Press,Rows',
          days: 'Monday,Thursday',
          title: 'Upper Body Strength',
        ),
      ];

      final oldGymSetsData = <v5.GymSetsData>[
        v5.GymSetsData(
          id: 1,
          name: 'Overhead Press',
          reps: 6.0,
          weight: 50.0,
          unit: 'kg',
          created: testDate,
          hidden: false,
        ),
        v5.GymSetsData(
          id: 2,
          name: 'Rows',
          reps: 8.0,
          weight: 60.0,
          unit: 'kg',
          created: testDate,
          hidden: true,
        ),
      ];

      await verifier.testWithDataIntegrity(
        oldVersion: 5,
        newVersion: 15,
        createOld: v5.DatabaseAtV5.new,
        createNew: v15.DatabaseAtV15.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, oldDb) {
          batch.insertAll(oldDb.plans, oldPlansData);
          batch.insertAll(oldDb.gymSets, oldGymSetsData);
        },
        validateItems: (newDb) async {
          final plans = await newDb.select(newDb.plans).get();
          expect(plans.length, 1);
          expect(plans.first.title, 'Upper Body Strength');
          expect(plans.first.exercises, 'Overhead Press,Rows');
          expect(plans.first.sequence, 1);

          final gymSets = await newDb.select(newDb.gymSets).get();
          expect(gymSets.length, 2);

          final overheadPress = gymSets.firstWhere(
            (set) => set.name == 'Overhead Press',
          );
          expect(overheadPress.weight, 50.0);
          expect(overheadPress.hidden, false);
          expect(overheadPress.bodyWeight, 0.0); // Added in v6
          expect(overheadPress.cardio, false); // Added in v8

          final rows = gymSets.firstWhere((set) => set.name == 'Rows');
          expect(rows.weight, 60.0);
          expect(rows.hidden, true);
          expect(rows.bodyWeight, 0.0);
          expect(rows.cardio, false);
        },
      );
    },
  );

  test('migration from v15 to v16 adds settings table', () async {
    final oldPlansData = <v15.PlansData>[
      v15.PlansData(
        id: 1,
        sequence: 1,
        exercises: 'Pull-ups,Dips',
        days: 'Tuesday,Thursday',
        title: 'Upper Body',
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 15,
      newVersion: 16,
      createOld: v15.DatabaseAtV15.new,
      createNew: v16.DatabaseAtV16.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.plans, oldPlansData);
      },
      validateItems: (newDb) async {
        final plans = await newDb.select(newDb.plans).get();
        expect(plans.length, 1);
        expect(plans.first.title, 'Upper Body');

        final settings = await newDb.select(newDb.settings).get();
        expect(settings.length, 1);
        expect(settings.first.themeMode, 'ThemeMode.system');
        expect(settings.first.vibrate, true);
      },
    );
  });

  test('migration from v16 to v17 adds planId to gym sets', () async {
    final testDate = DateTime(2024, 1, 1);

    final oldGymSetsData = <v16.GymSetsData>[
      v16.GymSetsData(
        id: 1,
        name: 'Squats',
        reps: 12.0,
        weight: 80.0,
        unit: 'kg',
        created: testDate,
        hidden: false,
        bodyWeight: 0.0,
        duration: 0.0,
        distance: 0.0,
        cardio: false,
        restMs: null,
        maxSets: null,
        incline: null,
      ),
    ];
    final expectedNewGymSetsData = <v17.GymSetsData>[
      v17.GymSetsData(
        id: 1,
        name: 'Squats',
        reps: 12.0,
        weight: 80.0,
        unit: 'kg',
        created: testDate,
        hidden: false,
        bodyWeight: 0.0,
        duration: 0.0,
        distance: 0.0,
        cardio: false,
        restMs: null,
        maxSets: null,
        incline: null,
        planId: null,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 16,
      newVersion: 17,
      createOld: v16.DatabaseAtV16.new,
      createNew: v17.DatabaseAtV17.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.gymSets, oldGymSetsData);
      },
      validateItems: (newDb) async {
        expect(expectedNewGymSetsData, await newDb.select(newDb.gymSets).get());
      },
    );
  });

  test('migration from v17 to v18 adds plan exercises table', () async {
    final testDate = DateTime(2024, 1, 1);

    final oldPlansData = <v17.PlansData>[
      v17.PlansData(
        id: 1,
        sequence: 1,
        exercises: 'Bench Press,Squats',
        days: 'Monday,Wednesday',
        title: 'Strength Training',
      ),
    ];

    final oldGymSetsData = <v17.GymSetsData>[
      v17.GymSetsData(
        id: 1,
        name: 'Bench Press',
        reps: 8.0,
        weight: 70.0,
        unit: 'kg',
        created: testDate,
        hidden: false,
        bodyWeight: 0.0,
        duration: 0.0,
        distance: 0.0,
        cardio: false,
        restMs: null,
        maxSets: 3,
        incline: null,
        planId: null,
      ),
      v17.GymSetsData(
        id: 2,
        name: 'Squats',
        reps: 10.0,
        weight: 90.0,
        unit: 'kg',
        created: testDate,
        hidden: false,
        bodyWeight: 0.0,
        duration: 0.0,
        distance: 0.0,
        cardio: false,
        restMs: null,
        maxSets: 4,
        incline: null,
        planId: null,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 17,
      newVersion: 18,
      createOld: v17.DatabaseAtV17.new,
      createNew: v18.DatabaseAtV18.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.plans, oldPlansData);
        batch.insertAll(oldDb.gymSets, oldGymSetsData);
      },
      validateItems: (newDb) async {
        final plans = await newDb.select(newDb.plans).get();
        expect(plans.length, 1);

        final planExercises = await newDb.select(newDb.planExercises).get();
        expect(planExercises.length, 2);
        expect(planExercises[0].exercise, 'Bench Press');
        expect(planExercises[0].maxSets, 3);
        expect(planExercises[1].exercise, 'Squats');
        expect(planExercises[1].maxSets, 4);
      },
    );
  });

  test('migration from v18 to current version preserves all data', () async {
    final testDate = DateTime(2024, 1, 1);

    final oldPlansData = <v18.PlansData>[
      v18.PlansData(
        id: 1,
        sequence: 1,
        exercises: 'Deadlift,Romanian Deadlift',
        days: 'Tuesday,Friday',
        title: 'Deadlift Day',
      ),
    ];

    final oldGymSetsData = <v18.GymSetsData>[
      v18.GymSetsData(
        id: 1,
        name: 'Deadlift',
        reps: 5.0,
        weight: 120.0,
        unit: 'kg',
        created: testDate,
        hidden: false,
        bodyWeight: 75.0,
        duration: 0.0,
        distance: 0.0,
        cardio: false,
        restMs: 180000, // 3 minutes
        incline: null,
        planId: 1,
      ),
      v18.GymSetsData(
        id: 2,
        name: 'Romanian Deadlift',
        reps: 8.0,
        weight: 80.0,
        unit: 'kg',
        created: testDate,
        hidden: false,
        bodyWeight: 75.0,
        duration: 0.0,
        distance: 0.0,
        cardio: false,
        restMs: 120000, // 2 minutes
        incline: null,
        planId: 1,
      ),
    ];

    final oldPlanExercisesData = <v18.PlanExercisesData>[
      v18.PlanExercisesData(
        id: 1,
        planId: 1,
        exercise: 'Deadlift',
        enabled: true,
        maxSets: 3,
      ),
      v18.PlanExercisesData(
        id: 2,
        planId: 1,
        exercise: 'Romanian Deadlift',
        enabled: true,
        maxSets: 4,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 18,
      newVersion: 41,
      createOld: v18.DatabaseAtV18.new,
      createNew: AppDatabase.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.plans, oldPlansData);
        batch.insertAll(oldDb.gymSets, oldGymSetsData);
        batch.insertAll(oldDb.planExercises, oldPlanExercisesData);
      },
      validateItems: (newDb) async {
        final plans = await newDb.select(newDb.plans).get();
        expect(plans.length, 1);
        expect(plans.first.title, 'Deadlift Day');
        expect(plans.first.sequence, 1);

        final exercises = await newDb.select(newDb.exercises).get();
        final exerciseByName = {
          for (final exercise in exercises) exercise.name: exercise,
        };
        expect(
          exerciseByName.keys,
          containsAll(<String>['Deadlift', 'Romanian Deadlift']),
        );
        expect(exerciseByName['Deadlift']!.defaultRestDurationMs, 180000);
        expect(
          exerciseByName['Romanian Deadlift']!.defaultRestDurationMs,
          120000,
        );

        final exerciseSets = await newDb.select(newDb.exerciseSets).get();
        expect(exerciseSets, hasLength(2));
        final deadlift = exerciseSets.singleWhere(
          (set) => set.exerciseId == exerciseByName['Deadlift']!.id,
        );
        expect(deadlift.loadKg, 120.0);
        expect(deadlift.reps, 5.0);
        expect(deadlift.bodyWeightKg, 75.0);

        final romanianDeadlift = exerciseSets.singleWhere(
          (set) => set.exerciseId == exerciseByName['Romanian Deadlift']!.id,
        );
        expect(romanianDeadlift.loadKg, 80.0);
        expect(romanianDeadlift.reps, 8.0);

        final planExercises = await newDb.select(newDb.planExercises).get();
        expect(planExercises, hasLength(2));
        expect(
          planExercises.any(
            (row) =>
                row.exerciseId == exerciseByName['Deadlift']!.id &&
                row.maxSets == 3,
          ),
          isTrue,
        );
        expect(
          planExercises.any(
            (row) =>
                row.exerciseId == exerciseByName['Romanian Deadlift']!.id &&
                row.maxSets == 4,
          ),
          isTrue,
        );

        // Verify settings table exists (added in v16)
        final settings = await newDb.select(newDb.settings).get();
        expect(settings.length, 0);
      },
    );
  });

  test('migration from v53 to v54 removes StopwatchPage from tabs', () async {
    final oldSettingsData = <v53.SettingsCompanion>[
      v53.SettingsCompanion.insert(
        alarmSound: '',
        cardioUnit: 'last-entry',
        curveLines: 1,
        explainedPermissions: 0,
        groupHistory: 0,
        longDateFormat: 'timeago',
        maxSets: 3,
        planTrailing: 'PlanTrailing.reorder',
        restTimers: 0,
        shortDateFormat: 'd/M/yy',
        showUnits: 1,
        strengthUnit: 'last-entry',
        systemColors: 0,
        tabs: const Value(
          'HistoryPage,PlansPage,GraphsPage,TimerPage,StopwatchPage',
        ),
        themeMode: 'ThemeMode.system',
        timerDuration: 210000,
        vibrate: 1,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 53,
      newVersion: 54,
      createOld: v53.DatabaseAtV53.new,
      createNew: AppDatabase.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.settings, oldSettingsData);
      },
      validateItems: (newDb) async {
        final settings = await newDb.select(newDb.settings).get();
        expect(settings.length, 1);
        expect(
          settings.first.tabs,
          'HistoryPage,PlansPage,GraphsPage,TimerPage',
        );
      },
    );
  });

  test('migration from v47 to v48 adds showGraphXAxis and showGraphLimit '
      'without duplicate column errors', () async {
    final oldSettingsData = <v47.SettingsCompanion>[
      v47.SettingsCompanion.insert(
        alarmSound: '',
        cardioUnit: 'last-entry',
        curveLines: 1,
        explainedPermissions: 0,
        groupHistory: 0,
        longDateFormat: 'timeago',
        maxSets: 3,
        planTrailing: 'PlanTrailing.reorder',
        restTimers: 0,
        shortDateFormat: 'd/M/yy',
        showUnits: 1,
        strengthUnit: 'last-entry',
        systemColors: 0,
        themeMode: 'ThemeMode.system',
        timerDuration: 210000,
        vibrate: 1,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 47,
      newVersion: 48,
      createOld: v47.DatabaseAtV47.new,
      createNew: AppDatabase.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.settings, oldSettingsData);
      },
      validateItems: (newDb) async {
        final settings = await newDb.select(newDb.settings).get();
        expect(settings.length, 1);
        expect(settings.first.showGraphXAxis, false);
        expect(settings.first.showGraphLimit, true);
      },
    );
  });
  test('migration from v59 through v61 backfills identity and history', () async {
    final oldCategories = <v59.CategoriesCompanion>[
      v59.CategoriesCompanion.insert(id: const Value(10), name: 'Chest & Arms'),
      v59.CategoriesCompanion.insert(id: const Value(20), name: 'Conditioning'),
    ];
    final oldPlans = <v59.PlansCompanion>[
      v59.PlansCompanion.insert(
        id: const Value(1),
        days: 'Monday',
        title: const Value('Migration Plan'),
      ),
    ];
    final oldGymSets = <v59.GymSetsCompanion>[
      v59.GymSetsCompanion.insert(
        id: const Value(1),
        created: 100,
        name: 'Bench Press',
        reps: 8,
        unit: 'lb',
        weight: 100,
        category: const Value('Chest & Arms'),
        image: const Value('old-history.png'),
        notes: const Value('ordinary set note'),
        restMs: const Value(60000),
      ),
      v59.GymSetsCompanion.insert(
        id: const Value(2),
        created: 200,
        name: 'Bench Press',
        reps: 6,
        unit: 'kg',
        weight: 80,
        category: const Value('Chest & Arms'),
        image: const Value('latest-history.png'),
        notes: const Value('latest set note'),
        restMs: const Value(90000),
      ),
      v59.GymSetsCompanion.insert(
        id: const Value(3),
        created: 50,
        name: 'Bench Press',
        reps: 0,
        unit: 'kg',
        weight: 0,
        category: const Value('Chest & Arms'),
        hidden: const Value(1),
        image: const Value('template.png'),
        notes: const Value('template note'),
        restMs: const Value(120000),
      ),
      v59.GymSetsCompanion.insert(
        id: const Value(4),
        cardio: const Value(1),
        created: 250,
        name: 'Rowing',
        reps: 0,
        unit: 'km',
        weight: 0,
        category: const Value('Conditioning'),
        image: const Value('old-rowing.png'),
        notes: const Value('old rowing set note'),
        restMs: const Value(30000),
      ),
      v59.GymSetsCompanion.insert(
        id: const Value(5),
        cardio: const Value(1),
        created: 300,
        name: 'Rowing',
        reps: 0,
        unit: 'mi',
        weight: 0,
        category: const Value('Conditioning'),
        image: const Value('latest-rowing.png'),
        notes: const Value('latest rowing set note'),
        restMs: const Value(45000),
      ),
      v59.GymSetsCompanion.insert(
        id: const Value(6),
        created: 400,
        name: 'Weight',
        reps: 1,
        unit: 'kg',
        weight: 75,
      ),
    ];
    final oldGraphPreferences = <v59.GraphPreferencesCompanion>[
      v59.GraphPreferencesCompanion.insert(
        name: 'Bench Press',
        metric: const Value('volume'),
        period: const Value('week'),
        limit: const Value(7),
        timeBasedXAxis: const Value(1),
        notes: const Value('exercise-level note'),
      ),
      v59.GraphPreferencesCompanion.insert(
        name: 'Preference Only',
        metric: const Value('bestReps'),
      ),
    ];
    final oldPlanExercises = <v59.PlanExercisesCompanion>[
      v59.PlanExercisesCompanion.insert(
        id: const Value(1),
        enabled: 1,
        exercise: 'Bench Press',
        planId: 1,
      ),
      v59.PlanExercisesCompanion.insert(
        id: const Value(2),
        enabled: 1,
        exercise: 'Rowing',
        planId: 1,
      ),
      v59.PlanExercisesCompanion.insert(
        id: const Value(3),
        enabled: 1,
        exercise: 'Weight',
        planId: 1,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 59,
      newVersion: 61,
      createOld: v59.DatabaseAtV59.new,
      createNew: AppDatabase.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.categories, oldCategories);
        batch.insertAll(oldDb.plans, oldPlans);
        batch.insertAll(oldDb.gymSets, oldGymSets);
        batch.insertAll(oldDb.graphPreferences, oldGraphPreferences);
        batch.insertAll(oldDb.planExercises, oldPlanExercises);
      },
      validateItems: (newDb) async {
        final exercises = await newDb.select(newDb.exercises).get();
        expect(exercises, hasLength(2));

        final bench = exercises.singleWhere(
          (exercise) => exercise.name == 'Bench Press',
        );
        expect(bench.kind, 'strength');
        expect(bench.displayUnit, 'kg');
        expect(bench.categoryId, 10);
        expect(bench.image, 'template.png');
        expect(bench.defaultRestDurationMs, 120000);
        expect(bench.notes, 'exercise-level note');
        expect(bench.graphMetric, 'volume');
        expect(bench.graphPeriod, 'week');
        expect(bench.graphLimit, 7);
        expect(bench.graphTimeBasedXAxis, isTrue);

        final rowing = exercises.singleWhere(
          (exercise) => exercise.name == 'Rowing',
        );
        expect(rowing.kind, 'cardio');
        expect(rowing.displayUnit, 'mi');
        expect(rowing.categoryId, 20);
        expect(rowing.image, 'latest-rowing.png');
        expect(rowing.defaultRestDurationMs, 45000);
        expect(rowing.notes, null);
        expect(rowing.graphMetric, 'bestWeight');
        expect(rowing.graphPeriod, 'day');
        expect(rowing.graphLimit, 20);
        expect(rowing.graphTimeBasedXAxis, isFalse);

        expect(
          exercises.where((exercise) => exercise.name == 'Weight'),
          isEmpty,
        );
        expect(
          exercises.where((exercise) => exercise.name == 'Preference Only'),
          isEmpty,
        );

        final planExercises = await newDb
            .customSelect('SELECT * FROM plan_exercises')
            .get();
        expect(
          planExercises.map((row) => row.read<int>('exercise_id')),
          containsAll(<int>[bench.id, rowing.id]),
        );
        expect(planExercises, hasLength(2));

        expect(
          await newDb
              .customSelect(
                "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'gym_sets'",
              )
              .get(),
          isEmpty,
        );
        expect(await newDb.select(newDb.exerciseSets).get(), hasLength(4));
        final migratedBodyWeights = await newDb.select(newDb.bodyWeights).get();
        expect(migratedBodyWeights, hasLength(1));
        expect(migratedBodyWeights.single.weightKg, 75);
        expect(await newDb.select(newDb.workouts).get(), isEmpty);
      },
    );
  });

  test(
    'migration from v60 to v61 backfills canonical history exactly once',
    () async {
      const dayOne = 1704888000;
      const dayTwo = dayOne + 108000;

      final oldPlans = <v60.PlansCompanion>[
        v60.PlansCompanion.insert(
          id: const Value(1),
          days: 'Monday',
          title: const Value('Plan One'),
        ),
        v60.PlansCompanion.insert(
          id: const Value(2),
          days: 'Tuesday',
          title: const Value('Plan Two'),
        ),
      ];
      final oldGymSets = <v60.GymSetsCompanion>[
        v60.GymSetsCompanion.insert(
          id: const Value(1),
          created: dayOne - 3600,
          name: 'Weight',
          reps: 1,
          unit: 'lb',
          weight: 180,
          image: const Value('weight-lb.jpg'),
        ),
        v60.GymSetsCompanion.insert(
          id: const Value(2),
          bodyWeight: const Value(180),
          created: dayOne,
          incline: const Value(2),
          name: 'Bench Press',
          notes: const Value('heavy'),
          planId: const Value(1),
          reps: 5,
          unit: 'lb',
          weight: 220,
        ),
        v60.GymSetsCompanion.insert(
          id: const Value(3),
          bodyWeight: const Value(180),
          cardio: const Value(1),
          created: dayOne + 300,
          distance: const Value(1.5),
          duration: const Value(12.5),
          name: 'Run',
          planId: const Value(1),
          reps: 0,
          unit: 'mi',
          weight: 0,
        ),
        v60.GymSetsCompanion.insert(
          id: const Value(4),
          bodyWeight: const Value(180),
          created: dayOne + 600,
          name: 'Squat',
          planId: const Value(2),
          reps: 8,
          unit: 'kg',
          weight: 100,
        ),
        v60.GymSetsCompanion.insert(
          id: const Value(5),
          bodyWeight: const Value(80),
          created: dayTwo,
          name: 'Bench Press',
          planId: const Value(1),
          reps: 3,
          unit: 'kg',
          weight: 105,
        ),
        v60.GymSetsCompanion.insert(
          id: const Value(6),
          bodyWeight: const Value(180),
          created: dayOne + 900,
          name: 'Curl',
          notes: const Value('standalone'),
          reps: 10,
          unit: 'kg',
          weight: 20,
        ),
        v60.GymSetsCompanion.insert(
          id: const Value(7),
          created: dayOne + 1200,
          hidden: const Value(1),
          name: 'Bench Press',
          planId: const Value(1),
          reps: 0,
          unit: 'kg',
          weight: 0,
        ),
        v60.GymSetsCompanion.insert(
          id: const Value(8),
          created: dayTwo - 3600,
          name: 'Weight',
          reps: 1,
          unit: 'kg',
          weight: 80,
          image: const Value('weight-kg.jpg'),
        ),
        v60.GymSetsCompanion.insert(
          id: const Value(9),
          created: dayTwo - 1800,
          hidden: const Value(1),
          name: 'Weight',
          reps: 1,
          unit: 'stone',
          weight: 12,
          image: const Value('hidden-weight.jpg'),
        ),
        v60.GymSetsCompanion.insert(
          id: const Value(10),
          bodyWeight: const Value(180),
          created: dayOne + 1500,
          name: 'Orphan Plan Exercise',
          planId: const Value(999),
          reps: 12,
          unit: 'stone',
          weight: 10,
        ),
      ];

      await verifier.testWithDataIntegrity(
        oldVersion: 60,
        newVersion: 61,
        createOld: v60.DatabaseAtV60.new,
        createNew: AppDatabase.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, oldDb) {
          batch.insertAll(oldDb.plans, oldPlans);
          batch.insertAll(oldDb.gymSets, oldGymSets);
        },
        validateItems: (newDb) async {
          final exercises = await newDb.select(newDb.exercises).get();
          final exercisesById = {
            for (final exercise in exercises) exercise.id: exercise,
          };
          final migratedSets = await newDb.select(newDb.exerciseSets).get();
          final bodyWeights = await newDb.select(newDb.bodyWeights).get();
          final workouts = await newDb.select(newDb.workouts).get();

          expect(migratedSets, hasLength(6));
          expect(bodyWeights, hasLength(2));
          expect(
            await newDb
                .customSelect(
                  "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'gym_sets'",
                )
                .get(),
            isEmpty,
          );
          expect(
            migratedSets
                .map((set) => exercisesById[set.exerciseId]!.name)
                .where((name) => name == 'Weight'),
            isEmpty,
          );

          final benchLb = migratedSets.singleWhere(
            (set) =>
                exercisesById[set.exerciseId]!.name == 'Bench Press' &&
                set.timestamp.millisecondsSinceEpoch ~/ 1000 == dayOne,
          );
          expect(benchLb.reps, 5);
          expect(benchLb.loadKg, closeTo(99.7903214, 0.000001));
          expect(benchLb.bodyWeightKg, closeTo(81.6466266, 0.000001));
          expect(benchLb.durationMs, 0);
          expect(benchLb.incline, 2);
          expect(benchLb.notes, 'heavy');
          expect(benchLb.workoutId, 2);

          final run = migratedSets.singleWhere(
            (set) => exercisesById[set.exerciseId]!.name == 'Run',
          );
          expect(run.loadKg, null);
          expect(run.distanceMetres, closeTo(2414.016, 0.000001));
          expect(run.durationMs, 750000);
          expect(run.bodyWeightKg, closeTo(81.6466266, 0.000001));
          expect(run.workoutId, 2);

          final benchKg = migratedSets.singleWhere(
            (set) =>
                exercisesById[set.exerciseId]!.name == 'Bench Press' &&
                set.timestamp.millisecondsSinceEpoch ~/ 1000 == dayTwo,
          );
          expect(benchKg.loadKg, 105);
          expect(benchKg.bodyWeightKg, 80);
          expect(benchKg.workoutId, 5);

          final standalone = migratedSets.singleWhere(
            (set) => exercisesById[set.exerciseId]!.name == 'Curl',
          );
          expect(standalone.workoutId, null);
          expect(standalone.notes, 'standalone');

          final orphan = migratedSets.singleWhere(
            (set) =>
                exercisesById[set.exerciseId]!.name == 'Orphan Plan Exercise',
          );
          expect(orphan.loadKg, closeTo(63.5029318, 0.000001));
          expect(orphan.workoutId, 10);

          expect(workouts, hasLength(4));
          final planOneDayOne = workouts.singleWhere(
            (workout) => workout.id == 2,
          );
          expect(planOneDayOne.planId, 1);
          expect(
            planOneDayOne.startedAt.millisecondsSinceEpoch ~/ 1000,
            dayOne,
          );
          expect(
            planOneDayOne.endedAt!.millisecondsSinceEpoch ~/ 1000,
            dayOne + 300,
          );
          expect(workouts.singleWhere((workout) => workout.id == 4).planId, 2);
          expect(workouts.singleWhere((workout) => workout.id == 5).planId, 1);
          expect(
            workouts.singleWhere((workout) => workout.id == 10).planId,
            null,
          );

          expect(bodyWeights[0].weightKg, closeTo(81.6466266, 0.000001));
          expect(bodyWeights[0].photo, 'weight-lb.jpg');
          expect(bodyWeights[1].weightKg, 80);
          expect(bodyWeights[1].photo, 'weight-kg.jpg');
          expect(
            bodyWeights.where((entry) => entry.photo == 'hidden-weight.jpg'),
            isEmpty,
          );
        },
      );
    },
  );
  test(
    'migration from v62 to v63 removes legacy storage and enforces foreign keys',
    () async {
      await verifier.testWithDataIntegrity(
        oldVersion: 62,
        newVersion: 63,
        createOld: v62.DatabaseAtV62.new,
        createNew: AppDatabase.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, oldDb) {
          batch.insert(
            oldDb.plans,
            v62.PlansCompanion.insert(
              id: const Value(1),
              days: 'Monday',
              title: const Value('Stable IDs'),
            ),
          );
          batch.insert(
            oldDb.exercises,
            v62.ExercisesCompanion.insert(
              id: const Value(10),
              name: 'Bench Press',
              kind: 'strength',
              displayUnit: 'kg',
            ),
          );
          batch.insertAll(oldDb.planExercises, [
            v62.PlanExercisesCompanion.insert(
              id: const Value(20),
              enabled: 1,
              exercise: 'Bench Press',
              exerciseId: const Value(10),
              planId: 1,
            ),
            v62.PlanExercisesCompanion.insert(
              id: const Value(21),
              enabled: 1,
              exercise: 'Unresolved Legacy Exercise',
              planId: 1,
            ),
            v62.PlanExercisesCompanion.insert(
              id: const Value(22),
              enabled: 1,
              exercise: 'Bench Press',
              exerciseId: const Value(10),
              planId: 999,
            ),
          ]);
          batch.insert(
            oldDb.settings,
            v62.SettingsCompanion.insert(
              alarmSound: '',
              cardioUnit: 'last-entry',
              curveLines: 1,
              explainedPermissions: 0,
              groupHistory: 0,
              longDateFormat: 'timeago',
              maxSets: 3,
              planTrailing: 'PlanTrailing.reorder',
              restTimers: 0,
              shortDateFormat: 'd/M/yy',
              showUnits: 0,
              strengthUnit: 'last-entry',
              systemColors: 0,
              themeMode: 'ThemeMode.system',
              timerDuration: 210000,
              vibrate: 1,
            ),
          );
          batch.insert(
            oldDb.metadata,
            v62.MetadataCompanion.insert(buildNumber: 777),
          );
        },
        validateItems: (newDb) async {
          final settings = await newDb.select(newDb.settings).getSingle();
          expect(settings.buildNumber, 777);

          final planExercises = await newDb.select(newDb.planExercises).get();
          expect(planExercises, hasLength(1));
          expect(planExercises.single.id, 20);
          expect(planExercises.single.exerciseId, 10);

          final legacyTables = await newDb
              .customSelect(
                "SELECT name FROM sqlite_master WHERE type = 'table' "
                "AND name IN ('gym_sets', 'graph_preferences', 'metadata')",
              )
              .get();
          expect(legacyTables, isEmpty);

          final planColumns = await newDb
              .customSelect('PRAGMA table_info(plan_exercises)')
              .get();
          expect(
            planColumns.where((row) => row.read<String>('name') == 'exercise'),
            isEmpty,
          );
          final exerciseIdColumn = planColumns.singleWhere(
            (row) => row.read<String>('name') == 'exercise_id',
          );
          expect(exerciseIdColumn.read<int>('notnull'), 1);

          final foreignKeyViolations = await newDb
              .customSelect('PRAGMA foreign_key_check')
              .get();
          expect(foreignKeyViolations, isEmpty);
        },
      );
    },
  );
  test(
    'migration from v64 to v65 repairs duplicates and installs constraints',
    () async {
      final olderStart =
          DateTime(2026, 10, 3, 8).millisecondsSinceEpoch ~/ 1000;
      final newerStart =
          DateTime(2026, 10, 3, 9).millisecondsSinceEpoch ~/ 1000;

      await verifier.testWithDataIntegrity(
        oldVersion: 64,
        newVersion: 65,
        createOld: v64.DatabaseAtV64.new,
        createNew: AppDatabase.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, oldDb) {
          batch.insert(
            oldDb.plans,
            v64.PlansCompanion.insert(id: const Value(1), days: 'Friday'),
          );
          batch.insert(
            oldDb.exercises,
            v64.ExercisesCompanion.insert(
              id: const Value(10),
              name: 'Bench Press',
              kind: 'strength',
              displayUnit: 'kg',
            ),
          );
          batch.insertAll(oldDb.planExercises, [
            v64.PlanExercisesCompanion.insert(
              id: const Value(20),
              planId: 1,
              exerciseId: 10,
              enabled: 0,
              maxSets: const Value(5),
              warmupSets: const Value(2),
              sequence: const Value(3),
            ),
            v64.PlanExercisesCompanion.insert(
              id: const Value(21),
              planId: 1,
              exerciseId: 10,
              enabled: 1,
              sequence: const Value(1),
            ),
          ]);
          batch.insertAll(oldDb.workouts, [
            v64.WorkoutsCompanion.insert(
              id: const Value(30),
              planId: const Value(1),
              startedAt: olderStart,
            ),
            v64.WorkoutsCompanion.insert(
              id: const Value(31),
              planId: const Value(1),
              startedAt: newerStart,
            ),
          ]);
        },
        validateItems: (newDb) async {
          final planExercises = await newDb.select(newDb.planExercises).get();
          expect(planExercises, hasLength(1));
          expect(planExercises.single.id, 21);
          expect(planExercises.single.enabled, isTrue);
          expect(planExercises.single.maxSets, 5);
          expect(planExercises.single.warmupSets, 2);
          expect(planExercises.single.sequence, 1);

          final workouts =
              await (newDb.workouts.select()
                    ..where((row) => row.planId.equals(1))
                    ..orderBy([(row) => OrderingTerm.asc(row.id)]))
                  .get();
          expect(workouts, hasLength(2));
          expect(workouts[0].id, 30);
          expect(
            workouts[0].endedAt,
            DateTime.fromMillisecondsSinceEpoch(newerStart * 1000),
          );
          expect(workouts[1].id, 31);
          expect(workouts[1].endedAt, null);

          final indexes = await newDb
              .customSelect(
                "SELECT name FROM sqlite_master "
                "WHERE type = 'index' AND name IN ("
                "'exercises_category_id',"
                "'exercise_sets_exercise_timestamp',"
                "'exercise_sets_workout_exercise',"
                "'workouts_plan_ended_started',"
                "'workouts_active_plan',"
                "'body_weights_timestamp',"
                "'plan_exercises_plan_exercise',"
                "'plan_exercises_exercise_id'"
                ")",
              )
              .map((row) => row.read<String>('name'))
              .get();
          expect(indexes.toSet(), {
            'exercises_category_id',
            'exercise_sets_exercise_timestamp',
            'exercise_sets_workout_exercise',
            'workouts_plan_ended_started',
            'workouts_active_plan',
            'body_weights_timestamp',
            'plan_exercises_plan_exercise',
            'plan_exercises_exercise_id',
          });

          expect(
            () => newDb.planExercises.insertOne(
              PlanExercisesCompanion.insert(
                planId: 1,
                exerciseId: 10,
                enabled: true,
              ),
            ),
            throwsA(anything),
          );
          expect(
            () => newDb.workouts.insertOne(
              WorkoutsCompanion.insert(
                planId: const Value(1),
                startedAt: DateTime(2026, 10, 3, 10),
              ),
            ),
            throwsA(anything),
          );

          final foreignKeyViolations = await newDb
              .customSelect('PRAGMA foreign_key_check')
              .get();
          expect(foreignKeyViolations, isEmpty);
        },
      );
    },
  );

  test(
    'migration from v65 to v66 allows one exercise name per category',
    () async {
      final timestamp = DateTime(2026, 10, 5, 8).millisecondsSinceEpoch ~/ 1000;

      await verifier.testWithDataIntegrity(
        oldVersion: 65,
        newVersion: 66,
        createOld: v65.DatabaseAtV65.new,
        createNew: AppDatabase.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, oldDb) {
          batch.insertAll(oldDb.categories, [
            v65.CategoriesCompanion.insert(id: const Value(1), name: 'Back'),
            v65.CategoriesCompanion.insert(
              id: const Value(2),
              name: 'Shoulders',
            ),
          ]);
          batch.insert(
            oldDb.plans,
            v65.PlansCompanion.insert(id: const Value(1), days: 'Friday'),
          );
          batch.insertAll(oldDb.exercises, [
            v65.ExercisesCompanion.insert(
              id: const Value(10),
              name: 'Reverse fly',
              kind: 'strength',
              displayUnit: 'kg',
              categoryId: const Value(1),
            ),
            v65.ExercisesCompanion.insert(
              id: const Value(11),
              name: 'Squat',
              kind: 'strength',
              displayUnit: 'kg',
            ),
          ]);
          batch.insert(
            oldDb.exerciseSets,
            v65.ExerciseSetsCompanion.insert(
              id: const Value(100),
              exerciseId: 10,
              timestamp: timestamp,
            ),
          );
          batch.insert(
            oldDb.planExercises,
            v65.PlanExercisesCompanion.insert(
              id: const Value(20),
              planId: 1,
              exerciseId: 11,
              enabled: 1,
            ),
          );
        },
        validateItems: (newDb) async {
          final exercises =
              await (newDb.exercises.select()
                    ..orderBy([(row) => OrderingTerm.asc(row.id)]))
                  .get();
          expect(exercises.map((row) => (row.id, row.name, row.categoryId)), [
            (10, 'Reverse fly', 1),
            (11, 'Squat', null),
          ]);

          final sets = await newDb.select(newDb.exerciseSets).get();
          expect(sets.single.exerciseId, 10);
          final planExercises = await newDb.select(newDb.planExercises).get();
          expect(planExercises.single.exerciseId, 11);

          final indexes = await newDb
              .customSelect(
                "SELECT name FROM sqlite_master WHERE type = 'index' "
                "AND name IN ('exercises_category_id', "
                "'exercises_name_category')",
              )
              .map((row) => row.read<String>('name'))
              .get();
          expect(indexes.toSet(), {
            'exercises_category_id',
            'exercises_name_category',
          });

          Future<void> insertExercise(String name, int? categoryId) {
            return newDb.exercises.insertOne(
              ExercisesCompanion.insert(
                name: name,
                kind: 'strength',
                displayUnit: 'kg',
                categoryId: Value(categoryId),
              ),
            );
          }

          await insertExercise('Reverse fly', 2);
          await insertExercise('Squat', 1);
          await expectLater(
            insertExercise('Reverse fly', 1),
            throwsA(anything),
          );
          await expectLater(insertExercise('Squat', null), throwsA(anything));

          final foreignKeyViolations = await newDb
              .customSelect('PRAGMA foreign_key_check')
              .get();
          expect(foreignKeyViolations, isEmpty);
        },
      );
    },
  );
}
