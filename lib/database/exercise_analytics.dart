import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:flexify/constants.dart';
import 'package:flexify/database/body_weight_repository.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/graph/cardio_data.dart';
import 'package:flexify/graph/strength_data.dart';
import 'package:flexify/main.dart';

class GraphExerciseSummary {
  const GraphExerciseSummary({
    required this.exerciseId,
    required this.bodyWeight,
    required this.name,
    required this.unit,
    required this.cardio,
    required this.weight,
    required this.reps,
    required this.duration,
    required this.distance,
    required this.created,
    this.image,
    this.category,
  });

  final int? exerciseId;
  final bool bodyWeight;
  final String name;

  String get selectionKey =>
      bodyWeight ? 'body-weight' : 'exercise:$exerciseId';
  final String unit;
  final bool cardio;
  final double weight;
  final double reps;
  final double duration;
  final double distance;
  final DateTime created;
  final String? image;
  final String? category;
}

typedef Rpm = ({String name, double rpm, double weight});

String _periodKey(DateTime value, Period period) {
  final date = value.toLocal();
  switch (period) {
    case Period.day:
      return '${date.year}-${date.month}-${date.day}';
    case Period.month:
      return '${date.year}-${date.month}';
    case Period.year:
      return '${date.year}';
    case Period.week:
      final jan1 = DateTime(date.year);
      final dayOfYear = date.difference(jan1).inDays;
      final firstMondayOffset = (8 - jan1.weekday) % 7;
      final week = dayOfYear < firstMondayOffset
          ? 0
          : 1 + ((dayOfYear - firstMondayOffset) ~/ 7);
      return '${date.year}-$week';
  }
}

String _categoryPeriodKey(String category, DateTime created, Period period) =>
    '$category\u0000${_periodKey(created, period)}';

DateTime _periodStart(DateTime value, Period period) {
  final date = value.toLocal();
  switch (period) {
    case Period.day:
      return DateTime(date.year, date.month, date.day);
    case Period.month:
      return DateTime(date.year, date.month);
    case Period.year:
      return DateTime(date.year);
    case Period.week:
      final jan1 = DateTime(date.year);
      final firstMonday = jan1.add(Duration(days: (8 - jan1.weekday) % 7));
      if (date.isBefore(firstMonday)) return jan1;
      final week = date.difference(firstMonday).inDays ~/ 7;
      return DateTime(
        firstMonday.year,
        firstMonday.month,
        firstMonday.day + week * 7,
      );
  }
}

Future<({Set<String> keys, DateTime? cutoff})> _latestGlobalBuckets({
  required Period period,
  required DateTime? start,
  required DateTime? end,
  required int limit,
}) async {
  if (limit <= 0) return (keys: <String>{}, cutoff: null);

  const pageSize = 256;
  final keys = <String>{};
  DateTime? cutoff;
  var offset = 0;

  while (keys.length < limit) {
    final query = db.selectOnly(db.exerciseSets)
      ..join([
        innerJoin(
          db.exercises,
          db.exercises.id.equalsExp(db.exerciseSets.exerciseId),
        ),
        innerJoin(
          db.categories,
          db.categories.id.equalsExp(db.exercises.categoryId),
        ),
      ])
      ..addColumns([
        db.exerciseSets.id,
        db.exerciseSets.timestamp,
        db.categories.name,
      ])
      ..orderBy([
        OrderingTerm.desc(db.exerciseSets.timestamp),
        OrderingTerm.desc(db.exerciseSets.id),
      ])
      ..limit(pageSize, offset: offset);

    if (start != null) {
      query.where(db.exerciseSets.timestamp.isBiggerOrEqualValue(start));
    }
    if (end != null) {
      query.where(db.exerciseSets.timestamp.isSmallerThanValue(end));
    }

    final rows = await query.get();
    if (rows.isEmpty) break;

    for (final row in rows) {
      final created = row.read(db.exerciseSets.timestamp)!;
      final category = row.read(db.categories.name)!;
      final key = _categoryPeriodKey(category, created, period);
      if (!keys.add(key)) continue;

      final bucketStart = _periodStart(created, period);
      if (cutoff == null || bucketStart.isBefore(cutoff)) {
        cutoff = bucketStart;
      }
      if (keys.length == limit) break;
    }

    if (rows.length < pageSize || keys.length == limit) break;
    offset += rows.length;
  }

  return (keys: keys, cutoff: cutoff);
}

