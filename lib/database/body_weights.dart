import 'package:drift/drift.dart';

/// A timestamped body-weight measurement stored canonically in kilograms.
@TableIndex.sql(
  'CREATE INDEX body_weights_timestamp '
  'ON body_weights (timestamp DESC, id DESC)',
)
class BodyWeights extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get weightKg => real()();
  TextColumn get photo => text().nullable()();
}
