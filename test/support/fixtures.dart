import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/performed_sets.dart';

final testNow = DateTime(2026, 1, 15, 12);

GymSet gymSetFixture(
  String name, {
  double reps = 5,
  double weight = 50,
  String unit = 'kg',
  DateTime? created,
  bool cardio = false,
  double? duration,
  String? category,
  String? notes,
  int? planId,
  bool hidden = false,
}) {
  return GymSet(
    id: 0,
    name: name,
    reps: reps,
    weight: weight,
    unit: unit,
    created: created ?? testNow,
    bodyWeight: 0,
    duration: duration ?? 0,
    distance: 0,
    cardio: cardio,
    category: category,
    notes: notes,
    planId: planId,
  );
}

GymSet gymSetModelFixture({
  int id = 0,
  String name = 'Bench press',
  double reps = 2,
  double weight = 3,
  String unit = 'kg',
  DateTime? created,
  bool hidden = false,
  double bodyWeight = 0,
  double duration = 0,
  double distance = 0,
  bool cardio = false,
}) {
  return GymSet(
    id: id,
    name: name,
    reps: reps,
    weight: weight,
    unit: unit,
    created: created ?? testNow,
    bodyWeight: bodyWeight,
    duration: duration,
    distance: distance,
    cardio: cardio,
  );
}

Future<GymSet> insertPerformedSetFixture(
  AppDatabase database,
  String name, {
  double reps = 5,
  double weight = 50,
  String unit = 'kg',
  DateTime? created,
  bool cardio = false,
  double duration = 0,
  double distance = 0,
  String? category,
  String? notes,
  int? planId,
  double bodyWeight = 0,
  int? incline,
}) async {
  final timestamp = created ?? testNow;
  final exercise = await ensureExerciseFixture(
    database,
    name,
    cardio: cardio,
    unit: unit,
  );

  int? categoryId;
  if (category != null) {
    final existingCategory =
        await (database.categories.select()
              ..where((row) => row.name.equals(category)))
            .getSingleOrNull();
    categoryId =
        existingCategory?.id ??
        await database.categories.insertOne(
          CategoriesCompanion.insert(name: category),
        );
    await (database.exercises.update()
          ..where((row) => row.id.equals(exercise.id)))
        .write(ExercisesCompanion(categoryId: Value(categoryId)));
  }

  int? workoutId;
  if (planId != null) {
    workoutId = await database.workouts.insertOne(
      WorkoutsCompanion.insert(planId: Value(planId), startedAt: timestamp),
    );
  }

  return insertPerformedSet(
    database,
    exerciseId: exercise.id,
    workoutId: workoutId,
    gymSet: GymSet(
      id: 0,
      name: name,
      reps: reps,
      weight: weight,
      unit: unit,
      created: timestamp,
      bodyWeight: bodyWeight,
      duration: duration,
      distance: distance,
      cardio: cardio,
      category: category,
      notes: notes,
      planId: planId,
      incline: incline,
    ),
  );
}

PlansCompanion planFixture({
  int? id,
  String days = 'Monday',
  String? title,
  int? sequence,
}) {
  return PlansCompanion.insert(
    id: id == null ? const Value.absent() : Value(id),
    days: days,
    title: title == null ? const Value.absent() : Value(title),
    sequence: sequence == null ? const Value.absent() : Value(sequence),
  );
}

ExercisesCompanion exerciseFixture(
  String name, {
  bool cardio = false,
  String unit = 'kg',
}) {
  return ExercisesCompanion.insert(
    name: name,
    kind: cardio ? 'cardio' : 'strength',
    displayUnit: unit,
  );
}

PlanExercisesCompanion planExerciseFixture({
  required int planId,
  required int exerciseId,
  bool enabled = true,
  int? sequence,
}) {
  return PlanExercisesCompanion.insert(
    planId: planId,
    exerciseId: exerciseId,
    enabled: enabled,
    sequence: sequence == null ? const Value.absent() : Value(sequence),
  );
}

Future<Exercise> ensureExerciseFixture(
  AppDatabase database,
  String name, {
  bool cardio = false,
  String unit = 'kg',
}) async {
  final existing =
      await (database.exercises.select()..where((row) => row.name.equals(name)))
          .getSingleOrNull();
  if (existing != null) {
    await (database.exercises.update()
          ..where((row) => row.id.equals(existing.id)))
        .write(
          ExercisesCompanion(
            kind: Value(cardio ? 'cardio' : 'strength'),
            displayUnit: Value(unit),
          ),
        );
    return (database.exercises.select()
          ..where((row) => row.id.equals(existing.id)))
        .getSingle();
  }
  return database.exercises.insertReturning(
    exerciseFixture(name, cardio: cardio, unit: unit),
  );
}

Future<PlanExercise> insertPlanExerciseFixture(
  AppDatabase database, {
  required int planId,
  required String exercise,
  bool enabled = true,
  int? sequence,
  bool cardio = false,
  String unit = 'kg',
}) async {
  final definition = await ensureExerciseFixture(
    database,
    exercise,
    cardio: cardio,
    unit: unit,
  );
  return database.planExercises.insertReturning(
    planExerciseFixture(
      planId: planId,
      exerciseId: definition.id,
      enabled: enabled,
      sequence: sequence,
    ),
  );
}

SettingsCompanion testSettings({
  bool? explainedPermissions,
  bool? notificationPermissionRequested,
  bool? repEstimation,
  bool? groupHistory,
  bool? restTimers,
  bool? showNotes,
  bool? showUnits,
  bool? showImages,
  bool? showGlobalProgress,
}) {
  return SettingsCompanion(
    explainedPermissions: explainedPermissions == null
        ? const Value.absent()
        : Value(explainedPermissions),
    notificationPermissionRequested: notificationPermissionRequested == null
        ? const Value.absent()
        : Value(notificationPermissionRequested),
    repEstimation: repEstimation == null
        ? const Value.absent()
        : Value(repEstimation),
    groupHistory: groupHistory == null
        ? const Value.absent()
        : Value(groupHistory),
    restTimers: restTimers == null ? const Value.absent() : Value(restTimers),
    showNotes: showNotes == null ? const Value.absent() : Value(showNotes),
    showUnits: showUnits == null ? const Value.absent() : Value(showUnits),
    showImages: showImages == null ? const Value.absent() : Value(showImages),
    showGlobalProgress: showGlobalProgress == null
        ? const Value.absent()
        : Value(showGlobalProgress),
  );
}
