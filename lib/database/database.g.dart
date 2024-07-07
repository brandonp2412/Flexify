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
  static const VerificationMeta _inclineMeta =
      const VerificationMeta('incline');
  @override
  late final GeneratedColumn<int> incline = GeneratedColumn<int>(
      'incline', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
      'plan_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
        incline,
        planId,
        image
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
    if (data.containsKey('incline')) {
      context.handle(_inclineMeta,
          incline.isAcceptableOrUnknown(data['incline']!, _inclineMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
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
      incline: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}incline']),
      planId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plan_id']),
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
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
  final int? incline;
  final int? planId;
  final String? image;
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
      this.incline,
      this.planId,
      this.image});
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
    if (!nullToAbsent || incline != null) {
      map['incline'] = Variable<int>(incline);
    }
    if (!nullToAbsent || planId != null) {
      map['plan_id'] = Variable<int>(planId);
    }
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
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
      incline: incline == null && nullToAbsent
          ? const Value.absent()
          : Value(incline),
      planId:
          planId == null && nullToAbsent ? const Value.absent() : Value(planId),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
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
      incline: serializer.fromJson<int?>(json['incline']),
      planId: serializer.fromJson<int?>(json['planId']),
      image: serializer.fromJson<String?>(json['image']),
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
      'incline': serializer.toJson<int?>(incline),
      'planId': serializer.toJson<int?>(planId),
      'image': serializer.toJson<String?>(image),
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
          Value<int?> incline = const Value.absent(),
          Value<int?> planId = const Value.absent(),
          Value<String?> image = const Value.absent()}) =>
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
        incline: incline.present ? incline.value : this.incline,
        planId: planId.present ? planId.value : this.planId,
        image: image.present ? image.value : this.image,
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
          ..write('incline: $incline, ')
          ..write('planId: $planId, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, reps, weight, unit, created, hidden,
      bodyWeight, duration, distance, cardio, restMs, incline, planId, image);
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
          other.incline == this.incline &&
          other.planId == this.planId &&
          other.image == this.image);
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
  final Value<int?> incline;
  final Value<int?> planId;
  final Value<String?> image;
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
    this.incline = const Value.absent(),
    this.planId = const Value.absent(),
    this.image = const Value.absent(),
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
    this.incline = const Value.absent(),
    this.planId = const Value.absent(),
    this.image = const Value.absent(),
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
    Expression<int>? incline,
    Expression<int>? planId,
    Expression<String>? image,
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
      if (incline != null) 'incline': incline,
      if (planId != null) 'plan_id': planId,
      if (image != null) 'image': image,
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
      Value<int?>? incline,
      Value<int?>? planId,
      Value<String?>? image}) {
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
      incline: incline ?? this.incline,
      planId: planId ?? this.planId,
      image: image ?? this.image,
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
    if (incline.present) {
      map['incline'] = Variable<int>(incline.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
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
          ..write('incline: $incline, ')
          ..write('planId: $planId, ')
          ..write('image: $image')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _themeModeMeta =
      const VerificationMeta('themeMode');
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _planTrailingMeta =
      const VerificationMeta('planTrailing');
  @override
  late final GeneratedColumn<String> planTrailing = GeneratedColumn<String>(
      'plan_trailing', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _longDateFormatMeta =
      const VerificationMeta('longDateFormat');
  @override
  late final GeneratedColumn<String> longDateFormat = GeneratedColumn<String>(
      'long_date_format', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _shortDateFormatMeta =
      const VerificationMeta('shortDateFormat');
  @override
  late final GeneratedColumn<String> shortDateFormat = GeneratedColumn<String>(
      'short_date_format', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _alarmSoundMeta =
      const VerificationMeta('alarmSound');
  @override
  late final GeneratedColumn<String> alarmSound = GeneratedColumn<String>(
      'alarm_sound', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cardioUnitMeta =
      const VerificationMeta('cardioUnit');
  @override
  late final GeneratedColumn<String> cardioUnit = GeneratedColumn<String>(
      'cardio_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _strengthUnitMeta =
      const VerificationMeta('strengthUnit');
  @override
  late final GeneratedColumn<String> strengthUnit = GeneratedColumn<String>(
      'strength_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timerDurationMeta =
      const VerificationMeta('timerDuration');
  @override
  late final GeneratedColumn<int> timerDuration = GeneratedColumn<int>(
      'timer_duration', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _maxSetsMeta =
      const VerificationMeta('maxSets');
  @override
  late final GeneratedColumn<int> maxSets = GeneratedColumn<int>(
      'max_sets', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _vibrateMeta =
      const VerificationMeta('vibrate');
  @override
  late final GeneratedColumn<bool> vibrate = GeneratedColumn<bool>(
      'vibrate', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("vibrate" IN (0, 1))'));
  static const VerificationMeta _restTimersMeta =
      const VerificationMeta('restTimers');
  @override
  late final GeneratedColumn<bool> restTimers = GeneratedColumn<bool>(
      'rest_timers', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("rest_timers" IN (0, 1))'));
  static const VerificationMeta _showUnitsMeta =
      const VerificationMeta('showUnits');
  @override
  late final GeneratedColumn<bool> showUnits = GeneratedColumn<bool>(
      'show_units', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_units" IN (0, 1))'));
  static const VerificationMeta _showImagesMeta =
      const VerificationMeta('showImages');
  @override
  late final GeneratedColumn<bool> showImages = GeneratedColumn<bool>(
      'show_images', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_images" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _systemColorsMeta =
      const VerificationMeta('systemColors');
  @override
  late final GeneratedColumn<bool> systemColors = GeneratedColumn<bool>(
      'system_colors', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("system_colors" IN (0, 1))'));
  static const VerificationMeta _explainedPermissionsMeta =
      const VerificationMeta('explainedPermissions');
  @override
  late final GeneratedColumn<bool> explainedPermissions = GeneratedColumn<bool>(
      'explained_permissions', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("explained_permissions" IN (0, 1))'));
  static const VerificationMeta _hideTimerTabMeta =
      const VerificationMeta('hideTimerTab');
  @override
  late final GeneratedColumn<bool> hideTimerTab = GeneratedColumn<bool>(
      'hide_timer_tab', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("hide_timer_tab" IN (0, 1))'));
  static const VerificationMeta _hideHistoryTabMeta =
      const VerificationMeta('hideHistoryTab');
  @override
  late final GeneratedColumn<bool> hideHistoryTab = GeneratedColumn<bool>(
      'hide_history_tab', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("hide_history_tab" IN (0, 1))'));
  static const VerificationMeta _curveLinesMeta =
      const VerificationMeta('curveLines');
  @override
  late final GeneratedColumn<bool> curveLines = GeneratedColumn<bool>(
      'curve_lines', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("curve_lines" IN (0, 1))'));
  static const VerificationMeta _hideWeightMeta =
      const VerificationMeta('hideWeight');
  @override
  late final GeneratedColumn<bool> hideWeight = GeneratedColumn<bool>(
      'hide_weight', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("hide_weight" IN (0, 1))'));
  static const VerificationMeta _groupHistoryMeta =
      const VerificationMeta('groupHistory');
  @override
  late final GeneratedColumn<bool> groupHistory = GeneratedColumn<bool>(
      'group_history', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("group_history" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        themeMode,
        planTrailing,
        longDateFormat,
        shortDateFormat,
        alarmSound,
        cardioUnit,
        strengthUnit,
        timerDuration,
        maxSets,
        vibrate,
        restTimers,
        showUnits,
        showImages,
        systemColors,
        explainedPermissions,
        hideTimerTab,
        hideHistoryTab,
        curveLines,
        hideWeight,
        groupHistory
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(_themeModeMeta,
          themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta));
    } else if (isInserting) {
      context.missing(_themeModeMeta);
    }
    if (data.containsKey('plan_trailing')) {
      context.handle(
          _planTrailingMeta,
          planTrailing.isAcceptableOrUnknown(
              data['plan_trailing']!, _planTrailingMeta));
    } else if (isInserting) {
      context.missing(_planTrailingMeta);
    }
    if (data.containsKey('long_date_format')) {
      context.handle(
          _longDateFormatMeta,
          longDateFormat.isAcceptableOrUnknown(
              data['long_date_format']!, _longDateFormatMeta));
    } else if (isInserting) {
      context.missing(_longDateFormatMeta);
    }
    if (data.containsKey('short_date_format')) {
      context.handle(
          _shortDateFormatMeta,
          shortDateFormat.isAcceptableOrUnknown(
              data['short_date_format']!, _shortDateFormatMeta));
    } else if (isInserting) {
      context.missing(_shortDateFormatMeta);
    }
    if (data.containsKey('alarm_sound')) {
      context.handle(
          _alarmSoundMeta,
          alarmSound.isAcceptableOrUnknown(
              data['alarm_sound']!, _alarmSoundMeta));
    } else if (isInserting) {
      context.missing(_alarmSoundMeta);
    }
    if (data.containsKey('cardio_unit')) {
      context.handle(
          _cardioUnitMeta,
          cardioUnit.isAcceptableOrUnknown(
              data['cardio_unit']!, _cardioUnitMeta));
    } else if (isInserting) {
      context.missing(_cardioUnitMeta);
    }
    if (data.containsKey('strength_unit')) {
      context.handle(
          _strengthUnitMeta,
          strengthUnit.isAcceptableOrUnknown(
              data['strength_unit']!, _strengthUnitMeta));
    } else if (isInserting) {
      context.missing(_strengthUnitMeta);
    }
    if (data.containsKey('timer_duration')) {
      context.handle(
          _timerDurationMeta,
          timerDuration.isAcceptableOrUnknown(
              data['timer_duration']!, _timerDurationMeta));
    } else if (isInserting) {
      context.missing(_timerDurationMeta);
    }
    if (data.containsKey('max_sets')) {
      context.handle(_maxSetsMeta,
          maxSets.isAcceptableOrUnknown(data['max_sets']!, _maxSetsMeta));
    } else if (isInserting) {
      context.missing(_maxSetsMeta);
    }
    if (data.containsKey('vibrate')) {
      context.handle(_vibrateMeta,
          vibrate.isAcceptableOrUnknown(data['vibrate']!, _vibrateMeta));
    } else if (isInserting) {
      context.missing(_vibrateMeta);
    }
    if (data.containsKey('rest_timers')) {
      context.handle(
          _restTimersMeta,
          restTimers.isAcceptableOrUnknown(
              data['rest_timers']!, _restTimersMeta));
    } else if (isInserting) {
      context.missing(_restTimersMeta);
    }
    if (data.containsKey('show_units')) {
      context.handle(_showUnitsMeta,
          showUnits.isAcceptableOrUnknown(data['show_units']!, _showUnitsMeta));
    } else if (isInserting) {
      context.missing(_showUnitsMeta);
    }
    if (data.containsKey('show_images')) {
      context.handle(
          _showImagesMeta,
          showImages.isAcceptableOrUnknown(
              data['show_images']!, _showImagesMeta));
    }
    if (data.containsKey('system_colors')) {
      context.handle(
          _systemColorsMeta,
          systemColors.isAcceptableOrUnknown(
              data['system_colors']!, _systemColorsMeta));
    } else if (isInserting) {
      context.missing(_systemColorsMeta);
    }
    if (data.containsKey('explained_permissions')) {
      context.handle(
          _explainedPermissionsMeta,
          explainedPermissions.isAcceptableOrUnknown(
              data['explained_permissions']!, _explainedPermissionsMeta));
    } else if (isInserting) {
      context.missing(_explainedPermissionsMeta);
    }
    if (data.containsKey('hide_timer_tab')) {
      context.handle(
          _hideTimerTabMeta,
          hideTimerTab.isAcceptableOrUnknown(
              data['hide_timer_tab']!, _hideTimerTabMeta));
    } else if (isInserting) {
      context.missing(_hideTimerTabMeta);
    }
    if (data.containsKey('hide_history_tab')) {
      context.handle(
          _hideHistoryTabMeta,
          hideHistoryTab.isAcceptableOrUnknown(
              data['hide_history_tab']!, _hideHistoryTabMeta));
    } else if (isInserting) {
      context.missing(_hideHistoryTabMeta);
    }
    if (data.containsKey('curve_lines')) {
      context.handle(
          _curveLinesMeta,
          curveLines.isAcceptableOrUnknown(
              data['curve_lines']!, _curveLinesMeta));
    } else if (isInserting) {
      context.missing(_curveLinesMeta);
    }
    if (data.containsKey('hide_weight')) {
      context.handle(
          _hideWeightMeta,
          hideWeight.isAcceptableOrUnknown(
              data['hide_weight']!, _hideWeightMeta));
    } else if (isInserting) {
      context.missing(_hideWeightMeta);
    }
    if (data.containsKey('group_history')) {
      context.handle(
          _groupHistoryMeta,
          groupHistory.isAcceptableOrUnknown(
              data['group_history']!, _groupHistoryMeta));
    } else if (isInserting) {
      context.missing(_groupHistoryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      themeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_mode'])!,
      planTrailing: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_trailing'])!,
      longDateFormat: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}long_date_format'])!,
      shortDateFormat: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}short_date_format'])!,
      alarmSound: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alarm_sound'])!,
      cardioUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cardio_unit'])!,
      strengthUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}strength_unit'])!,
      timerDuration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timer_duration'])!,
      maxSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_sets'])!,
      vibrate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}vibrate'])!,
      restTimers: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}rest_timers'])!,
      showUnits: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_units'])!,
      showImages: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_images'])!,
      systemColors: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}system_colors'])!,
      explainedPermissions: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}explained_permissions'])!,
      hideTimerTab: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hide_timer_tab'])!,
      hideHistoryTab: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hide_history_tab'])!,
      curveLines: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}curve_lines'])!,
      hideWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hide_weight'])!,
      groupHistory: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}group_history'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String themeMode;
  final String planTrailing;
  final String longDateFormat;
  final String shortDateFormat;
  final String alarmSound;
  final String cardioUnit;
  final String strengthUnit;
  final int timerDuration;
  final int maxSets;
  final bool vibrate;
  final bool restTimers;
  final bool showUnits;
  final bool showImages;
  final bool systemColors;
  final bool explainedPermissions;
  final bool hideTimerTab;
  final bool hideHistoryTab;
  final bool curveLines;
  final bool hideWeight;
  final bool groupHistory;
  const Setting(
      {required this.id,
      required this.themeMode,
      required this.planTrailing,
      required this.longDateFormat,
      required this.shortDateFormat,
      required this.alarmSound,
      required this.cardioUnit,
      required this.strengthUnit,
      required this.timerDuration,
      required this.maxSets,
      required this.vibrate,
      required this.restTimers,
      required this.showUnits,
      required this.showImages,
      required this.systemColors,
      required this.explainedPermissions,
      required this.hideTimerTab,
      required this.hideHistoryTab,
      required this.curveLines,
      required this.hideWeight,
      required this.groupHistory});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['plan_trailing'] = Variable<String>(planTrailing);
    map['long_date_format'] = Variable<String>(longDateFormat);
    map['short_date_format'] = Variable<String>(shortDateFormat);
    map['alarm_sound'] = Variable<String>(alarmSound);
    map['cardio_unit'] = Variable<String>(cardioUnit);
    map['strength_unit'] = Variable<String>(strengthUnit);
    map['timer_duration'] = Variable<int>(timerDuration);
    map['max_sets'] = Variable<int>(maxSets);
    map['vibrate'] = Variable<bool>(vibrate);
    map['rest_timers'] = Variable<bool>(restTimers);
    map['show_units'] = Variable<bool>(showUnits);
    map['show_images'] = Variable<bool>(showImages);
    map['system_colors'] = Variable<bool>(systemColors);
    map['explained_permissions'] = Variable<bool>(explainedPermissions);
    map['hide_timer_tab'] = Variable<bool>(hideTimerTab);
    map['hide_history_tab'] = Variable<bool>(hideHistoryTab);
    map['curve_lines'] = Variable<bool>(curveLines);
    map['hide_weight'] = Variable<bool>(hideWeight);
    map['group_history'] = Variable<bool>(groupHistory);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      planTrailing: Value(planTrailing),
      longDateFormat: Value(longDateFormat),
      shortDateFormat: Value(shortDateFormat),
      alarmSound: Value(alarmSound),
      cardioUnit: Value(cardioUnit),
      strengthUnit: Value(strengthUnit),
      timerDuration: Value(timerDuration),
      maxSets: Value(maxSets),
      vibrate: Value(vibrate),
      restTimers: Value(restTimers),
      showUnits: Value(showUnits),
      showImages: Value(showImages),
      systemColors: Value(systemColors),
      explainedPermissions: Value(explainedPermissions),
      hideTimerTab: Value(hideTimerTab),
      hideHistoryTab: Value(hideHistoryTab),
      curveLines: Value(curveLines),
      hideWeight: Value(hideWeight),
      groupHistory: Value(groupHistory),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      planTrailing: serializer.fromJson<String>(json['planTrailing']),
      longDateFormat: serializer.fromJson<String>(json['longDateFormat']),
      shortDateFormat: serializer.fromJson<String>(json['shortDateFormat']),
      alarmSound: serializer.fromJson<String>(json['alarmSound']),
      cardioUnit: serializer.fromJson<String>(json['cardioUnit']),
      strengthUnit: serializer.fromJson<String>(json['strengthUnit']),
      timerDuration: serializer.fromJson<int>(json['timerDuration']),
      maxSets: serializer.fromJson<int>(json['maxSets']),
      vibrate: serializer.fromJson<bool>(json['vibrate']),
      restTimers: serializer.fromJson<bool>(json['restTimers']),
      showUnits: serializer.fromJson<bool>(json['showUnits']),
      showImages: serializer.fromJson<bool>(json['showImages']),
      systemColors: serializer.fromJson<bool>(json['systemColors']),
      explainedPermissions:
          serializer.fromJson<bool>(json['explainedPermissions']),
      hideTimerTab: serializer.fromJson<bool>(json['hideTimerTab']),
      hideHistoryTab: serializer.fromJson<bool>(json['hideHistoryTab']),
      curveLines: serializer.fromJson<bool>(json['curveLines']),
      hideWeight: serializer.fromJson<bool>(json['hideWeight']),
      groupHistory: serializer.fromJson<bool>(json['groupHistory']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'planTrailing': serializer.toJson<String>(planTrailing),
      'longDateFormat': serializer.toJson<String>(longDateFormat),
      'shortDateFormat': serializer.toJson<String>(shortDateFormat),
      'alarmSound': serializer.toJson<String>(alarmSound),
      'cardioUnit': serializer.toJson<String>(cardioUnit),
      'strengthUnit': serializer.toJson<String>(strengthUnit),
      'timerDuration': serializer.toJson<int>(timerDuration),
      'maxSets': serializer.toJson<int>(maxSets),
      'vibrate': serializer.toJson<bool>(vibrate),
      'restTimers': serializer.toJson<bool>(restTimers),
      'showUnits': serializer.toJson<bool>(showUnits),
      'showImages': serializer.toJson<bool>(showImages),
      'systemColors': serializer.toJson<bool>(systemColors),
      'explainedPermissions': serializer.toJson<bool>(explainedPermissions),
      'hideTimerTab': serializer.toJson<bool>(hideTimerTab),
      'hideHistoryTab': serializer.toJson<bool>(hideHistoryTab),
      'curveLines': serializer.toJson<bool>(curveLines),
      'hideWeight': serializer.toJson<bool>(hideWeight),
      'groupHistory': serializer.toJson<bool>(groupHistory),
    };
  }

  Setting copyWith(
          {int? id,
          String? themeMode,
          String? planTrailing,
          String? longDateFormat,
          String? shortDateFormat,
          String? alarmSound,
          String? cardioUnit,
          String? strengthUnit,
          int? timerDuration,
          int? maxSets,
          bool? vibrate,
          bool? restTimers,
          bool? showUnits,
          bool? showImages,
          bool? systemColors,
          bool? explainedPermissions,
          bool? hideTimerTab,
          bool? hideHistoryTab,
          bool? curveLines,
          bool? hideWeight,
          bool? groupHistory}) =>
      Setting(
        id: id ?? this.id,
        themeMode: themeMode ?? this.themeMode,
        planTrailing: planTrailing ?? this.planTrailing,
        longDateFormat: longDateFormat ?? this.longDateFormat,
        shortDateFormat: shortDateFormat ?? this.shortDateFormat,
        alarmSound: alarmSound ?? this.alarmSound,
        cardioUnit: cardioUnit ?? this.cardioUnit,
        strengthUnit: strengthUnit ?? this.strengthUnit,
        timerDuration: timerDuration ?? this.timerDuration,
        maxSets: maxSets ?? this.maxSets,
        vibrate: vibrate ?? this.vibrate,
        restTimers: restTimers ?? this.restTimers,
        showUnits: showUnits ?? this.showUnits,
        showImages: showImages ?? this.showImages,
        systemColors: systemColors ?? this.systemColors,
        explainedPermissions: explainedPermissions ?? this.explainedPermissions,
        hideTimerTab: hideTimerTab ?? this.hideTimerTab,
        hideHistoryTab: hideHistoryTab ?? this.hideHistoryTab,
        curveLines: curveLines ?? this.curveLines,
        hideWeight: hideWeight ?? this.hideWeight,
        groupHistory: groupHistory ?? this.groupHistory,
      );
  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('planTrailing: $planTrailing, ')
          ..write('longDateFormat: $longDateFormat, ')
          ..write('shortDateFormat: $shortDateFormat, ')
          ..write('alarmSound: $alarmSound, ')
          ..write('cardioUnit: $cardioUnit, ')
          ..write('strengthUnit: $strengthUnit, ')
          ..write('timerDuration: $timerDuration, ')
          ..write('maxSets: $maxSets, ')
          ..write('vibrate: $vibrate, ')
          ..write('restTimers: $restTimers, ')
          ..write('showUnits: $showUnits, ')
          ..write('showImages: $showImages, ')
          ..write('systemColors: $systemColors, ')
          ..write('explainedPermissions: $explainedPermissions, ')
          ..write('hideTimerTab: $hideTimerTab, ')
          ..write('hideHistoryTab: $hideHistoryTab, ')
          ..write('curveLines: $curveLines, ')
          ..write('hideWeight: $hideWeight, ')
          ..write('groupHistory: $groupHistory')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        themeMode,
        planTrailing,
        longDateFormat,
        shortDateFormat,
        alarmSound,
        cardioUnit,
        strengthUnit,
        timerDuration,
        maxSets,
        vibrate,
        restTimers,
        showUnits,
        showImages,
        systemColors,
        explainedPermissions,
        hideTimerTab,
        hideHistoryTab,
        curveLines,
        hideWeight,
        groupHistory
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.planTrailing == this.planTrailing &&
          other.longDateFormat == this.longDateFormat &&
          other.shortDateFormat == this.shortDateFormat &&
          other.alarmSound == this.alarmSound &&
          other.cardioUnit == this.cardioUnit &&
          other.strengthUnit == this.strengthUnit &&
          other.timerDuration == this.timerDuration &&
          other.maxSets == this.maxSets &&
          other.vibrate == this.vibrate &&
          other.restTimers == this.restTimers &&
          other.showUnits == this.showUnits &&
          other.showImages == this.showImages &&
          other.systemColors == this.systemColors &&
          other.explainedPermissions == this.explainedPermissions &&
          other.hideTimerTab == this.hideTimerTab &&
          other.hideHistoryTab == this.hideHistoryTab &&
          other.curveLines == this.curveLines &&
          other.hideWeight == this.hideWeight &&
          other.groupHistory == this.groupHistory);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<String> planTrailing;
  final Value<String> longDateFormat;
  final Value<String> shortDateFormat;
  final Value<String> alarmSound;
  final Value<String> cardioUnit;
  final Value<String> strengthUnit;
  final Value<int> timerDuration;
  final Value<int> maxSets;
  final Value<bool> vibrate;
  final Value<bool> restTimers;
  final Value<bool> showUnits;
  final Value<bool> showImages;
  final Value<bool> systemColors;
  final Value<bool> explainedPermissions;
  final Value<bool> hideTimerTab;
  final Value<bool> hideHistoryTab;
  final Value<bool> curveLines;
  final Value<bool> hideWeight;
  final Value<bool> groupHistory;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.planTrailing = const Value.absent(),
    this.longDateFormat = const Value.absent(),
    this.shortDateFormat = const Value.absent(),
    this.alarmSound = const Value.absent(),
    this.cardioUnit = const Value.absent(),
    this.strengthUnit = const Value.absent(),
    this.timerDuration = const Value.absent(),
    this.maxSets = const Value.absent(),
    this.vibrate = const Value.absent(),
    this.restTimers = const Value.absent(),
    this.showUnits = const Value.absent(),
    this.showImages = const Value.absent(),
    this.systemColors = const Value.absent(),
    this.explainedPermissions = const Value.absent(),
    this.hideTimerTab = const Value.absent(),
    this.hideHistoryTab = const Value.absent(),
    this.curveLines = const Value.absent(),
    this.hideWeight = const Value.absent(),
    this.groupHistory = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    required String themeMode,
    required String planTrailing,
    required String longDateFormat,
    required String shortDateFormat,
    required String alarmSound,
    required String cardioUnit,
    required String strengthUnit,
    required int timerDuration,
    required int maxSets,
    required bool vibrate,
    required bool restTimers,
    required bool showUnits,
    this.showImages = const Value.absent(),
    required bool systemColors,
    required bool explainedPermissions,
    required bool hideTimerTab,
    required bool hideHistoryTab,
    required bool curveLines,
    required bool hideWeight,
    required bool groupHistory,
  })  : themeMode = Value(themeMode),
        planTrailing = Value(planTrailing),
        longDateFormat = Value(longDateFormat),
        shortDateFormat = Value(shortDateFormat),
        alarmSound = Value(alarmSound),
        cardioUnit = Value(cardioUnit),
        strengthUnit = Value(strengthUnit),
        timerDuration = Value(timerDuration),
        maxSets = Value(maxSets),
        vibrate = Value(vibrate),
        restTimers = Value(restTimers),
        showUnits = Value(showUnits),
        systemColors = Value(systemColors),
        explainedPermissions = Value(explainedPermissions),
        hideTimerTab = Value(hideTimerTab),
        hideHistoryTab = Value(hideHistoryTab),
        curveLines = Value(curveLines),
        hideWeight = Value(hideWeight),
        groupHistory = Value(groupHistory);
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<String>? planTrailing,
    Expression<String>? longDateFormat,
    Expression<String>? shortDateFormat,
    Expression<String>? alarmSound,
    Expression<String>? cardioUnit,
    Expression<String>? strengthUnit,
    Expression<int>? timerDuration,
    Expression<int>? maxSets,
    Expression<bool>? vibrate,
    Expression<bool>? restTimers,
    Expression<bool>? showUnits,
    Expression<bool>? showImages,
    Expression<bool>? systemColors,
    Expression<bool>? explainedPermissions,
    Expression<bool>? hideTimerTab,
    Expression<bool>? hideHistoryTab,
    Expression<bool>? curveLines,
    Expression<bool>? hideWeight,
    Expression<bool>? groupHistory,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (planTrailing != null) 'plan_trailing': planTrailing,
      if (longDateFormat != null) 'long_date_format': longDateFormat,
      if (shortDateFormat != null) 'short_date_format': shortDateFormat,
      if (alarmSound != null) 'alarm_sound': alarmSound,
      if (cardioUnit != null) 'cardio_unit': cardioUnit,
      if (strengthUnit != null) 'strength_unit': strengthUnit,
      if (timerDuration != null) 'timer_duration': timerDuration,
      if (maxSets != null) 'max_sets': maxSets,
      if (vibrate != null) 'vibrate': vibrate,
      if (restTimers != null) 'rest_timers': restTimers,
      if (showUnits != null) 'show_units': showUnits,
      if (showImages != null) 'show_images': showImages,
      if (systemColors != null) 'system_colors': systemColors,
      if (explainedPermissions != null)
        'explained_permissions': explainedPermissions,
      if (hideTimerTab != null) 'hide_timer_tab': hideTimerTab,
      if (hideHistoryTab != null) 'hide_history_tab': hideHistoryTab,
      if (curveLines != null) 'curve_lines': curveLines,
      if (hideWeight != null) 'hide_weight': hideWeight,
      if (groupHistory != null) 'group_history': groupHistory,
    });
  }

  SettingsCompanion copyWith(
      {Value<int>? id,
      Value<String>? themeMode,
      Value<String>? planTrailing,
      Value<String>? longDateFormat,
      Value<String>? shortDateFormat,
      Value<String>? alarmSound,
      Value<String>? cardioUnit,
      Value<String>? strengthUnit,
      Value<int>? timerDuration,
      Value<int>? maxSets,
      Value<bool>? vibrate,
      Value<bool>? restTimers,
      Value<bool>? showUnits,
      Value<bool>? showImages,
      Value<bool>? systemColors,
      Value<bool>? explainedPermissions,
      Value<bool>? hideTimerTab,
      Value<bool>? hideHistoryTab,
      Value<bool>? curveLines,
      Value<bool>? hideWeight,
      Value<bool>? groupHistory}) {
    return SettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      planTrailing: planTrailing ?? this.planTrailing,
      longDateFormat: longDateFormat ?? this.longDateFormat,
      shortDateFormat: shortDateFormat ?? this.shortDateFormat,
      alarmSound: alarmSound ?? this.alarmSound,
      cardioUnit: cardioUnit ?? this.cardioUnit,
      strengthUnit: strengthUnit ?? this.strengthUnit,
      timerDuration: timerDuration ?? this.timerDuration,
      maxSets: maxSets ?? this.maxSets,
      vibrate: vibrate ?? this.vibrate,
      restTimers: restTimers ?? this.restTimers,
      showUnits: showUnits ?? this.showUnits,
      showImages: showImages ?? this.showImages,
      systemColors: systemColors ?? this.systemColors,
      explainedPermissions: explainedPermissions ?? this.explainedPermissions,
      hideTimerTab: hideTimerTab ?? this.hideTimerTab,
      hideHistoryTab: hideHistoryTab ?? this.hideHistoryTab,
      curveLines: curveLines ?? this.curveLines,
      hideWeight: hideWeight ?? this.hideWeight,
      groupHistory: groupHistory ?? this.groupHistory,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (planTrailing.present) {
      map['plan_trailing'] = Variable<String>(planTrailing.value);
    }
    if (longDateFormat.present) {
      map['long_date_format'] = Variable<String>(longDateFormat.value);
    }
    if (shortDateFormat.present) {
      map['short_date_format'] = Variable<String>(shortDateFormat.value);
    }
    if (alarmSound.present) {
      map['alarm_sound'] = Variable<String>(alarmSound.value);
    }
    if (cardioUnit.present) {
      map['cardio_unit'] = Variable<String>(cardioUnit.value);
    }
    if (strengthUnit.present) {
      map['strength_unit'] = Variable<String>(strengthUnit.value);
    }
    if (timerDuration.present) {
      map['timer_duration'] = Variable<int>(timerDuration.value);
    }
    if (maxSets.present) {
      map['max_sets'] = Variable<int>(maxSets.value);
    }
    if (vibrate.present) {
      map['vibrate'] = Variable<bool>(vibrate.value);
    }
    if (restTimers.present) {
      map['rest_timers'] = Variable<bool>(restTimers.value);
    }
    if (showUnits.present) {
      map['show_units'] = Variable<bool>(showUnits.value);
    }
    if (showImages.present) {
      map['show_images'] = Variable<bool>(showImages.value);
    }
    if (systemColors.present) {
      map['system_colors'] = Variable<bool>(systemColors.value);
    }
    if (explainedPermissions.present) {
      map['explained_permissions'] = Variable<bool>(explainedPermissions.value);
    }
    if (hideTimerTab.present) {
      map['hide_timer_tab'] = Variable<bool>(hideTimerTab.value);
    }
    if (hideHistoryTab.present) {
      map['hide_history_tab'] = Variable<bool>(hideHistoryTab.value);
    }
    if (curveLines.present) {
      map['curve_lines'] = Variable<bool>(curveLines.value);
    }
    if (hideWeight.present) {
      map['hide_weight'] = Variable<bool>(hideWeight.value);
    }
    if (groupHistory.present) {
      map['group_history'] = Variable<bool>(groupHistory.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('planTrailing: $planTrailing, ')
          ..write('longDateFormat: $longDateFormat, ')
          ..write('shortDateFormat: $shortDateFormat, ')
          ..write('alarmSound: $alarmSound, ')
          ..write('cardioUnit: $cardioUnit, ')
          ..write('strengthUnit: $strengthUnit, ')
          ..write('timerDuration: $timerDuration, ')
          ..write('maxSets: $maxSets, ')
          ..write('vibrate: $vibrate, ')
          ..write('restTimers: $restTimers, ')
          ..write('showUnits: $showUnits, ')
          ..write('showImages: $showImages, ')
          ..write('systemColors: $systemColors, ')
          ..write('explainedPermissions: $explainedPermissions, ')
          ..write('hideTimerTab: $hideTimerTab, ')
          ..write('hideHistoryTab: $hideHistoryTab, ')
          ..write('curveLines: $curveLines, ')
          ..write('hideWeight: $hideWeight, ')
          ..write('groupHistory: $groupHistory')
          ..write(')'))
        .toString();
  }
}

class $PlanExercisesTable extends PlanExercises
    with TableInfo<$PlanExercisesTable, PlanExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
      'plan_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES plans (id)'));
  static const VerificationMeta _exerciseMeta =
      const VerificationMeta('exercise');
  @override
  late final GeneratedColumn<String> exercise = GeneratedColumn<String>(
      'exercise', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES gym_sets (name)'));
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'));
  static const VerificationMeta _maxSetsMeta =
      const VerificationMeta('maxSets');
  @override
  late final GeneratedColumn<int> maxSets = GeneratedColumn<int>(
      'max_sets', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, planId, exercise, enabled, maxSets];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_exercises';
  @override
  VerificationContext validateIntegrity(Insertable<PlanExercise> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('exercise')) {
      context.handle(_exerciseMeta,
          exercise.isAcceptableOrUnknown(data['exercise']!, _exerciseMeta));
    } else if (isInserting) {
      context.missing(_exerciseMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('max_sets')) {
      context.handle(_maxSetsMeta,
          maxSets.isAcceptableOrUnknown(data['max_sets']!, _maxSetsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanExercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      planId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plan_id'])!,
      exercise: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      maxSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_sets']),
    );
  }

  @override
  $PlanExercisesTable createAlias(String alias) {
    return $PlanExercisesTable(attachedDatabase, alias);
  }
}

class PlanExercise extends DataClass implements Insertable<PlanExercise> {
  final int id;
  final int planId;
  final String exercise;
  final bool enabled;
  final int? maxSets;
  const PlanExercise(
      {required this.id,
      required this.planId,
      required this.exercise,
      required this.enabled,
      this.maxSets});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<int>(planId);
    map['exercise'] = Variable<String>(exercise);
    map['enabled'] = Variable<bool>(enabled);
    if (!nullToAbsent || maxSets != null) {
      map['max_sets'] = Variable<int>(maxSets);
    }
    return map;
  }

  PlanExercisesCompanion toCompanion(bool nullToAbsent) {
    return PlanExercisesCompanion(
      id: Value(id),
      planId: Value(planId),
      exercise: Value(exercise),
      enabled: Value(enabled),
      maxSets: maxSets == null && nullToAbsent
          ? const Value.absent()
          : Value(maxSets),
    );
  }

  factory PlanExercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanExercise(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int>(json['planId']),
      exercise: serializer.fromJson<String>(json['exercise']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      maxSets: serializer.fromJson<int?>(json['maxSets']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int>(planId),
      'exercise': serializer.toJson<String>(exercise),
      'enabled': serializer.toJson<bool>(enabled),
      'maxSets': serializer.toJson<int?>(maxSets),
    };
  }

  PlanExercise copyWith(
          {int? id,
          int? planId,
          String? exercise,
          bool? enabled,
          Value<int?> maxSets = const Value.absent()}) =>
      PlanExercise(
        id: id ?? this.id,
        planId: planId ?? this.planId,
        exercise: exercise ?? this.exercise,
        enabled: enabled ?? this.enabled,
        maxSets: maxSets.present ? maxSets.value : this.maxSets,
      );
  @override
  String toString() {
    return (StringBuffer('PlanExercise(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('exercise: $exercise, ')
          ..write('enabled: $enabled, ')
          ..write('maxSets: $maxSets')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planId, exercise, enabled, maxSets);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanExercise &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.exercise == this.exercise &&
          other.enabled == this.enabled &&
          other.maxSets == this.maxSets);
}

class PlanExercisesCompanion extends UpdateCompanion<PlanExercise> {
  final Value<int> id;
  final Value<int> planId;
  final Value<String> exercise;
  final Value<bool> enabled;
  final Value<int?> maxSets;
  const PlanExercisesCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.exercise = const Value.absent(),
    this.enabled = const Value.absent(),
    this.maxSets = const Value.absent(),
  });
  PlanExercisesCompanion.insert({
    this.id = const Value.absent(),
    required int planId,
    required String exercise,
    required bool enabled,
    this.maxSets = const Value.absent(),
  })  : planId = Value(planId),
        exercise = Value(exercise),
        enabled = Value(enabled);
  static Insertable<PlanExercise> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<String>? exercise,
    Expression<bool>? enabled,
    Expression<int>? maxSets,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (exercise != null) 'exercise': exercise,
      if (enabled != null) 'enabled': enabled,
      if (maxSets != null) 'max_sets': maxSets,
    });
  }

  PlanExercisesCompanion copyWith(
      {Value<int>? id,
      Value<int>? planId,
      Value<String>? exercise,
      Value<bool>? enabled,
      Value<int?>? maxSets}) {
    return PlanExercisesCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      exercise: exercise ?? this.exercise,
      enabled: enabled ?? this.enabled,
      maxSets: maxSets ?? this.maxSets,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (exercise.present) {
      map['exercise'] = Variable<String>(exercise.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (maxSets.present) {
      map['max_sets'] = Variable<int>(maxSets.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanExercisesCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('exercise: $exercise, ')
          ..write('enabled: $enabled, ')
          ..write('maxSets: $maxSets')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $PlansTable plans = $PlansTable(this);
  late final $GymSetsTable gymSets = $GymSetsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $PlanExercisesTable planExercises = $PlanExercisesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [plans, gymSets, settings, planExercises];
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

  ComposableFilter planExercisesRefs(
      ComposableFilter Function($$PlanExercisesTableFilterComposer f) f) {
    final $$PlanExercisesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.planExercises,
        getReferencedColumn: (t) => t.planId,
        builder: (joinBuilder, parentComposers) =>
            $$PlanExercisesTableFilterComposer(ComposerState($state.db,
                $state.db.planExercises, joinBuilder, parentComposers)));
    return f(composer);
  }
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
  Value<int?> incline,
  Value<int?> planId,
  Value<String?> image,
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
  Value<int?> incline,
  Value<int?> planId,
  Value<String?> image,
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
            Value<int?> incline = const Value.absent(),
            Value<int?> planId = const Value.absent(),
            Value<String?> image = const Value.absent(),
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
            incline: incline,
            planId: planId,
            image: image,
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
            Value<int?> incline = const Value.absent(),
            Value<int?> planId = const Value.absent(),
            Value<String?> image = const Value.absent(),
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
            incline: incline,
            planId: planId,
            image: image,
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

  ColumnFilters<int> get incline => $state.composableBuilder(
      column: $state.table.incline,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get planId => $state.composableBuilder(
      column: $state.table.planId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter planExercisesRefs(
      ComposableFilter Function($$PlanExercisesTableFilterComposer f) f) {
    final $$PlanExercisesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.name,
        referencedTable: $state.db.planExercises,
        getReferencedColumn: (t) => t.exercise,
        builder: (joinBuilder, parentComposers) =>
            $$PlanExercisesTableFilterComposer(ComposerState($state.db,
                $state.db.planExercises, joinBuilder, parentComposers)));
    return f(composer);
  }
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

  ColumnOrderings<int> get incline => $state.composableBuilder(
      column: $state.table.incline,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get planId => $state.composableBuilder(
      column: $state.table.planId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SettingsTableInsertCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  required String themeMode,
  required String planTrailing,
  required String longDateFormat,
  required String shortDateFormat,
  required String alarmSound,
  required String cardioUnit,
  required String strengthUnit,
  required int timerDuration,
  required int maxSets,
  required bool vibrate,
  required bool restTimers,
  required bool showUnits,
  Value<bool> showImages,
  required bool systemColors,
  required bool explainedPermissions,
  required bool hideTimerTab,
  required bool hideHistoryTab,
  required bool curveLines,
  required bool hideWeight,
  required bool groupHistory,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<String> themeMode,
  Value<String> planTrailing,
  Value<String> longDateFormat,
  Value<String> shortDateFormat,
  Value<String> alarmSound,
  Value<String> cardioUnit,
  Value<String> strengthUnit,
  Value<int> timerDuration,
  Value<int> maxSets,
  Value<bool> vibrate,
  Value<bool> restTimers,
  Value<bool> showUnits,
  Value<bool> showImages,
  Value<bool> systemColors,
  Value<bool> explainedPermissions,
  Value<bool> hideTimerTab,
  Value<bool> hideHistoryTab,
  Value<bool> curveLines,
  Value<bool> hideWeight,
  Value<bool> groupHistory,
});

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableProcessedTableManager,
    $$SettingsTableInsertCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SettingsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SettingsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$SettingsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<String> planTrailing = const Value.absent(),
            Value<String> longDateFormat = const Value.absent(),
            Value<String> shortDateFormat = const Value.absent(),
            Value<String> alarmSound = const Value.absent(),
            Value<String> cardioUnit = const Value.absent(),
            Value<String> strengthUnit = const Value.absent(),
            Value<int> timerDuration = const Value.absent(),
            Value<int> maxSets = const Value.absent(),
            Value<bool> vibrate = const Value.absent(),
            Value<bool> restTimers = const Value.absent(),
            Value<bool> showUnits = const Value.absent(),
            Value<bool> showImages = const Value.absent(),
            Value<bool> systemColors = const Value.absent(),
            Value<bool> explainedPermissions = const Value.absent(),
            Value<bool> hideTimerTab = const Value.absent(),
            Value<bool> hideHistoryTab = const Value.absent(),
            Value<bool> curveLines = const Value.absent(),
            Value<bool> hideWeight = const Value.absent(),
            Value<bool> groupHistory = const Value.absent(),
          }) =>
              SettingsCompanion(
            id: id,
            themeMode: themeMode,
            planTrailing: planTrailing,
            longDateFormat: longDateFormat,
            shortDateFormat: shortDateFormat,
            alarmSound: alarmSound,
            cardioUnit: cardioUnit,
            strengthUnit: strengthUnit,
            timerDuration: timerDuration,
            maxSets: maxSets,
            vibrate: vibrate,
            restTimers: restTimers,
            showUnits: showUnits,
            showImages: showImages,
            systemColors: systemColors,
            explainedPermissions: explainedPermissions,
            hideTimerTab: hideTimerTab,
            hideHistoryTab: hideHistoryTab,
            curveLines: curveLines,
            hideWeight: hideWeight,
            groupHistory: groupHistory,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String themeMode,
            required String planTrailing,
            required String longDateFormat,
            required String shortDateFormat,
            required String alarmSound,
            required String cardioUnit,
            required String strengthUnit,
            required int timerDuration,
            required int maxSets,
            required bool vibrate,
            required bool restTimers,
            required bool showUnits,
            Value<bool> showImages = const Value.absent(),
            required bool systemColors,
            required bool explainedPermissions,
            required bool hideTimerTab,
            required bool hideHistoryTab,
            required bool curveLines,
            required bool hideWeight,
            required bool groupHistory,
          }) =>
              SettingsCompanion.insert(
            id: id,
            themeMode: themeMode,
            planTrailing: planTrailing,
            longDateFormat: longDateFormat,
            shortDateFormat: shortDateFormat,
            alarmSound: alarmSound,
            cardioUnit: cardioUnit,
            strengthUnit: strengthUnit,
            timerDuration: timerDuration,
            maxSets: maxSets,
            vibrate: vibrate,
            restTimers: restTimers,
            showUnits: showUnits,
            showImages: showImages,
            systemColors: systemColors,
            explainedPermissions: explainedPermissions,
            hideTimerTab: hideTimerTab,
            hideHistoryTab: hideHistoryTab,
            curveLines: curveLines,
            hideWeight: hideWeight,
            groupHistory: groupHistory,
          ),
        ));
}

class $$SettingsTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableProcessedTableManager,
    $$SettingsTableInsertCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder> {
  $$SettingsTableProcessedTableManager(super.$state);
}

class $$SettingsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get themeMode => $state.composableBuilder(
      column: $state.table.themeMode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get planTrailing => $state.composableBuilder(
      column: $state.table.planTrailing,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get longDateFormat => $state.composableBuilder(
      column: $state.table.longDateFormat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get shortDateFormat => $state.composableBuilder(
      column: $state.table.shortDateFormat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get alarmSound => $state.composableBuilder(
      column: $state.table.alarmSound,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get cardioUnit => $state.composableBuilder(
      column: $state.table.cardioUnit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get strengthUnit => $state.composableBuilder(
      column: $state.table.strengthUnit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get timerDuration => $state.composableBuilder(
      column: $state.table.timerDuration,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get maxSets => $state.composableBuilder(
      column: $state.table.maxSets,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get vibrate => $state.composableBuilder(
      column: $state.table.vibrate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get restTimers => $state.composableBuilder(
      column: $state.table.restTimers,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get showUnits => $state.composableBuilder(
      column: $state.table.showUnits,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get showImages => $state.composableBuilder(
      column: $state.table.showImages,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get systemColors => $state.composableBuilder(
      column: $state.table.systemColors,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get explainedPermissions => $state.composableBuilder(
      column: $state.table.explainedPermissions,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get hideTimerTab => $state.composableBuilder(
      column: $state.table.hideTimerTab,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get hideHistoryTab => $state.composableBuilder(
      column: $state.table.hideHistoryTab,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get curveLines => $state.composableBuilder(
      column: $state.table.curveLines,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get hideWeight => $state.composableBuilder(
      column: $state.table.hideWeight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get groupHistory => $state.composableBuilder(
      column: $state.table.groupHistory,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SettingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get themeMode => $state.composableBuilder(
      column: $state.table.themeMode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get planTrailing => $state.composableBuilder(
      column: $state.table.planTrailing,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get longDateFormat => $state.composableBuilder(
      column: $state.table.longDateFormat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get shortDateFormat => $state.composableBuilder(
      column: $state.table.shortDateFormat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get alarmSound => $state.composableBuilder(
      column: $state.table.alarmSound,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cardioUnit => $state.composableBuilder(
      column: $state.table.cardioUnit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get strengthUnit => $state.composableBuilder(
      column: $state.table.strengthUnit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get timerDuration => $state.composableBuilder(
      column: $state.table.timerDuration,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get maxSets => $state.composableBuilder(
      column: $state.table.maxSets,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get vibrate => $state.composableBuilder(
      column: $state.table.vibrate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get restTimers => $state.composableBuilder(
      column: $state.table.restTimers,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get showUnits => $state.composableBuilder(
      column: $state.table.showUnits,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get showImages => $state.composableBuilder(
      column: $state.table.showImages,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get systemColors => $state.composableBuilder(
      column: $state.table.systemColors,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get explainedPermissions => $state.composableBuilder(
      column: $state.table.explainedPermissions,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get hideTimerTab => $state.composableBuilder(
      column: $state.table.hideTimerTab,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get hideHistoryTab => $state.composableBuilder(
      column: $state.table.hideHistoryTab,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get curveLines => $state.composableBuilder(
      column: $state.table.curveLines,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get hideWeight => $state.composableBuilder(
      column: $state.table.hideWeight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get groupHistory => $state.composableBuilder(
      column: $state.table.groupHistory,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PlanExercisesTableInsertCompanionBuilder = PlanExercisesCompanion
    Function({
  Value<int> id,
  required int planId,
  required String exercise,
  required bool enabled,
  Value<int?> maxSets,
});
typedef $$PlanExercisesTableUpdateCompanionBuilder = PlanExercisesCompanion
    Function({
  Value<int> id,
  Value<int> planId,
  Value<String> exercise,
  Value<bool> enabled,
  Value<int?> maxSets,
});

class $$PlanExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlanExercisesTable,
    PlanExercise,
    $$PlanExercisesTableFilterComposer,
    $$PlanExercisesTableOrderingComposer,
    $$PlanExercisesTableProcessedTableManager,
    $$PlanExercisesTableInsertCompanionBuilder,
    $$PlanExercisesTableUpdateCompanionBuilder> {
  $$PlanExercisesTableTableManager(_$AppDatabase db, $PlanExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PlanExercisesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PlanExercisesTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$PlanExercisesTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> planId = const Value.absent(),
            Value<String> exercise = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<int?> maxSets = const Value.absent(),
          }) =>
              PlanExercisesCompanion(
            id: id,
            planId: planId,
            exercise: exercise,
            enabled: enabled,
            maxSets: maxSets,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int planId,
            required String exercise,
            required bool enabled,
            Value<int?> maxSets = const Value.absent(),
          }) =>
              PlanExercisesCompanion.insert(
            id: id,
            planId: planId,
            exercise: exercise,
            enabled: enabled,
            maxSets: maxSets,
          ),
        ));
}

class $$PlanExercisesTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $PlanExercisesTable,
    PlanExercise,
    $$PlanExercisesTableFilterComposer,
    $$PlanExercisesTableOrderingComposer,
    $$PlanExercisesTableProcessedTableManager,
    $$PlanExercisesTableInsertCompanionBuilder,
    $$PlanExercisesTableUpdateCompanionBuilder> {
  $$PlanExercisesTableProcessedTableManager(super.$state);
}

class $$PlanExercisesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PlanExercisesTable> {
  $$PlanExercisesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get enabled => $state.composableBuilder(
      column: $state.table.enabled,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get maxSets => $state.composableBuilder(
      column: $state.table.maxSets,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$PlansTableFilterComposer get planId {
    final $$PlansTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $state.db.plans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$PlansTableFilterComposer(
            ComposerState(
                $state.db, $state.db.plans, joinBuilder, parentComposers)));
    return composer;
  }

  $$GymSetsTableFilterComposer get exercise {
    final $$GymSetsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exercise,
        referencedTable: $state.db.gymSets,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder, parentComposers) => $$GymSetsTableFilterComposer(
            ComposerState(
                $state.db, $state.db.gymSets, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$PlanExercisesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PlanExercisesTable> {
  $$PlanExercisesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get enabled => $state.composableBuilder(
      column: $state.table.enabled,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get maxSets => $state.composableBuilder(
      column: $state.table.maxSets,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$PlansTableOrderingComposer get planId {
    final $$PlansTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $state.db.plans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) => $$PlansTableOrderingComposer(
            ComposerState(
                $state.db, $state.db.plans, joinBuilder, parentComposers)));
    return composer;
  }

  $$GymSetsTableOrderingComposer get exercise {
    final $$GymSetsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exercise,
        referencedTable: $state.db.gymSets,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder, parentComposers) =>
            $$GymSetsTableOrderingComposer(ComposerState(
                $state.db, $state.db.gymSets, joinBuilder, parentComposers)));
    return composer;
  }
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$PlansTableTableManager get plans =>
      $$PlansTableTableManager(_db, _db.plans);
  $$GymSetsTableTableManager get gymSets =>
      $$GymSetsTableTableManager(_db, _db.gymSets);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$PlanExercisesTableTableManager get planExercises =>
      $$PlanExercisesTableTableManager(_db, _db.planExercises);
}
