import 'package:drift/drift.dart';

/// A timestamped body-weight measurement stored canonically in kilograms.
class BodyWeights extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get weightKg => real()();
  TextColumn get photo => text().nullable()();
}
