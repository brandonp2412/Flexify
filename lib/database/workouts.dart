import 'package:drift/drift.dart';
import 'package:flexify/database/plans.dart';

/// A concrete workout session, optionally started from a plan.
class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer().nullable().references(
    Plans,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
}
