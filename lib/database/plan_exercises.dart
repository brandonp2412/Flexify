import 'package:drift/drift.dart';
import 'package:flexify/database/gym_sets.dart';
import 'package:flexify/database/plans.dart';

class PlanExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get planId => integer().references(Plans, #id)();
  TextColumn get exercise => text().references(GymSets, #name)();
  BoolColumn get enabled => boolean()();
  IntColumn get maxSets => integer().nullable()();
}
