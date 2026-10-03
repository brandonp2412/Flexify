import 'package:drift/drift.dart';
import 'package:flexify/database/categories.dart';

/// Stable exercise identity and configuration shared across plans and history.
@TableIndex(name: 'exercises_category_id', columns: {#categoryId})
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
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
