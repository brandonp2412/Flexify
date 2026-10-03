import 'package:drift/drift.dart';
import 'package:flexify/database/exercises.dart';
import 'package:flexify/database/plans.dart';

@TableIndex(
  name: 'plan_exercises_plan_exercise',
  columns: {#planId, #exerciseId},
  unique: true,
)
@TableIndex(name: 'plan_exercises_exercise_id', columns: {#exerciseId})
class PlanExercises extends Table {
  BoolColumn get enabled => boolean()();
  BoolColumn get timers => boolean().withDefault(const Constant(true))();
  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.cascade)();
  IntColumn get id => integer().autoIncrement()();
  IntColumn get maxSets => integer().nullable()();
  IntColumn get planId => integer().references(Plans, #id)();
  IntColumn get warmupSets => integer().nullable()();
  IntColumn get sequence => integer().withDefault(const Constant(0))();
}
