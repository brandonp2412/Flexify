import 'package:drift/drift.dart';

/// Stores per-exercise settings: graph display preferences and exercise notes.
class GraphPreferences extends Table {
  TextColumn get name => text()();
  TextColumn get metric => text().withDefault(const Constant('bestWeight'))();
  TextColumn get period => text().withDefault(const Constant('day'))();
  IntColumn get limit => integer().withDefault(const Constant(20))();
  BoolColumn get timeBasedXAxis =>
      boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {name};
}
