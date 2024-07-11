import 'package:drift/drift.dart';

class Plans extends Table {
  TextColumn get days => text()();
  TextColumn get exercises => text()();
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sequence => integer().nullable()();
  TextColumn get title => text().nullable()();
}
