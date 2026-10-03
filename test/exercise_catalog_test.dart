import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_queries.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';

void main() {
  setUp(() => db = testDb());

  test('creating an exercise writes only catalog state', () async {
    final exercise = await createExerciseDefinition(
      name: 'Catalog-only press',
      cardio: false,
      displayUnit: 'kg',
      category: 'Chest',
      image: '/tmp/press.png',
      defaultRestDurationMs: 90000,
    );

    expect(exercise.name, 'Catalog-only press');
    expect(exercise.kind, 'strength');
    expect(exercise.displayUnit, 'kg');
    expect(exercise.image, '/tmp/press.png');
    expect(exercise.defaultRestDurationMs, 90000);
    expect(await getExerciseCategoryName(exercise), 'Chest');
    expect(
      await (db.exerciseSets.select()
            ..where((set) => set.exerciseId.equals(exercise.id)))
          .get(),
      isEmpty,
    );
  });

  test(
    'rename keeps history and plans attached to the stable exercise id',
    () async {
      final exercise = await createExerciseDefinition(
        name: 'Stable lift',
        cardio: false,
        displayUnit: 'kg',
      );
      final timestamp = DateTime(2026, 10, 1, 18, 30);
      final historyId = await db.exerciseSets.insertOne(
        ExerciseSetsCompanion.insert(
          exerciseId: exercise.id,
          timestamp: timestamp,
          reps: const Value(5),
          loadKg: const Value(100),
        ),
      );
      final planId = await db.plans.insertOne(
        PlansCompanion.insert(days: 'Tuesday'),
      );
      await db.planExercises.insertOne(
        PlanExercisesCompanion.insert(
          planId: planId,
          exerciseId: exercise.id,
          enabled: true,
        ),
      );

      await updateExerciseDefinition(
        exerciseId: exercise.id,
        name: 'Renamed stable lift',
        cardio: false,
        displayUnit: 'kg',
      );

      final renamed = await getExerciseById(exercise.id);
      expect(renamed!.name, 'Renamed stable lift');
      expect(
        (await (db.exerciseSets.select()
                  ..where((set) => set.id.equals(historyId)))
                .getSingle())
            .exerciseId,
        exercise.id,
      );
      final history = await getExerciseSets(db, search: 'Renamed stable lift');
      expect(history, hasLength(1));
      expect(history.single.name, 'Renamed stable lift');
      expect(history.single.created, timestamp);
      expect(
        (await (db.planExercises.select()
                  ..where((row) => row.planId.equals(planId)))
                .getSingle())
            .exerciseId,
        exercise.id,
      );
    },
  );

  test('rest image category and graph preferences live on exercises', () async {
    final exercise = await createExerciseDefinition(
      name: 'Config lift',
      cardio: false,
      displayUnit: 'kg',
    );

    await updateExerciseDefinition(
      exerciseId: exercise.id,
      name: exercise.name,
      cardio: false,
      displayUnit: 'lb',
      category: 'Arms',
      image: '/tmp/config.png',
      defaultRestDurationMs: 120000,
    );
    await updateExerciseGraphPreferences(
      exerciseId: exercise.id,
      metric: 'volume',
      period: 'week',
      limit: 42,
      timeBasedXAxis: true,
      notes: 'Keep elbows tucked',
    );

    final updated = await getExerciseById(exercise.id);
    expect(updated!.displayUnit, 'lb');
    expect(updated.image, '/tmp/config.png');
    expect(updated.defaultRestDurationMs, 120000);
    expect(await getExerciseCategoryName(updated), 'Arms');
    expect(updated.graphMetric, 'volume');
    expect(updated.graphPeriod, 'week');
    expect(updated.graphLimit, 42);
    expect(updated.graphTimeBasedXAxis, isTrue);
    expect(updated.notes, 'Keep elbows tucked');
    expect(
      await db
          .customSelect(
            "SELECT name FROM sqlite_master "
            "WHERE type = 'table' AND name = 'graph_preferences'",
          )
          .get(),
      isEmpty,
    );
  });

  test('renaming onto an existing exercise merges stable references', () async {
    final source = await createExerciseDefinition(
      name: 'Merge source',
      cardio: false,
      displayUnit: 'kg',
    );
    final target = await createExerciseDefinition(
      name: 'Merge target',
      cardio: false,
      displayUnit: 'kg',
    );
    final planId = await db.plans.insertOne(
      PlansCompanion.insert(days: 'Friday'),
    );
    await db.planExercises.insertOne(
      PlanExercisesCompanion.insert(
        planId: planId,
        exerciseId: source.id,
        enabled: true,
      ),
    );
    await db.exerciseSets.insertOne(
      ExerciseSetsCompanion.insert(
        exerciseId: source.id,
        timestamp: DateTime(2026, 10, 2, 9),
        reps: const Value(5),
        loadKg: const Value(80),
      ),
    );
    await db.exerciseSets.insertOne(
      ExerciseSetsCompanion.insert(
        exerciseId: target.id,
        timestamp: DateTime(2026, 10, 2, 10),
        reps: const Value(6),
        loadKg: const Value(90),
      ),
    );

    await updateExerciseDefinition(
      exerciseId: source.id,
      name: target.name,
      cardio: false,
      displayUnit: 'lb',
      category: 'Merged',
    );

    expect(await getExerciseById(source.id), null);
    final merged = await getExerciseById(target.id);
    expect(merged, isA<Exercise>());
    expect(merged!.displayUnit, 'lb');
    expect(await getExerciseCategoryName(merged), 'Merged');

    final sets = await db.exerciseSets.select().get();
    expect(sets, hasLength(2));
    expect(sets.every((set) => set.exerciseId == target.id), isTrue);
    final planExercise =
        await (db.planExercises.select()
              ..where((row) => row.planId.equals(planId)))
            .getSingle();
    expect(planExercise.exerciseId, target.id);
  });

  test('plan editor discovers catalog exercises by stable id', () async {
    final exercise = await createExerciseDefinition(
      name: 'Plan-only lift',
      cardio: false,
      displayUnit: 'kg',
    );
    final planId = await db.plans.insertOne(
      PlansCompanion.insert(days: 'Thursday'),
    );

    var drafts = await loadPlanExerciseDrafts(
      PlansCompanion(id: Value(planId)),
    );
    var draft = drafts.singleWhere(
      (row) => row.planExercise.exerciseId.value == exercise.id,
    );
    expect(draft.exerciseName, exercise.name);
    expect(draft.planExercise.enabled.value, isFalse);

    await db.planExercises.insertOne(
      PlanExercisesCompanion.insert(
        planId: planId,
        exerciseId: exercise.id,
        enabled: true,
      ),
    );
    drafts = await loadPlanExerciseDrafts(PlansCompanion(id: Value(planId)));
    draft = drafts.singleWhere(
      (row) => row.planExercise.exerciseId.value == exercise.id,
    );
    expect(draft.planExercise.enabled.value, isTrue);
    expect(draft.exerciseName, exercise.name);
  });
}
