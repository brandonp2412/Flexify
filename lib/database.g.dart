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
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool> hidden = GeneratedColumn<bool>(
      'hidden', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("hidden" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _bodyWeightMeta =
      const VerificationMeta('bodyWeight');
  @override
  late final GeneratedColumn<double> bodyWeight = GeneratedColumn<double>(
      'body_weight', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<double> duration = GeneratedColumn<double>(
      'duration', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _distanceMeta =
      const VerificationMeta('distance');
  @override
  late final GeneratedColumn<double> distance = GeneratedColumn<double>(
      'distance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _cardioMeta = const VerificationMeta('cardio');
  @override
  late final GeneratedColumn<bool> cardio = GeneratedColumn<bool>(
      'cardio', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("cardio" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _restMsMeta = const VerificationMeta('restMs');
  @override
  late final GeneratedColumn<int> restMs = GeneratedColumn<int>(
      'rest_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _maxSetsMeta =
      const VerificationMeta('maxSets');
  @override
  late final GeneratedColumn<int> maxSets = GeneratedColumn<int>(
      'max_sets', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _inclineMeta =
      const VerificationMeta('incline');
  @override
  late final GeneratedColumn<int> incline = GeneratedColumn<int>(
      'incline', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        reps,
        weight,
        unit,
        created,
        hidden,
        bodyWeight,
        duration,
        distance,
        cardio,
        restMs,
        maxSets,
        incline
      ];
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
    if (data.containsKey('hidden')) {
      context.handle(_hiddenMeta,
          hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta));
    }
    if (data.containsKey('body_weight')) {
      context.handle(
          _bodyWeightMeta,
          bodyWeight.isAcceptableOrUnknown(
              data['body_weight']!, _bodyWeightMeta));
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    }
    if (data.containsKey('distance')) {
      context.handle(_distanceMeta,
          distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta));
    }
    if (data.containsKey('cardio')) {
      context.handle(_cardioMeta,
          cardio.isAcceptableOrUnknown(data['cardio']!, _cardioMeta));
    }
    if (data.containsKey('rest_ms')) {
      context.handle(_restMsMeta,
          restMs.isAcceptableOrUnknown(data['rest_ms']!, _restMsMeta));
    }
    if (data.containsKey('max_sets')) {
      context.handle(_maxSetsMeta,
          maxSets.isAcceptableOrUnknown(data['max_sets']!, _maxSetsMeta));
    }
    if (data.containsKey('incline')) {
      context.handle(_inclineMeta,
          incline.isAcceptableOrUnknown(data['incline']!, _inclineMeta));
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
      hidden: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hidden'])!,
      bodyWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}body_weight'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}duration'])!,
      distance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}distance'])!,
      cardio: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}cardio'])!,
      restMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rest_ms']),
      maxSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_sets']),
      incline: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}incline']),
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
  final bool hidden;
  final double bodyWeight;
  final double duration;
  final double distance;
  final bool cardio;
  final int? restMs;
  final int? maxSets;
  final int? incline;
  const GymSet(
      {required this.id,
      required this.name,
      required this.reps,
      required this.weight,
      required this.unit,
      required this.created,
      required this.hidden,
      required this.bodyWeight,
      required this.duration,
      required this.distance,
      required this.cardio,
      this.restMs,
      this.maxSets,
      this.incline});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['reps'] = Variable<double>(reps);
    map['weight'] = Variable<double>(weight);
    map['unit'] = Variable<String>(unit);
    map['created'] = Variable<DateTime>(created);
    map['hidden'] = Variable<bool>(hidden);
    map['body_weight'] = Variable<double>(bodyWeight);
    map['duration'] = Variable<double>(duration);
    map['distance'] = Variable<double>(distance);
    map['cardio'] = Variable<bool>(cardio);
    if (!nullToAbsent || restMs != null) {
      map['rest_ms'] = Variable<int>(restMs);
    }
    if (!nullToAbsent || maxSets != null) {
      map['max_sets'] = Variable<int>(maxSets);
    }
    if (!nullToAbsent || incline != null) {
      map['incline'] = Variable<int>(incline);
    }
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
      hidden: Value(hidden),
      bodyWeight: Value(bodyWeight),
      duration: Value(duration),
      distance: Value(distance),
      cardio: Value(cardio),
      restMs:
          restMs == null && nullToAbsent ? const Value.absent() : Value(restMs),
      maxSets: maxSets == null && nullToAbsent
          ? const Value.absent()
          : Value(maxSets),
      incline: incline == null && nullToAbsent
          ? const Value.absent()
          : Value(incline),
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
      hidden: serializer.fromJson<bool>(json['hidden']),
      bodyWeight: serializer.fromJson<double>(json['bodyWeight']),
      duration: serializer.fromJson<double>(json['duration']),
      distance: serializer.fromJson<double>(json['distance']),
      cardio: serializer.fromJson<bool>(json['cardio']),
      restMs: serializer.fromJson<int?>(json['restMs']),
      maxSets: serializer.fromJson<int?>(json['maxSets']),
      incline: serializer.fromJson<int?>(json['incline']),
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
      'hidden': serializer.toJson<bool>(hidden),
      'bodyWeight': serializer.toJson<double>(bodyWeight),
      'duration': serializer.toJson<double>(duration),
      'distance': serializer.toJson<double>(distance),
      'cardio': serializer.toJson<bool>(cardio),
      'restMs': serializer.toJson<int?>(restMs),
      'maxSets': serializer.toJson<int?>(maxSets),
      'incline': serializer.toJson<int?>(incline),
    };
  }

  GymSet copyWith(
          {int? id,
          String? name,
          double? reps,
          double? weight,
          String? unit,
          DateTime? created,
          bool? hidden,
          double? bodyWeight,
          double? duration,
          double? distance,
          bool? cardio,
          Value<int?> restMs = const Value.absent(),
          Value<int?> maxSets = const Value.absent(),
          Value<int?> incline = const Value.absent()}) =>
      GymSet(
        id: id ?? this.id,
        name: name ?? this.name,
        reps: reps ?? this.reps,
        weight: weight ?? this.weight,
        unit: unit ?? this.unit,
        created: created ?? this.created,
        hidden: hidden ?? this.hidden,
        bodyWeight: bodyWeight ?? this.bodyWeight,
        duration: duration ?? this.duration,
        distance: distance ?? this.distance,
        cardio: cardio ?? this.cardio,
        restMs: restMs.present ? restMs.value : this.restMs,
        maxSets: maxSets.present ? maxSets.value : this.maxSets,
        incline: incline.present ? incline.value : this.incline,
      );
  @override
  String toString() {
    return (StringBuffer('GymSet(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('unit: $unit, ')
          ..write('created: $created, ')
          ..write('hidden: $hidden, ')
          ..write('bodyWeight: $bodyWeight, ')
          ..write('duration: $duration, ')
          ..write('distance: $distance, ')
          ..write('cardio: $cardio, ')
          ..write('restMs: $restMs, ')
          ..write('maxSets: $maxSets, ')
          ..write('incline: $incline')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, reps, weight, unit, created, hidden,
      bodyWeight, duration, distance, cardio, restMs, maxSets, incline);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GymSet &&
          other.id == this.id &&
          other.name == this.name &&
          other.reps == this.reps &&
          other.weight == this.weight &&
          other.unit == this.unit &&
          other.created == this.created &&
          other.hidden == this.hidden &&
          other.bodyWeight == this.bodyWeight &&
          other.duration == this.duration &&
          other.distance == this.distance &&
          other.cardio == this.cardio &&
          other.restMs == this.restMs &&
          other.maxSets == this.maxSets &&
          other.incline == this.incline);
}

