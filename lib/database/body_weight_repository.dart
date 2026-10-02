import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';

double displayBodyWeight(String unit, double weightKg) {
  return switch (unit) {
    'lb' => weightKg / 0.45359237,
    'stone' => weightKg / 6.35029318,
    _ => weightKg,
  };
}

double? canonicalBodyWeightKg(String unit, double value) {
  return switch (unit) {
    'kg' => value,
    'lb' => value * 0.45359237,
    'stone' => value * 6.35029318,
    _ => null,
  };
}

Future<BodyWeight?> getLatestBodyWeight(AppDatabase database) {
  return (database.bodyWeights.select()
        ..orderBy([
          (row) =>
              OrderingTerm(expression: row.timestamp, mode: OrderingMode.desc),
          (row) => OrderingTerm(expression: row.id, mode: OrderingMode.desc),
        ])
        ..limit(1))
      .getSingleOrNull();
}

Future<List<BodyWeight>> getBodyWeightHistory(
  AppDatabase database, {
  int limit = 20,
}) {
  return (database.bodyWeights.select()
        ..orderBy([
          (row) =>
              OrderingTerm(expression: row.timestamp, mode: OrderingMode.desc),
          (row) => OrderingTerm(expression: row.id, mode: OrderingMode.desc),
        ])
        ..limit(limit))
      .get();
}

Future<int> recordBodyWeight(
  AppDatabase database, {
  required DateTime timestamp,
  required double weightKg,
  String? photo,
}) {
  return database.bodyWeights.insertOne(
    BodyWeightsCompanion.insert(
      timestamp: timestamp,
      weightKg: weightKg,
      photo: Value(photo),
    ),
  );
}
