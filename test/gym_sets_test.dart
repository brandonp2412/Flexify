import 'package:drift/drift.dart' hide isNull;
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';
import 'support/fixtures.dart';

void main() {
  setUp(() => db = testDb());

  Future<int> insertSet() async {
    final exercise = await ensureExerciseFixture(db, 'Bench press');
    return db.exerciseSets.insertOne(
      ExerciseSetsCompanion.insert(
        exerciseId: exercise.id,
        timestamp: DateTime(2026, 10, 3, 8),
        reps: const Value(5),
        loadKg: const Value(20),
      ),
    );
  }

  test('exercise sets can be created', () async {
    final id = await insertSet();
    expect(id, greaterThan(0));
  });

  test('exercise sets can be read', () async {
    final id = await insertSet();
    final set =
        await (db.exerciseSets.select()
              ..where((row) => row.id.equals(id))
              ..limit(1))
            .getSingle();
    expect(set.reps, 5);
    expect(set.loadKg, 20);
  });

  test('exercise sets can be updated', () async {
    final id = await insertSet();
    await (db.exerciseSets.update()..where((row) => row.id.equals(id))).write(
      const ExerciseSetsCompanion(reps: Value(6), loadKg: Value(25)),
    );
    final updated =
        await (db.exerciseSets.select()
              ..where((row) => row.id.equals(id))
              ..limit(1))
            .getSingle();
    expect(updated.reps, 6);
    expect(updated.loadKg, 25);
  });

  test('exercise sets can be deleted', () async {
    final id = await insertSet();
    await db.exerciseSets.deleteWhere((row) => row.id.equals(id));
    final set =
        await (db.exerciseSets.select()
              ..where((row) => row.id.equals(id))
              ..limit(1))
            .getSingleOrNull();
    expect(set, isNull);
  });
}
