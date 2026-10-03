import 'package:csv/csv.dart';
import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/utils.dart';

const _format = 'flexify_graphs_v2';

const _header = <String>[
  'format',
  'recordType',
  'id',
  'exerciseId',
  'workoutId',
  'name',
  'kind',
  'displayUnit',
  'category',
  'image',
  'defaultRestDurationMs',
  'notes',
  'graphMetric',
  'graphPeriod',
  'graphLimit',
  'graphTimeBasedXAxis',
  'archived',
  'timestamp',
  'reps',
  'loadKg',
  'durationMs',
  'distanceMetres',
  'incline',
  'bodyWeightKg',
  'photo',
  'planId',
  'startedAt',
  'endedAt',
];

final class GraphCsvImportException implements Exception {
  const GraphCsvImportException(this.message);

  final String message;

  @override
  String toString() => message;
}

final class GraphCsvImportResult {
  const GraphCsvImportResult({
    required this.exercises,
    required this.workouts,
    required this.exerciseSets,
    required this.bodyWeights,
  });

  final int exercises;
  final int workouts;
  final int exerciseSets;
  final int bodyWeights;
}

Future<String> exportGraphCsv(AppDatabase database) async {
  final exercises = await database.exercises.select().get();
  final categories = {
    for (final category in await database.categories.select().get())
      category.id: category.name,
  };
  final workouts = await database.workouts.select().get();
  final exerciseSets = await database.exerciseSets.select().get();
  final bodyWeights = await database.bodyWeights.select().get();

  final rows = <List<Object?>>[_header];

  for (final exercise in exercises) {
    rows.add([
      _format,
      'exercise',
      exercise.id,
      null,
      null,
      exercise.name,
      exercise.kind,
      exercise.displayUnit,
      exercise.categoryId == null ? null : categories[exercise.categoryId],
      exercise.image,
      exercise.defaultRestDurationMs,
      exercise.notes,
      exercise.graphMetric,
      exercise.graphPeriod,
      exercise.graphLimit,
      exercise.graphTimeBasedXAxis,
      exercise.archived,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    ]);
  }

  for (final workout in workouts) {
    rows.add([
      _format,
      'workout',
      workout.id,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      workout.planId,
      workout.startedAt.toIso8601String(),
      workout.endedAt?.toIso8601String(),
    ]);
  }

  for (final set in exerciseSets) {
    rows.add([
      _format,
      'exerciseSet',
      set.id,
      set.exerciseId,
      set.workoutId,
      null,
      null,
      null,
      null,
      null,
      null,
      set.notes,
      null,
      null,
      null,
      null,
      null,
      set.timestamp.toIso8601String(),
      set.reps,
      set.loadKg,
      set.durationMs,
      set.distanceMetres,
      set.incline,
      set.bodyWeightKg,
      null,
      null,
      null,
      null,
    ]);
  }

  for (final weight in bodyWeights) {
    rows.add([
      _format,
      'bodyWeight',
      weight.id,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      weight.timestamp.toIso8601String(),
      null,
      null,
      null,
      null,
      null,
      weight.weightKg,
      weight.photo,
      null,
      null,
      null,
    ]);
  }

  return CsvEncoder(lineDelimiter: "\n").convert(rows);
}

Future<GraphCsvImportResult> importGraphCsv(
  AppDatabase database,
  String csvContent,
) async {
  final rows = CsvDecoder().convert(csvContent);
  if (rows.isEmpty) {
    throw const GraphCsvImportException('CSV file is empty.');
  }
  if (rows.length <= 1) {
    throw const GraphCsvImportException('CSV needs at least one data row.');
  }

  final header = rows.first.map((value) => value.toString()).toList();
  if (header.contains('recordType') && header.contains('format')) {
    return _importV2(database, header, rows.skip(1).toList());
  }
  return _importLegacy(database, header, rows.skip(1).toList());
}