List<List<ExerciseSetView>> _groupSets(
  Iterable<ExerciseSetView> sets,
  Period period,
  int limit,
) {
  final grouped = <String, List<ExerciseSetView>>{};
  for (final set in sets) {
    grouped.putIfAbsent(_periodKey(set.created, period), () => []).add(set);
  }

  final groups = grouped.values.toList();
  for (final group in groups) {
    group.sort((a, b) => a.created.compareTo(b.created));
  }
  groups.sort((a, b) => b.last.created.compareTo(a.last.created));
  return groups.take(limit).toList().reversed.toList();
}

double _loadInUnit(ExerciseSetView set, String target) {
  final kg = canonicalExerciseSetLoad(set.unit, set.weight);
  return displayLoad(target, kg);
}

double _distanceInUnit(ExerciseSetView set, String target) {
  final metres = canonicalExerciseSetDistance(set.unit, set.distance);
  return displayDistance(target, metres);
}

double _oneRepMax(double weight, double reps) {
  final factor = 1.0278 - 0.0278 * reps;
  if (factor == 0) return 0;
  return weight >= 0 ? weight / factor : weight * factor;
}

ExerciseSetView _latest(List<ExerciseSetView> sets) =>
    sets.reduce((a, b) => a.created.isAfter(b.created) ? a : b);

ExerciseSetView _bestWeightSet(List<ExerciseSetView> sets, String target) {
  return sets.reduce((a, b) {
    final aWeight = _loadInUnit(a, target);
    final bWeight = _loadInUnit(b, target);
    if (bWeight > aWeight) return b;
    if (bWeight == aWeight && b.reps > a.reps) return b;
    return a;
  });
}

ExerciseSetView _bestRepsSet(List<ExerciseSetView> sets) {
  return sets.reduce((a, b) {
    if (b.reps > a.reps) return b;
    if (b.reps == a.reps && b.weight > a.weight) return b;
    return a;
  });
}

ExerciseSetView _bestOneRepMaxSet(List<ExerciseSetView> sets, String target) {
  return sets.reduce((a, b) {
    final aOrm = _oneRepMax(_loadInUnit(a, target), a.reps);
    final bOrm = _oneRepMax(_loadInUnit(b, target), b.reps);
    return bOrm > aOrm ? b : a;
  });
}

ExerciseSetView _bestRelativeSet(List<ExerciseSetView> sets) {
  return sets.reduce((a, b) {
    if (b.weight > a.weight) return b;
    if (b.weight == a.weight && b.reps > a.reps) return b;
    return a;
  });
}

StrengthData _strengthBucket(
  List<ExerciseSetView> sets, {
  required StrengthMetric metric,
  required String target,
  String? category,
}) {
  late final ExerciseSetView representative;
  late final double value;

  switch (metric) {
    case StrengthMetric.bestWeight:
      representative = _bestWeightSet(sets, target);
      value = _loadInUnit(representative, target);
      break;
    case StrengthMetric.bestReps:
      representative = _bestRepsSet(sets);
      value = representative.reps;
      break;
    case StrengthMetric.oneRepMax:
      representative = _bestOneRepMaxSet(sets, target);
      value = _oneRepMax(
        _loadInUnit(representative, target),
        representative.reps,
      );
      break;
    case StrengthMetric.volume:
      representative = _latest(sets);
      final volume = sets.fold<double>(
        0,
        (sum, set) => sum + _loadInUnit(set, target) * set.reps,
      );
      value = double.parse(volume.toStringAsFixed(2));
      break;
    case StrengthMetric.relativeStrength:
      representative = _bestRelativeSet(sets);
      value = representative.bodyWeight == 0
          ? 0
          : representative.weight / representative.bodyWeight;
      break;
  }

  return StrengthData(
    created: representative.created,
    value: value,
    unit: target,
    reps: representative.reps,
    category: category,
  );
}

