/// Identifies an exercise by its name within a category.
///
/// The same name can exist once per category, and each keeps its own history.
/// A null [category] is the uncategorized group.
typedef ExerciseKey = ({String name, String? category});

/// Returns the names used by more than one of [exercises].
Set<String> sharedExerciseNames(Iterable<ExerciseKey> exercises) {
  final seen = <String>{};
  return {
    for (final exercise in exercises)
      if (!seen.add(exercise.name)) exercise.name,
  };
}

/// Names [exercise] for display, adding its category only when its name is in
/// [sharedNames] and so would otherwise look the same as another exercise.
String exerciseLabel(ExerciseKey exercise, Set<String> sharedNames) {
  final category = exercise.category;
  if (category == null || !sharedNames.contains(exercise.name)) {
    return exercise.name;
  }
  return '${exercise.name} ($category)';
}
