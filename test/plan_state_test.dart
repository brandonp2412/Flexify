import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flexify/plan/plan_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  test('getGymCounts only counts sets from the current calendar day', () async {
    final planId = await db.plans.insertOne(
      PlansCompanion.insert(days: 'Monday'),
    );
    await db.planExercises.insertOne(
      PlanExercisesCompanion.insert(
        planId: planId,
        exercise: 'Bench press',
        enabled: true,
      ),
    );

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final lateLastNight = startOfToday.subtract(const Duration(hours: 1));

    GymSetsCompanion benchPress(DateTime created, {bool hidden = false}) =>
        GymSetsCompanion.insert(
          name: 'Bench press',
          reps: 5,
          weight: 100,
          unit: 'kg',
          created: created,
          hidden: Value(hidden),
          planId: Value(planId),
        );

    await db.gymSets.insertOne(benchPress(now));
    // Within a rolling 24-hour window for most of the day, but on the
    // previous calendar day, so it must not count toward today's workout:
    // https://github.com/brandonp2412/Flexify/issues/313
    await db.gymSets.insertOne(benchPress(lateLastNight));
    await db.gymSets.insertOne(benchPress(now, hidden: true));
    await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 5,
        weight: 100,
        unit: 'kg',
        created: now,
      ),
    );

    final counts = await PlanState().getGymCounts(planId);

    expect(counts, hasLength(1));
    expect(counts.single.name, 'Bench press');
    expect(counts.single.count, 1);
  });
}
