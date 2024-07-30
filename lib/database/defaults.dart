import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';

const defaultExercises = [
  ('Arnold press', 'Shoulders'),
  ('Back extension', 'Back'),
  ('Barbell bench press', 'Chest'),
  ('Barbell biceps curl', 'Arms'),
  ('Barbell bent-over row', 'Back'),
  ('Barbell shoulder press', 'Shoulders'),
  ('Barbell shrug', 'Shoulders'),
  ('Cable fly', 'Chest'),
  ('Cable lateral raise', 'Shoulders'),
  ('Cable pull-down', 'Back'),
  ('Chest fly', 'Chest'),
  ('Chin-up', 'Back'),
  ('Close-grip pull-up', 'Back'),
  ('Crunch', 'Core'),
  ('Deadlift', 'Back'),
  ('Decline bench press', 'Chest'),
  ('Diamond push-up', 'Chest'),
  ('Dumbbell bench press', 'Chest'),
  ('Dumbbell biceps curl', 'Arms'),
  ('Dumbbell bent-over row', 'Back'),
  ('Dumbbell fly', 'Chest'),
  ('Dumbbell lateral raise', 'Shoulders'),
  ('Dumbbell shoulder press', 'Shoulders'),
  ('Dumbbell shrug', 'Shoulders'),
  ('Good morning', 'Back'),
  ('Hanging leg raise', 'Core'),
  ('Hyperextension', 'Back'),
  ('Incline bench press', 'Chest'),
  ('Lat pull-down', 'Back'),
  ('Leg curl', 'Legs'),
  ('Leg extension', 'Legs'),
  ('Leg press', 'Legs'),
  ('Leg raise', 'Core'),
  ('Lunge', 'Legs'),
  ('Narrow-grip push-up', 'Chest'),
  ('Neck curl', 'Shoulders'),
  ('Overhead triceps extension', 'Arms'),
  ('Preacher curl', 'Arms'),
  ('Pull-down', 'Back'),
  ('Pull-up', 'Back'),
  ('Push-up', 'Chest'),
  ('Reverse grip pull-down', 'Back'),
  ('Reverse grip pushdown', 'Arms'),
  ('Roman chair leg raise', 'Core'),
  ('Romanian deadlift', 'Back'),
  ('Russian twist', 'Core'),
  ('Seated calf raise', 'Calves'),
  ('Shoulder shrug', 'Shoulders'),
  ('Squat', 'Legs'),
  ('Standing calf raise', 'Calves'),
  ('T-bar row', 'Back'),
  ('Triceps dip', 'Arms'),
  ('Triceps extension', 'Arms'),
  ('Triceps pushdown', 'Arms'),
  ('Upright row', 'Shoulders'),
  ('Weighted Russian twist', 'Core'),
  ('Wide-grip pull-up', 'Back'),
  ('Wide-grip push-up', 'Chest'),
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
          timers: const Value(true),
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
  ),
);
