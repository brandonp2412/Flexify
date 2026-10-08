import 'package:drift/drift.dart';
import 'package:flexify/database/body_weight_repository.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_key.dart';

/// Converts a stored canonical load to the exercise display unit.
double displayLoad(String unit, double? loadKg) {
  if (loadKg == null) return 0;
  return switch (unit) {
    'lb' => loadKg / 0.45359237,
    'stone' => loadKg / 6.35029318,
    _ => loadKg,
  };
}

/// Converts a displayed load to canonical kilograms.
double? canonicalExerciseSetLoad(String unit, double value) {
  return switch (unit) {
    'kg' => value,
    'lb' => value * 0.45359237,
    'stone' => value * 6.35029318,
    _ => null,
  };
}

/// Converts a stored canonical distance to the exercise display unit.
double displayDistance(String unit, double? distanceMetres) {
  if (distanceMetres == null) return 0;
  return switch (unit) {
    'km' => distanceMetres / 1000,
    'mi' => distanceMetres / 1609.344,
    _ => distanceMetres,
  };
}

/// Converts a displayed distance to canonical metres.
double? canonicalExerciseSetDistance(String unit, double value) {
  return switch (unit) {
    'm' => value,
    'km' => value * 1000,
    'mi' => value * 1609.344,
    _ => null,
  };
}

double _displayBodyWeight(String unit, double? bodyWeightKg) {
  if (bodyWeightKg == null) return 0;
  return switch (unit) {
    'lb' => bodyWeightKg / 0.45359237,
    'stone' => bodyWeightKg / 6.35029318,
    _ => bodyWeightKg,
  };
}

double? _canonicalBodyWeight(String unit, double value) {
  if (value == 0) return null;
  return canonicalExerciseSetLoad(unit, value);
}

ExerciseSetView _toExerciseSetView(AppDatabase database, TypedResult row) {
  final set = row.readTable(database.exerciseSets);
  final exercise = row.readTable(database.exercises);
  final category = row.readTableOrNull(database.categories);
  final workout = row.readTableOrNull(database.workouts);
  final unit = exercise.displayUnit;

  return ExerciseSetView(
    id: set.id,
    bodyWeight: _displayBodyWeight(unit, set.bodyWeightKg),
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

Expression<bool> _isExercise(AppDatabase database, ExerciseKey exercise) {
  final category = exercise.category;
  return database.exercises.name.equals(exercise.name) &
      (category == null
          ? database.exercises.categoryId.isNull()
          : database.categories.name.equals(category));
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
  required ExerciseKey exercise,
  DateTime? startDate,
  DateTime? endDate,
  int? limit,
  OrderingMode order = OrderingMode.desc,
}) async {
  final query = _exerciseSetQuery(database, order: order)
    ..where(_isExercise(database, exercise));

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

Future<ExerciseSetView?> getExerciseSetForExerciseAt(
  AppDatabase database, {
  required ExerciseKey exercise,
  required DateTime timestamp,
}) async {
  final query = _exerciseSetQuery(database)
    ..where(_isExercise(database, exercise))
    ..where(database.exerciseSets.timestamp.equals(timestamp))
    ..limit(1);
  final row = await query.getSingleOrNull();
  return row == null ? null : _toExerciseSetView(database, row);
}

Future<int> countExerciseSetsForExercises(
  AppDatabase database,
  Iterable<ExerciseKey> exercises,
) async {
  final keys = exercises.toList();
  if (keys.isEmpty) return 0;

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
              leftOuterJoin(
                database.categories,
                database.categories.id.equalsExp(database.exercises.categoryId),
              ),
            ])
            ..addColumns([count])
            ..where(
              keys
                  .map((exercise) => _isExercise(database, exercise))
                  .reduce((a, b) => a | b),
            ))
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

/// Loads the latest exercise set for an exercise within its category.
Future<ExerciseSetView?> getLatestExerciseSet(
  AppDatabase database, {
  required ExerciseKey exercise,
}) async {
  final query = _exerciseSetQuery(database)
    ..where(_isExercise(database, exercise))
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
  final resolvedBodyWeightKg =
      bodyWeightKg ??
      _canonicalBodyWeight(exerciseSet.unit, exerciseSet.bodyWeight) ??
      (await getLatestBodyWeight(database))?.weightKg;

  final id = await database.exerciseSets.insertOne(
    ExerciseSetsCompanion.insert(
      exerciseId: exerciseId,
      workoutId: Value(workoutId),
      timestamp: exerciseSet.created,
      reps: Value(exerciseSet.reps),
      loadKg: Value(
        canonicalExerciseSetLoad(exerciseSet.unit, exerciseSet.weight),
      ),
      durationMs: Value((exerciseSet.duration * 60000).round()),
      distanceMetres: Value(
        canonicalExerciseSetDistance(exerciseSet.unit, exerciseSet.distance),
      ),
      incline: Value(exerciseSet.incline?.toDouble()),
      bodyWeightKg: Value(resolvedBodyWeightKg),
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
          loadKg: Value(
            canonicalExerciseSetLoad(exerciseSet.unit, exerciseSet.weight),
          ),
          durationMs: Value((exerciseSet.duration * 60000).round()),
          distanceMetres: Value(
            canonicalExerciseSetDistance(
              exerciseSet.unit,
              exerciseSet.distance,
            ),
          ),
          incline: Value(exerciseSet.incline?.toDouble()),
          bodyWeightKg: Value(
            bodyWeightKg ??
                _canonicalBodyWeight(exerciseSet.unit, exerciseSet.bodyWeight),
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
  final previous = (await getExerciseSetsForExercise(
    database,
    exercise: (name: exerciseSet.name, category: exerciseSet.category),
  )).where((set) => set.id != exerciseSet.id);

  if (exerciseSet.cardio &&
      const {'kg', 'lb', 'stone'}.contains(exerciseSet.unit)) {
    final candidates = previous.toList();
    if (candidates.isEmpty) return false;
    candidates.sort((a, b) {
      final load = b.weight.compareTo(a.weight);
      return load != 0 ? load : b.duration.compareTo(a.duration);
    });
    final best = candidates.first;
    return exerciseSet.weight > best.weight ||
        (exerciseSet.weight == best.weight &&
            exerciseSet.duration > best.duration);
  }

  if (exerciseSet.cardio) {
    if (exerciseSet.duration == 0) return false;
    final candidates = previous.where((set) => set.duration > 0).toList();
    if (candidates.isEmpty) return false;
    final bestPace = candidates
        .map((set) => set.distance / set.duration)
        .reduce((a, b) => a > b ? a : b);
    return exerciseSet.distance / exerciseSet.duration > bestPace;
  }

  final candidates = previous.toList();
  if (candidates.isEmpty) return false;
  candidates.sort((a, b) {
    final load = b.weight.compareTo(a.weight);
    return load != 0 ? load : b.reps.compareTo(a.reps);
  });
  final best = candidates.first;
  return exerciseSet.weight > best.weight ||
      (exerciseSet.weight == best.weight && exerciseSet.reps > best.reps);
}
