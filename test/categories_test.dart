import 'package:drift/drift.dart' hide isNull;
import 'package:flexify/database/categories.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_catalog.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_tests.dart';
import 'support/fixtures.dart';

void main() {
  setUp(() => db = testDb());

  Future<(Exercise, ExerciseSetView)> seedChestSet() async {
    await createCategory('Chest');
    final exercise = await createExerciseDefinition(
      name: 'Bench press',
      cardio: false,
      displayUnit: 'kg',
      category: 'Chest',
    );
    final set = await insertExerciseSetFixture(
      db,
      exercise.name,
      reps: 5,
      weight: 80,
      category: 'Chest',
    );
    return (exercise, set);
  }

  test(
    'renaming a category keeps exercise and history linked by stable id',
    () async {
      final (exercise, _) = await seedChestSet();
      final category =
          await (db.categories.select()
                ..where((category) => category.name.equals('Chest')))
              .getSingle();

      await renameCategory(category, 'Upper body');

      final updated = await getExerciseById(exercise.id);
      expect(await getExerciseCategoryName(updated!), 'Upper body');
      final history = await getExerciseSets(db, search: 'Bench press');
      expect(history.single.category, 'Upper body');
    },
  );

  test(
    'merging a category moves exercise definitions and joined history',
    () async {
      final (exercise, _) = await seedChestSet();
      await createCategory('Upper body');
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
      final history = await getExerciseSets(db, search: 'Bench press');
      expect(history.single.category, 'Upper body');
    },
  );

  test(
    'deleting a category clears it from exercise and joined history',
    () async {
      final (exercise, _) = await seedChestSet();
      await deleteCategory(
        await (db.categories.select()
              ..where((category) => category.name.equals('Chest')))
            .getSingle(),
      );

      expect((await getExerciseById(exercise.id))!.categoryId, isNull);
      final history = await getExerciseSets(db, search: 'Bench press');
      expect(history.single.category, isNull);
    },
  );
}
