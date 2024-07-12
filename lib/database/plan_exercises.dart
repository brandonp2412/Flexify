import 'package:drift/drift.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/database/plans.dart';

class PlanExercises extends Table {
  BoolColumn get enabled => boolean()();
  TextColumn get exercise => text().references(GymSets, #name)();
  IntColumn get id => integer().autoIncrement()();
  IntColumn get maxSets => integer().nullable()();
  IntColumn get planId => integer().references(Plans, #id)();
}
