import 'package:drift/drift.dart';
import 'package:flexify/cardio_data.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database.dart';
import 'package:flexify/main.dart';

class GymSets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get reps => real()();
  RealColumn get weight => real()();
  TextColumn get unit => text()();
  DateTimeColumn get created => dateTime()();
  BoolColumn get hidden => boolean().withDefault(const Constant(false))();
  RealColumn get bodyWeight => real().withDefault(const Constant(0.0))();
  RealColumn get duration => real().withDefault(const Constant(0.0))();
  RealColumn get distance => real().withDefault(const Constant(0.0))();
  BoolColumn get cardio => boolean().withDefault(const Constant(false))();
  IntColumn get restMs => integer().nullable()();
  IntColumn get maxSets => integer().nullable()();
  IntColumn get incline => integer().nullable()();
}

double _getValue(TypedResult row, CardioMetric metric) {
  switch (metric) {
    case CardioMetric.pace:
      return row.read(db.gymSets.distance.sum() / db.gymSets.duration.sum()) ??
          0;
    case CardioMetric.distance:
      return row.read(db.gymSets.distance.sum())!;
    case CardioMetric.duration:
      return row.read(db.gymSets.duration.sum())!;
  }
}

Expression<String> _getCreated(Period groupBy) {
  switch (groupBy) {
    case Period.day:
      return const CustomExpression<String>(
        "STRFTIME('%Y-%m-%d', DATE(created, 'unixepoch', 'localtime'))",
      );
    case Period.week:
      return const CustomExpression<String>(
        "STRFTIME('%Y-%m-%W', DATE(created, 'unixepoch', 'localtime'))",
      );
    case Period.month:
      return const CustomExpression<String>(
        "STRFTIME('%Y-%m', DATE(created, 'unixepoch', 'localtime'))",
      );
    case Period.year:
      return const CustomExpression<String>(
        "STRFTIME('%Y', DATE(created, 'unixepoch', 'localtime'))",
      );
  }
}

Stream<List<CardioData>> watchCardio({
  Period groupBy = Period.day,
  String name = "",
  CardioMetric metric = CardioMetric.pace,
  DateTime? startDate,
  DateTime? endDate,
}) {
  return (db.selectOnly(db.gymSets)
        ..addColumns([
          db.gymSets.duration.sum(),
          db.gymSets.distance.sum(),
          db.gymSets.distance.sum() / db.gymSets.duration.sum(),
          db.gymSets.created,
          db.gymSets.unit,
        ])
        ..where(db.gymSets.name.equals(name))
        ..where(db.gymSets.hidden.equals(false))
        ..where(
          db.gymSets.created.isBiggerOrEqualValue(startDate ?? DateTime(0)),
        )
        ..where(
          db.gymSets.created.isSmallerThanValue(
            endDate ?? DateTime.now().toLocal().add(const Duration(days: 1)),
          ),
        )
        ..orderBy([
          OrderingTerm(
            expression: db.gymSets.created.date,
            mode: OrderingMode.desc,
          ),
        ])
        ..limit(11)
        ..groupBy([_getCreated(groupBy)]))
      .watch()
      .map(
    (results) {
      List<CardioData> list = [];
      for (final result in results.reversed) {
        list.add(
          CardioData(
            created: result.read(db.gymSets.created)!,
            value: double.parse(_getValue(result, metric).toStringAsFixed(2)),
            unit: result.read(db.gymSets.unit)!,
          ),
        );
      }
      return list;
    },
  );
}

Stream<List<GymSetsCompanion>> watchGraphs() {
  return (db.gymSets.selectOnly()
        ..addColumns([
          db.gymSets.name,
          db.gymSets.unit,
          db.gymSets.weight,
          db.gymSets.reps,
          db.gymSets.cardio,
          db.gymSets.duration,
          db.gymSets.distance,
          db.gymSets.created.max(),
        ])
        ..orderBy([
          OrderingTerm(
            expression: db.gymSets.created.max(),
            mode: OrderingMode.desc,
          ),
        ])
        ..groupBy([db.gymSets.name]))
      .watch()
      .map(
        (results) => results
            .map(
              (result) => GymSetsCompanion(
                name: Value(result.read(db.gymSets.name)!),
                weight: Value(result.read(db.gymSets.weight)!),
                unit: Value(result.read(db.gymSets.unit)!),
                reps: Value(result.read(db.gymSets.reps)!),
                cardio: Value(result.read(db.gymSets.cardio)!),
                duration: Value(result.read(db.gymSets.duration)!),
                distance: Value(result.read(db.gymSets.distance)!),
                created: Value(result.read(db.gymSets.created.max())!),
              ),
            )
            .toList(),
      );
}

typedef GymCount = ({
  int count,
  String name,
  int? maxSets,
  int? restMs,
});

Stream<List<GymCount>> watchCount(List<String> exercises) {
  const countColumn = CustomExpression<int>(
    """
      COUNT(
        CASE WHEN DATE(created, 'unixepoch', 'localtime') = DATE('now') 
          AND hidden = 0 THEN 1 END
      )
      """,
  );

  return (db.selectOnly(db.gymSets)
        ..addColumns([
          db.gymSets.name,
          countColumn,
          db.gymSets.maxSets,
          db.gymSets.restMs,
        ])
        ..where(db.gymSets.name.isIn(exercises))
        ..groupBy([db.gymSets.name]))
      .watch()
      .map(
        (results) => results
            .map(
              (resultRow) => (
                count: resultRow.read<int>(countColumn)!,
                name: resultRow.read(db.gymSets.name)!,
                maxSets: resultRow.read(db.gymSets.maxSets),
                restMs: resultRow.read(db.gymSets.restMs),
              ),
            )
            .toList(),
      );
}
