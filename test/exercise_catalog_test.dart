import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_queries.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';

void main() {
  setUp(() => db = testDb());

  test(
    'creating an exercise writes the catalog without a hidden fake set',
    () async {
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
        await (db.gymSets.select()
              ..where((set) => set.name.equals('Catalog-only press')))
            .get(),
        isEmpty,
      );
    },
  );

  test(
    'rename keeps performed history attached to the stable exercise id',
    () async {
      final exercise = await createExerciseDefinition(
        name: 'Stable lift',
        cardio: false,
        displayUnit: 'kg',
      );
      final timestamp = DateTime(2026, 10, 1, 18, 30);
      await db.gymSets.insertOne(
        GymSetsCompanion.insert(
          name: 'Stable lift',
          reps: 5,
          weight: 100,
          unit: 'kg',
          created: timestamp,
        ),
      );
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
          exercise: exercise.name,
          exerciseId: Value(exercise.id),
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
      expect(
        (await (db.gymSets.select()
                  ..where((set) => set.created.equals(timestamp)))
                .getSingle())
            .name,
        'Stable lift',
      );
      expect(
        (await (db.planExercises.select()
                  ..where((row) => row.planId.equals(planId)))
                .getSingle())
            .exercise,
        'Renamed stable lift',
      );
      expect(
        await (db.gymSets.select()
              ..where((set) => set.name.equals('Renamed stable lift')))
            .get(),
        isEmpty,
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
      await (db.graphPreferences.select()
            ..where((pref) => pref.name.equals(exercise.name)))
          .get(),
      isEmpty,
    );
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
    final draft = drafts.singleWhere(
      (row) => row.exerciseId.value == exercise.id,
    );
    expect(draft.exercise.value, exercise.name);
    expect(draft.enabled.value, isFalse);

    await db.planExercises.insertOne(
      PlanExercisesCompanion.insert(
        planId: planId,
        exercise: exercise.name,
        exerciseId: Value(exercise.id),
        enabled: true,
      ),
    );
    drafts = await loadPlanExerciseDrafts(PlansCompanion(id: Value(planId)));
    expect(
      drafts
          .singleWhere((row) => row.exerciseId.value == exercise.id)
          .enabled
          .value,
      isTrue,
    );
  });
}
