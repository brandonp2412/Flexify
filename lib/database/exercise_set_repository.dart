import 'package:drift/drift.dart';
import 'package:flexify/database/body_weight_repository.dart';
import 'package:flexify/database/database.dart';

/// Converts a stored load in kilograms to the exercise display unit.
double displayLoad(String unit, double? loadKg) {
  if (loadKg == null) return 0;
  return switch (unit) {
    'lb' => loadKg / 0.45359237,
    'stone' => loadKg / 6.35029318,
    _ => loadKg,
  };
}

/// Converts a displayed load to kilograms.
double? loadKg(String unit, double value) {
  return switch (unit) {
    'kg' => value,
    'lb' => value * 0.45359237,
    'stone' => value * 6.35029318,
    _ => null,
  };
}

/// Converts a stored distance in metres to the exercise display unit.
double displayDistance(String unit, double? distanceMetres) {
  if (distanceMetres == null) return 0;
  return switch (unit) {
    'km' => distanceMetres / 1000,
    'mi' => distanceMetres / 1609.344,
    _ => distanceMetres,
  };
}

/// Converts a displayed distance to metres.
double? distanceMetres(String unit, double value) {
  return switch (unit) {
    'm' => value,
    'km' => value * 1000,
    'mi' => value * 1609.344,
    _ => null,
  };
}

ExerciseSetView _toExerciseSetView(AppDatabase database, TypedResult row) {
  final set = row.readTable(database.exerciseSets);
  final exercise = row.readTable(database.exercises);
  final category = row.readTableOrNull(database.categories);
  final workout = row.readTableOrNull(database.workouts);
  final unit = exercise.displayUnit;

  return ExerciseSetView(
    id: set.id,
    bodyWeight: set.bodyWeightKg == null
        ? 0
        : displayBodyWeight(unit, set.bodyWeightKg!),
    cardio: exercise.kind == 'cardio',
    category: category?.name,
    created: set.timestamp.toLocal(),
    distance: displayDistance(unit, set.distanceMetres),
    duration: (set.durationMs ?? 0) / 60000,
    image: exercise.image,
    incline: set.incline?.round(),
    name: exercise.name,
    notes: set.notes,
    planId: workout?.planId,
    reps: set.reps ?? 0,
    restMs: exercise.defaultRestDurationMs,
    unit: unit,
    weight: displayLoad(unit, set.loadKg),
  );
}

JoinedSelectStatement<HasResultSet, dynamic> _exerciseSetQuery(
  AppDatabase database, {
  OrderingMode order = OrderingMode.desc,
}) {
  return database.select(database.exerciseSets).join([
    innerJoin(
      database.exercises,
      database.exercises.id.equalsExp(database.exerciseSets.exerciseId),
    ),
    leftOuterJoin(
      database.categories,
      database.categories.id.equalsExp(database.exercises.categoryId),
    ),
    leftOuterJoin(
      database.workouts,
      database.workouts.id.equalsExp(database.exerciseSets.workoutId),
    ),
  ])..orderBy([
    OrderingTerm(expression: database.exerciseSets.timestamp, mode: order),
    OrderingTerm(expression: database.exerciseSets.id, mode: order),
  ]);
}