Future<List<StrengthData>> getBodyWeightData({
  required String target,
  required Period period,
  required DateTime? start,
  required DateTime? end,
  required int limit,
}) async {
  final query = db.bodyWeights.select()
    ..orderBy([
      (row) => OrderingTerm.asc(row.timestamp),
      (row) => OrderingTerm.asc(row.id),
    ]);
  if (start != null) {
    query.where((row) => row.timestamp.isBiggerOrEqualValue(start));
  }
  if (end != null) {
    query.where((row) => row.timestamp.isSmallerThanValue(end));
  }

  final rows = await query.get();
  final grouped = <String, List<BodyWeight>>{};
  for (final row in rows) {
    grouped.putIfAbsent(_periodKey(row.timestamp, period), () => []).add(row);
  }

  final groups = grouped.values.toList()
    ..sort((a, b) => b.last.timestamp.compareTo(a.last.timestamp));
  return groups.take(limit).toList().reversed.map((group) {
    final row = group.last;
    return StrengthData(
      created: row.timestamp.toLocal(),
      value: displayBodyWeight(target, row.weightKg),
      unit: target,
      reps: 1,
    );
  }).toList();
}

Future<List<StrengthData>> getStrengthData({
  required String target,
  required String name,
  required StrengthMetric metric,
  required Period period,
  required DateTime? start,
  required DateTime? end,
  required int limit,
}) async {
  final sets = await getExerciseSetsForExercise(
    db,
    exerciseName: name,
    startDate: start,
    endDate: end,
    order: OrderingMode.asc,
  );
  final groups = _groupSets(sets.where((set) => !set.cardio), period, limit);
  return [
    for (final group in groups)
      _strengthBucket(
        group,
        metric: metric,
        target: target,
        category: group.first.category,
      ),
  ];
}

double _averageIncline(List<ExerciseSetView> sets) {
  final values = sets
      .where((set) => set.incline != null)
      .map((set) => set.incline!.toDouble())
      .toList();
  if (values.isEmpty) return 0;
  return values.reduce((a, b) => a + b) / values.length;
}

CardioData _cardioBucket(
  List<ExerciseSetView> sets, {
  required CardioMetric metric,
  required String target,
}) {
  final representative = _latest(sets);
  final duration = sets.fold<double>(0, (sum, set) => sum + set.duration);
  final incline = _averageIncline(sets);
  late final double value;

  switch (metric) {
    case CardioMetric.pace:
      final distance = sets.fold<double>(
        0,
        (sum, set) => sum + _distanceInUnit(set, target),
      );
      value = duration == 0 ? 0 : distance / duration;
      break;
    case CardioMetric.distance:
      value = sets.fold<double>(
        0,
        (sum, set) => sum + _distanceInUnit(set, target),
      );
      break;
    case CardioMetric.duration:
      value = duration;
      break;
    case CardioMetric.incline:
      value = incline;
      break;
    case CardioMetric.inclineAdjustedPace:
      final distance = sets.fold<double>(
        0,
        (sum, set) => sum + _distanceInUnit(set, target),
      );
      final pace = duration == 0 ? 0 : distance / duration;
      value = pace * math.pow(1.1, incline).toDouble();
      break;
    case CardioMetric.weight:
      value = sets
          .map((set) => _loadInUnit(set, target))
          .fold<double>(0, math.max);
      break;
  }

  return CardioData(
    created: representative.created,
    value: double.parse(value.toStringAsFixed(2)),
    unit: target,
  );
}