class GymSetsCompanion extends UpdateCompanion<GymSet> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> reps;
  final Value<double> weight;
  final Value<String> unit;
  final Value<DateTime> created;
  final Value<bool> hidden;
  final Value<double> bodyWeight;
  final Value<double> duration;
  final Value<double> distance;
  final Value<bool> cardio;
  final Value<int?> restMs;
  final Value<int?> maxSets;
  final Value<int?> incline;
  const GymSetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.unit = const Value.absent(),
    this.created = const Value.absent(),
    this.hidden = const Value.absent(),
    this.bodyWeight = const Value.absent(),
    this.duration = const Value.absent(),
    this.distance = const Value.absent(),
    this.cardio = const Value.absent(),
    this.restMs = const Value.absent(),
    this.maxSets = const Value.absent(),
    this.incline = const Value.absent(),
  });
  GymSetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double reps,
    required double weight,
    required String unit,
    required DateTime created,
    this.hidden = const Value.absent(),
    this.bodyWeight = const Value.absent(),
    this.duration = const Value.absent(),
    this.distance = const Value.absent(),
    this.cardio = const Value.absent(),
    this.restMs = const Value.absent(),
    this.maxSets = const Value.absent(),
    this.incline = const Value.absent(),
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
    Expression<bool>? hidden,
    Expression<double>? bodyWeight,
    Expression<double>? duration,
    Expression<double>? distance,
    Expression<bool>? cardio,
    Expression<int>? restMs,
    Expression<int>? maxSets,
    Expression<int>? incline,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (reps != null) 'reps': reps,
      if (weight != null) 'weight': weight,
      if (unit != null) 'unit': unit,
      if (created != null) 'created': created,
      if (hidden != null) 'hidden': hidden,
      if (bodyWeight != null) 'body_weight': bodyWeight,
      if (duration != null) 'duration': duration,
      if (distance != null) 'distance': distance,
      if (cardio != null) 'cardio': cardio,
      if (restMs != null) 'rest_ms': restMs,
      if (maxSets != null) 'max_sets': maxSets,
      if (incline != null) 'incline': incline,
    });
  }

  GymSetsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? reps,
      Value<double>? weight,
      Value<String>? unit,
      Value<DateTime>? created,
      Value<bool>? hidden,
      Value<double>? bodyWeight,
      Value<double>? duration,
      Value<double>? distance,
      Value<bool>? cardio,
      Value<int?>? restMs,
      Value<int?>? maxSets,
      Value<int?>? incline}) {
    return GymSetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      created: created ?? this.created,
      hidden: hidden ?? this.hidden,
      bodyWeight: bodyWeight ?? this.bodyWeight,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      cardio: cardio ?? this.cardio,
      restMs: restMs ?? this.restMs,
      maxSets: maxSets ?? this.maxSets,
      incline: incline ?? this.incline,
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
    if (hidden.present) {
      map['hidden'] = Variable<bool>(hidden.value);
    }
    if (bodyWeight.present) {
      map['body_weight'] = Variable<double>(bodyWeight.value);
    }
    if (duration.present) {
      map['duration'] = Variable<double>(duration.value);
    }
    if (distance.present) {
      map['distance'] = Variable<double>(distance.value);
    }
    if (cardio.present) {
      map['cardio'] = Variable<bool>(cardio.value);
    }
    if (restMs.present) {
      map['rest_ms'] = Variable<int>(restMs.value);
    }
    if (maxSets.present) {
      map['max_sets'] = Variable<int>(maxSets.value);
    }
    if (incline.present) {
      map['incline'] = Variable<int>(incline.value);
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
          ..write('created: $created, ')
          ..write('hidden: $hidden, ')
          ..write('bodyWeight: $bodyWeight, ')
          ..write('duration: $duration, ')
          ..write('distance: $distance, ')
          ..write('cardio: $cardio, ')
          ..write('restMs: $restMs, ')
          ..write('maxSets: $maxSets, ')
          ..write('incline: $incline')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $PlansTable plans = $PlansTable(this);
  late final $GymSetsTable gymSets = $GymSetsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [plans, gymSets];
}

typedef $$PlansTableInsertCompanionBuilder = PlansCompanion Function({
  Value<int> id,
  Value<int?> sequence,
  required String exercises,
  required String days,
  Value<String?> title,
});
typedef $$PlansTableUpdateCompanionBuilder = PlansCompanion Function({
  Value<int> id,
  Value<int?> sequence,
  Value<String> exercises,
  Value<String> days,
  Value<String?> title,
});

class $$PlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlansTable,
    Plan,
    $$PlansTableFilterComposer,
    $$PlansTableOrderingComposer,
    $$PlansTableProcessedTableManager,
    $$PlansTableInsertCompanionBuilder,
    $$PlansTableUpdateCompanionBuilder> {
  $$PlansTableTableManager(_$AppDatabase db, $PlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PlansTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PlansTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$PlansTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int?> sequence = const Value.absent(),
            Value<String> exercises = const Value.absent(),
            Value<String> days = const Value.absent(),
            Value<String?> title = const Value.absent(),
          }) =>
              PlansCompanion(
            id: id,
            sequence: sequence,
            exercises: exercises,
            days: days,
            title: title,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int?> sequence = const Value.absent(),
            required String exercises,
            required String days,
            Value<String?> title = const Value.absent(),
          }) =>
              PlansCompanion.insert(
            id: id,
            sequence: sequence,
            exercises: exercises,
            days: days,
            title: title,
          ),
        ));
}

