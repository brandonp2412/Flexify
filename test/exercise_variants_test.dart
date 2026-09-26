import 'package:drift/drift.dart' hide isNull;
import 'package:flexify/constants.dart';
import 'package:flexify/database/categories.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_queries.dart';
import 'package:flexify/plan/start_plan_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';
import 'support/fixtures.dart';

/// The same exercise name in two categories is tracked as two exercises.
void main() {
  setUp(() {
    db = testDb();
  });

  Future<void> seedReverseFly() => db.gymSets.insertAll([
    gymSetFixture('Reverse fly', weight: 30, category: 'Back', planId: 1),
    gymSetFixture('Reverse fly', weight: 12, category: 'Shoulders', planId: 2),
  ]);

  test('graph data only includes sets from the requested category', () async {
    await seedReverseFly();

    Future<double> bestWeight(String category) async {
      final data = await getStrengthData(
        target: 'kg',
        name: 'Reverse fly',
        category: category,
        metric: StrengthMetric.bestWeight,
        period: Period.day,
        start: null,
        end: null,
        limit: 11,
      );
      return data.single.value;
    }

    expect(await bestWeight('Back'), 30);
    expect(await bestWeight('Shoulders'), 12);
  });

  test('personal bests are compared within one category', () async {
    await seedReverseFly();
    final shoulders = await db
        .into(db.gymSets)
        .insertReturning(
          gymSetFixture('Reverse fly', weight: 14, category: 'Shoulders'),
        );

    expect(
      await isBest(shoulders),
      isTrue,
      reason: 'The heavier Back variant must not hide a Shoulders record.',
    );
  });

  test('graphs list each category variant separately', () async {
    await seedReverseFly();

    final graphs = await watchGraphs().first;
    final variants = graphs
        .where((graph) => graph.name.value == 'Reverse fly')
        .map((graph) => graph.category.value)
        .toSet();

    expect(variants, {'Back', 'Shoulders'});
  });

  test('plan progress counts each variant separately', () async {
    final planId = await db.plans.insertOne(planFixture());
    await db.planExercises.insertAll([
      planExerciseFixture(
        planId: planId,
        exercise: 'Reverse fly',
        category: 'Back',
      ),
      planExerciseFixture(
        planId: planId,
        exercise: 'Reverse fly',
        category: 'Shoulders',
      ),
    ]);
    await db.gymSets.insertAll([
      gymSetFixture('Reverse fly', category: 'Shoulders', hidden: true),
      gymSetFixture(
        'Reverse fly',
        category: 'Back',
        planId: planId,
        created: DateTime.now(),
      ),
      gymSetFixture(
        'Reverse fly',
        category: 'Back',
        planId: planId,
        created: DateTime.now(),
      ),
    ]);

    final counts = await getGymCounts(planId);
    int countFor(String category) =>
        counts.singleWhere((count) => count.category == category).count;

    expect(countFor('Back'), 2);
    expect(countFor('Shoulders'), 0);
  });

  test('workout prefill never borrows weights from another category', () async {
    await seedReverseFly();

    final back = await getStartPlanPrefill(db, 'Reverse fly', 'Back', 1);
    final shoulders = await getStartPlanPrefill(
      db,
      'Reverse fly',
      'Shoulders',
      1,
    );

    expect(back?.weight, 30);
    expect(
      shoulders,
      isNull,
      reason: 'Plan 1 only has Back history for this name.',
    );
  });

  test('merging categories carries plan entries and graph notes', () async {
    await createCategory('Rear delts');
    await createCategory('Shoulders');
    final planId = await db.plans.insertOne(planFixture());
    await db.planExercises.insertOne(
      planExerciseFixture(
        planId: planId,
        exercise: 'Reverse fly',
        category: 'Rear delts',
      ),
    );
    await db.graphPreferences.insertOne(
      GraphPreferencesCompanion.insert(
        name: 'Reverse fly',
        category: const Value('Rear delts'),
        notes: const Value('Light and slow'),
      ),
    );
    final categories = await db.categories.select().get();

    await mergeCategory(
      categories.singleWhere((category) => category.name == 'Rear delts'),
      categories.singleWhere((category) => category.name == 'Shoulders'),
    );

    final planned =
        await (db.planExercises.select()
              ..where((entry) => entry.planId.equals(planId)))
            .getSingle();
    final preference = await db.graphPreferences.select().getSingle();
    expect(planned.category, 'Shoulders');
    expect(preference.category, 'Shoulders');
    expect(preference.notes, 'Light and slow');
  });
}
