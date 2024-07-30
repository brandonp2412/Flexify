// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PlansTable extends Plans with TableInfo<$PlansTable, Plan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _daysMeta = const VerificationMeta('days');
  @override
  late final GeneratedColumn<String> days = GeneratedColumn<String>(
      'days', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exercisesMeta =
      const VerificationMeta('exercises');
  @override
  late final GeneratedColumn<String> exercises = GeneratedColumn<String>(
      'exercises', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [days, exercises, id, sequence, title];
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
    if (data.containsKey('days')) {
      context.handle(
          _daysMeta, days.isAcceptableOrUnknown(data['days']!, _daysMeta));
    } else if (isInserting) {
      context.missing(_daysMeta);
    }
    if (data.containsKey('exercises')) {
      context.handle(_exercisesMeta,
          exercises.isAcceptableOrUnknown(data['exercises']!, _exercisesMeta));
    } else if (isInserting) {
      context.missing(_exercisesMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sequence')) {
      context.handle(_sequenceMeta,
          sequence.isAcceptableOrUnknown(data['sequence']!, _sequenceMeta));
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
      days: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}days'])!,
      exercises: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercises'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sequence: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sequence']),
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
  final String days;
  final String exercises;
  final int id;
  final int? sequence;
  final String? title;
  const Plan(
      {required this.days,
      required this.exercises,
      required this.id,
      this.sequence,
      this.title});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['days'] = Variable<String>(days);
    map['exercises'] = Variable<String>(exercises);
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || sequence != null) {
      map['sequence'] = Variable<int>(sequence);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    return map;
  }

  PlansCompanion toCompanion(bool nullToAbsent) {
    return PlansCompanion(
      days: Value(days),
      exercises: Value(exercises),
      id: Value(id),
      sequence: sequence == null && nullToAbsent
          ? const Value.absent()
          : Value(sequence),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
    );
  }

  factory Plan.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Plan(
      days: serializer.fromJson<String>(json['days']),
      exercises: serializer.fromJson<String>(json['exercises']),
      id: serializer.fromJson<int>(json['id']),
      sequence: serializer.fromJson<int?>(json['sequence']),
      title: serializer.fromJson<String?>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'days': serializer.toJson<String>(days),
      'exercises': serializer.toJson<String>(exercises),
      'id': serializer.toJson<int>(id),
      'sequence': serializer.toJson<int?>(sequence),
      'title': serializer.toJson<String?>(title),
    };
  }

  Plan copyWith(
          {String? days,
          String? exercises,
          int? id,
          Value<int?> sequence = const Value.absent(),
          Value<String?> title = const Value.absent()}) =>
      Plan(
        days: days ?? this.days,
        exercises: exercises ?? this.exercises,
        id: id ?? this.id,
        sequence: sequence.present ? sequence.value : this.sequence,
        title: title.present ? title.value : this.title,
      );
  @override
  String toString() {
    return (StringBuffer('Plan(')
          ..write('days: $days, ')
          ..write('exercises: $exercises, ')
          ..write('id: $id, ')
          ..write('sequence: $sequence, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(days, exercises, id, sequence, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plan &&
          other.days == this.days &&
          other.exercises == this.exercises &&
          other.id == this.id &&
          other.sequence == this.sequence &&
          other.title == this.title);
}

class PlansCompanion extends UpdateCompanion<Plan> {
  final Value<String> days;
  final Value<String> exercises;
  final Value<int> id;
  final Value<int?> sequence;
  final Value<String?> title;
  const PlansCompanion({
    this.days = const Value.absent(),
    this.exercises = const Value.absent(),
    this.id = const Value.absent(),
    this.sequence = const Value.absent(),
    this.title = const Value.absent(),
  });
  PlansCompanion.insert({
    required String days,
    required String exercises,
    this.id = const Value.absent(),
    this.sequence = const Value.absent(),
    this.title = const Value.absent(),
  })  : days = Value(days),
        exercises = Value(exercises);
  static Insertable<Plan> custom({
    Expression<String>? days,
    Expression<String>? exercises,
    Expression<int>? id,
    Expression<int>? sequence,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (days != null) 'days': days,
      if (exercises != null) 'exercises': exercises,
      if (id != null) 'id': id,
      if (sequence != null) 'sequence': sequence,
      if (title != null) 'title': title,
    });
  }

  PlansCompanion copyWith(
      {Value<String>? days,
      Value<String>? exercises,
      Value<int>? id,
      Value<int?>? sequence,
      Value<String?>? title}) {
    return PlansCompanion(
      days: days ?? this.days,
      exercises: exercises ?? this.exercises,
      id: id ?? this.id,
      sequence: sequence ?? this.sequence,
      title: title ?? this.title,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (days.present) {
      map['days'] = Variable<String>(days.value);
    }
    if (exercises.present) {
      map['exercises'] = Variable<String>(exercises.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sequence.present) {
      map['sequence'] = Variable<int>(sequence.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlansCompanion(')
          ..write('days: $days, ')
          ..write('exercises: $exercises, ')
          ..write('id: $id, ')
          ..write('sequence: $sequence, ')
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
  static const VerificationMeta _bodyWeightMeta =
      const VerificationMeta('bodyWeight');
  @override
  late final GeneratedColumn<double> bodyWeight = GeneratedColumn<double>(
      'body_weight', aliasedName, false,
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
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdMeta =
      const VerificationMeta('created');
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
      'created', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _distanceMeta =
      const VerificationMeta('distance');
  @override
  late final GeneratedColumn<double> distance = GeneratedColumn<double>(
      'distance', aliasedName, false,
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
  static const VerificationMeta _hiddenMeta = const VerificationMeta('hidden');
  @override
  late final GeneratedColumn<bool> hidden = GeneratedColumn<bool>(
      'hidden', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("hidden" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _imageMeta = const VerificationMeta('image');
  @override
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _inclineMeta =
      const VerificationMeta('incline');
  @override
  late final GeneratedColumn<int> incline = GeneratedColumn<int>(
      'incline', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
      'plan_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<double> reps = GeneratedColumn<double>(
      'reps', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _restMsMeta = const VerificationMeta('restMs');
  @override
  late final GeneratedColumn<int> restMs = GeneratedColumn<int>(
      'rest_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        bodyWeight,
        cardio,
        category,
        created,
        distance,
        duration,
        hidden,
        id,
        image,
        incline,
        name,
        planId,
        reps,
        restMs,
        unit,
        weight
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
    if (data.containsKey('body_weight')) {
      context.handle(
          _bodyWeightMeta,
          bodyWeight.isAcceptableOrUnknown(
              data['body_weight']!, _bodyWeightMeta));
    }
    if (data.containsKey('cardio')) {
      context.handle(_cardioMeta,
          cardio.isAcceptableOrUnknown(data['cardio']!, _cardioMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created']!, _createdMeta));
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('distance')) {
      context.handle(_distanceMeta,
          distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta));
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    }
    if (data.containsKey('hidden')) {
      context.handle(_hiddenMeta,
          hidden.isAcceptableOrUnknown(data['hidden']!, _hiddenMeta));
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('image')) {
      context.handle(
          _imageMeta, image.isAcceptableOrUnknown(data['image']!, _imageMeta));
    }
    if (data.containsKey('incline')) {
      context.handle(_inclineMeta,
          incline.isAcceptableOrUnknown(data['incline']!, _inclineMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('rest_ms')) {
      context.handle(_restMsMeta,
          restMs.isAcceptableOrUnknown(data['rest_ms']!, _restMsMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GymSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GymSet(
      bodyWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}body_weight'])!,
      cardio: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}cardio'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      created: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created'])!,
      distance: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}distance'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}duration'])!,
      hidden: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hidden'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      image: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image']),
      incline: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}incline']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      planId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plan_id']),
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}reps'])!,
      restMs: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rest_ms']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight'])!,
    );
  }

  @override
  $GymSetsTable createAlias(String alias) {
    return $GymSetsTable(attachedDatabase, alias);
  }
}

class GymSet extends DataClass implements Insertable<GymSet> {
  final double bodyWeight;
  final bool cardio;
  final String? category;
  final DateTime created;
  final double distance;
  final double duration;
  final bool hidden;
  final int id;
  final String? image;
  final int? incline;
  final String name;
  final int? planId;
  final double reps;
  final int? restMs;
  final String unit;
  final double weight;
  const GymSet(
      {required this.bodyWeight,
      required this.cardio,
      this.category,
      required this.created,
      required this.distance,
      required this.duration,
      required this.hidden,
      required this.id,
      this.image,
      this.incline,
      required this.name,
      this.planId,
      required this.reps,
      this.restMs,
      required this.unit,
      required this.weight});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['body_weight'] = Variable<double>(bodyWeight);
    map['cardio'] = Variable<bool>(cardio);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['created'] = Variable<DateTime>(created);
    map['distance'] = Variable<double>(distance);
    map['duration'] = Variable<double>(duration);
    map['hidden'] = Variable<bool>(hidden);
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || image != null) {
      map['image'] = Variable<String>(image);
    }
    if (!nullToAbsent || incline != null) {
      map['incline'] = Variable<int>(incline);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || planId != null) {
      map['plan_id'] = Variable<int>(planId);
    }
    map['reps'] = Variable<double>(reps);
    if (!nullToAbsent || restMs != null) {
      map['rest_ms'] = Variable<int>(restMs);
    }
    map['unit'] = Variable<String>(unit);
    map['weight'] = Variable<double>(weight);
    return map;
  }

  GymSetsCompanion toCompanion(bool nullToAbsent) {
    return GymSetsCompanion(
      bodyWeight: Value(bodyWeight),
      cardio: Value(cardio),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      created: Value(created),
      distance: Value(distance),
      duration: Value(duration),
      hidden: Value(hidden),
      id: Value(id),
      image:
          image == null && nullToAbsent ? const Value.absent() : Value(image),
      incline: incline == null && nullToAbsent
          ? const Value.absent()
          : Value(incline),
      name: Value(name),
      planId:
          planId == null && nullToAbsent ? const Value.absent() : Value(planId),
      reps: Value(reps),
      restMs:
          restMs == null && nullToAbsent ? const Value.absent() : Value(restMs),
      unit: Value(unit),
      weight: Value(weight),
    );
  }

  factory GymSet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GymSet(
      bodyWeight: serializer.fromJson<double>(json['bodyWeight']),
      cardio: serializer.fromJson<bool>(json['cardio']),
      category: serializer.fromJson<String?>(json['category']),
      created: serializer.fromJson<DateTime>(json['created']),
      distance: serializer.fromJson<double>(json['distance']),
      duration: serializer.fromJson<double>(json['duration']),
      hidden: serializer.fromJson<bool>(json['hidden']),
      id: serializer.fromJson<int>(json['id']),
      image: serializer.fromJson<String?>(json['image']),
      incline: serializer.fromJson<int?>(json['incline']),
      name: serializer.fromJson<String>(json['name']),
      planId: serializer.fromJson<int?>(json['planId']),
      reps: serializer.fromJson<double>(json['reps']),
      restMs: serializer.fromJson<int?>(json['restMs']),
      unit: serializer.fromJson<String>(json['unit']),
      weight: serializer.fromJson<double>(json['weight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bodyWeight': serializer.toJson<double>(bodyWeight),
      'cardio': serializer.toJson<bool>(cardio),
      'category': serializer.toJson<String?>(category),
      'created': serializer.toJson<DateTime>(created),
      'distance': serializer.toJson<double>(distance),
      'duration': serializer.toJson<double>(duration),
      'hidden': serializer.toJson<bool>(hidden),
      'id': serializer.toJson<int>(id),
      'image': serializer.toJson<String?>(image),
      'incline': serializer.toJson<int?>(incline),
      'name': serializer.toJson<String>(name),
      'planId': serializer.toJson<int?>(planId),
      'reps': serializer.toJson<double>(reps),
      'restMs': serializer.toJson<int?>(restMs),
      'unit': serializer.toJson<String>(unit),
      'weight': serializer.toJson<double>(weight),
    };
  }

  GymSet copyWith(
          {double? bodyWeight,
          bool? cardio,
          Value<String?> category = const Value.absent(),
          DateTime? created,
          double? distance,
          double? duration,
          bool? hidden,
          int? id,
          Value<String?> image = const Value.absent(),
          Value<int?> incline = const Value.absent(),
          String? name,
          Value<int?> planId = const Value.absent(),
          double? reps,
          Value<int?> restMs = const Value.absent(),
          String? unit,
          double? weight}) =>
      GymSet(
        bodyWeight: bodyWeight ?? this.bodyWeight,
        cardio: cardio ?? this.cardio,
        category: category.present ? category.value : this.category,
        created: created ?? this.created,
        distance: distance ?? this.distance,
        duration: duration ?? this.duration,
        hidden: hidden ?? this.hidden,
        id: id ?? this.id,
        image: image.present ? image.value : this.image,
        incline: incline.present ? incline.value : this.incline,
        name: name ?? this.name,
        planId: planId.present ? planId.value : this.planId,
        reps: reps ?? this.reps,
        restMs: restMs.present ? restMs.value : this.restMs,
        unit: unit ?? this.unit,
        weight: weight ?? this.weight,
      );
  @override
  String toString() {
    return (StringBuffer('GymSet(')
          ..write('bodyWeight: $bodyWeight, ')
          ..write('cardio: $cardio, ')
          ..write('category: $category, ')
          ..write('created: $created, ')
          ..write('distance: $distance, ')
          ..write('duration: $duration, ')
          ..write('hidden: $hidden, ')
          ..write('id: $id, ')
          ..write('image: $image, ')
          ..write('incline: $incline, ')
          ..write('name: $name, ')
          ..write('planId: $planId, ')
          ..write('reps: $reps, ')
          ..write('restMs: $restMs, ')
          ..write('unit: $unit, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      bodyWeight,
      cardio,
      category,
      created,
      distance,
      duration,
      hidden,
      id,
      image,
      incline,
      name,
      planId,
      reps,
      restMs,
      unit,
      weight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GymSet &&
          other.bodyWeight == this.bodyWeight &&
          other.cardio == this.cardio &&
          other.category == this.category &&
          other.created == this.created &&
          other.distance == this.distance &&
          other.duration == this.duration &&
          other.hidden == this.hidden &&
          other.id == this.id &&
          other.image == this.image &&
          other.incline == this.incline &&
          other.name == this.name &&
          other.planId == this.planId &&
          other.reps == this.reps &&
          other.restMs == this.restMs &&
          other.unit == this.unit &&
          other.weight == this.weight);
}

class GymSetsCompanion extends UpdateCompanion<GymSet> {
  final Value<double> bodyWeight;
  final Value<bool> cardio;
  final Value<String?> category;
  final Value<DateTime> created;
  final Value<double> distance;
  final Value<double> duration;
  final Value<bool> hidden;
  final Value<int> id;
  final Value<String?> image;
  final Value<int?> incline;
  final Value<String> name;
  final Value<int?> planId;
  final Value<double> reps;
  final Value<int?> restMs;
  final Value<String> unit;
  final Value<double> weight;
  const GymSetsCompanion({
    this.bodyWeight = const Value.absent(),
    this.cardio = const Value.absent(),
    this.category = const Value.absent(),
    this.created = const Value.absent(),
    this.distance = const Value.absent(),
    this.duration = const Value.absent(),
    this.hidden = const Value.absent(),
    this.id = const Value.absent(),
    this.image = const Value.absent(),
    this.incline = const Value.absent(),
    this.name = const Value.absent(),
    this.planId = const Value.absent(),
    this.reps = const Value.absent(),
    this.restMs = const Value.absent(),
    this.unit = const Value.absent(),
    this.weight = const Value.absent(),
  });
  GymSetsCompanion.insert({
    this.bodyWeight = const Value.absent(),
    this.cardio = const Value.absent(),
    this.category = const Value.absent(),
    required DateTime created,
    this.distance = const Value.absent(),
    this.duration = const Value.absent(),
    this.hidden = const Value.absent(),
    this.id = const Value.absent(),
    this.image = const Value.absent(),
    this.incline = const Value.absent(),
    required String name,
    this.planId = const Value.absent(),
    required double reps,
    this.restMs = const Value.absent(),
    required String unit,
    required double weight,
  })  : created = Value(created),
        name = Value(name),
        reps = Value(reps),
        unit = Value(unit),
        weight = Value(weight);
  static Insertable<GymSet> custom({
    Expression<double>? bodyWeight,
    Expression<bool>? cardio,
    Expression<String>? category,
    Expression<DateTime>? created,
    Expression<double>? distance,
    Expression<double>? duration,
    Expression<bool>? hidden,
    Expression<int>? id,
    Expression<String>? image,
    Expression<int>? incline,
    Expression<String>? name,
    Expression<int>? planId,
    Expression<double>? reps,
    Expression<int>? restMs,
    Expression<String>? unit,
    Expression<double>? weight,
  }) {
    return RawValuesInsertable({
      if (bodyWeight != null) 'body_weight': bodyWeight,
      if (cardio != null) 'cardio': cardio,
      if (category != null) 'category': category,
      if (created != null) 'created': created,
      if (distance != null) 'distance': distance,
      if (duration != null) 'duration': duration,
      if (hidden != null) 'hidden': hidden,
      if (id != null) 'id': id,
      if (image != null) 'image': image,
      if (incline != null) 'incline': incline,
      if (name != null) 'name': name,
      if (planId != null) 'plan_id': planId,
      if (reps != null) 'reps': reps,
      if (restMs != null) 'rest_ms': restMs,
      if (unit != null) 'unit': unit,
      if (weight != null) 'weight': weight,
    });
  }

  GymSetsCompanion copyWith(
      {Value<double>? bodyWeight,
      Value<bool>? cardio,
      Value<String?>? category,
      Value<DateTime>? created,
      Value<double>? distance,
      Value<double>? duration,
      Value<bool>? hidden,
      Value<int>? id,
      Value<String?>? image,
      Value<int?>? incline,
      Value<String>? name,
      Value<int?>? planId,
      Value<double>? reps,
      Value<int?>? restMs,
      Value<String>? unit,
      Value<double>? weight}) {
    return GymSetsCompanion(
      bodyWeight: bodyWeight ?? this.bodyWeight,
      cardio: cardio ?? this.cardio,
      category: category ?? this.category,
      created: created ?? this.created,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      hidden: hidden ?? this.hidden,
      id: id ?? this.id,
      image: image ?? this.image,
      incline: incline ?? this.incline,
      name: name ?? this.name,
      planId: planId ?? this.planId,
      reps: reps ?? this.reps,
      restMs: restMs ?? this.restMs,
      unit: unit ?? this.unit,
      weight: weight ?? this.weight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bodyWeight.present) {
      map['body_weight'] = Variable<double>(bodyWeight.value);
    }
    if (cardio.present) {
      map['cardio'] = Variable<bool>(cardio.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (distance.present) {
      map['distance'] = Variable<double>(distance.value);
    }
    if (duration.present) {
      map['duration'] = Variable<double>(duration.value);
    }
    if (hidden.present) {
      map['hidden'] = Variable<bool>(hidden.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (image.present) {
      map['image'] = Variable<String>(image.value);
    }
    if (incline.present) {
      map['incline'] = Variable<int>(incline.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (reps.present) {
      map['reps'] = Variable<double>(reps.value);
    }
    if (restMs.present) {
      map['rest_ms'] = Variable<int>(restMs.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GymSetsCompanion(')
          ..write('bodyWeight: $bodyWeight, ')
          ..write('cardio: $cardio, ')
          ..write('category: $category, ')
          ..write('created: $created, ')
          ..write('distance: $distance, ')
          ..write('duration: $duration, ')
          ..write('hidden: $hidden, ')
          ..write('id: $id, ')
          ..write('image: $image, ')
          ..write('incline: $incline, ')
          ..write('name: $name, ')
          ..write('planId: $planId, ')
          ..write('reps: $reps, ')
          ..write('restMs: $restMs, ')
          ..write('unit: $unit, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _alarmSoundMeta =
      const VerificationMeta('alarmSound');
  @override
  late final GeneratedColumn<String> alarmSound = GeneratedColumn<String>(
      'alarm_sound', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _automaticBackupsMeta =
      const VerificationMeta('automaticBackups');
  @override
  late final GeneratedColumn<bool> automaticBackups = GeneratedColumn<bool>(
      'automatic_backups', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("automatic_backups" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _backupPathMeta =
      const VerificationMeta('backupPath');
  @override
  late final GeneratedColumn<String> backupPath = GeneratedColumn<String>(
      'backup_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cardioUnitMeta =
      const VerificationMeta('cardioUnit');
  @override
  late final GeneratedColumn<String> cardioUnit = GeneratedColumn<String>(
      'cardio_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _curveLinesMeta =
      const VerificationMeta('curveLines');
  @override
  late final GeneratedColumn<bool> curveLines = GeneratedColumn<bool>(
      'curve_lines', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("curve_lines" IN (0, 1))'));
  static const VerificationMeta _durationEstimationMeta =
      const VerificationMeta('durationEstimation');
  @override
  late final GeneratedColumn<bool> durationEstimation = GeneratedColumn<bool>(
      'duration_estimation', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("duration_estimation" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _enableSoundMeta =
      const VerificationMeta('enableSound');
  @override
  late final GeneratedColumn<bool> enableSound = GeneratedColumn<bool>(
      'enable_sound', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("enable_sound" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _explainedPermissionsMeta =
      const VerificationMeta('explainedPermissions');
  @override
  late final GeneratedColumn<bool> explainedPermissions = GeneratedColumn<bool>(
      'explained_permissions', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("explained_permissions" IN (0, 1))'));
  static const VerificationMeta _groupHistoryMeta =
      const VerificationMeta('groupHistory');
  @override
  late final GeneratedColumn<bool> groupHistory = GeneratedColumn<bool>(
      'group_history', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("group_history" IN (0, 1))'));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _longDateFormatMeta =
      const VerificationMeta('longDateFormat');
  @override
  late final GeneratedColumn<String> longDateFormat = GeneratedColumn<String>(
      'long_date_format', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _maxSetsMeta =
      const VerificationMeta('maxSets');
  @override
  late final GeneratedColumn<int> maxSets = GeneratedColumn<int>(
      'max_sets', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _planTrailingMeta =
      const VerificationMeta('planTrailing');
  @override
  late final GeneratedColumn<String> planTrailing = GeneratedColumn<String>(
      'plan_trailing', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _repEstimationMeta =
      const VerificationMeta('repEstimation');
  @override
  late final GeneratedColumn<bool> repEstimation = GeneratedColumn<bool>(
      'rep_estimation', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("rep_estimation" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _restTimersMeta =
      const VerificationMeta('restTimers');
  @override
  late final GeneratedColumn<bool> restTimers = GeneratedColumn<bool>(
      'rest_timers', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("rest_timers" IN (0, 1))'));
  static const VerificationMeta _shortDateFormatMeta =
      const VerificationMeta('shortDateFormat');
  @override
  late final GeneratedColumn<String> shortDateFormat = GeneratedColumn<String>(
      'short_date_format', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _showBodyWeightMeta =
      const VerificationMeta('showBodyWeight');
  @override
  late final GeneratedColumn<bool> showBodyWeight = GeneratedColumn<bool>(
      'show_body_weight', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_body_weight" IN (0, 1))'),
      defaultValue: const Constant(true));
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
  static const VerificationMeta _showUnitsMeta =
      const VerificationMeta('showUnits');
  @override
  late final GeneratedColumn<bool> showUnits = GeneratedColumn<bool>(
      'show_units', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_units" IN (0, 1))'));
  static const VerificationMeta _strengthUnitMeta =
      const VerificationMeta('strengthUnit');
  @override
  late final GeneratedColumn<String> strengthUnit = GeneratedColumn<String>(
      'strength_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _systemColorsMeta =
      const VerificationMeta('systemColors');
  @override
  late final GeneratedColumn<bool> systemColors = GeneratedColumn<bool>(
      'system_colors', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("system_colors" IN (0, 1))'));
  static const VerificationMeta _tabsMeta = const VerificationMeta('tabs');
  @override
  late final GeneratedColumn<String> tabs = GeneratedColumn<String>(
      'tabs', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue:
          const Constant("HistoryPage,PlansPage,GraphsPage,TimerPage"));
  static const VerificationMeta _themeModeMeta =
      const VerificationMeta('themeMode');
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timerDurationMeta =
      const VerificationMeta('timerDuration');
  @override
  late final GeneratedColumn<int> timerDuration = GeneratedColumn<int>(
      'timer_duration', aliasedName, false,
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
  static const VerificationMeta _warmupSetsMeta =
      const VerificationMeta('warmupSets');
  @override
  late final GeneratedColumn<int> warmupSets = GeneratedColumn<int>(
      'warmup_sets', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        alarmSound,
        automaticBackups,
        backupPath,
        cardioUnit,
        curveLines,
        durationEstimation,
        enableSound,
        explainedPermissions,
        groupHistory,
        id,
        longDateFormat,
        maxSets,
        planTrailing,
        repEstimation,
        restTimers,
        shortDateFormat,
        showBodyWeight,
        showImages,
        showUnits,
        strengthUnit,
        systemColors,
        tabs,
        themeMode,
        timerDuration,
        vibrate,
        warmupSets
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
    if (data.containsKey('alarm_sound')) {
      context.handle(
          _alarmSoundMeta,
          alarmSound.isAcceptableOrUnknown(
              data['alarm_sound']!, _alarmSoundMeta));
    } else if (isInserting) {
      context.missing(_alarmSoundMeta);
    }
    if (data.containsKey('automatic_backups')) {
      context.handle(
          _automaticBackupsMeta,
          automaticBackups.isAcceptableOrUnknown(
              data['automatic_backups']!, _automaticBackupsMeta));
    }
    if (data.containsKey('backup_path')) {
      context.handle(
          _backupPathMeta,
          backupPath.isAcceptableOrUnknown(
              data['backup_path']!, _backupPathMeta));
    }
    if (data.containsKey('cardio_unit')) {
      context.handle(
          _cardioUnitMeta,
          cardioUnit.isAcceptableOrUnknown(
              data['cardio_unit']!, _cardioUnitMeta));
    } else if (isInserting) {
      context.missing(_cardioUnitMeta);
    }
    if (data.containsKey('curve_lines')) {
      context.handle(
          _curveLinesMeta,
          curveLines.isAcceptableOrUnknown(
              data['curve_lines']!, _curveLinesMeta));
    } else if (isInserting) {
      context.missing(_curveLinesMeta);
    }
    if (data.containsKey('duration_estimation')) {
      context.handle(
          _durationEstimationMeta,
          durationEstimation.isAcceptableOrUnknown(
              data['duration_estimation']!, _durationEstimationMeta));
    }
    if (data.containsKey('enable_sound')) {
      context.handle(
          _enableSoundMeta,
          enableSound.isAcceptableOrUnknown(
              data['enable_sound']!, _enableSoundMeta));
    }
    if (data.containsKey('explained_permissions')) {
      context.handle(
          _explainedPermissionsMeta,
          explainedPermissions.isAcceptableOrUnknown(
              data['explained_permissions']!, _explainedPermissionsMeta));
    } else if (isInserting) {
      context.missing(_explainedPermissionsMeta);
    }
    if (data.containsKey('group_history')) {
      context.handle(
          _groupHistoryMeta,
          groupHistory.isAcceptableOrUnknown(
              data['group_history']!, _groupHistoryMeta));
    } else if (isInserting) {
      context.missing(_groupHistoryMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('long_date_format')) {
      context.handle(
          _longDateFormatMeta,
          longDateFormat.isAcceptableOrUnknown(
              data['long_date_format']!, _longDateFormatMeta));
    } else if (isInserting) {
      context.missing(_longDateFormatMeta);
    }
    if (data.containsKey('max_sets')) {
      context.handle(_maxSetsMeta,
          maxSets.isAcceptableOrUnknown(data['max_sets']!, _maxSetsMeta));
    } else if (isInserting) {
      context.missing(_maxSetsMeta);
    }
    if (data.containsKey('plan_trailing')) {
      context.handle(
          _planTrailingMeta,
          planTrailing.isAcceptableOrUnknown(
              data['plan_trailing']!, _planTrailingMeta));
    } else if (isInserting) {
      context.missing(_planTrailingMeta);
    }
    if (data.containsKey('rep_estimation')) {
      context.handle(
          _repEstimationMeta,
          repEstimation.isAcceptableOrUnknown(
              data['rep_estimation']!, _repEstimationMeta));
    }
    if (data.containsKey('rest_timers')) {
      context.handle(
          _restTimersMeta,
          restTimers.isAcceptableOrUnknown(
              data['rest_timers']!, _restTimersMeta));
    } else if (isInserting) {
      context.missing(_restTimersMeta);
    }
    if (data.containsKey('short_date_format')) {
      context.handle(
          _shortDateFormatMeta,
          shortDateFormat.isAcceptableOrUnknown(
              data['short_date_format']!, _shortDateFormatMeta));
    } else if (isInserting) {
      context.missing(_shortDateFormatMeta);
    }
    if (data.containsKey('show_body_weight')) {
      context.handle(
          _showBodyWeightMeta,
          showBodyWeight.isAcceptableOrUnknown(
              data['show_body_weight']!, _showBodyWeightMeta));
    }
    if (data.containsKey('show_images')) {
      context.handle(
          _showImagesMeta,
          showImages.isAcceptableOrUnknown(
              data['show_images']!, _showImagesMeta));
    }
    if (data.containsKey('show_units')) {
      context.handle(_showUnitsMeta,
          showUnits.isAcceptableOrUnknown(data['show_units']!, _showUnitsMeta));
    } else if (isInserting) {
      context.missing(_showUnitsMeta);
    }
    if (data.containsKey('strength_unit')) {
      context.handle(
          _strengthUnitMeta,
          strengthUnit.isAcceptableOrUnknown(
              data['strength_unit']!, _strengthUnitMeta));
    } else if (isInserting) {
      context.missing(_strengthUnitMeta);
    }
    if (data.containsKey('system_colors')) {
      context.handle(
          _systemColorsMeta,
          systemColors.isAcceptableOrUnknown(
              data['system_colors']!, _systemColorsMeta));
    } else if (isInserting) {
      context.missing(_systemColorsMeta);
    }
    if (data.containsKey('tabs')) {
      context.handle(
          _tabsMeta, tabs.isAcceptableOrUnknown(data['tabs']!, _tabsMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(_themeModeMeta,
          themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta));
    } else if (isInserting) {
      context.missing(_themeModeMeta);
    }
    if (data.containsKey('timer_duration')) {
      context.handle(
          _timerDurationMeta,
          timerDuration.isAcceptableOrUnknown(
              data['timer_duration']!, _timerDurationMeta));
    } else if (isInserting) {
      context.missing(_timerDurationMeta);
    }
    if (data.containsKey('vibrate')) {
      context.handle(_vibrateMeta,
          vibrate.isAcceptableOrUnknown(data['vibrate']!, _vibrateMeta));
    } else if (isInserting) {
      context.missing(_vibrateMeta);
    }
    if (data.containsKey('warmup_sets')) {
      context.handle(
          _warmupSetsMeta,
          warmupSets.isAcceptableOrUnknown(
              data['warmup_sets']!, _warmupSetsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      alarmSound: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alarm_sound'])!,
      automaticBackups: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}automatic_backups'])!,
      backupPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}backup_path']),
      cardioUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cardio_unit'])!,
      curveLines: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}curve_lines'])!,
      durationEstimation: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}duration_estimation'])!,
      enableSound: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enable_sound'])!,
      explainedPermissions: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}explained_permissions'])!,
      groupHistory: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}group_history'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      longDateFormat: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}long_date_format'])!,
      maxSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_sets'])!,
      planTrailing: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_trailing'])!,
      repEstimation: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}rep_estimation'])!,
      restTimers: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}rest_timers'])!,
      shortDateFormat: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}short_date_format'])!,
      showBodyWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_body_weight'])!,
      showImages: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_images'])!,
      showUnits: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_units'])!,
      strengthUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}strength_unit'])!,
      systemColors: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}system_colors'])!,
      tabs: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tabs'])!,
      themeMode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}theme_mode'])!,
      timerDuration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timer_duration'])!,
      vibrate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}vibrate'])!,
      warmupSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}warmup_sets']),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String alarmSound;
  final bool automaticBackups;
  final String? backupPath;
  final String cardioUnit;
  final bool curveLines;
  final bool durationEstimation;
  final bool enableSound;
  final bool explainedPermissions;
  final bool groupHistory;
  final int id;
  final String longDateFormat;
  final int maxSets;
  final String planTrailing;
  final bool repEstimation;
  final bool restTimers;
  final String shortDateFormat;
  final bool showBodyWeight;
  final bool showImages;
  final bool showUnits;
  final String strengthUnit;
  final bool systemColors;
  final String tabs;
  final String themeMode;
  final int timerDuration;
  final bool vibrate;
  final int? warmupSets;
  const Setting(
      {required this.alarmSound,
      required this.automaticBackups,
      this.backupPath,
      required this.cardioUnit,
      required this.curveLines,
      required this.durationEstimation,
      required this.enableSound,
      required this.explainedPermissions,
      required this.groupHistory,
      required this.id,
      required this.longDateFormat,
      required this.maxSets,
      required this.planTrailing,
      required this.repEstimation,
      required this.restTimers,
      required this.shortDateFormat,
      required this.showBodyWeight,
      required this.showImages,
      required this.showUnits,
      required this.strengthUnit,
      required this.systemColors,
      required this.tabs,
      required this.themeMode,
      required this.timerDuration,
      required this.vibrate,
      this.warmupSets});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['alarm_sound'] = Variable<String>(alarmSound);
    map['automatic_backups'] = Variable<bool>(automaticBackups);
    if (!nullToAbsent || backupPath != null) {
      map['backup_path'] = Variable<String>(backupPath);
    }
    map['cardio_unit'] = Variable<String>(cardioUnit);
    map['curve_lines'] = Variable<bool>(curveLines);
    map['duration_estimation'] = Variable<bool>(durationEstimation);
    map['enable_sound'] = Variable<bool>(enableSound);
    map['explained_permissions'] = Variable<bool>(explainedPermissions);
    map['group_history'] = Variable<bool>(groupHistory);
    map['id'] = Variable<int>(id);
    map['long_date_format'] = Variable<String>(longDateFormat);
    map['max_sets'] = Variable<int>(maxSets);
    map['plan_trailing'] = Variable<String>(planTrailing);
    map['rep_estimation'] = Variable<bool>(repEstimation);
    map['rest_timers'] = Variable<bool>(restTimers);
    map['short_date_format'] = Variable<String>(shortDateFormat);
    map['show_body_weight'] = Variable<bool>(showBodyWeight);
    map['show_images'] = Variable<bool>(showImages);
    map['show_units'] = Variable<bool>(showUnits);
    map['strength_unit'] = Variable<String>(strengthUnit);
    map['system_colors'] = Variable<bool>(systemColors);
    map['tabs'] = Variable<String>(tabs);
    map['theme_mode'] = Variable<String>(themeMode);
    map['timer_duration'] = Variable<int>(timerDuration);
    map['vibrate'] = Variable<bool>(vibrate);
    if (!nullToAbsent || warmupSets != null) {
      map['warmup_sets'] = Variable<int>(warmupSets);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      alarmSound: Value(alarmSound),
      automaticBackups: Value(automaticBackups),
      backupPath: backupPath == null && nullToAbsent
          ? const Value.absent()
          : Value(backupPath),
      cardioUnit: Value(cardioUnit),
      curveLines: Value(curveLines),
      durationEstimation: Value(durationEstimation),
      enableSound: Value(enableSound),
      explainedPermissions: Value(explainedPermissions),
      groupHistory: Value(groupHistory),
      id: Value(id),
      longDateFormat: Value(longDateFormat),
      maxSets: Value(maxSets),
      planTrailing: Value(planTrailing),
      repEstimation: Value(repEstimation),
      restTimers: Value(restTimers),
      shortDateFormat: Value(shortDateFormat),
      showBodyWeight: Value(showBodyWeight),
      showImages: Value(showImages),
      showUnits: Value(showUnits),
      strengthUnit: Value(strengthUnit),
      systemColors: Value(systemColors),
      tabs: Value(tabs),
      themeMode: Value(themeMode),
      timerDuration: Value(timerDuration),
      vibrate: Value(vibrate),
      warmupSets: warmupSets == null && nullToAbsent
          ? const Value.absent()
          : Value(warmupSets),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      alarmSound: serializer.fromJson<String>(json['alarmSound']),
      automaticBackups: serializer.fromJson<bool>(json['automaticBackups']),
      backupPath: serializer.fromJson<String?>(json['backupPath']),
      cardioUnit: serializer.fromJson<String>(json['cardioUnit']),
      curveLines: serializer.fromJson<bool>(json['curveLines']),
      durationEstimation: serializer.fromJson<bool>(json['durationEstimation']),
      enableSound: serializer.fromJson<bool>(json['enableSound']),
      explainedPermissions:
          serializer.fromJson<bool>(json['explainedPermissions']),
      groupHistory: serializer.fromJson<bool>(json['groupHistory']),
      id: serializer.fromJson<int>(json['id']),
      longDateFormat: serializer.fromJson<String>(json['longDateFormat']),
      maxSets: serializer.fromJson<int>(json['maxSets']),
      planTrailing: serializer.fromJson<String>(json['planTrailing']),
      repEstimation: serializer.fromJson<bool>(json['repEstimation']),
      restTimers: serializer.fromJson<bool>(json['restTimers']),
      shortDateFormat: serializer.fromJson<String>(json['shortDateFormat']),
      showBodyWeight: serializer.fromJson<bool>(json['showBodyWeight']),
      showImages: serializer.fromJson<bool>(json['showImages']),
      showUnits: serializer.fromJson<bool>(json['showUnits']),
      strengthUnit: serializer.fromJson<String>(json['strengthUnit']),
      systemColors: serializer.fromJson<bool>(json['systemColors']),
      tabs: serializer.fromJson<String>(json['tabs']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      timerDuration: serializer.fromJson<int>(json['timerDuration']),
      vibrate: serializer.fromJson<bool>(json['vibrate']),
      warmupSets: serializer.fromJson<int?>(json['warmupSets']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'alarmSound': serializer.toJson<String>(alarmSound),
      'automaticBackups': serializer.toJson<bool>(automaticBackups),
      'backupPath': serializer.toJson<String?>(backupPath),
      'cardioUnit': serializer.toJson<String>(cardioUnit),
      'curveLines': serializer.toJson<bool>(curveLines),
      'durationEstimation': serializer.toJson<bool>(durationEstimation),
      'enableSound': serializer.toJson<bool>(enableSound),
      'explainedPermissions': serializer.toJson<bool>(explainedPermissions),
      'groupHistory': serializer.toJson<bool>(groupHistory),
      'id': serializer.toJson<int>(id),
      'longDateFormat': serializer.toJson<String>(longDateFormat),
      'maxSets': serializer.toJson<int>(maxSets),
      'planTrailing': serializer.toJson<String>(planTrailing),
      'repEstimation': serializer.toJson<bool>(repEstimation),
      'restTimers': serializer.toJson<bool>(restTimers),
      'shortDateFormat': serializer.toJson<String>(shortDateFormat),
      'showBodyWeight': serializer.toJson<bool>(showBodyWeight),
      'showImages': serializer.toJson<bool>(showImages),
      'showUnits': serializer.toJson<bool>(showUnits),
      'strengthUnit': serializer.toJson<String>(strengthUnit),
      'systemColors': serializer.toJson<bool>(systemColors),
      'tabs': serializer.toJson<String>(tabs),
      'themeMode': serializer.toJson<String>(themeMode),
      'timerDuration': serializer.toJson<int>(timerDuration),
      'vibrate': serializer.toJson<bool>(vibrate),
      'warmupSets': serializer.toJson<int?>(warmupSets),
    };
  }

  Setting copyWith(
          {String? alarmSound,
          bool? automaticBackups,
          Value<String?> backupPath = const Value.absent(),
          String? cardioUnit,
          bool? curveLines,
          bool? durationEstimation,
          bool? enableSound,
          bool? explainedPermissions,
          bool? groupHistory,
          int? id,
          String? longDateFormat,
          int? maxSets,
          String? planTrailing,
          bool? repEstimation,
          bool? restTimers,
          String? shortDateFormat,
          bool? showBodyWeight,
          bool? showImages,
          bool? showUnits,
          String? strengthUnit,
          bool? systemColors,
          String? tabs,
          String? themeMode,
          int? timerDuration,
          bool? vibrate,
          Value<int?> warmupSets = const Value.absent()}) =>
      Setting(
        alarmSound: alarmSound ?? this.alarmSound,
        automaticBackups: automaticBackups ?? this.automaticBackups,
        backupPath: backupPath.present ? backupPath.value : this.backupPath,
        cardioUnit: cardioUnit ?? this.cardioUnit,
        curveLines: curveLines ?? this.curveLines,
        durationEstimation: durationEstimation ?? this.durationEstimation,
        enableSound: enableSound ?? this.enableSound,
        explainedPermissions: explainedPermissions ?? this.explainedPermissions,
        groupHistory: groupHistory ?? this.groupHistory,
        id: id ?? this.id,
        longDateFormat: longDateFormat ?? this.longDateFormat,
        maxSets: maxSets ?? this.maxSets,
        planTrailing: planTrailing ?? this.planTrailing,
        repEstimation: repEstimation ?? this.repEstimation,
        restTimers: restTimers ?? this.restTimers,
        shortDateFormat: shortDateFormat ?? this.shortDateFormat,
        showBodyWeight: showBodyWeight ?? this.showBodyWeight,
        showImages: showImages ?? this.showImages,
        showUnits: showUnits ?? this.showUnits,
        strengthUnit: strengthUnit ?? this.strengthUnit,
        systemColors: systemColors ?? this.systemColors,
        tabs: tabs ?? this.tabs,
        themeMode: themeMode ?? this.themeMode,
        timerDuration: timerDuration ?? this.timerDuration,
        vibrate: vibrate ?? this.vibrate,
        warmupSets: warmupSets.present ? warmupSets.value : this.warmupSets,
      );
  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('alarmSound: $alarmSound, ')
          ..write('automaticBackups: $automaticBackups, ')
          ..write('backupPath: $backupPath, ')
          ..write('cardioUnit: $cardioUnit, ')
          ..write('curveLines: $curveLines, ')
          ..write('durationEstimation: $durationEstimation, ')
          ..write('enableSound: $enableSound, ')
          ..write('explainedPermissions: $explainedPermissions, ')
          ..write('groupHistory: $groupHistory, ')
          ..write('id: $id, ')
          ..write('longDateFormat: $longDateFormat, ')
          ..write('maxSets: $maxSets, ')
          ..write('planTrailing: $planTrailing, ')
          ..write('repEstimation: $repEstimation, ')
          ..write('restTimers: $restTimers, ')
          ..write('shortDateFormat: $shortDateFormat, ')
          ..write('showBodyWeight: $showBodyWeight, ')
          ..write('showImages: $showImages, ')
          ..write('showUnits: $showUnits, ')
          ..write('strengthUnit: $strengthUnit, ')
          ..write('systemColors: $systemColors, ')
          ..write('tabs: $tabs, ')
          ..write('themeMode: $themeMode, ')
          ..write('timerDuration: $timerDuration, ')
          ..write('vibrate: $vibrate, ')
          ..write('warmupSets: $warmupSets')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        alarmSound,
        automaticBackups,
        backupPath,
        cardioUnit,
        curveLines,
        durationEstimation,
        enableSound,
        explainedPermissions,
        groupHistory,
        id,
        longDateFormat,
        maxSets,
        planTrailing,
        repEstimation,
        restTimers,
        shortDateFormat,
        showBodyWeight,
        showImages,
        showUnits,
        strengthUnit,
        systemColors,
        tabs,
        themeMode,
        timerDuration,
        vibrate,
        warmupSets
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.alarmSound == this.alarmSound &&
          other.automaticBackups == this.automaticBackups &&
          other.backupPath == this.backupPath &&
          other.cardioUnit == this.cardioUnit &&
          other.curveLines == this.curveLines &&
          other.durationEstimation == this.durationEstimation &&
          other.enableSound == this.enableSound &&
          other.explainedPermissions == this.explainedPermissions &&
          other.groupHistory == this.groupHistory &&
          other.id == this.id &&
          other.longDateFormat == this.longDateFormat &&
          other.maxSets == this.maxSets &&
          other.planTrailing == this.planTrailing &&
          other.repEstimation == this.repEstimation &&
          other.restTimers == this.restTimers &&
          other.shortDateFormat == this.shortDateFormat &&
          other.showBodyWeight == this.showBodyWeight &&
          other.showImages == this.showImages &&
          other.showUnits == this.showUnits &&
          other.strengthUnit == this.strengthUnit &&
          other.systemColors == this.systemColors &&
          other.tabs == this.tabs &&
          other.themeMode == this.themeMode &&
          other.timerDuration == this.timerDuration &&
          other.vibrate == this.vibrate &&
          other.warmupSets == this.warmupSets);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> alarmSound;
  final Value<bool> automaticBackups;
  final Value<String?> backupPath;
  final Value<String> cardioUnit;
  final Value<bool> curveLines;
  final Value<bool> durationEstimation;
  final Value<bool> enableSound;
  final Value<bool> explainedPermissions;
  final Value<bool> groupHistory;
  final Value<int> id;
  final Value<String> longDateFormat;
  final Value<int> maxSets;
  final Value<String> planTrailing;
  final Value<bool> repEstimation;
  final Value<bool> restTimers;
  final Value<String> shortDateFormat;
  final Value<bool> showBodyWeight;
  final Value<bool> showImages;
  final Value<bool> showUnits;
  final Value<String> strengthUnit;
  final Value<bool> systemColors;
  final Value<String> tabs;
  final Value<String> themeMode;
  final Value<int> timerDuration;
  final Value<bool> vibrate;
  final Value<int?> warmupSets;
  const SettingsCompanion({
    this.alarmSound = const Value.absent(),
    this.automaticBackups = const Value.absent(),
    this.backupPath = const Value.absent(),
    this.cardioUnit = const Value.absent(),
    this.curveLines = const Value.absent(),
    this.durationEstimation = const Value.absent(),
    this.enableSound = const Value.absent(),
    this.explainedPermissions = const Value.absent(),
    this.groupHistory = const Value.absent(),
    this.id = const Value.absent(),
    this.longDateFormat = const Value.absent(),
    this.maxSets = const Value.absent(),
    this.planTrailing = const Value.absent(),
    this.repEstimation = const Value.absent(),
    this.restTimers = const Value.absent(),
    this.shortDateFormat = const Value.absent(),
    this.showBodyWeight = const Value.absent(),
    this.showImages = const Value.absent(),
    this.showUnits = const Value.absent(),
    this.strengthUnit = const Value.absent(),
    this.systemColors = const Value.absent(),
    this.tabs = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.timerDuration = const Value.absent(),
    this.vibrate = const Value.absent(),
    this.warmupSets = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String alarmSound,
    this.automaticBackups = const Value.absent(),
    this.backupPath = const Value.absent(),
    required String cardioUnit,
    required bool curveLines,
    this.durationEstimation = const Value.absent(),
    this.enableSound = const Value.absent(),
    required bool explainedPermissions,
    required bool groupHistory,
    this.id = const Value.absent(),
    required String longDateFormat,
    required int maxSets,
    required String planTrailing,
    this.repEstimation = const Value.absent(),
    required bool restTimers,
    required String shortDateFormat,
    this.showBodyWeight = const Value.absent(),
    this.showImages = const Value.absent(),
    required bool showUnits,
    required String strengthUnit,
    required bool systemColors,
    this.tabs = const Value.absent(),
    required String themeMode,
    required int timerDuration,
    required bool vibrate,
    this.warmupSets = const Value.absent(),
  })  : alarmSound = Value(alarmSound),
        cardioUnit = Value(cardioUnit),
        curveLines = Value(curveLines),
        explainedPermissions = Value(explainedPermissions),
        groupHistory = Value(groupHistory),
        longDateFormat = Value(longDateFormat),
        maxSets = Value(maxSets),
        planTrailing = Value(planTrailing),
        restTimers = Value(restTimers),
        shortDateFormat = Value(shortDateFormat),
        showUnits = Value(showUnits),
        strengthUnit = Value(strengthUnit),
        systemColors = Value(systemColors),
        themeMode = Value(themeMode),
        timerDuration = Value(timerDuration),
        vibrate = Value(vibrate);
  static Insertable<Setting> custom({
    Expression<String>? alarmSound,
    Expression<bool>? automaticBackups,
    Expression<String>? backupPath,
    Expression<String>? cardioUnit,
    Expression<bool>? curveLines,
    Expression<bool>? durationEstimation,
    Expression<bool>? enableSound,
    Expression<bool>? explainedPermissions,
    Expression<bool>? groupHistory,
    Expression<int>? id,
    Expression<String>? longDateFormat,
    Expression<int>? maxSets,
    Expression<String>? planTrailing,
    Expression<bool>? repEstimation,
    Expression<bool>? restTimers,
    Expression<String>? shortDateFormat,
    Expression<bool>? showBodyWeight,
    Expression<bool>? showImages,
    Expression<bool>? showUnits,
    Expression<String>? strengthUnit,
    Expression<bool>? systemColors,
    Expression<String>? tabs,
    Expression<String>? themeMode,
    Expression<int>? timerDuration,
    Expression<bool>? vibrate,
    Expression<int>? warmupSets,
  }) {
    return RawValuesInsertable({
      if (alarmSound != null) 'alarm_sound': alarmSound,
      if (automaticBackups != null) 'automatic_backups': automaticBackups,
      if (backupPath != null) 'backup_path': backupPath,
      if (cardioUnit != null) 'cardio_unit': cardioUnit,
      if (curveLines != null) 'curve_lines': curveLines,
      if (durationEstimation != null) 'duration_estimation': durationEstimation,
      if (enableSound != null) 'enable_sound': enableSound,
      if (explainedPermissions != null)
        'explained_permissions': explainedPermissions,
      if (groupHistory != null) 'group_history': groupHistory,
      if (id != null) 'id': id,
      if (longDateFormat != null) 'long_date_format': longDateFormat,
      if (maxSets != null) 'max_sets': maxSets,
      if (planTrailing != null) 'plan_trailing': planTrailing,
      if (repEstimation != null) 'rep_estimation': repEstimation,
      if (restTimers != null) 'rest_timers': restTimers,
      if (shortDateFormat != null) 'short_date_format': shortDateFormat,
      if (showBodyWeight != null) 'show_body_weight': showBodyWeight,
      if (showImages != null) 'show_images': showImages,
      if (showUnits != null) 'show_units': showUnits,
      if (strengthUnit != null) 'strength_unit': strengthUnit,
      if (systemColors != null) 'system_colors': systemColors,
      if (tabs != null) 'tabs': tabs,
      if (themeMode != null) 'theme_mode': themeMode,
      if (timerDuration != null) 'timer_duration': timerDuration,
      if (vibrate != null) 'vibrate': vibrate,
      if (warmupSets != null) 'warmup_sets': warmupSets,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? alarmSound,
      Value<bool>? automaticBackups,
      Value<String?>? backupPath,
      Value<String>? cardioUnit,
      Value<bool>? curveLines,
      Value<bool>? durationEstimation,
      Value<bool>? enableSound,
      Value<bool>? explainedPermissions,
      Value<bool>? groupHistory,
      Value<int>? id,
      Value<String>? longDateFormat,
      Value<int>? maxSets,
      Value<String>? planTrailing,
      Value<bool>? repEstimation,
      Value<bool>? restTimers,
      Value<String>? shortDateFormat,
      Value<bool>? showBodyWeight,
      Value<bool>? showImages,
      Value<bool>? showUnits,
      Value<String>? strengthUnit,
      Value<bool>? systemColors,
      Value<String>? tabs,
      Value<String>? themeMode,
      Value<int>? timerDuration,
      Value<bool>? vibrate,
      Value<int?>? warmupSets}) {
    return SettingsCompanion(
      alarmSound: alarmSound ?? this.alarmSound,
      automaticBackups: automaticBackups ?? this.automaticBackups,
      backupPath: backupPath ?? this.backupPath,
      cardioUnit: cardioUnit ?? this.cardioUnit,
      curveLines: curveLines ?? this.curveLines,
      durationEstimation: durationEstimation ?? this.durationEstimation,
      enableSound: enableSound ?? this.enableSound,
      explainedPermissions: explainedPermissions ?? this.explainedPermissions,
      groupHistory: groupHistory ?? this.groupHistory,
      id: id ?? this.id,
      longDateFormat: longDateFormat ?? this.longDateFormat,
      maxSets: maxSets ?? this.maxSets,
      planTrailing: planTrailing ?? this.planTrailing,
      repEstimation: repEstimation ?? this.repEstimation,
      restTimers: restTimers ?? this.restTimers,
      shortDateFormat: shortDateFormat ?? this.shortDateFormat,
      showBodyWeight: showBodyWeight ?? this.showBodyWeight,
      showImages: showImages ?? this.showImages,
      showUnits: showUnits ?? this.showUnits,
      strengthUnit: strengthUnit ?? this.strengthUnit,
      systemColors: systemColors ?? this.systemColors,
      tabs: tabs ?? this.tabs,
      themeMode: themeMode ?? this.themeMode,
      timerDuration: timerDuration ?? this.timerDuration,
      vibrate: vibrate ?? this.vibrate,
      warmupSets: warmupSets ?? this.warmupSets,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (alarmSound.present) {
      map['alarm_sound'] = Variable<String>(alarmSound.value);
    }
    if (automaticBackups.present) {
      map['automatic_backups'] = Variable<bool>(automaticBackups.value);
    }
    if (backupPath.present) {
      map['backup_path'] = Variable<String>(backupPath.value);
    }
    if (cardioUnit.present) {
      map['cardio_unit'] = Variable<String>(cardioUnit.value);
    }
    if (curveLines.present) {
      map['curve_lines'] = Variable<bool>(curveLines.value);
    }
    if (durationEstimation.present) {
      map['duration_estimation'] = Variable<bool>(durationEstimation.value);
    }
    if (enableSound.present) {
      map['enable_sound'] = Variable<bool>(enableSound.value);
    }
    if (explainedPermissions.present) {
      map['explained_permissions'] = Variable<bool>(explainedPermissions.value);
    }
    if (groupHistory.present) {
      map['group_history'] = Variable<bool>(groupHistory.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (longDateFormat.present) {
      map['long_date_format'] = Variable<String>(longDateFormat.value);
    }
    if (maxSets.present) {
      map['max_sets'] = Variable<int>(maxSets.value);
    }
    if (planTrailing.present) {
      map['plan_trailing'] = Variable<String>(planTrailing.value);
    }
    if (repEstimation.present) {
      map['rep_estimation'] = Variable<bool>(repEstimation.value);
    }
    if (restTimers.present) {
      map['rest_timers'] = Variable<bool>(restTimers.value);
    }
    if (shortDateFormat.present) {
      map['short_date_format'] = Variable<String>(shortDateFormat.value);
    }
    if (showBodyWeight.present) {
      map['show_body_weight'] = Variable<bool>(showBodyWeight.value);
    }
    if (showImages.present) {
      map['show_images'] = Variable<bool>(showImages.value);
    }
    if (showUnits.present) {
      map['show_units'] = Variable<bool>(showUnits.value);
    }
    if (strengthUnit.present) {
      map['strength_unit'] = Variable<String>(strengthUnit.value);
    }
    if (systemColors.present) {
      map['system_colors'] = Variable<bool>(systemColors.value);
    }
    if (tabs.present) {
      map['tabs'] = Variable<String>(tabs.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (timerDuration.present) {
      map['timer_duration'] = Variable<int>(timerDuration.value);
    }
    if (vibrate.present) {
      map['vibrate'] = Variable<bool>(vibrate.value);
    }
    if (warmupSets.present) {
      map['warmup_sets'] = Variable<int>(warmupSets.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('alarmSound: $alarmSound, ')
          ..write('automaticBackups: $automaticBackups, ')
          ..write('backupPath: $backupPath, ')
          ..write('cardioUnit: $cardioUnit, ')
          ..write('curveLines: $curveLines, ')
          ..write('durationEstimation: $durationEstimation, ')
          ..write('enableSound: $enableSound, ')
          ..write('explainedPermissions: $explainedPermissions, ')
          ..write('groupHistory: $groupHistory, ')
          ..write('id: $id, ')
          ..write('longDateFormat: $longDateFormat, ')
          ..write('maxSets: $maxSets, ')
          ..write('planTrailing: $planTrailing, ')
          ..write('repEstimation: $repEstimation, ')
          ..write('restTimers: $restTimers, ')
          ..write('shortDateFormat: $shortDateFormat, ')
          ..write('showBodyWeight: $showBodyWeight, ')
          ..write('showImages: $showImages, ')
          ..write('showUnits: $showUnits, ')
          ..write('strengthUnit: $strengthUnit, ')
          ..write('systemColors: $systemColors, ')
          ..write('tabs: $tabs, ')
          ..write('themeMode: $themeMode, ')
          ..write('timerDuration: $timerDuration, ')
          ..write('vibrate: $vibrate, ')
          ..write('warmupSets: $warmupSets')
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
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'));
  static const VerificationMeta _timersMeta = const VerificationMeta('timers');
  @override
  late final GeneratedColumn<bool> timers = GeneratedColumn<bool>(
      'timers', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("timers" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _exerciseMeta =
      const VerificationMeta('exercise');
  @override
  late final GeneratedColumn<String> exercise = GeneratedColumn<String>(
      'exercise', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES gym_sets (name)'));
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _maxSetsMeta =
      const VerificationMeta('maxSets');
  @override
  late final GeneratedColumn<int> maxSets = GeneratedColumn<int>(
      'max_sets', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
      'plan_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES plans (id)'));
  static const VerificationMeta _warmupSetsMeta =
      const VerificationMeta('warmupSets');
  @override
  late final GeneratedColumn<int> warmupSets = GeneratedColumn<int>(
      'warmup_sets', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [enabled, timers, exercise, id, maxSets, planId, warmupSets];
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
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    } else if (isInserting) {
      context.missing(_enabledMeta);
    }
    if (data.containsKey('timers')) {
      context.handle(_timersMeta,
          timers.isAcceptableOrUnknown(data['timers']!, _timersMeta));
    }
    if (data.containsKey('exercise')) {
      context.handle(_exerciseMeta,
          exercise.isAcceptableOrUnknown(data['exercise']!, _exerciseMeta));
    } else if (isInserting) {
      context.missing(_exerciseMeta);
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('max_sets')) {
      context.handle(_maxSetsMeta,
          maxSets.isAcceptableOrUnknown(data['max_sets']!, _maxSetsMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(_planIdMeta,
          planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta));
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('warmup_sets')) {
      context.handle(
          _warmupSetsMeta,
          warmupSets.isAcceptableOrUnknown(
              data['warmup_sets']!, _warmupSetsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanExercise(
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      timers: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}timers'])!,
      exercise: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      maxSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_sets']),
      planId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}plan_id'])!,
      warmupSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}warmup_sets']),
    );
  }

  @override
  $PlanExercisesTable createAlias(String alias) {
    return $PlanExercisesTable(attachedDatabase, alias);
  }
}

class PlanExercise extends DataClass implements Insertable<PlanExercise> {
  final bool enabled;
  final bool timers;
  final String exercise;
  final int id;
  final int? maxSets;
  final int planId;
  final int? warmupSets;
  const PlanExercise(
      {required this.enabled,
      required this.timers,
      required this.exercise,
      required this.id,
      this.maxSets,
      required this.planId,
      this.warmupSets});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['enabled'] = Variable<bool>(enabled);
    map['timers'] = Variable<bool>(timers);
    map['exercise'] = Variable<String>(exercise);
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || maxSets != null) {
      map['max_sets'] = Variable<int>(maxSets);
    }
    map['plan_id'] = Variable<int>(planId);
    if (!nullToAbsent || warmupSets != null) {
      map['warmup_sets'] = Variable<int>(warmupSets);
    }
    return map;
  }

  PlanExercisesCompanion toCompanion(bool nullToAbsent) {
    return PlanExercisesCompanion(
      enabled: Value(enabled),
      timers: Value(timers),
      exercise: Value(exercise),
      id: Value(id),
      maxSets: maxSets == null && nullToAbsent
          ? const Value.absent()
          : Value(maxSets),
      planId: Value(planId),
      warmupSets: warmupSets == null && nullToAbsent
          ? const Value.absent()
          : Value(warmupSets),
    );
  }

  factory PlanExercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanExercise(
      enabled: serializer.fromJson<bool>(json['enabled']),
      timers: serializer.fromJson<bool>(json['timers']),
      exercise: serializer.fromJson<String>(json['exercise']),
      id: serializer.fromJson<int>(json['id']),
      maxSets: serializer.fromJson<int?>(json['maxSets']),
      planId: serializer.fromJson<int>(json['planId']),
      warmupSets: serializer.fromJson<int?>(json['warmupSets']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'enabled': serializer.toJson<bool>(enabled),
      'timers': serializer.toJson<bool>(timers),
      'exercise': serializer.toJson<String>(exercise),
      'id': serializer.toJson<int>(id),
      'maxSets': serializer.toJson<int?>(maxSets),
      'planId': serializer.toJson<int>(planId),
      'warmupSets': serializer.toJson<int?>(warmupSets),
    };
  }

  PlanExercise copyWith(
          {bool? enabled,
          bool? timers,
          String? exercise,
          int? id,
          Value<int?> maxSets = const Value.absent(),
          int? planId,
          Value<int?> warmupSets = const Value.absent()}) =>
      PlanExercise(
        enabled: enabled ?? this.enabled,
        timers: timers ?? this.timers,
        exercise: exercise ?? this.exercise,
        id: id ?? this.id,
        maxSets: maxSets.present ? maxSets.value : this.maxSets,
        planId: planId ?? this.planId,
        warmupSets: warmupSets.present ? warmupSets.value : this.warmupSets,
      );
  @override
  String toString() {
    return (StringBuffer('PlanExercise(')
          ..write('enabled: $enabled, ')
          ..write('timers: $timers, ')
          ..write('exercise: $exercise, ')
          ..write('id: $id, ')
          ..write('maxSets: $maxSets, ')
          ..write('planId: $planId, ')
          ..write('warmupSets: $warmupSets')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(enabled, timers, exercise, id, maxSets, planId, warmupSets);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanExercise &&
          other.enabled == this.enabled &&
          other.timers == this.timers &&
          other.exercise == this.exercise &&
          other.id == this.id &&
          other.maxSets == this.maxSets &&
          other.planId == this.planId &&
          other.warmupSets == this.warmupSets);
}

class PlanExercisesCompanion extends UpdateCompanion<PlanExercise> {
  final Value<bool> enabled;
  final Value<bool> timers;
  final Value<String> exercise;
  final Value<int> id;
  final Value<int?> maxSets;
  final Value<int> planId;
  final Value<int?> warmupSets;
  const PlanExercisesCompanion({
    this.enabled = const Value.absent(),
    this.timers = const Value.absent(),
    this.exercise = const Value.absent(),
    this.id = const Value.absent(),
    this.maxSets = const Value.absent(),
    this.planId = const Value.absent(),
    this.warmupSets = const Value.absent(),
  });
  PlanExercisesCompanion.insert({
    required bool enabled,
    this.timers = const Value.absent(),
    required String exercise,
    this.id = const Value.absent(),
    this.maxSets = const Value.absent(),
    required int planId,
    this.warmupSets = const Value.absent(),
  })  : enabled = Value(enabled),
        exercise = Value(exercise),
        planId = Value(planId);
  static Insertable<PlanExercise> custom({
    Expression<bool>? enabled,
    Expression<bool>? timers,
    Expression<String>? exercise,
    Expression<int>? id,
    Expression<int>? maxSets,
    Expression<int>? planId,
    Expression<int>? warmupSets,
  }) {
    return RawValuesInsertable({
      if (enabled != null) 'enabled': enabled,
      if (timers != null) 'timers': timers,
      if (exercise != null) 'exercise': exercise,
      if (id != null) 'id': id,
      if (maxSets != null) 'max_sets': maxSets,
      if (planId != null) 'plan_id': planId,
      if (warmupSets != null) 'warmup_sets': warmupSets,
    });
  }

  PlanExercisesCompanion copyWith(
      {Value<bool>? enabled,
      Value<bool>? timers,
      Value<String>? exercise,
      Value<int>? id,
      Value<int?>? maxSets,
      Value<int>? planId,
      Value<int?>? warmupSets}) {
    return PlanExercisesCompanion(
      enabled: enabled ?? this.enabled,
      timers: timers ?? this.timers,
      exercise: exercise ?? this.exercise,
      id: id ?? this.id,
      maxSets: maxSets ?? this.maxSets,
      planId: planId ?? this.planId,
      warmupSets: warmupSets ?? this.warmupSets,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (timers.present) {
      map['timers'] = Variable<bool>(timers.value);
    }
    if (exercise.present) {
      map['exercise'] = Variable<String>(exercise.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (maxSets.present) {
      map['max_sets'] = Variable<int>(maxSets.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (warmupSets.present) {
      map['warmup_sets'] = Variable<int>(warmupSets.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanExercisesCompanion(')
          ..write('enabled: $enabled, ')
          ..write('timers: $timers, ')
          ..write('exercise: $exercise, ')
          ..write('id: $id, ')
          ..write('maxSets: $maxSets, ')
          ..write('planId: $planId, ')
          ..write('warmupSets: $warmupSets')
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
  required String days,
  required String exercises,
  Value<int> id,
  Value<int?> sequence,
  Value<String?> title,
});
typedef $$PlansTableUpdateCompanionBuilder = PlansCompanion Function({
  Value<String> days,
  Value<String> exercises,
  Value<int> id,
  Value<int?> sequence,
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
            Value<String> days = const Value.absent(),
            Value<String> exercises = const Value.absent(),
            Value<int> id = const Value.absent(),
            Value<int?> sequence = const Value.absent(),
            Value<String?> title = const Value.absent(),
          }) =>
              PlansCompanion(
            days: days,
            exercises: exercises,
            id: id,
            sequence: sequence,
            title: title,
          ),
          getInsertCompanionBuilder: ({
            required String days,
            required String exercises,
            Value<int> id = const Value.absent(),
            Value<int?> sequence = const Value.absent(),
            Value<String?> title = const Value.absent(),
          }) =>
              PlansCompanion.insert(
            days: days,
            exercises: exercises,
            id: id,
            sequence: sequence,
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
  ColumnFilters<String> get days => $state.composableBuilder(
      column: $state.table.days,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get exercises => $state.composableBuilder(
      column: $state.table.exercises,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sequence => $state.composableBuilder(
      column: $state.table.sequence,
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
  ColumnOrderings<String> get days => $state.composableBuilder(
      column: $state.table.days,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get exercises => $state.composableBuilder(
      column: $state.table.exercises,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sequence => $state.composableBuilder(
      column: $state.table.sequence,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$GymSetsTableInsertCompanionBuilder = GymSetsCompanion Function({
  Value<double> bodyWeight,
  Value<bool> cardio,
  Value<String?> category,
  required DateTime created,
  Value<double> distance,
  Value<double> duration,
  Value<bool> hidden,
  Value<int> id,
  Value<String?> image,
  Value<int?> incline,
  required String name,
  Value<int?> planId,
  required double reps,
  Value<int?> restMs,
  required String unit,
  required double weight,
});
typedef $$GymSetsTableUpdateCompanionBuilder = GymSetsCompanion Function({
  Value<double> bodyWeight,
  Value<bool> cardio,
  Value<String?> category,
  Value<DateTime> created,
  Value<double> distance,
  Value<double> duration,
  Value<bool> hidden,
  Value<int> id,
  Value<String?> image,
  Value<int?> incline,
  Value<String> name,
  Value<int?> planId,
  Value<double> reps,
  Value<int?> restMs,
  Value<String> unit,
  Value<double> weight,
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
            Value<double> bodyWeight = const Value.absent(),
            Value<bool> cardio = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<DateTime> created = const Value.absent(),
            Value<double> distance = const Value.absent(),
            Value<double> duration = const Value.absent(),
            Value<bool> hidden = const Value.absent(),
            Value<int> id = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<int?> incline = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int?> planId = const Value.absent(),
            Value<double> reps = const Value.absent(),
            Value<int?> restMs = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> weight = const Value.absent(),
          }) =>
              GymSetsCompanion(
            bodyWeight: bodyWeight,
            cardio: cardio,
            category: category,
            created: created,
            distance: distance,
            duration: duration,
            hidden: hidden,
            id: id,
            image: image,
            incline: incline,
            name: name,
            planId: planId,
            reps: reps,
            restMs: restMs,
            unit: unit,
            weight: weight,
          ),
          getInsertCompanionBuilder: ({
            Value<double> bodyWeight = const Value.absent(),
            Value<bool> cardio = const Value.absent(),
            Value<String?> category = const Value.absent(),
            required DateTime created,
            Value<double> distance = const Value.absent(),
            Value<double> duration = const Value.absent(),
            Value<bool> hidden = const Value.absent(),
            Value<int> id = const Value.absent(),
            Value<String?> image = const Value.absent(),
            Value<int?> incline = const Value.absent(),
            required String name,
            Value<int?> planId = const Value.absent(),
            required double reps,
            Value<int?> restMs = const Value.absent(),
            required String unit,
            required double weight,
          }) =>
              GymSetsCompanion.insert(
            bodyWeight: bodyWeight,
            cardio: cardio,
            category: category,
            created: created,
            distance: distance,
            duration: duration,
            hidden: hidden,
            id: id,
            image: image,
            incline: incline,
            name: name,
            planId: planId,
            reps: reps,
            restMs: restMs,
            unit: unit,
            weight: weight,
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
  ColumnFilters<double> get bodyWeight => $state.composableBuilder(
      column: $state.table.bodyWeight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get cardio => $state.composableBuilder(
      column: $state.table.cardio,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get created => $state.composableBuilder(
      column: $state.table.created,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get distance => $state.composableBuilder(
      column: $state.table.distance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get duration => $state.composableBuilder(
      column: $state.table.duration,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get hidden => $state.composableBuilder(
      column: $state.table.hidden,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get incline => $state.composableBuilder(
      column: $state.table.incline,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get planId => $state.composableBuilder(
      column: $state.table.planId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get reps => $state.composableBuilder(
      column: $state.table.reps,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get restMs => $state.composableBuilder(
      column: $state.table.restMs,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get weight => $state.composableBuilder(
      column: $state.table.weight,
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
  ColumnOrderings<double> get bodyWeight => $state.composableBuilder(
      column: $state.table.bodyWeight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get cardio => $state.composableBuilder(
      column: $state.table.cardio,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get created => $state.composableBuilder(
      column: $state.table.created,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get distance => $state.composableBuilder(
      column: $state.table.distance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get duration => $state.composableBuilder(
      column: $state.table.duration,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get hidden => $state.composableBuilder(
      column: $state.table.hidden,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get image => $state.composableBuilder(
      column: $state.table.image,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get incline => $state.composableBuilder(
      column: $state.table.incline,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get planId => $state.composableBuilder(
      column: $state.table.planId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get reps => $state.composableBuilder(
      column: $state.table.reps,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get restMs => $state.composableBuilder(
      column: $state.table.restMs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get unit => $state.composableBuilder(
      column: $state.table.unit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get weight => $state.composableBuilder(
      column: $state.table.weight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SettingsTableInsertCompanionBuilder = SettingsCompanion Function({
  required String alarmSound,
  Value<bool> automaticBackups,
  Value<String?> backupPath,
  required String cardioUnit,
  required bool curveLines,
  Value<bool> durationEstimation,
  Value<bool> enableSound,
  required bool explainedPermissions,
  required bool groupHistory,
  Value<int> id,
  required String longDateFormat,
  required int maxSets,
  required String planTrailing,
  Value<bool> repEstimation,
  required bool restTimers,
  required String shortDateFormat,
  Value<bool> showBodyWeight,
  Value<bool> showImages,
  required bool showUnits,
  required String strengthUnit,
  required bool systemColors,
  Value<String> tabs,
  required String themeMode,
  required int timerDuration,
  required bool vibrate,
  Value<int?> warmupSets,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> alarmSound,
  Value<bool> automaticBackups,
  Value<String?> backupPath,
  Value<String> cardioUnit,
  Value<bool> curveLines,
  Value<bool> durationEstimation,
  Value<bool> enableSound,
  Value<bool> explainedPermissions,
  Value<bool> groupHistory,
  Value<int> id,
  Value<String> longDateFormat,
  Value<int> maxSets,
  Value<String> planTrailing,
  Value<bool> repEstimation,
  Value<bool> restTimers,
  Value<String> shortDateFormat,
  Value<bool> showBodyWeight,
  Value<bool> showImages,
  Value<bool> showUnits,
  Value<String> strengthUnit,
  Value<bool> systemColors,
  Value<String> tabs,
  Value<String> themeMode,
  Value<int> timerDuration,
  Value<bool> vibrate,
  Value<int?> warmupSets,
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
            Value<String> alarmSound = const Value.absent(),
            Value<bool> automaticBackups = const Value.absent(),
            Value<String?> backupPath = const Value.absent(),
            Value<String> cardioUnit = const Value.absent(),
            Value<bool> curveLines = const Value.absent(),
            Value<bool> durationEstimation = const Value.absent(),
            Value<bool> enableSound = const Value.absent(),
            Value<bool> explainedPermissions = const Value.absent(),
            Value<bool> groupHistory = const Value.absent(),
            Value<int> id = const Value.absent(),
            Value<String> longDateFormat = const Value.absent(),
            Value<int> maxSets = const Value.absent(),
            Value<String> planTrailing = const Value.absent(),
            Value<bool> repEstimation = const Value.absent(),
            Value<bool> restTimers = const Value.absent(),
            Value<String> shortDateFormat = const Value.absent(),
            Value<bool> showBodyWeight = const Value.absent(),
            Value<bool> showImages = const Value.absent(),
            Value<bool> showUnits = const Value.absent(),
            Value<String> strengthUnit = const Value.absent(),
            Value<bool> systemColors = const Value.absent(),
            Value<String> tabs = const Value.absent(),
            Value<String> themeMode = const Value.absent(),
            Value<int> timerDuration = const Value.absent(),
            Value<bool> vibrate = const Value.absent(),
            Value<int?> warmupSets = const Value.absent(),
          }) =>
              SettingsCompanion(
            alarmSound: alarmSound,
            automaticBackups: automaticBackups,
            backupPath: backupPath,
            cardioUnit: cardioUnit,
            curveLines: curveLines,
            durationEstimation: durationEstimation,
            enableSound: enableSound,
            explainedPermissions: explainedPermissions,
            groupHistory: groupHistory,
            id: id,
            longDateFormat: longDateFormat,
            maxSets: maxSets,
            planTrailing: planTrailing,
            repEstimation: repEstimation,
            restTimers: restTimers,
            shortDateFormat: shortDateFormat,
            showBodyWeight: showBodyWeight,
            showImages: showImages,
            showUnits: showUnits,
            strengthUnit: strengthUnit,
            systemColors: systemColors,
            tabs: tabs,
            themeMode: themeMode,
            timerDuration: timerDuration,
            vibrate: vibrate,
            warmupSets: warmupSets,
          ),
          getInsertCompanionBuilder: ({
            required String alarmSound,
            Value<bool> automaticBackups = const Value.absent(),
            Value<String?> backupPath = const Value.absent(),
            required String cardioUnit,
            required bool curveLines,
            Value<bool> durationEstimation = const Value.absent(),
            Value<bool> enableSound = const Value.absent(),
            required bool explainedPermissions,
            required bool groupHistory,
            Value<int> id = const Value.absent(),
            required String longDateFormat,
            required int maxSets,
            required String planTrailing,
            Value<bool> repEstimation = const Value.absent(),
            required bool restTimers,
            required String shortDateFormat,
            Value<bool> showBodyWeight = const Value.absent(),
            Value<bool> showImages = const Value.absent(),
            required bool showUnits,
            required String strengthUnit,
            required bool systemColors,
            Value<String> tabs = const Value.absent(),
            required String themeMode,
            required int timerDuration,
            required bool vibrate,
            Value<int?> warmupSets = const Value.absent(),
          }) =>
              SettingsCompanion.insert(
            alarmSound: alarmSound,
            automaticBackups: automaticBackups,
            backupPath: backupPath,
            cardioUnit: cardioUnit,
            curveLines: curveLines,
            durationEstimation: durationEstimation,
            enableSound: enableSound,
            explainedPermissions: explainedPermissions,
            groupHistory: groupHistory,
            id: id,
            longDateFormat: longDateFormat,
            maxSets: maxSets,
            planTrailing: planTrailing,
            repEstimation: repEstimation,
            restTimers: restTimers,
            shortDateFormat: shortDateFormat,
            showBodyWeight: showBodyWeight,
            showImages: showImages,
            showUnits: showUnits,
            strengthUnit: strengthUnit,
            systemColors: systemColors,
            tabs: tabs,
            themeMode: themeMode,
            timerDuration: timerDuration,
            vibrate: vibrate,
            warmupSets: warmupSets,
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
  ColumnFilters<String> get alarmSound => $state.composableBuilder(
      column: $state.table.alarmSound,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get automaticBackups => $state.composableBuilder(
      column: $state.table.automaticBackups,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get backupPath => $state.composableBuilder(
      column: $state.table.backupPath,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get cardioUnit => $state.composableBuilder(
      column: $state.table.cardioUnit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get curveLines => $state.composableBuilder(
      column: $state.table.curveLines,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get durationEstimation => $state.composableBuilder(
      column: $state.table.durationEstimation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get enableSound => $state.composableBuilder(
      column: $state.table.enableSound,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get explainedPermissions => $state.composableBuilder(
      column: $state.table.explainedPermissions,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get groupHistory => $state.composableBuilder(
      column: $state.table.groupHistory,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get longDateFormat => $state.composableBuilder(
      column: $state.table.longDateFormat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get maxSets => $state.composableBuilder(
      column: $state.table.maxSets,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get planTrailing => $state.composableBuilder(
      column: $state.table.planTrailing,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get repEstimation => $state.composableBuilder(
      column: $state.table.repEstimation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get restTimers => $state.composableBuilder(
      column: $state.table.restTimers,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get shortDateFormat => $state.composableBuilder(
      column: $state.table.shortDateFormat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get showBodyWeight => $state.composableBuilder(
      column: $state.table.showBodyWeight,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get showImages => $state.composableBuilder(
      column: $state.table.showImages,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get showUnits => $state.composableBuilder(
      column: $state.table.showUnits,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get strengthUnit => $state.composableBuilder(
      column: $state.table.strengthUnit,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get systemColors => $state.composableBuilder(
      column: $state.table.systemColors,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get tabs => $state.composableBuilder(
      column: $state.table.tabs,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get themeMode => $state.composableBuilder(
      column: $state.table.themeMode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get timerDuration => $state.composableBuilder(
      column: $state.table.timerDuration,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get vibrate => $state.composableBuilder(
      column: $state.table.vibrate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get warmupSets => $state.composableBuilder(
      column: $state.table.warmupSets,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SettingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get alarmSound => $state.composableBuilder(
      column: $state.table.alarmSound,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get automaticBackups => $state.composableBuilder(
      column: $state.table.automaticBackups,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get backupPath => $state.composableBuilder(
      column: $state.table.backupPath,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get cardioUnit => $state.composableBuilder(
      column: $state.table.cardioUnit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get curveLines => $state.composableBuilder(
      column: $state.table.curveLines,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get durationEstimation => $state.composableBuilder(
      column: $state.table.durationEstimation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get enableSound => $state.composableBuilder(
      column: $state.table.enableSound,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get explainedPermissions => $state.composableBuilder(
      column: $state.table.explainedPermissions,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get groupHistory => $state.composableBuilder(
      column: $state.table.groupHistory,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get longDateFormat => $state.composableBuilder(
      column: $state.table.longDateFormat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get maxSets => $state.composableBuilder(
      column: $state.table.maxSets,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get planTrailing => $state.composableBuilder(
      column: $state.table.planTrailing,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get repEstimation => $state.composableBuilder(
      column: $state.table.repEstimation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get restTimers => $state.composableBuilder(
      column: $state.table.restTimers,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get shortDateFormat => $state.composableBuilder(
      column: $state.table.shortDateFormat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get showBodyWeight => $state.composableBuilder(
      column: $state.table.showBodyWeight,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get showImages => $state.composableBuilder(
      column: $state.table.showImages,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get showUnits => $state.composableBuilder(
      column: $state.table.showUnits,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get strengthUnit => $state.composableBuilder(
      column: $state.table.strengthUnit,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get systemColors => $state.composableBuilder(
      column: $state.table.systemColors,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get tabs => $state.composableBuilder(
      column: $state.table.tabs,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get themeMode => $state.composableBuilder(
      column: $state.table.themeMode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get timerDuration => $state.composableBuilder(
      column: $state.table.timerDuration,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get vibrate => $state.composableBuilder(
      column: $state.table.vibrate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get warmupSets => $state.composableBuilder(
      column: $state.table.warmupSets,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PlanExercisesTableInsertCompanionBuilder = PlanExercisesCompanion
    Function({
  required bool enabled,
  Value<bool> timers,
  required String exercise,
  Value<int> id,
  Value<int?> maxSets,
  required int planId,
  Value<int?> warmupSets,
});
typedef $$PlanExercisesTableUpdateCompanionBuilder = PlanExercisesCompanion
    Function({
  Value<bool> enabled,
  Value<bool> timers,
  Value<String> exercise,
  Value<int> id,
  Value<int?> maxSets,
  Value<int> planId,
  Value<int?> warmupSets,
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
            Value<bool> enabled = const Value.absent(),
            Value<bool> timers = const Value.absent(),
            Value<String> exercise = const Value.absent(),
            Value<int> id = const Value.absent(),
            Value<int?> maxSets = const Value.absent(),
            Value<int> planId = const Value.absent(),
            Value<int?> warmupSets = const Value.absent(),
          }) =>
              PlanExercisesCompanion(
            enabled: enabled,
            timers: timers,
            exercise: exercise,
            id: id,
            maxSets: maxSets,
            planId: planId,
            warmupSets: warmupSets,
          ),
          getInsertCompanionBuilder: ({
            required bool enabled,
            Value<bool> timers = const Value.absent(),
            required String exercise,
            Value<int> id = const Value.absent(),
            Value<int?> maxSets = const Value.absent(),
            required int planId,
            Value<int?> warmupSets = const Value.absent(),
          }) =>
              PlanExercisesCompanion.insert(
            enabled: enabled,
            timers: timers,
            exercise: exercise,
            id: id,
            maxSets: maxSets,
            planId: planId,
            warmupSets: warmupSets,
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
  ColumnFilters<bool> get enabled => $state.composableBuilder(
      column: $state.table.enabled,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get timers => $state.composableBuilder(
      column: $state.table.timers,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get maxSets => $state.composableBuilder(
      column: $state.table.maxSets,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get warmupSets => $state.composableBuilder(
      column: $state.table.warmupSets,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

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
}

class $$PlanExercisesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PlanExercisesTable> {
  $$PlanExercisesTableOrderingComposer(super.$state);
  ColumnOrderings<bool> get enabled => $state.composableBuilder(
      column: $state.table.enabled,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get timers => $state.composableBuilder(
      column: $state.table.timers,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get maxSets => $state.composableBuilder(
      column: $state.table.maxSets,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get warmupSets => $state.composableBuilder(
      column: $state.table.warmupSets,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

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