class $$PlansTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $PlansTable,
    Plan,
    $$PlansTableFilterComposer,
    $$PlansTableOrderingComposer,
    $$PlansTableProcessedTableManager,
    $$PlansTableInsertCompanionBuilder,
    $$PlansTableUpdateCompanionBuilder> {
  $$PlansTableProcessedTableManager(super.$state);
}

class $$PlansTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PlansTable> {
  $$PlansTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sequence => $state.composableBuilder(
      column: $state.table.sequence,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get exercises => $state.composableBuilder(
      column: $state.table.exercises,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get days => $state.composableBuilder(
      column: $state.table.days,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PlansTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PlansTable> {
  $$PlansTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sequence => $state.composableBuilder(
      column: $state.table.sequence,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get exercises => $state.composableBuilder(
      column: $state.table.exercises,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get days => $state.composableBuilder(
      column: $state.table.days,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$GymSetsTableInsertCompanionBuilder = GymSetsCompanion Function({
  Value<int> id,
  required String name,
  required double reps,
  required double weight,
  required String unit,
  required DateTime created,
  Value<bool> hidden,
  Value<double> bodyWeight,
  Value<double> duration,
  Value<double> distance,
  Value<bool> cardio,
  Value<int?> restMs,
  Value<int?> maxSets,
  Value<int?> incline,
});
typedef $$GymSetsTableUpdateCompanionBuilder = GymSetsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> reps,
  Value<double> weight,
  Value<String> unit,
  Value<DateTime> created,
  Value<bool> hidden,
  Value<double> bodyWeight,
  Value<double> duration,
  Value<double> distance,
  Value<bool> cardio,
  Value<int?> restMs,
  Value<int?> maxSets,
  Value<int?> incline,
});

class $$GymSetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GymSetsTable,
    GymSet,
    $$GymSetsTableFilterComposer,
    $$GymSetsTableOrderingComposer,
    $$GymSetsTableProcessedTableManager,
    $$GymSetsTableInsertCompanionBuilder,
    $$GymSetsTableUpdateCompanionBuilder> {
  $$GymSetsTableTableManager(_$AppDatabase db, $GymSetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$GymSetsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$GymSetsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$GymSetsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> reps = const Value.absent(),
            Value<double> weight = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<DateTime> created = const Value.absent(),
            Value<bool> hidden = const Value.absent(),
            Value<double> bodyWeight = const Value.absent(),
            Value<double> duration = const Value.absent(),
            Value<double> distance = const Value.absent(),
            Value<bool> cardio = const Value.absent(),
            Value<int?> restMs = const Value.absent(),
            Value<int?> maxSets = const Value.absent(),
            Value<int?> incline = const Value.absent(),
          }) =>
              GymSetsCompanion(
            id: id,
            name: name,
            reps: reps,
            weight: weight,
            unit: unit,
            created: created,
            hidden: hidden,
            bodyWeight: bodyWeight,
            duration: duration,
            distance: distance,
            cardio: cardio,
            restMs: restMs,
            maxSets: maxSets,
            incline: incline,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double reps,
            required double weight,
            required String unit,
            required DateTime created,
            Value<bool> hidden = const Value.absent(),
            Value<double> bodyWeight = const Value.absent(),
            Value<double> duration = const Value.absent(),
            Value<double> distance = const Value.absent(),
            Value<bool> cardio = const Value.absent(),
            Value<int?> restMs = const Value.absent(),
            Value<int?> maxSets = const Value.absent(),
            Value<int?> incline = const Value.absent(),
          }) =>
              GymSetsCompanion.insert(
            id: id,
            name: name,
            reps: reps,
            weight: weight,
            unit: unit,
            created: created,
            hidden: hidden,
            bodyWeight: bodyWeight,
            duration: duration,
            distance: distance,
            cardio: cardio,
            restMs: restMs,
            maxSets: maxSets,
            incline: incline,
          ),
        ));
}

class $$GymSetsTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $GymSetsTable,
    GymSet,
    $$GymSetsTableFilterComposer,
    $$GymSetsTableOrderingComposer,
    $$GymSetsTableProcessedTableManager,
    $$GymSetsTableInsertCompanionBuilder,
    $$GymSetsTableUpdateCompanionBuilder> {
  $$GymSetsTableProcessedTableManager(super.$state);
}

class $$GymSetsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $GymSetsTable> {
  $$GymSetsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get reps => $state.composableBuilder(
      column: $state.table.reps,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get weight => $state.composableBuilder(
      column: $state.table.weight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get created => $state.composableBuilder(
      column: $state.table.created,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get hidden => $state.composableBuilder(
      column: $state.table.hidden,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get bodyWeight => $state.composableBuilder(
      column: $state.table.bodyWeight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get duration => $state.composableBuilder(
      column: $state.table.duration,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get distance => $state.composableBuilder(
      column: $state.table.distance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get cardio => $state.composableBuilder(
      column: $state.table.cardio,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get restMs => $state.composableBuilder(
      column: $state.table.restMs,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get maxSets => $state.composableBuilder(
      column: $state.table.maxSets,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get incline => $state.composableBuilder(
      column: $state.table.incline,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$GymSetsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $GymSetsTable> {
  $$GymSetsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get reps => $state.composableBuilder(
      column: $state.table.reps,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get weight => $state.composableBuilder(
      column: $state.table.weight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get created => $state.composableBuilder(
      column: $state.table.created,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get hidden => $state.composableBuilder(
      column: $state.table.hidden,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get bodyWeight => $state.composableBuilder(
      column: $state.table.bodyWeight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get duration => $state.composableBuilder(
      column: $state.table.duration,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get distance => $state.composableBuilder(
      column: $state.table.distance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get cardio => $state.composableBuilder(
      column: $state.table.cardio,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get restMs => $state.composableBuilder(
      column: $state.table.restMs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get maxSets => $state.composableBuilder(
      column: $state.table.maxSets,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get incline => $state.composableBuilder(
      column: $state.table.incline,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$PlansTableTableManager get plans =>
      $$PlansTableTableManager(_db, _db.plans);
  $$GymSetsTableTableManager get gymSets =>
      $$GymSetsTableTableManager(_db, _db.gymSets);
}
