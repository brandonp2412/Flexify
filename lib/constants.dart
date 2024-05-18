import 'package:drift/drift.dart';
import 'package:flexify/database.dart';

enum Period {
  day,
  week,
  month,
  year,
}

enum CardioMetric { pace, distance, duration }

enum StrengthMetric {
  oneRepMax,
  volume,
  bestWeight,
  relativeStrength,
  bestReps,
}

const weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const defaultPlans = [
  PlansCompanion(
    days: Value('Monday'),
    exercises: Value(
      'Deadlift,Lat pull-down,Barbell bent-over row,Barbell biceps curl',
    ),
  ),
  PlansCompanion(
    days: Value('Wednesday'),
    exercises: Value(
      'Barbell bench press,Barbell shoulder press,Chest fly,Dumbbell lateral raise,Triceps extension',
    ),
  ),
  PlansCompanion(
    days: Value('Friday'),
    exercises: Value('Squat,Leg press,Leg curl,Seated calf raise'),
  ),
];

const defaultExercises = [
  'Arnold press',
  'Back extension',
  'Barbell bench press',
  'Barbell biceps curl',
  'Barbell bent-over row',
  'Barbell shoulder press',
  'Barbell shrug',
  'Cable fly',
  'Cable lateral raise',
  'Cable pull-down',
  'Chest fly',
  'Chin-up',
  'Close-grip pull-up',
  'Crunch',
  'Deadlift',
  'Decline bench press',
  'Diamond push-up',
  'Dumbbell bench press',
  'Dumbbell biceps curl',
  'Dumbbell bent-over row',
  'Dumbbell fly',
  'Dumbbell lateral raise',
  'Dumbbell shoulder press',
  'Dumbbell shrug',
  'Good morning',
  'Hanging leg raise',
  'Hyperextension',
  'Incline bench press',
  'Lat pull-down',
  'Leg curl',
  'Leg extension',
  'Leg press',
  'Leg raise',
  'Lunge',
  'Narrow-grip push-up',
  'Neck curl',
  'Overhead triceps extension',
  'Preacher curl',
  'Pull-down',
  'Pull-up',
  'Push-up',
  'Reverse grip pull-down',
  'Reverse grip pushdown',
  'Roman chair leg raise',
  'Romanian deadlift',
  'Russian twist',
  'Seated calf raise',
  'Shoulder shrug',
  'Squat',
  'Standing calf raise',
  'T-bar row',
  'Triceps dip',
  'Triceps extension',
  'Triceps pushdown',
  'Upright row',
  'Weighted Russian twist',
  'Wide-grip pull-up',
  'Wide-grip push-up',
];