Future<GraphCsvImportResult> _importV2(
  AppDatabase database,
  List<String> header,
  List<List<dynamic>> rows,
) async {
  final records = rows.map((row) => _CsvRow(header, row)).toList();
  for (final row in records) {
    final format = row.string('format');
    if (format != _format) {
      throw GraphCsvImportException('Unsupported graph CSV format: $format.');
    }
  }

  final exerciseIds = <int, int>{};
  final workoutIds = <int, int>{};
  var exerciseCount = 0;
  var workoutCount = 0;
  var setCount = 0;
  var bodyWeightCount = 0;

  await database.transaction(() async {
    await database.exerciseSets.deleteAll();
    await database.workouts.deleteAll();
    await database.bodyWeights.deleteAll();

    for (final row in records.where(
      (row) => row.string('recordType') == 'exercise',
    )) {
      final sourceId = row.integer('id', required: true)!;
      final name = row.string('name', required: true);
      final categoryId = await _ensureCategory(
        database,
        row.nullableString('category'),
      );
      final existing =
          await (database.exercises.select()
                ..where((exercise) => exercise.name.equals(name)))
              .getSingleOrNull();

      final companion = ExercisesCompanion(
        name: Value(name),
        kind: Value(row.string('kind', required: true)),
        displayUnit: Value(row.string('displayUnit', required: true)),
        categoryId: Value(categoryId),
        image: Value(row.nullableString('image')),
        defaultRestDurationMs: Value(row.integer('defaultRestDurationMs')),
        notes: Value(row.nullableString('notes')),
        graphMetric: Value(row.string('graphMetric', fallback: 'bestWeight')),
        graphPeriod: Value(row.string('graphPeriod', fallback: 'day')),
        graphLimit: Value(row.integer('graphLimit') ?? 20),
        graphTimeBasedXAxis: Value(row.boolean('graphTimeBasedXAxis')),
        archived: Value(row.boolean('archived')),
      );

      final targetId = existing == null
          ? await database.exercises.insertOne(companion)
          : existing.id;
      if (existing != null) {
        await (database.exercises.update()
              ..where((exercise) => exercise.id.equals(existing.id)))
            .write(companion);
      }
      exerciseIds[sourceId] = targetId;
      exerciseCount++;
    }

    final existingPlanIds = {
      for (final plan in await database.plans.select().get()) plan.id,
    };
    for (final row in records.where(
      (row) => row.string('recordType') == 'workout',
    )) {
      final sourceId = row.integer('id', required: true)!;
      final sourcePlanId = row.integer('planId');
      final targetId = await database.workouts.insertOne(
        WorkoutsCompanion.insert(
          planId: Value(
            sourcePlanId != null && existingPlanIds.contains(sourcePlanId)
                ? sourcePlanId
                : null,
          ),
          startedAt: row.date('startedAt', required: true)!,
          endedAt: Value(row.date('endedAt')),
        ),
      );
      workoutIds[sourceId] = targetId;
      workoutCount++;
    }

    for (final row in records.where(
      (row) => row.string('recordType') == 'bodyWeight',
    )) {
      await database.bodyWeights.insertOne(
        BodyWeightsCompanion.insert(
          timestamp: row.date('timestamp', required: true)!,
          weightKg: row.number('bodyWeightKg', required: true)!,
          photo: Value(row.nullableString('photo')),
        ),
      );
      bodyWeightCount++;
    }

    for (final row in records.where(
      (row) => row.string('recordType') == 'exerciseSet',
    )) {
      final sourceExerciseId = row.integer('exerciseId', required: true)!;
      final exerciseId = exerciseIds[sourceExerciseId];
      if (exerciseId == null) {
        throw GraphCsvImportException(
          'Exercise set references missing exercise $sourceExerciseId.',
        );
      }
      final sourceWorkoutId = row.integer('workoutId');
      final workoutId = sourceWorkoutId == null
          ? null
          : workoutIds[sourceWorkoutId];
      if (sourceWorkoutId != null && workoutId == null) {
        throw GraphCsvImportException(
          'Exercise set references missing workout $sourceWorkoutId.',
        );
      }

      await database.exerciseSets.insertOne(
        ExerciseSetsCompanion.insert(
          exerciseId: exerciseId,
          workoutId: Value(workoutId),
          timestamp: row.date('timestamp', required: true)!,
          reps: Value(row.number('reps')),
          loadKg: Value(row.number('loadKg')),
          durationMs: Value(row.integer('durationMs')),
          distanceMetres: Value(row.number('distanceMetres')),
          incline: Value(row.number('incline')),
          bodyWeightKg: Value(row.number('bodyWeightKg')),
          notes: Value(row.nullableString('notes')),
        ),
      );
      setCount++;
    }
  });

  return GraphCsvImportResult(
    exercises: exerciseCount,
    workouts: workoutCount,
    exerciseSets: setCount,
    bodyWeights: bodyWeightCount,
  );
}

