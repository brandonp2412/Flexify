import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  db = AppDatabase(executor: NativeDatabase.memory());

  test('gym sets can be created', () async {
    final id = await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 5,
        weight: 20,
        unit: 'kg',
        created: DateTime.now(),
      ),
    );
    expect(id, greaterThan(0));
  });

  test('gym sets can be read', () async {
    final id = await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 5,
        weight: 20,
        unit: 'kg',
        created: DateTime.now(),
      ),
    );
    final gymSet = await (db.gymSets.select()
          ..where((u) => u.id.equals(id))
          ..limit(1))
        .getSingle();
    expect(gymSet.name, 'Bench press');
  });

  test('gym sets can be updated', () async {
    final id = await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 5,
        weight: 20,
        unit: 'kg',
        created: DateTime.now(),
      ),
    );
    final gymSet = await (db.gymSets.select()
          ..where((u) => u.id.equals(id))
          ..limit(1))
        .getSingle();
    await (db.gymSets.update()..where((u) => u.id.equals(id))).write(
      gymSet.copyWith(
        name: 'New name',
      ),
    );
    final updatedSet = await (db.gymSets.select()
          ..where((u) => u.id.equals(id))
          ..limit(1))
        .getSingle();
    expect(updatedSet.name, 'New name');
  });

  test('gym sets can be deleted', () async {
    final id = await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 5,
        weight: 20,
        unit: 'kg',
        created: DateTime.now(),
      ),
    );
    await (db.gymSets.deleteWhere((tbl) => tbl.id.equals(id)));
    final gymSet = await (db.gymSets.select()
          ..where((u) => u.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
    expect(gymSet, null);
  });
}
