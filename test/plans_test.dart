import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  db = AppDatabase(executor: NativeDatabase.memory());

  test('plans can be created', () async {
    final id = await db.plans.insertOne(
      PlansCompanion.insert(
        days: "Monday,Tuesday,Wednesday",
        exercises: "Bench press,Rows,Bicep curls",
      ),
    );
    expect(id, greaterThan(0));
  });

  test('plans can be read', () async {
    final id = await db.plans.insertOne(
      PlansCompanion.insert(
        days: "Monday,Tuesday,Wednesday",
        exercises: "Bench press,Rows,Bicep curls",
      ),
    );
    final plan = await (db.plans.select()
          ..where((u) => u.id.equals(id))
          ..limit(1))
        .getSingle();
    expect(plan.days, "Monday,Tuesday,Wednesday");
    expect(plan.exercises, "Bench press,Rows,Bicep curls");
  });

  test('plans can be updated', () async {
    final id = await db.plans.insertOne(
      PlansCompanion.insert(
        days: "Monday,Tuesday,Wednesday",
        exercises: "Bench press,Rows,Bicep curls",
      ),
    );
    final plan = await (db.plans.select()
          ..where((u) => u.id.equals(id))
          ..limit(1))
        .getSingle();
    await (db.plans.update()..where((u) => u.id.equals(id))).write(
      plan.copyWith(
        days: 'Thursday,Friday',
        exercises: 'Chin-up,Deadlift,Squat',
      ),
    );
    final updatedPlan = await (db.plans.select()
          ..where((u) => u.id.equals(id))
          ..limit(1))
        .getSingle();
    expect(updatedPlan.days, 'Thursday,Friday');
    expect(updatedPlan.exercises, 'Chin-up,Deadlift,Squat');
  });

  test('plans can be deleted', () async {
    final id = await db.plans.insertOne(
      PlansCompanion.insert(
        days: "Monday,Tuesday,Wednesday",
        exercises: "Bench press,Rows,Bicep curls",
      ),
    );
    await (db.plans.deleteWhere((tbl) => tbl.id.equals(id)));
    final plan = await (db.plans.select()
          ..where((u) => u.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
    expect(plan, null);
  });
}
