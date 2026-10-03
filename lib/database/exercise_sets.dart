import 'package:drift/drift.dart';
import 'package:flexify/database/exercises.dart';
import 'package:flexify/database/workouts.dart';

/// One exercise set with metrics stored in canonical units.
@TableIndex(name: 'exercise_sets_timestamp', columns: {#timestamp, #id})
@TableIndex.sql(
  'CREATE INDEX exercise_sets_exercise_timestamp '
  'ON exercise_sets (exercise_id, timestamp DESC, id DESC)',
)
@TableIndex.sql(
  'CREATE INDEX exercise_sets_workout_exercise '
  'ON exercise_sets (workout_id, exercise_id, timestamp, id)',
)
class ExerciseSets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get workoutId => integer().nullable().references(
    Workouts,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get reps => real().nullable()();
  RealColumn get loadKg => real().nullable()();
  IntColumn get durationMs => integer().nullable()();
  RealColumn get distanceMetres => real().nullable()();
  RealColumn get incline => real().nullable()();
  RealColumn get bodyWeightKg => real().nullable()();
  TextColumn get notes => text().nullable()();
}
