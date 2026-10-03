import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flexify/constants.dart';
import 'package:flexify/database/body_weight_repository.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_analytics.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';

void main() {
  setUp(() {
    db = testDb();
  });

  tearDown(() => db.close());

  test(
    'body-weight records live only in body_weights and preserve photos',
    () async {
      final timestamp = DateTime(2026, 10, 3, 8);

      await recordBodyWeight(
        db,
        timestamp: timestamp,
        weightKg: 81.25,
        photo: '/tmp/weight.jpg',
      );

      expect(await db.bodyWeights.count().getSingle(), 1);
      expect(await db.exerciseSets.count().getSingle(), 0);

      final latest = await getLatestBodyWeight(db);
      expect(latest, isNotNull);
      expect(latest!.timestamp, timestamp);
      expect(latest.weightKg, 81.25);
      expect(latest.photo, '/tmp/weight.jpg');

      final history = await getBodyWeightHistory(db);
      expect(history, hasLength(1));
      expect(history.single.id, latest.id);

      final fakeExercise =
          await (db.exercises.select()
                ..where((row) => row.name.equals('Weight')))
              .getSingleOrNull();
      expect(fakeExercise, isNull);

      final weightSummary = (await watchGraphs().first).singleWhere(
        (summary) => summary.name == 'Weight',
      );
      expect(weightSummary.exerciseId, isNull);
      expect(weightSummary.weight, closeTo(81.25, 0.0001));
      expect(weightSummary.image, '/tmp/weight.jpg');

      final graphHistory = await getBodyWeightGraphHistory();
      expect(graphHistory, hasLength(1));
      expect(graphHistory.single.id, latest.id);
      expect(graphHistory.single.image, '/tmp/weight.jpg');
      expect(graphHistory.single.weight, 81.25);

      final graphData = await getBodyWeightData(
        target: 'lb',
        period: Period.day,
        start: null,
        end: null,
        limit: 20,
      );
      expect(graphData, hasLength(1));
      expect(graphData.single.value, closeTo(179.1257, 0.001));
    },
  );

  test('later body weight does not change exercise-set snapshot or relative strength', () async {
    final firstWeightAt = DateTime(2026, 10, 3, 8);
    final setAt = DateTime(2026, 10, 3, 9);

    await recordBodyWeight(db, timestamp: firstWeightAt, weightKg: 80);
    final exerciseId = await db.exercises.insertOne(
      ExercisesCompanion.insert(
        name: 'Snapshot bench',
        kind: 'strength',
        displayUnit: 'kg',
      ),
    );

    final inserted = await insertExerciseSet(
      db,
      exerciseId: exerciseId,
      exerciseSet: ExerciseSetView(
        id: 0,
        bodyWeight: 0,
        cardio: false,
        created: setAt,
        distance: 0,
        duration: 0,
        name: 'Snapshot bench',
        reps: 5,
        unit: 'kg',
        weight: 100,
      ),
    );

    final storedBefore =
        await (db.exerciseSets.select()
              ..where((row) => row.id.equals(inserted.id)))
            .getSingle();
    expect(storedBefore.bodyWeightKg, 80);

    final relativeBefore = await getStrengthData(
      target: 'kg',
      name: 'Snapshot bench',
      metric: StrengthMetric.relativeStrength,
      period: Period.day,
      start: null,
      end: null,
      limit: 20,
    );
    expect(relativeBefore.single.value, closeTo(1.25, 0.0001));

    await recordBodyWeight(
      db,
      timestamp: DateTime(2026, 10, 3, 20),
      weightKg: 90,
    );

    final storedAfter =
        await (db.exerciseSets.select()
              ..where((row) => row.id.equals(inserted.id)))
            .getSingle();
    expect(storedAfter.bodyWeightKg, 80);

    final relativeAfter = await getStrengthData(
      target: 'kg',
      name: 'Snapshot bench',
      metric: StrengthMetric.relativeStrength,
      period: Period.day,
      start: null,
      end: null,
      limit: 20,
    );
    expect(relativeAfter.single.value, closeTo(1.25, 0.0001));
    expect(relativeAfter.single.value, relativeBefore.single.value);
  });
}
