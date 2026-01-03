// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $NotebooksTable extends Notebooks
    with TableInfo<$NotebooksTable, Notebook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotebooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, title, icon, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notebooks';
  @override
  VerificationContext validateIntegrity(Insertable<Notebook> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Notebook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Notebook(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color']),
    );
  }

  @override
  $NotebooksTable createAlias(String alias) {
    return $NotebooksTable(attachedDatabase, alias);
  }
}

class Notebook extends DataClass implements Insertable<Notebook> {
  final int id;
  final String title;
  final String icon;
  final int? color;
  const Notebook(
      {required this.id, required this.title, required this.icon, this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['icon'] = Variable<String>(icon);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    return map;
  }

  NotebooksCompanion toCompanion(bool nullToAbsent) {
    return NotebooksCompanion(
      id: Value(id),
      title: Value(title),
      icon: Value(icon),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
    );
  }

  factory Notebook.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Notebook(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int?>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int?>(color),
    };
  }

  Notebook copyWith(
          {int? id,
          String? title,
          String? icon,
          Value<int?> color = const Value.absent()}) =>
      Notebook(
        id: id ?? this.id,
        title: title ?? this.title,
        icon: icon ?? this.icon,
        color: color.present ? color.value : this.color,
      );
  Notebook copyWithCompanion(NotebooksCompanion data) {
    return Notebook(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Notebook(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('icon: $icon, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, icon, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Notebook &&
          other.id == this.id &&
          other.title == this.title &&
          other.icon == this.icon &&
          other.color == this.color);
}

class NotebooksCompanion extends UpdateCompanion<Notebook> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> icon;
  final Value<int?> color;
  const NotebooksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
  });
  NotebooksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String icon,
    this.color = const Value.absent(),
  })  : title = Value(title),
        icon = Value(icon);
  static Insertable<Notebook> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? icon,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
    });
  }

  NotebooksCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? icon,
      Value<int?>? color}) {
    return NotebooksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      color: color ?? this.color,
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
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotebooksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('icon: $icon, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $DiariesTable extends Diaries with TableInfo<$DiariesTable, Diary> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, date, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diaries';
  @override
  VerificationContext validateIntegrity(Insertable<Diary> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Diary map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Diary(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
    );
  }

  @override
  $DiariesTable createAlias(String alias) {
    return $DiariesTable(attachedDatabase, alias);
  }
}

class Diary extends DataClass implements Insertable<Diary> {
  final int id;
  final DateTime date;
  final String content;
  const Diary({required this.id, required this.date, required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['content'] = Variable<String>(content);
    return map;
  }

  DiariesCompanion toCompanion(bool nullToAbsent) {
    return DiariesCompanion(
      id: Value(id),
      date: Value(date),
      content: Value(content),
    );
  }

  factory Diary.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Diary(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'content': serializer.toJson<String>(content),
    };
  }

  Diary copyWith({int? id, DateTime? date, String? content}) => Diary(
        id: id ?? this.id,
        date: date ?? this.date,
        content: content ?? this.content,
      );
  Diary copyWithCompanion(DiariesCompanion data) {
    return Diary(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Diary(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Diary &&
          other.id == this.id &&
          other.date == this.date &&
          other.content == this.content);
}

class DiariesCompanion extends UpdateCompanion<Diary> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> content;
  const DiariesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.content = const Value.absent(),
  });
  DiariesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String content,
  })  : date = Value(date),
        content = Value(content);
  static Insertable<Diary> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (content != null) 'content': content,
    });
  }

  DiariesCompanion copyWith(
      {Value<int>? id, Value<DateTime>? date, Value<String>? content}) {
    return DiariesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiariesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

class $DiaryImagesTable extends DiaryImages
    with TableInfo<$DiaryImagesTable, DiaryImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _diaryIdMeta =
      const VerificationMeta('diaryId');
  @override
  late final GeneratedColumn<int> diaryId = GeneratedColumn<int>(
      'diary_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES diaries (id)'));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isLandscapeMeta =
      const VerificationMeta('isLandscape');
  @override
  late final GeneratedColumn<bool> isLandscape = GeneratedColumn<bool>(
      'is_landscape', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_landscape" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, diaryId, imagePath, isLandscape];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_images';
  @override
  VerificationContext validateIntegrity(Insertable<DiaryImage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('diary_id')) {
      context.handle(_diaryIdMeta,
          diaryId.isAcceptableOrUnknown(data['diary_id']!, _diaryIdMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('is_landscape')) {
      context.handle(
          _isLandscapeMeta,
          isLandscape.isAcceptableOrUnknown(
              data['is_landscape']!, _isLandscapeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryImage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      diaryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}diary_id']),
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path'])!,
      isLandscape: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_landscape']),
    );
  }

  @override
  $DiaryImagesTable createAlias(String alias) {
    return $DiaryImagesTable(attachedDatabase, alias);
  }
}

class DiaryImage extends DataClass implements Insertable<DiaryImage> {
  final int id;
  final int? diaryId;
  final String imagePath;
  final bool? isLandscape;
  const DiaryImage(
      {required this.id,
      this.diaryId,
      required this.imagePath,
      this.isLandscape});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || diaryId != null) {
      map['diary_id'] = Variable<int>(diaryId);
    }
    map['image_path'] = Variable<String>(imagePath);
    if (!nullToAbsent || isLandscape != null) {
      map['is_landscape'] = Variable<bool>(isLandscape);
    }
    return map;
  }

  DiaryImagesCompanion toCompanion(bool nullToAbsent) {
    return DiaryImagesCompanion(
      id: Value(id),
      diaryId: diaryId == null && nullToAbsent
          ? const Value.absent()
          : Value(diaryId),
      imagePath: Value(imagePath),
      isLandscape: isLandscape == null && nullToAbsent
          ? const Value.absent()
          : Value(isLandscape),
    );
  }

  factory DiaryImage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryImage(
      id: serializer.fromJson<int>(json['id']),
      diaryId: serializer.fromJson<int?>(json['diaryId']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      isLandscape: serializer.fromJson<bool?>(json['isLandscape']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'diaryId': serializer.toJson<int?>(diaryId),
      'imagePath': serializer.toJson<String>(imagePath),
      'isLandscape': serializer.toJson<bool?>(isLandscape),
    };
  }

  DiaryImage copyWith(
          {int? id,
          Value<int?> diaryId = const Value.absent(),
          String? imagePath,
          Value<bool?> isLandscape = const Value.absent()}) =>
      DiaryImage(
        id: id ?? this.id,
        diaryId: diaryId.present ? diaryId.value : this.diaryId,
        imagePath: imagePath ?? this.imagePath,
        isLandscape: isLandscape.present ? isLandscape.value : this.isLandscape,
      );
  DiaryImage copyWithCompanion(DiaryImagesCompanion data) {
    return DiaryImage(
      id: data.id.present ? data.id.value : this.id,
      diaryId: data.diaryId.present ? data.diaryId.value : this.diaryId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      isLandscape:
          data.isLandscape.present ? data.isLandscape.value : this.isLandscape,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryImage(')
          ..write('id: $id, ')
          ..write('diaryId: $diaryId, ')
          ..write('imagePath: $imagePath, ')
          ..write('isLandscape: $isLandscape')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, diaryId, imagePath, isLandscape);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryImage &&
          other.id == this.id &&
          other.diaryId == this.diaryId &&
          other.imagePath == this.imagePath &&
          other.isLandscape == this.isLandscape);
}

class DiaryImagesCompanion extends UpdateCompanion<DiaryImage> {
  final Value<int> id;
  final Value<int?> diaryId;
  final Value<String> imagePath;
  final Value<bool?> isLandscape;
  const DiaryImagesCompanion({
    this.id = const Value.absent(),
    this.diaryId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.isLandscape = const Value.absent(),
  });
  DiaryImagesCompanion.insert({
    this.id = const Value.absent(),
    this.diaryId = const Value.absent(),
    required String imagePath,
    this.isLandscape = const Value.absent(),
  }) : imagePath = Value(imagePath);
  static Insertable<DiaryImage> custom({
    Expression<int>? id,
    Expression<int>? diaryId,
    Expression<String>? imagePath,
    Expression<bool>? isLandscape,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (diaryId != null) 'diary_id': diaryId,
      if (imagePath != null) 'image_path': imagePath,
      if (isLandscape != null) 'is_landscape': isLandscape,
    });
  }

  DiaryImagesCompanion copyWith(
      {Value<int>? id,
      Value<int?>? diaryId,
      Value<String>? imagePath,
      Value<bool?>? isLandscape}) {
    return DiaryImagesCompanion(
      id: id ?? this.id,
      diaryId: diaryId ?? this.diaryId,
      imagePath: imagePath ?? this.imagePath,
      isLandscape: isLandscape ?? this.isLandscape,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (diaryId.present) {
      map['diary_id'] = Variable<int>(diaryId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (isLandscape.present) {
      map['is_landscape'] = Variable<bool>(isLandscape.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryImagesCompanion(')
          ..write('id: $id, ')
          ..write('diaryId: $diaryId, ')
          ..write('imagePath: $imagePath, ')
          ..write('isLandscape: $isLandscape')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _diaryIdMeta =
      const VerificationMeta('diaryId');
  @override
  late final GeneratedColumn<int> diaryId = GeneratedColumn<int>(
      'diary_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES diaries (id)'));
  static const VerificationMeta _parentTaskIdMeta =
      const VerificationMeta('parentTaskId');
  @override
  late final GeneratedColumn<int> parentTaskId = GeneratedColumn<int>(
      'parent_task_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES tasks (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, isCompleted, diaryId, parentTaskId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('diary_id')) {
      context.handle(_diaryIdMeta,
          diaryId.isAcceptableOrUnknown(data['diary_id']!, _diaryIdMeta));
    }
    if (data.containsKey('parent_task_id')) {
      context.handle(
          _parentTaskIdMeta,
          parentTaskId.isAcceptableOrUnknown(
              data['parent_task_id']!, _parentTaskIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      diaryId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}diary_id']),
      parentTaskId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_task_id']),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String title;
  final bool isCompleted;
  final int? diaryId;
  final int? parentTaskId;
  const Task(
      {required this.id,
      required this.title,
      required this.isCompleted,
      this.diaryId,
      this.parentTaskId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || diaryId != null) {
      map['diary_id'] = Variable<int>(diaryId);
    }
    if (!nullToAbsent || parentTaskId != null) {
      map['parent_task_id'] = Variable<int>(parentTaskId);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      title: Value(title),
      isCompleted: Value(isCompleted),
      diaryId: diaryId == null && nullToAbsent
          ? const Value.absent()
          : Value(diaryId),
      parentTaskId: parentTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentTaskId),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      diaryId: serializer.fromJson<int?>(json['diaryId']),
      parentTaskId: serializer.fromJson<int?>(json['parentTaskId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'diaryId': serializer.toJson<int?>(diaryId),
      'parentTaskId': serializer.toJson<int?>(parentTaskId),
    };
  }

  Task copyWith(
          {int? id,
          String? title,
          bool? isCompleted,
          Value<int?> diaryId = const Value.absent(),
          Value<int?> parentTaskId = const Value.absent()}) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        isCompleted: isCompleted ?? this.isCompleted,
        diaryId: diaryId.present ? diaryId.value : this.diaryId,
        parentTaskId:
            parentTaskId.present ? parentTaskId.value : this.parentTaskId,
      );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      diaryId: data.diaryId.present ? data.diaryId.value : this.diaryId,
      parentTaskId: data.parentTaskId.present
          ? data.parentTaskId.value
          : this.parentTaskId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('diaryId: $diaryId, ')
          ..write('parentTaskId: $parentTaskId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, isCompleted, diaryId, parentTaskId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.title == this.title &&
          other.isCompleted == this.isCompleted &&
          other.diaryId == this.diaryId &&
          other.parentTaskId == this.parentTaskId);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> title;
  final Value<bool> isCompleted;
  final Value<int?> diaryId;
  final Value<int?> parentTaskId;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.diaryId = const Value.absent(),
    this.parentTaskId = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.isCompleted = const Value.absent(),
    this.diaryId = const Value.absent(),
    this.parentTaskId = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<bool>? isCompleted,
    Expression<int>? diaryId,
    Expression<int>? parentTaskId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (diaryId != null) 'diary_id': diaryId,
      if (parentTaskId != null) 'parent_task_id': parentTaskId,
    });
  }

  TasksCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<bool>? isCompleted,
      Value<int?>? diaryId,
      Value<int?>? parentTaskId}) {
    return TasksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      diaryId: diaryId ?? this.diaryId,
      parentTaskId: parentTaskId ?? this.parentTaskId,
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
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (diaryId.present) {
      map['diary_id'] = Variable<int>(diaryId.value);
    }
    if (parentTaskId.present) {
      map['parent_task_id'] = Variable<int>(parentTaskId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('diaryId: $diaryId, ')
          ..write('parentTaskId: $parentTaskId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $NotebooksTable notebooks = $NotebooksTable(this);
  late final $DiariesTable diaries = $DiariesTable(this);
  late final $DiaryImagesTable diaryImages = $DiaryImagesTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [notebooks, diaries, diaryImages, tasks];
}

typedef $$NotebooksTableCreateCompanionBuilder = NotebooksCompanion Function({
  Value<int> id,
  required String title,
  required String icon,
  Value<int?> color,
});
typedef $$NotebooksTableUpdateCompanionBuilder = NotebooksCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> icon,
  Value<int?> color,
});

class $$NotebooksTableFilterComposer
    extends Composer<_$AppDatabase, $NotebooksTable> {
  $$NotebooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));
}

class $$NotebooksTableOrderingComposer
    extends Composer<_$AppDatabase, $NotebooksTable> {
  $$NotebooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));
}

class $$NotebooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotebooksTable> {
  $$NotebooksTableAnnotationComposer({
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

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$NotebooksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotebooksTable,
    Notebook,
    $$NotebooksTableFilterComposer,
    $$NotebooksTableOrderingComposer,
    $$NotebooksTableAnnotationComposer,
    $$NotebooksTableCreateCompanionBuilder,
    $$NotebooksTableUpdateCompanionBuilder,
    (Notebook, BaseReferences<_$AppDatabase, $NotebooksTable, Notebook>),
    Notebook,
    PrefetchHooks Function()> {
  $$NotebooksTableTableManager(_$AppDatabase db, $NotebooksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotebooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotebooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotebooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<int?> color = const Value.absent(),
          }) =>
              NotebooksCompanion(
            id: id,
            title: title,
            icon: icon,
            color: color,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String icon,
            Value<int?> color = const Value.absent(),
          }) =>
              NotebooksCompanion.insert(
            id: id,
            title: title,
            icon: icon,
            color: color,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotebooksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotebooksTable,
    Notebook,
    $$NotebooksTableFilterComposer,
    $$NotebooksTableOrderingComposer,
    $$NotebooksTableAnnotationComposer,
    $$NotebooksTableCreateCompanionBuilder,
    $$NotebooksTableUpdateCompanionBuilder,
    (Notebook, BaseReferences<_$AppDatabase, $NotebooksTable, Notebook>),
    Notebook,
    PrefetchHooks Function()>;
typedef $$DiariesTableCreateCompanionBuilder = DiariesCompanion Function({
  Value<int> id,
  required DateTime date,
  required String content,
});
typedef $$DiariesTableUpdateCompanionBuilder = DiariesCompanion Function({
  Value<int> id,
  Value<DateTime> date,
  Value<String> content,
});

final class $$DiariesTableReferences
    extends BaseReferences<_$AppDatabase, $DiariesTable, Diary> {
  $$DiariesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DiaryImagesTable, List<DiaryImage>>
      _diaryImagesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.diaryImages,
              aliasName:
                  $_aliasNameGenerator(db.diaries.id, db.diaryImages.diaryId));

  $$DiaryImagesTableProcessedTableManager get diaryImagesRefs {
    final manager = $$DiaryImagesTableTableManager($_db, $_db.diaryImages)
        .filter((f) => f.diaryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_diaryImagesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TasksTable, List<Task>> _tasksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.tasks,
          aliasName: $_aliasNameGenerator(db.diaries.id, db.tasks.diaryId));

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager($_db, $_db.tasks)
        .filter((f) => f.diaryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DiariesTableFilterComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  Expression<bool> diaryImagesRefs(
      Expression<bool> Function($$DiaryImagesTableFilterComposer f) f) {
    final $$DiaryImagesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.diaryImages,
        getReferencedColumn: (t) => t.diaryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiaryImagesTableFilterComposer(
              $db: $db,
              $table: $db.diaryImages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> tasksRefs(
      Expression<bool> Function($$TasksTableFilterComposer f) f) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.diaryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableFilterComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DiariesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));
}

class $$DiariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiariesTable> {
  $$DiariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  Expression<T> diaryImagesRefs<T extends Object>(
      Expression<T> Function($$DiaryImagesTableAnnotationComposer a) f) {
    final $$DiaryImagesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.diaryImages,
        getReferencedColumn: (t) => t.diaryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiaryImagesTableAnnotationComposer(
              $db: $db,
              $table: $db.diaryImages,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
      Expression<T> Function($$TasksTableAnnotationComposer a) f) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.diaryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableAnnotationComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DiariesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DiariesTable,
    Diary,
    $$DiariesTableFilterComposer,
    $$DiariesTableOrderingComposer,
    $$DiariesTableAnnotationComposer,
    $$DiariesTableCreateCompanionBuilder,
    $$DiariesTableUpdateCompanionBuilder,
    (Diary, $$DiariesTableReferences),
    Diary,
    PrefetchHooks Function({bool diaryImagesRefs, bool tasksRefs})> {
  $$DiariesTableTableManager(_$AppDatabase db, $DiariesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> content = const Value.absent(),
          }) =>
              DiariesCompanion(
            id: id,
            date: date,
            content: content,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime date,
            required String content,
          }) =>
              DiariesCompanion.insert(
            id: id,
            date: date,
            content: content,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DiariesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {diaryImagesRefs = false, tasksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (diaryImagesRefs) db.diaryImages,
                if (tasksRefs) db.tasks
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (diaryImagesRefs)
                    await $_getPrefetchedData<Diary, $DiariesTable, DiaryImage>(
                        currentTable: table,
                        referencedTable:
                            $$DiariesTableReferences._diaryImagesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DiariesTableReferences(db, table, p0)
                                .diaryImagesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.diaryId == item.id),
                        typedResults: items),
                  if (tasksRefs)
                    await $_getPrefetchedData<Diary, $DiariesTable, Task>(
                        currentTable: table,
                        referencedTable:
                            $$DiariesTableReferences._tasksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DiariesTableReferences(db, table, p0).tasksRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.diaryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DiariesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DiariesTable,
    Diary,
    $$DiariesTableFilterComposer,
    $$DiariesTableOrderingComposer,
    $$DiariesTableAnnotationComposer,
    $$DiariesTableCreateCompanionBuilder,
    $$DiariesTableUpdateCompanionBuilder,
    (Diary, $$DiariesTableReferences),
    Diary,
    PrefetchHooks Function({bool diaryImagesRefs, bool tasksRefs})>;
typedef $$DiaryImagesTableCreateCompanionBuilder = DiaryImagesCompanion
    Function({
  Value<int> id,
  Value<int?> diaryId,
  required String imagePath,
  Value<bool?> isLandscape,
});
typedef $$DiaryImagesTableUpdateCompanionBuilder = DiaryImagesCompanion
    Function({
  Value<int> id,
  Value<int?> diaryId,
  Value<String> imagePath,
  Value<bool?> isLandscape,
});

final class $$DiaryImagesTableReferences
    extends BaseReferences<_$AppDatabase, $DiaryImagesTable, DiaryImage> {
  $$DiaryImagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DiariesTable _diaryIdTable(_$AppDatabase db) => db.diaries
      .createAlias($_aliasNameGenerator(db.diaryImages.diaryId, db.diaries.id));

  $$DiariesTableProcessedTableManager? get diaryId {
    final $_column = $_itemColumn<int>('diary_id');
    if ($_column == null) return null;
    final manager = $$DiariesTableTableManager($_db, $_db.diaries)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diaryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$DiaryImagesTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryImagesTable> {
  $$DiaryImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLandscape => $composableBuilder(
      column: $table.isLandscape, builder: (column) => ColumnFilters(column));

  $$DiariesTableFilterComposer get diaryId {
    final $$DiariesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.diaryId,
        referencedTable: $db.diaries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiariesTableFilterComposer(
              $db: $db,
              $table: $db.diaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DiaryImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryImagesTable> {
  $$DiaryImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLandscape => $composableBuilder(
      column: $table.isLandscape, builder: (column) => ColumnOrderings(column));

  $$DiariesTableOrderingComposer get diaryId {
    final $$DiariesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.diaryId,
        referencedTable: $db.diaries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiariesTableOrderingComposer(
              $db: $db,
              $table: $db.diaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DiaryImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryImagesTable> {
  $$DiaryImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<bool> get isLandscape => $composableBuilder(
      column: $table.isLandscape, builder: (column) => column);

  $$DiariesTableAnnotationComposer get diaryId {
    final $$DiariesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.diaryId,
        referencedTable: $db.diaries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiariesTableAnnotationComposer(
              $db: $db,
              $table: $db.diaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DiaryImagesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DiaryImagesTable,
    DiaryImage,
    $$DiaryImagesTableFilterComposer,
    $$DiaryImagesTableOrderingComposer,
    $$DiaryImagesTableAnnotationComposer,
    $$DiaryImagesTableCreateCompanionBuilder,
    $$DiaryImagesTableUpdateCompanionBuilder,
    (DiaryImage, $$DiaryImagesTableReferences),
    DiaryImage,
    PrefetchHooks Function({bool diaryId})> {
  $$DiaryImagesTableTableManager(_$AppDatabase db, $DiaryImagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> diaryId = const Value.absent(),
            Value<String> imagePath = const Value.absent(),
            Value<bool?> isLandscape = const Value.absent(),
          }) =>
              DiaryImagesCompanion(
            id: id,
            diaryId: diaryId,
            imagePath: imagePath,
            isLandscape: isLandscape,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> diaryId = const Value.absent(),
            required String imagePath,
            Value<bool?> isLandscape = const Value.absent(),
          }) =>
              DiaryImagesCompanion.insert(
            id: id,
            diaryId: diaryId,
            imagePath: imagePath,
            isLandscape: isLandscape,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DiaryImagesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({diaryId = false}) {
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
                if (diaryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.diaryId,
                    referencedTable:
                        $$DiaryImagesTableReferences._diaryIdTable(db),
                    referencedColumn:
                        $$DiaryImagesTableReferences._diaryIdTable(db).id,
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

typedef $$DiaryImagesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DiaryImagesTable,
    DiaryImage,
    $$DiaryImagesTableFilterComposer,
    $$DiaryImagesTableOrderingComposer,
    $$DiaryImagesTableAnnotationComposer,
    $$DiaryImagesTableCreateCompanionBuilder,
    $$DiaryImagesTableUpdateCompanionBuilder,
    (DiaryImage, $$DiaryImagesTableReferences),
    DiaryImage,
    PrefetchHooks Function({bool diaryId})>;
typedef $$TasksTableCreateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  required String title,
  Value<bool> isCompleted,
  Value<int?> diaryId,
  Value<int?> parentTaskId,
});
typedef $$TasksTableUpdateCompanionBuilder = TasksCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<bool> isCompleted,
  Value<int?> diaryId,
  Value<int?> parentTaskId,
});

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, Task> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DiariesTable _diaryIdTable(_$AppDatabase db) => db.diaries
      .createAlias($_aliasNameGenerator(db.tasks.diaryId, db.diaries.id));

  $$DiariesTableProcessedTableManager? get diaryId {
    final $_column = $_itemColumn<int>('diary_id');
    if ($_column == null) return null;
    final manager = $$DiariesTableTableManager($_db, $_db.diaries)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_diaryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TasksTable _parentTaskIdTable(_$AppDatabase db) => db.tasks
      .createAlias($_aliasNameGenerator(db.tasks.parentTaskId, db.tasks.id));

  $$TasksTableProcessedTableManager? get parentTaskId {
    final $_column = $_itemColumn<int>('parent_task_id');
    if ($_column == null) return null;
    final manager = $$TasksTableTableManager($_db, $_db.tasks)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentTaskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  $$DiariesTableFilterComposer get diaryId {
    final $$DiariesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.diaryId,
        referencedTable: $db.diaries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiariesTableFilterComposer(
              $db: $db,
              $table: $db.diaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TasksTableFilterComposer get parentTaskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentTaskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableFilterComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  $$DiariesTableOrderingComposer get diaryId {
    final $$DiariesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.diaryId,
        referencedTable: $db.diaries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiariesTableOrderingComposer(
              $db: $db,
              $table: $db.diaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TasksTableOrderingComposer get parentTaskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentTaskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableOrderingComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
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

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  $$DiariesTableAnnotationComposer get diaryId {
    final $$DiariesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.diaryId,
        referencedTable: $db.diaries,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DiariesTableAnnotationComposer(
              $db: $db,
              $table: $db.diaries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TasksTableAnnotationComposer get parentTaskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentTaskId,
        referencedTable: $db.tasks,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TasksTableAnnotationComposer(
              $db: $db,
              $table: $db.tasks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TasksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, $$TasksTableReferences),
    Task,
    PrefetchHooks Function({bool diaryId, bool parentTaskId})> {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<int?> diaryId = const Value.absent(),
            Value<int?> parentTaskId = const Value.absent(),
          }) =>
              TasksCompanion(
            id: id,
            title: title,
            isCompleted: isCompleted,
            diaryId: diaryId,
            parentTaskId: parentTaskId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<bool> isCompleted = const Value.absent(),
            Value<int?> diaryId = const Value.absent(),
            Value<int?> parentTaskId = const Value.absent(),
          }) =>
              TasksCompanion.insert(
            id: id,
            title: title,
            isCompleted: isCompleted,
            diaryId: diaryId,
            parentTaskId: parentTaskId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TasksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({diaryId = false, parentTaskId = false}) {
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
                if (diaryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.diaryId,
                    referencedTable: $$TasksTableReferences._diaryIdTable(db),
                    referencedColumn:
                        $$TasksTableReferences._diaryIdTable(db).id,
                  ) as T;
                }
                if (parentTaskId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentTaskId,
                    referencedTable:
                        $$TasksTableReferences._parentTaskIdTable(db),
                    referencedColumn:
                        $$TasksTableReferences._parentTaskIdTable(db).id,
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

typedef $$TasksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TasksTable,
    Task,
    $$TasksTableFilterComposer,
    $$TasksTableOrderingComposer,
    $$TasksTableAnnotationComposer,
    $$TasksTableCreateCompanionBuilder,
    $$TasksTableUpdateCompanionBuilder,
    (Task, $$TasksTableReferences),
    Task,
    PrefetchHooks Function({bool diaryId, bool parentTaskId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$NotebooksTableTableManager get notebooks =>
      $$NotebooksTableTableManager(_db, _db.notebooks);
  $$DiariesTableTableManager get diaries =>
      $$DiariesTableTableManager(_db, _db.diaries);
  $$DiaryImagesTableTableManager get diaryImages =>
      $$DiaryImagesTableTableManager(_db, _db.diaryImages);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
}