JoinedSelectStatement<HasResultSet, dynamic> _filteredExerciseSetQuery(
  AppDatabase database, {
  String search = '',
  String? category,
  DateTime? startDate,
  DateTime? endDate,
  DateTime? endDateExclusive,
  Iterable<int>? ids,
  bool? cardio,
  double? repsGt,
  double? repsLt,
  double? weightGt,
  double? weightLt,
  int? limit,
}) {
  final query = _exerciseSetQuery(database);
  final sets = database.exerciseSets;
  final exercises = database.exercises;
  for (final term
      in search.toLowerCase().split(' ').where((term) => term.isNotEmpty)) {
    query.where(exercises.name.lower().contains(term));
  }
  if (category != null) query.where(database.categories.name.equals(category));
  if (startDate != null)
    query.where(sets.timestamp.isBiggerOrEqualValue(startDate));
  if (endDate != null)
    query.where(sets.timestamp.isSmallerOrEqualValue(endDate));
  if (endDateExclusive != null)
    query.where(sets.timestamp.isSmallerThanValue(endDateExclusive));
  if (ids != null) query.where(sets.id.isIn(ids));
  if (cardio != null) {
    query.where(exercises.kind.equals(cardio ? 'cardio' : 'strength'));
  }

  // History's numeric filters apply to strength sets only, in displayed units.
  final isCardio = exercises.kind.equals('cardio');
  final reps = ifNull(sets.reps, const Constant(0.0));
  final load = ifNull(sets.loadKg, const Constant(0.0));
  final weight = exercises.displayUnit.caseMatch<double>(
    when: {
      const Constant('lb'): load / const Constant(0.45359237),
      const Constant('stone'): load / const Constant(6.35029318),
    },
    orElse: load,
  );
  if (repsGt != null) query.where(isCardio | reps.isBiggerThanValue(repsGt));
  if (repsLt != null) query.where(isCardio | reps.isSmallerThanValue(repsLt));
  if (weightGt != null)
    query.where(isCardio | weight.isBiggerThanValue(weightGt));
  if (weightLt != null)
    query.where(isCardio | weight.isSmallerThanValue(weightLt));
  if (limit != null) query.limit(limit);
  return query;
}

/// Watches exercise sets projected with exercise metadata for history UI.
Stream<List<ExerciseSetView>> watchExerciseSets(
  AppDatabase database, {
  String search = '',
  String? category,
  DateTime? startDate,
  DateTime? endDate,
  double? repsGt,
  double? repsLt,
  double? weightGt,
  double? weightLt,
  int? limit,
}) {
  return _filteredExerciseSetQuery(
    database,
    search: search,
    category: category,
    startDate: startDate,
    endDate: endDate,
    repsGt: repsGt,
    repsLt: repsLt,
    weightGt: weightGt,
    weightLt: weightLt,
    limit: limit,
  ).watch().map(
    (rows) => rows.map((row) => _toExerciseSetView(database, row)).toList(),
  );
}

/// Loads exercise sets projected with exercise metadata.
Future<List<ExerciseSetView>> getExerciseSets(
  AppDatabase database, {
  String search = '',
  String? category,
  DateTime? startDate,
  DateTime? endDate,
  DateTime? endDateExclusive,
  bool? cardio,
  double? repsGt,
  double? repsLt,
  double? weightGt,
  double? weightLt,
  int? limit,
}) async {
  final rows = await _filteredExerciseSetQuery(
    database,
    search: search,
    category: category,
    startDate: startDate,
    endDate: endDate,
    endDateExclusive: endDateExclusive,
    cardio: cardio,
    repsGt: repsGt,
    repsLt: repsLt,
    weightGt: weightGt,
    weightLt: weightLt,
    limit: limit,
  ).get();
  return rows.map((row) => _toExerciseSetView(database, row)).toList();
}

/// Loads only the requested exercise-set identifiers.
Future<List<ExerciseSetView>> getExerciseSetsByIds(
  AppDatabase database,
  Iterable<int> ids,
) async {
  final values = ids.toList();
  if (values.isEmpty) return [];
  final rows = await _filteredExerciseSetQuery(database, ids: values).get();
  return rows.map((row) => _toExerciseSetView(database, row)).toList();
}

Future<List<ExerciseSetView>> getExerciseSetsForExercise(
  AppDatabase database, {
  required String exerciseName,
  DateTime? startDate,
  DateTime? endDate,
  int? limit,
  OrderingMode order = OrderingMode.desc,
}) async {
  final query = _exerciseSetQuery(database, order: order)
    ..where(database.exercises.name.equals(exerciseName));

  if (startDate != null) {
    query.where(
      database.exerciseSets.timestamp.isBiggerOrEqualValue(startDate),
    );
  }
  if (endDate != null) {
    query.where(database.exerciseSets.timestamp.isSmallerThanValue(endDate));
  }
  if (limit != null) query.limit(limit);

  final rows = await query.get();
  return rows.map((row) => _toExerciseSetView(database, row)).toList();
}

