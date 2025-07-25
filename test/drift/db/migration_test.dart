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
import 'generated/schema_v5.dart' as v5;

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
        final userSet = gymSets
            .firstWhere((set) => set.name == 'Deadlift' && set.reps == 5.0);
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

        final overheadPress =
            gymSets.firstWhere((set) => set.name == 'Overhead Press');
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
  });

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
        expect(plans.first.exercises, 'Deadlift,Romanian Deadlift');
        expect(plans.first.sequence, 1);

        final gymSets = await newDb.select(newDb.gymSets).get();
        expect(gymSets.length, 2);

        final deadlift = gymSets.firstWhere((set) => set.name == 'Deadlift');
        expect(deadlift.weight, 120.0);
        expect(deadlift.reps, 5.0);
        expect(deadlift.bodyWeight, 75.0);
        expect(deadlift.restMs, 180000);
        expect(deadlift.planId, 1);
        expect(deadlift.cardio, false);

        final romanianDeadlift =
            gymSets.firstWhere((set) => set.name == 'Romanian Deadlift');
        expect(romanianDeadlift.weight, 80.0);
        expect(romanianDeadlift.reps, 8.0);
        expect(romanianDeadlift.restMs, 120000);

        final planExercises = await newDb.select(newDb.planExercises).get();
        expect(planExercises.length, 2);
        expect(
          planExercises
              .any((pe) => pe.exercise == 'Deadlift' && pe.maxSets == 3),
          true,
        );
        expect(
          planExercises.any(
            (pe) => pe.exercise == 'Romanian Deadlift' && pe.maxSets == 4,
          ),
          true,
        );

        // Verify settings table exists (added in v16)
        final settings = await newDb.select(newDb.settings).get();
        expect(
          settings.length,
          0,
        );
      },
    );
  });
}