Future<GraphCsvImportResult> _importLegacy(
  AppDatabase database,
  List<String> header,
  List<List<dynamic>> rows,
) async {
  if (!header.contains('name') ||
      !header.contains('created') ||
      !header.contains('unit')) {
    throw const GraphCsvImportException('Unrecognized graph CSV columns.');
  }

  final records = rows.map((row) => _CsvRow(header, row)).toList();
  final legacyWeights =
      records
          .where(
            (row) => row.string('name') == 'Weight' && !row.boolean('hidden'),
          )
          .map(
            (row) => (
              timestamp: row.date('created', required: true)!,
              unit: row.string('unit', fallback: 'kg'),
              value: row.number('weight', required: true)!,
            ),
          )
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

  final latestWeightUnit = legacyWeights.isEmpty
      ? null
      : legacyWeights.last.unit;
  final exerciseIds = <String, int>{};
  var setCount = 0;
  var bodyWeightCount = 0;

  await database.transaction(() async {
    await database.exerciseSets.deleteAll();
    await database.workouts.deleteAll();
    await database.bodyWeights.deleteAll();

    for (final weight in legacyWeights) {
      final kg = canonicalExerciseSetLoad(weight.unit, weight.value);
      if (kg == null) continue;
      await database.bodyWeights.insertOne(
        BodyWeightsCompanion.insert(timestamp: weight.timestamp, weightKg: kg),
      );
      bodyWeightCount++;
    }

    final realRows = records.where((row) => row.string('name') != 'Weight');
    for (final row in realRows) {
      final name = row.string('name', required: true);
      if (exerciseIds.containsKey(name)) continue;

      final existing =
          await (database.exercises.select()
                ..where((exercise) => exercise.name.equals(name)))
              .getSingleOrNull();
      final kind = row.boolean('cardio') ? 'cardio' : 'strength';
      final unit = row.string('unit', fallback: kind == 'cardio' ? 'km' : 'kg');

      if (existing == null) {
        exerciseIds[name] = await database.exercises.insertOne(
          ExercisesCompanion.insert(name: name, kind: kind, displayUnit: unit),
        );
      } else {
        exerciseIds[name] = existing.id;
        await (database.exercises.update()
              ..where((exercise) => exercise.id.equals(existing.id)))
            .write(
              ExercisesCompanion(kind: Value(kind), displayUnit: Value(unit)),
            );
      }
    }

    for (final row in realRows.where((row) => !row.boolean('hidden'))) {
      final timestamp = row.date('created', required: true)!;
      final unit = row.string('unit', fallback: 'kg');
      final rawBodyWeight = row.number('bodyWeight') ?? 0;
      final bodyWeightUnit = _legacyBodyWeightUnit(
        legacyWeights,
        timestamp,
        latestWeightUnit,
      );
      final bodyWeightKg = rawBodyWeight == 0 || bodyWeightUnit == null
          ? null
          : canonicalExerciseSetLoad(bodyWeightUnit, rawBodyWeight);

      await database.exerciseSets.insertOne(
        ExerciseSetsCompanion.insert(
          exerciseId: exerciseIds[row.string('name', required: true)]!,
          timestamp: timestamp,
          reps: Value(row.number('reps')),
          loadKg: Value(
            canonicalExerciseSetLoad(unit, row.number('weight') ?? 0),
          ),
          durationMs: Value(
            row.has('duration')
                ? ((row.number('duration') ?? 0) * 60000).round()
                : null,
          ),
          distanceMetres: Value(
            row.has('distance')
                ? canonicalExerciseSetDistance(
                    unit,
                    row.number('distance') ?? 0,
                  )
                : null,
          ),
          incline: Value(row.number('incline')),
          bodyWeightKg: Value(bodyWeightKg),
        ),
      );
      setCount++;
    }
  });

  return GraphCsvImportResult(
    exercises: exerciseIds.length,
    workouts: 0,
    exerciseSets: setCount,
    bodyWeights: bodyWeightCount,
  );
}

