// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Plans extends Table with TableInfo<Plans, PlansData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Plans(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> days = GeneratedColumn<String>(
      'days', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> exercises = GeneratedColumn<String>(
      'exercises', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<int> sequence = GeneratedColumn<int>(
      'sequence', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlansData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlansData(
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
  Plans createAlias(String alias) {
    return Plans(attachedDatabase, alias);
  }
}

class PlansData extends DataClass implements Insertable<PlansData> {
  final String days;
  final String exercises;
  final int id;
  final int? sequence;
  final String? title;
  const PlansData(
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

  factory PlansData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlansData(
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

  PlansData copyWith(
          {String? days,
          String? exercises,
          int? id,
          Value<int?> sequence = const Value.absent(),
          Value<String?> title = const Value.absent()}) =>
      PlansData(
        days: days ?? this.days,
        exercises: exercises ?? this.exercises,
        id: id ?? this.id,
        sequence: sequence.present ? sequence.value : this.sequence,
        title: title.present ? title.value : this.title,
      );
  PlansData copyWithCompanion(PlansCompanion data) {
    return PlansData(
      days: data.days.present ? data.days.value : this.days,
      exercises: data.exercises.present ? data.exercises.value : this.exercises,
      id: data.id.present ? data.id.value : this.id,
      sequence: data.sequence.present ? data.sequence.value : this.sequence,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlansData(')
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
      (other is PlansData &&
          other.days == this.days &&
          other.exercises == this.exercises &&
          other.id == this.id &&
          other.sequence == this.sequence &&
          other.title == this.title);
}

class PlansCompanion extends UpdateCompanion<PlansData> {
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
  static Insertable<PlansData> custom({
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

class GymSets extends Table with TableInfo<GymSets, GymSetsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  GymSets(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<double> bodyWeight = GeneratedColumn<double>(
      'body_weight', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  late final GeneratedColumn<bool> cardio = GeneratedColumn<bool>(
      'cardio', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("cardio" IN (0, 1))'),
      defaultValue: const Constant(false));
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
      'created', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  late final GeneratedColumn<double> distance = GeneratedColumn<double>(
      'distance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  late final GeneratedColumn<double> duration = GeneratedColumn<double>(
      'duration', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  late final GeneratedColumn<bool> hidden = GeneratedColumn<bool>(
      'hidden', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("hidden" IN (0, 1))'),
      defaultValue: const Constant(false));
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> image = GeneratedColumn<String>(
      'image', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<int> incline = GeneratedColumn<int>(
      'incline', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
      'plan_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<double> reps = GeneratedColumn<double>(
      'reps', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  late final GeneratedColumn<int> restMs = GeneratedColumn<int>(
      'rest_ms', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GymSetsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GymSetsData(
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
  GymSets createAlias(String alias) {
    return GymSets(attachedDatabase, alias);
  }
}

class GymSetsData extends DataClass implements Insertable<GymSetsData> {
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
  const GymSetsData(
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

  factory GymSetsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GymSetsData(
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

  GymSetsData copyWith(
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
      GymSetsData(
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
  GymSetsData copyWithCompanion(GymSetsCompanion data) {
    return GymSetsData(
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
      planId: data.planId.present ? data.planId.value : this.planId,
      reps: data.reps.present ? data.reps.value : this.reps,
      restMs: data.restMs.present ? data.restMs.value : this.restMs,
      unit: data.unit.present ? data.unit.value : this.unit,
      weight: data.weight.present ? data.weight.value : this.weight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GymSetsData(')
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
      (other is GymSetsData &&
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

class GymSetsCompanion extends UpdateCompanion<GymSetsData> {
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
  static Insertable<GymSetsData> custom({
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

class Settings extends Table with TableInfo<Settings, SettingsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Settings(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> alarmSound = GeneratedColumn<String>(
      'alarm_sound', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<String> cardioUnit = GeneratedColumn<String>(
      'cardio_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<bool> curveLines = GeneratedColumn<bool>(
      'curve_lines', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("curve_lines" IN (0, 1))'));
  late final GeneratedColumn<bool> explainedPermissions = GeneratedColumn<bool>(
      'explained_permissions', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("explained_permissions" IN (0, 1))'));
  late final GeneratedColumn<bool> groupHistory = GeneratedColumn<bool>(
      'group_history', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("group_history" IN (0, 1))'));
  late final GeneratedColumn<bool> hideHistoryTab = GeneratedColumn<bool>(
      'hide_history_tab', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("hide_history_tab" IN (0, 1))'));
  late final GeneratedColumn<bool> hideTimerTab = GeneratedColumn<bool>(
      'hide_timer_tab', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("hide_timer_tab" IN (0, 1))'));
  late final GeneratedColumn<bool> hideWeight = GeneratedColumn<bool>(
      'hide_weight', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("hide_weight" IN (0, 1))'));
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> longDateFormat = GeneratedColumn<String>(
      'long_date_format', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> maxSets = GeneratedColumn<int>(
      'max_sets', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<String> planTrailing = GeneratedColumn<String>(
      'plan_trailing', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<bool> restTimers = GeneratedColumn<bool>(
      'rest_timers', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("rest_timers" IN (0, 1))'));
  late final GeneratedColumn<String> shortDateFormat = GeneratedColumn<String>(
      'short_date_format', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<bool> showImages = GeneratedColumn<bool>(
      'show_images', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_images" IN (0, 1))'),
      defaultValue: const Constant(true));
  late final GeneratedColumn<bool> showUnits = GeneratedColumn<bool>(
      'show_units', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("show_units" IN (0, 1))'));
  late final GeneratedColumn<String> strengthUnit = GeneratedColumn<String>(
      'strength_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<bool> systemColors = GeneratedColumn<bool>(
      'system_colors', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("system_colors" IN (0, 1))'));
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
      'theme_mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<int> timerDuration = GeneratedColumn<int>(
      'timer_duration', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  late final GeneratedColumn<bool> vibrate = GeneratedColumn<bool>(
      'vibrate', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("vibrate" IN (0, 1))'));
  late final GeneratedColumn<int> warmupSets = GeneratedColumn<int>(
      'warmup_sets', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        alarmSound,
        cardioUnit,
        curveLines,
        explainedPermissions,
        groupHistory,
        hideHistoryTab,
        hideTimerTab,
        hideWeight,
        id,
        longDateFormat,
        maxSets,
        planTrailing,
        restTimers,
        shortDateFormat,
        showImages,
        showUnits,
        strengthUnit,
        systemColors,
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsData(
      alarmSound: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alarm_sound'])!,
      cardioUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cardio_unit'])!,
      curveLines: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}curve_lines'])!,
      explainedPermissions: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}explained_permissions'])!,
      groupHistory: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}group_history'])!,
      hideHistoryTab: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hide_history_tab'])!,
      hideTimerTab: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hide_timer_tab'])!,
      hideWeight: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}hide_weight'])!,
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      longDateFormat: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}long_date_format'])!,
      maxSets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}max_sets'])!,
      planTrailing: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}plan_trailing'])!,
      restTimers: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}rest_timers'])!,
      shortDateFormat: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}short_date_format'])!,
      showImages: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_images'])!,
      showUnits: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_units'])!,
      strengthUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}strength_unit'])!,
      systemColors: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}system_colors'])!,
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
  Settings createAlias(String alias) {
    return Settings(attachedDatabase, alias);
  }
}

class SettingsData extends DataClass implements Insertable<SettingsData> {
  final String alarmSound;
  final String cardioUnit;
  final bool curveLines;
  final bool explainedPermissions;
  final bool groupHistory;
  final bool hideHistoryTab;
  final bool hideTimerTab;
  final bool hideWeight;
  final int id;
  final String longDateFormat;
  final int maxSets;
  final String planTrailing;
  final bool restTimers;
  final String shortDateFormat;
  final bool showImages;
  final bool showUnits;
  final String strengthUnit;
  final bool systemColors;
  final String themeMode;
  final int timerDuration;
  final bool vibrate;
  final int? warmupSets;
  const SettingsData(
      {required this.alarmSound,
      required this.cardioUnit,
      required this.curveLines,
      required this.explainedPermissions,
      required this.groupHistory,
      required this.hideHistoryTab,
      required this.hideTimerTab,
      required this.hideWeight,
      required this.id,
      required this.longDateFormat,
      required this.maxSets,
      required this.planTrailing,
      required this.restTimers,
      required this.shortDateFormat,
      required this.showImages,
      required this.showUnits,
      required this.strengthUnit,
      required this.systemColors,
      required this.themeMode,
      required this.timerDuration,
      required this.vibrate,
      this.warmupSets});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['alarm_sound'] = Variable<String>(alarmSound);
    map['cardio_unit'] = Variable<String>(cardioUnit);
    map['curve_lines'] = Variable<bool>(curveLines);
    map['explained_permissions'] = Variable<bool>(explainedPermissions);
    map['group_history'] = Variable<bool>(groupHistory);
    map['hide_history_tab'] = Variable<bool>(hideHistoryTab);
    map['hide_timer_tab'] = Variable<bool>(hideTimerTab);
    map['hide_weight'] = Variable<bool>(hideWeight);
    map['id'] = Variable<int>(id);
    map['long_date_format'] = Variable<String>(longDateFormat);
    map['max_sets'] = Variable<int>(maxSets);
    map['plan_trailing'] = Variable<String>(planTrailing);
    map['rest_timers'] = Variable<bool>(restTimers);
    map['short_date_format'] = Variable<String>(shortDateFormat);
    map['show_images'] = Variable<bool>(showImages);
    map['show_units'] = Variable<bool>(showUnits);
    map['strength_unit'] = Variable<String>(strengthUnit);
    map['system_colors'] = Variable<bool>(systemColors);
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
      cardioUnit: Value(cardioUnit),
      curveLines: Value(curveLines),
      explainedPermissions: Value(explainedPermissions),
      groupHistory: Value(groupHistory),
      hideHistoryTab: Value(hideHistoryTab),
      hideTimerTab: Value(hideTimerTab),
      hideWeight: Value(hideWeight),
      id: Value(id),
      longDateFormat: Value(longDateFormat),
      maxSets: Value(maxSets),
      planTrailing: Value(planTrailing),
      restTimers: Value(restTimers),
      shortDateFormat: Value(shortDateFormat),
      showImages: Value(showImages),
      showUnits: Value(showUnits),
      strengthUnit: Value(strengthUnit),
      systemColors: Value(systemColors),
      themeMode: Value(themeMode),
      timerDuration: Value(timerDuration),
      vibrate: Value(vibrate),
      warmupSets: warmupSets == null && nullToAbsent
          ? const Value.absent()
          : Value(warmupSets),
    );
  }

  factory SettingsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsData(
      alarmSound: serializer.fromJson<String>(json['alarmSound']),
      cardioUnit: serializer.fromJson<String>(json['cardioUnit']),
      curveLines: serializer.fromJson<bool>(json['curveLines']),
      explainedPermissions:
          serializer.fromJson<bool>(json['explainedPermissions']),
      groupHistory: serializer.fromJson<bool>(json['groupHistory']),
      hideHistoryTab: serializer.fromJson<bool>(json['hideHistoryTab']),
      hideTimerTab: serializer.fromJson<bool>(json['hideTimerTab']),
      hideWeight: serializer.fromJson<bool>(json['hideWeight']),
      id: serializer.fromJson<int>(json['id']),
      longDateFormat: serializer.fromJson<String>(json['longDateFormat']),
      maxSets: serializer.fromJson<int>(json['maxSets']),
      planTrailing: serializer.fromJson<String>(json['planTrailing']),
      restTimers: serializer.fromJson<bool>(json['restTimers']),
      shortDateFormat: serializer.fromJson<String>(json['shortDateFormat']),
      showImages: serializer.fromJson<bool>(json['showImages']),
      showUnits: serializer.fromJson<bool>(json['showUnits']),
      strengthUnit: serializer.fromJson<String>(json['strengthUnit']),
      systemColors: serializer.fromJson<bool>(json['systemColors']),
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
      'cardioUnit': serializer.toJson<String>(cardioUnit),
      'curveLines': serializer.toJson<bool>(curveLines),
      'explainedPermissions': serializer.toJson<bool>(explainedPermissions),
      'groupHistory': serializer.toJson<bool>(groupHistory),
      'hideHistoryTab': serializer.toJson<bool>(hideHistoryTab),
      'hideTimerTab': serializer.toJson<bool>(hideTimerTab),
      'hideWeight': serializer.toJson<bool>(hideWeight),
      'id': serializer.toJson<int>(id),
      'longDateFormat': serializer.toJson<String>(longDateFormat),
      'maxSets': serializer.toJson<int>(maxSets),
      'planTrailing': serializer.toJson<String>(planTrailing),
      'restTimers': serializer.toJson<bool>(restTimers),
      'shortDateFormat': serializer.toJson<String>(shortDateFormat),
      'showImages': serializer.toJson<bool>(showImages),
      'showUnits': serializer.toJson<bool>(showUnits),
      'strengthUnit': serializer.toJson<String>(strengthUnit),
      'systemColors': serializer.toJson<bool>(systemColors),
      'themeMode': serializer.toJson<String>(themeMode),
      'timerDuration': serializer.toJson<int>(timerDuration),
      'vibrate': serializer.toJson<bool>(vibrate),
      'warmupSets': serializer.toJson<int?>(warmupSets),
    };
  }

  SettingsData copyWith(
          {String? alarmSound,
          String? cardioUnit,
          bool? curveLines,
          bool? explainedPermissions,
          bool? groupHistory,
          bool? hideHistoryTab,
          bool? hideTimerTab,
          bool? hideWeight,
          int? id,
          String? longDateFormat,
          int? maxSets,
          String? planTrailing,
          bool? restTimers,
          String? shortDateFormat,
          bool? showImages,
          bool? showUnits,
          String? strengthUnit,
          bool? systemColors,
          String? themeMode,
          int? timerDuration,
          bool? vibrate,
          Value<int?> warmupSets = const Value.absent()}) =>
      SettingsData(
        alarmSound: alarmSound ?? this.alarmSound,
        cardioUnit: cardioUnit ?? this.cardioUnit,
        curveLines: curveLines ?? this.curveLines,
        explainedPermissions: explainedPermissions ?? this.explainedPermissions,
        groupHistory: groupHistory ?? this.groupHistory,
        hideHistoryTab: hideHistoryTab ?? this.hideHistoryTab,
        hideTimerTab: hideTimerTab ?? this.hideTimerTab,
        hideWeight: hideWeight ?? this.hideWeight,
        id: id ?? this.id,
        longDateFormat: longDateFormat ?? this.longDateFormat,
        maxSets: maxSets ?? this.maxSets,
        planTrailing: planTrailing ?? this.planTrailing,
        restTimers: restTimers ?? this.restTimers,
        shortDateFormat: shortDateFormat ?? this.shortDateFormat,
        showImages: showImages ?? this.showImages,
        showUnits: showUnits ?? this.showUnits,
        strengthUnit: strengthUnit ?? this.strengthUnit,
        systemColors: systemColors ?? this.systemColors,
        themeMode: themeMode ?? this.themeMode,
        timerDuration: timerDuration ?? this.timerDuration,
        vibrate: vibrate ?? this.vibrate,
        warmupSets: warmupSets.present ? warmupSets.value : this.warmupSets,
      );
  SettingsData copyWithCompanion(SettingsCompanion data) {
    return SettingsData(
      alarmSound:
          data.alarmSound.present ? data.alarmSound.value : this.alarmSound,
      cardioUnit:
          data.cardioUnit.present ? data.cardioUnit.value : this.cardioUnit,
      curveLines:
          data.curveLines.present ? data.curveLines.value : this.curveLines,
      explainedPermissions: data.explainedPermissions.present
          ? data.explainedPermissions.value
          : this.explainedPermissions,
      groupHistory: data.groupHistory.present
          ? data.groupHistory.value
          : this.groupHistory,
      hideHistoryTab: data.hideHistoryTab.present
          ? data.hideHistoryTab.value
          : this.hideHistoryTab,
      hideTimerTab: data.hideTimerTab.present
          ? data.hideTimerTab.value
          : this.hideTimerTab,
      hideWeight:
          data.hideWeight.present ? data.hideWeight.value : this.hideWeight,
      id: data.id.present ? data.id.value : this.id,
      longDateFormat: data.longDateFormat.present
          ? data.longDateFormat.value
          : this.longDateFormat,
      maxSets: data.maxSets.present ? data.maxSets.value : this.maxSets,
      planTrailing: data.planTrailing.present
          ? data.planTrailing.value
          : this.planTrailing,
      restTimers:
          data.restTimers.present ? data.restTimers.value : this.restTimers,
      shortDateFormat: data.shortDateFormat.present
          ? data.shortDateFormat.value
          : this.shortDateFormat,
      showImages:
          data.showImages.present ? data.showImages.value : this.showImages,
      showUnits: data.showUnits.present ? data.showUnits.value : this.showUnits,
      strengthUnit: data.strengthUnit.present
          ? data.strengthUnit.value
          : this.strengthUnit,
      systemColors: data.systemColors.present
          ? data.systemColors.value
          : this.systemColors,
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
    return (StringBuffer('SettingsData(')
          ..write('alarmSound: $alarmSound, ')
          ..write('cardioUnit: $cardioUnit, ')
          ..write('curveLines: $curveLines, ')
          ..write('explainedPermissions: $explainedPermissions, ')
          ..write('groupHistory: $groupHistory, ')
          ..write('hideHistoryTab: $hideHistoryTab, ')
          ..write('hideTimerTab: $hideTimerTab, ')
          ..write('hideWeight: $hideWeight, ')
          ..write('id: $id, ')
          ..write('longDateFormat: $longDateFormat, ')
          ..write('maxSets: $maxSets, ')
          ..write('planTrailing: $planTrailing, ')
          ..write('restTimers: $restTimers, ')
          ..write('shortDateFormat: $shortDateFormat, ')
          ..write('showImages: $showImages, ')
          ..write('showUnits: $showUnits, ')
          ..write('strengthUnit: $strengthUnit, ')
          ..write('systemColors: $systemColors, ')
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
        cardioUnit,
        curveLines,
        explainedPermissions,
        groupHistory,
        hideHistoryTab,
        hideTimerTab,
        hideWeight,
        id,
        longDateFormat,
        maxSets,
        planTrailing,
        restTimers,
        shortDateFormat,
        showImages,
        showUnits,
        strengthUnit,
        systemColors,
        themeMode,
        timerDuration,
        vibrate,
        warmupSets
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsData &&
          other.alarmSound == this.alarmSound &&
          other.cardioUnit == this.cardioUnit &&
          other.curveLines == this.curveLines &&
          other.explainedPermissions == this.explainedPermissions &&
          other.groupHistory == this.groupHistory &&
          other.hideHistoryTab == this.hideHistoryTab &&
          other.hideTimerTab == this.hideTimerTab &&
          other.hideWeight == this.hideWeight &&
          other.id == this.id &&
          other.longDateFormat == this.longDateFormat &&
          other.maxSets == this.maxSets &&
          other.planTrailing == this.planTrailing &&
          other.restTimers == this.restTimers &&
          other.shortDateFormat == this.shortDateFormat &&
          other.showImages == this.showImages &&
          other.showUnits == this.showUnits &&
          other.strengthUnit == this.strengthUnit &&
          other.systemColors == this.systemColors &&
          other.themeMode == this.themeMode &&
          other.timerDuration == this.timerDuration &&
          other.vibrate == this.vibrate &&
          other.warmupSets == this.warmupSets);
}

class SettingsCompanion extends UpdateCompanion<SettingsData> {
  final Value<String> alarmSound;
  final Value<String> cardioUnit;
  final Value<bool> curveLines;
  final Value<bool> explainedPermissions;
  final Value<bool> groupHistory;
  final Value<bool> hideHistoryTab;
  final Value<bool> hideTimerTab;
  final Value<bool> hideWeight;
  final Value<int> id;
  final Value<String> longDateFormat;
  final Value<int> maxSets;
  final Value<String> planTrailing;
  final Value<bool> restTimers;
  final Value<String> shortDateFormat;
  final Value<bool> showImages;
  final Value<bool> showUnits;
  final Value<String> strengthUnit;
  final Value<bool> systemColors;
  final Value<String> themeMode;
  final Value<int> timerDuration;
  final Value<bool> vibrate;
  final Value<int?> warmupSets;
  const SettingsCompanion({
    this.alarmSound = const Value.absent(),
    this.cardioUnit = const Value.absent(),
    this.curveLines = const Value.absent(),
    this.explainedPermissions = const Value.absent(),
    this.groupHistory = const Value.absent(),
    this.hideHistoryTab = const Value.absent(),
    this.hideTimerTab = const Value.absent(),
    this.hideWeight = const Value.absent(),
    this.id = const Value.absent(),
    this.longDateFormat = const Value.absent(),
    this.maxSets = const Value.absent(),
    this.planTrailing = const Value.absent(),
    this.restTimers = const Value.absent(),
    this.shortDateFormat = const Value.absent(),
    this.showImages = const Value.absent(),
    this.showUnits = const Value.absent(),
    this.strengthUnit = const Value.absent(),
    this.systemColors = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.timerDuration = const Value.absent(),
    this.vibrate = const Value.absent(),
    this.warmupSets = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String alarmSound,
    required String cardioUnit,
    required bool curveLines,
    required bool explainedPermissions,
    required bool groupHistory,
    required bool hideHistoryTab,
    required bool hideTimerTab,
    required bool hideWeight,
    this.id = const Value.absent(),
    required String longDateFormat,
    required int maxSets,
    required String planTrailing,
    required bool restTimers,
    required String shortDateFormat,
    this.showImages = const Value.absent(),
    required bool showUnits,
    required String strengthUnit,
    required bool systemColors,
    required String themeMode,
    required int timerDuration,
    required bool vibrate,
    this.warmupSets = const Value.absent(),
  })  : alarmSound = Value(alarmSound),
        cardioUnit = Value(cardioUnit),
        curveLines = Value(curveLines),
        explainedPermissions = Value(explainedPermissions),
        groupHistory = Value(groupHistory),
        hideHistoryTab = Value(hideHistoryTab),
        hideTimerTab = Value(hideTimerTab),
        hideWeight = Value(hideWeight),
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
  static Insertable<SettingsData> custom({
    Expression<String>? alarmSound,
    Expression<String>? cardioUnit,
    Expression<bool>? curveLines,
    Expression<bool>? explainedPermissions,
    Expression<bool>? groupHistory,
    Expression<bool>? hideHistoryTab,
    Expression<bool>? hideTimerTab,
    Expression<bool>? hideWeight,
    Expression<int>? id,
    Expression<String>? longDateFormat,
    Expression<int>? maxSets,
    Expression<String>? planTrailing,
    Expression<bool>? restTimers,
    Expression<String>? shortDateFormat,
    Expression<bool>? showImages,
    Expression<bool>? showUnits,
    Expression<String>? strengthUnit,
    Expression<bool>? systemColors,
    Expression<String>? themeMode,
    Expression<int>? timerDuration,
    Expression<bool>? vibrate,
    Expression<int>? warmupSets,
  }) {
    return RawValuesInsertable({
      if (alarmSound != null) 'alarm_sound': alarmSound,
      if (cardioUnit != null) 'cardio_unit': cardioUnit,
      if (curveLines != null) 'curve_lines': curveLines,
      if (explainedPermissions != null)
        'explained_permissions': explainedPermissions,
      if (groupHistory != null) 'group_history': groupHistory,
      if (hideHistoryTab != null) 'hide_history_tab': hideHistoryTab,
      if (hideTimerTab != null) 'hide_timer_tab': hideTimerTab,
      if (hideWeight != null) 'hide_weight': hideWeight,
      if (id != null) 'id': id,
      if (longDateFormat != null) 'long_date_format': longDateFormat,
      if (maxSets != null) 'max_sets': maxSets,
      if (planTrailing != null) 'plan_trailing': planTrailing,
      if (restTimers != null) 'rest_timers': restTimers,
      if (shortDateFormat != null) 'short_date_format': shortDateFormat,
      if (showImages != null) 'show_images': showImages,
      if (showUnits != null) 'show_units': showUnits,
      if (strengthUnit != null) 'strength_unit': strengthUnit,
      if (systemColors != null) 'system_colors': systemColors,
      if (themeMode != null) 'theme_mode': themeMode,
      if (timerDuration != null) 'timer_duration': timerDuration,
      if (vibrate != null) 'vibrate': vibrate,
      if (warmupSets != null) 'warmup_sets': warmupSets,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? alarmSound,
      Value<String>? cardioUnit,
      Value<bool>? curveLines,
      Value<bool>? explainedPermissions,
      Value<bool>? groupHistory,
      Value<bool>? hideHistoryTab,
      Value<bool>? hideTimerTab,
      Value<bool>? hideWeight,
      Value<int>? id,
      Value<String>? longDateFormat,
      Value<int>? maxSets,
      Value<String>? planTrailing,
      Value<bool>? restTimers,
      Value<String>? shortDateFormat,
      Value<bool>? showImages,
      Value<bool>? showUnits,
      Value<String>? strengthUnit,
      Value<bool>? systemColors,
      Value<String>? themeMode,
      Value<int>? timerDuration,
      Value<bool>? vibrate,
      Value<int?>? warmupSets}) {
    return SettingsCompanion(
      alarmSound: alarmSound ?? this.alarmSound,
      cardioUnit: cardioUnit ?? this.cardioUnit,
      curveLines: curveLines ?? this.curveLines,
      explainedPermissions: explainedPermissions ?? this.explainedPermissions,
      groupHistory: groupHistory ?? this.groupHistory,
      hideHistoryTab: hideHistoryTab ?? this.hideHistoryTab,
      hideTimerTab: hideTimerTab ?? this.hideTimerTab,
      hideWeight: hideWeight ?? this.hideWeight,
      id: id ?? this.id,
      longDateFormat: longDateFormat ?? this.longDateFormat,
      maxSets: maxSets ?? this.maxSets,
      planTrailing: planTrailing ?? this.planTrailing,
      restTimers: restTimers ?? this.restTimers,
      shortDateFormat: shortDateFormat ?? this.shortDateFormat,
      showImages: showImages ?? this.showImages,
      showUnits: showUnits ?? this.showUnits,
      strengthUnit: strengthUnit ?? this.strengthUnit,
      systemColors: systemColors ?? this.systemColors,
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
    if (cardioUnit.present) {
      map['cardio_unit'] = Variable<String>(cardioUnit.value);
    }
    if (curveLines.present) {
      map['curve_lines'] = Variable<bool>(curveLines.value);
    }
    if (explainedPermissions.present) {
      map['explained_permissions'] = Variable<bool>(explainedPermissions.value);
    }
    if (groupHistory.present) {
      map['group_history'] = Variable<bool>(groupHistory.value);
    }
    if (hideHistoryTab.present) {
      map['hide_history_tab'] = Variable<bool>(hideHistoryTab.value);
    }
    if (hideTimerTab.present) {
      map['hide_timer_tab'] = Variable<bool>(hideTimerTab.value);
    }
    if (hideWeight.present) {
      map['hide_weight'] = Variable<bool>(hideWeight.value);
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
    if (restTimers.present) {
      map['rest_timers'] = Variable<bool>(restTimers.value);
    }
    if (shortDateFormat.present) {
      map['short_date_format'] = Variable<String>(shortDateFormat.value);
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
          ..write('cardioUnit: $cardioUnit, ')
          ..write('curveLines: $curveLines, ')
          ..write('explainedPermissions: $explainedPermissions, ')
          ..write('groupHistory: $groupHistory, ')
          ..write('hideHistoryTab: $hideHistoryTab, ')
          ..write('hideTimerTab: $hideTimerTab, ')
          ..write('hideWeight: $hideWeight, ')
          ..write('id: $id, ')
          ..write('longDateFormat: $longDateFormat, ')
          ..write('maxSets: $maxSets, ')
          ..write('planTrailing: $planTrailing, ')
          ..write('restTimers: $restTimers, ')
          ..write('shortDateFormat: $shortDateFormat, ')
          ..write('showImages: $showImages, ')
          ..write('showUnits: $showUnits, ')
          ..write('strengthUnit: $strengthUnit, ')
          ..write('systemColors: $systemColors, ')
          ..write('themeMode: $themeMode, ')
          ..write('timerDuration: $timerDuration, ')
          ..write('vibrate: $vibrate, ')
          ..write('warmupSets: $warmupSets')
          ..write(')'))
        .toString();
  }
}

class PlanExercises extends Table
    with TableInfo<PlanExercises, PlanExercisesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PlanExercises(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'));
  late final GeneratedColumn<String> exercise = GeneratedColumn<String>(
      'exercise', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES gym_sets (name)'));
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<int> maxSets = GeneratedColumn<int>(
      'max_sets', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
      'plan_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES plans (id)'));
  late final GeneratedColumn<int> warmupSets = GeneratedColumn<int>(
      'warmup_sets', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [enabled, exercise, id, maxSets, planId, warmupSets];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_exercises';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanExercisesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanExercisesData(
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
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
  PlanExercises createAlias(String alias) {
    return PlanExercises(attachedDatabase, alias);
  }
}

class PlanExercisesData extends DataClass
    implements Insertable<PlanExercisesData> {
  final bool enabled;
  final String exercise;
  final int id;
  final int? maxSets;
  final int planId;
  final int? warmupSets;
  const PlanExercisesData(
      {required this.enabled,
      required this.exercise,
      required this.id,
      this.maxSets,
      required this.planId,
      this.warmupSets});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['enabled'] = Variable<bool>(enabled);
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

  factory PlanExercisesData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanExercisesData(
      enabled: serializer.fromJson<bool>(json['enabled']),
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
      'exercise': serializer.toJson<String>(exercise),
      'id': serializer.toJson<int>(id),
      'maxSets': serializer.toJson<int?>(maxSets),
      'planId': serializer.toJson<int>(planId),
      'warmupSets': serializer.toJson<int?>(warmupSets),
    };
  }

  PlanExercisesData copyWith(
          {bool? enabled,
          String? exercise,
          int? id,
          Value<int?> maxSets = const Value.absent(),
          int? planId,
          Value<int?> warmupSets = const Value.absent()}) =>
      PlanExercisesData(
        enabled: enabled ?? this.enabled,
        exercise: exercise ?? this.exercise,
        id: id ?? this.id,
        maxSets: maxSets.present ? maxSets.value : this.maxSets,
        planId: planId ?? this.planId,
        warmupSets: warmupSets.present ? warmupSets.value : this.warmupSets,
      );
  PlanExercisesData copyWithCompanion(PlanExercisesCompanion data) {
    return PlanExercisesData(
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
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
    return (StringBuffer('PlanExercisesData(')
          ..write('enabled: $enabled, ')
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
      Object.hash(enabled, exercise, id, maxSets, planId, warmupSets);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanExercisesData &&
          other.enabled == this.enabled &&
          other.exercise == this.exercise &&
          other.id == this.id &&
          other.maxSets == this.maxSets &&
          other.planId == this.planId &&
          other.warmupSets == this.warmupSets);
}

class PlanExercisesCompanion extends UpdateCompanion<PlanExercisesData> {
  final Value<bool> enabled;
  final Value<String> exercise;
  final Value<int> id;
  final Value<int?> maxSets;
  final Value<int> planId;
  final Value<int?> warmupSets;
  const PlanExercisesCompanion({
    this.enabled = const Value.absent(),
    this.exercise = const Value.absent(),
    this.id = const Value.absent(),
    this.maxSets = const Value.absent(),
    this.planId = const Value.absent(),
    this.warmupSets = const Value.absent(),
  });
  PlanExercisesCompanion.insert({
    required bool enabled,
    required String exercise,
    this.id = const Value.absent(),
    this.maxSets = const Value.absent(),
    required int planId,
    this.warmupSets = const Value.absent(),
  })  : enabled = Value(enabled),
        exercise = Value(exercise),
        planId = Value(planId);
  static Insertable<PlanExercisesData> custom({
    Expression<bool>? enabled,
    Expression<String>? exercise,
    Expression<int>? id,
    Expression<int>? maxSets,
    Expression<int>? planId,
    Expression<int>? warmupSets,
  }) {
    return RawValuesInsertable({
      if (enabled != null) 'enabled': enabled,
      if (exercise != null) 'exercise': exercise,
      if (id != null) 'id': id,
      if (maxSets != null) 'max_sets': maxSets,
      if (planId != null) 'plan_id': planId,
      if (warmupSets != null) 'warmup_sets': warmupSets,
    });
  }

  PlanExercisesCompanion copyWith(
      {Value<bool>? enabled,
      Value<String>? exercise,
      Value<int>? id,
      Value<int?>? maxSets,
      Value<int>? planId,
      Value<int?>? warmupSets}) {
    return PlanExercisesCompanion(
      enabled: enabled ?? this.enabled,
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
          ..write('exercise: $exercise, ')
          ..write('id: $id, ')
          ..write('maxSets: $maxSets, ')
          ..write('planId: $planId, ')
          ..write('warmupSets: $warmupSets')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV21 extends GeneratedDatabase {
  DatabaseAtV21(QueryExecutor e) : super(e);
  late final Plans plans = Plans(this);
  late final GymSets gymSets = GymSets(this);
  late final Settings settings = Settings(this);
  late final PlanExercises planExercises = PlanExercises(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [plans, gymSets, settings, planExercises];
  @override
  int get schemaVersion => 21;
}
