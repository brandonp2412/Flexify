import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/database/exercise_set_repository.dart';
import 'package:flexify/plan/workout_sessions.dart';

class StartPlanData {
  const StartPlanData({
    required this.plan,
    required this.workout,
    required this.exercises,
    required this.defaults,
    required this.sets,
    required this.previous,
    required this.categories,
  });

  final Plan? plan;
  final Workout workout;
  final List<PlanExerciseEntry> exercises;
  final Map<int, ExerciseSetView> defaults;
  final Map<int, List<ExerciseSetView>> sets;
  final Map<int, PreviousExerciseDay> previous;
  final Map<int, String?> categories;
}

Stream<StartPlanData> watchStartPlanData(
  AppDatabase database,
  int planId,
) async* {
  final workout = await resumeOrStartWorkout(database, planId);
  const defaultId = CustomExpression<int>('''COALESCE(
    (SELECT s.id FROM exercise_sets s
      JOIN workouts w ON w.id = s.workout_id
      WHERE s.exercise_id = exercises.id AND w.plan_id = plans.id
      ORDER BY w.started_at DESC, w.id DESC, s.timestamp, s.id LIMIT 1),
    (SELECT s.id FROM exercise_sets s
      WHERE s.exercise_id = exercises.id AND s.workout_id IS NULL
      ORDER BY s.timestamp DESC, s.id DESC LIMIT 1)
  )''');
  const previousDay = CustomExpression<String>('''(
    SELECT date(MAX(s.timestamp), 'unixepoch', 'localtime')
    FROM exercise_sets s WHERE s.exercise_id = exercises.id
      AND s.timestamp < CAST(strftime('%s', date('now', 'localtime'), 'utc') AS INTEGER)
  )''');
  final query =
      database.select(database.plans).join([
          leftOuterJoin(
            database.planExercises,
            database.planExercises.planId.equalsExp(database.plans.id) &
                database.planExercises.enabled.equals(true),
          ),
          leftOuterJoin(
            database.exercises,
            database.exercises.id.equalsExp(database.planExercises.exerciseId),
          ),
          leftOuterJoin(
            database.categories,
            database.categories.id.equalsExp(database.exercises.categoryId),
          ),
          leftOuterJoin(
            database.exerciseSets,
            database.exerciseSets.exerciseId.equalsExp(database.exercises.id) &
                (database.exerciseSets.workoutId.equals(workout.id) |
                    database.exerciseSets.id.equalsExp(defaultId) |
                    CustomExpression<bool>(
                      "date(exercise_sets.timestamp, 'unixepoch', 'localtime') = (${previousDay.content})",
                    )),
          ),
          leftOuterJoin(
            database.workouts,
            database.workouts.id.equalsExp(database.exerciseSets.workoutId),
          ),
        ])
        ..addColumns([defaultId, previousDay])
        ..where(database.plans.id.equals(planId))
        ..orderBy([
          OrderingTerm.asc(database.planExercises.sequence),
          OrderingTerm.asc(database.planExercises.id),
          OrderingTerm.asc(database.exerciseSets.timestamp),
          OrderingTerm.asc(database.exerciseSets.id),
        ]);
  yield* query.watch().map((rows) {
    final entries = <int, PlanExerciseEntry>{};
    final defaults = <int, ExerciseSetView>{};
    final sets = <int, List<ExerciseSetView>>{};
    final previous = <int, PreviousExerciseDay>{};
    final categories = <int, String?>{};
    for (final row in rows) {
      final exercise = row.readTableOrNull(database.exercises);
      final pe = row.readTableOrNull(database.planExercises);
      if (exercise == null || pe == null) continue;
      entries[exercise.id] = PlanExerciseEntry(
        planExercise: pe,
        exercise: exercise,
      );
      final category = row.readTableOrNull(database.categories)?.name;
      categories[exercise.id] = category;
      final set = row.readTableOrNull(database.exerciseSets);
      if (set == null) continue;
      final view = exerciseSetView(
        set,
        exercise,
        category: category,
        planId: row.readTableOrNull(database.workouts)?.planId,
      );
      if (set.id == row.read(defaultId)) defaults[exercise.id] = view;
      if (set.workoutId == workout.id)
        sets.putIfAbsent(exercise.id, () => []).add(view);
      final day = row.read(previousDay);
      final date = day == null ? null : DateTime.parse(day);
      if (date != null &&
          view.created.year == date.year &&
          view.created.month == date.month &&
          view.created.day == date.day) {
        previous
            .putIfAbsent(
              exercise.id,
              () => PreviousExerciseDay(day: date, sets: []),
            )
            .sets
            .add(
              PreviousExerciseSet(
                cardio: view.cardio,
                unit: view.unit,
                reps: view.reps,
                weight: view.weight,
                distance: view.distance,
                duration: view.duration,
                incline: view.incline,
              ),
            );
      }
    }
    return StartPlanData(
      plan: rows.isEmpty ? null : rows.first.readTable(database.plans),
      workout: workout,
      exercises: entries.values.toList(),
      defaults: defaults,
      sets: sets,
      previous: previous,
      categories: categories,
    );
  });
}