class PreviousExerciseSet {
  const PreviousExerciseSet({
    required this.cardio,
    required this.unit,
    required this.reps,
    required this.weight,
    required this.distance,
    required this.duration,
    required this.incline,
  });

  final bool cardio;
  final String unit;
  final double reps;
  final double weight;
  final double distance;
  final double duration;
  final int? incline;
}

class PreviousExerciseDay {
  const PreviousExerciseDay({required this.day, required this.sets});

  final DateTime day;
  final List<PreviousExerciseSet> sets;
}

Stream<Map<int, PreviousExerciseDay>> watchPreviousExerciseDays(
  AppDatabase database,
  int planId, {
  DateTime? now,
}) {
  final reference = now?.toLocal();
  final startOfToday = reference == null
      ? null
      : DateTime(reference.year, reference.month, reference.day);
  final cutoff = startOfToday == null
      ? "CAST(strftime('%s', date('now', 'localtime'), 'utc') AS INTEGER)"
      : '?';

  return database
      .customSelect(
        '''
        WITH latest_days AS (
          SELECT pe.exercise_id,
                 date(MAX(s.timestamp), 'unixepoch', 'localtime') AS day
          FROM plan_exercises pe
          JOIN exercise_sets s ON s.exercise_id = pe.exercise_id
          WHERE pe.plan_id = ? AND pe.enabled = 1 AND s.timestamp < $cutoff
          GROUP BY pe.exercise_id
        )
        SELECT latest_days.exercise_id AS exercise_id, latest_days.day AS day,
               s.reps AS reps, s.load_kg AS load_kg,
               s.distance_metres AS distance_metres,
               s.duration_ms AS duration_ms, s.incline AS incline,
               e.kind AS kind, e.display_unit AS unit
        FROM latest_days
        JOIN exercise_sets s ON s.exercise_id = latest_days.exercise_id
          AND s.timestamp >= CAST(strftime('%s', latest_days.day, 'utc') AS INTEGER)
          AND s.timestamp < CAST(strftime('%s', date(latest_days.day, '+1 day'), 'utc') AS INTEGER)
        JOIN exercises e ON e.id = s.exercise_id
        ORDER BY s.timestamp, s.id
        ''',
        variables: [
          Variable(planId),
          if (startOfToday != null)
            Variable(startOfToday.millisecondsSinceEpoch ~/ 1000),
        ],
        readsFrom: {
          database.planExercises,
          database.exerciseSets,
          database.exercises,
        },
      )
      .watch()
      .map((rows) {
        final grouped = <int, PreviousExerciseDay>{};
        for (final row in rows) {
          final exerciseId = row.read<int>('exercise_id');
          final unit = row.read<String>('unit');
          final day = grouped.putIfAbsent(
            exerciseId,
            () => PreviousExerciseDay(
              day: DateTime.parse(row.read<String>('day')),
              sets: [],
            ),
          );
          day.sets.add(
            PreviousExerciseSet(
              cardio: row.read<String>('kind') == 'cardio',
              unit: unit,
              reps: row.read<double?>('reps') ?? 0,
              weight: displayLoad(unit, row.read<double?>('load_kg')),
              distance: displayDistance(
                unit,
                row.read<double?>('distance_metres'),
              ),
              duration: (row.read<int?>('duration_ms') ?? 0) / 60000,
              incline: row.read<double?>('incline')?.round(),
            ),
          );
        }
        return grouped;
      });
}

Future<ExerciseSetView?> getExerciseSetForExerciseAt(
  AppDatabase database, {
  required String exerciseName,
  required DateTime timestamp,
}) async {
  final query = _exerciseSetQuery(database)
    ..where(database.exercises.name.equals(exerciseName))
    ..where(database.exerciseSets.timestamp.equals(timestamp))
    ..limit(1);
  final row = await query.getSingleOrNull();
  return row == null ? null : _toExerciseSetView(database, row);
}

