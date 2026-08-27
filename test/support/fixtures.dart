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

PlanExercisesCompanion planExerciseFixture({
  required int planId,
  required String exercise,
  bool enabled = true,
  int? sequence,
}) {
  return PlanExercisesCompanion.insert(
    planId: planId,
    exercise: exercise,
    enabled: enabled,
    sequence: sequence == null ? const Value.absent() : Value(sequence),
  );
}

SettingsCompanion testSettings({
  bool? explainedPermissions,
  bool? notificationPermissionRequested,
  bool? repEstimation,
  bool? groupHistory,
  bool? restTimers,
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
    restTimers: restTimers == null
        ? const Value.absent()
        : Value(restTimers),
  );
}
