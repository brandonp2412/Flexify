import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flexify/database/database.dart';
import 'package:flexify/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  db = AppDatabase(NativeDatabase.memory());

  test('plans can be created', () async {
    final id = await db.plans.insertOne(
      PlansCompanion.insert(
        days: "Monday,Tuesday,Wednesday",
      ),
    );
    expect(id, greaterThan(0));
  });

  test('plans can be read', () async {
    await db.plans.insertOne(
      PlansCompanion.insert(
        id: Value(1),
        days: "Monday,Tuesday,Wednesday",
      ),
    );
    final plan = await (db.plans.select()
          ..where((u) => u.id.equals(1))
          ..limit(1))
        .getSingle();
    expect(plan.days, "Monday,Tuesday,Wednesday");
  });

  test('plans can be updated', () async {
    final id = await db.plans.insertOne(
      PlansCompanion.insert(
        days: "Monday,Tuesday,Wednesday",
      ),
    );
    final plan = await (db.plans.select()
          ..where((u) => u.id.equals(id))
          ..limit(1))
        .getSingle();
    await (db.plans.update()..where((u) => u.id.equals(id))).write(
      plan.copyWith(
        days: 'Thursday,Friday',
      ),
    );
    final updatedPlan = await (db.plans.select()
          ..where((u) => u.id.equals(id))
          ..limit(1))
        .getSingle();
    expect(updatedPlan.days, 'Thursday,Friday');
  });

  test('plans can be deleted', () async {
    final id = await db.plans.insertOne(
      PlansCompanion.insert(
        days: "Monday,Tuesday,Wednesday",
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
