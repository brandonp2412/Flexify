import 'package:drift/drift.dart' hide isNull;
import 'package:flexify/database/categories.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';

void main() {
  setUp(() => db = testDb());

  test('renaming a category updates its workout entries', () async {
    await createCategory('Chest');
    await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 5,
        weight: 80,
        unit: 'kg',
        created: DateTime.now(),
        category: const Value('Chest'),
      ),
    );

    final category =
        await (db.categories.select()
              ..where((category) => category.name.equals('Chest')))
            .getSingle();
    await renameCategory(category, 'Upper body');

    expect(
      (await (db.gymSets.select()
                ..where((set) => set.name.equals('Bench press')))
              .getSingle())
          .category,
      'Upper body',
    );
    expect(
      (await (db.categories.select()
                ..where((category) => category.name.equals('Upper body')))
              .getSingle())
          .name,
      'Upper body',
    );
  });

  test('merging a category preserves its workout entries', () async {
    await createCategory('Chest');
    await createCategory('Upper body');
    await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 5,
        weight: 80,
        unit: 'kg',
        created: DateTime.now(),
        category: const Value('Chest'),
      ),
    );
    final chest =
        await (db.categories.select()
              ..where((category) => category.name.equals('Chest')))
            .getSingle();
    final upperBody =
        await (db.categories.select()
              ..where((category) => category.name.equals('Upper body')))
            .getSingle();

    await mergeCategory(chest, upperBody);

    expect(
      (await (db.gymSets.select()
                ..where((set) => set.name.equals('Bench press')))
              .getSingle())
          .category,
      'Upper body',
    );
    expect(
      await (db.categories.select()
            ..where((category) => category.name.equals('Chest')))
          .get(),
      isEmpty,
    );
  });

  test('deleting a category clears it from its workout entries', () async {
    await createCategory('Chest');
    await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: 'Bench press',
        reps: 5,
        weight: 80,
        unit: 'kg',
        created: DateTime.now(),
        category: const Value('Chest'),
      ),
    );

    await deleteCategory(
      await (db.categories.select()
            ..where((category) => category.name.equals('Chest')))
          .getSingle(),
    );

    expect(
      (await (db.gymSets.select()
                ..where((set) => set.name.equals('Bench press')))
              .getSingle())
          .category,
      isNull,
    );
    expect(
      await (db.categories.select()
            ..where((category) => category.name.equals('Chest')))
          .get(),
      isEmpty,
    );
  });
}
