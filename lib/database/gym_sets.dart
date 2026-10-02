import 'package:drift/drift.dart';
import 'package:flexify/main.dart';

/// Legacy storage kept temporarily for migration/compatibility readers.
/// New performed-set writes and analytics use [ExerciseSets] joined to [Exercises].
class GymSets extends Table {
  RealColumn get bodyWeight => real().withDefault(const Constant(0.0))();
  BoolColumn get cardio => boolean().withDefault(const Constant(false))();
  TextColumn get category => text().nullable()();
  DateTimeColumn get created => dateTime()();
  RealColumn get distance => real().withDefault(const Constant(0.0))();
  RealColumn get duration => real().withDefault(const Constant(0.0))();
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();
  IntColumn get id => integer().autoIncrement()();
  TextColumn get image => text().nullable()();
  IntColumn get incline => integer().nullable()();
  TextColumn get name => text()();
  TextColumn get notes => text().nullable()();
  IntColumn get planId => integer().nullable()();
  RealColumn get reps => real()();
  IntColumn get restMs => integer().nullable()();
  TextColumn get unit => text()();
  RealColumn get weight => real()();
}

Stream<List<String>> getCategoriesStream() {
  return (db.select(
    db.categories,
  )..orderBy([(category) => OrderingTerm.asc(category.name)])).watch().map(
    (categories) => categories.map((category) => category.name).toList(),
  );
}