Future<List<CardioData>> getCardioData({
  Period period = Period.day,
  String name = '',
  CardioMetric metric = CardioMetric.pace,
  String target = 'km',
  DateTime? start,
  DateTime? end,
  int limit = 11,
}) async {
  final sets = await getExerciseSetsForExercise(
    db,
    exerciseName: name,
    startDate: start ?? DateTime(0),
    endDate: end ?? DateTime.now().toLocal().add(const Duration(days: 1)),
    order: OrderingMode.asc,
  );
  final groups = _groupSets(sets.where((set) => set.cardio), period, limit);
  return [
    for (final group in groups)
      _cardioBucket(group, metric: metric, target: target),
  ];
}

Future<List<String?>> getCategories() {
  return (db.select(db.categories)
        ..orderBy([(category) => OrderingTerm.asc(category.name)]))
      .map((category) => category.name)
      .get();
}

Future<List<StrengthData>> getGlobalData({
  required String target,
  required StrengthMetric metric,
  required Period period,
  required DateTime? start,
  required DateTime? end,
  required int limit,
}) async {
  final window = await _latestGlobalBuckets(
    period: period,
    start: start,
    end: end,
    limit: limit,
  );
  if (window.keys.isEmpty || window.cutoff == null) return [];

  final fetchStart = start != null && start.isAfter(window.cutoff!)
      ? start
      : window.cutoff;
  final allSets = await getExerciseSets(
    db,
    startDate: fetchStart,
    endDateExclusive: end,
  );

  final buckets = <String, List<ExerciseSetView>>{};
  for (final set in allSets) {
    final category = set.category;
    if (category == null) continue;
    final key = _categoryPeriodKey(category, set.created, period);
    if (!window.keys.contains(key)) continue;
    buckets.putIfAbsent(key, () => []).add(set);
  }

  final groups = buckets.values.toList();
  for (final group in groups) {
    group.sort((a, b) => a.created.compareTo(b.created));
  }
  groups.sort((a, b) => b.last.created.compareTo(a.last.created));

  return groups.reversed
      .map(
        (group) => _strengthBucket(
          group,
          metric: metric,
          target: target,
          category: group.first.category,
        ),
      )
      .toList();
}

Future<List<Rpm>> getRpms() async {
  final cutoff = DateTime.now().subtract(const Duration(days: 30));
  final sets = await getExerciseSets(db, startDate: cutoff, cardio: false)
    ..sort((a, b) => a.created.compareTo(b.created));

  final byName = <String, List<ExerciseSetView>>{};
  for (final set in sets) {
    byName.putIfAbsent(set.name, () => []).add(set);
  }

  final grouped = <String, List<double>>{};
  final weights = <String, double>{};
  for (final entry in byName.entries) {
    ExerciseSetView? previous;
    for (final set in entry.value) {
      if (previous != null) {
        final minutes =
            set.created.difference(previous.created).inMilliseconds / 60000;
        if (minutes > 0 && minutes <= 5) {
          final rpm = set.reps / minutes;
          if (rpm >= 0.1 && rpm <= 10) {
            final key = '${entry.key}\u0000${set.weight}';
            grouped.putIfAbsent(key, () => []).add(rpm);
            weights[key] = set.weight;
          }
        }
      }
      previous = set;
    }
  }

  return grouped.entries.map((entry) {
    final split = entry.key.indexOf('\u0000');
    final values = entry.value;
    return (
      name: entry.key.substring(0, split),
      rpm: values.reduce((a, b) => a + b) / values.length,
      weight: weights[entry.key]!,
    );
  }).toList();
}

