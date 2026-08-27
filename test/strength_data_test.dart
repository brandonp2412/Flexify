import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';
import 'support/fixtures.dart';

void main() {
  setUp(() {
    db = testDb();
  });

  test('getStrengthData converts best weight to the requested unit', () async {
    await db.gymSets.insertOne(
      gymSetFixture('Bench press', reps: 5, weight: 100),
    );

    final data = await getStrengthData(
      target: 'lb',
      name: 'Bench press',
      metric: StrengthMetric.bestWeight,
      period: Period.day,
      start: testNow.subtract(const Duration(days: 1)),
      end: testNow.add(const Duration(days: 1)),
      limit: 11,
    );

    expect(data, hasLength(1));
    expect(data.single.value, closeTo(220.462262, 0.000001));
  });

  test('getStrengthData calculates daily volume in the query layer', () async {
    await db.gymSets.insertAll([
      gymSetFixture('Bench press', reps: 5, weight: 100),
      gymSetFixture(
        'Bench press',
        reps: 10,
        weight: 50,
        created: testNow.add(const Duration(minutes: 1)),
      ),
    ]);

    final data = await getStrengthData(
      target: 'kg',
      name: 'Bench press',
      metric: StrengthMetric.volume,
      period: Period.day,
      start: testNow.subtract(const Duration(days: 1)),
      end: testNow.add(const Duration(days: 1)),
      limit: 11,
    );

    expect(data, hasLength(1));
    expect(data.single.value, 1000);
  });
}
