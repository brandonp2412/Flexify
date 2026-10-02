import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';

/// Stores the reusable category names available for workout entries.
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

/// A category and the number of workout entries currently using it.
class CategorySummary {
  const CategorySummary({required this.category, required this.usageCount});

  final Category category;
  final int usageCount;
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

/// Removes [category] and clears it from every workout entry using it.
Future<void> deleteCategory(Category category) {
  return db.transaction(() async {
    await (db.exercises.update()
          ..where((exercise) => exercise.categoryId.equals(category.id)))
        .write(const ExercisesCompanion(categoryId: Value(null)));
    await (db.categories.delete()
          ..where((entry) => entry.id.equals(category.id)))
        .go();
  });
}

/// Moves entries using [source] to [target], then removes [source].
Future<void> mergeCategory(Category source, Category target) {
  return db.transaction(() async {
    await (db.exercises.update()
          ..where((exercise) => exercise.categoryId.equals(source.id)))
        .write(ExercisesCompanion(categoryId: Value(target.id)));
    await (db.categories.delete()..where((entry) => entry.id.equals(source.id)))
        .go();
  });
}

/// Renames [category] everywhere it is used.
Future<void> renameCategory(Category category, String name) {
  final trimmedName = name.trim();
  if (trimmedName == category.name) return Future.value();

  return (db.categories.update()
        ..where((entry) => entry.id.equals(category.id)))
      .write(CategoriesCompanion(name: Value(trimmedName)));
}

/// Watches all categories together with their workout-entry usage counts.
Stream<List<CategorySummary>> watchCategorySummaries() {
  return db
      .customSelect(
        '''
          SELECT categories.id, categories.name, COUNT(exercises.id) AS usage_count
          FROM categories
          LEFT JOIN exercises ON exercises.category_id = categories.id
            AND exercises.archived = 0
          GROUP BY categories.id, categories.name
          ORDER BY categories.name COLLATE NOCASE
        ''',
        readsFrom: {db.categories, db.exercises},
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
              ),
            )
            .toList(),
      );
}

Stream<List<String>> getCategoriesStream() {
  return (db.select(
    db.categories,
  )..orderBy([(category) => OrderingTerm.asc(category.name)])).watch().map(
    (categories) => categories.map((category) => category.name).toList(),
  );
}
