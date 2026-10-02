import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';

final testNow = DateTime(2026, 1, 15, 12);

GymSetsCompanion gymSetFixture(
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
  return GymSetsCompanion.insert(
    name: name,
    reps: reps,
    weight: weight,
    unit: unit,
    created: created ?? testNow,
    cardio: Value(cardio),
    duration: duration == null ? const Value.absent() : Value(duration),
    category: category == null ? const Value.absent() : Value(category),
    notes: notes == null ? const Value.absent() : Value(notes),
    planId: planId == null ? const Value.absent() : Value(planId),
    hidden: Value(hidden),
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
    hidden: hidden,
    bodyWeight: bodyWeight,
    duration: duration,
    distance: distance,
    cardio: cardio,
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
  required String exercise,
  bool enabled = true,
  int? sequence,
  int? exerciseId,
}) {
  return PlanExercisesCompanion.insert(
    planId: planId,
    exercise: exercise,
    exerciseId: Value(exerciseId),
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
      exercise: exercise,
      enabled: enabled,
      sequence: sequence,
      exerciseId: definition.id,
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
