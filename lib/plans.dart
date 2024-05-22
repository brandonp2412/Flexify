import 'package:drift/drift.dart';

class Plans extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sequence => integer().nullable()();
  TextColumn get exercises => text()();
  TextColumn get days => text()();
  TextColumn get title => text().nullable()();
}
