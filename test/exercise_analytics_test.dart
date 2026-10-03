import 'package:flexify/constants.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';
import 'support/fixtures.dart';

void main() {
  setUp(() {
    db = testDb();
  });

  tearDown(() => db.close());

  test('strength analytics normalize mixed units and survive rename', () async {
    await insertExerciseSetFixture(
      db,
      'Bench old',
      reps: 5,
      weight: 100,
      unit: 'kg',
      bodyWeight: 80,
      category: 'Chest',
      created: testNow,
    );
    await insertExerciseSetFixture(
      db,
      'Bench old',
      reps: 10,
      weight: 220.462262,
      unit: 'lb',
      bodyWeight: 176.36981,
      category: 'Chest',
      created: testNow.add(const Duration(minutes: 1)),
    );

    final exercise = await getExerciseByName('Bench old');
    await updateExerciseDefinition(
      exerciseId: exercise!.id,
      name: 'Bench renamed',
      cardio: false,
      displayUnit: 'lb',
      category: 'Chest',
    );

    final bestWeight = await getStrengthData(
      target: 'kg',
      name: 'Bench renamed',
      metric: StrengthMetric.bestWeight,
      period: Period.day,
      start: testNow.subtract(const Duration(days: 1)),
      end: testNow.add(const Duration(days: 1)),
      limit: 20,
    );
    final bestReps = await getStrengthData(
      target: 'kg',
      name: 'Bench renamed',
      metric: StrengthMetric.bestReps,
      period: Period.day,
      start: null,
      end: null,
      limit: 20,
    );
    final volume = await getStrengthData(
      target: 'kg',
      name: 'Bench renamed',
      metric: StrengthMetric.volume,
      period: Period.day,
      start: null,
      end: null,
      limit: 20,
    );
    final oneRepMax = await getStrengthData(
      target: 'kg',
      name: 'Bench renamed',
      metric: StrengthMetric.oneRepMax,
      period: Period.day,
      start: null,
      end: null,
      limit: 20,
    );
    final relative = await getStrengthData(
      target: 'kg',
      name: 'Bench renamed',
      metric: StrengthMetric.relativeStrength,
      period: Period.day,
      start: null,
      end: null,
      limit: 20,
    );

    expect(bestWeight.single.value, closeTo(100, 0.0001));
    expect(bestReps.single.value, 10);
    expect(volume.single.value, closeTo(1500, 0.01));
    expect(oneRepMax.single.value, closeTo(133.37, 0.02));
    expect(relative.single.value, closeTo(1.25, 0.0001));
    expect(
      await getStrengthData(
        target: 'kg',
        name: 'Bench old',
        metric: StrengthMetric.bestWeight,
        period: Period.day,
        start: null,
        end: null,
        limit: 20,
      ),
      isEmpty,
    );

    final global = await getGlobalData(
      target: 'kg',
      metric: StrengthMetric.volume,
      period: Period.day,
      start: null,
      end: null,
      limit: 20,
    );
    expect(global.single.category, 'Chest');
    expect(global.single.value, closeTo(1500, 0.01));

    final summary = (await watchGraphs().first).singleWhere(
      (row) => row.exerciseId == exercise.id,
    );
    expect(summary.name, 'Bench renamed');
    expect(summary.unit, 'lb');
  });

  test(
    'cardio analytics normalize distance, incline, load and duration',
    () async {
      await insertExerciseSetFixture(
        db,
        'Run',
        cardio: true,
        unit: 'km',
        distance: 1,
        duration: 5,
        incline: 2,
        created: testNow,
      );
      await insertExerciseSetFixture(
        db,
        'Run',
        cardio: true,
        unit: 'mi',
        distance: 0.621371192,
        duration: 5,
        incline: 4,
        created: testNow.add(const Duration(minutes: 1)),
      );

      Future<double> runMetric(CardioMetric metric) async {
        final data = await getCardioData(
          target: 'km',
          name: 'Run',
          metric: metric,
          period: Period.day,
          start: null,
          end: null,
        );
        return data.single.value;
      }

      expect(await runMetric(CardioMetric.distance), closeTo(2, 0.01));
      expect(await runMetric(CardioMetric.duration), 10);
      expect(await runMetric(CardioMetric.pace), closeTo(0.2, 0.01));
      expect(await runMetric(CardioMetric.incline), 3);
      expect(await runMetric(CardioMetric.inclineAdjustedPace), 0.27);

      await insertExerciseSetFixture(
        db,
        'Sled',
        cardio: true,
        unit: 'kg',
        weight: 50,
        duration: 1,
        created: testNow,
      );
      await insertExerciseSetFixture(
        db,
        'Sled',
        cardio: true,
        unit: 'lb',
        weight: 132.277357,
        duration: 2,
        created: testNow.add(const Duration(minutes: 1)),
      );

      final weighted = await getCardioData(
        target: 'kg',
        name: 'Sled',
        metric: CardioMetric.weight,
        period: Period.day,
        start: null,
        end: null,
      );
      final timed = await getCardioData(
        target: 'kg',
        name: 'Sled',
        metric: CardioMetric.duration,
        period: Period.day,
        start: null,
        end: null,
      );

      expect(weighted.single.value, closeTo(60, 0.01));
      expect(timed.single.value, 3);
    },
  );

  test('RPM and best-set detection read redesigned exercise sets', () async {
    final now = DateTime.now().toLocal();
    final first = await insertExerciseSetFixture(
      db,
      'Curl',
      reps: 4,
      weight: 50,
      created: now.subtract(const Duration(minutes: 2)),
    );
    final second = await insertExerciseSetFixture(
      db,
      'Curl',
      reps: 6,
      weight: 50,
      created: now.subtract(const Duration(minutes: 1)),
    );

    final rpms = await getRpms();
    final rpm = rpms.singleWhere((row) => row.name == 'Curl');
    expect(rpm.rpm, closeTo(6, 0.01));
    expect(await isBestExerciseSet(db, first), isFalse);
    expect(await isBestExerciseSet(db, second), isTrue);
  });
}
