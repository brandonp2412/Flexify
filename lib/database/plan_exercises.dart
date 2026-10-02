import 'package:drift/drift.dart';
import 'package:flexify/database/exercises.dart';
import 'package:flexify/database/plans.dart';

class PlanExercises extends Table {
  BoolColumn get enabled => boolean()();
  BoolColumn get timers => boolean().withDefault(const Constant(true))();
  TextColumn get exercise => text()();
  IntColumn get exerciseId => integer().nullable().references(
    Exercises,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get id => integer().autoIncrement()();
  IntColumn get maxSets => integer().nullable()();
  IntColumn get planId => integer().references(Plans, #id)();
  IntColumn get warmupSets => integer().nullable()();
  IntColumn get sequence => integer().withDefault(const Constant(0))();
}
