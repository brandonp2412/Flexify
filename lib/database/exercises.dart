import 'package:drift/drift.dart';
import 'package:flexify/database/categories.dart';

/// Stable exercise identity and configuration shared across plans and history.
///
/// A name is unique within a category, so the same name can exist once per
/// category. Uncategorized exercises share one namespace, which is why the
/// unique index coalesces a missing category id instead of relying on a
/// composite unique key: SQLite treats NULLs in unique keys as distinct.
@TableIndex(name: 'exercises_category_id', columns: {#categoryId})
@TableIndex.sql(
  'CREATE UNIQUE INDEX exercises_name_category '
  'ON exercises (name, COALESCE(category_id, 0))',
)
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get kind => text()();
  TextColumn get displayUnit => text()();
  IntColumn get categoryId => integer().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get image => text().nullable()();
  IntColumn get defaultRestDurationMs => integer().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get graphMetric =>
      text().withDefault(const Constant('bestWeight'))();
  TextColumn get graphPeriod => text().withDefault(const Constant('day'))();
  IntColumn get graphLimit => integer().withDefault(const Constant(20))();
  BoolColumn get graphTimeBasedXAxis =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}
