// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PlansTable extends Plans with TableInfo<$PlansTable, Plan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sequenceMeta =
      const VerificationMeta('sequence');
  @override
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
      'sequence', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _exercisesMeta =
      const VerificationMeta('exercises');
  @override
  late final GeneratedColumn<String> exercises = GeneratedColumn<String>(
      'exercises', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _daysMeta = const VerificationMeta('days');
  @override
  late final GeneratedColumn<String> days = GeneratedColumn<String>(
      'days', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, sequence, exercises, days, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plans';
  @override
  VerificationContext validateIntegrity(Insertable<Plan> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sequence')) {
      context.handle(_sequenceMeta,
          sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta));
    }
    if (data.containsKey('exercises')) {
      context.handle(_exercisesMeta,
          exercises.isAcceptableOrUnknown(data['exercises']!, _exercisesMeta));
    } else if (isInserting) {
      context.missing(_exercisesMeta);
    }
    if (data.containsKey('days')) {
      context.handle(
          _daysMeta, days.isAcceptableOrUnknown(data['days']!, _daysMeta));
    } else if (isInserting) {
      context.missing(_daysMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Plan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Plan(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sequence: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sequence']),
      exercises: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercises'])!,
      days: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}days'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
    );
  }

  @override
  $PlansTable createAlias(String alias) {
    return $PlansTable(attachedDatabase, alias);
  }
}

