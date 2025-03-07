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
  Plan copyWithCompanion(PlansCompanion data) {
    return Plan(
      days: data.days.present ? data.days.value : this.days,
      exercises: data.exercises.present ? data.exercises.value : this.exercises,
      id: data.id.present ? data.id.value : this.id,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      title: data.title.present ? data.title.value : this.title,
    );
  }

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
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
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
        notes,
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
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
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
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
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
  final String? notes;
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
      this.notes,
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
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
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
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
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
      notes: serializer.fromJson<String?>(json['notes']),
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
      'notes': serializer.toJson<String?>(notes),
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
          Value<String?> notes = const Value.absent(),
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
        notes: notes.present ? notes.value : this.notes,
        planId: planId.present ? planId.value : this.planId,
        reps: reps ?? this.reps,
        restMs: restMs.present ? restMs.value : this.restMs,
        unit: unit ?? this.unit,
        weight: weight ?? this.weight,
      );
  GymSet copyWithCompanion(GymSetsCompanion data) {
    return GymSet(
      bodyWeight:
          data.bodyWeight.present ? data.bodyWeight.value : this.bodyWeight,
      cardio: data.cardio.present ? data.cardio.value : this.cardio,
      category: data.category.present ? data.category.value : this.category,
      created: data.created.present ? data.created.value : this.created,
      distance: data.distance.present ? data.distance.value : this.distance,
      duration: data.duration.present ? data.duration.value : this.duration,
      hidden: data.hidden.present ? data.hidden.value : this.hidden,
      id: data.id.present ? data.id.value : this.id,
      image: data.image.present ? data.image.value : this.image,
      incline: data.incline.present ? data.incline.value : this.incline,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      planId: data.planId.present ? data.planId.value : this.planId,
      reps: data.reps.present ? data.reps.value : this.reps,
      restMs: data.restMs.present ? data.restMs.value : this.restMs,
      unit: data.unit.present ? data.unit.value : this.unit,
      weight: data.weight.present ? data.weight.value : this.weight,
    );
  }

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
          ..write('notes: $notes, ')
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
      notes,
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
          other.notes == this.notes &&
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
  final Value<String?> notes;
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
    this.notes = const Value.absent(),
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
    this.notes = const Value.absent(),
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
    Expression<String>? notes,
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
      if (notes != null) 'notes': notes,
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
      Value<String?>? notes,
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
      notes: notes ?? this.notes,
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
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
          ..write('notes: $notes, ')
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
  static const VerificationMeta _curveSmoothnessMeta =
      const VerificationMeta('curveSmoothness');
  @override
  late final GeneratedColumn<double> curveSmoothness = GeneratedColumn<double>(
      'curve_smoothness', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
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
  static const VerificationMeta _notificationsMeta =
      const VerificationMeta('notifications');
  @override
  late final GeneratedColumn<bool> notifications = GeneratedColumn<bool>(
      'notifications', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notifications" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _peekGraphMeta =
      const VerificationMeta('peekGraph');
  @override
  late final GeneratedColumn<bool> peekGraph = GeneratedColumn<bool>(
      'peek_graph', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("peek_graph" IN (0, 1))'),
      defaultValue: const Constant(false));
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
  static const VerificationMeta _showCategoriesMeta =
      const VerificationMeta('showCategories');
  @override
  late final GeneratedColumn<bool> showCategories = GeneratedColumn<bool>(
      'show_categories', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_categories" IN (0, 1))'),
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
  static const VerificationMeta _showNotesMeta =
      const VerificationMeta('showNotes');
  @override
  late final GeneratedColumn<bool> showNotes = GeneratedColumn<bool>(
      'show_notes', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_notes" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _showGlobalProgressMeta =
      const VerificationMeta('showGlobalProgress');
  @override
  late final GeneratedColumn<bool> showGlobalProgress = GeneratedColumn<bool>(
      'show_global_progress', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_global_progress" IN (0, 1))'),
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
        curveSmoothness,
        durationEstimation,
        enableSound,
        explainedPermissions,
        groupHistory,
        id,
        longDateFormat,
        maxSets,
        notifications,
        peekGraph,
        planTrailing,
        repEstimation,
        restTimers,
        shortDateFormat,
        showBodyWeight,
        showCategories,
        showImages,
        showNotes,
        showGlobalProgress,
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
    if (data.containsKey('curve_smoothness')) {
      context.handle(
          _curveSmoothnessMeta,
          curveSmoothness.isAcceptableOrUnknown(
              data['curve_smoothness']!, _curveSmoothnessMeta));
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
    if (data.containsKey('notifications')) {
      context.handle(
          _notificationsMeta,
          notifications.isAcceptableOrUnknown(
              data['notifications']!, _notificationsMeta));
    }
    if (data.containsKey('peek_graph')) {
      context.handle(_peekGraphMeta,
          peekGraph.isAcceptableOrUnknown(data['peek_graph']!, _peekGraphMeta));
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
    if (data.containsKey('show_categories')) {
      context.handle(
          _showCategoriesMeta,
          showCategories.isAcceptableOrUnknown(
              data['show_categories']!, _showCategoriesMeta));
    }
    if (data.containsKey('show_images')) {
      context.handle(
          _showImagesMeta,
          showImages.isAcceptableOrUnknown(
              data['show_images']!, _showImagesMeta));
    }
    if (data.containsKey('show_notes')) {
      context.handle(_showNotesMeta,
          showNotes.isAcceptableOrUnknown(data['show_notes']!, _showNotesMeta));
    }
    if (data.containsKey('show_global_progress')) {
      context.handle(
          _showGlobalProgressMeta,
          showGlobalProgress.isAcceptableOrUnknown(
              data['show_global_progress']!, _showGlobalProgressMeta));
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
      curveSmoothness: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}curve_smoothness']),
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
      notifications: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}notifications'])!,
      peekGraph: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}peek_graph'])!,
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
      showCategories: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_categories'])!,
      showImages: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_images'])!,
      showNotes: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_notes'])!,
      showGlobalProgress: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}show_global_progress'])!,
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
  final double? curveSmoothness;
  final bool durationEstimation;
  final bool enableSound;
  final bool explainedPermissions;
  final bool groupHistory;
  final int id;
  final String longDateFormat;
  final int maxSets;
  final bool notifications;
  final bool peekGraph;
  final String planTrailing;
  final bool repEstimation;
  final bool restTimers;
  final String shortDateFormat;
  final bool showBodyWeight;
  final bool showCategories;
  final bool showImages;
  final bool showNotes;
  final bool showGlobalProgress;
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
      this.curveSmoothness,
      required this.durationEstimation,
      required this.enableSound,
      required this.explainedPermissions,
      required this.groupHistory,
      required this.id,
      required this.longDateFormat,
      required this.maxSets,
      required this.notifications,
      required this.peekGraph,
      required this.planTrailing,
      required this.repEstimation,
      required this.restTimers,
      required this.shortDateFormat,
      required this.showBodyWeight,
      required this.showCategories,
      required this.showImages,
      required this.showNotes,
      required this.showGlobalProgress,
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
    if (!nullToAbsent || curveSmoothness != null) {
      map['curve_smoothness'] = Variable<double>(curveSmoothness);
    }
    map['duration_estimation'] = Variable<bool>(durationEstimation);
    map['enable_sound'] = Variable<bool>(enableSound);
    map['explained_permissions'] = Variable<bool>(explainedPermissions);
    map['group_history'] = Variable<bool>(groupHistory);
    map['id'] = Variable<int>(id);
    map['long_date_format'] = Variable<String>(longDateFormat);
    map['max_sets'] = Variable<int>(maxSets);
    map['notifications'] = Variable<bool>(notifications);
    map['peek_graph'] = Variable<bool>(peekGraph);
    map['plan_trailing'] = Variable<String>(planTrailing);
    map['rep_estimation'] = Variable<bool>(repEstimation);
    map['rest_timers'] = Variable<bool>(restTimers);
    map['short_date_format'] = Variable<String>(shortDateFormat);
    map['show_body_weight'] = Variable<bool>(showBodyWeight);
    map['show_categories'] = Variable<bool>(showCategories);
    map['show_images'] = Variable<bool>(showImages);
    map['show_notes'] = Variable<bool>(showNotes);
    map['show_global_progress'] = Variable<bool>(showGlobalProgress);
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
      curveSmoothness: curveSmoothness == null && nullToAbsent
          ? const Value.absent()
          : Value(curveSmoothness),
      durationEstimation: Value(durationEstimation),
      enableSound: Value(enableSound),
      explainedPermissions: Value(explainedPermissions),
      groupHistory: Value(groupHistory),
      id: Value(id),
      longDateFormat: Value(longDateFormat),
      maxSets: Value(maxSets),
      notifications: Value(notifications),
      peekGraph: Value(peekGraph),
      planTrailing: Value(planTrailing),
      repEstimation: Value(repEstimation),
      restTimers: Value(restTimers),
      shortDateFormat: Value(shortDateFormat),
      showBodyWeight: Value(showBodyWeight),
      showCategories: Value(showCategories),
      showImages: Value(showImages),
      showNotes: Value(showNotes),
      showGlobalProgress: Value(showGlobalProgress),
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
      curveSmoothness: serializer.fromJson<double?>(json['curveSmoothness']),
      durationEstimation: serializer.fromJson<bool>(json['durationEstimation']),
      enableSound: serializer.fromJson<bool>(json['enableSound']),
      explainedPermissions:
          serializer.fromJson<bool>(json['explainedPermissions']),
      groupHistory: serializer.fromJson<bool>(json['groupHistory']),
      id: serializer.fromJson<int>(json['id']),
      longDateFormat: serializer.fromJson<String>(json['longDateFormat']),
      maxSets: serializer.fromJson<int>(json['maxSets']),
      notifications: serializer.fromJson<bool>(json['notifications']),
      peekGraph: serializer.fromJson<bool>(json['peekGraph']),
      planTrailing: serializer.fromJson<String>(json['planTrailing']),
      repEstimation: serializer.fromJson<bool>(json['repEstimation']),
      restTimers: serializer.fromJson<bool>(json['restTimers']),
      shortDateFormat: serializer.fromJson<String>(json['shortDateFormat']),
      showBodyWeight: serializer.fromJson<bool>(json['showBodyWeight']),
      showCategories: serializer.fromJson<bool>(json['showCategories']),
      showImages: serializer.fromJson<bool>(json['showImages']),
      showNotes: serializer.fromJson<bool>(json['showNotes']),
      showGlobalProgress: serializer.fromJson<bool>(json['showGlobalProgress']),
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
      'curveSmoothness': serializer.toJson<double?>(curveSmoothness),
      'durationEstimation': serializer.toJson<bool>(durationEstimation),
      'enableSound': serializer.toJson<bool>(enableSound),
      'explainedPermissions': serializer.toJson<bool>(explainedPermissions),
      'groupHistory': serializer.toJson<bool>(groupHistory),
      'id': serializer.toJson<int>(id),
      'longDateFormat': serializer.toJson<String>(longDateFormat),
      'maxSets': serializer.toJson<int>(maxSets),
      'notifications': serializer.toJson<bool>(notifications),
      'peekGraph': serializer.toJson<bool>(peekGraph),
      'planTrailing': serializer.toJson<String>(planTrailing),
      'repEstimation': serializer.toJson<bool>(repEstimation),
      'restTimers': serializer.toJson<bool>(restTimers),
      'shortDateFormat': serializer.toJson<String>(shortDateFormat),
      'showBodyWeight': serializer.toJson<bool>(showBodyWeight),
      'showCategories': serializer.toJson<bool>(showCategories),
      'showImages': serializer.toJson<bool>(showImages),
      'showNotes': serializer.toJson<bool>(showNotes),
      'showGlobalProgress': serializer.toJson<bool>(showGlobalProgress),
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
          Value<double?> curveSmoothness = const Value.absent(),
          bool? durationEstimation,
          bool? enableSound,
          bool? explainedPermissions,
          bool? groupHistory,
          int? id,
          String? longDateFormat,
          int? maxSets,
          bool? notifications,
          bool? peekGraph,
          String? planTrailing,
          bool? repEstimation,
          bool? restTimers,
          String? shortDateFormat,
          bool? showBodyWeight,
          bool? showCategories,
          bool? showImages,
          bool? showNotes,
          bool? showGlobalProgress,
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
        curveSmoothness: curveSmoothness.present
            ? curveSmoothness.value
            : this.curveSmoothness,
        durationEstimation: durationEstimation ?? this.durationEstimation,
        enableSound: enableSound ?? this.enableSound,
        explainedPermissions: explainedPermissions ?? this.explainedPermissions,
        groupHistory: groupHistory ?? this.groupHistory,
        id: id ?? this.id,
        longDateFormat: longDateFormat ?? this.longDateFormat,
        maxSets: maxSets ?? this.maxSets,
        notifications: notifications ?? this.notifications,
        peekGraph: peekGraph ?? this.peekGraph,
        planTrailing: planTrailing ?? this.planTrailing,
        repEstimation: repEstimation ?? this.repEstimation,
        restTimers: restTimers ?? this.restTimers,
        shortDateFormat: shortDateFormat ?? this.shortDateFormat,
        showBodyWeight: showBodyWeight ?? this.showBodyWeight,
        showCategories: showCategories ?? this.showCategories,
        showImages: showImages ?? this.showImages,
        showNotes: showNotes ?? this.showNotes,
        showGlobalProgress: showGlobalProgress ?? this.showGlobalProgress,
        showUnits: showUnits ?? this.showUnits,
        strengthUnit: strengthUnit ?? this.strengthUnit,
        systemColors: systemColors ?? this.systemColors,
        tabs: tabs ?? this.tabs,
        themeMode: themeMode ?? this.themeMode,
        timerDuration: timerDuration ?? this.timerDuration,
        vibrate: vibrate ?? this.vibrate,
        warmupSets: warmupSets.present ? warmupSets.value : this.warmupSets,
      );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      alarmSound:
          data.alarmSound.present ? data.alarmSound.value : this.alarmSound,
      automaticBackups: data.automaticBackups.present
          ? data.automaticBackups.value
          : this.automaticBackups,
      backupPath:
          data.backupPath.present ? data.backupPath.value : this.backupPath,
      cardioUnit:
          data.cardioUnit.present ? data.cardioUnit.value : this.cardioUnit,
      curveLines:
          data.curveLines.present ? data.curveLines.value : this.curveLines,
      curveSmoothness: data.curveSmoothness.present
          ? data.curveSmoothness.value
          : this.curveSmoothness,
      durationEstimation: data.durationEstimation.present
          ? data.durationEstimation.value
          : this.durationEstimation,
      enableSound:
          data.enableSound.present ? data.enableSound.value : this.enableSound,
      explainedPermissions: data.explainedPermissions.present
          ? data.explainedPermissions.value
          : this.explainedPermissions,
      groupHistory: data.groupHistory.present
          ? data.groupHistory.value
          : this.groupHistory,
      id: data.id.present ? data.id.value : this.id,
      longDateFormat: data.longDateFormat.present
          ? data.longDateFormat.value
          : this.longDateFormat,
      maxSets: data.maxSets.present ? data.maxSets.value : this.maxSets,
      notifications: data.notifications.present
          ? data.notifications.value
          : this.notifications,
      peekGraph: data.peekGraph.present ? data.peekGraph.value : this.peekGraph,
      planTrailing: data.planTrailing.present
          ? data.planTrailing.value
          : this.planTrailing,
      repEstimation: data.repEstimation.present
          ? data.repEstimation.value
          : this.repEstimation,
      restTimers:
          data.restTimers.present ? data.restTimers.value : this.restTimers,
      shortDateFormat: data.shortDateFormat.present
          ? data.shortDateFormat.value
          : this.shortDateFormat,
      showBodyWeight: data.showBodyWeight.present
          ? data.showBodyWeight.value
          : this.showBodyWeight,
      showCategories: data.showCategories.present
          ? data.showCategories.value
          : this.showCategories,
      showImages:
          data.showImages.present ? data.showImages.value : this.showImages,
      showNotes: data.showNotes.present ? data.showNotes.value : this.showNotes,
      showGlobalProgress: data.showGlobalProgress.present
          ? data.showGlobalProgress.value
          : this.showGlobalProgress,
      showUnits: data.showUnits.present ? data.showUnits.value : this.showUnits,
      strengthUnit: data.strengthUnit.present
          ? data.strengthUnit.value
          : this.strengthUnit,
      systemColors: data.systemColors.present
          ? data.systemColors.value
          : this.systemColors,
      tabs: data.tabs.present ? data.tabs.value : this.tabs,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      timerDuration: data.timerDuration.present
          ? data.timerDuration.value
          : this.timerDuration,
      vibrate: data.vibrate.present ? data.vibrate.value : this.vibrate,
      warmupSets:
          data.warmupSets.present ? data.warmupSets.value : this.warmupSets,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('alarmSound: $alarmSound, ')
          ..write('automaticBackups: $automaticBackups, ')
          ..write('backupPath: $backupPath, ')
          ..write('cardioUnit: $cardioUnit, ')
          ..write('curveLines: $curveLines, ')
          ..write('curveSmoothness: $curveSmoothness, ')
          ..write('durationEstimation: $durationEstimation, ')
          ..write('enableSound: $enableSound, ')
          ..write('explainedPermissions: $explainedPermissions, ')
          ..write('groupHistory: $groupHistory, ')
          ..write('id: $id, ')
          ..write('longDateFormat: $longDateFormat, ')
          ..write('maxSets: $maxSets, ')
          ..write('notifications: $notifications, ')
          ..write('peekGraph: $peekGraph, ')
          ..write('planTrailing: $planTrailing, ')
          ..write('repEstimation: $repEstimation, ')
          ..write('restTimers: $restTimers, ')
          ..write('shortDateFormat: $shortDateFormat, ')
          ..write('showBodyWeight: $showBodyWeight, ')
          ..write('showCategories: $showCategories, ')
          ..write('showImages: $showImages, ')
          ..write('showNotes: $showNotes, ')
          ..write('showGlobalProgress: $showGlobalProgress, ')
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
        curveSmoothness,
        durationEstimation,
        enableSound,
        explainedPermissions,
        groupHistory,
        id,
        longDateFormat,
        maxSets,
        notifications,
        peekGraph,
        planTrailing,
        repEstimation,
        restTimers,
        shortDateFormat,
        showBodyWeight,
        showCategories,
        showImages,
        showNotes,
        showGlobalProgress,
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
          other.curveSmoothness == this.curveSmoothness &&
          other.durationEstimation == this.durationEstimation &&
          other.enableSound == this.enableSound &&
          other.explainedPermissions == this.explainedPermissions &&
          other.groupHistory == this.groupHistory &&
          other.id == this.id &&
          other.longDateFormat == this.longDateFormat &&
          other.maxSets == this.maxSets &&
          other.notifications == this.notifications &&
          other.peekGraph == this.peekGraph &&
          other.planTrailing == this.planTrailing &&
          other.repEstimation == this.repEstimation &&
          other.restTimers == this.restTimers &&
          other.shortDateFormat == this.shortDateFormat &&
          other.showBodyWeight == this.showBodyWeight &&
          other.showCategories == this.showCategories &&
          other.showImages == this.showImages &&
          other.showNotes == this.showNotes &&
          other.showGlobalProgress == this.showGlobalProgress &&
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
  final Value<double?> curveSmoothness;
  final Value<bool> durationEstimation;
  final Value<bool> enableSound;
  final Value<bool> explainedPermissions;
  final Value<bool> groupHistory;
  final Value<int> id;
  final Value<String> longDateFormat;
  final Value<int> maxSets;
  final Value<bool> notifications;
  final Value<bool> peekGraph;
  final Value<String> planTrailing;
  final Value<bool> repEstimation;
  final Value<bool> restTimers;
  final Value<String> shortDateFormat;
  final Value<bool> showBodyWeight;
  final Value<bool> showCategories;
  final Value<bool> showImages;
  final Value<bool> showNotes;
  final Value<bool> showGlobalProgress;
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
    this.curveSmoothness = const Value.absent(),
    this.durationEstimation = const Value.absent(),
    this.enableSound = const Value.absent(),
    this.explainedPermissions = const Value.absent(),
    this.groupHistory = const Value.absent(),
    this.id = const Value.absent(),
    this.longDateFormat = const Value.absent(),
    this.maxSets = const Value.absent(),
    this.notifications = const Value.absent(),
    this.peekGraph = const Value.absent(),
    this.planTrailing = const Value.absent(),
    this.repEstimation = const Value.absent(),
    this.restTimers = const Value.absent(),
    this.shortDateFormat = const Value.absent(),
    this.showBodyWeight = const Value.absent(),
    this.showCategories = const Value.absent(),
    this.showImages = const Value.absent(),
    this.showNotes = const Value.absent(),
    this.showGlobalProgress = const Value.absent(),
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
    this.curveSmoothness = const Value.absent(),
    this.durationEstimation = const Value.absent(),
    this.enableSound = const Value.absent(),
    required bool explainedPermissions,
    required bool groupHistory,
    this.id = const Value.absent(),
    required String longDateFormat,
    required int maxSets,
    this.notifications = const Value.absent(),
    this.peekGraph = const Value.absent(),
    required String planTrailing,
    this.repEstimation = const Value.absent(),
    required bool restTimers,
    required String shortDateFormat,
    this.showBodyWeight = const Value.absent(),
    this.showCategories = const Value.absent(),
    this.showImages = const Value.absent(),
    this.showNotes = const Value.absent(),
    this.showGlobalProgress = const Value.absent(),
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
    Expression<double>? curveSmoothness,
    Expression<bool>? durationEstimation,
    Expression<bool>? enableSound,
    Expression<bool>? explainedPermissions,
    Expression<bool>? groupHistory,
    Expression<int>? id,
    Expression<String>? longDateFormat,
    Expression<int>? maxSets,
    Expression<bool>? notifications,
    Expression<bool>? peekGraph,
    Expression<String>? planTrailing,
    Expression<bool>? repEstimation,
    Expression<bool>? restTimers,
    Expression<String>? shortDateFormat,
    Expression<bool>? showBodyWeight,
    Expression<bool>? showCategories,
    Expression<bool>? showImages,
    Expression<bool>? showNotes,
    Expression<bool>? showGlobalProgress,
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
      if (curveSmoothness != null) 'curve_smoothness': curveSmoothness,
      if (durationEstimation != null) 'duration_estimation': durationEstimation,
      if (enableSound != null) 'enable_sound': enableSound,
      if (explainedPermissions != null)
        'explained_permissions': explainedPermissions,
      if (groupHistory != null) 'group_history': groupHistory,
      if (id != null) 'id': id,
      if (longDateFormat != null) 'long_date_format': longDateFormat,
      if (maxSets != null) 'max_sets': maxSets,
      if (notifications != null) 'notifications': notifications,
      if (peekGraph != null) 'peek_graph': peekGraph,
      if (planTrailing != null) 'plan_trailing': planTrailing,
      if (repEstimation != null) 'rep_estimation': repEstimation,
      if (restTimers != null) 'rest_timers': restTimers,
      if (shortDateFormat != null) 'short_date_format': shortDateFormat,
      if (showBodyWeight != null) 'show_body_weight': showBodyWeight,
      if (showCategories != null) 'show_categories': showCategories,
      if (showImages != null) 'show_images': showImages,
      if (showNotes != null) 'show_notes': showNotes,
      if (showGlobalProgress != null)
        'show_global_progress': showGlobalProgress,
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
      Value<double?>? curveSmoothness,
      Value<bool>? durationEstimation,
      Value<bool>? enableSound,
      Value<bool>? explainedPermissions,
      Value<bool>? groupHistory,
      Value<int>? id,
      Value<String>? longDateFormat,
      Value<int>? maxSets,
      Value<bool>? notifications,
      Value<bool>? peekGraph,
      Value<String>? planTrailing,
      Value<bool>? repEstimation,
      Value<bool>? restTimers,
      Value<String>? shortDateFormat,
      Value<bool>? showBodyWeight,
      Value<bool>? showCategories,
      Value<bool>? showImages,
      Value<bool>? showNotes,
      Value<bool>? showGlobalProgress,
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
      curveSmoothness: curveSmoothness ?? this.curveSmoothness,
      durationEstimation: durationEstimation ?? this.durationEstimation,
      enableSound: enableSound ?? this.enableSound,
      explainedPermissions: explainedPermissions ?? this.explainedPermissions,
      groupHistory: groupHistory ?? this.groupHistory,
      id: id ?? this.id,
      longDateFormat: longDateFormat ?? this.longDateFormat,
      maxSets: maxSets ?? this.maxSets,
      notifications: notifications ?? this.notifications,
      peekGraph: peekGraph ?? this.peekGraph,
      planTrailing: planTrailing ?? this.planTrailing,
      repEstimation: repEstimation ?? this.repEstimation,
      restTimers: restTimers ?? this.restTimers,
      shortDateFormat: shortDateFormat ?? this.shortDateFormat,
      showBodyWeight: showBodyWeight ?? this.showBodyWeight,
      showCategories: showCategories ?? this.showCategories,
      showImages: showImages ?? this.showImages,
      showNotes: showNotes ?? this.showNotes,
      showGlobalProgress: showGlobalProgress ?? this.showGlobalProgress,
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
    if (curveSmoothness.present) {
      map['curve_smoothness'] = Variable<double>(curveSmoothness.value);
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
    if (notifications.present) {
      map['notifications'] = Variable<bool>(notifications.value);
    }
    if (peekGraph.present) {
      map['peek_graph'] = Variable<bool>(peekGraph.value);
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
    if (showCategories.present) {
      map['show_categories'] = Variable<bool>(showCategories.value);
    }
    if (showImages.present) {
      map['show_images'] = Variable<bool>(showImages.value);
    }
    if (showNotes.present) {
      map['show_notes'] = Variable<bool>(showNotes.value);
    }
    if (showGlobalProgress.present) {
      map['show_global_progress'] = Variable<bool>(showGlobalProgress.value);
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
          ..write('curveSmoothness: $curveSmoothness, ')
          ..write('durationEstimation: $durationEstimation, ')
          ..write('enableSound: $enableSound, ')
          ..write('explainedPermissions: $explainedPermissions, ')
          ..write('groupHistory: $groupHistory, ')
          ..write('id: $id, ')
          ..write('longDateFormat: $longDateFormat, ')
          ..write('maxSets: $maxSets, ')
          ..write('notifications: $notifications, ')
          ..write('peekGraph: $peekGraph, ')
          ..write('planTrailing: $planTrailing, ')
          ..write('repEstimation: $repEstimation, ')
          ..write('restTimers: $restTimers, ')
          ..write('shortDateFormat: $shortDateFormat, ')
          ..write('showBodyWeight: $showBodyWeight, ')
          ..write('showCategories: $showCategories, ')
          ..write('showImages: $showImages, ')
          ..write('showNotes: $showNotes, ')
          ..write('showGlobalProgress: $showGlobalProgress, ')
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
  PlanExercise copyWithCompanion(PlanExercisesCompanion data) {
    return PlanExercise(
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      timers: data.timers.present ? data.timers.value : this.timers,
      exercise: data.exercise.present ? data.exercise.value : this.exercise,
      id: data.id.present ? data.id.value : this.id,
      maxSets: data.maxSets.present ? data.maxSets.value : this.maxSets,
      planId: data.planId.present ? data.planId.value : this.planId,
      warmupSets:
          data.warmupSets.present ? data.warmupSets.value : this.warmupSets,
    );
  }

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
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
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

typedef $$PlansTableCreateCompanionBuilder = PlansCompanion Function({
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

final class $$PlansTableReferences
    extends BaseReferences<_$AppDatabase, $PlansTable, Plan> {
  $$PlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlanExercisesTable, List<PlanExercise>>
      _planExercisesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.planExercises,
              aliasName:
                  $_aliasNameGenerator(db.plans.id, db.planExercises.planId));

  $$PlanExercisesTableProcessedTableManager get planExercisesRefs {
    final manager = $$PlanExercisesTableTableManager($_db, $_db.planExercises)
        .filter((f) => f.planId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_planExercisesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$PlansTableFilterComposer extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get days => $composableBuilder(
      column: $table.days, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exercises => $composableBuilder(
      column: $table.exercises, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sequence => $composableBuilder(
      column: $table.sequence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  Expression<bool> planExercisesRefs(
      Expression<bool> Function($$PlanExercisesTableFilterComposer f) f) {
    final $$PlanExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.planExercises,
        getReferencedColumn: (t) => t.planId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanExercisesTableFilterComposer(
              $db: $db,
              $table: $db.planExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlansTableOrderingComposer
    extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get days => $composableBuilder(
      column: $table.days, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exercises => $composableBuilder(
      column: $table.exercises, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sequence => $composableBuilder(
      column: $table.sequence, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));
}

class $$PlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlansTable> {
  $$PlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get days =>
      $composableBuilder(column: $table.days, builder: (column) => column);

  GeneratedColumn<String> get exercises =>
      $composableBuilder(column: $table.exercises, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sequence =>
      $composableBuilder(column: $table.sequence, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  Expression<T> planExercisesRefs<T extends Object>(
      Expression<T> Function($$PlanExercisesTableAnnotationComposer a) f) {
    final $$PlanExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.planExercises,
        getReferencedColumn: (t) => t.planId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.planExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$PlansTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlansTable,
    Plan,
    $$PlansTableFilterComposer,
    $$PlansTableOrderingComposer,
    $$PlansTableAnnotationComposer,
    $$PlansTableCreateCompanionBuilder,
    $$PlansTableUpdateCompanionBuilder,
    (Plan, $$PlansTableReferences),
    Plan,
    PrefetchHooks Function({bool planExercisesRefs})> {
  $$PlansTableTableManager(_$AppDatabase db, $PlansTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
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
          createCompanionCallback: ({
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
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$PlansTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({planExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (planExercisesRefs) db.planExercises
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (planExercisesRefs)
                    await $_getPrefetchedData<Plan, $PlansTable, PlanExercise>(
                        currentTable: table,
                        referencedTable:
                            $$PlansTableReferences._planExercisesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$PlansTableReferences(db, table, p0)
                                .planExercisesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.planId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$PlansTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlansTable,
    Plan,
    $$PlansTableFilterComposer,
    $$PlansTableOrderingComposer,
    $$PlansTableAnnotationComposer,
    $$PlansTableCreateCompanionBuilder,
    $$PlansTableUpdateCompanionBuilder,
    (Plan, $$PlansTableReferences),
    Plan,
    PrefetchHooks Function({bool planExercisesRefs})>;
typedef $$GymSetsTableCreateCompanionBuilder = GymSetsCompanion Function({
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
  Value<String?> notes,
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
  Value<String?> notes,
  Value<int?> planId,
  Value<double> reps,
  Value<int?> restMs,
  Value<String> unit,
  Value<double> weight,
});

final class $$GymSetsTableReferences
    extends BaseReferences<_$AppDatabase, $GymSetsTable, GymSet> {
  $$GymSetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlanExercisesTable, List<PlanExercise>>
      _planExercisesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.planExercises,
              aliasName: $_aliasNameGenerator(
                  db.gymSets.name, db.planExercises.exercise));

  $$PlanExercisesTableProcessedTableManager get planExercisesRefs {
    final manager = $$PlanExercisesTableTableManager($_db, $_db.planExercises)
        .filter(
            (f) => f.exercise.name.sqlEquals($_itemColumn<String>('name')!));

    final cache = $_typedResult.readTableOrNull(_planExercisesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$GymSetsTableFilterComposer
    extends Composer<_$AppDatabase, $GymSetsTable> {
  $$GymSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get bodyWeight => $composableBuilder(
      column: $table.bodyWeight, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get cardio => $composableBuilder(
      column: $table.cardio, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get created => $composableBuilder(
      column: $table.created, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get distance => $composableBuilder(
      column: $table.distance, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hidden => $composableBuilder(
      column: $table.hidden, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get incline => $composableBuilder(
      column: $table.incline, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get planId => $composableBuilder(
      column: $table.planId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get restMs => $composableBuilder(
      column: $table.restMs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  Expression<bool> planExercisesRefs(
      Expression<bool> Function($$PlanExercisesTableFilterComposer f) f) {
    final $$PlanExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.name,
        referencedTable: $db.planExercises,
        getReferencedColumn: (t) => t.exercise,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanExercisesTableFilterComposer(
              $db: $db,
              $table: $db.planExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GymSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $GymSetsTable> {
  $$GymSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get bodyWeight => $composableBuilder(
      column: $table.bodyWeight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get cardio => $composableBuilder(
      column: $table.cardio, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get created => $composableBuilder(
      column: $table.created, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get distance => $composableBuilder(
      column: $table.distance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hidden => $composableBuilder(
      column: $table.hidden, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get image => $composableBuilder(
      column: $table.image, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get incline => $composableBuilder(
      column: $table.incline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get planId => $composableBuilder(
      column: $table.planId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get restMs => $composableBuilder(
      column: $table.restMs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));
}

class $$GymSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GymSetsTable> {
  $$GymSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get bodyWeight => $composableBuilder(
      column: $table.bodyWeight, builder: (column) => column);

  GeneratedColumn<bool> get cardio =>
      $composableBuilder(column: $table.cardio, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<double> get distance =>
      $composableBuilder(column: $table.distance, builder: (column) => column);

  GeneratedColumn<double> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<bool> get hidden =>
      $composableBuilder(column: $table.hidden, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get image =>
      $composableBuilder(column: $table.image, builder: (column) => column);

  GeneratedColumn<int> get incline =>
      $composableBuilder(column: $table.incline, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get planId =>
      $composableBuilder(column: $table.planId, builder: (column) => column);

  GeneratedColumn<double> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get restMs =>
      $composableBuilder(column: $table.restMs, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  Expression<T> planExercisesRefs<T extends Object>(
      Expression<T> Function($$PlanExercisesTableAnnotationComposer a) f) {
    final $$PlanExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.name,
        referencedTable: $db.planExercises,
        getReferencedColumn: (t) => t.exercise,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlanExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.planExercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$GymSetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GymSetsTable,
    GymSet,
    $$GymSetsTableFilterComposer,
    $$GymSetsTableOrderingComposer,
    $$GymSetsTableAnnotationComposer,
    $$GymSetsTableCreateCompanionBuilder,
    $$GymSetsTableUpdateCompanionBuilder,
    (GymSet, $$GymSetsTableReferences),
    GymSet,
    PrefetchHooks Function({bool planExercisesRefs})> {
  $$GymSetsTableTableManager(_$AppDatabase db, $GymSetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GymSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GymSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GymSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
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
            Value<String?> notes = const Value.absent(),
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
            notes: notes,
            planId: planId,
            reps: reps,
            restMs: restMs,
            unit: unit,
            weight: weight,
          ),
          createCompanionCallback: ({
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
            Value<String?> notes = const Value.absent(),
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
            notes: notes,
            planId: planId,
            reps: reps,
            restMs: restMs,
            unit: unit,
            weight: weight,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$GymSetsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({planExercisesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (planExercisesRefs) db.planExercises
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (planExercisesRefs)
                    await $_getPrefetchedData<GymSet, $GymSetsTable,
                            PlanExercise>(
                        currentTable: table,
                        referencedTable: $$GymSetsTableReferences
                            ._planExercisesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$GymSetsTableReferences(db, table, p0)
                                .planExercisesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.exercise == item.name),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$GymSetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $GymSetsTable,
    GymSet,
    $$GymSetsTableFilterComposer,
    $$GymSetsTableOrderingComposer,
    $$GymSetsTableAnnotationComposer,
    $$GymSetsTableCreateCompanionBuilder,
    $$GymSetsTableUpdateCompanionBuilder,
    (GymSet, $$GymSetsTableReferences),
    GymSet,
    PrefetchHooks Function({bool planExercisesRefs})>;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String alarmSound,
  Value<bool> automaticBackups,
  Value<String?> backupPath,
  required String cardioUnit,
  required bool curveLines,
  Value<double?> curveSmoothness,
  Value<bool> durationEstimation,
  Value<bool> enableSound,
  required bool explainedPermissions,
  required bool groupHistory,
  Value<int> id,
  required String longDateFormat,
  required int maxSets,
  Value<bool> notifications,
  Value<bool> peekGraph,
  required String planTrailing,
  Value<bool> repEstimation,
  required bool restTimers,
  required String shortDateFormat,
  Value<bool> showBodyWeight,
  Value<bool> showCategories,
  Value<bool> showImages,
  Value<bool> showNotes,
  Value<bool> showGlobalProgress,
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
  Value<double?> curveSmoothness,
  Value<bool> durationEstimation,
  Value<bool> enableSound,
  Value<bool> explainedPermissions,
  Value<bool> groupHistory,
  Value<int> id,
  Value<String> longDateFormat,
  Value<int> maxSets,
  Value<bool> notifications,
  Value<bool> peekGraph,
  Value<String> planTrailing,
  Value<bool> repEstimation,
  Value<bool> restTimers,
  Value<String> shortDateFormat,
  Value<bool> showBodyWeight,
  Value<bool> showCategories,
  Value<bool> showImages,
  Value<bool> showNotes,
  Value<bool> showGlobalProgress,
  Value<bool> showUnits,
  Value<String> strengthUnit,
  Value<bool> systemColors,
  Value<String> tabs,
  Value<String> themeMode,
  Value<int> timerDuration,
  Value<bool> vibrate,
  Value<int?> warmupSets,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get alarmSound => $composableBuilder(
      column: $table.alarmSound, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get automaticBackups => $composableBuilder(
      column: $table.automaticBackups,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get backupPath => $composableBuilder(
      column: $table.backupPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardioUnit => $composableBuilder(
      column: $table.cardioUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get curveLines => $composableBuilder(
      column: $table.curveLines, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get curveSmoothness => $composableBuilder(
      column: $table.curveSmoothness,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get durationEstimation => $composableBuilder(
      column: $table.durationEstimation,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enableSound => $composableBuilder(
      column: $table.enableSound, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get explainedPermissions => $composableBuilder(
      column: $table.explainedPermissions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get groupHistory => $composableBuilder(
      column: $table.groupHistory, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get longDateFormat => $composableBuilder(
      column: $table.longDateFormat,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxSets => $composableBuilder(
      column: $table.maxSets, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notifications => $composableBuilder(
      column: $table.notifications, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get peekGraph => $composableBuilder(
      column: $table.peekGraph, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get planTrailing => $composableBuilder(
      column: $table.planTrailing, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get repEstimation => $composableBuilder(
      column: $table.repEstimation, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get restTimers => $composableBuilder(
      column: $table.restTimers, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shortDateFormat => $composableBuilder(
      column: $table.shortDateFormat,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showBodyWeight => $composableBuilder(
      column: $table.showBodyWeight,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showCategories => $composableBuilder(
      column: $table.showCategories,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showImages => $composableBuilder(
      column: $table.showImages, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showNotes => $composableBuilder(
      column: $table.showNotes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showGlobalProgress => $composableBuilder(
      column: $table.showGlobalProgress,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get showUnits => $composableBuilder(
      column: $table.showUnits, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get strengthUnit => $composableBuilder(
      column: $table.strengthUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get systemColors => $composableBuilder(
      column: $table.systemColors, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tabs => $composableBuilder(
      column: $table.tabs, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timerDuration => $composableBuilder(
      column: $table.timerDuration, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get vibrate => $composableBuilder(
      column: $table.vibrate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get warmupSets => $composableBuilder(
      column: $table.warmupSets, builder: (column) => ColumnFilters(column));
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get alarmSound => $composableBuilder(
      column: $table.alarmSound, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get automaticBackups => $composableBuilder(
      column: $table.automaticBackups,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get backupPath => $composableBuilder(
      column: $table.backupPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardioUnit => $composableBuilder(
      column: $table.cardioUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get curveLines => $composableBuilder(
      column: $table.curveLines, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get curveSmoothness => $composableBuilder(
      column: $table.curveSmoothness,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get durationEstimation => $composableBuilder(
      column: $table.durationEstimation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enableSound => $composableBuilder(
      column: $table.enableSound, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get explainedPermissions => $composableBuilder(
      column: $table.explainedPermissions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get groupHistory => $composableBuilder(
      column: $table.groupHistory,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get longDateFormat => $composableBuilder(
      column: $table.longDateFormat,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxSets => $composableBuilder(
      column: $table.maxSets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notifications => $composableBuilder(
      column: $table.notifications,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get peekGraph => $composableBuilder(
      column: $table.peekGraph, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get planTrailing => $composableBuilder(
      column: $table.planTrailing,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get repEstimation => $composableBuilder(
      column: $table.repEstimation,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get restTimers => $composableBuilder(
      column: $table.restTimers, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shortDateFormat => $composableBuilder(
      column: $table.shortDateFormat,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showBodyWeight => $composableBuilder(
      column: $table.showBodyWeight,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showCategories => $composableBuilder(
      column: $table.showCategories,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showImages => $composableBuilder(
      column: $table.showImages, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showNotes => $composableBuilder(
      column: $table.showNotes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showGlobalProgress => $composableBuilder(
      column: $table.showGlobalProgress,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get showUnits => $composableBuilder(
      column: $table.showUnits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get strengthUnit => $composableBuilder(
      column: $table.strengthUnit,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get systemColors => $composableBuilder(
      column: $table.systemColors,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tabs => $composableBuilder(
      column: $table.tabs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get themeMode => $composableBuilder(
      column: $table.themeMode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timerDuration => $composableBuilder(
      column: $table.timerDuration,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get vibrate => $composableBuilder(
      column: $table.vibrate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get warmupSets => $composableBuilder(
      column: $table.warmupSets, builder: (column) => ColumnOrderings(column));
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get alarmSound => $composableBuilder(
      column: $table.alarmSound, builder: (column) => column);

  GeneratedColumn<bool> get automaticBackups => $composableBuilder(
      column: $table.automaticBackups, builder: (column) => column);

  GeneratedColumn<String> get backupPath => $composableBuilder(
      column: $table.backupPath, builder: (column) => column);

  GeneratedColumn<String> get cardioUnit => $composableBuilder(
      column: $table.cardioUnit, builder: (column) => column);

  GeneratedColumn<bool> get curveLines => $composableBuilder(
      column: $table.curveLines, builder: (column) => column);

  GeneratedColumn<double> get curveSmoothness => $composableBuilder(
      column: $table.curveSmoothness, builder: (column) => column);

  GeneratedColumn<bool> get durationEstimation => $composableBuilder(
      column: $table.durationEstimation, builder: (column) => column);

  GeneratedColumn<bool> get enableSound => $composableBuilder(
      column: $table.enableSound, builder: (column) => column);

  GeneratedColumn<bool> get explainedPermissions => $composableBuilder(
      column: $table.explainedPermissions, builder: (column) => column);

  GeneratedColumn<bool> get groupHistory => $composableBuilder(
      column: $table.groupHistory, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get longDateFormat => $composableBuilder(
      column: $table.longDateFormat, builder: (column) => column);

  GeneratedColumn<int> get maxSets =>
      $composableBuilder(column: $table.maxSets, builder: (column) => column);

  GeneratedColumn<bool> get notifications => $composableBuilder(
      column: $table.notifications, builder: (column) => column);

  GeneratedColumn<bool> get peekGraph =>
      $composableBuilder(column: $table.peekGraph, builder: (column) => column);

  GeneratedColumn<String> get planTrailing => $composableBuilder(
      column: $table.planTrailing, builder: (column) => column);

  GeneratedColumn<bool> get repEstimation => $composableBuilder(
      column: $table.repEstimation, builder: (column) => column);

  GeneratedColumn<bool> get restTimers => $composableBuilder(
      column: $table.restTimers, builder: (column) => column);

  GeneratedColumn<String> get shortDateFormat => $composableBuilder(
      column: $table.shortDateFormat, builder: (column) => column);

  GeneratedColumn<bool> get showBodyWeight => $composableBuilder(
      column: $table.showBodyWeight, builder: (column) => column);

  GeneratedColumn<bool> get showCategories => $composableBuilder(
      column: $table.showCategories, builder: (column) => column);

  GeneratedColumn<bool> get showImages => $composableBuilder(
      column: $table.showImages, builder: (column) => column);

  GeneratedColumn<bool> get showNotes =>
      $composableBuilder(column: $table.showNotes, builder: (column) => column);

  GeneratedColumn<bool> get showGlobalProgress => $composableBuilder(
      column: $table.showGlobalProgress, builder: (column) => column);

  GeneratedColumn<bool> get showUnits =>
      $composableBuilder(column: $table.showUnits, builder: (column) => column);

  GeneratedColumn<String> get strengthUnit => $composableBuilder(
      column: $table.strengthUnit, builder: (column) => column);

  GeneratedColumn<bool> get systemColors => $composableBuilder(
      column: $table.systemColors, builder: (column) => column);

  GeneratedColumn<String> get tabs =>
      $composableBuilder(column: $table.tabs, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<int> get timerDuration => $composableBuilder(
      column: $table.timerDuration, builder: (column) => column);

  GeneratedColumn<bool> get vibrate =>
      $composableBuilder(column: $table.vibrate, builder: (column) => column);

  GeneratedColumn<int> get warmupSets => $composableBuilder(
      column: $table.warmupSets, builder: (column) => column);
}

class $$SettingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()> {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> alarmSound = const Value.absent(),
            Value<bool> automaticBackups = const Value.absent(),
            Value<String?> backupPath = const Value.absent(),
            Value<String> cardioUnit = const Value.absent(),
            Value<bool> curveLines = const Value.absent(),
            Value<double?> curveSmoothness = const Value.absent(),
            Value<bool> durationEstimation = const Value.absent(),
            Value<bool> enableSound = const Value.absent(),
            Value<bool> explainedPermissions = const Value.absent(),
            Value<bool> groupHistory = const Value.absent(),
            Value<int> id = const Value.absent(),
            Value<String> longDateFormat = const Value.absent(),
            Value<int> maxSets = const Value.absent(),
            Value<bool> notifications = const Value.absent(),
            Value<bool> peekGraph = const Value.absent(),
            Value<String> planTrailing = const Value.absent(),
            Value<bool> repEstimation = const Value.absent(),
            Value<bool> restTimers = const Value.absent(),
            Value<String> shortDateFormat = const Value.absent(),
            Value<bool> showBodyWeight = const Value.absent(),
            Value<bool> showCategories = const Value.absent(),
            Value<bool> showImages = const Value.absent(),
            Value<bool> showNotes = const Value.absent(),
            Value<bool> showGlobalProgress = const Value.absent(),
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
            curveSmoothness: curveSmoothness,
            durationEstimation: durationEstimation,
            enableSound: enableSound,
            explainedPermissions: explainedPermissions,
            groupHistory: groupHistory,
            id: id,
            longDateFormat: longDateFormat,
            maxSets: maxSets,
            notifications: notifications,
            peekGraph: peekGraph,
            planTrailing: planTrailing,
            repEstimation: repEstimation,
            restTimers: restTimers,
            shortDateFormat: shortDateFormat,
            showBodyWeight: showBodyWeight,
            showCategories: showCategories,
            showImages: showImages,
            showNotes: showNotes,
            showGlobalProgress: showGlobalProgress,
            showUnits: showUnits,
            strengthUnit: strengthUnit,
            systemColors: systemColors,
            tabs: tabs,
            themeMode: themeMode,
            timerDuration: timerDuration,
            vibrate: vibrate,
            warmupSets: warmupSets,
          ),
          createCompanionCallback: ({
            required String alarmSound,
            Value<bool> automaticBackups = const Value.absent(),
            Value<String?> backupPath = const Value.absent(),
            required String cardioUnit,
            required bool curveLines,
            Value<double?> curveSmoothness = const Value.absent(),
            Value<bool> durationEstimation = const Value.absent(),
            Value<bool> enableSound = const Value.absent(),
            required bool explainedPermissions,
            required bool groupHistory,
            Value<int> id = const Value.absent(),
            required String longDateFormat,
            required int maxSets,
            Value<bool> notifications = const Value.absent(),
            Value<bool> peekGraph = const Value.absent(),
            required String planTrailing,
            Value<bool> repEstimation = const Value.absent(),
            required bool restTimers,
            required String shortDateFormat,
            Value<bool> showBodyWeight = const Value.absent(),
            Value<bool> showCategories = const Value.absent(),
            Value<bool> showImages = const Value.absent(),
            Value<bool> showNotes = const Value.absent(),
            Value<bool> showGlobalProgress = const Value.absent(),
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
            curveSmoothness: curveSmoothness,
            durationEstimation: durationEstimation,
            enableSound: enableSound,
            explainedPermissions: explainedPermissions,
            groupHistory: groupHistory,
            id: id,
            longDateFormat: longDateFormat,
            maxSets: maxSets,
            notifications: notifications,
            peekGraph: peekGraph,
            planTrailing: planTrailing,
            repEstimation: repEstimation,
            restTimers: restTimers,
            shortDateFormat: shortDateFormat,
            showBodyWeight: showBodyWeight,
            showCategories: showCategories,
            showImages: showImages,
            showNotes: showNotes,
            showGlobalProgress: showGlobalProgress,
            showUnits: showUnits,
            strengthUnit: strengthUnit,
            systemColors: systemColors,
            tabs: tabs,
            themeMode: themeMode,
            timerDuration: timerDuration,
            vibrate: vibrate,
            warmupSets: warmupSets,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SettingsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SettingsTable,
    Setting,
    $$SettingsTableFilterComposer,
    $$SettingsTableOrderingComposer,
    $$SettingsTableAnnotationComposer,
    $$SettingsTableCreateCompanionBuilder,
    $$SettingsTableUpdateCompanionBuilder,
    (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
    Setting,
    PrefetchHooks Function()>;
typedef $$PlanExercisesTableCreateCompanionBuilder = PlanExercisesCompanion
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

final class $$PlanExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $PlanExercisesTable, PlanExercise> {
  $$PlanExercisesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $GymSetsTable _exerciseTable(_$AppDatabase db) =>
      db.gymSets.createAlias(
          $_aliasNameGenerator(db.planExercises.exercise, db.gymSets.name));

  $$GymSetsTableProcessedTableManager get exercise {
    final $_column = $_itemColumn<String>('exercise')!;

    final manager = $$GymSetsTableTableManager($_db, $_db.gymSets)
        .filter((f) => f.name.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $PlansTable _planIdTable(_$AppDatabase db) => db.plans
      .createAlias($_aliasNameGenerator(db.planExercises.planId, db.plans.id));

  $$PlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<int>('plan_id')!;

    final manager = $$PlansTableTableManager($_db, $_db.plans)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlanExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $PlanExercisesTable> {
  $$PlanExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get timers => $composableBuilder(
      column: $table.timers, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get maxSets => $composableBuilder(
      column: $table.maxSets, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get warmupSets => $composableBuilder(
      column: $table.warmupSets, builder: (column) => ColumnFilters(column));

  $$GymSetsTableFilterComposer get exercise {
    final $$GymSetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exercise,
        referencedTable: $db.gymSets,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GymSetsTableFilterComposer(
              $db: $db,
              $table: $db.gymSets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlansTableFilterComposer get planId {
    final $$PlansTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.plans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlansTableFilterComposer(
              $db: $db,
              $table: $db.plans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlanExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanExercisesTable> {
  $$PlanExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get timers => $composableBuilder(
      column: $table.timers, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get maxSets => $composableBuilder(
      column: $table.maxSets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get warmupSets => $composableBuilder(
      column: $table.warmupSets, builder: (column) => ColumnOrderings(column));

  $$GymSetsTableOrderingComposer get exercise {
    final $$GymSetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exercise,
        referencedTable: $db.gymSets,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GymSetsTableOrderingComposer(
              $db: $db,
              $table: $db.gymSets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlansTableOrderingComposer get planId {
    final $$PlansTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.plans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlansTableOrderingComposer(
              $db: $db,
              $table: $db.plans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlanExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanExercisesTable> {
  $$PlanExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get timers =>
      $composableBuilder(column: $table.timers, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get maxSets =>
      $composableBuilder(column: $table.maxSets, builder: (column) => column);

  GeneratedColumn<int> get warmupSets => $composableBuilder(
      column: $table.warmupSets, builder: (column) => column);

  $$GymSetsTableAnnotationComposer get exercise {
    final $$GymSetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exercise,
        referencedTable: $db.gymSets,
        getReferencedColumn: (t) => t.name,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$GymSetsTableAnnotationComposer(
              $db: $db,
              $table: $db.gymSets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$PlansTableAnnotationComposer get planId {
    final $$PlansTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.planId,
        referencedTable: $db.plans,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlansTableAnnotationComposer(
              $db: $db,
              $table: $db.plans,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlanExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlanExercisesTable,
    PlanExercise,
    $$PlanExercisesTableFilterComposer,
    $$PlanExercisesTableOrderingComposer,
    $$PlanExercisesTableAnnotationComposer,
    $$PlanExercisesTableCreateCompanionBuilder,
    $$PlanExercisesTableUpdateCompanionBuilder,
    (PlanExercise, $$PlanExercisesTableReferences),
    PlanExercise,
    PrefetchHooks Function({bool exercise, bool planId})> {
  $$PlanExercisesTableTableManager(_$AppDatabase db, $PlanExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
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
          createCompanionCallback: ({
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
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlanExercisesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({exercise = false, planId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (exercise) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.exercise,
                    referencedTable:
                        $$PlanExercisesTableReferences._exerciseTable(db),
                    referencedColumn:
                        $$PlanExercisesTableReferences._exerciseTable(db).name,
                  ) as T;
                }
                if (planId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.planId,
                    referencedTable:
                        $$PlanExercisesTableReferences._planIdTable(db),
                    referencedColumn:
                        $$PlanExercisesTableReferences._planIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PlanExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlanExercisesTable,
    PlanExercise,
    $$PlanExercisesTableFilterComposer,
    $$PlanExercisesTableOrderingComposer,
    $$PlanExercisesTableAnnotationComposer,
    $$PlanExercisesTableCreateCompanionBuilder,
    $$PlanExercisesTableUpdateCompanionBuilder,
    (PlanExercise, $$PlanExercisesTableReferences),
    PlanExercise,
    PrefetchHooks Function({bool exercise, bool planId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlansTableTableManager get plans =>
      $$PlansTableTableManager(_db, _db.plans);
  $$GymSetsTableTableManager get gymSets =>
      $$GymSetsTableTableManager(_db, _db.gymSets);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$PlanExercisesTableTableManager get planExercises =>
      $$PlanExercisesTableTableManager(_db, _db.planExercises);
}
