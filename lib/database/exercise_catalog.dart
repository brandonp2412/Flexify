import 'package:drift/drift.dart';
import 'package:flexify/database/categories.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';

Future<int?> _categoryId(String? name) async {
  final trimmed = name?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  await createCategory(trimmed);
  return (await (db.categories.select()
            ..where((category) => category.name.equals(trimmed)))
          .getSingle())
      .id;
}

Future<Exercise?> getExerciseByName(String name) {
  return (db.exercises.select()..where(
        (exercise) =>
            exercise.name.equals(name) & exercise.archived.equals(false),
      ))
      .getSingleOrNull();
}

Future<Exercise?> getExerciseById(int id) {
  return (db.exercises.select()..where(
        (exercise) => exercise.id.equals(id) & exercise.archived.equals(false),
      ))
      .getSingleOrNull();
}

Future<List<String>> getExerciseNames() {
  return (db.exercises.select()
        ..where((exercise) => exercise.archived.equals(false))
        ..orderBy([(exercise) => OrderingTerm.asc(exercise.name)]))
      .map((exercise) => exercise.name)
      .get();
}

Stream<List<Exercise>> watchExerciseCatalog() {
  return (db.exercises.select()
        ..where((exercise) => exercise.archived.equals(false))
        ..orderBy([(exercise) => OrderingTerm.asc(exercise.name)]))
      .watch();
}

Stream<List<String>> watchExerciseNames() =>
    watchExerciseCatalog().map((rows) => rows.map((row) => row.name).toList());

Future<String?> getExerciseCategoryName(Exercise exercise) async {
  final categoryId = exercise.categoryId;
  if (categoryId == null) return null;
  return (await (db.categories.select()
            ..where((category) => category.id.equals(categoryId)))
          .getSingleOrNull())
      ?.name;
}

Future<Exercise> createExerciseDefinition({
  required String name,
  required bool cardio,
  required String displayUnit,
  String? category,
  String? image,
  int? defaultRestDurationMs,
  String? notes,
}) async {
  final trimmedName = name.trim();
  final id = await _categoryId(category);
  return db.exercises.insertReturning(
    ExercisesCompanion.insert(
      name: trimmedName,
      kind: cardio ? 'cardio' : 'strength',
      displayUnit: displayUnit,
      categoryId: Value(id),
      image: Value(image),
      defaultRestDurationMs: Value(defaultRestDurationMs),
      notes: Value(notes),
    ),
  );
}

Future<Exercise> syncExerciseDefinition({
  required String name,
  required bool cardio,
  required String displayUnit,
  String? category,
  String? image,
  int? defaultRestDurationMs,
}) async {
  final existing = await getExerciseByName(name);
  if (existing == null) {
    return createExerciseDefinition(
      name: name,
      cardio: cardio,
      displayUnit: displayUnit,
      category: category,
      image: image,
      defaultRestDurationMs: defaultRestDurationMs,
    );
  }
  final categoryId = await _categoryId(category);
  await (db.exercises.update()..where((row) => row.id.equals(existing.id)))
      .write(
        ExercisesCompanion(
          kind: Value(cardio ? 'cardio' : 'strength'),
          displayUnit: Value(displayUnit),
          categoryId: Value(categoryId),
          image: Value(image),
          defaultRestDurationMs: Value(defaultRestDurationMs),
        ),
      );
  return (db.exercises.select()..where((row) => row.id.equals(existing.id)))
      .getSingle();
}

Future<void> _mergePlanExerciseReferences({
  required int sourceExerciseId,
  required int targetExerciseId,
}) async {
  final sourceRows =
      await (db.planExercises.select()
            ..where((row) => row.exerciseId.equals(sourceExerciseId)))
          .get();

  for (final source in sourceRows) {
    final target =
        await (db.planExercises.select()..where(
              (row) =>
                  row.planId.equals(source.planId) &
                  row.exerciseId.equals(targetExerciseId),
            ))
            .getSingleOrNull();

    if (target == null) {
      await (db.planExercises.update()
            ..where((row) => row.id.equals(source.id)))
          .write(PlanExercisesCompanion(exerciseId: Value(targetExerciseId)));
      continue;
    }

    final preferSource = source.enabled && !target.enabled;
    await (db.planExercises.update()..where((row) => row.id.equals(target.id)))
        .write(
          PlanExercisesCompanion(
            enabled: Value(target.enabled || source.enabled),
            maxSets: Value(
              preferSource ? source.maxSets : target.maxSets ?? source.maxSets,
            ),
            warmupSets: Value(
              preferSource
                  ? source.warmupSets
                  : target.warmupSets ?? source.warmupSets,
            ),
            timers: Value(preferSource ? source.timers : target.timers),
            sequence: Value(
              source.sequence < target.sequence
                  ? source.sequence
                  : target.sequence,
            ),
          ),
        );
    await (db.planExercises.delete()..where((row) => row.id.equals(source.id)))
        .go();
  }
}

Future<void> updateExerciseDefinition({
  required int exerciseId,
  required String name,
  required bool cardio,
  required String displayUnit,
  String? category,
  String? image,
  int? defaultRestDurationMs,
}) async {
  final trimmedName = name.trim();
  final categoryId = await _categoryId(category);
  final target =
      await (db.exercises.select()
            ..where((row) => row.name.equals(trimmedName)))
          .getSingleOrNull();

  final definition = ExercisesCompanion(
    name: Value(trimmedName),
    kind: Value(cardio ? 'cardio' : 'strength'),
    displayUnit: Value(displayUnit),
    categoryId: Value(categoryId),
    image: Value(image),
    defaultRestDurationMs: Value(defaultRestDurationMs),
  );

  if (target == null || target.id == exerciseId) {
    await (db.exercises.update()..where((row) => row.id.equals(exerciseId)))
        .write(definition);
    return;
  }

  await db.transaction(() async {
    await _mergePlanExerciseReferences(
      sourceExerciseId: exerciseId,
      targetExerciseId: target.id,
    );
    await (db.exerciseSets.update()
          ..where((row) => row.exerciseId.equals(exerciseId)))
        .write(ExerciseSetsCompanion(exerciseId: Value(target.id)));
    await (db.exercises.update()..where((row) => row.id.equals(target.id)))
        .write(
          ExercisesCompanion(
            name: Value(target.name),
            kind: Value(cardio ? 'cardio' : 'strength'),
            displayUnit: Value(displayUnit),
            categoryId: Value(categoryId),
            image: Value(image),
            defaultRestDurationMs: Value(defaultRestDurationMs),
            archived: const Value(false),
          ),
        );
    await (db.exercises.delete()..where((row) => row.id.equals(exerciseId)))
        .go();
  });
}

Future<void> updateExerciseGraphPreferences({
  required int exerciseId,
  required String metric,
  required String period,
  required int limit,
  required bool timeBasedXAxis,
  required String? notes,
}) {
  return (db.exercises.update()..where((row) => row.id.equals(exerciseId)))
      .write(
        ExercisesCompanion(
          graphMetric: Value(metric),
          graphPeriod: Value(period),
          graphLimit: Value(limit),
          graphTimeBasedXAxis: Value(timeBasedXAxis),
          notes: Value(notes),
        ),
      );
}
