import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';

const defaultExercises = [
  ('Arnold press', 'Shoulders', 6.0),
  ('Back extension', 'Back', 5.0),
  ('Barbell bench press', 'Chest', 6.0),
  ('Barbell biceps curl', 'Arms', 6.0),
  ('Barbell bent-over row', 'Back', 6.0),
  ('Barbell shoulder press', 'Shoulders', 6.0),
  ('Barbell shrug', 'Shoulders', 6.0),
  ('Cable fly', 'Chest', 5.5),
  ('Cable lateral raise', 'Shoulders', 5.5),
  ('Cable pull-down', 'Back', 6.0),
  ('Chest fly', 'Chest', 5.5),
  ('Chin-up', 'Back', 8.0),
  ('Close-grip pull-up', 'Back', 8.0),
  ('Crunch', 'Core', 4.0),
  ('Deadlift', 'Back', 6.0),
  ('Decline bench press', 'Chest', 6.0),
  ('Diamond push-up', 'Chest', 6.0),
  ('Dumbbell bench press', 'Chest', 6.0),
  ('Dumbbell biceps curl', 'Arms', 6.0),
  ('Dumbbell bent-over row', 'Back', 6.0),
  ('Dumbbell fly', 'Chest', 5.5),
  ('Dumbbell lateral raise', 'Shoulders', 5.5),
  ('Dumbbell shoulder press', 'Shoulders', 6.0),
  ('Dumbbell shrug', 'Shoulders', 6.0),
  ('Good morning', 'Back', 5.5),
  ('Hanging leg raise', 'Core', 4.0),
  ('Hyperextension', 'Back', 5.0),
  ('Incline bench press', 'Chest', 6.0),
  ('Lat pull-down', 'Back', 6.0),
  ('Leg curl', 'Legs', 5.5),
  ('Leg extension', 'Legs', 5.5),
  ('Leg press', 'Legs', 6.0),
  ('Leg raise', 'Core', 4.0),
  ('Lunge', 'Legs', 5.5),
  ('Narrow-grip push-up', 'Chest', 6.0),
  ('Neck curl', 'Shoulders', 5.5),
  ('Overhead triceps extension', 'Arms', 6.0),
  ('Preacher curl', 'Arms', 6.0),
  ('Pull-down', 'Back', 6.0),
  ('Pull-up', 'Back', 8.0),
  ('Push-up', 'Chest', 6.0),
  ('Reverse grip pull-down', 'Back', 6.0),
  ('Reverse grip pushdown', 'Arms', 6.0),
  ('Roman chair leg raise', 'Core', 4.0),
  ('Romanian deadlift', 'Back', 6.0),
  ('Russian twist', 'Core', 4.0),
  ('Seated calf raise', 'Calves', 5.5),
  ('Shoulder shrug', 'Shoulders', 6.0),
  ('Squat', 'Legs', 6.0),
  ('Standing calf raise', 'Calves', 5.5),
  ('T-bar row', 'Back', 6.0),
  ('Triceps dip', 'Arms', 6.0),
  ('Triceps extension', 'Arms', 6.0),
  ('Triceps pushdown', 'Arms', 6.0),
  ('Upright row', 'Shoulders', 6.0),
  ('Weighted Russian twist', 'Core', 5.0),
  ('Wide-grip pull-up', 'Back', 8.0),
  ('Wide-grip push-up', 'Chest', 6.0),
];

const defaultPlans = [
  PlansCompanion(
    id: Value(1),
    days: Value('Monday'),
    exercises: Value(
      'Deadlift,Lat pull-down,Barbell bent-over row,Barbell biceps curl',
    ),
  ),
  PlansCompanion(
    id: Value(2),
    days: Value('Wednesday'),
    exercises: Value(
      'Barbell bench press,Barbell shoulder press,Chest fly,Dumbbell lateral raise,Triceps extension',
    ),
  ),
  PlansCompanion(
    id: Value(3),
    days: Value('Friday'),
    exercises: Value('Squat,Leg press,Leg curl,Seated calf raise'),
  ),
];

final defaultPlanExercises = defaultPlans
    .map((plan) {
      final exercises = plan.exercises.value.split(',');
      return defaultExercises.map(
        (exercise) => PlanExercisesCompanion.insert(
          planId: plan.id.value,
          exercise: exercise.$1,
          enabled: exercises.contains(exercise.$1),
        ),
      );
    })
    .toList()
    .expand(
      (element) => element,
    );

final defaultSets = defaultExercises.map(
  (exercise) => GymSetsCompanion(
    created: Value(DateTime.now().toLocal()),
    name: Value(exercise.$1),
    reps: const Value(0),
    weight: const Value(0),
    hidden: const Value(true),
    unit: const Value('kg'),
    category: Value(exercise.$2),
    met: Value(exercise.$3),
  ),
);
