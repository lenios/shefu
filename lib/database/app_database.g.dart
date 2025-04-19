// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _servingsMeta =
      const VerificationMeta('servings');
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
      'servings', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> tags =
      GeneratedColumn<String>('tags', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant(''))
          .withConverter<List<String>>($RecipesTable.$convertertags);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
      'category', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _countryCodeMeta =
      const VerificationMeta('countryCode');
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
      'country_code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('WW'));
  static const VerificationMeta _caloriesMeta =
      const VerificationMeta('calories');
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
      'calories', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
      'time', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
      'month', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _carbohydratesMeta =
      const VerificationMeta('carbohydrates');
  @override
  late final GeneratedColumn<int> carbohydrates = GeneratedColumn<int>(
      'carbohydrates', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        source,
        imagePath,
        notes,
        servings,
        tags,
        category,
        countryCode,
        calories,
        time,
        month,
        carbohydrates
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(Insertable<Recipe> instance,
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
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('servings')) {
      context.handle(_servingsMeta,
          servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('country_code')) {
      context.handle(
          _countryCodeMeta,
          countryCode.isAcceptableOrUnknown(
              data['country_code']!, _countryCodeMeta));
    }
    if (data.containsKey('calories')) {
      context.handle(_caloriesMeta,
          calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    }
    if (data.containsKey('carbohydrates')) {
      context.handle(
          _carbohydratesMeta,
          carbohydrates.isAcceptableOrUnknown(
              data['carbohydrates']!, _carbohydratesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      servings: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}servings'])!,
      tags: $RecipesTable.$convertertags.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}category'])!,
      countryCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country_code'])!,
      calories: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}calories'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      carbohydrates: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}carbohydrates'])!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertertags =
      const ListConverter<String>();
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final int id;
  final String title;
  final String source;
  final String imagePath;
  final String notes;
  final int servings;
  final List<String> tags;
  final int category;
  final String countryCode;
  final int calories;
  final int time;
  final int month;
  final int carbohydrates;
  const Recipe(
      {required this.id,
      required this.title,
      required this.source,
      required this.imagePath,
      required this.notes,
      required this.servings,
      required this.tags,
      required this.category,
      required this.countryCode,
      required this.calories,
      required this.time,
      required this.month,
      required this.carbohydrates});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['source'] = Variable<String>(source);
    map['image_path'] = Variable<String>(imagePath);
    map['notes'] = Variable<String>(notes);
    map['servings'] = Variable<int>(servings);
    {
      map['tags'] = Variable<String>($RecipesTable.$convertertags.toSql(tags));
    }
    map['category'] = Variable<int>(category);
    map['country_code'] = Variable<String>(countryCode);
    map['calories'] = Variable<int>(calories);
    map['time'] = Variable<int>(time);
    map['month'] = Variable<int>(month);
    map['carbohydrates'] = Variable<int>(carbohydrates);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      title: Value(title),
      source: Value(source),
      imagePath: Value(imagePath),
      notes: Value(notes),
      servings: Value(servings),
      tags: Value(tags),
      category: Value(category),
      countryCode: Value(countryCode),
      calories: Value(calories),
      time: Value(time),
      month: Value(month),
      carbohydrates: Value(carbohydrates),
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      source: serializer.fromJson<String>(json['source']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      notes: serializer.fromJson<String>(json['notes']),
      servings: serializer.fromJson<int>(json['servings']),
      tags: serializer.fromJson<List<String>>(json['tags']),
      category: serializer.fromJson<int>(json['category']),
      countryCode: serializer.fromJson<String>(json['countryCode']),
      calories: serializer.fromJson<int>(json['calories']),
      time: serializer.fromJson<int>(json['time']),
      month: serializer.fromJson<int>(json['month']),
      carbohydrates: serializer.fromJson<int>(json['carbohydrates']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'source': serializer.toJson<String>(source),
      'imagePath': serializer.toJson<String>(imagePath),
      'notes': serializer.toJson<String>(notes),
      'servings': serializer.toJson<int>(servings),
      'tags': serializer.toJson<List<String>>(tags),
      'category': serializer.toJson<int>(category),
      'countryCode': serializer.toJson<String>(countryCode),
      'calories': serializer.toJson<int>(calories),
      'time': serializer.toJson<int>(time),
      'month': serializer.toJson<int>(month),
      'carbohydrates': serializer.toJson<int>(carbohydrates),
    };
  }

  Recipe copyWith(
          {int? id,
          String? title,
          String? source,
          String? imagePath,
          String? notes,
          int? servings,
          List<String>? tags,
          int? category,
          String? countryCode,
          int? calories,
          int? time,
          int? month,
          int? carbohydrates}) =>
      Recipe(
        id: id ?? this.id,
        title: title ?? this.title,
        source: source ?? this.source,
        imagePath: imagePath ?? this.imagePath,
        notes: notes ?? this.notes,
        servings: servings ?? this.servings,
        tags: tags ?? this.tags,
        category: category ?? this.category,
        countryCode: countryCode ?? this.countryCode,
        calories: calories ?? this.calories,
        time: time ?? this.time,
        month: month ?? this.month,
        carbohydrates: carbohydrates ?? this.carbohydrates,
      );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      source: data.source.present ? data.source.value : this.source,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      notes: data.notes.present ? data.notes.value : this.notes,
      servings: data.servings.present ? data.servings.value : this.servings,
      tags: data.tags.present ? data.tags.value : this.tags,
      category: data.category.present ? data.category.value : this.category,
      countryCode:
          data.countryCode.present ? data.countryCode.value : this.countryCode,
      calories: data.calories.present ? data.calories.value : this.calories,
      time: data.time.present ? data.time.value : this.time,
      month: data.month.present ? data.month.value : this.month,
      carbohydrates: data.carbohydrates.present
          ? data.carbohydrates.value
          : this.carbohydrates,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('source: $source, ')
          ..write('imagePath: $imagePath, ')
          ..write('notes: $notes, ')
          ..write('servings: $servings, ')
          ..write('tags: $tags, ')
          ..write('category: $category, ')
          ..write('countryCode: $countryCode, ')
          ..write('calories: $calories, ')
          ..write('time: $time, ')
          ..write('month: $month, ')
          ..write('carbohydrates: $carbohydrates')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, source, imagePath, notes, servings,
      tags, category, countryCode, calories, time, month, carbohydrates);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.title == this.title &&
          other.source == this.source &&
          other.imagePath == this.imagePath &&
          other.notes == this.notes &&
          other.servings == this.servings &&
          other.tags == this.tags &&
          other.category == this.category &&
          other.countryCode == this.countryCode &&
          other.calories == this.calories &&
          other.time == this.time &&
          other.month == this.month &&
          other.carbohydrates == this.carbohydrates);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> source;
  final Value<String> imagePath;
  final Value<String> notes;
  final Value<int> servings;
  final Value<List<String>> tags;
  final Value<int> category;
  final Value<String> countryCode;
  final Value<int> calories;
  final Value<int> time;
  final Value<int> month;
  final Value<int> carbohydrates;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.source = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.notes = const Value.absent(),
    this.servings = const Value.absent(),
    this.tags = const Value.absent(),
    this.category = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.calories = const Value.absent(),
    this.time = const Value.absent(),
    this.month = const Value.absent(),
    this.carbohydrates = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.source = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.notes = const Value.absent(),
    this.servings = const Value.absent(),
    this.tags = const Value.absent(),
    this.category = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.calories = const Value.absent(),
    this.time = const Value.absent(),
    this.month = const Value.absent(),
    this.carbohydrates = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Recipe> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? source,
    Expression<String>? imagePath,
    Expression<String>? notes,
    Expression<int>? servings,
    Expression<String>? tags,
    Expression<int>? category,
    Expression<String>? countryCode,
    Expression<int>? calories,
    Expression<int>? time,
    Expression<int>? month,
    Expression<int>? carbohydrates,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (source != null) 'source': source,
      if (imagePath != null) 'image_path': imagePath,
      if (notes != null) 'notes': notes,
      if (servings != null) 'servings': servings,
      if (tags != null) 'tags': tags,
      if (category != null) 'category': category,
      if (countryCode != null) 'country_code': countryCode,
      if (calories != null) 'calories': calories,
      if (time != null) 'time': time,
      if (month != null) 'month': month,
      if (carbohydrates != null) 'carbohydrates': carbohydrates,
    });
  }

  RecipesCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? source,
      Value<String>? imagePath,
      Value<String>? notes,
      Value<int>? servings,
      Value<List<String>>? tags,
      Value<int>? category,
      Value<String>? countryCode,
      Value<int>? calories,
      Value<int>? time,
      Value<int>? month,
      Value<int>? carbohydrates}) {
    return RecipesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      source: source ?? this.source,
      imagePath: imagePath ?? this.imagePath,
      notes: notes ?? this.notes,
      servings: servings ?? this.servings,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      countryCode: countryCode ?? this.countryCode,
      calories: calories ?? this.calories,
      time: time ?? this.time,
      month: month ?? this.month,
      carbohydrates: carbohydrates ?? this.carbohydrates,
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
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (tags.present) {
      map['tags'] =
          Variable<String>($RecipesTable.$convertertags.toSql(tags.value));
    }
    if (category.present) {
      map['category'] = Variable<int>(category.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (carbohydrates.present) {
      map['carbohydrates'] = Variable<int>(carbohydrates.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('source: $source, ')
          ..write('imagePath: $imagePath, ')
          ..write('notes: $notes, ')
          ..write('servings: $servings, ')
          ..write('tags: $tags, ')
          ..write('category: $category, ')
          ..write('countryCode: $countryCode, ')
          ..write('calories: $calories, ')
          ..write('time: $time, ')
          ..write('month: $month, ')
          ..write('carbohydrates: $carbohydrates')
          ..write(')'))
        .toString();
  }
}

class $RecipeStepsTable extends RecipeSteps
    with TableInfo<$RecipeStepsTable, RecipeStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES recipes (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _instructionMeta =
      const VerificationMeta('instruction');
  @override
  late final GeneratedColumn<String> instruction = GeneratedColumn<String>(
      'instruction', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _timerMeta = const VerificationMeta('timer');
  @override
  late final GeneratedColumn<int> timer = GeneratedColumn<int>(
      'timer', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _stepOrderMeta =
      const VerificationMeta('stepOrder');
  @override
  late final GeneratedColumn<int> stepOrder = GeneratedColumn<int>(
      'step_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, recipeId, name, instruction, imagePath, timer, stepOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_steps';
  @override
  VerificationContext validateIntegrity(Insertable<RecipeStep> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('instruction')) {
      context.handle(
          _instructionMeta,
          instruction.isAcceptableOrUnknown(
              data['instruction']!, _instructionMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('timer')) {
      context.handle(
          _timerMeta, timer.isAcceptableOrUnknown(data['timer']!, _timerMeta));
    }
    if (data.containsKey('step_order')) {
      context.handle(_stepOrderMeta,
          stepOrder.isAcceptableOrUnknown(data['step_order']!, _stepOrderMeta));
    } else if (isInserting) {
      context.missing(_stepOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeStep(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      instruction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instruction'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path'])!,
      timer: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timer'])!,
      stepOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}step_order'])!,
    );
  }

  @override
  $RecipeStepsTable createAlias(String alias) {
    return $RecipeStepsTable(attachedDatabase, alias);
  }
}

class RecipeStep extends DataClass implements Insertable<RecipeStep> {
  final int id;
  final int recipeId;
  final String name;
  final String instruction;
  final String imagePath;
  final int timer;
  final int stepOrder;
  const RecipeStep(
      {required this.id,
      required this.recipeId,
      required this.name,
      required this.instruction,
      required this.imagePath,
      required this.timer,
      required this.stepOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['name'] = Variable<String>(name);
    map['instruction'] = Variable<String>(instruction);
    map['image_path'] = Variable<String>(imagePath);
    map['timer'] = Variable<int>(timer);
    map['step_order'] = Variable<int>(stepOrder);
    return map;
  }

  RecipeStepsCompanion toCompanion(bool nullToAbsent) {
    return RecipeStepsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      name: Value(name),
      instruction: Value(instruction),
      imagePath: Value(imagePath),
      timer: Value(timer),
      stepOrder: Value(stepOrder),
    );
  }

  factory RecipeStep.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeStep(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      name: serializer.fromJson<String>(json['name']),
      instruction: serializer.fromJson<String>(json['instruction']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      timer: serializer.fromJson<int>(json['timer']),
      stepOrder: serializer.fromJson<int>(json['stepOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'name': serializer.toJson<String>(name),
      'instruction': serializer.toJson<String>(instruction),
      'imagePath': serializer.toJson<String>(imagePath),
      'timer': serializer.toJson<int>(timer),
      'stepOrder': serializer.toJson<int>(stepOrder),
    };
  }

  RecipeStep copyWith(
          {int? id,
          int? recipeId,
          String? name,
          String? instruction,
          String? imagePath,
          int? timer,
          int? stepOrder}) =>
      RecipeStep(
        id: id ?? this.id,
        recipeId: recipeId ?? this.recipeId,
        name: name ?? this.name,
        instruction: instruction ?? this.instruction,
        imagePath: imagePath ?? this.imagePath,
        timer: timer ?? this.timer,
        stepOrder: stepOrder ?? this.stepOrder,
      );
  RecipeStep copyWithCompanion(RecipeStepsCompanion data) {
    return RecipeStep(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      name: data.name.present ? data.name.value : this.name,
      instruction:
          data.instruction.present ? data.instruction.value : this.instruction,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      timer: data.timer.present ? data.timer.value : this.timer,
      stepOrder: data.stepOrder.present ? data.stepOrder.value : this.stepOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStep(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
          ..write('instruction: $instruction, ')
          ..write('imagePath: $imagePath, ')
          ..write('timer: $timer, ')
          ..write('stepOrder: $stepOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recipeId, name, instruction, imagePath, timer, stepOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeStep &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.name == this.name &&
          other.instruction == this.instruction &&
          other.imagePath == this.imagePath &&
          other.timer == this.timer &&
          other.stepOrder == this.stepOrder);
}

class RecipeStepsCompanion extends UpdateCompanion<RecipeStep> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<String> name;
  final Value<String> instruction;
  final Value<String> imagePath;
  final Value<int> timer;
  final Value<int> stepOrder;
  const RecipeStepsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.name = const Value.absent(),
    this.instruction = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.timer = const Value.absent(),
    this.stepOrder = const Value.absent(),
  });
  RecipeStepsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    this.name = const Value.absent(),
    this.instruction = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.timer = const Value.absent(),
    required int stepOrder,
  })  : recipeId = Value(recipeId),
        stepOrder = Value(stepOrder);
  static Insertable<RecipeStep> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<String>? name,
    Expression<String>? instruction,
    Expression<String>? imagePath,
    Expression<int>? timer,
    Expression<int>? stepOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (name != null) 'name': name,
      if (instruction != null) 'instruction': instruction,
      if (imagePath != null) 'image_path': imagePath,
      if (timer != null) 'timer': timer,
      if (stepOrder != null) 'step_order': stepOrder,
    });
  }

  RecipeStepsCompanion copyWith(
      {Value<int>? id,
      Value<int>? recipeId,
      Value<String>? name,
      Value<String>? instruction,
      Value<String>? imagePath,
      Value<int>? timer,
      Value<int>? stepOrder}) {
    return RecipeStepsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      name: name ?? this.name,
      instruction: instruction ?? this.instruction,
      imagePath: imagePath ?? this.imagePath,
      timer: timer ?? this.timer,
      stepOrder: stepOrder ?? this.stepOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (instruction.present) {
      map['instruction'] = Variable<String>(instruction.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (timer.present) {
      map['timer'] = Variable<int>(timer.value);
    }
    if (stepOrder.present) {
      map['step_order'] = Variable<int>(stepOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStepsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
          ..write('instruction: $instruction, ')
          ..write('imagePath: $imagePath, ')
          ..write('timer: $timer, ')
          ..write('stepOrder: $stepOrder')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _recipeStepIdMeta =
      const VerificationMeta('recipeStepId');
  @override
  late final GeneratedColumn<int> recipeStepId = GeneratedColumn<int>(
      'recipe_step_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES recipe_steps (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  static const VerificationMeta _shapeMeta = const VerificationMeta('shape');
  @override
  late final GeneratedColumn<String> shape = GeneratedColumn<String>(
      'shape', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
      'food_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _selectedFactorIdMeta =
      const VerificationMeta('selectedFactorId');
  @override
  late final GeneratedColumn<int> selectedFactorId = GeneratedColumn<int>(
      'selected_factor_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _ingredientOrderMeta =
      const VerificationMeta('ingredientOrder');
  @override
  late final GeneratedColumn<int> ingredientOrder = GeneratedColumn<int>(
      'ingredient_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        recipeStepId,
        name,
        unit,
        quantity,
        shape,
        foodId,
        selectedFactorId,
        ingredientOrder
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(Insertable<Ingredient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_step_id')) {
      context.handle(
          _recipeStepIdMeta,
          recipeStepId.isAcceptableOrUnknown(
              data['recipe_step_id']!, _recipeStepIdMeta));
    } else if (isInserting) {
      context.missing(_recipeStepIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('shape')) {
      context.handle(
          _shapeMeta, shape.isAcceptableOrUnknown(data['shape']!, _shapeMeta));
    }
    if (data.containsKey('food_id')) {
      context.handle(_foodIdMeta,
          foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta));
    }
    if (data.containsKey('selected_factor_id')) {
      context.handle(
          _selectedFactorIdMeta,
          selectedFactorId.isAcceptableOrUnknown(
              data['selected_factor_id']!, _selectedFactorIdMeta));
    }
    if (data.containsKey('ingredient_order')) {
      context.handle(
          _ingredientOrderMeta,
          ingredientOrder.isAcceptableOrUnknown(
              data['ingredient_order']!, _ingredientOrderMeta));
    } else if (isInserting) {
      context.missing(_ingredientOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recipeStepId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recipe_step_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      shape: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}shape'])!,
      foodId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}food_id'])!,
      selectedFactorId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}selected_factor_id'])!,
      ingredientOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ingredient_order'])!,
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final int id;
  final int recipeStepId;
  final String name;
  final String unit;
  final double quantity;
  final String shape;
  final int foodId;
  final int selectedFactorId;
  final int ingredientOrder;
  const Ingredient(
      {required this.id,
      required this.recipeStepId,
      required this.name,
      required this.unit,
      required this.quantity,
      required this.shape,
      required this.foodId,
      required this.selectedFactorId,
      required this.ingredientOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_step_id'] = Variable<int>(recipeStepId);
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<String>(unit);
    map['quantity'] = Variable<double>(quantity);
    map['shape'] = Variable<String>(shape);
    map['food_id'] = Variable<int>(foodId);
    map['selected_factor_id'] = Variable<int>(selectedFactorId);
    map['ingredient_order'] = Variable<int>(ingredientOrder);
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      recipeStepId: Value(recipeStepId),
      name: Value(name),
      unit: Value(unit),
      quantity: Value(quantity),
      shape: Value(shape),
      foodId: Value(foodId),
      selectedFactorId: Value(selectedFactorId),
      ingredientOrder: Value(ingredientOrder),
    );
  }

  factory Ingredient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<int>(json['id']),
      recipeStepId: serializer.fromJson<int>(json['recipeStepId']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      quantity: serializer.fromJson<double>(json['quantity']),
      shape: serializer.fromJson<String>(json['shape']),
      foodId: serializer.fromJson<int>(json['foodId']),
      selectedFactorId: serializer.fromJson<int>(json['selectedFactorId']),
      ingredientOrder: serializer.fromJson<int>(json['ingredientOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeStepId': serializer.toJson<int>(recipeStepId),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'quantity': serializer.toJson<double>(quantity),
      'shape': serializer.toJson<String>(shape),
      'foodId': serializer.toJson<int>(foodId),
      'selectedFactorId': serializer.toJson<int>(selectedFactorId),
      'ingredientOrder': serializer.toJson<int>(ingredientOrder),
    };
  }

  Ingredient copyWith(
          {int? id,
          int? recipeStepId,
          String? name,
          String? unit,
          double? quantity,
          String? shape,
          int? foodId,
          int? selectedFactorId,
          int? ingredientOrder}) =>
      Ingredient(
        id: id ?? this.id,
        recipeStepId: recipeStepId ?? this.recipeStepId,
        name: name ?? this.name,
        unit: unit ?? this.unit,
        quantity: quantity ?? this.quantity,
        shape: shape ?? this.shape,
        foodId: foodId ?? this.foodId,
        selectedFactorId: selectedFactorId ?? this.selectedFactorId,
        ingredientOrder: ingredientOrder ?? this.ingredientOrder,
      );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      recipeStepId: data.recipeStepId.present
          ? data.recipeStepId.value
          : this.recipeStepId,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      shape: data.shape.present ? data.shape.value : this.shape,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      selectedFactorId: data.selectedFactorId.present
          ? data.selectedFactorId.value
          : this.selectedFactorId,
      ingredientOrder: data.ingredientOrder.present
          ? data.ingredientOrder.value
          : this.ingredientOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('recipeStepId: $recipeStepId, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('shape: $shape, ')
          ..write('foodId: $foodId, ')
          ..write('selectedFactorId: $selectedFactorId, ')
          ..write('ingredientOrder: $ingredientOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeStepId, name, unit, quantity, shape,
      foodId, selectedFactorId, ingredientOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.recipeStepId == this.recipeStepId &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.quantity == this.quantity &&
          other.shape == this.shape &&
          other.foodId == this.foodId &&
          other.selectedFactorId == this.selectedFactorId &&
          other.ingredientOrder == this.ingredientOrder);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<int> id;
  final Value<int> recipeStepId;
  final Value<String> name;
  final Value<String> unit;
  final Value<double> quantity;
  final Value<String> shape;
  final Value<int> foodId;
  final Value<int> selectedFactorId;
  final Value<int> ingredientOrder;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.recipeStepId = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantity = const Value.absent(),
    this.shape = const Value.absent(),
    this.foodId = const Value.absent(),
    this.selectedFactorId = const Value.absent(),
    this.ingredientOrder = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeStepId,
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantity = const Value.absent(),
    this.shape = const Value.absent(),
    this.foodId = const Value.absent(),
    this.selectedFactorId = const Value.absent(),
    required int ingredientOrder,
  })  : recipeStepId = Value(recipeStepId),
        ingredientOrder = Value(ingredientOrder);
  static Insertable<Ingredient> custom({
    Expression<int>? id,
    Expression<int>? recipeStepId,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<double>? quantity,
    Expression<String>? shape,
    Expression<int>? foodId,
    Expression<int>? selectedFactorId,
    Expression<int>? ingredientOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeStepId != null) 'recipe_step_id': recipeStepId,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (quantity != null) 'quantity': quantity,
      if (shape != null) 'shape': shape,
      if (foodId != null) 'food_id': foodId,
      if (selectedFactorId != null) 'selected_factor_id': selectedFactorId,
      if (ingredientOrder != null) 'ingredient_order': ingredientOrder,
    });
  }

  IngredientsCompanion copyWith(
      {Value<int>? id,
      Value<int>? recipeStepId,
      Value<String>? name,
      Value<String>? unit,
      Value<double>? quantity,
      Value<String>? shape,
      Value<int>? foodId,
      Value<int>? selectedFactorId,
      Value<int>? ingredientOrder}) {
    return IngredientsCompanion(
      id: id ?? this.id,
      recipeStepId: recipeStepId ?? this.recipeStepId,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      shape: shape ?? this.shape,
      foodId: foodId ?? this.foodId,
      selectedFactorId: selectedFactorId ?? this.selectedFactorId,
      ingredientOrder: ingredientOrder ?? this.ingredientOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeStepId.present) {
      map['recipe_step_id'] = Variable<int>(recipeStepId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (shape.present) {
      map['shape'] = Variable<String>(shape.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (selectedFactorId.present) {
      map['selected_factor_id'] = Variable<int>(selectedFactorId.value);
    }
    if (ingredientOrder.present) {
      map['ingredient_order'] = Variable<int>(ingredientOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('recipeStepId: $recipeStepId, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('shape: $shape, ')
          ..write('foodId: $foodId, ')
          ..write('selectedFactorId: $selectedFactorId, ')
          ..write('ingredientOrder: $ingredientOrder')
          ..write(')'))
        .toString();
  }
}

class $NutrientsTable extends Nutrients
    with TableInfo<$NutrientsTable, Nutrient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutrientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _descENMeta = const VerificationMeta('descEN');
  @override
  late final GeneratedColumn<String> descEN = GeneratedColumn<String>(
      'desc_e_n', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descFRMeta = const VerificationMeta('descFR');
  @override
  late final GeneratedColumn<String> descFR = GeneratedColumn<String>(
      'desc_f_r', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _proteinsMeta =
      const VerificationMeta('proteins');
  @override
  late final GeneratedColumn<double> proteins = GeneratedColumn<double>(
      'proteins', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _waterMeta = const VerificationMeta('water');
  @override
  late final GeneratedColumn<double> water = GeneratedColumn<double>(
      'water', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
      'fat', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _energKcalMeta =
      const VerificationMeta('energKcal');
  @override
  late final GeneratedColumn<double> energKcal = GeneratedColumn<double>(
      'energ_kcal', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _carbohydratesMeta =
      const VerificationMeta('carbohydrates');
  @override
  late final GeneratedColumn<double> carbohydrates = GeneratedColumn<double>(
      'carbohydrates', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, descEN, descFR, proteins, water, fat, energKcal, carbohydrates];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrients';
  @override
  VerificationContext validateIntegrity(Insertable<Nutrient> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('desc_e_n')) {
      context.handle(_descENMeta,
          descEN.isAcceptableOrUnknown(data['desc_e_n']!, _descENMeta));
    } else if (isInserting) {
      context.missing(_descENMeta);
    }
    if (data.containsKey('desc_f_r')) {
      context.handle(_descFRMeta,
          descFR.isAcceptableOrUnknown(data['desc_f_r']!, _descFRMeta));
    } else if (isInserting) {
      context.missing(_descFRMeta);
    }
    if (data.containsKey('proteins')) {
      context.handle(_proteinsMeta,
          proteins.isAcceptableOrUnknown(data['proteins']!, _proteinsMeta));
    }
    if (data.containsKey('water')) {
      context.handle(
          _waterMeta, water.isAcceptableOrUnknown(data['water']!, _waterMeta));
    }
    if (data.containsKey('fat')) {
      context.handle(
          _fatMeta, fat.isAcceptableOrUnknown(data['fat']!, _fatMeta));
    }
    if (data.containsKey('energ_kcal')) {
      context.handle(_energKcalMeta,
          energKcal.isAcceptableOrUnknown(data['energ_kcal']!, _energKcalMeta));
    }
    if (data.containsKey('carbohydrates')) {
      context.handle(
          _carbohydratesMeta,
          carbohydrates.isAcceptableOrUnknown(
              data['carbohydrates']!, _carbohydratesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Nutrient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Nutrient(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      descEN: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}desc_e_n'])!,
      descFR: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}desc_f_r'])!,
      proteins: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}proteins'])!,
      water: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}water'])!,
      fat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}fat'])!,
      energKcal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}energ_kcal'])!,
      carbohydrates: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}carbohydrates'])!,
    );
  }

  @override
  $NutrientsTable createAlias(String alias) {
    return $NutrientsTable(attachedDatabase, alias);
  }
}

class Nutrient extends DataClass implements Insertable<Nutrient> {
  final int id;
  final String descEN;
  final String descFR;
  final double proteins;
  final double water;
  final double fat;
  final double energKcal;
  final double carbohydrates;
  const Nutrient(
      {required this.id,
      required this.descEN,
      required this.descFR,
      required this.proteins,
      required this.water,
      required this.fat,
      required this.energKcal,
      required this.carbohydrates});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['desc_e_n'] = Variable<String>(descEN);
    map['desc_f_r'] = Variable<String>(descFR);
    map['proteins'] = Variable<double>(proteins);
    map['water'] = Variable<double>(water);
    map['fat'] = Variable<double>(fat);
    map['energ_kcal'] = Variable<double>(energKcal);
    map['carbohydrates'] = Variable<double>(carbohydrates);
    return map;
  }

  NutrientsCompanion toCompanion(bool nullToAbsent) {
    return NutrientsCompanion(
      id: Value(id),
      descEN: Value(descEN),
      descFR: Value(descFR),
      proteins: Value(proteins),
      water: Value(water),
      fat: Value(fat),
      energKcal: Value(energKcal),
      carbohydrates: Value(carbohydrates),
    );
  }

  factory Nutrient.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Nutrient(
      id: serializer.fromJson<int>(json['id']),
      descEN: serializer.fromJson<String>(json['descEN']),
      descFR: serializer.fromJson<String>(json['descFR']),
      proteins: serializer.fromJson<double>(json['proteins']),
      water: serializer.fromJson<double>(json['water']),
      fat: serializer.fromJson<double>(json['fat']),
      energKcal: serializer.fromJson<double>(json['energKcal']),
      carbohydrates: serializer.fromJson<double>(json['carbohydrates']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'descEN': serializer.toJson<String>(descEN),
      'descFR': serializer.toJson<String>(descFR),
      'proteins': serializer.toJson<double>(proteins),
      'water': serializer.toJson<double>(water),
      'fat': serializer.toJson<double>(fat),
      'energKcal': serializer.toJson<double>(energKcal),
      'carbohydrates': serializer.toJson<double>(carbohydrates),
    };
  }

  Nutrient copyWith(
          {int? id,
          String? descEN,
          String? descFR,
          double? proteins,
          double? water,
          double? fat,
          double? energKcal,
          double? carbohydrates}) =>
      Nutrient(
        id: id ?? this.id,
        descEN: descEN ?? this.descEN,
        descFR: descFR ?? this.descFR,
        proteins: proteins ?? this.proteins,
        water: water ?? this.water,
        fat: fat ?? this.fat,
        energKcal: energKcal ?? this.energKcal,
        carbohydrates: carbohydrates ?? this.carbohydrates,
      );
  Nutrient copyWithCompanion(NutrientsCompanion data) {
    return Nutrient(
      id: data.id.present ? data.id.value : this.id,
      descEN: data.descEN.present ? data.descEN.value : this.descEN,
      descFR: data.descFR.present ? data.descFR.value : this.descFR,
      proteins: data.proteins.present ? data.proteins.value : this.proteins,
      water: data.water.present ? data.water.value : this.water,
      fat: data.fat.present ? data.fat.value : this.fat,
      energKcal: data.energKcal.present ? data.energKcal.value : this.energKcal,
      carbohydrates: data.carbohydrates.present
          ? data.carbohydrates.value
          : this.carbohydrates,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Nutrient(')
          ..write('id: $id, ')
          ..write('descEN: $descEN, ')
          ..write('descFR: $descFR, ')
          ..write('proteins: $proteins, ')
          ..write('water: $water, ')
          ..write('fat: $fat, ')
          ..write('energKcal: $energKcal, ')
          ..write('carbohydrates: $carbohydrates')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, descEN, descFR, proteins, water, fat, energKcal, carbohydrates);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Nutrient &&
          other.id == this.id &&
          other.descEN == this.descEN &&
          other.descFR == this.descFR &&
          other.proteins == this.proteins &&
          other.water == this.water &&
          other.fat == this.fat &&
          other.energKcal == this.energKcal &&
          other.carbohydrates == this.carbohydrates);
}

class NutrientsCompanion extends UpdateCompanion<Nutrient> {
  final Value<int> id;
  final Value<String> descEN;
  final Value<String> descFR;
  final Value<double> proteins;
  final Value<double> water;
  final Value<double> fat;
  final Value<double> energKcal;
  final Value<double> carbohydrates;
  const NutrientsCompanion({
    this.id = const Value.absent(),
    this.descEN = const Value.absent(),
    this.descFR = const Value.absent(),
    this.proteins = const Value.absent(),
    this.water = const Value.absent(),
    this.fat = const Value.absent(),
    this.energKcal = const Value.absent(),
    this.carbohydrates = const Value.absent(),
  });
  NutrientsCompanion.insert({
    this.id = const Value.absent(),
    required String descEN,
    required String descFR,
    this.proteins = const Value.absent(),
    this.water = const Value.absent(),
    this.fat = const Value.absent(),
    this.energKcal = const Value.absent(),
    this.carbohydrates = const Value.absent(),
  })  : descEN = Value(descEN),
        descFR = Value(descFR);
  static Insertable<Nutrient> custom({
    Expression<int>? id,
    Expression<String>? descEN,
    Expression<String>? descFR,
    Expression<double>? proteins,
    Expression<double>? water,
    Expression<double>? fat,
    Expression<double>? energKcal,
    Expression<double>? carbohydrates,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (descEN != null) 'desc_e_n': descEN,
      if (descFR != null) 'desc_f_r': descFR,
      if (proteins != null) 'proteins': proteins,
      if (water != null) 'water': water,
      if (fat != null) 'fat': fat,
      if (energKcal != null) 'energ_kcal': energKcal,
      if (carbohydrates != null) 'carbohydrates': carbohydrates,
    });
  }

  NutrientsCompanion copyWith(
      {Value<int>? id,
      Value<String>? descEN,
      Value<String>? descFR,
      Value<double>? proteins,
      Value<double>? water,
      Value<double>? fat,
      Value<double>? energKcal,
      Value<double>? carbohydrates}) {
    return NutrientsCompanion(
      id: id ?? this.id,
      descEN: descEN ?? this.descEN,
      descFR: descFR ?? this.descFR,
      proteins: proteins ?? this.proteins,
      water: water ?? this.water,
      fat: fat ?? this.fat,
      energKcal: energKcal ?? this.energKcal,
      carbohydrates: carbohydrates ?? this.carbohydrates,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (descEN.present) {
      map['desc_e_n'] = Variable<String>(descEN.value);
    }
    if (descFR.present) {
      map['desc_f_r'] = Variable<String>(descFR.value);
    }
    if (proteins.present) {
      map['proteins'] = Variable<double>(proteins.value);
    }
    if (water.present) {
      map['water'] = Variable<double>(water.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (energKcal.present) {
      map['energ_kcal'] = Variable<double>(energKcal.value);
    }
    if (carbohydrates.present) {
      map['carbohydrates'] = Variable<double>(carbohydrates.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutrientsCompanion(')
          ..write('id: $id, ')
          ..write('descEN: $descEN, ')
          ..write('descFR: $descFR, ')
          ..write('proteins: $proteins, ')
          ..write('water: $water, ')
          ..write('fat: $fat, ')
          ..write('energKcal: $energKcal, ')
          ..write('carbohydrates: $carbohydrates')
          ..write(')'))
        .toString();
  }
}

class $ConversionsTable extends Conversions
    with TableInfo<$ConversionsTable, Conversion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nutrientIdMeta =
      const VerificationMeta('nutrientId');
  @override
  late final GeneratedColumn<int> nutrientId = GeneratedColumn<int>(
      'nutrient_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES nutrients (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _factorMeta = const VerificationMeta('factor');
  @override
  late final GeneratedColumn<double> factor = GeneratedColumn<double>(
      'factor', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _descENMeta = const VerificationMeta('descEN');
  @override
  late final GeneratedColumn<String> descEN = GeneratedColumn<String>(
      'descEN', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _descFRMeta = const VerificationMeta('descFR');
  @override
  late final GeneratedColumn<String> descFR = GeneratedColumn<String>(
      'descFR', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns =>
      [id, nutrientId, name, factor, descEN, descFR];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversions';
  @override
  VerificationContext validateIntegrity(Insertable<Conversion> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nutrient_id')) {
      context.handle(
          _nutrientIdMeta,
          nutrientId.isAcceptableOrUnknown(
              data['nutrient_id']!, _nutrientIdMeta));
    } else if (isInserting) {
      context.missing(_nutrientIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('factor')) {
      context.handle(_factorMeta,
          factor.isAcceptableOrUnknown(data['factor']!, _factorMeta));
    }
    if (data.containsKey('descEN')) {
      context.handle(_descENMeta,
          descEN.isAcceptableOrUnknown(data['descEN']!, _descENMeta));
    }
    if (data.containsKey('descFR')) {
      context.handle(_descFRMeta,
          descFR.isAcceptableOrUnknown(data['descFR']!, _descFRMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Conversion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Conversion(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nutrientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}nutrient_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      factor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}factor'])!,
      descEN: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descEN'])!,
      descFR: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descFR'])!,
    );
  }

  @override
  $ConversionsTable createAlias(String alias) {
    return $ConversionsTable(attachedDatabase, alias);
  }
}

class Conversion extends DataClass implements Insertable<Conversion> {
  final int id;
  final int nutrientId;
  final String name;
  final double factor;
  final String descEN;
  final String descFR;
  const Conversion(
      {required this.id,
      required this.nutrientId,
      required this.name,
      required this.factor,
      required this.descEN,
      required this.descFR});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nutrient_id'] = Variable<int>(nutrientId);
    map['name'] = Variable<String>(name);
    map['factor'] = Variable<double>(factor);
    map['descEN'] = Variable<String>(descEN);
    map['descFR'] = Variable<String>(descFR);
    return map;
  }

  ConversionsCompanion toCompanion(bool nullToAbsent) {
    return ConversionsCompanion(
      id: Value(id),
      nutrientId: Value(nutrientId),
      name: Value(name),
      factor: Value(factor),
      descEN: Value(descEN),
      descFR: Value(descFR),
    );
  }

  factory Conversion.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Conversion(
      id: serializer.fromJson<int>(json['id']),
      nutrientId: serializer.fromJson<int>(json['nutrientId']),
      name: serializer.fromJson<String>(json['name']),
      factor: serializer.fromJson<double>(json['factor']),
      descEN: serializer.fromJson<String>(json['descEN']),
      descFR: serializer.fromJson<String>(json['descFR']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nutrientId': serializer.toJson<int>(nutrientId),
      'name': serializer.toJson<String>(name),
      'factor': serializer.toJson<double>(factor),
      'descEN': serializer.toJson<String>(descEN),
      'descFR': serializer.toJson<String>(descFR),
    };
  }

  Conversion copyWith(
          {int? id,
          int? nutrientId,
          String? name,
          double? factor,
          String? descEN,
          String? descFR}) =>
      Conversion(
        id: id ?? this.id,
        nutrientId: nutrientId ?? this.nutrientId,
        name: name ?? this.name,
        factor: factor ?? this.factor,
        descEN: descEN ?? this.descEN,
        descFR: descFR ?? this.descFR,
      );
  Conversion copyWithCompanion(ConversionsCompanion data) {
    return Conversion(
      id: data.id.present ? data.id.value : this.id,
      nutrientId:
          data.nutrientId.present ? data.nutrientId.value : this.nutrientId,
      name: data.name.present ? data.name.value : this.name,
      factor: data.factor.present ? data.factor.value : this.factor,
      descEN: data.descEN.present ? data.descEN.value : this.descEN,
      descFR: data.descFR.present ? data.descFR.value : this.descFR,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Conversion(')
          ..write('id: $id, ')
          ..write('nutrientId: $nutrientId, ')
          ..write('name: $name, ')
          ..write('factor: $factor, ')
          ..write('descEN: $descEN, ')
          ..write('descFR: $descFR')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nutrientId, name, factor, descEN, descFR);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Conversion &&
          other.id == this.id &&
          other.nutrientId == this.nutrientId &&
          other.name == this.name &&
          other.factor == this.factor &&
          other.descEN == this.descEN &&
          other.descFR == this.descFR);
}

class ConversionsCompanion extends UpdateCompanion<Conversion> {
  final Value<int> id;
  final Value<int> nutrientId;
  final Value<String> name;
  final Value<double> factor;
  final Value<String> descEN;
  final Value<String> descFR;
  const ConversionsCompanion({
    this.id = const Value.absent(),
    this.nutrientId = const Value.absent(),
    this.name = const Value.absent(),
    this.factor = const Value.absent(),
    this.descEN = const Value.absent(),
    this.descFR = const Value.absent(),
  });
  ConversionsCompanion.insert({
    this.id = const Value.absent(),
    required int nutrientId,
    required String name,
    this.factor = const Value.absent(),
    this.descEN = const Value.absent(),
    this.descFR = const Value.absent(),
  })  : nutrientId = Value(nutrientId),
        name = Value(name);
  static Insertable<Conversion> custom({
    Expression<int>? id,
    Expression<int>? nutrientId,
    Expression<String>? name,
    Expression<double>? factor,
    Expression<String>? descEN,
    Expression<String>? descFR,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nutrientId != null) 'nutrient_id': nutrientId,
      if (name != null) 'name': name,
      if (factor != null) 'factor': factor,
      if (descEN != null) 'descEN': descEN,
      if (descFR != null) 'descFR': descFR,
    });
  }

  ConversionsCompanion copyWith(
      {Value<int>? id,
      Value<int>? nutrientId,
      Value<String>? name,
      Value<double>? factor,
      Value<String>? descEN,
      Value<String>? descFR}) {
    return ConversionsCompanion(
      id: id ?? this.id,
      nutrientId: nutrientId ?? this.nutrientId,
      name: name ?? this.name,
      factor: factor ?? this.factor,
      descEN: descEN ?? this.descEN,
      descFR: descFR ?? this.descFR,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nutrientId.present) {
      map['nutrient_id'] = Variable<int>(nutrientId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (factor.present) {
      map['factor'] = Variable<double>(factor.value);
    }
    if (descEN.present) {
      map['descEN'] = Variable<String>(descEN.value);
    }
    if (descFR.present) {
      map['descFR'] = Variable<String>(descFR.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversionsCompanion(')
          ..write('id: $id, ')
          ..write('nutrientId: $nutrientId, ')
          ..write('name: $name, ')
          ..write('factor: $factor, ')
          ..write('descEN: $descEN, ')
          ..write('descFR: $descFR')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeStepsTable recipeSteps = $RecipeStepsTable(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $NutrientsTable nutrients = $NutrientsTable(this);
  late final $ConversionsTable conversions = $ConversionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [recipes, recipeSteps, ingredients, nutrients, conversions];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('recipe_steps', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('recipe_steps',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('ingredients', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  required String title,
  Value<String> source,
  Value<String> imagePath,
  Value<String> notes,
  Value<int> servings,
  Value<List<String>> tags,
  Value<int> category,
  Value<String> countryCode,
  Value<int> calories,
  Value<int> time,
  Value<int> month,
  Value<int> carbohydrates,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> source,
  Value<String> imagePath,
  Value<String> notes,
  Value<int> servings,
  Value<List<String>> tags,
  Value<int> category,
  Value<String> countryCode,
  Value<int> calories,
  Value<int> time,
  Value<int> month,
  Value<int> carbohydrates,
});

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, Recipe> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeStepsTable, List<RecipeStep>>
      _recipeStepsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.recipeSteps,
              aliasName:
                  $_aliasNameGenerator(db.recipes.id, db.recipeSteps.recipeId));

  $$RecipeStepsTableProcessedTableManager get recipeStepsRefs {
    final manager = $$RecipeStepsTableTableManager($_db, $_db.recipeSteps)
        .filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeStepsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
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

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get tags =>
      $composableBuilder(
          column: $table.tags,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get countryCode => $composableBuilder(
      column: $table.countryCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get carbohydrates => $composableBuilder(
      column: $table.carbohydrates, builder: (column) => ColumnFilters(column));

  Expression<bool> recipeStepsRefs(
      Expression<bool> Function($$RecipeStepsTableFilterComposer f) f) {
    final $$RecipeStepsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeSteps,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeStepsTableFilterComposer(
              $db: $db,
              $table: $db.recipeSteps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
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

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get servings => $composableBuilder(
      column: $table.servings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get countryCode => $composableBuilder(
      column: $table.countryCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get calories => $composableBuilder(
      column: $table.calories, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month => $composableBuilder(
      column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get carbohydrates => $composableBuilder(
      column: $table.carbohydrates,
      builder: (column) => ColumnOrderings(column));
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
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

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get countryCode => $composableBuilder(
      column: $table.countryCode, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<int> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get carbohydrates => $composableBuilder(
      column: $table.carbohydrates, builder: (column) => column);

  Expression<T> recipeStepsRefs<T extends Object>(
      Expression<T> Function($$RecipeStepsTableAnnotationComposer a) f) {
    final $$RecipeStepsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.recipeSteps,
        getReferencedColumn: (t) => t.recipeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeStepsTableAnnotationComposer(
              $db: $db,
              $table: $db.recipeSteps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecipesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipesTable,
    Recipe,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (Recipe, $$RecipesTableReferences),
    Recipe,
    PrefetchHooks Function({bool recipeStepsRefs})> {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> imagePath = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> servings = const Value.absent(),
            Value<List<String>> tags = const Value.absent(),
            Value<int> category = const Value.absent(),
            Value<String> countryCode = const Value.absent(),
            Value<int> calories = const Value.absent(),
            Value<int> time = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<int> carbohydrates = const Value.absent(),
          }) =>
              RecipesCompanion(
            id: id,
            title: title,
            source: source,
            imagePath: imagePath,
            notes: notes,
            servings: servings,
            tags: tags,
            category: category,
            countryCode: countryCode,
            calories: calories,
            time: time,
            month: month,
            carbohydrates: carbohydrates,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            Value<String> source = const Value.absent(),
            Value<String> imagePath = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> servings = const Value.absent(),
            Value<List<String>> tags = const Value.absent(),
            Value<int> category = const Value.absent(),
            Value<String> countryCode = const Value.absent(),
            Value<int> calories = const Value.absent(),
            Value<int> time = const Value.absent(),
            Value<int> month = const Value.absent(),
            Value<int> carbohydrates = const Value.absent(),
          }) =>
              RecipesCompanion.insert(
            id: id,
            title: title,
            source: source,
            imagePath: imagePath,
            notes: notes,
            servings: servings,
            tags: tags,
            category: category,
            countryCode: countryCode,
            calories: calories,
            time: time,
            month: month,
            carbohydrates: carbohydrates,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$RecipesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({recipeStepsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (recipeStepsRefs) db.recipeSteps],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recipeStepsRefs)
                    await $_getPrefetchedData<Recipe, $RecipesTable,
                            RecipeStep>(
                        currentTable: table,
                        referencedTable:
                            $$RecipesTableReferences._recipeStepsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecipesTableReferences(db, table, p0)
                                .recipeStepsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.recipeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RecipesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipesTable,
    Recipe,
    $$RecipesTableFilterComposer,
    $$RecipesTableOrderingComposer,
    $$RecipesTableAnnotationComposer,
    $$RecipesTableCreateCompanionBuilder,
    $$RecipesTableUpdateCompanionBuilder,
    (Recipe, $$RecipesTableReferences),
    Recipe,
    PrefetchHooks Function({bool recipeStepsRefs})>;
typedef $$RecipeStepsTableCreateCompanionBuilder = RecipeStepsCompanion
    Function({
  Value<int> id,
  required int recipeId,
  Value<String> name,
  Value<String> instruction,
  Value<String> imagePath,
  Value<int> timer,
  required int stepOrder,
});
typedef $$RecipeStepsTableUpdateCompanionBuilder = RecipeStepsCompanion
    Function({
  Value<int> id,
  Value<int> recipeId,
  Value<String> name,
  Value<String> instruction,
  Value<String> imagePath,
  Value<int> timer,
  Value<int> stepOrder,
});

final class $$RecipeStepsTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeStepsTable, RecipeStep> {
  $$RecipeStepsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias(
          $_aliasNameGenerator(db.recipeSteps.recipeId, db.recipes.id));

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager($_db, $_db.recipes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$IngredientsTable, List<Ingredient>>
      _ingredientsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.ingredients,
              aliasName: $_aliasNameGenerator(
                  db.recipeSteps.id, db.ingredients.recipeStepId));

  $$IngredientsTableProcessedTableManager get ingredientsRefs {
    final manager = $$IngredientsTableTableManager($_db, $_db.ingredients)
        .filter((f) => f.recipeStepId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ingredientsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RecipeStepsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instruction => $composableBuilder(
      column: $table.instruction, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timer => $composableBuilder(
      column: $table.timer, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stepOrder => $composableBuilder(
      column: $table.stepOrder, builder: (column) => ColumnFilters(column));

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableFilterComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> ingredientsRefs(
      Expression<bool> Function($$IngredientsTableFilterComposer f) f) {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.recipeStepId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableFilterComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecipeStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instruction => $composableBuilder(
      column: $table.instruction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timer => $composableBuilder(
      column: $table.timer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stepOrder => $composableBuilder(
      column: $table.stepOrder, builder: (column) => ColumnOrderings(column));

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableOrderingComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RecipeStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get instruction => $composableBuilder(
      column: $table.instruction, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get timer =>
      $composableBuilder(column: $table.timer, builder: (column) => column);

  GeneratedColumn<int> get stepOrder =>
      $composableBuilder(column: $table.stepOrder, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeId,
        referencedTable: $db.recipes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipesTableAnnotationComposer(
              $db: $db,
              $table: $db.recipes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> ingredientsRefs<T extends Object>(
      Expression<T> Function($$IngredientsTableAnnotationComposer a) f) {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.ingredients,
        getReferencedColumn: (t) => t.recipeStepId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$IngredientsTableAnnotationComposer(
              $db: $db,
              $table: $db.ingredients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecipeStepsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipeStepsTable,
    RecipeStep,
    $$RecipeStepsTableFilterComposer,
    $$RecipeStepsTableOrderingComposer,
    $$RecipeStepsTableAnnotationComposer,
    $$RecipeStepsTableCreateCompanionBuilder,
    $$RecipeStepsTableUpdateCompanionBuilder,
    (RecipeStep, $$RecipeStepsTableReferences),
    RecipeStep,
    PrefetchHooks Function({bool recipeId, bool ingredientsRefs})> {
  $$RecipeStepsTableTableManager(_$AppDatabase db, $RecipeStepsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> recipeId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> instruction = const Value.absent(),
            Value<String> imagePath = const Value.absent(),
            Value<int> timer = const Value.absent(),
            Value<int> stepOrder = const Value.absent(),
          }) =>
              RecipeStepsCompanion(
            id: id,
            recipeId: recipeId,
            name: name,
            instruction: instruction,
            imagePath: imagePath,
            timer: timer,
            stepOrder: stepOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int recipeId,
            Value<String> name = const Value.absent(),
            Value<String> instruction = const Value.absent(),
            Value<String> imagePath = const Value.absent(),
            Value<int> timer = const Value.absent(),
            required int stepOrder,
          }) =>
              RecipeStepsCompanion.insert(
            id: id,
            recipeId: recipeId,
            name: name,
            instruction: instruction,
            imagePath: imagePath,
            timer: timer,
            stepOrder: stepOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecipeStepsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({recipeId = false, ingredientsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ingredientsRefs) db.ingredients],
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
                if (recipeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recipeId,
                    referencedTable:
                        $$RecipeStepsTableReferences._recipeIdTable(db),
                    referencedColumn:
                        $$RecipeStepsTableReferences._recipeIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ingredientsRefs)
                    await $_getPrefetchedData<RecipeStep, $RecipeStepsTable,
                            Ingredient>(
                        currentTable: table,
                        referencedTable: $$RecipeStepsTableReferences
                            ._ingredientsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecipeStepsTableReferences(db, table, p0)
                                .ingredientsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.recipeStepId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RecipeStepsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipeStepsTable,
    RecipeStep,
    $$RecipeStepsTableFilterComposer,
    $$RecipeStepsTableOrderingComposer,
    $$RecipeStepsTableAnnotationComposer,
    $$RecipeStepsTableCreateCompanionBuilder,
    $$RecipeStepsTableUpdateCompanionBuilder,
    (RecipeStep, $$RecipeStepsTableReferences),
    RecipeStep,
    PrefetchHooks Function({bool recipeId, bool ingredientsRefs})>;
typedef $$IngredientsTableCreateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  required int recipeStepId,
  Value<String> name,
  Value<String> unit,
  Value<double> quantity,
  Value<String> shape,
  Value<int> foodId,
  Value<int> selectedFactorId,
  required int ingredientOrder,
});
typedef $$IngredientsTableUpdateCompanionBuilder = IngredientsCompanion
    Function({
  Value<int> id,
  Value<int> recipeStepId,
  Value<String> name,
  Value<String> unit,
  Value<double> quantity,
  Value<String> shape,
  Value<int> foodId,
  Value<int> selectedFactorId,
  Value<int> ingredientOrder,
});

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipeStepsTable _recipeStepIdTable(_$AppDatabase db) =>
      db.recipeSteps.createAlias(
          $_aliasNameGenerator(db.ingredients.recipeStepId, db.recipeSteps.id));

  $$RecipeStepsTableProcessedTableManager get recipeStepId {
    final $_column = $_itemColumn<int>('recipe_step_id')!;

    final manager = $$RecipeStepsTableTableManager($_db, $_db.recipeSteps)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeStepIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shape => $composableBuilder(
      column: $table.shape, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get foodId => $composableBuilder(
      column: $table.foodId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get selectedFactorId => $composableBuilder(
      column: $table.selectedFactorId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ingredientOrder => $composableBuilder(
      column: $table.ingredientOrder,
      builder: (column) => ColumnFilters(column));

  $$RecipeStepsTableFilterComposer get recipeStepId {
    final $$RecipeStepsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeStepId,
        referencedTable: $db.recipeSteps,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeStepsTableFilterComposer(
              $db: $db,
              $table: $db.recipeSteps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shape => $composableBuilder(
      column: $table.shape, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get foodId => $composableBuilder(
      column: $table.foodId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get selectedFactorId => $composableBuilder(
      column: $table.selectedFactorId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ingredientOrder => $composableBuilder(
      column: $table.ingredientOrder,
      builder: (column) => ColumnOrderings(column));

  $$RecipeStepsTableOrderingComposer get recipeStepId {
    final $$RecipeStepsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeStepId,
        referencedTable: $db.recipeSteps,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeStepsTableOrderingComposer(
              $db: $db,
              $table: $db.recipeSteps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get shape =>
      $composableBuilder(column: $table.shape, builder: (column) => column);

  GeneratedColumn<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<int> get selectedFactorId => $composableBuilder(
      column: $table.selectedFactorId, builder: (column) => column);

  GeneratedColumn<int> get ingredientOrder => $composableBuilder(
      column: $table.ingredientOrder, builder: (column) => column);

  $$RecipeStepsTableAnnotationComposer get recipeStepId {
    final $$RecipeStepsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.recipeStepId,
        referencedTable: $db.recipeSteps,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecipeStepsTableAnnotationComposer(
              $db: $db,
              $table: $db.recipeSteps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$IngredientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $IngredientsTable,
    Ingredient,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (Ingredient, $$IngredientsTableReferences),
    Ingredient,
    PrefetchHooks Function({bool recipeStepId})> {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> recipeStepId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> shape = const Value.absent(),
            Value<int> foodId = const Value.absent(),
            Value<int> selectedFactorId = const Value.absent(),
            Value<int> ingredientOrder = const Value.absent(),
          }) =>
              IngredientsCompanion(
            id: id,
            recipeStepId: recipeStepId,
            name: name,
            unit: unit,
            quantity: quantity,
            shape: shape,
            foodId: foodId,
            selectedFactorId: selectedFactorId,
            ingredientOrder: ingredientOrder,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int recipeStepId,
            Value<String> name = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> shape = const Value.absent(),
            Value<int> foodId = const Value.absent(),
            Value<int> selectedFactorId = const Value.absent(),
            required int ingredientOrder,
          }) =>
              IngredientsCompanion.insert(
            id: id,
            recipeStepId: recipeStepId,
            name: name,
            unit: unit,
            quantity: quantity,
            shape: shape,
            foodId: foodId,
            selectedFactorId: selectedFactorId,
            ingredientOrder: ingredientOrder,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$IngredientsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({recipeStepId = false}) {
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
                if (recipeStepId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.recipeStepId,
                    referencedTable:
                        $$IngredientsTableReferences._recipeStepIdTable(db),
                    referencedColumn:
                        $$IngredientsTableReferences._recipeStepIdTable(db).id,
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

typedef $$IngredientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $IngredientsTable,
    Ingredient,
    $$IngredientsTableFilterComposer,
    $$IngredientsTableOrderingComposer,
    $$IngredientsTableAnnotationComposer,
    $$IngredientsTableCreateCompanionBuilder,
    $$IngredientsTableUpdateCompanionBuilder,
    (Ingredient, $$IngredientsTableReferences),
    Ingredient,
    PrefetchHooks Function({bool recipeStepId})>;
typedef $$NutrientsTableCreateCompanionBuilder = NutrientsCompanion Function({
  Value<int> id,
  required String descEN,
  required String descFR,
  Value<double> proteins,
  Value<double> water,
  Value<double> fat,
  Value<double> energKcal,
  Value<double> carbohydrates,
});
typedef $$NutrientsTableUpdateCompanionBuilder = NutrientsCompanion Function({
  Value<int> id,
  Value<String> descEN,
  Value<String> descFR,
  Value<double> proteins,
  Value<double> water,
  Value<double> fat,
  Value<double> energKcal,
  Value<double> carbohydrates,
});

final class $$NutrientsTableReferences
    extends BaseReferences<_$AppDatabase, $NutrientsTable, Nutrient> {
  $$NutrientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ConversionsTable, List<Conversion>>
      _conversionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.conversions,
          aliasName:
              $_aliasNameGenerator(db.nutrients.id, db.conversions.nutrientId));

  $$ConversionsTableProcessedTableManager get conversionsRefs {
    final manager = $$ConversionsTableTableManager($_db, $_db.conversions)
        .filter((f) => f.nutrientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_conversionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$NutrientsTableFilterComposer
    extends Composer<_$AppDatabase, $NutrientsTable> {
  $$NutrientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descEN => $composableBuilder(
      column: $table.descEN, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descFR => $composableBuilder(
      column: $table.descFR, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get proteins => $composableBuilder(
      column: $table.proteins, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get water => $composableBuilder(
      column: $table.water, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get energKcal => $composableBuilder(
      column: $table.energKcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbohydrates => $composableBuilder(
      column: $table.carbohydrates, builder: (column) => ColumnFilters(column));

  Expression<bool> conversionsRefs(
      Expression<bool> Function($$ConversionsTableFilterComposer f) f) {
    final $$ConversionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.conversions,
        getReferencedColumn: (t) => t.nutrientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConversionsTableFilterComposer(
              $db: $db,
              $table: $db.conversions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$NutrientsTableOrderingComposer
    extends Composer<_$AppDatabase, $NutrientsTable> {
  $$NutrientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descEN => $composableBuilder(
      column: $table.descEN, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descFR => $composableBuilder(
      column: $table.descFR, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get proteins => $composableBuilder(
      column: $table.proteins, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get water => $composableBuilder(
      column: $table.water, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fat => $composableBuilder(
      column: $table.fat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get energKcal => $composableBuilder(
      column: $table.energKcal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbohydrates => $composableBuilder(
      column: $table.carbohydrates,
      builder: (column) => ColumnOrderings(column));
}

class $$NutrientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NutrientsTable> {
  $$NutrientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get descEN =>
      $composableBuilder(column: $table.descEN, builder: (column) => column);

  GeneratedColumn<String> get descFR =>
      $composableBuilder(column: $table.descFR, builder: (column) => column);

  GeneratedColumn<double> get proteins =>
      $composableBuilder(column: $table.proteins, builder: (column) => column);

  GeneratedColumn<double> get water =>
      $composableBuilder(column: $table.water, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<double> get energKcal =>
      $composableBuilder(column: $table.energKcal, builder: (column) => column);

  GeneratedColumn<double> get carbohydrates => $composableBuilder(
      column: $table.carbohydrates, builder: (column) => column);

  Expression<T> conversionsRefs<T extends Object>(
      Expression<T> Function($$ConversionsTableAnnotationComposer a) f) {
    final $$ConversionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.conversions,
        getReferencedColumn: (t) => t.nutrientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConversionsTableAnnotationComposer(
              $db: $db,
              $table: $db.conversions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$NutrientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NutrientsTable,
    Nutrient,
    $$NutrientsTableFilterComposer,
    $$NutrientsTableOrderingComposer,
    $$NutrientsTableAnnotationComposer,
    $$NutrientsTableCreateCompanionBuilder,
    $$NutrientsTableUpdateCompanionBuilder,
    (Nutrient, $$NutrientsTableReferences),
    Nutrient,
    PrefetchHooks Function({bool conversionsRefs})> {
  $$NutrientsTableTableManager(_$AppDatabase db, $NutrientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NutrientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NutrientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutrientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> descEN = const Value.absent(),
            Value<String> descFR = const Value.absent(),
            Value<double> proteins = const Value.absent(),
            Value<double> water = const Value.absent(),
            Value<double> fat = const Value.absent(),
            Value<double> energKcal = const Value.absent(),
            Value<double> carbohydrates = const Value.absent(),
          }) =>
              NutrientsCompanion(
            id: id,
            descEN: descEN,
            descFR: descFR,
            proteins: proteins,
            water: water,
            fat: fat,
            energKcal: energKcal,
            carbohydrates: carbohydrates,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String descEN,
            required String descFR,
            Value<double> proteins = const Value.absent(),
            Value<double> water = const Value.absent(),
            Value<double> fat = const Value.absent(),
            Value<double> energKcal = const Value.absent(),
            Value<double> carbohydrates = const Value.absent(),
          }) =>
              NutrientsCompanion.insert(
            id: id,
            descEN: descEN,
            descFR: descFR,
            proteins: proteins,
            water: water,
            fat: fat,
            energKcal: energKcal,
            carbohydrates: carbohydrates,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$NutrientsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({conversionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (conversionsRefs) db.conversions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (conversionsRefs)
                    await $_getPrefetchedData<Nutrient, $NutrientsTable,
                            Conversion>(
                        currentTable: table,
                        referencedTable: $$NutrientsTableReferences
                            ._conversionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$NutrientsTableReferences(db, table, p0)
                                .conversionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.nutrientId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$NutrientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NutrientsTable,
    Nutrient,
    $$NutrientsTableFilterComposer,
    $$NutrientsTableOrderingComposer,
    $$NutrientsTableAnnotationComposer,
    $$NutrientsTableCreateCompanionBuilder,
    $$NutrientsTableUpdateCompanionBuilder,
    (Nutrient, $$NutrientsTableReferences),
    Nutrient,
    PrefetchHooks Function({bool conversionsRefs})>;
typedef $$ConversionsTableCreateCompanionBuilder = ConversionsCompanion
    Function({
  Value<int> id,
  required int nutrientId,
  required String name,
  Value<double> factor,
  Value<String> descEN,
  Value<String> descFR,
});
typedef $$ConversionsTableUpdateCompanionBuilder = ConversionsCompanion
    Function({
  Value<int> id,
  Value<int> nutrientId,
  Value<String> name,
  Value<double> factor,
  Value<String> descEN,
  Value<String> descFR,
});

final class $$ConversionsTableReferences
    extends BaseReferences<_$AppDatabase, $ConversionsTable, Conversion> {
  $$ConversionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NutrientsTable _nutrientIdTable(_$AppDatabase db) =>
      db.nutrients.createAlias(
          $_aliasNameGenerator(db.conversions.nutrientId, db.nutrients.id));

  $$NutrientsTableProcessedTableManager get nutrientId {
    final $_column = $_itemColumn<int>('nutrient_id')!;

    final manager = $$NutrientsTableTableManager($_db, $_db.nutrients)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_nutrientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ConversionsTableFilterComposer
    extends Composer<_$AppDatabase, $ConversionsTable> {
  $$ConversionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get factor => $composableBuilder(
      column: $table.factor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descEN => $composableBuilder(
      column: $table.descEN, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descFR => $composableBuilder(
      column: $table.descFR, builder: (column) => ColumnFilters(column));

  $$NutrientsTableFilterComposer get nutrientId {
    final $$NutrientsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.nutrientId,
        referencedTable: $db.nutrients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NutrientsTableFilterComposer(
              $db: $db,
              $table: $db.nutrients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ConversionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversionsTable> {
  $$ConversionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get factor => $composableBuilder(
      column: $table.factor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descEN => $composableBuilder(
      column: $table.descEN, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descFR => $composableBuilder(
      column: $table.descFR, builder: (column) => ColumnOrderings(column));

  $$NutrientsTableOrderingComposer get nutrientId {
    final $$NutrientsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.nutrientId,
        referencedTable: $db.nutrients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NutrientsTableOrderingComposer(
              $db: $db,
              $table: $db.nutrients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ConversionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversionsTable> {
  $$ConversionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get factor =>
      $composableBuilder(column: $table.factor, builder: (column) => column);

  GeneratedColumn<String> get descEN =>
      $composableBuilder(column: $table.descEN, builder: (column) => column);

  GeneratedColumn<String> get descFR =>
      $composableBuilder(column: $table.descFR, builder: (column) => column);

  $$NutrientsTableAnnotationComposer get nutrientId {
    final $$NutrientsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.nutrientId,
        referencedTable: $db.nutrients,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$NutrientsTableAnnotationComposer(
              $db: $db,
              $table: $db.nutrients,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ConversionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ConversionsTable,
    Conversion,
    $$ConversionsTableFilterComposer,
    $$ConversionsTableOrderingComposer,
    $$ConversionsTableAnnotationComposer,
    $$ConversionsTableCreateCompanionBuilder,
    $$ConversionsTableUpdateCompanionBuilder,
    (Conversion, $$ConversionsTableReferences),
    Conversion,
    PrefetchHooks Function({bool nutrientId})> {
  $$ConversionsTableTableManager(_$AppDatabase db, $ConversionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> nutrientId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> factor = const Value.absent(),
            Value<String> descEN = const Value.absent(),
            Value<String> descFR = const Value.absent(),
          }) =>
              ConversionsCompanion(
            id: id,
            nutrientId: nutrientId,
            name: name,
            factor: factor,
            descEN: descEN,
            descFR: descFR,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int nutrientId,
            required String name,
            Value<double> factor = const Value.absent(),
            Value<String> descEN = const Value.absent(),
            Value<String> descFR = const Value.absent(),
          }) =>
              ConversionsCompanion.insert(
            id: id,
            nutrientId: nutrientId,
            name: name,
            factor: factor,
            descEN: descEN,
            descFR: descFR,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ConversionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({nutrientId = false}) {
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
                if (nutrientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.nutrientId,
                    referencedTable:
                        $$ConversionsTableReferences._nutrientIdTable(db),
                    referencedColumn:
                        $$ConversionsTableReferences._nutrientIdTable(db).id,
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

typedef $$ConversionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ConversionsTable,
    Conversion,
    $$ConversionsTableFilterComposer,
    $$ConversionsTableOrderingComposer,
    $$ConversionsTableAnnotationComposer,
    $$ConversionsTableCreateCompanionBuilder,
    $$ConversionsTableUpdateCompanionBuilder,
    (Conversion, $$ConversionsTableReferences),
    Conversion,
    PrefetchHooks Function({bool nutrientId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeStepsTableTableManager get recipeSteps =>
      $$RecipeStepsTableTableManager(_db, _db.recipeSteps);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$NutrientsTableTableManager get nutrients =>
      $$NutrientsTableTableManager(_db, _db.nutrients);
  $$ConversionsTableTableManager get conversions =>
      $$ConversionsTableTableManager(_db, _db.conversions);
}