class Plan extends DataClass implements Insertable<Plan> {
  final int id;
  final int? sequence;
  final String exercises;
  final String days;
  final String? title;
  const Plan(
      {required this.id,
      this.sequence,
      required this.exercises,
      required this.days,
      this.title});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || sequence != null) {
      map['sequence'] = Variable<int>(sequence);
    }
    map['exercises'] = Variable<String>(exercises);
    map['days'] = Variable<String>(days);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    return map;
  }

  PlansCompanion toCompanion(bool nullToAbsent) {
    return PlansCompanion(
      id: Value(id),
      sequence: sequence == null && nullToAbsent
          ? const Value.absent()
          : Value(sequence),
      exercises: Value(exercises),
      days: Value(days),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
    );
  }

  factory Plan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Plan(
      id: serializer.fromJson<int>(json['id']),
      sequence: serializer.fromJson<int?>(json['sequence']),
      exercises: serializer.fromJson<String>(json['exercises']),
      days: serializer.fromJson<String>(json['days']),
      title: serializer.fromJson<String?>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sequence': serializer.toJson<int?>(sequence),
      'exercises': serializer.toJson<String>(exercises),
      'days': serializer.toJson<String>(days),
      'title': serializer.toJson<String?>(title),
    };
  }

  Plan copyWith(
          {int? id,
          Value<int?> sequence = const Value.absent(),
          String? exercises,
          String? days,
          Value<String?> title = const Value.absent()}) =>
      Plan(
        id: id ?? this.id,
        sequence: sequence.present ? sequence.value : this.sequence,
        exercises: exercises ?? this.exercises,
        days: days ?? this.days,
        title: title.present ? title.value : this.title,
      );
  @override
  String toString() {
    return (StringBuffer('Plan(')
          ..write('id: $id, ')
          ..write('sequence: $sequence, ')
          ..write('exercises: $exercises, ')
          ..write('days: $days, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sequence, exercises, days, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plan &&
          other.id == this.id &&
          other.sequence == this.sequence &&
          other.exercises == this.exercises &&
          other.days == this.days &&
          other.title == this.title);
}

class PlansCompanion extends UpdateCompanion<Plan> {
  final Value<int> id;
  final Value<int?> sequence;
  final Value<String> exercises;
  final Value<String> days;
  final Value<String?> title;
  const PlansCompanion({
    this.id = const Value.absent(),
    this.sequence = const Value.absent(),
    this.exercises = const Value.absent(),
    this.days = const Value.absent(),
    this.title = const Value.absent(),
  });
  PlansCompanion.insert({
    this.id = const Value.absent(),
    this.sequence = const Value.absent(),
    required String exercises,
    required String days,
    this.title = const Value.absent(),
  })  : exercises = Value(exercises),
        days = Value(days);
  static Insertable<Plan> custom({
    Expression<int>? id,
    Expression<int>? sequence,
    Expression<String>? exercises,
    Expression<String>? days,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sequence != null) 'sequence': sequence,
      if (exercises != null) 'exercises': exercises,
      if (days != null) 'days': days,
      if (title != null) 'title': title,
    });
  }

  PlansCompanion copyWith(
      {Value<int>? id,
      Value<int?>? sequence,
      Value<String>? exercises,
      Value<String>? days,
      Value<String?>? title}) {
    return PlansCompanion(
      id: id ?? this.id,
      sequence: sequence ?? this.sequence,
      exercises: exercises ?? this.exercises,
      days: days ?? this.days,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (exercises.present) {
      map['exercises'] = Variable<String>(exercises.value);
    }
    if (days.present) {
      map['days'] = Variable<String>(days.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlansCompanion(')
          ..write('id: $id, ')
          ..write('sequence: $sequence, ')
          ..write('exercises: $exercises, ')
          ..write('days: $days, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $GymSetsTable extends GymSets with TableInfo<$GymSetsTable, GymSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GymSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<double> reps = GeneratedColumn<double>(
      'reps', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdMeta =
      const VerificationMeta('created');
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
      'created', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, reps, weight, unit, created];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gym_sets';
  @override
  VerificationContext validateIntegrity(Insertable<GymSet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created']!, _createdMeta));
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GymSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GymSet(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}reps'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      created: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created'])!,
    );
  }

  @override
  $GymSetsTable createAlias(String alias) {
    return $GymSetsTable(attachedDatabase, alias);
  }
}

class GymSet extends DataClass implements Insertable<GymSet> {
  final int id;
  final String name;
  final double reps;
  final double weight;
  final String unit;
  final DateTime created;
  const GymSet(
      {required this.id,
      required this.name,
      required this.reps,
      required this.weight,
      required this.unit,
      required this.created});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['reps'] = Variable<double>(reps);
    map['weight'] = Variable<double>(weight);
    map['unit'] = Variable<String>(unit);
    map['created'] = Variable<DateTime>(created);
    return map;
  }

  GymSetsCompanion toCompanion(bool nullToAbsent) {
    return GymSetsCompanion(
      id: Value(id),
      name: Value(name),
      reps: Value(reps),
      weight: Value(weight),
      unit: Value(unit),
      created: Value(created),
    );
  }

  factory GymSet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GymSet(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      reps: serializer.fromJson<double>(json['reps']),
      weight: serializer.fromJson<double>(json['weight']),
      unit: serializer.fromJson<String>(json['unit']),
      created: serializer.fromJson<DateTime>(json['created']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'reps': serializer.toJson<double>(reps),
      'weight': serializer.toJson<double>(weight),
      'unit': serializer.toJson<String>(unit),
      'created': serializer.toJson<DateTime>(created),
    };
  }

  GymSet copyWith(
          {int? id,
          String? name,
          double? reps,
          double? weight,
          String? unit,
          DateTime? created}) =>
      GymSet(
        id: id ?? this.id,
        name: name ?? this.name,
        reps: reps ?? this.reps,
        weight: weight ?? this.weight,
        unit: unit ?? this.unit,
        created: created ?? this.created,
      );
  @override
  String toString() {
    return (StringBuffer('GymSet(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('unit: $unit, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, reps, weight, unit, created);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GymSet &&
          other.id == this.id &&
          other.name == this.name &&
          other.reps == this.reps &&
          other.weight == this.weight &&
          other.unit == this.unit &&
          other.created == this.created);
}

class GymSetsCompanion extends UpdateCompanion<GymSet> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> reps;
  final Value<double> weight;
  final Value<String> unit;
  final Value<DateTime> created;
  const GymSetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.unit = const Value.absent(),
    this.created = const Value.absent(),
  });
  GymSetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double reps,
    required double weight,
    required String unit,
    required DateTime created,
  })  : name = Value(name),
        reps = Value(reps),
        weight = Value(weight),
        unit = Value(unit),
        created = Value(created);
  static Insertable<GymSet> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? reps,
    Expression<double>? weight,
    Expression<String>? unit,
    Expression<DateTime>? created,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (reps != null) 'reps': reps,
      if (weight != null) 'weight': weight,
      if (unit != null) 'unit': unit,
      if (created != null) 'created': created,
    });
  }

  GymSetsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? reps,
      Value<double>? weight,
      Value<String>? unit,
      Value<DateTime>? created}) {
    return GymSetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      created: created ?? this.created,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (reps.present) {
      map['reps'] = Variable<double>(reps.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GymSetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('unit: $unit, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $PlansTable plans = $PlansTable(this);
  late final $GymSetsTable gymSets = $GymSetsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [plans, gymSets];
}
