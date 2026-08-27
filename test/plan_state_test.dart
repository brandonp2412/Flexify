import 'package:drift/drift.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';
import 'support/fixtures.dart';

void main() {
  setUp(() {
    db = testDb();
  });

  test('getGymCounts only counts sets from the current calendar day', () async {
    final planId = await db.plans.insertOne(planFixture());
    await db.planExercises.insertOne(
      planExerciseFixture(planId: planId, exercise: 'Bench press'),
    );

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final lateLastNight = startOfToday.subtract(const Duration(hours: 1));

    await db.gymSets.insertOne(
      gymSetFixture('Bench press', weight: 100, created: now, planId: planId),
    );
    await db.gymSets.insertOne(
      gymSetFixture(
        'Bench press',
        weight: 100,
        created: lateLastNight,
        planId: planId,
      ),
    );
    await db.gymSets.insertOne(
      gymSetFixture(
        'Bench press',
        weight: 100,
        created: now,
        planId: planId,
        hidden: true,
      ),
    );
    await db.gymSets.insertOne(
      gymSetFixture('Bench press', weight: 100, created: now),
    );

    final counts = await PlanState().getGymCounts(planId);

    expect(counts, hasLength(1));
    expect(counts.single.name, 'Bench press');
    expect(counts.single.count, 1);
  });

  test('setExercises keeps enabled plan order before available exercises', () async {
    final planId = await db.plans.insertOne(
      planFixture(id: 1, title: 'Push day'),
    );
    final plan = await (db.plans.select()..where((p) => p.id.equals(planId)))
        .getSingle();

    await db.gymSets.insertAll([
      gymSetFixture('Arnold press'),
      gymSetFixture('Back extension'),
      gymSetFixture('Barbell biceps curl'),
    ]);
    await db.planExercises.insertAll([
      planExerciseFixture(
        planId: planId,
        exercise: 'Arnold press',
        sequence: 1,
      ),
      planExerciseFixture(
        planId: planId,
        exercise: 'Back extension',
        sequence: 0,
      ),
    ]);

    final state = PlanState();
    await state.setExercises(plan.toCompanion(false));

    expect(
      state.exercises.map((exercise) => exercise.exercise.value),
      ['Back extension', 'Arnold press', 'Barbell biceps curl'],
    );
    expect(
      state.exercises.map((exercise) => exercise.enabled.value),
      [true, true, false],
    );
  });
}
