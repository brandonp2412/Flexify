import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flexify/data_portability/graph_csv.dart';
import 'package:flexify/database/database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<AppDatabase> emptyDatabase() async {
    final database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    await database.exerciseSets.deleteAll();
    await database.workouts.deleteAll();
    await database.bodyWeights.deleteAll();
    await database.planExercises.deleteAll();
    await database.exercises.deleteAll();
    await database.categories.deleteAll();
    await database.plans.deleteAll();
    return database;
  }

  test(
    'new graph CSV round-trips canonical history and relationships',
    () async {
      final source = await emptyDatabase();
      final target = await emptyDatabase();
      addTearDown(source.close);
      addTearDown(target.close);

      await source.plans.insertOne(
        PlansCompanion.insert(id: const Value(7), days: 'Monday'),
      );
      await target.plans.insertOne(
        PlansCompanion.insert(id: const Value(7), days: 'Monday'),
      );
      final categoryId = await source.categories.insertOne(
        CategoriesCompanion.insert(name: 'Power'),
      );
      final exerciseId = await source.exercises.insertOne(
        ExercisesCompanion.insert(
          name: 'Bench press',
          kind: 'strength',
          displayUnit: 'lb',
          categoryId: Value(categoryId),
          image: const Value('/images/bench.jpg'),
          defaultRestDurationMs: const Value(90000),
          notes: const Value('Pause reps'),
          graphMetric: const Value('oneRepMax'),
          graphPeriod: const Value('week'),
          graphLimit: const Value(42),
          graphTimeBasedXAxis: const Value(true),
        ),
      );
      final workoutId = await source.workouts.insertOne(
        WorkoutsCompanion.insert(
          planId: const Value(7),
          startedAt: DateTime.utc(2026, 9, 1, 6),
          endedAt: Value(DateTime.utc(2026, 9, 1, 7)),
        ),
      );
      await source.exerciseSets.insertOne(
        ExerciseSetsCompanion.insert(
          exerciseId: exerciseId,
          workoutId: Value(workoutId),
          timestamp: DateTime.utc(2026, 9, 1, 6, 10),
          reps: const Value(5),
          loadKg: const Value(100.25),
          durationMs: const Value(12345),
          distanceMetres: const Value(321.5),
          incline: const Value(2.5),
          bodyWeightKg: const Value(81.75),
          notes: const Value('Top set'),
        ),
      );
      await source.bodyWeights.insertOne(
        BodyWeightsCompanion.insert(
          timestamp: DateTime.utc(2026, 9, 1, 5),
          weightKg: 81.75,
          photo: const Value('/images/weight.jpg'),
        ),
      );

      final sourceWorkout = await source.workouts.select().getSingle();
      final sourceSet = await source.exerciseSets.select().getSingle();
      final csv = await exportGraphCsv(source);
      final result = await importGraphCsv(target, csv);

      expect(result.exercises, 1);
      expect(result.workouts, 1);
      expect(result.exerciseSets, 1);
      expect(result.bodyWeights, 1);

      final exercise = await target.exercises.select().getSingle();
      expect(exercise.name, 'Bench press');
      expect(exercise.displayUnit, 'lb');
      expect(exercise.image, '/images/bench.jpg');
      expect(exercise.defaultRestDurationMs, 90000);
      expect(exercise.notes, 'Pause reps');
      expect(exercise.graphMetric, 'oneRepMax');
      expect(exercise.graphPeriod, 'week');
      expect(exercise.graphLimit, 42);
      expect(exercise.graphTimeBasedXAxis, isTrue);
      final category = await target.categories.select().getSingle();
      expect(category.name, 'Power');

      final workout = await target.workouts.select().getSingle();
      expect(workout.planId, 7);
      expect(workout.startedAt, sourceWorkout.startedAt);
      expect(workout.endedAt, sourceWorkout.endedAt);

      final set = await target.exerciseSets.select().getSingle();
      expect(set.exerciseId, exercise.id);
      expect(set.workoutId, workout.id);
      expect(set.timestamp, sourceSet.timestamp);
      expect(set.reps, 5);
      expect(set.loadKg, 100.25);
      expect(set.durationMs, 12345);
      expect(set.distanceMetres, 321.5);
      expect(set.incline, 2.5);
      expect(set.bodyWeightKg, 81.75);
      expect(set.notes, 'Top set');

      final bodyWeight = await target.bodyWeights.select().getSingle();
      expect(bodyWeight.weightKg, 81.75);
      expect(bodyWeight.photo, '/images/weight.jpg');
    },
  );

  test('legacy graph CSV imports into redesigned canonical tables', () async {
    final database = await emptyDatabase();
    addTearDown(database.close);

    const csv =
        '''id,name,reps,weight,created,unit,bodyWeight,duration,distance,cardio,hidden,incline
1,Weight,0,176.36981,2026-09-01T05:00:00.000Z,lb,0,0,0,false,false,
2,Bench press,0,0,2026-09-01T05:30:00.000Z,lb,0,0,0,false,true,
3,Bench press,5,220.462262,2026-09-01T06:00:00.000Z,lb,176.36981,0,0,false,false,
4,Run,0,0,2026-09-02T06:00:00.000Z,km,0,25,5,true,false,3
''';

    final result = await importGraphCsv(database, csv);

    expect(result.exercises, 2);
    expect(result.workouts, 0);
    expect(result.exerciseSets, 2);
    expect(result.bodyWeights, 1);

    final weight = await database.bodyWeights.select().getSingle();
    expect(weight.weightKg, closeTo(80, 0.0001));

    final exercises = await database.exercises.select().get();
    final bench = exercises.singleWhere(
      (exercise) => exercise.name == 'Bench press',
    );
    final run = exercises.singleWhere((exercise) => exercise.name == 'Run');
    expect(bench.kind, 'strength');
    expect(bench.displayUnit, 'lb');
    expect(run.kind, 'cardio');
    expect(run.displayUnit, 'km');

    final sets = await database.exerciseSets.select().get();
    final benchSet = sets.singleWhere((set) => set.exerciseId == bench.id);
    expect(benchSet.loadKg, closeTo(100, 0.0001));
    expect(benchSet.bodyWeightKg, closeTo(80, 0.0001));

    final runSet = sets.singleWhere((set) => set.exerciseId == run.id);
    expect(runSet.loadKg, isNull);
    expect(runSet.distanceMetres, 5000);
    expect(runSet.durationMs, 1500000);
    expect(runSet.incline, 3);
  });

  test(
    'graph CSV keeps same-named exercises in other categories apart',
    () async {
      final source = await emptyDatabase();
      final target = await emptyDatabase();
      addTearDown(source.close);
      addTearDown(target.close);

      for (final (category, load) in [('Back', 40.0), ('Shoulders', 12.0)]) {
        final categoryId = await source.categories.insertOne(
          CategoriesCompanion.insert(name: category),
        );
        final exerciseId = await source.exercises.insertOne(
          ExercisesCompanion.insert(
            name: 'Reverse fly',
            kind: 'strength',
            displayUnit: 'kg',
            categoryId: Value(categoryId),
          ),
        );
        await source.exerciseSets.insertOne(
          ExerciseSetsCompanion.insert(
            exerciseId: exerciseId,
            timestamp: DateTime.utc(2026, 9, 1, 6),
            reps: const Value(10),
            loadKg: Value(load),
          ),
        );
      }

      final csv = await exportGraphCsv(source);
      await importGraphCsv(target, csv);
      final secondImport = await importGraphCsv(target, csv);

      expect(secondImport.exercises, 2);
      final categories = {
        for (final category in await target.categories.select().get())
          category.id: category.name,
      };
      final exercises = await target.exercises.select().get();
      expect(exercises, hasLength(2));
      final loadsByCategory = <String?, double?>{};
      for (final set in await target.exerciseSets.select().get()) {
        final exercise = exercises.singleWhere(
          (row) => row.id == set.exerciseId,
        );
        loadsByCategory[categories[exercise.categoryId]] = set.loadKg;
      }
      expect(loadsByCategory, {'Back': 40.0, 'Shoulders': 12.0});
    },
  );

  test(
    'legacy graph CSV attaches a shared name to the oldest exercise',
    () async {
      final database = await emptyDatabase();
      addTearDown(database.close);
      final firstId = await database.exercises.insertOne(
        ExercisesCompanion.insert(
          name: 'Reverse fly',
          kind: 'strength',
          displayUnit: 'kg',
        ),
      );
      final categoryId = await database.categories.insertOne(
        CategoriesCompanion.insert(name: 'Shoulders'),
      );
      await database.exercises.insertOne(
        ExercisesCompanion.insert(
          name: 'Reverse fly',
          kind: 'strength',
          displayUnit: 'kg',
          categoryId: Value(categoryId),
        ),
      );

      const csv =
          '''id,name,reps,weight,created,unit,bodyWeight,duration,distance,cardio,hidden,incline
1,Reverse fly,10,20,2026-09-01T06:00:00.000Z,kg,0,0,0,false,false,
''';
      final result = await importGraphCsv(database, csv);

      expect(result.exerciseSets, 1);
      expect(await database.exercises.select().get(), hasLength(2));
      expect(
        (await database.exerciseSets.select().getSingle()).exerciseId,
        firstId,
      );
    },
  );
}
