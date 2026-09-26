import 'package:drift/drift.dart';

/// Stores per-exercise settings: graph display preferences and exercise notes.
///
/// Rows are keyed by exercise name and category, because the same name in two
/// categories is a separate exercise. An empty [category] stores an
/// uncategorized exercise, since primary key columns cannot rely on `NULL`.
class GraphPreferences extends Table {
  TextColumn get name => text()();
  TextColumn get category => text().withDefault(const Constant(''))();
  TextColumn get metric => text().withDefault(const Constant('bestWeight'))();
  TextColumn get period => text().withDefault(const Constant('day'))();
  IntColumn get limit => integer().withDefault(const Constant(20))();
  BoolColumn get timeBasedXAxis =>
      boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {name, category};
}
