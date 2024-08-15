import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/graph/cardio_data.dart';
import 'package:flexify/graph/strength_data.dart';
import 'package:flexify/main.dart';

const inclineAdjustedPace = CustomExpression<double>(
  "SUM(distance) * POW(1.1, AVG(incline)) / SUM(duration)",
);

double getCardio(TypedResult row, CardioMetric metric) {
  switch (metric) {
    case CardioMetric.pace:
      return row.read(db.gymSets.distance.sum() / db.gymSets.duration.sum()) ??
          0;
    case CardioMetric.distance:
      return row.read(db.gymSets.distance.sum())!;
    case CardioMetric.duration:
      return row.read(db.gymSets.duration.sum())!;
    case CardioMetric.incline:
      return row.read(db.gymSets.incline.avg())!;
    case CardioMetric.inclineAdjustedPace:
      return row.read(inclineAdjustedPace)!;
  }
}

final ormCol = db.gymSets.weight /
    (const Variable(1.0278) - const Variable(0.0278) * db.gymSets.reps);
const volumeCol = CustomExpression<double>("ROUND(SUM(weight * reps), 2)");
final relativeCol = db.gymSets.weight.max() / db.gymSets.bodyWeight;

Future<List<StrengthData>> getStrengthData({
  required String targetUnit,
  required String name,
  required StrengthMetric metric,
  required Period period,
  required DateTime? startDate,
  required DateTime? endDate,
}) async {
  Expression<String> createdCol = getCreated(period);

  var query = (db.selectOnly(db.gymSets)
    ..addColumns([
      db.gymSets.weight.max(),
      volumeCol,
      ormCol,
      db.gymSets.created,
      if (metric == StrengthMetric.bestReps) db.gymSets.reps.max(),
      if (metric != StrengthMetric.bestReps) db.gymSets.reps,
      db.gymSets.unit,
      relativeCol,
    ])
    ..where(db.gymSets.name.equals(name))
    ..where(db.gymSets.hidden.equals(false))
    ..orderBy([
      OrderingTerm(
        expression: createdCol,
        mode: OrderingMode.desc,
      ),
    ])
    ..limit(11)
    ..groupBy([createdCol]));

  if (startDate != null)
    query = query
      ..where(
        db.gymSets.created.isBiggerOrEqualValue(startDate),
      );
  if (endDate != null)
    query = query
      ..where(
        db.gymSets.created.isSmallerThanValue(endDate),
      );

  final results = await query.get();

  List<StrengthData> list = [];
  for (final result in results.reversed) {
    final unit = result.read(db.gymSets.unit)!;
    var value = getStrength(result, metric);

    if (unit == 'lb' && targetUnit == 'kg') {
      value *= 0.45359237;
    } else if (unit == 'kg' && targetUnit == 'lb') {
      value *= 2.20462262;
    }

    double reps = 0.0;
    try {
      reps = result.read(db.gymSets.reps)!;
    } catch (_) {}

    list.add(
      StrengthData(
        created: result.read(db.gymSets.created)!.toLocal(),
        value: value,
        unit: unit,
        reps: reps,
      ),
    );
  }

  return list;
}

double getStrength(TypedResult row, StrengthMetric metric) {
  switch (metric) {
    case StrengthMetric.oneRepMax:
      return row.read(ormCol)!;
    case StrengthMetric.volume:
      return row.read(volumeCol)!;
    case StrengthMetric.relativeStrength:
      return row.read(relativeCol) ?? 0;
    case StrengthMetric.bestWeight:
      return row.read(db.gymSets.weight.max())!;
    case StrengthMetric.bestReps:
      try {
        return row.read(db.gymSets.reps.max())!;
      } catch (error) {
        return 0;
      }
  }
}

Future<List<CardioData>> getCardioData({
  Period period = Period.day,
  String name = "",
  CardioMetric metric = CardioMetric.pace,
  String targetUnit = "km",
  DateTime? startDate,
  DateTime? endDate,
}) async {
  Expression<String> createdCol = getCreated(period);

  final results = await (db.selectOnly(db.gymSets)
        ..addColumns([
          db.gymSets.duration.sum(),
          db.gymSets.distance.sum(),
          db.gymSets.distance.sum() / db.gymSets.duration.sum(),
          db.gymSets.incline.avg(),
          inclineAdjustedPace,
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
            expression: createdCol,
            mode: OrderingMode.desc,
          ),
        ])
        ..limit(11)
        ..groupBy([createdCol]))
      .get();

  List<CardioData> list = [];

  for (final result in results.reversed) {
    var value = getCardio(result, metric);
    final unit = result.read(db.gymSets.unit)!;

    if (unit == 'km' && targetUnit == 'mi') {
      value /= 1.609;
    } else if (unit == 'mi' && targetUnit == 'km') {
      value *= 1.609;
    } else if (unit == 'm' && targetUnit == 'km') {
      value /= 1000;
    } else if (unit == 'km' && targetUnit == 'm') {
      value *= 1000;
    } else if (unit == 'm' && targetUnit == 'mi') {
      value /= 1609.34;
    } else if (unit == 'mi' && targetUnit == 'm') {
      value *= 1609.34;
    }

    list.add(
      CardioData(
        created: result.read(db.gymSets.created)!.toLocal(),
        value: double.parse(value.toStringAsFixed(2)),
        unit: targetUnit,
      ),
    );
  }

  return list;
}

typedef Rpm = ({String name, double rpm, double weight});

Future<List<Rpm>> getRpms() async {
  final results = await db.customSelect("""
    WITH time_diffs AS (
      SELECT
        name,
        reps,
        ((created - LAG(created) OVER (PARTITION BY name ORDER BY created)) / 60.0) as time_diff,
        weight
      FROM gym_sets
      WHERE created >= strftime('%s', 'now') - 60*60*24*30
        AND cardio = false
    ),
    reps_per_min AS (
      SELECT
        name,
        (reps / time_diff) as rpm,
        weight
      FROM time_diffs
      WHERE time_diff IS NOT NULL
        AND time_diff <= 5
    )
    SELECT
      name,
      AVG(rpm) as rpm,
      weight
    FROM reps_per_min
    WHERE rpm IS NOT NULL
    GROUP BY name, weight;
  """).get();
  return results
      .map(
        (result) => (
          name: result.read<String>('name'),
          rpm: result.read<double>('rpm'),
          weight: result.read<double>('weight')
        ),
      )
      .toList();
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
          db.gymSets.image,
          db.gymSets.category,
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
                image: Value(result.read(db.gymSets.image)),
                category: Value(result.read(db.gymSets.category)),
              ),
            )
            .toList(),
      );
}

Expression<String> getCreated(Period groupBy) {
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
  IntColumn get planId => integer().nullable()();
  RealColumn get reps => real()();
  IntColumn get restMs => integer().nullable()();
  TextColumn get unit => text()();
  RealColumn get weight => real()();
}
