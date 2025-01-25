import 'package:drift/drift.dart';
import 'package:flexify/database/database.dart';
import 'package:flutter/material.dart';

const weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const categories = [
  'Chest',
  'Back',
  'Shoulders',
  'Arms',
  'Legs',
  'Core',
  'Glutes',
  'Calves',
];

enum CardioMetric { pace, distance, duration, incline, inclineAdjustedPace }

enum Period {
  day,
  week,
  month,
  year,
}

enum PlanTrailing { reorder, ratio, count, percent, none }

enum StrengthMetric {
  oneRepMax,
  volume,
  bestWeight,
  relativeStrength,
  bestReps,
}

final defaultSettings = SettingsCompanion.insert(
  themeMode: ThemeMode.system.toString(),
  planTrailing: PlanTrailing.reorder.toString(),
  longDateFormat: 'dd/MM/yy',
  shortDateFormat: 'd/M/yy',
  timerDuration: const Duration(minutes: 3, seconds: 30).inMilliseconds,
  maxSets: 3,
  vibrate: true,
  restTimers: true,
  showUnits: true,
  alarmSound: '',
  cardioUnit: 'km',
  curveLines: false,
  explainedPermissions: false,
  groupHistory: true,
  showBodyWeight: const Value(true),
  strengthUnit: 'kg',
  systemColors: false,
);

const positiveReinforcement = [
  'Great work! You are incredible.',
  'Nice king! Your progress is inspiring.',
  'I kneel...',
  "What's that? A new record!",
  "Incredible stuff! You are an inspiration.",
  "Wow. Nice.",
  "Getting strong much?",
  "Yeah. You're a pretty big guy.",
  "Amazing. Incredible.",
  "Arnie would be proud.",
  "Ronnie C looks upon you with glee.",
  "YEAH! LIGHTWEIGHT BABY!!!!!!!",
  "Is that a new record? I knew you could do it.",
  "Great work! I am proud of you.",
  "Yeah baby! Light weight!",
  "Keep it up! Great progress.",
  "You are doing so well.",
  "That's my boy!",
  "Keep it up.",
  "You are getting very strong.",
  "Powerful.",
  "Powerful stuff!",
  "I am proud of you.",
  "Keep up the great work.",
  "Stand tall! You just made a new record.",
  "New record! You just pushed further than ever!",
  "Yep! That's a record.",
  "Wow! New record!",
  "Very good stuff.",
];
