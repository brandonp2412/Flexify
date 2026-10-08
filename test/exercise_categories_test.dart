import 'package:drift/drift.dart' show OrderingMode;
import 'package:flexify/constants.dart' show Period, StrengthMetric;
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/database/exercise_key.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';
import 'support/fixtures.dart';

const ExerciseKey _back = (name: 'Reverse fly', category: 'Back');
const ExerciseKey _shoulders = (name: 'Reverse fly', category: 'Shoulders');
const ExerciseKey _uncategorized = (name: 'Reverse fly', category: null);

void main() {
  setUp(() => db = testDb());

  Future<void> seedSameNameInTwoCategories() async {
    await insertExerciseSetFixture(
      db,
      'Reverse fly',
      category: 'Back',
      weight: 40,
      reps: 10,
    );
    await insertExerciseSetFixture(
      db,
      'Reverse fly',
      category: 'Shoulders',
      weight: 10,
      reps: 12,
      created: testNow.add(const Duration(days: 1)),
    );
    await insertExerciseSetFixture(
      db,
      'Reverse fly',
      category: 'Shoulders',
      weight: 12,
      reps: 12,
      created: testNow.add(const Duration(days: 2)),
    );
  }

  test('history is kept separately for each category', () async {
    await seedSameNameInTwoCategories();

    Future<List<double>> weights(ExerciseKey exercise) async =>
        (await getExerciseSetsForExercise(
          db,
          exercise: exercise,
          order: OrderingMode.asc,
        )).map((set) => set.weight).toList();

    expect(await weights(_back), [40]);
    expect(await weights(_shoulders), [10, 12]);
    expect(await weights(_uncategorized), isEmpty);
    expect((await getLatestExerciseSet(db, exercise: _back))!.weight, 40);
    expect((await getLatestExerciseSet(db, exercise: _shoulders))!.weight, 12);
    expect(await countExerciseSetsForExercises(db, [_back]), 1);
    expect(await countExerciseSetsForExercises(db, [_shoulders]), 2);
    expect(await countExerciseSetsForExercises(db, [_back, _shoulders]), 3);
  });

  test('graph data is computed per category', () async {
    await seedSameNameInTwoCategories();

    Future<List<double>> best(ExerciseKey exercise) async =>
        (await getStrengthData(
          target: 'kg',
          exercise: exercise,
          metric: StrengthMetric.bestWeight,
          period: Period.day,
          start: null,
          end: null,
          limit: 20,
        )).map((point) => point.value).toList();

    expect(await best(_back), [40]);
    expect(await best(_shoulders), [10, 12]);
    expect(await getGraphHistory(_back), hasLength(1));
    expect(
      await getGraphPointSet(_shoulders, testNow.add(const Duration(days: 1))),
      isNotNull,
    );
    expect(
      await getGraphPointSet(_back, testNow.add(const Duration(days: 1))),
      isNull,
    );
    expect(await countGraphSets([_shoulders]), 2);
  });

  test('graph list shows one entry per category', () async {
    await seedSameNameInTwoCategories();

    final graphs = await watchGraphs().first;

    expect(graphs.map((graph) => graph.name), ['Reverse fly', 'Reverse fly']);
    expect(graphs.map((graph) => graph.category).toSet(), {
      'Back',
      'Shoulders',
    });
    expect(graphs.map((graph) => graph.selectionKey).toSet(), hasLength(2));
    expect(graphs.singleWhere((graph) => graph.category == 'Back').weight, 40);
    expect(
      graphs.singleWhere((graph) => graph.category == 'Shoulders').weight,
      12,
    );
  });

  test('a personal best is judged within its own category', () async {
    await insertExerciseSetFixture(
      db,
      'Reverse fly',
      category: 'Back',
      weight: 40,
    );
    await insertExerciseSetFixture(
      db,
      'Reverse fly',
      category: 'Shoulders',
      weight: 10,
      created: testNow.add(const Duration(days: 1)),
    );
    final heavierShoulders = await insertExerciseSetFixture(
      db,
      'Reverse fly',
      category: 'Shoulders',
      weight: 15,
      created: testNow.add(const Duration(days: 2)),
    );
    final lighterShoulders = await insertExerciseSetFixture(
      db,
      'Reverse fly',
      category: 'Shoulders',
      weight: 5,
      created: testNow.add(const Duration(days: 3)),
    );

    expect(await isBestExerciseSet(db, heavierShoulders), isTrue);
    expect(await isBestExerciseSet(db, lighterShoulders), isFalse);
  });

  test('rep pace estimates are kept per category', () async {
    final now = DateTime.now();
    for (final (category, reps) in [('Back', 6.0), ('Shoulders', 8.0)]) {
      await insertExerciseSetFixture(
        db,
        'Reverse fly',
        category: category,
        weight: 20,
        reps: reps,
        created: now.subtract(const Duration(minutes: 10)),
      );
      await insertExerciseSetFixture(
        db,
        'Reverse fly',
        category: category,
        weight: 20,
        reps: reps,
        created: now.subtract(const Duration(minutes: 8)),
      );
    }

    final rpms = await getRpms();

    expect(
      {for (final rpm in rpms) rpm.exercise: rpm.rpm},
      {_back: closeTo(3, 0.01), _shoulders: closeTo(4, 0.01)},
    );
  });
}
