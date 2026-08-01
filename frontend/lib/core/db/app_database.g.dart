// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LearningStagesTable extends LearningStages
    with TableInfo<$LearningStagesTable, LearningStage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LearningStagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slug,
    order,
    title,
    description,
    icon,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'learning_stages';
  @override
  VerificationContext validateIntegrity(
    Insertable<LearningStage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LearningStage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LearningStage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
    );
  }

  @override
  $LearningStagesTable createAlias(String alias) {
    return $LearningStagesTable(attachedDatabase, alias);
  }
}

class LearningStage extends DataClass implements Insertable<LearningStage> {
  final int id;
  final String slug;
  final int order;
  final String title;
  final String? description;
  final String? icon;
  const LearningStage({
    required this.id,
    required this.slug,
    required this.order,
    required this.title,
    this.description,
    this.icon,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['slug'] = Variable<String>(slug);
    map['order'] = Variable<int>(order);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    return map;
  }

  LearningStagesCompanion toCompanion(bool nullToAbsent) {
    return LearningStagesCompanion(
      id: Value(id),
      slug: Value(slug),
      order: Value(order),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
    );
  }

  factory LearningStage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LearningStage(
      id: serializer.fromJson<int>(json['id']),
      slug: serializer.fromJson<String>(json['slug']),
      order: serializer.fromJson<int>(json['order']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      icon: serializer.fromJson<String?>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slug': serializer.toJson<String>(slug),
      'order': serializer.toJson<int>(order),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<String?>(icon),
    };
  }

  LearningStage copyWith({
    int? id,
    String? slug,
    int? order,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> icon = const Value.absent(),
  }) => LearningStage(
    id: id ?? this.id,
    slug: slug ?? this.slug,
    order: order ?? this.order,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    icon: icon.present ? icon.value : this.icon,
  );
  LearningStage copyWithCompanion(LearningStagesCompanion data) {
    return LearningStage(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      order: data.order.present ? data.order.value : this.order,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      icon: data.icon.present ? data.icon.value : this.icon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LearningStage(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('order: $order, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, slug, order, title, description, icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LearningStage &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.order == this.order &&
          other.title == this.title &&
          other.description == this.description &&
          other.icon == this.icon);
}

class LearningStagesCompanion extends UpdateCompanion<LearningStage> {
  final Value<int> id;
  final Value<String> slug;
  final Value<int> order;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> icon;
  const LearningStagesCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.order = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
  });
  LearningStagesCompanion.insert({
    this.id = const Value.absent(),
    required String slug,
    required int order,
    required String title,
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
  }) : slug = Value(slug),
       order = Value(order),
       title = Value(title);
  static Insertable<LearningStage> custom({
    Expression<int>? id,
    Expression<String>? slug,
    Expression<int>? order,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? icon,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (order != null) 'order': order,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
    });
  }

  LearningStagesCompanion copyWith({
    Value<int>? id,
    Value<String>? slug,
    Value<int>? order,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? icon,
  }) {
    return LearningStagesCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      order: order ?? this.order,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LearningStagesCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('order: $order, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }
}

class $LessonsTable extends Lessons with TableInfo<$LessonsTable, Lesson> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _learningStageIdMeta = const VerificationMeta(
    'learningStageId',
  );
  @override
  late final GeneratedColumn<int> learningStageId = GeneratedColumn<int>(
    'learning_stage_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyJsonMeta = const VerificationMeta(
    'bodyJson',
  );
  @override
  late final GeneratedColumn<String> bodyJson = GeneratedColumn<String>(
    'body_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _needToKnowMeta = const VerificationMeta(
    'needToKnow',
  );
  @override
  late final GeneratedColumn<bool> needToKnow = GeneratedColumn<bool>(
    'need_to_know',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("need_to_know" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    learningStageId,
    slug,
    order,
    title,
    summary,
    bodyJson,
    estimatedMinutes,
    needToKnow,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lessons';
  @override
  VerificationContext validateIntegrity(
    Insertable<Lesson> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('learning_stage_id')) {
      context.handle(
        _learningStageIdMeta,
        learningStageId.isAcceptableOrUnknown(
          data['learning_stage_id']!,
          _learningStageIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_learningStageIdMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    }
    if (data.containsKey('body_json')) {
      context.handle(
        _bodyJsonMeta,
        bodyJson.isAcceptableOrUnknown(data['body_json']!, _bodyJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyJsonMeta);
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    }
    if (data.containsKey('need_to_know')) {
      context.handle(
        _needToKnowMeta,
        needToKnow.isAcceptableOrUnknown(
          data['need_to_know']!,
          _needToKnowMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Lesson map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Lesson(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      learningStageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}learning_stage_id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      ),
      bodyJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_json'],
      )!,
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      )!,
      needToKnow: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}need_to_know'],
      )!,
    );
  }

  @override
  $LessonsTable createAlias(String alias) {
    return $LessonsTable(attachedDatabase, alias);
  }
}

class Lesson extends DataClass implements Insertable<Lesson> {
  final int id;
  final int learningStageId;
  final String slug;
  final int order;
  final String title;
  final String? summary;

  /// JSON-encoded array of structured content blocks (heading/text/quote/...).
  final String bodyJson;
  final int estimatedMinutes;
  final bool needToKnow;
  const Lesson({
    required this.id,
    required this.learningStageId,
    required this.slug,
    required this.order,
    required this.title,
    this.summary,
    required this.bodyJson,
    required this.estimatedMinutes,
    required this.needToKnow,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['learning_stage_id'] = Variable<int>(learningStageId);
    map['slug'] = Variable<String>(slug);
    map['order'] = Variable<int>(order);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['body_json'] = Variable<String>(bodyJson);
    map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    map['need_to_know'] = Variable<bool>(needToKnow);
    return map;
  }

  LessonsCompanion toCompanion(bool nullToAbsent) {
    return LessonsCompanion(
      id: Value(id),
      learningStageId: Value(learningStageId),
      slug: Value(slug),
      order: Value(order),
      title: Value(title),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      bodyJson: Value(bodyJson),
      estimatedMinutes: Value(estimatedMinutes),
      needToKnow: Value(needToKnow),
    );
  }

  factory Lesson.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Lesson(
      id: serializer.fromJson<int>(json['id']),
      learningStageId: serializer.fromJson<int>(json['learningStageId']),
      slug: serializer.fromJson<String>(json['slug']),
      order: serializer.fromJson<int>(json['order']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String?>(json['summary']),
      bodyJson: serializer.fromJson<String>(json['bodyJson']),
      estimatedMinutes: serializer.fromJson<int>(json['estimatedMinutes']),
      needToKnow: serializer.fromJson<bool>(json['needToKnow']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'learningStageId': serializer.toJson<int>(learningStageId),
      'slug': serializer.toJson<String>(slug),
      'order': serializer.toJson<int>(order),
      'title': serializer.toJson<String>(title),
      'summary': serializer.toJson<String?>(summary),
      'bodyJson': serializer.toJson<String>(bodyJson),
      'estimatedMinutes': serializer.toJson<int>(estimatedMinutes),
      'needToKnow': serializer.toJson<bool>(needToKnow),
    };
  }

  Lesson copyWith({
    int? id,
    int? learningStageId,
    String? slug,
    int? order,
    String? title,
    Value<String?> summary = const Value.absent(),
    String? bodyJson,
    int? estimatedMinutes,
    bool? needToKnow,
  }) => Lesson(
    id: id ?? this.id,
    learningStageId: learningStageId ?? this.learningStageId,
    slug: slug ?? this.slug,
    order: order ?? this.order,
    title: title ?? this.title,
    summary: summary.present ? summary.value : this.summary,
    bodyJson: bodyJson ?? this.bodyJson,
    estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    needToKnow: needToKnow ?? this.needToKnow,
  );
  Lesson copyWithCompanion(LessonsCompanion data) {
    return Lesson(
      id: data.id.present ? data.id.value : this.id,
      learningStageId: data.learningStageId.present
          ? data.learningStageId.value
          : this.learningStageId,
      slug: data.slug.present ? data.slug.value : this.slug,
      order: data.order.present ? data.order.value : this.order,
      title: data.title.present ? data.title.value : this.title,
      summary: data.summary.present ? data.summary.value : this.summary,
      bodyJson: data.bodyJson.present ? data.bodyJson.value : this.bodyJson,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      needToKnow: data.needToKnow.present
          ? data.needToKnow.value
          : this.needToKnow,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Lesson(')
          ..write('id: $id, ')
          ..write('learningStageId: $learningStageId, ')
          ..write('slug: $slug, ')
          ..write('order: $order, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('bodyJson: $bodyJson, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('needToKnow: $needToKnow')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    learningStageId,
    slug,
    order,
    title,
    summary,
    bodyJson,
    estimatedMinutes,
    needToKnow,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Lesson &&
          other.id == this.id &&
          other.learningStageId == this.learningStageId &&
          other.slug == this.slug &&
          other.order == this.order &&
          other.title == this.title &&
          other.summary == this.summary &&
          other.bodyJson == this.bodyJson &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.needToKnow == this.needToKnow);
}

class LessonsCompanion extends UpdateCompanion<Lesson> {
  final Value<int> id;
  final Value<int> learningStageId;
  final Value<String> slug;
  final Value<int> order;
  final Value<String> title;
  final Value<String?> summary;
  final Value<String> bodyJson;
  final Value<int> estimatedMinutes;
  final Value<bool> needToKnow;
  const LessonsCompanion({
    this.id = const Value.absent(),
    this.learningStageId = const Value.absent(),
    this.slug = const Value.absent(),
    this.order = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
    this.bodyJson = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.needToKnow = const Value.absent(),
  });
  LessonsCompanion.insert({
    this.id = const Value.absent(),
    required int learningStageId,
    required String slug,
    required int order,
    required String title,
    this.summary = const Value.absent(),
    required String bodyJson,
    this.estimatedMinutes = const Value.absent(),
    this.needToKnow = const Value.absent(),
  }) : learningStageId = Value(learningStageId),
       slug = Value(slug),
       order = Value(order),
       title = Value(title),
       bodyJson = Value(bodyJson);
  static Insertable<Lesson> custom({
    Expression<int>? id,
    Expression<int>? learningStageId,
    Expression<String>? slug,
    Expression<int>? order,
    Expression<String>? title,
    Expression<String>? summary,
    Expression<String>? bodyJson,
    Expression<int>? estimatedMinutes,
    Expression<bool>? needToKnow,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (learningStageId != null) 'learning_stage_id': learningStageId,
      if (slug != null) 'slug': slug,
      if (order != null) 'order': order,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (bodyJson != null) 'body_json': bodyJson,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (needToKnow != null) 'need_to_know': needToKnow,
    });
  }

  LessonsCompanion copyWith({
    Value<int>? id,
    Value<int>? learningStageId,
    Value<String>? slug,
    Value<int>? order,
    Value<String>? title,
    Value<String?>? summary,
    Value<String>? bodyJson,
    Value<int>? estimatedMinutes,
    Value<bool>? needToKnow,
  }) {
    return LessonsCompanion(
      id: id ?? this.id,
      learningStageId: learningStageId ?? this.learningStageId,
      slug: slug ?? this.slug,
      order: order ?? this.order,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      bodyJson: bodyJson ?? this.bodyJson,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      needToKnow: needToKnow ?? this.needToKnow,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (learningStageId.present) {
      map['learning_stage_id'] = Variable<int>(learningStageId.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (bodyJson.present) {
      map['body_json'] = Variable<String>(bodyJson.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (needToKnow.present) {
      map['need_to_know'] = Variable<bool>(needToKnow.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonsCompanion(')
          ..write('id: $id, ')
          ..write('learningStageId: $learningStageId, ')
          ..write('slug: $slug, ')
          ..write('order: $order, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('bodyJson: $bodyJson, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('needToKnow: $needToKnow')
          ..write(')'))
        .toString();
  }
}

class $LessonProgressEntriesTable extends LessonProgressEntries
    with TableInfo<$LessonProgressEntriesTable, LessonProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('not_started'),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, lessonId, status, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_progress_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {lessonId},
  ];
  @override
  LessonProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonProgressEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $LessonProgressEntriesTable createAlias(String alias) {
    return $LessonProgressEntriesTable(attachedDatabase, alias);
  }
}

class LessonProgressEntry extends DataClass
    implements Insertable<LessonProgressEntry> {
  final int id;
  final int lessonId;

  /// One of: not_started, in_progress, completed.
  final String status;
  final DateTime? completedAt;
  const LessonProgressEntry({
    required this.id,
    required this.lessonId,
    required this.status,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lesson_id'] = Variable<int>(lessonId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  LessonProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return LessonProgressEntriesCompanion(
      id: Value(id),
      lessonId: Value(lessonId),
      status: Value(status),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory LessonProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonProgressEntry(
      id: serializer.fromJson<int>(json['id']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
      status: serializer.fromJson<String>(json['status']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lessonId': serializer.toJson<int>(lessonId),
      'status': serializer.toJson<String>(status),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  LessonProgressEntry copyWith({
    int? id,
    int? lessonId,
    String? status,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => LessonProgressEntry(
    id: id ?? this.id,
    lessonId: lessonId ?? this.lessonId,
    status: status ?? this.status,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  LessonProgressEntry copyWithCompanion(LessonProgressEntriesCompanion data) {
    return LessonProgressEntry(
      id: data.id.present ? data.id.value : this.id,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      status: data.status.present ? data.status.value : this.status,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressEntry(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lessonId, status, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonProgressEntry &&
          other.id == this.id &&
          other.lessonId == this.lessonId &&
          other.status == this.status &&
          other.completedAt == this.completedAt);
}

class LessonProgressEntriesCompanion
    extends UpdateCompanion<LessonProgressEntry> {
  final Value<int> id;
  final Value<int> lessonId;
  final Value<String> status;
  final Value<DateTime?> completedAt;
  const LessonProgressEntriesCompanion({
    this.id = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  LessonProgressEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int lessonId,
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
  }) : lessonId = Value(lessonId);
  static Insertable<LessonProgressEntry> custom({
    Expression<int>? id,
    Expression<int>? lessonId,
    Expression<String>? status,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lessonId != null) 'lesson_id': lessonId,
      if (status != null) 'status': status,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  LessonProgressEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? lessonId,
    Value<String>? status,
    Value<DateTime?>? completedAt,
  }) {
    return LessonProgressEntriesCompanion(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressEntriesCompanion(')
          ..write('id: $id, ')
          ..write('lessonId: $lessonId, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $DuaCategoriesTable extends DuaCategories
    with TableInfo<$DuaCategoriesTable, DuaCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuaCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, slug, title, icon, order];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dua_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<DuaCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DuaCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DuaCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  $DuaCategoriesTable createAlias(String alias) {
    return $DuaCategoriesTable(attachedDatabase, alias);
  }
}

class DuaCategory extends DataClass implements Insertable<DuaCategory> {
  final int id;
  final String slug;
  final String title;
  final String? icon;
  final int order;
  const DuaCategory({
    required this.id,
    required this.slug,
    required this.title,
    this.icon,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['slug'] = Variable<String>(slug);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['order'] = Variable<int>(order);
    return map;
  }

  DuaCategoriesCompanion toCompanion(bool nullToAbsent) {
    return DuaCategoriesCompanion(
      id: Value(id),
      slug: Value(slug),
      title: Value(title),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      order: Value(order),
    );
  }

  factory DuaCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DuaCategory(
      id: serializer.fromJson<int>(json['id']),
      slug: serializer.fromJson<String>(json['slug']),
      title: serializer.fromJson<String>(json['title']),
      icon: serializer.fromJson<String?>(json['icon']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slug': serializer.toJson<String>(slug),
      'title': serializer.toJson<String>(title),
      'icon': serializer.toJson<String?>(icon),
      'order': serializer.toJson<int>(order),
    };
  }

  DuaCategory copyWith({
    int? id,
    String? slug,
    String? title,
    Value<String?> icon = const Value.absent(),
    int? order,
  }) => DuaCategory(
    id: id ?? this.id,
    slug: slug ?? this.slug,
    title: title ?? this.title,
    icon: icon.present ? icon.value : this.icon,
    order: order ?? this.order,
  );
  DuaCategory copyWithCompanion(DuaCategoriesCompanion data) {
    return DuaCategory(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      title: data.title.present ? data.title.value : this.title,
      icon: data.icon.present ? data.icon.value : this.icon,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DuaCategory(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('title: $title, ')
          ..write('icon: $icon, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, slug, title, icon, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DuaCategory &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.title == this.title &&
          other.icon == this.icon &&
          other.order == this.order);
}

class DuaCategoriesCompanion extends UpdateCompanion<DuaCategory> {
  final Value<int> id;
  final Value<String> slug;
  final Value<String> title;
  final Value<String?> icon;
  final Value<int> order;
  const DuaCategoriesCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.title = const Value.absent(),
    this.icon = const Value.absent(),
    this.order = const Value.absent(),
  });
  DuaCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String slug,
    required String title,
    this.icon = const Value.absent(),
    required int order,
  }) : slug = Value(slug),
       title = Value(title),
       order = Value(order);
  static Insertable<DuaCategory> custom({
    Expression<int>? id,
    Expression<String>? slug,
    Expression<String>? title,
    Expression<String>? icon,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (title != null) 'title': title,
      if (icon != null) 'icon': icon,
      if (order != null) 'order': order,
    });
  }

  DuaCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? slug,
    Value<String>? title,
    Value<String?>? icon,
    Value<int>? order,
  }) {
    return DuaCategoriesCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DuaCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('title: $title, ')
          ..write('icon: $icon, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

class $DuasTable extends Duas with TableInfo<$DuasTable, Dua> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DuasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _duaCategoryIdMeta = const VerificationMeta(
    'duaCategoryId',
  );
  @override
  late final GeneratedColumn<int> duaCategoryId = GeneratedColumn<int>(
    'dua_category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _arabicTextMeta = const VerificationMeta(
    'arabicText',
  );
  @override
  late final GeneratedColumn<String> arabicText = GeneratedColumn<String>(
    'arabic_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transliterationMeta = const VerificationMeta(
    'transliteration',
  );
  @override
  late final GeneratedColumn<String> transliteration = GeneratedColumn<String>(
    'transliteration',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authenticityMeta = const VerificationMeta(
    'authenticity',
  );
  @override
  late final GeneratedColumn<String> authenticity = GeneratedColumn<String>(
    'authenticity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('sahih'),
  );
  static const VerificationMeta _benefitsMeta = const VerificationMeta(
    'benefits',
  );
  @override
  late final GeneratedColumn<String> benefits = GeneratedColumn<String>(
    'benefits',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDailyFeaturedMeta = const VerificationMeta(
    'isDailyFeatured',
  );
  @override
  late final GeneratedColumn<bool> isDailyFeatured = GeneratedColumn<bool>(
    'is_daily_featured',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_daily_featured" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    duaCategoryId,
    title,
    arabicText,
    transliteration,
    translation,
    reference,
    authenticity,
    benefits,
    isDailyFeatured,
    order,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'duas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Dua> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('dua_category_id')) {
      context.handle(
        _duaCategoryIdMeta,
        duaCategoryId.isAcceptableOrUnknown(
          data['dua_category_id']!,
          _duaCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_duaCategoryIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('arabic_text')) {
      context.handle(
        _arabicTextMeta,
        arabicText.isAcceptableOrUnknown(data['arabic_text']!, _arabicTextMeta),
      );
    } else if (isInserting) {
      context.missing(_arabicTextMeta);
    }
    if (data.containsKey('transliteration')) {
      context.handle(
        _transliterationMeta,
        transliteration.isAcceptableOrUnknown(
          data['transliteration']!,
          _transliterationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transliterationMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationMeta);
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('authenticity')) {
      context.handle(
        _authenticityMeta,
        authenticity.isAcceptableOrUnknown(
          data['authenticity']!,
          _authenticityMeta,
        ),
      );
    }
    if (data.containsKey('benefits')) {
      context.handle(
        _benefitsMeta,
        benefits.isAcceptableOrUnknown(data['benefits']!, _benefitsMeta),
      );
    }
    if (data.containsKey('is_daily_featured')) {
      context.handle(
        _isDailyFeaturedMeta,
        isDailyFeatured.isAcceptableOrUnknown(
          data['is_daily_featured']!,
          _isDailyFeaturedMeta,
        ),
      );
    }
    if (data.containsKey('order')) {
      context.handle(
        _orderMeta,
        order.isAcceptableOrUnknown(data['order']!, _orderMeta),
      );
    } else if (isInserting) {
      context.missing(_orderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Dua map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Dua(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      duaCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dua_category_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      arabicText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arabic_text'],
      )!,
      transliteration: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transliteration'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      authenticity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}authenticity'],
      )!,
      benefits: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}benefits'],
      ),
      isDailyFeatured: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_daily_featured'],
      )!,
      order: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order'],
      )!,
    );
  }

  @override
  $DuasTable createAlias(String alias) {
    return $DuasTable(attachedDatabase, alias);
  }
}

class Dua extends DataClass implements Insertable<Dua> {
  final int id;
  final int duaCategoryId;
  final String title;
  final String arabicText;
  final String transliteration;
  final String translation;
  final String reference;
  final String authenticity;
  final String? benefits;
  final bool isDailyFeatured;
  final int order;
  const Dua({
    required this.id,
    required this.duaCategoryId,
    required this.title,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.reference,
    required this.authenticity,
    this.benefits,
    required this.isDailyFeatured,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['dua_category_id'] = Variable<int>(duaCategoryId);
    map['title'] = Variable<String>(title);
    map['arabic_text'] = Variable<String>(arabicText);
    map['transliteration'] = Variable<String>(transliteration);
    map['translation'] = Variable<String>(translation);
    map['reference'] = Variable<String>(reference);
    map['authenticity'] = Variable<String>(authenticity);
    if (!nullToAbsent || benefits != null) {
      map['benefits'] = Variable<String>(benefits);
    }
    map['is_daily_featured'] = Variable<bool>(isDailyFeatured);
    map['order'] = Variable<int>(order);
    return map;
  }

  DuasCompanion toCompanion(bool nullToAbsent) {
    return DuasCompanion(
      id: Value(id),
      duaCategoryId: Value(duaCategoryId),
      title: Value(title),
      arabicText: Value(arabicText),
      transliteration: Value(transliteration),
      translation: Value(translation),
      reference: Value(reference),
      authenticity: Value(authenticity),
      benefits: benefits == null && nullToAbsent
          ? const Value.absent()
          : Value(benefits),
      isDailyFeatured: Value(isDailyFeatured),
      order: Value(order),
    );
  }

  factory Dua.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Dua(
      id: serializer.fromJson<int>(json['id']),
      duaCategoryId: serializer.fromJson<int>(json['duaCategoryId']),
      title: serializer.fromJson<String>(json['title']),
      arabicText: serializer.fromJson<String>(json['arabicText']),
      transliteration: serializer.fromJson<String>(json['transliteration']),
      translation: serializer.fromJson<String>(json['translation']),
      reference: serializer.fromJson<String>(json['reference']),
      authenticity: serializer.fromJson<String>(json['authenticity']),
      benefits: serializer.fromJson<String?>(json['benefits']),
      isDailyFeatured: serializer.fromJson<bool>(json['isDailyFeatured']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'duaCategoryId': serializer.toJson<int>(duaCategoryId),
      'title': serializer.toJson<String>(title),
      'arabicText': serializer.toJson<String>(arabicText),
      'transliteration': serializer.toJson<String>(transliteration),
      'translation': serializer.toJson<String>(translation),
      'reference': serializer.toJson<String>(reference),
      'authenticity': serializer.toJson<String>(authenticity),
      'benefits': serializer.toJson<String?>(benefits),
      'isDailyFeatured': serializer.toJson<bool>(isDailyFeatured),
      'order': serializer.toJson<int>(order),
    };
  }

  Dua copyWith({
    int? id,
    int? duaCategoryId,
    String? title,
    String? arabicText,
    String? transliteration,
    String? translation,
    String? reference,
    String? authenticity,
    Value<String?> benefits = const Value.absent(),
    bool? isDailyFeatured,
    int? order,
  }) => Dua(
    id: id ?? this.id,
    duaCategoryId: duaCategoryId ?? this.duaCategoryId,
    title: title ?? this.title,
    arabicText: arabicText ?? this.arabicText,
    transliteration: transliteration ?? this.transliteration,
    translation: translation ?? this.translation,
    reference: reference ?? this.reference,
    authenticity: authenticity ?? this.authenticity,
    benefits: benefits.present ? benefits.value : this.benefits,
    isDailyFeatured: isDailyFeatured ?? this.isDailyFeatured,
    order: order ?? this.order,
  );
  Dua copyWithCompanion(DuasCompanion data) {
    return Dua(
      id: data.id.present ? data.id.value : this.id,
      duaCategoryId: data.duaCategoryId.present
          ? data.duaCategoryId.value
          : this.duaCategoryId,
      title: data.title.present ? data.title.value : this.title,
      arabicText: data.arabicText.present
          ? data.arabicText.value
          : this.arabicText,
      transliteration: data.transliteration.present
          ? data.transliteration.value
          : this.transliteration,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      reference: data.reference.present ? data.reference.value : this.reference,
      authenticity: data.authenticity.present
          ? data.authenticity.value
          : this.authenticity,
      benefits: data.benefits.present ? data.benefits.value : this.benefits,
      isDailyFeatured: data.isDailyFeatured.present
          ? data.isDailyFeatured.value
          : this.isDailyFeatured,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Dua(')
          ..write('id: $id, ')
          ..write('duaCategoryId: $duaCategoryId, ')
          ..write('title: $title, ')
          ..write('arabicText: $arabicText, ')
          ..write('transliteration: $transliteration, ')
          ..write('translation: $translation, ')
          ..write('reference: $reference, ')
          ..write('authenticity: $authenticity, ')
          ..write('benefits: $benefits, ')
          ..write('isDailyFeatured: $isDailyFeatured, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    duaCategoryId,
    title,
    arabicText,
    transliteration,
    translation,
    reference,
    authenticity,
    benefits,
    isDailyFeatured,
    order,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dua &&
          other.id == this.id &&
          other.duaCategoryId == this.duaCategoryId &&
          other.title == this.title &&
          other.arabicText == this.arabicText &&
          other.transliteration == this.transliteration &&
          other.translation == this.translation &&
          other.reference == this.reference &&
          other.authenticity == this.authenticity &&
          other.benefits == this.benefits &&
          other.isDailyFeatured == this.isDailyFeatured &&
          other.order == this.order);
}

class DuasCompanion extends UpdateCompanion<Dua> {
  final Value<int> id;
  final Value<int> duaCategoryId;
  final Value<String> title;
  final Value<String> arabicText;
  final Value<String> transliteration;
  final Value<String> translation;
  final Value<String> reference;
  final Value<String> authenticity;
  final Value<String?> benefits;
  final Value<bool> isDailyFeatured;
  final Value<int> order;
  const DuasCompanion({
    this.id = const Value.absent(),
    this.duaCategoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.arabicText = const Value.absent(),
    this.transliteration = const Value.absent(),
    this.translation = const Value.absent(),
    this.reference = const Value.absent(),
    this.authenticity = const Value.absent(),
    this.benefits = const Value.absent(),
    this.isDailyFeatured = const Value.absent(),
    this.order = const Value.absent(),
  });
  DuasCompanion.insert({
    this.id = const Value.absent(),
    required int duaCategoryId,
    required String title,
    required String arabicText,
    required String transliteration,
    required String translation,
    required String reference,
    this.authenticity = const Value.absent(),
    this.benefits = const Value.absent(),
    this.isDailyFeatured = const Value.absent(),
    required int order,
  }) : duaCategoryId = Value(duaCategoryId),
       title = Value(title),
       arabicText = Value(arabicText),
       transliteration = Value(transliteration),
       translation = Value(translation),
       reference = Value(reference),
       order = Value(order);
  static Insertable<Dua> custom({
    Expression<int>? id,
    Expression<int>? duaCategoryId,
    Expression<String>? title,
    Expression<String>? arabicText,
    Expression<String>? transliteration,
    Expression<String>? translation,
    Expression<String>? reference,
    Expression<String>? authenticity,
    Expression<String>? benefits,
    Expression<bool>? isDailyFeatured,
    Expression<int>? order,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (duaCategoryId != null) 'dua_category_id': duaCategoryId,
      if (title != null) 'title': title,
      if (arabicText != null) 'arabic_text': arabicText,
      if (transliteration != null) 'transliteration': transliteration,
      if (translation != null) 'translation': translation,
      if (reference != null) 'reference': reference,
      if (authenticity != null) 'authenticity': authenticity,
      if (benefits != null) 'benefits': benefits,
      if (isDailyFeatured != null) 'is_daily_featured': isDailyFeatured,
      if (order != null) 'order': order,
    });
  }

  DuasCompanion copyWith({
    Value<int>? id,
    Value<int>? duaCategoryId,
    Value<String>? title,
    Value<String>? arabicText,
    Value<String>? transliteration,
    Value<String>? translation,
    Value<String>? reference,
    Value<String>? authenticity,
    Value<String?>? benefits,
    Value<bool>? isDailyFeatured,
    Value<int>? order,
  }) {
    return DuasCompanion(
      id: id ?? this.id,
      duaCategoryId: duaCategoryId ?? this.duaCategoryId,
      title: title ?? this.title,
      arabicText: arabicText ?? this.arabicText,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      reference: reference ?? this.reference,
      authenticity: authenticity ?? this.authenticity,
      benefits: benefits ?? this.benefits,
      isDailyFeatured: isDailyFeatured ?? this.isDailyFeatured,
      order: order ?? this.order,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (duaCategoryId.present) {
      map['dua_category_id'] = Variable<int>(duaCategoryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (arabicText.present) {
      map['arabic_text'] = Variable<String>(arabicText.value);
    }
    if (transliteration.present) {
      map['transliteration'] = Variable<String>(transliteration.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (authenticity.present) {
      map['authenticity'] = Variable<String>(authenticity.value);
    }
    if (benefits.present) {
      map['benefits'] = Variable<String>(benefits.value);
    }
    if (isDailyFeatured.present) {
      map['is_daily_featured'] = Variable<bool>(isDailyFeatured.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DuasCompanion(')
          ..write('id: $id, ')
          ..write('duaCategoryId: $duaCategoryId, ')
          ..write('title: $title, ')
          ..write('arabicText: $arabicText, ')
          ..write('transliteration: $transliteration, ')
          ..write('translation: $translation, ')
          ..write('reference: $reference, ')
          ..write('authenticity: $authenticity, ')
          ..write('benefits: $benefits, ')
          ..write('isDailyFeatured: $isDailyFeatured, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }
}

class $AiFaqEntriesTable extends AiFaqEntries
    with TableInfo<$AiFaqEntriesTable, AiFaqEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiFaqEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _faqKeyMeta = const VerificationMeta('faqKey');
  @override
  late final GeneratedColumn<String> faqKey = GeneratedColumn<String>(
    'faq_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _canonicalQuestionMeta = const VerificationMeta(
    'canonicalQuestion',
  );
  @override
  late final GeneratedColumn<String> canonicalQuestion =
      GeneratedColumn<String>(
        'canonical_question',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _questionVariantsJsonMeta =
      const VerificationMeta('questionVariantsJson');
  @override
  late final GeneratedColumn<String> questionVariantsJson =
      GeneratedColumn<String>(
        'question_variants_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _keywordsJsonMeta = const VerificationMeta(
    'keywordsJson',
  );
  @override
  late final GeneratedColumn<String> keywordsJson = GeneratedColumn<String>(
    'keywords_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answerTextMeta = const VerificationMeta(
    'answerText',
  );
  @override
  late final GeneratedColumn<String> answerText = GeneratedColumn<String>(
    'answer_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceCitationsJsonMeta =
      const VerificationMeta('sourceCitationsJson');
  @override
  late final GeneratedColumn<String> sourceCitationsJson =
      GeneratedColumn<String>(
        'source_citations_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _confidenceMeta = const VerificationMeta(
    'confidence',
  );
  @override
  late final GeneratedColumn<String> confidence = GeneratedColumn<String>(
    'confidence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requiresScholarDisclaimerMeta =
      const VerificationMeta('requiresScholarDisclaimer');
  @override
  late final GeneratedColumn<bool> requiresScholarDisclaimer =
      GeneratedColumn<bool>(
        'requires_scholar_disclaimer',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("requires_scholar_disclaimer" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    faqKey,
    canonicalQuestion,
    questionVariantsJson,
    keywordsJson,
    category,
    answerText,
    sourceCitationsJson,
    confidence,
    requiresScholarDisclaimer,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_faq_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiFaqEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('faq_key')) {
      context.handle(
        _faqKeyMeta,
        faqKey.isAcceptableOrUnknown(data['faq_key']!, _faqKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_faqKeyMeta);
    }
    if (data.containsKey('canonical_question')) {
      context.handle(
        _canonicalQuestionMeta,
        canonicalQuestion.isAcceptableOrUnknown(
          data['canonical_question']!,
          _canonicalQuestionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_canonicalQuestionMeta);
    }
    if (data.containsKey('question_variants_json')) {
      context.handle(
        _questionVariantsJsonMeta,
        questionVariantsJson.isAcceptableOrUnknown(
          data['question_variants_json']!,
          _questionVariantsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionVariantsJsonMeta);
    }
    if (data.containsKey('keywords_json')) {
      context.handle(
        _keywordsJsonMeta,
        keywordsJson.isAcceptableOrUnknown(
          data['keywords_json']!,
          _keywordsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_keywordsJsonMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('answer_text')) {
      context.handle(
        _answerTextMeta,
        answerText.isAcceptableOrUnknown(data['answer_text']!, _answerTextMeta),
      );
    } else if (isInserting) {
      context.missing(_answerTextMeta);
    }
    if (data.containsKey('source_citations_json')) {
      context.handle(
        _sourceCitationsJsonMeta,
        sourceCitationsJson.isAcceptableOrUnknown(
          data['source_citations_json']!,
          _sourceCitationsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceCitationsJsonMeta);
    }
    if (data.containsKey('confidence')) {
      context.handle(
        _confidenceMeta,
        confidence.isAcceptableOrUnknown(data['confidence']!, _confidenceMeta),
      );
    } else if (isInserting) {
      context.missing(_confidenceMeta);
    }
    if (data.containsKey('requires_scholar_disclaimer')) {
      context.handle(
        _requiresScholarDisclaimerMeta,
        requiresScholarDisclaimer.isAcceptableOrUnknown(
          data['requires_scholar_disclaimer']!,
          _requiresScholarDisclaimerMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiFaqEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiFaqEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      faqKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}faq_key'],
      )!,
      canonicalQuestion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canonical_question'],
      )!,
      questionVariantsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_variants_json'],
      )!,
      keywordsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keywords_json'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      answerText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answer_text'],
      )!,
      sourceCitationsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_citations_json'],
      )!,
      confidence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confidence'],
      )!,
      requiresScholarDisclaimer: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_scholar_disclaimer'],
      )!,
    );
  }

  @override
  $AiFaqEntriesTable createAlias(String alias) {
    return $AiFaqEntriesTable(attachedDatabase, alias);
  }
}

class AiFaqEntry extends DataClass implements Insertable<AiFaqEntry> {
  final int id;
  final String faqKey;
  final String canonicalQuestion;

  /// JSON-encoded array of strings.
  final String questionVariantsJson;

  /// JSON-encoded array of strings.
  final String keywordsJson;
  final String category;
  final String answerText;

  /// JSON-encoded array of {type, id?, collection?, number?, label}.
  final String sourceCitationsJson;

  /// One of: general_guidance, requires_scholar.
  final String confidence;
  final bool requiresScholarDisclaimer;
  const AiFaqEntry({
    required this.id,
    required this.faqKey,
    required this.canonicalQuestion,
    required this.questionVariantsJson,
    required this.keywordsJson,
    required this.category,
    required this.answerText,
    required this.sourceCitationsJson,
    required this.confidence,
    required this.requiresScholarDisclaimer,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['faq_key'] = Variable<String>(faqKey);
    map['canonical_question'] = Variable<String>(canonicalQuestion);
    map['question_variants_json'] = Variable<String>(questionVariantsJson);
    map['keywords_json'] = Variable<String>(keywordsJson);
    map['category'] = Variable<String>(category);
    map['answer_text'] = Variable<String>(answerText);
    map['source_citations_json'] = Variable<String>(sourceCitationsJson);
    map['confidence'] = Variable<String>(confidence);
    map['requires_scholar_disclaimer'] = Variable<bool>(
      requiresScholarDisclaimer,
    );
    return map;
  }

  AiFaqEntriesCompanion toCompanion(bool nullToAbsent) {
    return AiFaqEntriesCompanion(
      id: Value(id),
      faqKey: Value(faqKey),
      canonicalQuestion: Value(canonicalQuestion),
      questionVariantsJson: Value(questionVariantsJson),
      keywordsJson: Value(keywordsJson),
      category: Value(category),
      answerText: Value(answerText),
      sourceCitationsJson: Value(sourceCitationsJson),
      confidence: Value(confidence),
      requiresScholarDisclaimer: Value(requiresScholarDisclaimer),
    );
  }

  factory AiFaqEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiFaqEntry(
      id: serializer.fromJson<int>(json['id']),
      faqKey: serializer.fromJson<String>(json['faqKey']),
      canonicalQuestion: serializer.fromJson<String>(json['canonicalQuestion']),
      questionVariantsJson: serializer.fromJson<String>(
        json['questionVariantsJson'],
      ),
      keywordsJson: serializer.fromJson<String>(json['keywordsJson']),
      category: serializer.fromJson<String>(json['category']),
      answerText: serializer.fromJson<String>(json['answerText']),
      sourceCitationsJson: serializer.fromJson<String>(
        json['sourceCitationsJson'],
      ),
      confidence: serializer.fromJson<String>(json['confidence']),
      requiresScholarDisclaimer: serializer.fromJson<bool>(
        json['requiresScholarDisclaimer'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'faqKey': serializer.toJson<String>(faqKey),
      'canonicalQuestion': serializer.toJson<String>(canonicalQuestion),
      'questionVariantsJson': serializer.toJson<String>(questionVariantsJson),
      'keywordsJson': serializer.toJson<String>(keywordsJson),
      'category': serializer.toJson<String>(category),
      'answerText': serializer.toJson<String>(answerText),
      'sourceCitationsJson': serializer.toJson<String>(sourceCitationsJson),
      'confidence': serializer.toJson<String>(confidence),
      'requiresScholarDisclaimer': serializer.toJson<bool>(
        requiresScholarDisclaimer,
      ),
    };
  }

  AiFaqEntry copyWith({
    int? id,
    String? faqKey,
    String? canonicalQuestion,
    String? questionVariantsJson,
    String? keywordsJson,
    String? category,
    String? answerText,
    String? sourceCitationsJson,
    String? confidence,
    bool? requiresScholarDisclaimer,
  }) => AiFaqEntry(
    id: id ?? this.id,
    faqKey: faqKey ?? this.faqKey,
    canonicalQuestion: canonicalQuestion ?? this.canonicalQuestion,
    questionVariantsJson: questionVariantsJson ?? this.questionVariantsJson,
    keywordsJson: keywordsJson ?? this.keywordsJson,
    category: category ?? this.category,
    answerText: answerText ?? this.answerText,
    sourceCitationsJson: sourceCitationsJson ?? this.sourceCitationsJson,
    confidence: confidence ?? this.confidence,
    requiresScholarDisclaimer:
        requiresScholarDisclaimer ?? this.requiresScholarDisclaimer,
  );
  AiFaqEntry copyWithCompanion(AiFaqEntriesCompanion data) {
    return AiFaqEntry(
      id: data.id.present ? data.id.value : this.id,
      faqKey: data.faqKey.present ? data.faqKey.value : this.faqKey,
      canonicalQuestion: data.canonicalQuestion.present
          ? data.canonicalQuestion.value
          : this.canonicalQuestion,
      questionVariantsJson: data.questionVariantsJson.present
          ? data.questionVariantsJson.value
          : this.questionVariantsJson,
      keywordsJson: data.keywordsJson.present
          ? data.keywordsJson.value
          : this.keywordsJson,
      category: data.category.present ? data.category.value : this.category,
      answerText: data.answerText.present
          ? data.answerText.value
          : this.answerText,
      sourceCitationsJson: data.sourceCitationsJson.present
          ? data.sourceCitationsJson.value
          : this.sourceCitationsJson,
      confidence: data.confidence.present
          ? data.confidence.value
          : this.confidence,
      requiresScholarDisclaimer: data.requiresScholarDisclaimer.present
          ? data.requiresScholarDisclaimer.value
          : this.requiresScholarDisclaimer,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiFaqEntry(')
          ..write('id: $id, ')
          ..write('faqKey: $faqKey, ')
          ..write('canonicalQuestion: $canonicalQuestion, ')
          ..write('questionVariantsJson: $questionVariantsJson, ')
          ..write('keywordsJson: $keywordsJson, ')
          ..write('category: $category, ')
          ..write('answerText: $answerText, ')
          ..write('sourceCitationsJson: $sourceCitationsJson, ')
          ..write('confidence: $confidence, ')
          ..write('requiresScholarDisclaimer: $requiresScholarDisclaimer')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    faqKey,
    canonicalQuestion,
    questionVariantsJson,
    keywordsJson,
    category,
    answerText,
    sourceCitationsJson,
    confidence,
    requiresScholarDisclaimer,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiFaqEntry &&
          other.id == this.id &&
          other.faqKey == this.faqKey &&
          other.canonicalQuestion == this.canonicalQuestion &&
          other.questionVariantsJson == this.questionVariantsJson &&
          other.keywordsJson == this.keywordsJson &&
          other.category == this.category &&
          other.answerText == this.answerText &&
          other.sourceCitationsJson == this.sourceCitationsJson &&
          other.confidence == this.confidence &&
          other.requiresScholarDisclaimer == this.requiresScholarDisclaimer);
}

class AiFaqEntriesCompanion extends UpdateCompanion<AiFaqEntry> {
  final Value<int> id;
  final Value<String> faqKey;
  final Value<String> canonicalQuestion;
  final Value<String> questionVariantsJson;
  final Value<String> keywordsJson;
  final Value<String> category;
  final Value<String> answerText;
  final Value<String> sourceCitationsJson;
  final Value<String> confidence;
  final Value<bool> requiresScholarDisclaimer;
  const AiFaqEntriesCompanion({
    this.id = const Value.absent(),
    this.faqKey = const Value.absent(),
    this.canonicalQuestion = const Value.absent(),
    this.questionVariantsJson = const Value.absent(),
    this.keywordsJson = const Value.absent(),
    this.category = const Value.absent(),
    this.answerText = const Value.absent(),
    this.sourceCitationsJson = const Value.absent(),
    this.confidence = const Value.absent(),
    this.requiresScholarDisclaimer = const Value.absent(),
  });
  AiFaqEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String faqKey,
    required String canonicalQuestion,
    required String questionVariantsJson,
    required String keywordsJson,
    required String category,
    required String answerText,
    required String sourceCitationsJson,
    required String confidence,
    this.requiresScholarDisclaimer = const Value.absent(),
  }) : faqKey = Value(faqKey),
       canonicalQuestion = Value(canonicalQuestion),
       questionVariantsJson = Value(questionVariantsJson),
       keywordsJson = Value(keywordsJson),
       category = Value(category),
       answerText = Value(answerText),
       sourceCitationsJson = Value(sourceCitationsJson),
       confidence = Value(confidence);
  static Insertable<AiFaqEntry> custom({
    Expression<int>? id,
    Expression<String>? faqKey,
    Expression<String>? canonicalQuestion,
    Expression<String>? questionVariantsJson,
    Expression<String>? keywordsJson,
    Expression<String>? category,
    Expression<String>? answerText,
    Expression<String>? sourceCitationsJson,
    Expression<String>? confidence,
    Expression<bool>? requiresScholarDisclaimer,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (faqKey != null) 'faq_key': faqKey,
      if (canonicalQuestion != null) 'canonical_question': canonicalQuestion,
      if (questionVariantsJson != null)
        'question_variants_json': questionVariantsJson,
      if (keywordsJson != null) 'keywords_json': keywordsJson,
      if (category != null) 'category': category,
      if (answerText != null) 'answer_text': answerText,
      if (sourceCitationsJson != null)
        'source_citations_json': sourceCitationsJson,
      if (confidence != null) 'confidence': confidence,
      if (requiresScholarDisclaimer != null)
        'requires_scholar_disclaimer': requiresScholarDisclaimer,
    });
  }

  AiFaqEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? faqKey,
    Value<String>? canonicalQuestion,
    Value<String>? questionVariantsJson,
    Value<String>? keywordsJson,
    Value<String>? category,
    Value<String>? answerText,
    Value<String>? sourceCitationsJson,
    Value<String>? confidence,
    Value<bool>? requiresScholarDisclaimer,
  }) {
    return AiFaqEntriesCompanion(
      id: id ?? this.id,
      faqKey: faqKey ?? this.faqKey,
      canonicalQuestion: canonicalQuestion ?? this.canonicalQuestion,
      questionVariantsJson: questionVariantsJson ?? this.questionVariantsJson,
      keywordsJson: keywordsJson ?? this.keywordsJson,
      category: category ?? this.category,
      answerText: answerText ?? this.answerText,
      sourceCitationsJson: sourceCitationsJson ?? this.sourceCitationsJson,
      confidence: confidence ?? this.confidence,
      requiresScholarDisclaimer:
          requiresScholarDisclaimer ?? this.requiresScholarDisclaimer,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (faqKey.present) {
      map['faq_key'] = Variable<String>(faqKey.value);
    }
    if (canonicalQuestion.present) {
      map['canonical_question'] = Variable<String>(canonicalQuestion.value);
    }
    if (questionVariantsJson.present) {
      map['question_variants_json'] = Variable<String>(
        questionVariantsJson.value,
      );
    }
    if (keywordsJson.present) {
      map['keywords_json'] = Variable<String>(keywordsJson.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (answerText.present) {
      map['answer_text'] = Variable<String>(answerText.value);
    }
    if (sourceCitationsJson.present) {
      map['source_citations_json'] = Variable<String>(
        sourceCitationsJson.value,
      );
    }
    if (confidence.present) {
      map['confidence'] = Variable<String>(confidence.value);
    }
    if (requiresScholarDisclaimer.present) {
      map['requires_scholar_disclaimer'] = Variable<bool>(
        requiresScholarDisclaimer.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiFaqEntriesCompanion(')
          ..write('id: $id, ')
          ..write('faqKey: $faqKey, ')
          ..write('canonicalQuestion: $canonicalQuestion, ')
          ..write('questionVariantsJson: $questionVariantsJson, ')
          ..write('keywordsJson: $keywordsJson, ')
          ..write('category: $category, ')
          ..write('answerText: $answerText, ')
          ..write('sourceCitationsJson: $sourceCitationsJson, ')
          ..write('confidence: $confidence, ')
          ..write('requiresScholarDisclaimer: $requiresScholarDisclaimer')
          ..write(')'))
        .toString();
  }
}

class $OnboardingAnswersTable extends OnboardingAnswers
    with TableInfo<$OnboardingAnswersTable, OnboardingAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OnboardingAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _backgroundTypeMeta = const VerificationMeta(
    'backgroundType',
  );
  @override
  late final GeneratedColumn<String> backgroundType = GeneratedColumn<String>(
    'background_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, backgroundType, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'onboarding_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<OnboardingAnswer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('background_type')) {
      context.handle(
        _backgroundTypeMeta,
        backgroundType.isAcceptableOrUnknown(
          data['background_type']!,
          _backgroundTypeMeta,
        ),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OnboardingAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OnboardingAnswer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      backgroundType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background_type'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $OnboardingAnswersTable createAlias(String alias) {
    return $OnboardingAnswersTable(attachedDatabase, alias);
  }
}

class OnboardingAnswer extends DataClass
    implements Insertable<OnboardingAnswer> {
  final int id;
  final String? backgroundType;
  final DateTime? completedAt;
  const OnboardingAnswer({
    required this.id,
    this.backgroundType,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || backgroundType != null) {
      map['background_type'] = Variable<String>(backgroundType);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  OnboardingAnswersCompanion toCompanion(bool nullToAbsent) {
    return OnboardingAnswersCompanion(
      id: Value(id),
      backgroundType: backgroundType == null && nullToAbsent
          ? const Value.absent()
          : Value(backgroundType),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory OnboardingAnswer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OnboardingAnswer(
      id: serializer.fromJson<int>(json['id']),
      backgroundType: serializer.fromJson<String?>(json['backgroundType']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'backgroundType': serializer.toJson<String?>(backgroundType),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  OnboardingAnswer copyWith({
    int? id,
    Value<String?> backgroundType = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
  }) => OnboardingAnswer(
    id: id ?? this.id,
    backgroundType: backgroundType.present
        ? backgroundType.value
        : this.backgroundType,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  OnboardingAnswer copyWithCompanion(OnboardingAnswersCompanion data) {
    return OnboardingAnswer(
      id: data.id.present ? data.id.value : this.id,
      backgroundType: data.backgroundType.present
          ? data.backgroundType.value
          : this.backgroundType,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingAnswer(')
          ..write('id: $id, ')
          ..write('backgroundType: $backgroundType, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, backgroundType, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnboardingAnswer &&
          other.id == this.id &&
          other.backgroundType == this.backgroundType &&
          other.completedAt == this.completedAt);
}

class OnboardingAnswersCompanion extends UpdateCompanion<OnboardingAnswer> {
  final Value<int> id;
  final Value<String?> backgroundType;
  final Value<DateTime?> completedAt;
  const OnboardingAnswersCompanion({
    this.id = const Value.absent(),
    this.backgroundType = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  OnboardingAnswersCompanion.insert({
    this.id = const Value.absent(),
    this.backgroundType = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  static Insertable<OnboardingAnswer> custom({
    Expression<int>? id,
    Expression<String>? backgroundType,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (backgroundType != null) 'background_type': backgroundType,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  OnboardingAnswersCompanion copyWith({
    Value<int>? id,
    Value<String?>? backgroundType,
    Value<DateTime?>? completedAt,
  }) {
    return OnboardingAnswersCompanion(
      id: id ?? this.id,
      backgroundType: backgroundType ?? this.backgroundType,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (backgroundType.present) {
      map['background_type'] = Variable<String>(backgroundType.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingAnswersCompanion(')
          ..write('id: $id, ')
          ..write('backgroundType: $backgroundType, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $ContentVersionMetaTable extends ContentVersionMeta
    with TableInfo<$ContentVersionMetaTable, ContentVersionMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentVersionMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _importedVersionMeta = const VerificationMeta(
    'importedVersion',
  );
  @override
  late final GeneratedColumn<int> importedVersion = GeneratedColumn<int>(
    'imported_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [contentType, importedVersion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_version_meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentVersionMetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('imported_version')) {
      context.handle(
        _importedVersionMeta,
        importedVersion.isAcceptableOrUnknown(
          data['imported_version']!,
          _importedVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentType};
  @override
  ContentVersionMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentVersionMetaData(
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      importedVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}imported_version'],
      )!,
    );
  }

  @override
  $ContentVersionMetaTable createAlias(String alias) {
    return $ContentVersionMetaTable(attachedDatabase, alias);
  }
}

class ContentVersionMetaData extends DataClass
    implements Insertable<ContentVersionMetaData> {
  final String contentType;
  final int importedVersion;
  const ContentVersionMetaData({
    required this.contentType,
    required this.importedVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_type'] = Variable<String>(contentType);
    map['imported_version'] = Variable<int>(importedVersion);
    return map;
  }

  ContentVersionMetaCompanion toCompanion(bool nullToAbsent) {
    return ContentVersionMetaCompanion(
      contentType: Value(contentType),
      importedVersion: Value(importedVersion),
    );
  }

  factory ContentVersionMetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentVersionMetaData(
      contentType: serializer.fromJson<String>(json['contentType']),
      importedVersion: serializer.fromJson<int>(json['importedVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentType': serializer.toJson<String>(contentType),
      'importedVersion': serializer.toJson<int>(importedVersion),
    };
  }

  ContentVersionMetaData copyWith({
    String? contentType,
    int? importedVersion,
  }) => ContentVersionMetaData(
    contentType: contentType ?? this.contentType,
    importedVersion: importedVersion ?? this.importedVersion,
  );
  ContentVersionMetaData copyWithCompanion(ContentVersionMetaCompanion data) {
    return ContentVersionMetaData(
      contentType: data.contentType.present
          ? data.contentType.value
          : this.contentType,
      importedVersion: data.importedVersion.present
          ? data.importedVersion.value
          : this.importedVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentVersionMetaData(')
          ..write('contentType: $contentType, ')
          ..write('importedVersion: $importedVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(contentType, importedVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentVersionMetaData &&
          other.contentType == this.contentType &&
          other.importedVersion == this.importedVersion);
}

class ContentVersionMetaCompanion
    extends UpdateCompanion<ContentVersionMetaData> {
  final Value<String> contentType;
  final Value<int> importedVersion;
  final Value<int> rowid;
  const ContentVersionMetaCompanion({
    this.contentType = const Value.absent(),
    this.importedVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ContentVersionMetaCompanion.insert({
    required String contentType,
    this.importedVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : contentType = Value(contentType);
  static Insertable<ContentVersionMetaData> custom({
    Expression<String>? contentType,
    Expression<int>? importedVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentType != null) 'content_type': contentType,
      if (importedVersion != null) 'imported_version': importedVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ContentVersionMetaCompanion copyWith({
    Value<String>? contentType,
    Value<int>? importedVersion,
    Value<int>? rowid,
  }) {
    return ContentVersionMetaCompanion(
      contentType: contentType ?? this.contentType,
      importedVersion: importedVersion ?? this.importedVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (importedVersion.present) {
      map['imported_version'] = Variable<int>(importedVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentVersionMetaCompanion(')
          ..write('contentType: $contentType, ')
          ..write('importedVersion: $importedVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalEntriesTable extends JournalEntries
    with TableInfo<$JournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, body, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $JournalEntriesTable createAlias(String alias) {
    return $JournalEntriesTable(attachedDatabase, alias);
  }
}

class JournalEntry extends DataClass implements Insertable<JournalEntry> {
  final int id;
  final String? title;
  final String body;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const JournalEntry({
    required this.id,
    this.title,
    required this.body,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      body: Value(body),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory JournalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntry(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String?>(title),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  JournalEntry copyWith({
    int? id,
    Value<String?> title = const Value.absent(),
    String? body,
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => JournalEntry(
    id: id ?? this.id,
    title: title.present ? title.value : this.title,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  JournalEntry copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, body, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String?> title;
  final Value<String> body;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    required String body,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : body = Value(body);
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  JournalEntriesCompanion copyWith({
    Value<int>? id,
    Value<String?>? title,
    Value<String>? body,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LearningStagesTable learningStages = $LearningStagesTable(this);
  late final $LessonsTable lessons = $LessonsTable(this);
  late final $LessonProgressEntriesTable lessonProgressEntries =
      $LessonProgressEntriesTable(this);
  late final $DuaCategoriesTable duaCategories = $DuaCategoriesTable(this);
  late final $DuasTable duas = $DuasTable(this);
  late final $AiFaqEntriesTable aiFaqEntries = $AiFaqEntriesTable(this);
  late final $OnboardingAnswersTable onboardingAnswers =
      $OnboardingAnswersTable(this);
  late final $ContentVersionMetaTable contentVersionMeta =
      $ContentVersionMetaTable(this);
  late final $JournalEntriesTable journalEntries = $JournalEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    learningStages,
    lessons,
    lessonProgressEntries,
    duaCategories,
    duas,
    aiFaqEntries,
    onboardingAnswers,
    contentVersionMeta,
    journalEntries,
  ];
}

typedef $$LearningStagesTableCreateCompanionBuilder =
    LearningStagesCompanion Function({
      Value<int> id,
      required String slug,
      required int order,
      required String title,
      Value<String?> description,
      Value<String?> icon,
    });
typedef $$LearningStagesTableUpdateCompanionBuilder =
    LearningStagesCompanion Function({
      Value<int> id,
      Value<String> slug,
      Value<int> order,
      Value<String> title,
      Value<String?> description,
      Value<String?> icon,
    });

class $$LearningStagesTableFilterComposer
    extends Composer<_$AppDatabase, $LearningStagesTable> {
  $$LearningStagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LearningStagesTableOrderingComposer
    extends Composer<_$AppDatabase, $LearningStagesTable> {
  $$LearningStagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LearningStagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LearningStagesTable> {
  $$LearningStagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);
}

class $$LearningStagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LearningStagesTable,
          LearningStage,
          $$LearningStagesTableFilterComposer,
          $$LearningStagesTableOrderingComposer,
          $$LearningStagesTableAnnotationComposer,
          $$LearningStagesTableCreateCompanionBuilder,
          $$LearningStagesTableUpdateCompanionBuilder,
          (
            LearningStage,
            BaseReferences<_$AppDatabase, $LearningStagesTable, LearningStage>,
          ),
          LearningStage,
          PrefetchHooks Function()
        > {
  $$LearningStagesTableTableManager(
    _$AppDatabase db,
    $LearningStagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LearningStagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LearningStagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LearningStagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> icon = const Value.absent(),
              }) => LearningStagesCompanion(
                id: id,
                slug: slug,
                order: order,
                title: title,
                description: description,
                icon: icon,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String slug,
                required int order,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> icon = const Value.absent(),
              }) => LearningStagesCompanion.insert(
                id: id,
                slug: slug,
                order: order,
                title: title,
                description: description,
                icon: icon,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LearningStagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LearningStagesTable,
      LearningStage,
      $$LearningStagesTableFilterComposer,
      $$LearningStagesTableOrderingComposer,
      $$LearningStagesTableAnnotationComposer,
      $$LearningStagesTableCreateCompanionBuilder,
      $$LearningStagesTableUpdateCompanionBuilder,
      (
        LearningStage,
        BaseReferences<_$AppDatabase, $LearningStagesTable, LearningStage>,
      ),
      LearningStage,
      PrefetchHooks Function()
    >;
typedef $$LessonsTableCreateCompanionBuilder =
    LessonsCompanion Function({
      Value<int> id,
      required int learningStageId,
      required String slug,
      required int order,
      required String title,
      Value<String?> summary,
      required String bodyJson,
      Value<int> estimatedMinutes,
      Value<bool> needToKnow,
    });
typedef $$LessonsTableUpdateCompanionBuilder =
    LessonsCompanion Function({
      Value<int> id,
      Value<int> learningStageId,
      Value<String> slug,
      Value<int> order,
      Value<String> title,
      Value<String?> summary,
      Value<String> bodyJson,
      Value<int> estimatedMinutes,
      Value<bool> needToKnow,
    });

class $$LessonsTableFilterComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get learningStageId => $composableBuilder(
    column: $table.learningStageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyJson => $composableBuilder(
    column: $table.bodyJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needToKnow => $composableBuilder(
    column: $table.needToKnow,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LessonsTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get learningStageId => $composableBuilder(
    column: $table.learningStageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyJson => $composableBuilder(
    column: $table.bodyJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needToKnow => $composableBuilder(
    column: $table.needToKnow,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LessonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonsTable> {
  $$LessonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get learningStageId => $composableBuilder(
    column: $table.learningStageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get bodyJson =>
      $composableBuilder(column: $table.bodyJson, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needToKnow => $composableBuilder(
    column: $table.needToKnow,
    builder: (column) => column,
  );
}

class $$LessonsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonsTable,
          Lesson,
          $$LessonsTableFilterComposer,
          $$LessonsTableOrderingComposer,
          $$LessonsTableAnnotationComposer,
          $$LessonsTableCreateCompanionBuilder,
          $$LessonsTableUpdateCompanionBuilder,
          (Lesson, BaseReferences<_$AppDatabase, $LessonsTable, Lesson>),
          Lesson,
          PrefetchHooks Function()
        > {
  $$LessonsTableTableManager(_$AppDatabase db, $LessonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LessonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> learningStageId = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> summary = const Value.absent(),
                Value<String> bodyJson = const Value.absent(),
                Value<int> estimatedMinutes = const Value.absent(),
                Value<bool> needToKnow = const Value.absent(),
              }) => LessonsCompanion(
                id: id,
                learningStageId: learningStageId,
                slug: slug,
                order: order,
                title: title,
                summary: summary,
                bodyJson: bodyJson,
                estimatedMinutes: estimatedMinutes,
                needToKnow: needToKnow,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int learningStageId,
                required String slug,
                required int order,
                required String title,
                Value<String?> summary = const Value.absent(),
                required String bodyJson,
                Value<int> estimatedMinutes = const Value.absent(),
                Value<bool> needToKnow = const Value.absent(),
              }) => LessonsCompanion.insert(
                id: id,
                learningStageId: learningStageId,
                slug: slug,
                order: order,
                title: title,
                summary: summary,
                bodyJson: bodyJson,
                estimatedMinutes: estimatedMinutes,
                needToKnow: needToKnow,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LessonsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonsTable,
      Lesson,
      $$LessonsTableFilterComposer,
      $$LessonsTableOrderingComposer,
      $$LessonsTableAnnotationComposer,
      $$LessonsTableCreateCompanionBuilder,
      $$LessonsTableUpdateCompanionBuilder,
      (Lesson, BaseReferences<_$AppDatabase, $LessonsTable, Lesson>),
      Lesson,
      PrefetchHooks Function()
    >;
typedef $$LessonProgressEntriesTableCreateCompanionBuilder =
    LessonProgressEntriesCompanion Function({
      Value<int> id,
      required int lessonId,
      Value<String> status,
      Value<DateTime?> completedAt,
    });
typedef $$LessonProgressEntriesTableUpdateCompanionBuilder =
    LessonProgressEntriesCompanion Function({
      Value<int> id,
      Value<int> lessonId,
      Value<String> status,
      Value<DateTime?> completedAt,
    });

class $$LessonProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LessonProgressEntriesTable> {
  $$LessonProgressEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LessonProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonProgressEntriesTable> {
  $$LessonProgressEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LessonProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonProgressEntriesTable> {
  $$LessonProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$LessonProgressEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonProgressEntriesTable,
          LessonProgressEntry,
          $$LessonProgressEntriesTableFilterComposer,
          $$LessonProgressEntriesTableOrderingComposer,
          $$LessonProgressEntriesTableAnnotationComposer,
          $$LessonProgressEntriesTableCreateCompanionBuilder,
          $$LessonProgressEntriesTableUpdateCompanionBuilder,
          (
            LessonProgressEntry,
            BaseReferences<
              _$AppDatabase,
              $LessonProgressEntriesTable,
              LessonProgressEntry
            >,
          ),
          LessonProgressEntry,
          PrefetchHooks Function()
        > {
  $$LessonProgressEntriesTableTableManager(
    _$AppDatabase db,
    $LessonProgressEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonProgressEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$LessonProgressEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LessonProgressEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => LessonProgressEntriesCompanion(
                id: id,
                lessonId: lessonId,
                status: status,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int lessonId,
                Value<String> status = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => LessonProgressEntriesCompanion.insert(
                id: id,
                lessonId: lessonId,
                status: status,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LessonProgressEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonProgressEntriesTable,
      LessonProgressEntry,
      $$LessonProgressEntriesTableFilterComposer,
      $$LessonProgressEntriesTableOrderingComposer,
      $$LessonProgressEntriesTableAnnotationComposer,
      $$LessonProgressEntriesTableCreateCompanionBuilder,
      $$LessonProgressEntriesTableUpdateCompanionBuilder,
      (
        LessonProgressEntry,
        BaseReferences<
          _$AppDatabase,
          $LessonProgressEntriesTable,
          LessonProgressEntry
        >,
      ),
      LessonProgressEntry,
      PrefetchHooks Function()
    >;
typedef $$DuaCategoriesTableCreateCompanionBuilder =
    DuaCategoriesCompanion Function({
      Value<int> id,
      required String slug,
      required String title,
      Value<String?> icon,
      required int order,
    });
typedef $$DuaCategoriesTableUpdateCompanionBuilder =
    DuaCategoriesCompanion Function({
      Value<int> id,
      Value<String> slug,
      Value<String> title,
      Value<String?> icon,
      Value<int> order,
    });

class $$DuaCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $DuaCategoriesTable> {
  $$DuaCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DuaCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DuaCategoriesTable> {
  $$DuaCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DuaCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DuaCategoriesTable> {
  $$DuaCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);
}

class $$DuaCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DuaCategoriesTable,
          DuaCategory,
          $$DuaCategoriesTableFilterComposer,
          $$DuaCategoriesTableOrderingComposer,
          $$DuaCategoriesTableAnnotationComposer,
          $$DuaCategoriesTableCreateCompanionBuilder,
          $$DuaCategoriesTableUpdateCompanionBuilder,
          (
            DuaCategory,
            BaseReferences<_$AppDatabase, $DuaCategoriesTable, DuaCategory>,
          ),
          DuaCategory,
          PrefetchHooks Function()
        > {
  $$DuaCategoriesTableTableManager(_$AppDatabase db, $DuaCategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DuaCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DuaCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DuaCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> order = const Value.absent(),
              }) => DuaCategoriesCompanion(
                id: id,
                slug: slug,
                title: title,
                icon: icon,
                order: order,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String slug,
                required String title,
                Value<String?> icon = const Value.absent(),
                required int order,
              }) => DuaCategoriesCompanion.insert(
                id: id,
                slug: slug,
                title: title,
                icon: icon,
                order: order,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DuaCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DuaCategoriesTable,
      DuaCategory,
      $$DuaCategoriesTableFilterComposer,
      $$DuaCategoriesTableOrderingComposer,
      $$DuaCategoriesTableAnnotationComposer,
      $$DuaCategoriesTableCreateCompanionBuilder,
      $$DuaCategoriesTableUpdateCompanionBuilder,
      (
        DuaCategory,
        BaseReferences<_$AppDatabase, $DuaCategoriesTable, DuaCategory>,
      ),
      DuaCategory,
      PrefetchHooks Function()
    >;
typedef $$DuasTableCreateCompanionBuilder =
    DuasCompanion Function({
      Value<int> id,
      required int duaCategoryId,
      required String title,
      required String arabicText,
      required String transliteration,
      required String translation,
      required String reference,
      Value<String> authenticity,
      Value<String?> benefits,
      Value<bool> isDailyFeatured,
      required int order,
    });
typedef $$DuasTableUpdateCompanionBuilder =
    DuasCompanion Function({
      Value<int> id,
      Value<int> duaCategoryId,
      Value<String> title,
      Value<String> arabicText,
      Value<String> transliteration,
      Value<String> translation,
      Value<String> reference,
      Value<String> authenticity,
      Value<String?> benefits,
      Value<bool> isDailyFeatured,
      Value<int> order,
    });

class $$DuasTableFilterComposer extends Composer<_$AppDatabase, $DuasTable> {
  $$DuasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get duaCategoryId => $composableBuilder(
    column: $table.duaCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authenticity => $composableBuilder(
    column: $table.authenticity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get benefits => $composableBuilder(
    column: $table.benefits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDailyFeatured => $composableBuilder(
    column: $table.isDailyFeatured,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DuasTableOrderingComposer extends Composer<_$AppDatabase, $DuasTable> {
  $$DuasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get duaCategoryId => $composableBuilder(
    column: $table.duaCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authenticity => $composableBuilder(
    column: $table.authenticity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get benefits => $composableBuilder(
    column: $table.benefits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDailyFeatured => $composableBuilder(
    column: $table.isDailyFeatured,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get order => $composableBuilder(
    column: $table.order,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DuasTableAnnotationComposer
    extends Composer<_$AppDatabase, $DuasTable> {
  $$DuasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get duaCategoryId => $composableBuilder(
    column: $table.duaCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get arabicText => $composableBuilder(
    column: $table.arabicText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transliteration => $composableBuilder(
    column: $table.transliteration,
    builder: (column) => column,
  );

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get authenticity => $composableBuilder(
    column: $table.authenticity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get benefits =>
      $composableBuilder(column: $table.benefits, builder: (column) => column);

  GeneratedColumn<bool> get isDailyFeatured => $composableBuilder(
    column: $table.isDailyFeatured,
    builder: (column) => column,
  );

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);
}

class $$DuasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DuasTable,
          Dua,
          $$DuasTableFilterComposer,
          $$DuasTableOrderingComposer,
          $$DuasTableAnnotationComposer,
          $$DuasTableCreateCompanionBuilder,
          $$DuasTableUpdateCompanionBuilder,
          (Dua, BaseReferences<_$AppDatabase, $DuasTable, Dua>),
          Dua,
          PrefetchHooks Function()
        > {
  $$DuasTableTableManager(_$AppDatabase db, $DuasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DuasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DuasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DuasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> duaCategoryId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> arabicText = const Value.absent(),
                Value<String> transliteration = const Value.absent(),
                Value<String> translation = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<String> authenticity = const Value.absent(),
                Value<String?> benefits = const Value.absent(),
                Value<bool> isDailyFeatured = const Value.absent(),
                Value<int> order = const Value.absent(),
              }) => DuasCompanion(
                id: id,
                duaCategoryId: duaCategoryId,
                title: title,
                arabicText: arabicText,
                transliteration: transliteration,
                translation: translation,
                reference: reference,
                authenticity: authenticity,
                benefits: benefits,
                isDailyFeatured: isDailyFeatured,
                order: order,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int duaCategoryId,
                required String title,
                required String arabicText,
                required String transliteration,
                required String translation,
                required String reference,
                Value<String> authenticity = const Value.absent(),
                Value<String?> benefits = const Value.absent(),
                Value<bool> isDailyFeatured = const Value.absent(),
                required int order,
              }) => DuasCompanion.insert(
                id: id,
                duaCategoryId: duaCategoryId,
                title: title,
                arabicText: arabicText,
                transliteration: transliteration,
                translation: translation,
                reference: reference,
                authenticity: authenticity,
                benefits: benefits,
                isDailyFeatured: isDailyFeatured,
                order: order,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DuasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DuasTable,
      Dua,
      $$DuasTableFilterComposer,
      $$DuasTableOrderingComposer,
      $$DuasTableAnnotationComposer,
      $$DuasTableCreateCompanionBuilder,
      $$DuasTableUpdateCompanionBuilder,
      (Dua, BaseReferences<_$AppDatabase, $DuasTable, Dua>),
      Dua,
      PrefetchHooks Function()
    >;
typedef $$AiFaqEntriesTableCreateCompanionBuilder =
    AiFaqEntriesCompanion Function({
      Value<int> id,
      required String faqKey,
      required String canonicalQuestion,
      required String questionVariantsJson,
      required String keywordsJson,
      required String category,
      required String answerText,
      required String sourceCitationsJson,
      required String confidence,
      Value<bool> requiresScholarDisclaimer,
    });
typedef $$AiFaqEntriesTableUpdateCompanionBuilder =
    AiFaqEntriesCompanion Function({
      Value<int> id,
      Value<String> faqKey,
      Value<String> canonicalQuestion,
      Value<String> questionVariantsJson,
      Value<String> keywordsJson,
      Value<String> category,
      Value<String> answerText,
      Value<String> sourceCitationsJson,
      Value<String> confidence,
      Value<bool> requiresScholarDisclaimer,
    });

class $$AiFaqEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AiFaqEntriesTable> {
  $$AiFaqEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get faqKey => $composableBuilder(
    column: $table.faqKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonicalQuestion => $composableBuilder(
    column: $table.canonicalQuestion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionVariantsJson => $composableBuilder(
    column: $table.questionVariantsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keywordsJson => $composableBuilder(
    column: $table.keywordsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answerText => $composableBuilder(
    column: $table.answerText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceCitationsJson => $composableBuilder(
    column: $table.sourceCitationsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresScholarDisclaimer => $composableBuilder(
    column: $table.requiresScholarDisclaimer,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AiFaqEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AiFaqEntriesTable> {
  $$AiFaqEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get faqKey => $composableBuilder(
    column: $table.faqKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonicalQuestion => $composableBuilder(
    column: $table.canonicalQuestion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionVariantsJson => $composableBuilder(
    column: $table.questionVariantsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keywordsJson => $composableBuilder(
    column: $table.keywordsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answerText => $composableBuilder(
    column: $table.answerText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceCitationsJson => $composableBuilder(
    column: $table.sourceCitationsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresScholarDisclaimer => $composableBuilder(
    column: $table.requiresScholarDisclaimer,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AiFaqEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AiFaqEntriesTable> {
  $$AiFaqEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get faqKey =>
      $composableBuilder(column: $table.faqKey, builder: (column) => column);

  GeneratedColumn<String> get canonicalQuestion => $composableBuilder(
    column: $table.canonicalQuestion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionVariantsJson => $composableBuilder(
    column: $table.questionVariantsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get keywordsJson => $composableBuilder(
    column: $table.keywordsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get answerText => $composableBuilder(
    column: $table.answerText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceCitationsJson => $composableBuilder(
    column: $table.sourceCitationsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get confidence => $composableBuilder(
    column: $table.confidence,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get requiresScholarDisclaimer => $composableBuilder(
    column: $table.requiresScholarDisclaimer,
    builder: (column) => column,
  );
}

class $$AiFaqEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AiFaqEntriesTable,
          AiFaqEntry,
          $$AiFaqEntriesTableFilterComposer,
          $$AiFaqEntriesTableOrderingComposer,
          $$AiFaqEntriesTableAnnotationComposer,
          $$AiFaqEntriesTableCreateCompanionBuilder,
          $$AiFaqEntriesTableUpdateCompanionBuilder,
          (
            AiFaqEntry,
            BaseReferences<_$AppDatabase, $AiFaqEntriesTable, AiFaqEntry>,
          ),
          AiFaqEntry,
          PrefetchHooks Function()
        > {
  $$AiFaqEntriesTableTableManager(_$AppDatabase db, $AiFaqEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AiFaqEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AiFaqEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AiFaqEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> faqKey = const Value.absent(),
                Value<String> canonicalQuestion = const Value.absent(),
                Value<String> questionVariantsJson = const Value.absent(),
                Value<String> keywordsJson = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> answerText = const Value.absent(),
                Value<String> sourceCitationsJson = const Value.absent(),
                Value<String> confidence = const Value.absent(),
                Value<bool> requiresScholarDisclaimer = const Value.absent(),
              }) => AiFaqEntriesCompanion(
                id: id,
                faqKey: faqKey,
                canonicalQuestion: canonicalQuestion,
                questionVariantsJson: questionVariantsJson,
                keywordsJson: keywordsJson,
                category: category,
                answerText: answerText,
                sourceCitationsJson: sourceCitationsJson,
                confidence: confidence,
                requiresScholarDisclaimer: requiresScholarDisclaimer,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String faqKey,
                required String canonicalQuestion,
                required String questionVariantsJson,
                required String keywordsJson,
                required String category,
                required String answerText,
                required String sourceCitationsJson,
                required String confidence,
                Value<bool> requiresScholarDisclaimer = const Value.absent(),
              }) => AiFaqEntriesCompanion.insert(
                id: id,
                faqKey: faqKey,
                canonicalQuestion: canonicalQuestion,
                questionVariantsJson: questionVariantsJson,
                keywordsJson: keywordsJson,
                category: category,
                answerText: answerText,
                sourceCitationsJson: sourceCitationsJson,
                confidence: confidence,
                requiresScholarDisclaimer: requiresScholarDisclaimer,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AiFaqEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AiFaqEntriesTable,
      AiFaqEntry,
      $$AiFaqEntriesTableFilterComposer,
      $$AiFaqEntriesTableOrderingComposer,
      $$AiFaqEntriesTableAnnotationComposer,
      $$AiFaqEntriesTableCreateCompanionBuilder,
      $$AiFaqEntriesTableUpdateCompanionBuilder,
      (
        AiFaqEntry,
        BaseReferences<_$AppDatabase, $AiFaqEntriesTable, AiFaqEntry>,
      ),
      AiFaqEntry,
      PrefetchHooks Function()
    >;
typedef $$OnboardingAnswersTableCreateCompanionBuilder =
    OnboardingAnswersCompanion Function({
      Value<int> id,
      Value<String?> backgroundType,
      Value<DateTime?> completedAt,
    });
typedef $$OnboardingAnswersTableUpdateCompanionBuilder =
    OnboardingAnswersCompanion Function({
      Value<int> id,
      Value<String?> backgroundType,
      Value<DateTime?> completedAt,
    });

class $$OnboardingAnswersTableFilterComposer
    extends Composer<_$AppDatabase, $OnboardingAnswersTable> {
  $$OnboardingAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backgroundType => $composableBuilder(
    column: $table.backgroundType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OnboardingAnswersTableOrderingComposer
    extends Composer<_$AppDatabase, $OnboardingAnswersTable> {
  $$OnboardingAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backgroundType => $composableBuilder(
    column: $table.backgroundType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OnboardingAnswersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OnboardingAnswersTable> {
  $$OnboardingAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get backgroundType => $composableBuilder(
    column: $table.backgroundType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$OnboardingAnswersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OnboardingAnswersTable,
          OnboardingAnswer,
          $$OnboardingAnswersTableFilterComposer,
          $$OnboardingAnswersTableOrderingComposer,
          $$OnboardingAnswersTableAnnotationComposer,
          $$OnboardingAnswersTableCreateCompanionBuilder,
          $$OnboardingAnswersTableUpdateCompanionBuilder,
          (
            OnboardingAnswer,
            BaseReferences<
              _$AppDatabase,
              $OnboardingAnswersTable,
              OnboardingAnswer
            >,
          ),
          OnboardingAnswer,
          PrefetchHooks Function()
        > {
  $$OnboardingAnswersTableTableManager(
    _$AppDatabase db,
    $OnboardingAnswersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OnboardingAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OnboardingAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OnboardingAnswersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> backgroundType = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => OnboardingAnswersCompanion(
                id: id,
                backgroundType: backgroundType,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> backgroundType = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
              }) => OnboardingAnswersCompanion.insert(
                id: id,
                backgroundType: backgroundType,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OnboardingAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OnboardingAnswersTable,
      OnboardingAnswer,
      $$OnboardingAnswersTableFilterComposer,
      $$OnboardingAnswersTableOrderingComposer,
      $$OnboardingAnswersTableAnnotationComposer,
      $$OnboardingAnswersTableCreateCompanionBuilder,
      $$OnboardingAnswersTableUpdateCompanionBuilder,
      (
        OnboardingAnswer,
        BaseReferences<
          _$AppDatabase,
          $OnboardingAnswersTable,
          OnboardingAnswer
        >,
      ),
      OnboardingAnswer,
      PrefetchHooks Function()
    >;
typedef $$ContentVersionMetaTableCreateCompanionBuilder =
    ContentVersionMetaCompanion Function({
      required String contentType,
      Value<int> importedVersion,
      Value<int> rowid,
    });
typedef $$ContentVersionMetaTableUpdateCompanionBuilder =
    ContentVersionMetaCompanion Function({
      Value<String> contentType,
      Value<int> importedVersion,
      Value<int> rowid,
    });

class $$ContentVersionMetaTableFilterComposer
    extends Composer<_$AppDatabase, $ContentVersionMetaTable> {
  $$ContentVersionMetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get importedVersion => $composableBuilder(
    column: $table.importedVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentVersionMetaTableOrderingComposer
    extends Composer<_$AppDatabase, $ContentVersionMetaTable> {
  $$ContentVersionMetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get importedVersion => $composableBuilder(
    column: $table.importedVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentVersionMetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $ContentVersionMetaTable> {
  $$ContentVersionMetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get importedVersion => $composableBuilder(
    column: $table.importedVersion,
    builder: (column) => column,
  );
}

class $$ContentVersionMetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ContentVersionMetaTable,
          ContentVersionMetaData,
          $$ContentVersionMetaTableFilterComposer,
          $$ContentVersionMetaTableOrderingComposer,
          $$ContentVersionMetaTableAnnotationComposer,
          $$ContentVersionMetaTableCreateCompanionBuilder,
          $$ContentVersionMetaTableUpdateCompanionBuilder,
          (
            ContentVersionMetaData,
            BaseReferences<
              _$AppDatabase,
              $ContentVersionMetaTable,
              ContentVersionMetaData
            >,
          ),
          ContentVersionMetaData,
          PrefetchHooks Function()
        > {
  $$ContentVersionMetaTableTableManager(
    _$AppDatabase db,
    $ContentVersionMetaTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentVersionMetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentVersionMetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentVersionMetaTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> contentType = const Value.absent(),
                Value<int> importedVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentVersionMetaCompanion(
                contentType: contentType,
                importedVersion: importedVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentType,
                Value<int> importedVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ContentVersionMetaCompanion.insert(
                contentType: contentType,
                importedVersion: importedVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentVersionMetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ContentVersionMetaTable,
      ContentVersionMetaData,
      $$ContentVersionMetaTableFilterComposer,
      $$ContentVersionMetaTableOrderingComposer,
      $$ContentVersionMetaTableAnnotationComposer,
      $$ContentVersionMetaTableCreateCompanionBuilder,
      $$ContentVersionMetaTableUpdateCompanionBuilder,
      (
        ContentVersionMetaData,
        BaseReferences<
          _$AppDatabase,
          $ContentVersionMetaTable,
          ContentVersionMetaData
        >,
      ),
      ContentVersionMetaData,
      PrefetchHooks Function()
    >;
typedef $$JournalEntriesTableCreateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      Value<String?> title,
      required String body,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$JournalEntriesTableUpdateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<int> id,
      Value<String?> title,
      Value<String> body,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $$JournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalEntriesTable> {
  $$JournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$JournalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalEntriesTable,
          JournalEntry,
          $$JournalEntriesTableFilterComposer,
          $$JournalEntriesTableOrderingComposer,
          $$JournalEntriesTableAnnotationComposer,
          $$JournalEntriesTableCreateCompanionBuilder,
          $$JournalEntriesTableUpdateCompanionBuilder,
          (
            JournalEntry,
            BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>,
          ),
          JournalEntry,
          PrefetchHooks Function()
        > {
  $$JournalEntriesTableTableManager(
    _$AppDatabase db,
    $JournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => JournalEntriesCompanion(
                id: id,
                title: title,
                body: body,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> title = const Value.absent(),
                required String body,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => JournalEntriesCompanion.insert(
                id: id,
                title: title,
                body: body,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalEntriesTable,
      JournalEntry,
      $$JournalEntriesTableFilterComposer,
      $$JournalEntriesTableOrderingComposer,
      $$JournalEntriesTableAnnotationComposer,
      $$JournalEntriesTableCreateCompanionBuilder,
      $$JournalEntriesTableUpdateCompanionBuilder,
      (
        JournalEntry,
        BaseReferences<_$AppDatabase, $JournalEntriesTable, JournalEntry>,
      ),
      JournalEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LearningStagesTableTableManager get learningStages =>
      $$LearningStagesTableTableManager(_db, _db.learningStages);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db, _db.lessons);
  $$LessonProgressEntriesTableTableManager get lessonProgressEntries =>
      $$LessonProgressEntriesTableTableManager(_db, _db.lessonProgressEntries);
  $$DuaCategoriesTableTableManager get duaCategories =>
      $$DuaCategoriesTableTableManager(_db, _db.duaCategories);
  $$DuasTableTableManager get duas => $$DuasTableTableManager(_db, _db.duas);
  $$AiFaqEntriesTableTableManager get aiFaqEntries =>
      $$AiFaqEntriesTableTableManager(_db, _db.aiFaqEntries);
  $$OnboardingAnswersTableTableManager get onboardingAnswers =>
      $$OnboardingAnswersTableTableManager(_db, _db.onboardingAnswers);
  $$ContentVersionMetaTableTableManager get contentVersionMeta =>
      $$ContentVersionMetaTableTableManager(_db, _db.contentVersionMeta);
  $$JournalEntriesTableTableManager get journalEntries =>
      $$JournalEntriesTableTableManager(_db, _db.journalEntries);
}
