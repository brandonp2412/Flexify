import 'package:drift/drift.dart' hide isNull;
import 'package:flexify/database/categories.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';

void main() {
  setUp(() => db = testDb());

  test('renaming a category keeps exercise usage by stable id', () async {
    await createCategory('Chest');
    final exercise = await createExerciseDefinition(
      name: 'Bench press',
      cardio: false,
      displayUnit: 'kg',
      category: 'Chest',
    );
    await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: exercise.name,
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

    final updated = await getExerciseById(exercise.id);
    expect(await getExerciseCategoryName(updated!), 'Upper body');
    expect(
      (await (db.gymSets.select()
                ..where((set) => set.name.equals('Bench press')))
              .getSingle())
          .category,
      'Chest',
    );
  });

  test('merging a category moves exercise definitions only', () async {
    await createCategory('Chest');
    await createCategory('Upper body');
    final exercise = await createExerciseDefinition(
      name: 'Bench press',
      cardio: false,
      displayUnit: 'kg',
      category: 'Chest',
    );
    await db.gymSets.insertOne(
      GymSetsCompanion.insert(
        name: exercise.name,
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

    final updated = await getExerciseById(exercise.id);
    expect(updated!.categoryId, upperBody.id);
    expect(
      (await (db.gymSets.select()
                ..where((set) => set.name.equals('Bench press')))
              .getSingle())
          .category,
      'Chest',
    );
  });

  test(
    'deleting a category clears it from exercise definitions only',
    () async {
      await createCategory('Chest');
      final exercise = await createExerciseDefinition(
        name: 'Bench press',
        cardio: false,
        displayUnit: 'kg',
        category: 'Chest',
      );
      await db.gymSets.insertOne(
        GymSetsCompanion.insert(
          name: exercise.name,
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

      expect((await getExerciseById(exercise.id))!.categoryId, isNull);
      expect(
        (await (db.gymSets.select()
                  ..where((set) => set.name.equals('Bench press')))
                .getSingle())
            .category,
        'Chest',
      );
    },
  );
}