String? _legacyBodyWeightUnit(
  List<({DateTime timestamp, String unit, double value})> weights,
  DateTime timestamp,
  String? fallback,
) {
  String? result;
  for (final weight in weights) {
    if (weight.timestamp.isAfter(timestamp)) break;
    result = weight.unit;
  }
  return result ?? fallback;
}

Future<int?> _ensureCategory(AppDatabase database, String? category) async {
  final name = category?.trim();
  if (name == null || name.isEmpty) return null;
  await database.categories.insertOne(
    CategoriesCompanion.insert(name: name),
    mode: InsertMode.insertOrIgnore,
  );
  return (await (database.categories.select()
            ..where((row) => row.name.equals(name)))
          .getSingle())
      .id;
}

final class _CsvRow {
  _CsvRow(List<String> header, List<dynamic> values)
    : _values = {
        for (var index = 0; index < header.length; index++)
          header[index]: index < values.length ? values[index] : null,
      };

  final Map<String, dynamic> _values;

  bool has(String key) => _values.containsKey(key);

  String string(String key, {bool required = false, String fallback = ''}) {
    final value = _values[key];
    if (value == null || value.toString().trim().isEmpty) {
      if (required) throw GraphCsvImportException('Missing $key.');
      return fallback;
    }
    return value.toString().trim();
  }

  String? nullableString(String key) {
    final value = string(key);
    return value.isEmpty ? null : value;
  }

  double? number(String key, {bool required = false}) {
    final value = _values[key];
    if (value == null || value.toString().trim().isEmpty) {
      if (required) throw GraphCsvImportException('Missing $key.');
      return null;
    }
    if (value is num) return value.toDouble();
    final parsed = double.tryParse(value.toString());
    if (parsed == null) {
      throw GraphCsvImportException('Invalid number for $key: $value.');
    }
    return parsed;
  }

  int? integer(String key, {bool required = false}) {
    final value = number(key, required: required);
    if (value == null) return null;
    if (value % 1 != 0) {
      throw GraphCsvImportException('Invalid integer for $key: $value.');
    }
    return value.toInt();
  }

  bool boolean(String key) {
    final value = _values[key];
    if (value is bool) return value;
    if (value is num) return value != 0;
    final normalized = value?.toString().trim().toLowerCase();
    return normalized == 'true' || normalized == '1';
  }

  DateTime? date(String key, {bool required = false}) {
    final value = _values[key];
    if (value == null || value.toString().trim().isEmpty) {
      if (required) throw GraphCsvImportException('Missing $key.');
      return null;
    }
    try {
      return parseDate(value.toString());
    } on FormatException {
      throw GraphCsvImportException('Invalid date for $key: $value.');
    }
  }
}
