import 'package:drift/drift.dart';
import 'package:flexify/database/plans.dart';

/// A concrete workout session, optionally started from a plan.
@TableIndex.sql(
  'CREATE INDEX workouts_plan_ended_started '
  'ON workouts (plan_id, ended_at, started_at DESC, id DESC)',
)
@TableIndex.sql(
  'CREATE UNIQUE INDEX workouts_active_plan ON workouts (plan_id) '
  'WHERE ended_at IS NULL AND plan_id IS NOT NULL',
)
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