Future<int> countExerciseSetsForExercises(
  AppDatabase database,
  Iterable<String> exerciseNames,
) async {
  final names = exerciseNames.toList();
  if (names.isEmpty) return 0;

  final count = database.exerciseSets.id.count();
  final row =
      await (database.selectOnly(database.exerciseSets)
            ..join([
              innerJoin(
                database.exercises,
                database.exercises.id.equalsExp(
                  database.exerciseSets.exerciseId,
                ),
              ),
            ])
            ..addColumns([count])
            ..where(database.exercises.name.isIn(names)))
          .getSingle();
  return row.read(count) ?? 0;
}

/// Loads one exercise set by its exercise_sets identifier.
Future<ExerciseSetView?> getExerciseSetById(
  AppDatabase database,
  int id,
) async {
  final query = _exerciseSetQuery(database)
    ..where(database.exerciseSets.id.equals(id));
  final row = await query.getSingleOrNull();
  return row == null ? null : _toExerciseSetView(database, row);
}

/// Loads the latest exercise set for an exercise name.
Future<ExerciseSetView?> getLatestExerciseSet(
  AppDatabase database, {
  required String exerciseName,
}) async {
  final query = _exerciseSetQuery(database)
    ..where(database.exercises.name.equals(exerciseName))
    ..limit(1);
  final row = await query.getSingleOrNull();
  return row == null ? null : _toExerciseSetView(database, row);
}

/// Loads the latest exercise set for an exercise in one workout.
Future<ExerciseSetView?> getLatestWorkoutExerciseSet(
  AppDatabase database, {
  required int workoutId,
  required int exerciseId,
}) async {
  final query = _exerciseSetQuery(database)
    ..where(
      database.exerciseSets.workoutId.equals(workoutId) &
          database.exerciseSets.exerciseId.equals(exerciseId),
    )
    ..limit(1);
  final row = await query.getSingleOrNull();
  return row == null ? null : _toExerciseSetView(database, row);
}

/// Watches exercise sets for one exercise in one workout.
Stream<List<ExerciseSetView>> watchWorkoutExerciseSets(
  AppDatabase database, {
  required int workoutId,
  required int exerciseId,
}) {
  final query = _exerciseSetQuery(database, order: OrderingMode.asc)
    ..where(
      database.exerciseSets.workoutId.equals(workoutId) &
          database.exerciseSets.exerciseId.equals(exerciseId),
    );
  return query.watch().map(
    (rows) => rows.map((row) => _toExerciseSetView(database, row)).toList(),
  );
}

/// Inserts one exercise set into exercise_sets only.
Future<ExerciseSetView> insertExerciseSet(
  AppDatabase database, {
  required ExerciseSetView exerciseSet,
  required int exerciseId,
  int? workoutId,
  double? bodyWeightKg,
}) async {
  final storedWeightKg =
      bodyWeightKg ??
      (exerciseSet.bodyWeight == 0
          ? null
          : toKg(exerciseSet.unit, exerciseSet.bodyWeight)) ??
      (await getLatestBodyWeight(database))?.weightKg;

  final id = await database.exerciseSets.insertOne(
    ExerciseSetsCompanion.insert(
      exerciseId: exerciseId,
      workoutId: Value(workoutId),
      timestamp: exerciseSet.created,
      reps: Value(exerciseSet.reps),
      loadKg: Value(loadKg(exerciseSet.unit, exerciseSet.weight)),
      durationMs: Value((exerciseSet.duration * 60000).round()),
      distanceMetres: Value(
        distanceMetres(exerciseSet.unit, exerciseSet.distance),
      ),
      incline: Value(exerciseSet.incline?.toDouble()),
      bodyWeightKg: Value(storedWeightKg),
      notes: Value(exerciseSet.notes),
    ),
  );
  return (await getExerciseSetById(database, id))!;
}