Stream<List<GraphExerciseSummary>> watchGraphs() {
  return db
      .customSelect(
        '''
          SELECT
            exercises.id AS exercise_id,
            0 AS body_weight,
            exercises.name AS name,
            exercises.display_unit AS unit,
            CASE WHEN exercises.kind = 'cardio' THEN 1 ELSE 0 END AS cardio,
            exercises.image AS image,
            categories.name AS category,
            latest.load_kg AS load_kg,
            COALESCE(latest.reps, 0) AS reps,
            latest.duration_ms AS duration_ms,
            latest.distance_metres AS distance_metres,
            latest.timestamp AS timestamp
          FROM exercises
          LEFT JOIN categories ON categories.id = exercises.category_id
          LEFT JOIN exercise_sets AS latest ON latest.id = (
            SELECT exercise_sets.id
            FROM exercise_sets
            WHERE exercise_sets.exercise_id = exercises.id
            ORDER BY exercise_sets.timestamp DESC, exercise_sets.id DESC
            LIMIT 1
          )
          WHERE exercises.archived = 0
            AND latest.id IS NOT NULL

          UNION ALL

          SELECT
            NULL AS exercise_id,
            1 AS body_weight,
            'Weight' AS name,
            'kg' AS unit,
            0 AS cardio,
            latest_weight.photo AS image,
            NULL AS category,
            latest_weight.weight_kg AS load_kg,
            1.0 AS reps,
            NULL AS duration_ms,
            NULL AS distance_metres,
            latest_weight.timestamp AS timestamp
          FROM body_weights AS latest_weight
          WHERE latest_weight.id = (
            SELECT body_weights.id
            FROM body_weights
            ORDER BY body_weights.timestamp DESC, body_weights.id DESC
            LIMIT 1
          )

          ORDER BY timestamp DESC, name COLLATE NOCASE
        ''',
        readsFrom: {
          db.exercises,
          db.categories,
          db.exerciseSets,
          db.bodyWeights,
        },
      )
      .watch()
      .map(
        (results) => results.map((result) {
          final unit = result.read<String>('unit');
          final timestamp = result.readNullable<int>('timestamp');
          return GraphExerciseSummary(
            exerciseId: result.readNullable<int>('exercise_id'),
            bodyWeight: result.read<int>('body_weight') != 0,
            name: result.read<String>('name'),
            unit: unit,
            cardio: result.read<int>('cardio') != 0,
            weight: displayLoad(unit, result.readNullable<double>('load_kg')),
            reps: result.read<double>('reps'),
            duration: (result.readNullable<int>('duration_ms') ?? 0) / 60000,
            distance: displayDistance(
              unit,
              result.readNullable<double>('distance_metres'),
            ),
            created: timestamp == null
                ? DateTime.fromMillisecondsSinceEpoch(0).toLocal()
                : DateTime.fromMillisecondsSinceEpoch(
                    timestamp * 1000,
                  ).toLocal(),
            image: result.readNullable<String>('image'),
            category: result.readNullable<String>('category'),
          );
        }).toList(),
      );
}

Future<List<ExerciseSetView>> getGraphHistory(
  String exerciseName, {
  int limit = 20,
}) {
  return getExerciseSetsForExercise(
    db,
    exerciseName: exerciseName,
    limit: limit,
  );
}

Future<List<ExerciseSetView>> getBodyWeightGraphHistory({
  int limit = 20,
}) async {
  final rows = await getBodyWeightHistory(db, limit: limit);
  return rows
      .map(
        (row) => ExerciseSetView(
          id: row.id,
          bodyWeight: 0,
          cardio: false,
          created: row.timestamp.toLocal(),
          distance: 0,
          duration: 0,
          image: row.photo,
          name: 'Weight',
          reps: 1,
          unit: 'kg',
          weight: row.weightKg,
        ),
      )
      .toList();
}

Future<ExerciseSetView?> getGraphPointSet(
  String exerciseName,
  DateTime timestamp,
) {
  return getExerciseSetForExerciseAt(
    db,
    exerciseName: exerciseName,
    timestamp: timestamp,
  );
}

Future<int> countGraphSets(Iterable<String> exerciseNames) {
  return countExerciseSetsForExercises(db, exerciseNames);
}
