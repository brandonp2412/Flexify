import 'package:drift/internal/versioned_schema.dart' as i0;
import 'package:drift/drift.dart' as i1;
import 'package:drift/drift.dart'; // ignore_for_file: type=lint,unused_import

// GENERATED BY drift_dev, DO NOT MODIFY.
final class Schema2 extends i0.VersionedSchema {
  Schema2({required super.database}) : super(version: 2);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    plans,
    gymSets,
  ];
  late final Shape0 plans = Shape0(
      source: i0.VersionedTable(
        entityName: 'plans',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_1,
          _column_2,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape1 gymSets = Shape1(
      source: i0.VersionedTable(
        entityName: 'gym_sets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
          _column_5,
          _column_6,
          _column_7,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape0 extends i0.VersionedTable {
  Shape0({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get exercises =>
      columnsByName['exercises']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<String> get days =>
      columnsByName['days']! as i1.GeneratedColumn<String>;
}

i1.GeneratedColumn<int> _column_0(String aliasedName) =>
    i1.GeneratedColumn<int>('id', aliasedName, false,
        hasAutoIncrement: true,
        type: i1.DriftSqlType.int,
        defaultConstraints:
            i1.GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
i1.GeneratedColumn<String> _column_1(String aliasedName) =>
    i1.GeneratedColumn<String>('exercises', aliasedName, false,
        type: i1.DriftSqlType.string);
i1.GeneratedColumn<String> _column_2(String aliasedName) =>
    i1.GeneratedColumn<String>('days', aliasedName, false,
        type: i1.DriftSqlType.string);

class Shape1 extends i0.VersionedTable {
  Shape1({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<double> get reps =>
      columnsByName['reps']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<double> get weight =>
      columnsByName['weight']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<String> get unit =>
      columnsByName['unit']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<DateTime> get created =>
      columnsByName['created']! as i1.GeneratedColumn<DateTime>;
}

i1.GeneratedColumn<String> _column_3(String aliasedName) =>
    i1.GeneratedColumn<String>('name', aliasedName, false,
        type: i1.DriftSqlType.string);
i1.GeneratedColumn<double> _column_4(String aliasedName) =>
    i1.GeneratedColumn<double>('reps', aliasedName, false,
        type: i1.DriftSqlType.double);
i1.GeneratedColumn<double> _column_5(String aliasedName) =>
    i1.GeneratedColumn<double>('weight', aliasedName, false,
        type: i1.DriftSqlType.double);
i1.GeneratedColumn<String> _column_6(String aliasedName) =>
    i1.GeneratedColumn<String>('unit', aliasedName, false,
        type: i1.DriftSqlType.string);
i1.GeneratedColumn<DateTime> _column_7(String aliasedName) =>
    i1.GeneratedColumn<DateTime>('created', aliasedName, false,
        type: i1.DriftSqlType.dateTime);

final class Schema3 extends i0.VersionedSchema {
  Schema3({required super.database}) : super(version: 3);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    plans,
    gymSets,
  ];
  late final Shape2 plans = Shape2(
      source: i0.VersionedTable(
        entityName: 'plans',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_8,
          _column_1,
          _column_2,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape1 gymSets = Shape1(
      source: i0.VersionedTable(
        entityName: 'gym_sets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
          _column_5,
          _column_6,
          _column_7,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape2 extends i0.VersionedTable {
  Shape2({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get sequence =>
      columnsByName['sequence']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get exercises =>
      columnsByName['exercises']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<String> get days =>
      columnsByName['days']! as i1.GeneratedColumn<String>;
}

i1.GeneratedColumn<int> _column_8(String aliasedName) =>
    i1.GeneratedColumn<int>('sequence', aliasedName, true,
        type: i1.DriftSqlType.int);

final class Schema4 extends i0.VersionedSchema {
  Schema4({required super.database}) : super(version: 4);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    plans,
    gymSets,
  ];
  late final Shape3 plans = Shape3(
      source: i0.VersionedTable(
        entityName: 'plans',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_8,
          _column_1,
          _column_2,
          _column_9,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape1 gymSets = Shape1(
      source: i0.VersionedTable(
        entityName: 'gym_sets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
          _column_5,
          _column_6,
          _column_7,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape3 extends i0.VersionedTable {
  Shape3({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get sequence =>
      columnsByName['sequence']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get exercises =>
      columnsByName['exercises']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<String> get days =>
      columnsByName['days']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<String> get title =>
      columnsByName['title']! as i1.GeneratedColumn<String>;
}

i1.GeneratedColumn<String> _column_9(String aliasedName) =>
    i1.GeneratedColumn<String>('title', aliasedName, true,
        type: i1.DriftSqlType.string);

final class Schema5 extends i0.VersionedSchema {
  Schema5({required super.database}) : super(version: 5);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    plans,
    gymSets,
  ];
  late final Shape3 plans = Shape3(
      source: i0.VersionedTable(
        entityName: 'plans',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_8,
          _column_1,
          _column_2,
          _column_9,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape4 gymSets = Shape4(
      source: i0.VersionedTable(
        entityName: 'gym_sets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
          _column_5,
          _column_6,
          _column_7,
          _column_10,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape4 extends i0.VersionedTable {
  Shape4({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<double> get reps =>
      columnsByName['reps']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<double> get weight =>
      columnsByName['weight']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<String> get unit =>
      columnsByName['unit']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<DateTime> get created =>
      columnsByName['created']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<bool> get hidden =>
      columnsByName['hidden']! as i1.GeneratedColumn<bool>;
}

i1.GeneratedColumn<bool> _column_10(String aliasedName) =>
    i1.GeneratedColumn<bool>('hidden', aliasedName, false,
        type: i1.DriftSqlType.bool,
        defaultConstraints:
            i1.GeneratedColumn.constraintIsAlways('CHECK ("hidden" IN (0, 1))'),
        defaultValue: const Constant(false));

final class Schema6 extends i0.VersionedSchema {
  Schema6({required super.database}) : super(version: 6);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    plans,
    gymSets,
  ];
  late final Shape3 plans = Shape3(
      source: i0.VersionedTable(
        entityName: 'plans',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_8,
          _column_1,
          _column_2,
          _column_9,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape5 gymSets = Shape5(
      source: i0.VersionedTable(
        entityName: 'gym_sets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
          _column_5,
          _column_6,
          _column_7,
          _column_10,
          _column_11,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape5 extends i0.VersionedTable {
  Shape5({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<double> get reps =>
      columnsByName['reps']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<double> get weight =>
      columnsByName['weight']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<String> get unit =>
      columnsByName['unit']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<DateTime> get created =>
      columnsByName['created']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<bool> get hidden =>
      columnsByName['hidden']! as i1.GeneratedColumn<bool>;
  i1.GeneratedColumn<double> get bodyWeight =>
      columnsByName['body_weight']! as i1.GeneratedColumn<double>;
}

i1.GeneratedColumn<double> _column_11(String aliasedName) =>
    i1.GeneratedColumn<double>('body_weight', aliasedName, false,
        type: i1.DriftSqlType.double, defaultValue: const Constant(0.0));

final class Schema7 extends i0.VersionedSchema {
  Schema7({required super.database}) : super(version: 7);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    plans,
    gymSets,
  ];
  late final Shape3 plans = Shape3(
      source: i0.VersionedTable(
        entityName: 'plans',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_8,
          _column_1,
          _column_2,
          _column_9,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape5 gymSets = Shape5(
      source: i0.VersionedTable(
        entityName: 'gym_sets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
          _column_5,
          _column_6,
          _column_7,
          _column_10,
          _column_11,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

final class Schema8 extends i0.VersionedSchema {
  Schema8({required super.database}) : super(version: 8);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    plans,
    gymSets,
  ];
  late final Shape3 plans = Shape3(
      source: i0.VersionedTable(
        entityName: 'plans',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_8,
          _column_1,
          _column_2,
          _column_9,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape6 gymSets = Shape6(
      source: i0.VersionedTable(
        entityName: 'gym_sets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
          _column_5,
          _column_6,
          _column_7,
          _column_10,
          _column_11,
          _column_12,
          _column_13,
          _column_14,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape6 extends i0.VersionedTable {
  Shape6({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<double> get reps =>
      columnsByName['reps']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<double> get weight =>
      columnsByName['weight']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<String> get unit =>
      columnsByName['unit']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<DateTime> get created =>
      columnsByName['created']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<bool> get hidden =>
      columnsByName['hidden']! as i1.GeneratedColumn<bool>;
  i1.GeneratedColumn<double> get bodyWeight =>
      columnsByName['body_weight']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<double> get duration =>
      columnsByName['duration']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<double> get distance =>
      columnsByName['distance']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<bool> get cardio =>
      columnsByName['cardio']! as i1.GeneratedColumn<bool>;
}

i1.GeneratedColumn<double> _column_12(String aliasedName) =>
    i1.GeneratedColumn<double>('duration', aliasedName, false,
        type: i1.DriftSqlType.double, defaultValue: const Constant(0.0));
i1.GeneratedColumn<double> _column_13(String aliasedName) =>
    i1.GeneratedColumn<double>('distance', aliasedName, false,
        type: i1.DriftSqlType.double, defaultValue: const Constant(0.0));
i1.GeneratedColumn<bool> _column_14(String aliasedName) =>
    i1.GeneratedColumn<bool>('cardio', aliasedName, false,
        type: i1.DriftSqlType.bool,
        defaultConstraints:
            i1.GeneratedColumn.constraintIsAlways('CHECK ("cardio" IN (0, 1))'),
        defaultValue: const Constant(false));

final class Schema10 extends i0.VersionedSchema {
  Schema10({required super.database}) : super(version: 10);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    plans,
    gymSets,
  ];
  late final Shape3 plans = Shape3(
      source: i0.VersionedTable(
        entityName: 'plans',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_8,
          _column_1,
          _column_2,
          _column_9,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape7 gymSets = Shape7(
      source: i0.VersionedTable(
        entityName: 'gym_sets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
          _column_5,
          _column_6,
          _column_7,
          _column_10,
          _column_11,
          _column_12,
          _column_13,
          _column_14,
          _column_15,
          _column_16,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape7 extends i0.VersionedTable {
  Shape7({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<double> get reps =>
      columnsByName['reps']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<double> get weight =>
      columnsByName['weight']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<String> get unit =>
      columnsByName['unit']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<DateTime> get created =>
      columnsByName['created']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<bool> get hidden =>
      columnsByName['hidden']! as i1.GeneratedColumn<bool>;
  i1.GeneratedColumn<double> get bodyWeight =>
      columnsByName['body_weight']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<double> get duration =>
      columnsByName['duration']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<double> get distance =>
      columnsByName['distance']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<bool> get cardio =>
      columnsByName['cardio']! as i1.GeneratedColumn<bool>;
  i1.GeneratedColumn<int> get restMs =>
      columnsByName['rest_ms']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get maxSets =>
      columnsByName['max_sets']! as i1.GeneratedColumn<int>;
}

i1.GeneratedColumn<int> _column_15(String aliasedName) =>
    i1.GeneratedColumn<int>('rest_ms', aliasedName, false,
        type: i1.DriftSqlType.int,
        defaultValue:
            Constant(const Duration(minutes: 3, seconds: 30).inMilliseconds));
i1.GeneratedColumn<int> _column_16(String aliasedName) =>
    i1.GeneratedColumn<int>('max_sets', aliasedName, false,
        type: i1.DriftSqlType.int, defaultValue: const Constant(3));

final class Schema11 extends i0.VersionedSchema {
  Schema11({required super.database}) : super(version: 11);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    plans,
    gymSets,
  ];
  late final Shape3 plans = Shape3(
      source: i0.VersionedTable(
        entityName: 'plans',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_8,
          _column_1,
          _column_2,
          _column_9,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape8 gymSets = Shape8(
      source: i0.VersionedTable(
        entityName: 'gym_sets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
          _column_5,
          _column_6,
          _column_7,
          _column_10,
          _column_11,
          _column_12,
          _column_13,
          _column_14,
          _column_15,
          _column_16,
          _column_17,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

class Shape8 extends i0.VersionedTable {
  Shape8({required super.source, required super.alias}) : super.aliased();
  i1.GeneratedColumn<int> get id =>
      columnsByName['id']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<String> get name =>
      columnsByName['name']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<double> get reps =>
      columnsByName['reps']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<double> get weight =>
      columnsByName['weight']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<String> get unit =>
      columnsByName['unit']! as i1.GeneratedColumn<String>;
  i1.GeneratedColumn<DateTime> get created =>
      columnsByName['created']! as i1.GeneratedColumn<DateTime>;
  i1.GeneratedColumn<bool> get hidden =>
      columnsByName['hidden']! as i1.GeneratedColumn<bool>;
  i1.GeneratedColumn<double> get bodyWeight =>
      columnsByName['body_weight']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<double> get duration =>
      columnsByName['duration']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<double> get distance =>
      columnsByName['distance']! as i1.GeneratedColumn<double>;
  i1.GeneratedColumn<bool> get cardio =>
      columnsByName['cardio']! as i1.GeneratedColumn<bool>;
  i1.GeneratedColumn<int> get restMs =>
      columnsByName['rest_ms']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get maxSets =>
      columnsByName['max_sets']! as i1.GeneratedColumn<int>;
  i1.GeneratedColumn<int> get incline =>
      columnsByName['incline']! as i1.GeneratedColumn<int>;
}

i1.GeneratedColumn<int> _column_17(String aliasedName) =>
    i1.GeneratedColumn<int>('incline', aliasedName, true,
        type: i1.DriftSqlType.int);

final class Schema12 extends i0.VersionedSchema {
  Schema12({required super.database}) : super(version: 12);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    plans,
    gymSets,
  ];
  late final Shape3 plans = Shape3(
      source: i0.VersionedTable(
        entityName: 'plans',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_8,
          _column_1,
          _column_2,
          _column_9,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape8 gymSets = Shape8(
      source: i0.VersionedTable(
        entityName: 'gym_sets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
          _column_5,
          _column_6,
          _column_7,
          _column_10,
          _column_11,
          _column_12,
          _column_13,
          _column_14,
          _column_15,
          _column_16,
          _column_17,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

final class Schema13 extends i0.VersionedSchema {
  Schema13({required super.database}) : super(version: 13);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    plans,
    gymSets,
  ];
  late final Shape3 plans = Shape3(
      source: i0.VersionedTable(
        entityName: 'plans',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_8,
          _column_1,
          _column_2,
          _column_9,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape8 gymSets = Shape8(
      source: i0.VersionedTable(
        entityName: 'gym_sets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
          _column_5,
          _column_6,
          _column_7,
          _column_10,
          _column_11,
          _column_12,
          _column_13,
          _column_14,
          _column_18,
          _column_16,
          _column_17,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

i1.GeneratedColumn<int> _column_18(String aliasedName) =>
    i1.GeneratedColumn<int>('rest_ms', aliasedName, true,
        type: i1.DriftSqlType.int);

final class Schema14 extends i0.VersionedSchema {
  Schema14({required super.database}) : super(version: 14);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    plans,
    gymSets,
  ];
  late final Shape3 plans = Shape3(
      source: i0.VersionedTable(
        entityName: 'plans',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_8,
          _column_1,
          _column_2,
          _column_9,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape8 gymSets = Shape8(
      source: i0.VersionedTable(
        entityName: 'gym_sets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
          _column_5,
          _column_6,
          _column_7,
          _column_10,
          _column_11,
          _column_12,
          _column_13,
          _column_14,
          _column_18,
          _column_19,
          _column_17,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

i1.GeneratedColumn<int> _column_19(String aliasedName) =>
    i1.GeneratedColumn<int>('max_sets', aliasedName, true,
        type: i1.DriftSqlType.int);

final class Schema15 extends i0.VersionedSchema {
  Schema15({required super.database}) : super(version: 15);
  @override
  late final List<i1.DatabaseSchemaEntity> entities = [
    plans,
    gymSets,
  ];
  late final Shape3 plans = Shape3(
      source: i0.VersionedTable(
        entityName: 'plans',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_8,
          _column_1,
          _column_2,
          _column_9,
        ],
        attachedDatabase: database,
      ),
      alias: null);
  late final Shape8 gymSets = Shape8(
      source: i0.VersionedTable(
        entityName: 'gym_sets',
        withoutRowId: false,
        isStrict: false,
        tableConstraints: [],
        columns: [
          _column_0,
          _column_3,
          _column_4,
          _column_5,
          _column_6,
          _column_7,
          _column_10,
          _column_11,
          _column_12,
          _column_13,
          _column_14,
          _column_18,
          _column_19,
          _column_17,
        ],
        attachedDatabase: database,
      ),
      alias: null);
}

i0.MigrationStepWithVersion migrationSteps({
  required Future<void> Function(i1.Migrator m, Schema2 schema) from1To2,
  required Future<void> Function(i1.Migrator m, Schema3 schema) from2To3,
  required Future<void> Function(i1.Migrator m, Schema4 schema) from3To4,
  required Future<void> Function(i1.Migrator m, Schema5 schema) from4To5,
  required Future<void> Function(i1.Migrator m, Schema6 schema) from5To6,
  required Future<void> Function(i1.Migrator m, Schema7 schema) from6To7,
  required Future<void> Function(i1.Migrator m, Schema8 schema) from7To8,
  required Future<void> Function(i1.Migrator m, Schema10 schema) from8To10,
  required Future<void> Function(i1.Migrator m, Schema11 schema) from10To11,
  required Future<void> Function(i1.Migrator m, Schema12 schema) from11To12,
  required Future<void> Function(i1.Migrator m, Schema13 schema) from12To13,
  required Future<void> Function(i1.Migrator m, Schema14 schema) from13To14,
  required Future<void> Function(i1.Migrator m, Schema15 schema) from14To15,
}) {
  return (currentVersion, database) async {
    switch (currentVersion) {
      case 1:
        final schema = Schema2(database: database);
        final migrator = i1.Migrator(database, schema);
        await from1To2(migrator, schema);
        return 2;
      case 2:
        final schema = Schema3(database: database);
        final migrator = i1.Migrator(database, schema);
        await from2To3(migrator, schema);
        return 3;
      case 3:
        final schema = Schema4(database: database);
        final migrator = i1.Migrator(database, schema);
        await from3To4(migrator, schema);
        return 4;
      case 4:
        final schema = Schema5(database: database);
        final migrator = i1.Migrator(database, schema);
        await from4To5(migrator, schema);
        return 5;
      case 5:
        final schema = Schema6(database: database);
        final migrator = i1.Migrator(database, schema);
        await from5To6(migrator, schema);
        return 6;
      case 6:
        final schema = Schema7(database: database);
        final migrator = i1.Migrator(database, schema);
        await from6To7(migrator, schema);
        return 7;
      case 7:
        final schema = Schema8(database: database);
        final migrator = i1.Migrator(database, schema);
        await from7To8(migrator, schema);
        return 8;
      case 8:
        final schema = Schema10(database: database);
        final migrator = i1.Migrator(database, schema);
        await from8To10(migrator, schema);
        return 10;
      case 10:
        final schema = Schema11(database: database);
        final migrator = i1.Migrator(database, schema);
        await from10To11(migrator, schema);
        return 11;
      case 11:
        final schema = Schema12(database: database);
        final migrator = i1.Migrator(database, schema);
        await from11To12(migrator, schema);
        return 12;
      case 12:
        final schema = Schema13(database: database);
        final migrator = i1.Migrator(database, schema);
        await from12To13(migrator, schema);
        return 13;
      case 13:
        final schema = Schema14(database: database);
        final migrator = i1.Migrator(database, schema);
        await from13To14(migrator, schema);
        return 14;
      case 14:
        final schema = Schema15(database: database);
        final migrator = i1.Migrator(database, schema);
        await from14To15(migrator, schema);
        return 15;
      default:
        throw ArgumentError.value('Unknown migration from $currentVersion');
    }
  };
}

i1.OnUpgrade stepByStep({
  required Future<void> Function(i1.Migrator m, Schema2 schema) from1To2,
  required Future<void> Function(i1.Migrator m, Schema3 schema) from2To3,
  required Future<void> Function(i1.Migrator m, Schema4 schema) from3To4,
  required Future<void> Function(i1.Migrator m, Schema5 schema) from4To5,
  required Future<void> Function(i1.Migrator m, Schema6 schema) from5To6,
  required Future<void> Function(i1.Migrator m, Schema7 schema) from6To7,
  required Future<void> Function(i1.Migrator m, Schema8 schema) from7To8,
  required Future<void> Function(i1.Migrator m, Schema10 schema) from8To10,
  required Future<void> Function(i1.Migrator m, Schema11 schema) from10To11,
  required Future<void> Function(i1.Migrator m, Schema12 schema) from11To12,
  required Future<void> Function(i1.Migrator m, Schema13 schema) from12To13,
  required Future<void> Function(i1.Migrator m, Schema14 schema) from13To14,
  required Future<void> Function(i1.Migrator m, Schema15 schema) from14To15,
}) =>
    i0.VersionedSchema.stepByStepHelper(
        step: migrationSteps(
      from1To2: from1To2,
      from2To3: from2To3,
      from3To4: from3To4,
      from4To5: from4To5,
      from5To6: from5To6,
      from6To7: from6To7,
      from7To8: from7To8,
      from8To10: from8To10,
      from10To11: from10To11,
      from11To12: from11To12,
      from12To13: from12To13,
      from13To14: from13To14,
      from14To15: from14To15,
    ));