/// Updates per-performance data and exercise identity in exercise_sets only.
Future<void> updateExerciseSet(
  AppDatabase database, {
  required int id,
  required ExerciseSetView exerciseSet,
  required int exerciseId,
  double? bodyWeightKg,
}) {
  return (database.exerciseSets.update()..where((set) => set.id.equals(id)))
      .write(
        ExerciseSetsCompanion(
          exerciseId: Value(exerciseId),
          timestamp: Value(exerciseSet.created),
          reps: Value(exerciseSet.reps),
          loadKg: Value(loadKg(exerciseSet.unit, exerciseSet.weight)),
          durationMs: Value((exerciseSet.duration * 60000).round()),
          distanceMetres: Value(
            distanceMetres(exerciseSet.unit, exerciseSet.distance),
          ),
          incline: Value(exerciseSet.incline?.toDouble()),
          bodyWeightKg: Value(
            bodyWeightKg ??
                (exerciseSet.bodyWeight == 0
                    ? null
                    : toKg(exerciseSet.unit, exerciseSet.bodyWeight)),
          ),
          notes: Value(exerciseSet.notes),
        ),
      );
}

/// Deletes exercise sets by exercise_sets identifiers.
Future<int> deleteExerciseSets(AppDatabase database, Iterable<int> ids) {
  final values = ids.toList();
  if (values.isEmpty) return Future.value(0);
  return (database.exerciseSets.delete()..where((set) => set.id.isIn(values)))
      .go();
}

/// Compares a set against prior exercise sets for positive reinforcement.
Future<bool> isBestExerciseSet(
  AppDatabase database,
  ExerciseSetView exerciseSet,
) async {
  final exercise =
      await (database.exercises.select()
            ..where((row) => row.name.equals(exerciseSet.name))
            ..limit(1))
          .getSingleOrNull();
  if (exercise == null) return false;

  final previous = database.exerciseSets.select()
    ..where(
      (set) =>
          set.exerciseId.equals(exercise.id) &
          set.id.isNotValue(exerciseSet.id),
    );

  if (exerciseSet.cardio &&
      const {'kg', 'lb', 'stone'}.contains(exerciseSet.unit)) {
    final best =
        await (previous
              ..orderBy([
                (set) =>
                    OrderingTerm.desc(ifNull(set.loadKg, const Constant(0.0))),
                (set) => OrderingTerm.desc(
                  ifNull(set.durationMs, const Constant(0)),
                ),
              ])
              ..limit(1))
            .getSingleOrNull();
    if (best == null) return false;
    final bestWeight = displayLoad(exerciseSet.unit, best.loadKg);
    final bestDuration = (best.durationMs ?? 0) / 60000;
    return exerciseSet.weight > bestWeight ||
        (exerciseSet.weight == bestWeight &&
            exerciseSet.duration > bestDuration);
  }

  if (exerciseSet.cardio) {
    if (exerciseSet.duration == 0) return false;
    final candidates = await previous.get();
    var bestPace = 0.0;
    var found = false;
    for (final candidate in candidates) {
      final duration = (candidate.durationMs ?? 0) / 60000;
      if (duration <= 0) continue;
      final pace =
          displayDistance(exerciseSet.unit, candidate.distanceMetres) /
          duration;
      if (!found || pace > bestPace) {
        bestPace = pace;
        found = true;
      }
    }
    return found && exerciseSet.distance / exerciseSet.duration > bestPace;
  }

  final best =
      await (previous
            ..orderBy([
              (set) =>
                  OrderingTerm.desc(ifNull(set.loadKg, const Constant(0.0))),
              (set) => OrderingTerm.desc(ifNull(set.reps, const Constant(0.0))),
            ])
            ..limit(1))
          .getSingleOrNull();
  if (best == null) return false;
  final bestWeight = displayLoad(exerciseSet.unit, best.loadKg);
  final bestReps = best.reps ?? 0;
  return exerciseSet.weight > bestWeight ||
      (exerciseSet.weight == bestWeight && exerciseSet.reps > bestReps);
}
