import 'package:drift/drift.dart';
import 'package:flexify/database/body_weight_repository.dart';
import 'package:flexify/database/database.dart';

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
double? canonicalPerformedLoad(String unit, double value) {
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
double? canonicalPerformedDistance(String unit, double value) {
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
  return canonicalPerformedLoad(unit, value);
}

PerformedSetView _toPerformedSet(AppDatabase database, TypedResult row) {
  final set = row.readTable(database.exerciseSets);
  final exercise = row.readTable(database.exercises);
  final category = row.readTableOrNull(database.categories);
  final workout = row.readTableOrNull(database.workouts);
  final unit = exercise.displayUnit;

  return PerformedSetView(
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

List<PerformedSetView> _filterPerformedSets(
  List<PerformedSetView> sets, {
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
  final terms = search
      .toLowerCase()
      .split(' ')
      .where((term) => term.isNotEmpty)
      .toList();

  final filtered = sets.where((set) {
    final name = set.name.toLowerCase();
    if (terms.any((term) => !name.contains(term))) return false;
    if (category != null && set.category != category) return false;
    if (startDate != null && set.created.isBefore(startDate)) return false;
    if (endDate != null && set.created.isAfter(endDate)) return false;
    if (!set.cardio && repsGt != null && set.reps <= repsGt) return false;
    if (!set.cardio && repsLt != null && set.reps >= repsLt) return false;
    if (!set.cardio && weightGt != null && set.weight <= weightGt) return false;
    if (!set.cardio && weightLt != null && set.weight >= weightLt) return false;
    return true;
  });

  return (limit == null ? filtered : filtered.take(limit)).toList();
}

JoinedSelectStatement<HasResultSet, dynamic> _performedSetQuery(
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

/// Watches performed sets projected with exercise metadata for history UI.
Stream<List<PerformedSetView>> watchPerformedSets(
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
  return _performedSetQuery(database).watch().map(
    (rows) => _filterPerformedSets(
      rows.map((row) => _toPerformedSet(database, row)).toList(),
      search: search,
      category: category,
      startDate: startDate,
      endDate: endDate,
      repsGt: repsGt,
      repsLt: repsLt,
      weightGt: weightGt,
      weightLt: weightLt,
      limit: limit,
    ),
  );
}

/// Loads performed sets projected with exercise metadata.
Future<List<PerformedSetView>> getPerformedSets(
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
}) async {
  final rows = await _performedSetQuery(database).get();
  return _filterPerformedSets(
    rows.map((row) => _toPerformedSet(database, row)).toList(),
    search: search,
    category: category,
    startDate: startDate,
    endDate: endDate,
    repsGt: repsGt,
    repsLt: repsLt,
    weightGt: weightGt,
    weightLt: weightLt,
    limit: limit,
  );
}

Future<List<PerformedSetView>> getPerformedSetsForExercise(
  AppDatabase database, {
  required String exerciseName,
  DateTime? startDate,
  DateTime? endDate,
  int? limit,
  OrderingMode order = OrderingMode.desc,
}) async {
  final query = _performedSetQuery(database, order: order)
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
  return rows.map((row) => _toPerformedSet(database, row)).toList();
}

Future<PerformedSetView?> getPerformedSetForExerciseAt(
  AppDatabase database, {
  required String exerciseName,
  required DateTime timestamp,
}) async {
  final query = _performedSetQuery(database)
    ..where(database.exercises.name.equals(exerciseName))
    ..where(database.exerciseSets.timestamp.equals(timestamp))
    ..limit(1);
  final row = await query.getSingleOrNull();
  return row == null ? null : _toPerformedSet(database, row);
}

Future<int> countPerformedSetsForExercises(
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

/// Loads one performed set by its exercise_sets identifier.
Future<PerformedSetView?> getPerformedSetById(
  AppDatabase database,
  int id,
) async {
  final query = _performedSetQuery(database)
    ..where(database.exerciseSets.id.equals(id));
  final row = await query.getSingleOrNull();
  return row == null ? null : _toPerformedSet(database, row);
}

/// Loads the latest performed set for an exercise name.
Future<PerformedSetView?> getLatestPerformedSet(
  AppDatabase database, {
  required String exerciseName,
}) async {
  final query = _performedSetQuery(database)
    ..where(database.exercises.name.equals(exerciseName))
    ..limit(1);
  final row = await query.getSingleOrNull();
  return row == null ? null : _toPerformedSet(database, row);
}

/// Loads the latest performed set for an exercise in one workout.
Future<PerformedSetView?> getLatestWorkoutPerformedSet(
  AppDatabase database, {
  required int workoutId,
  required int exerciseId,
}) async {
  final query = _performedSetQuery(database)
    ..where(
      database.exerciseSets.workoutId.equals(workoutId) &
          database.exerciseSets.exerciseId.equals(exerciseId),
    )
    ..limit(1);
  final row = await query.getSingleOrNull();
  return row == null ? null : _toPerformedSet(database, row);
}

/// Watches performed sets for one exercise in one workout.
Stream<List<PerformedSetView>> watchWorkoutPerformedSets(
  AppDatabase database, {
  required int workoutId,
  required int exerciseId,
}) {
  final query = _performedSetQuery(database, order: OrderingMode.asc)
    ..where(
      database.exerciseSets.workoutId.equals(workoutId) &
          database.exerciseSets.exerciseId.equals(exerciseId),
    );
  return query.watch().map(
    (rows) => rows.map((row) => _toPerformedSet(database, row)).toList(),
  );
}

/// Inserts one performed set into exercise_sets only.
Future<PerformedSetView> insertPerformedSet(
  AppDatabase database, {
  required PerformedSetView performedSet,
  required int exerciseId,
  int? workoutId,
  double? bodyWeightKg,
}) async {
  final resolvedBodyWeightKg =
      bodyWeightKg ??
      _canonicalBodyWeight(performedSet.unit, performedSet.bodyWeight) ??
      (await getLatestBodyWeight(database))?.weightKg;

  final id = await database.exerciseSets.insertOne(
    ExerciseSetsCompanion.insert(
      exerciseId: exerciseId,
      workoutId: Value(workoutId),
      timestamp: performedSet.created,
      reps: Value(performedSet.reps),
      loadKg: Value(
        canonicalPerformedLoad(performedSet.unit, performedSet.weight),
      ),
      durationMs: Value((performedSet.duration * 60000).round()),
      distanceMetres: Value(
        canonicalPerformedDistance(performedSet.unit, performedSet.distance),
      ),
      incline: Value(performedSet.incline?.toDouble()),
      bodyWeightKg: Value(resolvedBodyWeightKg),
      notes: Value(performedSet.notes),
    ),
  );
  return (await getPerformedSetById(database, id))!;
}

/// Updates per-performance data and exercise identity in exercise_sets only.
Future<void> updatePerformedSet(
  AppDatabase database, {
  required int id,
  required PerformedSetView performedSet,
  required int exerciseId,
  double? bodyWeightKg,
}) {
  return (database.exerciseSets.update()..where((set) => set.id.equals(id)))
      .write(
        ExerciseSetsCompanion(
          exerciseId: Value(exerciseId),
          timestamp: Value(performedSet.created),
          reps: Value(performedSet.reps),
          loadKg: Value(
            canonicalPerformedLoad(performedSet.unit, performedSet.weight),
          ),
          durationMs: Value((performedSet.duration * 60000).round()),
          distanceMetres: Value(
            canonicalPerformedDistance(
              performedSet.unit,
              performedSet.distance,
            ),
          ),
          incline: Value(performedSet.incline?.toDouble()),
          bodyWeightKg: Value(
            bodyWeightKg ??
                _canonicalBodyWeight(
                  performedSet.unit,
                  performedSet.bodyWeight,
                ),
          ),
          notes: Value(performedSet.notes),
        ),
      );
}

/// Deletes performed sets by exercise_sets identifiers.
Future<int> deletePerformedSets(AppDatabase database, Iterable<int> ids) {
  final values = ids.toList();
  if (values.isEmpty) return Future.value(0);
  return (database.exerciseSets.delete()..where((set) => set.id.isIn(values)))
      .go();
}

/// Compares a set against prior performed sets for positive reinforcement.
Future<bool> isBestPerformedSet(
  AppDatabase database,
  PerformedSetView performedSet,
) async {
  final previous = (await getPerformedSetsForExercise(
    database,
    exerciseName: performedSet.name,
  )).where((set) => set.id != performedSet.id);

  if (performedSet.cardio &&
      const {'kg', 'lb', 'stone'}.contains(performedSet.unit)) {
    final candidates = previous.toList();
    if (candidates.isEmpty) return false;
    candidates.sort((a, b) {
      final load = b.weight.compareTo(a.weight);
      return load != 0 ? load : b.duration.compareTo(a.duration);
    });
    final best = candidates.first;
    return performedSet.weight > best.weight ||
        (performedSet.weight == best.weight &&
            performedSet.duration > best.duration);
  }

  if (performedSet.cardio) {
    if (performedSet.duration == 0) return false;
    final candidates = previous.where((set) => set.duration > 0).toList();
    if (candidates.isEmpty) return false;
    final bestPace = candidates
        .map((set) => set.distance / set.duration)
        .reduce((a, b) => a > b ? a : b);
    return performedSet.distance / performedSet.duration > bestPace;
  }

  final candidates = previous.toList();
  if (candidates.isEmpty) return false;
  candidates.sort((a, b) {
    final load = b.weight.compareTo(a.weight);
    return load != 0 ? load : b.reps.compareTo(a.reps);
  });
  final best = candidates.first;
  return performedSet.weight > best.weight ||
      (performedSet.weight == best.weight && performedSet.reps > best.reps);
}
