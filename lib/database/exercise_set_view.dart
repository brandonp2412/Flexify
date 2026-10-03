import 'package:drift/drift.dart';

/// UI/domain projection of an exercise set joined with exercise metadata.
///
/// This intentionally is not a Drift table. Persistent set data lives in
/// exercise_sets, while exercise identity/configuration lives in exercises.
class ExerciseSetView {
  const ExerciseSetView({
    required this.bodyWeight,
    required this.cardio,
    this.category,
    required this.created,
    required this.distance,
    required this.duration,
    required this.id,
    this.image,
    this.incline,
    required this.name,
    this.notes,
    this.planId,
    required this.reps,
    this.restMs,
    required this.unit,
    required this.weight,
  });

  final double bodyWeight;
  final bool cardio;
  final String? category;
  final DateTime created;
  final double distance;
  final double duration;
  final int id;
  final String? image;
  final int? incline;
  final String name;
  final String? notes;
  final int? planId;
  final double reps;
  final int? restMs;
  final String unit;
  final double weight;

  ExerciseSetView copyWith({
    double? bodyWeight,
    bool? cardio,
    Value<String?> category = const Value.absent(),
    DateTime? created,
    double? distance,
    double? duration,
    int? id,
    Value<String?> image = const Value.absent(),
    Value<int?> incline = const Value.absent(),
    String? name,
    Value<String?> notes = const Value.absent(),
    Value<int?> planId = const Value.absent(),
    double? reps,
    Value<int?> restMs = const Value.absent(),
    String? unit,
    double? weight,
  }) {
    return ExerciseSetView(
      bodyWeight: bodyWeight ?? this.bodyWeight,
      cardio: cardio ?? this.cardio,
      category: category.present ? category.value : this.category,
      created: created ?? this.created,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      id: id ?? this.id,
      image: image.present ? image.value : this.image,
      incline: incline.present ? incline.value : this.incline,
      name: name ?? this.name,
      notes: notes.present ? notes.value : this.notes,
      planId: planId.present ? planId.value : this.planId,
      reps: reps ?? this.reps,
      restMs: restMs.present ? restMs.value : this.restMs,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
    );
  }
}
