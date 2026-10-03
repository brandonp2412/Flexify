import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
  });

  tearDown(() => database.close());

  Future<int> addExercise({
    required String name,
    required String unit,
    required bool cardio,
    String? category,
    String? image,
    int? restMs,
  }) async {
    int? categoryId;
    if (category != null) {
      categoryId = await database.categories.insertOne(
        CategoriesCompanion.insert(name: category),
      );
    }
    return database.exercises.insertOne(
      ExercisesCompanion.insert(
        name: name,
        kind: cardio ? 'cardio' : 'strength',
        displayUnit: unit,
        categoryId: Value(categoryId),
        image: Value(image),
        defaultRestDurationMs: Value(restMs),
      ),
    );
  }

  ExerciseSetView draft({
    required String name,
    required String unit,
    required DateTime created,
    bool cardio = false,
    double reps = 0,
    double weight = 0,
    double distance = 0,
    double duration = 0,
    double bodyWeight = 0,
    int? incline,
    String? notes,
  }) {
    return ExerciseSetView(
      id: 0,
      bodyWeight: bodyWeight,
      cardio: cardio,
      created: created,
      distance: distance,
      duration: duration,
      incline: incline,
      name: name,
      notes: notes,
      reps: reps,
      unit: unit,
      weight: weight,
    );
  }

  test(
    'CRUD stores only canonical exercise-set data in exercise_sets',
    () async {
      final exerciseId = await addExercise(
        name: 'Cutover Bench',
        unit: 'lb',
        cardio: false,
        category: 'Push',
        image: '/tmp/bench.png',
        restMs: 90000,
      );
      final planId = await database.plans.insertOne(
        PlansCompanion.insert(days: 'Friday'),
      );
      final workoutId = await database.workouts.insertOne(
        WorkoutsCompanion.insert(
          planId: Value(planId),
          startedAt: DateTime(2026, 10, 2, 18),
        ),
      );

      final inserted = await insertExerciseSet(
        database,
        exerciseSet: draft(
          name: 'Cutover Bench',
          unit: 'lb',
          created: DateTime(2026, 10, 2, 18, 5),
          reps: 5,
          weight: 220,
          duration: 1.5,
          bodyWeight: 180,
          notes: 'working set',
        ),
        exerciseId: exerciseId,
        workoutId: workoutId,
      );

      final stored =
          await (database.exerciseSets.select()
                ..where((set) => set.id.equals(inserted.id)))
              .getSingle();
      expect(stored.exerciseId, exerciseId);
      expect(stored.workoutId, workoutId);
      expect(stored.reps, 5);
      expect(stored.loadKg, closeTo(99.7903214, 0.000001));
      expect(stored.durationMs, 90000);
      expect(stored.bodyWeightKg, closeTo(81.6466266, 0.000001));
      expect(stored.notes, 'working set');

      expect(inserted.name, 'Cutover Bench');
      expect(inserted.category, 'Push');
      expect(inserted.image, '/tmp/bench.png');
      expect(inserted.restMs, 90000);
      expect(inserted.unit, 'lb');
      expect(inserted.weight, closeTo(220, 0.000001));
      expect(inserted.bodyWeight, closeTo(180, 0.000001));
      expect(inserted.planId, planId);

      await updateExerciseSet(
        database,
        id: inserted.id,
        exerciseSet: inserted.copyWith(
          reps: 6,
          weight: 225,
          notes: const Value('top set'),
        ),
        exerciseId: exerciseId,
      );

      final updated = await getExerciseSetById(database, inserted.id);
      expect(updated, isNotNull);
      expect(updated!.reps, 6);
      expect(updated.weight, closeTo(225, 0.000001));
      expect(updated.notes, 'top set');
      expect(updated.category, 'Push');

      expect(await deleteExerciseSets(database, [inserted.id]), 1);
      expect(await getExerciseSetById(database, inserted.id), isNull);
    },
  );

  test('history search and filters use joined exercise metadata', () async {
    final benchId = await addExercise(
      name: 'Cutover Bench',
      unit: 'kg',
      cardio: false,
      category: 'Push',
    );
    final runId = await addExercise(
      name: 'Cutover Run',
      unit: 'km',
      cardio: true,
      category: 'Cardio',
    );

    await insertExerciseSet(
      database,
      exerciseSet: draft(
        name: 'Cutover Bench',
        unit: 'kg',
        created: DateTime(2026, 9, 30, 9),
        reps: 5,
        weight: 80,
      ),
      exerciseId: benchId,
    );
    await insertExerciseSet(
      database,
      exerciseSet: draft(
        name: 'Cutover Bench',
        unit: 'kg',
        created: DateTime(2026, 10, 1, 9),
        reps: 8,
        weight: 90,
      ),
      exerciseId: benchId,
    );
    await insertExerciseSet(
      database,
      exerciseSet: draft(
        name: 'Cutover Run',
        unit: 'km',
        created: DateTime(2026, 10, 2, 9),
        cardio: true,
        distance: 5,
        duration: 25,
        incline: 2,
      ),
      exerciseId: runId,
    );

    final searched = await getExerciseSets(database, search: 'bench');
    expect(searched, hasLength(2));
    expect(searched.every((set) => set.category == 'Push'), isTrue);
    expect(searched.first.created, DateTime(2026, 10, 1, 9));

    final filtered = await getExerciseSets(
      database,
      category: 'Push',
      startDate: DateTime(2026, 10, 1),
      repsGt: 6,
      weightGt: 85,
    );
    expect(filtered, hasLength(1));
    expect(filtered.single.name, 'Cutover Bench');
    expect(filtered.single.reps, 8);

    final cardio = await getExerciseSets(database, category: 'Cardio');
    expect(cardio, hasLength(1));
    expect(cardio.single.cardio, isTrue);
    expect(cardio.single.distance, closeTo(5, 0.000001));
    expect(cardio.single.duration, 25);
    expect(cardio.single.incline, 2);
  });

  test('history ordering uses the timestamp index', () async {
    final queryPlan = await database.customSelect('''
      EXPLAIN QUERY PLAN
      SELECT exercise_sets.id
      FROM exercise_sets
      INNER JOIN exercises
        ON exercises.id = exercise_sets.exercise_id
      LEFT JOIN categories
        ON categories.id = exercises.category_id
      LEFT JOIN workouts
        ON workouts.id = exercise_sets.workout_id
      ORDER BY exercise_sets.timestamp DESC, exercise_sets.id DESC
      LIMIT 100
    ''').get();

    final details = queryPlan
        .map((row) => row.read<String>('detail'))
        .join('\n');
    expect(details, contains('exercise_sets_timestamp'));
  });
}
