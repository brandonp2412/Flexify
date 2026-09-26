import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';

/// Stores the reusable category names available for workout entries.
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

/// A category with the number of workout entries and distinct exercises
/// currently using it.
class CategorySummary {
  const CategorySummary({
    required this.category,
    required this.usageCount,
    required this.exerciseCount,
  });

  final Category category;
  final int usageCount;
  final int exerciseCount;
}

/// Adds [name] if it is not already available.
Future<void> createCategory(String name) {
  return db
      .into(db.categories)
      .insert(
        CategoriesCompanion.insert(name: name.trim()),
        mode: InsertMode.insertOrIgnore,
      );
}

/// Moves every set, plan entry, and graph preference in category [from] to
/// category [to], where a null [to] leaves them uncategorized.
///
/// Exercises are identified by name and category, so this can merge two
/// exercises that share a name. Their sets combine; the graph preferences
/// already stored for the destination exercise win.
Future<void> _moveCategoryUsage(String from, String? to) async {
  await (db.gymSets.update()..where((set) => set.category.equals(from))).write(
    GymSetsCompanion(category: Value(to)),
  );
  await (db.planExercises.update()
        ..where((exercise) => exercise.category.equals(from)))
      .write(PlanExercisesCompanion(category: Value(to)));
  await db.customUpdate(
    'UPDATE OR IGNORE graph_preferences SET category = ? WHERE category = ?',
    variables: [Variable(to ?? ''), Variable(from)],
    updates: {db.graphPreferences},
  );
  await (db.graphPreferences.delete()
        ..where((preference) => preference.category.equals(from)))
      .go();
}

/// Removes [category]; exercises in it become uncategorized.
Future<void> deleteCategory(Category category) {
  return db.transaction(() async {
    await _moveCategoryUsage(category.name, null);
    await (db.categories.delete()
          ..where((entry) => entry.id.equals(category.id)))
        .go();
  });
}

/// Moves exercises in [source] to [target], then removes [source].
Future<void> mergeCategory(Category source, Category target) {
  return db.transaction(() async {
    await _moveCategoryUsage(source.name, target.name);
    await (db.categories.delete()..where((entry) => entry.id.equals(source.id)))
        .go();
  });
}

/// Renames [category] everywhere it is used.
Future<void> renameCategory(Category category, String name) {
  final trimmedName = name.trim();
  if (trimmedName == category.name) return Future.value();

  return db.transaction(() async {
    await _moveCategoryUsage(category.name, trimmedName);
    await (db.categories.update()
          ..where((entry) => entry.id.equals(category.id)))
        .write(CategoriesCompanion(name: Value(trimmedName)));
  });
}

/// Watches all categories together with their workout-entry usage counts.
Stream<List<CategorySummary>> watchCategorySummaries() {
  return db
      .customSelect(
        '''
          SELECT categories.id, categories.name,
            COUNT(gym_sets.id) AS usage_count,
            COUNT(DISTINCT gym_sets.name) AS exercise_count
          FROM categories
          LEFT JOIN gym_sets ON gym_sets.category = categories.name
          GROUP BY categories.id, categories.name
          ORDER BY categories.name COLLATE NOCASE
        ''',
        readsFrom: {db.categories, db.gymSets},
      )
      .watch()
      .map(
        (rows) => rows
            .map(
              (row) => CategorySummary(
                category: Category(
                  id: row.read<int>('id'),
                  name: row.read<String>('name'),
                ),
                usageCount: row.read<int>('usage_count'),
                exerciseCount: row.read<int>('exercise_count'),
              ),
            )
            .toList(),
      );
}

/// Watches how many distinct exercises have no category, not counting the
/// body weight log.
Stream<int> watchUncategorizedExerciseCount() {
  return db
      .customSelect(
        '''
          SELECT COUNT(DISTINCT name) AS exercise_count FROM gym_sets
          WHERE category IS NULL AND name != ?
        ''',
        variables: [const Variable(bodyWeightExercise)],
        readsFrom: {db.gymSets},
      )
      .watchSingle()
      .map((row) => row.read<int>('exercise_count'));
}
