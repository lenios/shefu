// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RecipesTable extends Recipes with TableInfo<$RecipesTable, RecipeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
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
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta('servings');
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
    'servings',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _piecesPerServingMeta = const VerificationMeta('piecesPerServing');
  @override
  late final GeneratedColumn<int> piecesPerServing = GeneratedColumn<int>(
    'pieces_per_serving',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countryCodeMeta = const VerificationMeta('countryCode');
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
    'country_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta('calories');
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<int> fat = GeneratedColumn<int>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbohydratesMeta = const VerificationMeta('carbohydrates');
  @override
  late final GeneratedColumn<int> carbohydrates = GeneratedColumn<int>(
    'carbohydrates',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta('protein');
  @override
  late final GeneratedColumn<int> protein = GeneratedColumn<int>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saturatedFatMeta = const VerificationMeta('saturatedFat');
  @override
  late final GeneratedColumn<int> saturatedFat = GeneratedColumn<int>(
    'saturated_fat',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transFatMeta = const VerificationMeta('transFat');
  @override
  late final GeneratedColumn<int> transFat = GeneratedColumn<int>(
    'trans_fat',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sugarMeta = const VerificationMeta('sugar');
  @override
  late final GeneratedColumn<int> sugar = GeneratedColumn<int>(
    'sugar',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiberMeta = const VerificationMeta('fiber');
  @override
  late final GeneratedColumn<int> fiber = GeneratedColumn<int>(
    'fiber',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cholesterolMeta = const VerificationMeta('cholesterol');
  @override
  late final GeneratedColumn<int> cholesterol = GeneratedColumn<int>(
    'cholesterol',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sodiumMeta = const VerificationMeta('sodium');
  @override
  late final GeneratedColumn<int> sodium = GeneratedColumn<int>(
    'sodium',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cookTimeMeta = const VerificationMeta('cookTime');
  @override
  late final GeneratedColumn<int> cookTime = GeneratedColumn<int>(
    'cook_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prepTimeMeta = const VerificationMeta('prepTime');
  @override
  late final GeneratedColumn<int> prepTime = GeneratedColumn<int>(
    'prep_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _restTimeMeta = const VerificationMeta('restTime');
  @override
  late final GeneratedColumn<int> restTime = GeneratedColumn<int>(
    'rest_time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _makeAheadMeta = const VerificationMeta('makeAhead');
  @override
  late final GeneratedColumn<String> makeAhead = GeneratedColumn<String>(
    'make_ahead',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _videoUrlMeta = const VerificationMeta('videoUrl');
  @override
  late final GeneratedColumn<String> videoUrl = GeneratedColumn<String>(
    'video_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> questions =
      GeneratedColumn<String>(
        'questions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($RecipesTable.$converterquestions);
  static const VerificationMeta _languageTagMeta = const VerificationMeta('languageTag');
  @override
  late final GeneratedColumn<String> languageTag = GeneratedColumn<String>(
    'language_tag',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    source,
    imagePath,
    notes,
    servings,
    piecesPerServing,
    category,
    countryCode,
    calories,
    fat,
    carbohydrates,
    protein,
    saturatedFat,
    transFat,
    sugar,
    fiber,
    cholesterol,
    sodium,
    time,
    cookTime,
    prepTime,
    restTime,
    month,
    makeAhead,
    videoUrl,
    questions,
    languageTag,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta, source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(_notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    } else if (isInserting) {
      context.missing(_notesMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    } else if (isInserting) {
      context.missing(_servingsMeta);
    }
    if (data.containsKey('pieces_per_serving')) {
      context.handle(
        _piecesPerServingMeta,
        piecesPerServing.isAcceptableOrUnknown(data['pieces_per_serving']!, _piecesPerServingMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('country_code')) {
      context.handle(
        _countryCodeMeta,
        countryCode.isAcceptableOrUnknown(data['country_code']!, _countryCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_countryCodeMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('fat')) {
      context.handle(_fatMeta, fat.isAcceptableOrUnknown(data['fat']!, _fatMeta));
    } else if (isInserting) {
      context.missing(_fatMeta);
    }
    if (data.containsKey('carbohydrates')) {
      context.handle(
        _carbohydratesMeta,
        carbohydrates.isAcceptableOrUnknown(data['carbohydrates']!, _carbohydratesMeta),
      );
    } else if (isInserting) {
      context.missing(_carbohydratesMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(_proteinMeta, protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta));
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('saturated_fat')) {
      context.handle(
        _saturatedFatMeta,
        saturatedFat.isAcceptableOrUnknown(data['saturated_fat']!, _saturatedFatMeta),
      );
    } else if (isInserting) {
      context.missing(_saturatedFatMeta);
    }
    if (data.containsKey('trans_fat')) {
      context.handle(
        _transFatMeta,
        transFat.isAcceptableOrUnknown(data['trans_fat']!, _transFatMeta),
      );
    } else if (isInserting) {
      context.missing(_transFatMeta);
    }
    if (data.containsKey('sugar')) {
      context.handle(_sugarMeta, sugar.isAcceptableOrUnknown(data['sugar']!, _sugarMeta));
    } else if (isInserting) {
      context.missing(_sugarMeta);
    }
    if (data.containsKey('fiber')) {
      context.handle(_fiberMeta, fiber.isAcceptableOrUnknown(data['fiber']!, _fiberMeta));
    } else if (isInserting) {
      context.missing(_fiberMeta);
    }
    if (data.containsKey('cholesterol')) {
      context.handle(
        _cholesterolMeta,
        cholesterol.isAcceptableOrUnknown(data['cholesterol']!, _cholesterolMeta),
      );
    } else if (isInserting) {
      context.missing(_cholesterolMeta);
    }
    if (data.containsKey('sodium')) {
      context.handle(_sodiumMeta, sodium.isAcceptableOrUnknown(data['sodium']!, _sodiumMeta));
    } else if (isInserting) {
      context.missing(_sodiumMeta);
    }
    if (data.containsKey('time')) {
      context.handle(_timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('cook_time')) {
      context.handle(
        _cookTimeMeta,
        cookTime.isAcceptableOrUnknown(data['cook_time']!, _cookTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_cookTimeMeta);
    }
    if (data.containsKey('prep_time')) {
      context.handle(
        _prepTimeMeta,
        prepTime.isAcceptableOrUnknown(data['prep_time']!, _prepTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_prepTimeMeta);
    }
    if (data.containsKey('rest_time')) {
      context.handle(
        _restTimeMeta,
        restTime.isAcceptableOrUnknown(data['rest_time']!, _restTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_restTimeMeta);
    }
    if (data.containsKey('month')) {
      context.handle(_monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('make_ahead')) {
      context.handle(
        _makeAheadMeta,
        makeAhead.isAcceptableOrUnknown(data['make_ahead']!, _makeAheadMeta),
      );
    } else if (isInserting) {
      context.missing(_makeAheadMeta);
    }
    if (data.containsKey('video_url')) {
      context.handle(
        _videoUrlMeta,
        videoUrl.isAcceptableOrUnknown(data['video_url']!, _videoUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_videoUrlMeta);
    }
    if (data.containsKey('language_tag')) {
      context.handle(
        _languageTagMeta,
        languageTag.isAcceptableOrUnknown(data['language_tag']!, _languageTagMeta),
      );
    } else if (isInserting) {
      context.missing(_languageTagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}servings'],
      )!,
      piecesPerServing: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pieces_per_serving'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category'],
      )!,
      countryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country_code'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
      fat: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}fat'])!,
      carbohydrates: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}carbohydrates'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}protein'],
      )!,
      saturatedFat: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}saturated_fat'],
      )!,
      transFat: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trans_fat'],
      )!,
      sugar: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sugar'])!,
      fiber: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}fiber'])!,
      cholesterol: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cholesterol'],
      )!,
      sodium: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sodium'],
      )!,
      time: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}time'])!,
      cookTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cook_time'],
      )!,
      prepTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prep_time'],
      )!,
      restTime: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_time'],
      )!,
      month: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}month'])!,
      makeAhead: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}make_ahead'],
      )!,
      videoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_url'],
      )!,
      questions: $RecipesTable.$converterquestions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}questions'],
        )!,
      ),
      languageTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_tag'],
      )!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterquestions = const StringListConverter();
}

class RecipeRow extends DataClass implements Insertable<RecipeRow> {
  final int id;
  final String title;
  final String source;
  final String imagePath;
  final String notes;
  final int servings;
  final int? piecesPerServing;
  final int category;
  final String countryCode;
  final int calories;
  final int fat;
  final int carbohydrates;
  final int protein;
  final int saturatedFat;
  final int transFat;
  final int sugar;
  final int fiber;
  final int cholesterol;
  final int sodium;
  final int time;
  final int cookTime;
  final int prepTime;
  final int restTime;
  final int month;
  final String makeAhead;
  final String videoUrl;
  final List<String> questions;
  final String languageTag;
  const RecipeRow({
    required this.id,
    required this.title,
    required this.source,
    required this.imagePath,
    required this.notes,
    required this.servings,
    this.piecesPerServing,
    required this.category,
    required this.countryCode,
    required this.calories,
    required this.fat,
    required this.carbohydrates,
    required this.protein,
    required this.saturatedFat,
    required this.transFat,
    required this.sugar,
    required this.fiber,
    required this.cholesterol,
    required this.sodium,
    required this.time,
    required this.cookTime,
    required this.prepTime,
    required this.restTime,
    required this.month,
    required this.makeAhead,
    required this.videoUrl,
    required this.questions,
    required this.languageTag,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['source'] = Variable<String>(source);
    map['image_path'] = Variable<String>(imagePath);
    map['notes'] = Variable<String>(notes);
    map['servings'] = Variable<int>(servings);
    if (!nullToAbsent || piecesPerServing != null) {
      map['pieces_per_serving'] = Variable<int>(piecesPerServing);
    }
    map['category'] = Variable<int>(category);
    map['country_code'] = Variable<String>(countryCode);
    map['calories'] = Variable<int>(calories);
    map['fat'] = Variable<int>(fat);
    map['carbohydrates'] = Variable<int>(carbohydrates);
    map['protein'] = Variable<int>(protein);
    map['saturated_fat'] = Variable<int>(saturatedFat);
    map['trans_fat'] = Variable<int>(transFat);
    map['sugar'] = Variable<int>(sugar);
    map['fiber'] = Variable<int>(fiber);
    map['cholesterol'] = Variable<int>(cholesterol);
    map['sodium'] = Variable<int>(sodium);
    map['time'] = Variable<int>(time);
    map['cook_time'] = Variable<int>(cookTime);
    map['prep_time'] = Variable<int>(prepTime);
    map['rest_time'] = Variable<int>(restTime);
    map['month'] = Variable<int>(month);
    map['make_ahead'] = Variable<String>(makeAhead);
    map['video_url'] = Variable<String>(videoUrl);
    {
      map['questions'] = Variable<String>($RecipesTable.$converterquestions.toSql(questions));
    }
    map['language_tag'] = Variable<String>(languageTag);
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
      piecesPerServing: piecesPerServing == null && nullToAbsent
          ? const Value.absent()
          : Value(piecesPerServing),
      category: Value(category),
      countryCode: Value(countryCode),
      calories: Value(calories),
      fat: Value(fat),
      carbohydrates: Value(carbohydrates),
      protein: Value(protein),
      saturatedFat: Value(saturatedFat),
      transFat: Value(transFat),
      sugar: Value(sugar),
      fiber: Value(fiber),
      cholesterol: Value(cholesterol),
      sodium: Value(sodium),
      time: Value(time),
      cookTime: Value(cookTime),
      prepTime: Value(prepTime),
      restTime: Value(restTime),
      month: Value(month),
      makeAhead: Value(makeAhead),
      videoUrl: Value(videoUrl),
      questions: Value(questions),
      languageTag: Value(languageTag),
    );
  }

  factory RecipeRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      source: serializer.fromJson<String>(json['source']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      notes: serializer.fromJson<String>(json['notes']),
      servings: serializer.fromJson<int>(json['servings']),
      piecesPerServing: serializer.fromJson<int?>(json['piecesPerServing']),
      category: serializer.fromJson<int>(json['category']),
      countryCode: serializer.fromJson<String>(json['countryCode']),
      calories: serializer.fromJson<int>(json['calories']),
      fat: serializer.fromJson<int>(json['fat']),
      carbohydrates: serializer.fromJson<int>(json['carbohydrates']),
      protein: serializer.fromJson<int>(json['protein']),
      saturatedFat: serializer.fromJson<int>(json['saturatedFat']),
      transFat: serializer.fromJson<int>(json['transFat']),
      sugar: serializer.fromJson<int>(json['sugar']),
      fiber: serializer.fromJson<int>(json['fiber']),
      cholesterol: serializer.fromJson<int>(json['cholesterol']),
      sodium: serializer.fromJson<int>(json['sodium']),
      time: serializer.fromJson<int>(json['time']),
      cookTime: serializer.fromJson<int>(json['cookTime']),
      prepTime: serializer.fromJson<int>(json['prepTime']),
      restTime: serializer.fromJson<int>(json['restTime']),
      month: serializer.fromJson<int>(json['month']),
      makeAhead: serializer.fromJson<String>(json['makeAhead']),
      videoUrl: serializer.fromJson<String>(json['videoUrl']),
      questions: serializer.fromJson<List<String>>(json['questions']),
      languageTag: serializer.fromJson<String>(json['languageTag']),
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
      'piecesPerServing': serializer.toJson<int?>(piecesPerServing),
      'category': serializer.toJson<int>(category),
      'countryCode': serializer.toJson<String>(countryCode),
      'calories': serializer.toJson<int>(calories),
      'fat': serializer.toJson<int>(fat),
      'carbohydrates': serializer.toJson<int>(carbohydrates),
      'protein': serializer.toJson<int>(protein),
      'saturatedFat': serializer.toJson<int>(saturatedFat),
      'transFat': serializer.toJson<int>(transFat),
      'sugar': serializer.toJson<int>(sugar),
      'fiber': serializer.toJson<int>(fiber),
      'cholesterol': serializer.toJson<int>(cholesterol),
      'sodium': serializer.toJson<int>(sodium),
      'time': serializer.toJson<int>(time),
      'cookTime': serializer.toJson<int>(cookTime),
      'prepTime': serializer.toJson<int>(prepTime),
      'restTime': serializer.toJson<int>(restTime),
      'month': serializer.toJson<int>(month),
      'makeAhead': serializer.toJson<String>(makeAhead),
      'videoUrl': serializer.toJson<String>(videoUrl),
      'questions': serializer.toJson<List<String>>(questions),
      'languageTag': serializer.toJson<String>(languageTag),
    };
  }

  RecipeRow copyWith({
    int? id,
    String? title,
    String? source,
    String? imagePath,
    String? notes,
    int? servings,
    Value<int?> piecesPerServing = const Value.absent(),
    int? category,
    String? countryCode,
    int? calories,
    int? fat,
    int? carbohydrates,
    int? protein,
    int? saturatedFat,
    int? transFat,
    int? sugar,
    int? fiber,
    int? cholesterol,
    int? sodium,
    int? time,
    int? cookTime,
    int? prepTime,
    int? restTime,
    int? month,
    String? makeAhead,
    String? videoUrl,
    List<String>? questions,
    String? languageTag,
  }) => RecipeRow(
    id: id ?? this.id,
    title: title ?? this.title,
    source: source ?? this.source,
    imagePath: imagePath ?? this.imagePath,
    notes: notes ?? this.notes,
    servings: servings ?? this.servings,
    piecesPerServing: piecesPerServing.present ? piecesPerServing.value : this.piecesPerServing,
    category: category ?? this.category,
    countryCode: countryCode ?? this.countryCode,
    calories: calories ?? this.calories,
    fat: fat ?? this.fat,
    carbohydrates: carbohydrates ?? this.carbohydrates,
    protein: protein ?? this.protein,
    saturatedFat: saturatedFat ?? this.saturatedFat,
    transFat: transFat ?? this.transFat,
    sugar: sugar ?? this.sugar,
    fiber: fiber ?? this.fiber,
    cholesterol: cholesterol ?? this.cholesterol,
    sodium: sodium ?? this.sodium,
    time: time ?? this.time,
    cookTime: cookTime ?? this.cookTime,
    prepTime: prepTime ?? this.prepTime,
    restTime: restTime ?? this.restTime,
    month: month ?? this.month,
    makeAhead: makeAhead ?? this.makeAhead,
    videoUrl: videoUrl ?? this.videoUrl,
    questions: questions ?? this.questions,
    languageTag: languageTag ?? this.languageTag,
  );
  RecipeRow copyWithCompanion(RecipesCompanion data) {
    return RecipeRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      source: data.source.present ? data.source.value : this.source,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      notes: data.notes.present ? data.notes.value : this.notes,
      servings: data.servings.present ? data.servings.value : this.servings,
      piecesPerServing: data.piecesPerServing.present
          ? data.piecesPerServing.value
          : this.piecesPerServing,
      category: data.category.present ? data.category.value : this.category,
      countryCode: data.countryCode.present ? data.countryCode.value : this.countryCode,
      calories: data.calories.present ? data.calories.value : this.calories,
      fat: data.fat.present ? data.fat.value : this.fat,
      carbohydrates: data.carbohydrates.present ? data.carbohydrates.value : this.carbohydrates,
      protein: data.protein.present ? data.protein.value : this.protein,
      saturatedFat: data.saturatedFat.present ? data.saturatedFat.value : this.saturatedFat,
      transFat: data.transFat.present ? data.transFat.value : this.transFat,
      sugar: data.sugar.present ? data.sugar.value : this.sugar,
      fiber: data.fiber.present ? data.fiber.value : this.fiber,
      cholesterol: data.cholesterol.present ? data.cholesterol.value : this.cholesterol,
      sodium: data.sodium.present ? data.sodium.value : this.sodium,
      time: data.time.present ? data.time.value : this.time,
      cookTime: data.cookTime.present ? data.cookTime.value : this.cookTime,
      prepTime: data.prepTime.present ? data.prepTime.value : this.prepTime,
      restTime: data.restTime.present ? data.restTime.value : this.restTime,
      month: data.month.present ? data.month.value : this.month,
      makeAhead: data.makeAhead.present ? data.makeAhead.value : this.makeAhead,
      videoUrl: data.videoUrl.present ? data.videoUrl.value : this.videoUrl,
      questions: data.questions.present ? data.questions.value : this.questions,
      languageTag: data.languageTag.present ? data.languageTag.value : this.languageTag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('source: $source, ')
          ..write('imagePath: $imagePath, ')
          ..write('notes: $notes, ')
          ..write('servings: $servings, ')
          ..write('piecesPerServing: $piecesPerServing, ')
          ..write('category: $category, ')
          ..write('countryCode: $countryCode, ')
          ..write('calories: $calories, ')
          ..write('fat: $fat, ')
          ..write('carbohydrates: $carbohydrates, ')
          ..write('protein: $protein, ')
          ..write('saturatedFat: $saturatedFat, ')
          ..write('transFat: $transFat, ')
          ..write('sugar: $sugar, ')
          ..write('fiber: $fiber, ')
          ..write('cholesterol: $cholesterol, ')
          ..write('sodium: $sodium, ')
          ..write('time: $time, ')
          ..write('cookTime: $cookTime, ')
          ..write('prepTime: $prepTime, ')
          ..write('restTime: $restTime, ')
          ..write('month: $month, ')
          ..write('makeAhead: $makeAhead, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('questions: $questions, ')
          ..write('languageTag: $languageTag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    title,
    source,
    imagePath,
    notes,
    servings,
    piecesPerServing,
    category,
    countryCode,
    calories,
    fat,
    carbohydrates,
    protein,
    saturatedFat,
    transFat,
    sugar,
    fiber,
    cholesterol,
    sodium,
    time,
    cookTime,
    prepTime,
    restTime,
    month,
    makeAhead,
    videoUrl,
    questions,
    languageTag,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.source == this.source &&
          other.imagePath == this.imagePath &&
          other.notes == this.notes &&
          other.servings == this.servings &&
          other.piecesPerServing == this.piecesPerServing &&
          other.category == this.category &&
          other.countryCode == this.countryCode &&
          other.calories == this.calories &&
          other.fat == this.fat &&
          other.carbohydrates == this.carbohydrates &&
          other.protein == this.protein &&
          other.saturatedFat == this.saturatedFat &&
          other.transFat == this.transFat &&
          other.sugar == this.sugar &&
          other.fiber == this.fiber &&
          other.cholesterol == this.cholesterol &&
          other.sodium == this.sodium &&
          other.time == this.time &&
          other.cookTime == this.cookTime &&
          other.prepTime == this.prepTime &&
          other.restTime == this.restTime &&
          other.month == this.month &&
          other.makeAhead == this.makeAhead &&
          other.videoUrl == this.videoUrl &&
          other.questions == this.questions &&
          other.languageTag == this.languageTag);
}

class RecipesCompanion extends UpdateCompanion<RecipeRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> source;
  final Value<String> imagePath;
  final Value<String> notes;
  final Value<int> servings;
  final Value<int?> piecesPerServing;
  final Value<int> category;
  final Value<String> countryCode;
  final Value<int> calories;
  final Value<int> fat;
  final Value<int> carbohydrates;
  final Value<int> protein;
  final Value<int> saturatedFat;
  final Value<int> transFat;
  final Value<int> sugar;
  final Value<int> fiber;
  final Value<int> cholesterol;
  final Value<int> sodium;
  final Value<int> time;
  final Value<int> cookTime;
  final Value<int> prepTime;
  final Value<int> restTime;
  final Value<int> month;
  final Value<String> makeAhead;
  final Value<String> videoUrl;
  final Value<List<String>> questions;
  final Value<String> languageTag;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.source = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.notes = const Value.absent(),
    this.servings = const Value.absent(),
    this.piecesPerServing = const Value.absent(),
    this.category = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.calories = const Value.absent(),
    this.fat = const Value.absent(),
    this.carbohydrates = const Value.absent(),
    this.protein = const Value.absent(),
    this.saturatedFat = const Value.absent(),
    this.transFat = const Value.absent(),
    this.sugar = const Value.absent(),
    this.fiber = const Value.absent(),
    this.cholesterol = const Value.absent(),
    this.sodium = const Value.absent(),
    this.time = const Value.absent(),
    this.cookTime = const Value.absent(),
    this.prepTime = const Value.absent(),
    this.restTime = const Value.absent(),
    this.month = const Value.absent(),
    this.makeAhead = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.questions = const Value.absent(),
    this.languageTag = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String source,
    required String imagePath,
    required String notes,
    required int servings,
    this.piecesPerServing = const Value.absent(),
    required int category,
    required String countryCode,
    required int calories,
    required int fat,
    required int carbohydrates,
    required int protein,
    required int saturatedFat,
    required int transFat,
    required int sugar,
    required int fiber,
    required int cholesterol,
    required int sodium,
    required int time,
    required int cookTime,
    required int prepTime,
    required int restTime,
    required int month,
    required String makeAhead,
    required String videoUrl,
    required List<String> questions,
    required String languageTag,
  }) : title = Value(title),
       source = Value(source),
       imagePath = Value(imagePath),
       notes = Value(notes),
       servings = Value(servings),
       category = Value(category),
       countryCode = Value(countryCode),
       calories = Value(calories),
       fat = Value(fat),
       carbohydrates = Value(carbohydrates),
       protein = Value(protein),
       saturatedFat = Value(saturatedFat),
       transFat = Value(transFat),
       sugar = Value(sugar),
       fiber = Value(fiber),
       cholesterol = Value(cholesterol),
       sodium = Value(sodium),
       time = Value(time),
       cookTime = Value(cookTime),
       prepTime = Value(prepTime),
       restTime = Value(restTime),
       month = Value(month),
       makeAhead = Value(makeAhead),
       videoUrl = Value(videoUrl),
       questions = Value(questions),
       languageTag = Value(languageTag);
  static Insertable<RecipeRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? source,
    Expression<String>? imagePath,
    Expression<String>? notes,
    Expression<int>? servings,
    Expression<int>? piecesPerServing,
    Expression<int>? category,
    Expression<String>? countryCode,
    Expression<int>? calories,
    Expression<int>? fat,
    Expression<int>? carbohydrates,
    Expression<int>? protein,
    Expression<int>? saturatedFat,
    Expression<int>? transFat,
    Expression<int>? sugar,
    Expression<int>? fiber,
    Expression<int>? cholesterol,
    Expression<int>? sodium,
    Expression<int>? time,
    Expression<int>? cookTime,
    Expression<int>? prepTime,
    Expression<int>? restTime,
    Expression<int>? month,
    Expression<String>? makeAhead,
    Expression<String>? videoUrl,
    Expression<String>? questions,
    Expression<String>? languageTag,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (source != null) 'source': source,
      if (imagePath != null) 'image_path': imagePath,
      if (notes != null) 'notes': notes,
      if (servings != null) 'servings': servings,
      if (piecesPerServing != null) 'pieces_per_serving': piecesPerServing,
      if (category != null) 'category': category,
      if (countryCode != null) 'country_code': countryCode,
      if (calories != null) 'calories': calories,
      if (fat != null) 'fat': fat,
      if (carbohydrates != null) 'carbohydrates': carbohydrates,
      if (protein != null) 'protein': protein,
      if (saturatedFat != null) 'saturated_fat': saturatedFat,
      if (transFat != null) 'trans_fat': transFat,
      if (sugar != null) 'sugar': sugar,
      if (fiber != null) 'fiber': fiber,
      if (cholesterol != null) 'cholesterol': cholesterol,
      if (sodium != null) 'sodium': sodium,
      if (time != null) 'time': time,
      if (cookTime != null) 'cook_time': cookTime,
      if (prepTime != null) 'prep_time': prepTime,
      if (restTime != null) 'rest_time': restTime,
      if (month != null) 'month': month,
      if (makeAhead != null) 'make_ahead': makeAhead,
      if (videoUrl != null) 'video_url': videoUrl,
      if (questions != null) 'questions': questions,
      if (languageTag != null) 'language_tag': languageTag,
    });
  }

  RecipesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? source,
    Value<String>? imagePath,
    Value<String>? notes,
    Value<int>? servings,
    Value<int?>? piecesPerServing,
    Value<int>? category,
    Value<String>? countryCode,
    Value<int>? calories,
    Value<int>? fat,
    Value<int>? carbohydrates,
    Value<int>? protein,
    Value<int>? saturatedFat,
    Value<int>? transFat,
    Value<int>? sugar,
    Value<int>? fiber,
    Value<int>? cholesterol,
    Value<int>? sodium,
    Value<int>? time,
    Value<int>? cookTime,
    Value<int>? prepTime,
    Value<int>? restTime,
    Value<int>? month,
    Value<String>? makeAhead,
    Value<String>? videoUrl,
    Value<List<String>>? questions,
    Value<String>? languageTag,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      source: source ?? this.source,
      imagePath: imagePath ?? this.imagePath,
      notes: notes ?? this.notes,
      servings: servings ?? this.servings,
      piecesPerServing: piecesPerServing ?? this.piecesPerServing,
      category: category ?? this.category,
      countryCode: countryCode ?? this.countryCode,
      calories: calories ?? this.calories,
      fat: fat ?? this.fat,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      protein: protein ?? this.protein,
      saturatedFat: saturatedFat ?? this.saturatedFat,
      transFat: transFat ?? this.transFat,
      sugar: sugar ?? this.sugar,
      fiber: fiber ?? this.fiber,
      cholesterol: cholesterol ?? this.cholesterol,
      sodium: sodium ?? this.sodium,
      time: time ?? this.time,
      cookTime: cookTime ?? this.cookTime,
      prepTime: prepTime ?? this.prepTime,
      restTime: restTime ?? this.restTime,
      month: month ?? this.month,
      makeAhead: makeAhead ?? this.makeAhead,
      videoUrl: videoUrl ?? this.videoUrl,
      questions: questions ?? this.questions,
      languageTag: languageTag ?? this.languageTag,
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
    if (piecesPerServing.present) {
      map['pieces_per_serving'] = Variable<int>(piecesPerServing.value);
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
    if (fat.present) {
      map['fat'] = Variable<int>(fat.value);
    }
    if (carbohydrates.present) {
      map['carbohydrates'] = Variable<int>(carbohydrates.value);
    }
    if (protein.present) {
      map['protein'] = Variable<int>(protein.value);
    }
    if (saturatedFat.present) {
      map['saturated_fat'] = Variable<int>(saturatedFat.value);
    }
    if (transFat.present) {
      map['trans_fat'] = Variable<int>(transFat.value);
    }
    if (sugar.present) {
      map['sugar'] = Variable<int>(sugar.value);
    }
    if (fiber.present) {
      map['fiber'] = Variable<int>(fiber.value);
    }
    if (cholesterol.present) {
      map['cholesterol'] = Variable<int>(cholesterol.value);
    }
    if (sodium.present) {
      map['sodium'] = Variable<int>(sodium.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (cookTime.present) {
      map['cook_time'] = Variable<int>(cookTime.value);
    }
    if (prepTime.present) {
      map['prep_time'] = Variable<int>(prepTime.value);
    }
    if (restTime.present) {
      map['rest_time'] = Variable<int>(restTime.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (makeAhead.present) {
      map['make_ahead'] = Variable<String>(makeAhead.value);
    }
    if (videoUrl.present) {
      map['video_url'] = Variable<String>(videoUrl.value);
    }
    if (questions.present) {
      map['questions'] = Variable<String>($RecipesTable.$converterquestions.toSql(questions.value));
    }
    if (languageTag.present) {
      map['language_tag'] = Variable<String>(languageTag.value);
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
          ..write('piecesPerServing: $piecesPerServing, ')
          ..write('category: $category, ')
          ..write('countryCode: $countryCode, ')
          ..write('calories: $calories, ')
          ..write('fat: $fat, ')
          ..write('carbohydrates: $carbohydrates, ')
          ..write('protein: $protein, ')
          ..write('saturatedFat: $saturatedFat, ')
          ..write('transFat: $transFat, ')
          ..write('sugar: $sugar, ')
          ..write('fiber: $fiber, ')
          ..write('cholesterol: $cholesterol, ')
          ..write('sodium: $sodium, ')
          ..write('time: $time, ')
          ..write('cookTime: $cookTime, ')
          ..write('prepTime: $prepTime, ')
          ..write('restTime: $restTime, ')
          ..write('month: $month, ')
          ..write('makeAhead: $makeAhead, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('questions: $questions, ')
          ..write('languageTag: $languageTag')
          ..write(')'))
        .toString();
  }
}

class $RecipeVariantsTable extends RecipeVariants
    with TableInfo<$RecipeVariantsTable, RecipeVariantRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeVariantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id) ON DELETE CASCADE',
    ),
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
  @override
  List<GeneratedColumn> get $columns => [id, recipeId, title];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_variants';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeVariantRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeVariantRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeVariantRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
    );
  }

  @override
  $RecipeVariantsTable createAlias(String alias) {
    return $RecipeVariantsTable(attachedDatabase, alias);
  }
}

class RecipeVariantRow extends DataClass implements Insertable<RecipeVariantRow> {
  final int id;
  final int recipeId;
  final String title;
  const RecipeVariantRow({required this.id, required this.recipeId, required this.title});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['title'] = Variable<String>(title);
    return map;
  }

  RecipeVariantsCompanion toCompanion(bool nullToAbsent) {
    return RecipeVariantsCompanion(id: Value(id), recipeId: Value(recipeId), title: Value(title));
  }

  factory RecipeVariantRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeVariantRow(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      title: serializer.fromJson<String>(json['title']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'title': serializer.toJson<String>(title),
    };
  }

  RecipeVariantRow copyWith({int? id, int? recipeId, String? title}) => RecipeVariantRow(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    title: title ?? this.title,
  );
  RecipeVariantRow copyWithCompanion(RecipeVariantsCompanion data) {
    return RecipeVariantRow(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      title: data.title.present ? data.title.value : this.title,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeVariantRow(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recipeId, title);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeVariantRow &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.title == this.title);
}

class RecipeVariantsCompanion extends UpdateCompanion<RecipeVariantRow> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<String> title;
  const RecipeVariantsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.title = const Value.absent(),
  });
  RecipeVariantsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required String title,
  }) : recipeId = Value(recipeId),
       title = Value(title);
  static Insertable<RecipeVariantRow> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<String>? title,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (title != null) 'title': title,
    });
  }

  RecipeVariantsCompanion copyWith({Value<int>? id, Value<int>? recipeId, Value<String>? title}) {
    return RecipeVariantsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      title: title ?? this.title,
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
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeVariantsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('title: $title')
          ..write(')'))
        .toString();
  }
}

class $RecipeStepsTable extends RecipeSteps with TableInfo<$RecipeStepsTable, RecipeStepRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _variantIdMeta = const VerificationMeta('variantId');
  @override
  late final GeneratedColumn<int> variantId = GeneratedColumn<int>(
    'variant_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipe_variants (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instructionMeta = const VerificationMeta('instruction');
  @override
  late final GeneratedColumn<String> instruction = GeneratedColumn<String>(
    'instruction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _videoUrlMeta = const VerificationMeta('videoUrl');
  @override
  late final GeneratedColumn<String> videoUrl = GeneratedColumn<String>(
    'video_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timerMeta = const VerificationMeta('timer');
  @override
  late final GeneratedColumn<int> timer = GeneratedColumn<int>(
    'timer',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepOrderMeta = const VerificationMeta('stepOrder');
  @override
  late final GeneratedColumn<int> stepOrder = GeneratedColumn<int>(
    'step_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    variantId,
    name,
    instruction,
    imagePath,
    videoUrl,
    timer,
    stepOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeStepRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    }
    if (data.containsKey('variant_id')) {
      context.handle(
        _variantIdMeta,
        variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('instruction')) {
      context.handle(
        _instructionMeta,
        instruction.isAcceptableOrUnknown(data['instruction']!, _instructionMeta),
      );
    } else if (isInserting) {
      context.missing(_instructionMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    if (data.containsKey('video_url')) {
      context.handle(
        _videoUrlMeta,
        videoUrl.isAcceptableOrUnknown(data['video_url']!, _videoUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_videoUrlMeta);
    }
    if (data.containsKey('timer')) {
      context.handle(_timerMeta, timer.isAcceptableOrUnknown(data['timer']!, _timerMeta));
    } else if (isInserting) {
      context.missing(_timerMeta);
    }
    if (data.containsKey('step_order')) {
      context.handle(
        _stepOrderMeta,
        stepOrder.isAcceptableOrUnknown(data['step_order']!, _stepOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_stepOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeStepRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeStepRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      ),
      variantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}variant_id'],
      ),
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      instruction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instruction'],
      )!,
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      )!,
      videoUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}video_url'],
      )!,
      timer: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}timer'])!,
      stepOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step_order'],
      )!,
    );
  }

  @override
  $RecipeStepsTable createAlias(String alias) {
    return $RecipeStepsTable(attachedDatabase, alias);
  }
}

class RecipeStepRow extends DataClass implements Insertable<RecipeStepRow> {
  final int id;
  final int? recipeId;
  final int? variantId;
  final String name;
  final String instruction;
  final String imagePath;
  final String videoUrl;
  final int timer;
  final int stepOrder;
  const RecipeStepRow({
    required this.id,
    this.recipeId,
    this.variantId,
    required this.name,
    required this.instruction,
    required this.imagePath,
    required this.videoUrl,
    required this.timer,
    required this.stepOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<int>(recipeId);
    }
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<int>(variantId);
    }
    map['name'] = Variable<String>(name);
    map['instruction'] = Variable<String>(instruction);
    map['image_path'] = Variable<String>(imagePath);
    map['video_url'] = Variable<String>(videoUrl);
    map['timer'] = Variable<int>(timer);
    map['step_order'] = Variable<int>(stepOrder);
    return map;
  }

  RecipeStepsCompanion toCompanion(bool nullToAbsent) {
    return RecipeStepsCompanion(
      id: Value(id),
      recipeId: recipeId == null && nullToAbsent ? const Value.absent() : Value(recipeId),
      variantId: variantId == null && nullToAbsent ? const Value.absent() : Value(variantId),
      name: Value(name),
      instruction: Value(instruction),
      imagePath: Value(imagePath),
      videoUrl: Value(videoUrl),
      timer: Value(timer),
      stepOrder: Value(stepOrder),
    );
  }

  factory RecipeStepRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeStepRow(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int?>(json['recipeId']),
      variantId: serializer.fromJson<int?>(json['variantId']),
      name: serializer.fromJson<String>(json['name']),
      instruction: serializer.fromJson<String>(json['instruction']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
      videoUrl: serializer.fromJson<String>(json['videoUrl']),
      timer: serializer.fromJson<int>(json['timer']),
      stepOrder: serializer.fromJson<int>(json['stepOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int?>(recipeId),
      'variantId': serializer.toJson<int?>(variantId),
      'name': serializer.toJson<String>(name),
      'instruction': serializer.toJson<String>(instruction),
      'imagePath': serializer.toJson<String>(imagePath),
      'videoUrl': serializer.toJson<String>(videoUrl),
      'timer': serializer.toJson<int>(timer),
      'stepOrder': serializer.toJson<int>(stepOrder),
    };
  }

  RecipeStepRow copyWith({
    int? id,
    Value<int?> recipeId = const Value.absent(),
    Value<int?> variantId = const Value.absent(),
    String? name,
    String? instruction,
    String? imagePath,
    String? videoUrl,
    int? timer,
    int? stepOrder,
  }) => RecipeStepRow(
    id: id ?? this.id,
    recipeId: recipeId.present ? recipeId.value : this.recipeId,
    variantId: variantId.present ? variantId.value : this.variantId,
    name: name ?? this.name,
    instruction: instruction ?? this.instruction,
    imagePath: imagePath ?? this.imagePath,
    videoUrl: videoUrl ?? this.videoUrl,
    timer: timer ?? this.timer,
    stepOrder: stepOrder ?? this.stepOrder,
  );
  RecipeStepRow copyWithCompanion(RecipeStepsCompanion data) {
    return RecipeStepRow(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      name: data.name.present ? data.name.value : this.name,
      instruction: data.instruction.present ? data.instruction.value : this.instruction,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      videoUrl: data.videoUrl.present ? data.videoUrl.value : this.videoUrl,
      timer: data.timer.present ? data.timer.value : this.timer,
      stepOrder: data.stepOrder.present ? data.stepOrder.value : this.stepOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStepRow(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('variantId: $variantId, ')
          ..write('name: $name, ')
          ..write('instruction: $instruction, ')
          ..write('imagePath: $imagePath, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('timer: $timer, ')
          ..write('stepOrder: $stepOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    variantId,
    name,
    instruction,
    imagePath,
    videoUrl,
    timer,
    stepOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeStepRow &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.variantId == this.variantId &&
          other.name == this.name &&
          other.instruction == this.instruction &&
          other.imagePath == this.imagePath &&
          other.videoUrl == this.videoUrl &&
          other.timer == this.timer &&
          other.stepOrder == this.stepOrder);
}

class RecipeStepsCompanion extends UpdateCompanion<RecipeStepRow> {
  final Value<int> id;
  final Value<int?> recipeId;
  final Value<int?> variantId;
  final Value<String> name;
  final Value<String> instruction;
  final Value<String> imagePath;
  final Value<String> videoUrl;
  final Value<int> timer;
  final Value<int> stepOrder;
  const RecipeStepsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.name = const Value.absent(),
    this.instruction = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.videoUrl = const Value.absent(),
    this.timer = const Value.absent(),
    this.stepOrder = const Value.absent(),
  });
  RecipeStepsCompanion.insert({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.variantId = const Value.absent(),
    required String name,
    required String instruction,
    required String imagePath,
    required String videoUrl,
    required int timer,
    required int stepOrder,
  }) : name = Value(name),
       instruction = Value(instruction),
       imagePath = Value(imagePath),
       videoUrl = Value(videoUrl),
       timer = Value(timer),
       stepOrder = Value(stepOrder);
  static Insertable<RecipeStepRow> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? variantId,
    Expression<String>? name,
    Expression<String>? instruction,
    Expression<String>? imagePath,
    Expression<String>? videoUrl,
    Expression<int>? timer,
    Expression<int>? stepOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (variantId != null) 'variant_id': variantId,
      if (name != null) 'name': name,
      if (instruction != null) 'instruction': instruction,
      if (imagePath != null) 'image_path': imagePath,
      if (videoUrl != null) 'video_url': videoUrl,
      if (timer != null) 'timer': timer,
      if (stepOrder != null) 'step_order': stepOrder,
    });
  }

  RecipeStepsCompanion copyWith({
    Value<int>? id,
    Value<int?>? recipeId,
    Value<int?>? variantId,
    Value<String>? name,
    Value<String>? instruction,
    Value<String>? imagePath,
    Value<String>? videoUrl,
    Value<int>? timer,
    Value<int>? stepOrder,
  }) {
    return RecipeStepsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      variantId: variantId ?? this.variantId,
      name: name ?? this.name,
      instruction: instruction ?? this.instruction,
      imagePath: imagePath ?? this.imagePath,
      videoUrl: videoUrl ?? this.videoUrl,
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
    if (variantId.present) {
      map['variant_id'] = Variable<int>(variantId.value);
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
    if (videoUrl.present) {
      map['video_url'] = Variable<String>(videoUrl.value);
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
          ..write('variantId: $variantId, ')
          ..write('name: $name, ')
          ..write('instruction: $instruction, ')
          ..write('imagePath: $imagePath, ')
          ..write('videoUrl: $videoUrl, ')
          ..write('timer: $timer, ')
          ..write('stepOrder: $stepOrder')
          ..write(')'))
        .toString();
  }
}

class $IngredientItemsTable extends IngredientItems
    with TableInfo<$IngredientItemsTable, IngredientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _stepIdMeta = const VerificationMeta('stepId');
  @override
  late final GeneratedColumn<int> stepId = GeneratedColumn<int>(
    'step_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipe_steps (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta('position');
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lowerNameMeta = const VerificationMeta('lowerName');
  @override
  late final GeneratedColumn<String> lowerName = GeneratedColumn<String>(
    'lower_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shapeMeta = const VerificationMeta('shape');
  @override
  late final GeneratedColumn<String> shape = GeneratedColumn<String>(
    'shape',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversionIdMeta = const VerificationMeta('conversionId');
  @override
  late final GeneratedColumn<int> conversionId = GeneratedColumn<int>(
    'conversion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionalMeta = const VerificationMeta('optional');
  @override
  late final GeneratedColumn<bool> optional = GeneratedColumn<bool>(
    'optional',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("optional" IN (0, 1))'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    stepId,
    position,
    name,
    lowerName,
    unit,
    quantity,
    shape,
    foodId,
    conversionId,
    optional,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('step_id')) {
      context.handle(_stepIdMeta, stepId.isAcceptableOrUnknown(data['step_id']!, _stepIdMeta));
    } else if (isInserting) {
      context.missing(_stepIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('lower_name')) {
      context.handle(
        _lowerNameMeta,
        lowerName.isAcceptableOrUnknown(data['lower_name']!, _lowerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lowerNameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(_unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('shape')) {
      context.handle(_shapeMeta, shape.isAcceptableOrUnknown(data['shape']!, _shapeMeta));
    } else if (isInserting) {
      context.missing(_shapeMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(_foodIdMeta, foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta));
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('conversion_id')) {
      context.handle(
        _conversionIdMeta,
        conversionId.isAcceptableOrUnknown(data['conversion_id']!, _conversionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_conversionIdMeta);
    }
    if (data.containsKey('optional')) {
      context.handle(
        _optionalMeta,
        optional.isAcceptableOrUnknown(data['optional']!, _optionalMeta),
      );
    } else if (isInserting) {
      context.missing(_optionalMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IngredientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      stepId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      lowerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lower_name'],
      )!,
      unit: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      shape: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shape'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      )!,
      conversionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}conversion_id'],
      )!,
      optional: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}optional'],
      )!,
    );
  }

  @override
  $IngredientItemsTable createAlias(String alias) {
    return $IngredientItemsTable(attachedDatabase, alias);
  }
}

class IngredientRow extends DataClass implements Insertable<IngredientRow> {
  final int id;
  final int stepId;

  /// Position in the step; ties (migrated rows) fall back to id order.
  final int position;
  final String name;

  /// `name.toLowerCase()` (Unicode-aware, unlike SQLite's `lower()`), indexed
  /// to find already linked ingredients by name.
  final String lowerName;
  final String unit;
  final double quantity;
  final String shape;
  final int foodId;
  final int conversionId;
  final bool optional;
  const IngredientRow({
    required this.id,
    required this.stepId,
    required this.position,
    required this.name,
    required this.lowerName,
    required this.unit,
    required this.quantity,
    required this.shape,
    required this.foodId,
    required this.conversionId,
    required this.optional,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['step_id'] = Variable<int>(stepId);
    map['position'] = Variable<int>(position);
    map['name'] = Variable<String>(name);
    map['lower_name'] = Variable<String>(lowerName);
    map['unit'] = Variable<String>(unit);
    map['quantity'] = Variable<double>(quantity);
    map['shape'] = Variable<String>(shape);
    map['food_id'] = Variable<int>(foodId);
    map['conversion_id'] = Variable<int>(conversionId);
    map['optional'] = Variable<bool>(optional);
    return map;
  }

  IngredientItemsCompanion toCompanion(bool nullToAbsent) {
    return IngredientItemsCompanion(
      id: Value(id),
      stepId: Value(stepId),
      position: Value(position),
      name: Value(name),
      lowerName: Value(lowerName),
      unit: Value(unit),
      quantity: Value(quantity),
      shape: Value(shape),
      foodId: Value(foodId),
      conversionId: Value(conversionId),
      optional: Value(optional),
    );
  }

  factory IngredientRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientRow(
      id: serializer.fromJson<int>(json['id']),
      stepId: serializer.fromJson<int>(json['stepId']),
      position: serializer.fromJson<int>(json['position']),
      name: serializer.fromJson<String>(json['name']),
      lowerName: serializer.fromJson<String>(json['lowerName']),
      unit: serializer.fromJson<String>(json['unit']),
      quantity: serializer.fromJson<double>(json['quantity']),
      shape: serializer.fromJson<String>(json['shape']),
      foodId: serializer.fromJson<int>(json['foodId']),
      conversionId: serializer.fromJson<int>(json['conversionId']),
      optional: serializer.fromJson<bool>(json['optional']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'stepId': serializer.toJson<int>(stepId),
      'position': serializer.toJson<int>(position),
      'name': serializer.toJson<String>(name),
      'lowerName': serializer.toJson<String>(lowerName),
      'unit': serializer.toJson<String>(unit),
      'quantity': serializer.toJson<double>(quantity),
      'shape': serializer.toJson<String>(shape),
      'foodId': serializer.toJson<int>(foodId),
      'conversionId': serializer.toJson<int>(conversionId),
      'optional': serializer.toJson<bool>(optional),
    };
  }

  IngredientRow copyWith({
    int? id,
    int? stepId,
    int? position,
    String? name,
    String? lowerName,
    String? unit,
    double? quantity,
    String? shape,
    int? foodId,
    int? conversionId,
    bool? optional,
  }) => IngredientRow(
    id: id ?? this.id,
    stepId: stepId ?? this.stepId,
    position: position ?? this.position,
    name: name ?? this.name,
    lowerName: lowerName ?? this.lowerName,
    unit: unit ?? this.unit,
    quantity: quantity ?? this.quantity,
    shape: shape ?? this.shape,
    foodId: foodId ?? this.foodId,
    conversionId: conversionId ?? this.conversionId,
    optional: optional ?? this.optional,
  );
  IngredientRow copyWithCompanion(IngredientItemsCompanion data) {
    return IngredientRow(
      id: data.id.present ? data.id.value : this.id,
      stepId: data.stepId.present ? data.stepId.value : this.stepId,
      position: data.position.present ? data.position.value : this.position,
      name: data.name.present ? data.name.value : this.name,
      lowerName: data.lowerName.present ? data.lowerName.value : this.lowerName,
      unit: data.unit.present ? data.unit.value : this.unit,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      shape: data.shape.present ? data.shape.value : this.shape,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      conversionId: data.conversionId.present ? data.conversionId.value : this.conversionId,
      optional: data.optional.present ? data.optional.value : this.optional,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientRow(')
          ..write('id: $id, ')
          ..write('stepId: $stepId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('lowerName: $lowerName, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('shape: $shape, ')
          ..write('foodId: $foodId, ')
          ..write('conversionId: $conversionId, ')
          ..write('optional: $optional')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    stepId,
    position,
    name,
    lowerName,
    unit,
    quantity,
    shape,
    foodId,
    conversionId,
    optional,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientRow &&
          other.id == this.id &&
          other.stepId == this.stepId &&
          other.position == this.position &&
          other.name == this.name &&
          other.lowerName == this.lowerName &&
          other.unit == this.unit &&
          other.quantity == this.quantity &&
          other.shape == this.shape &&
          other.foodId == this.foodId &&
          other.conversionId == this.conversionId &&
          other.optional == this.optional);
}

class IngredientItemsCompanion extends UpdateCompanion<IngredientRow> {
  final Value<int> id;
  final Value<int> stepId;
  final Value<int> position;
  final Value<String> name;
  final Value<String> lowerName;
  final Value<String> unit;
  final Value<double> quantity;
  final Value<String> shape;
  final Value<int> foodId;
  final Value<int> conversionId;
  final Value<bool> optional;
  const IngredientItemsCompanion({
    this.id = const Value.absent(),
    this.stepId = const Value.absent(),
    this.position = const Value.absent(),
    this.name = const Value.absent(),
    this.lowerName = const Value.absent(),
    this.unit = const Value.absent(),
    this.quantity = const Value.absent(),
    this.shape = const Value.absent(),
    this.foodId = const Value.absent(),
    this.conversionId = const Value.absent(),
    this.optional = const Value.absent(),
  });
  IngredientItemsCompanion.insert({
    this.id = const Value.absent(),
    required int stepId,
    required int position,
    required String name,
    required String lowerName,
    required String unit,
    required double quantity,
    required String shape,
    required int foodId,
    required int conversionId,
    required bool optional,
  }) : stepId = Value(stepId),
       position = Value(position),
       name = Value(name),
       lowerName = Value(lowerName),
       unit = Value(unit),
       quantity = Value(quantity),
       shape = Value(shape),
       foodId = Value(foodId),
       conversionId = Value(conversionId),
       optional = Value(optional);
  static Insertable<IngredientRow> custom({
    Expression<int>? id,
    Expression<int>? stepId,
    Expression<int>? position,
    Expression<String>? name,
    Expression<String>? lowerName,
    Expression<String>? unit,
    Expression<double>? quantity,
    Expression<String>? shape,
    Expression<int>? foodId,
    Expression<int>? conversionId,
    Expression<bool>? optional,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stepId != null) 'step_id': stepId,
      if (position != null) 'position': position,
      if (name != null) 'name': name,
      if (lowerName != null) 'lower_name': lowerName,
      if (unit != null) 'unit': unit,
      if (quantity != null) 'quantity': quantity,
      if (shape != null) 'shape': shape,
      if (foodId != null) 'food_id': foodId,
      if (conversionId != null) 'conversion_id': conversionId,
      if (optional != null) 'optional': optional,
    });
  }

  IngredientItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? stepId,
    Value<int>? position,
    Value<String>? name,
    Value<String>? lowerName,
    Value<String>? unit,
    Value<double>? quantity,
    Value<String>? shape,
    Value<int>? foodId,
    Value<int>? conversionId,
    Value<bool>? optional,
  }) {
    return IngredientItemsCompanion(
      id: id ?? this.id,
      stepId: stepId ?? this.stepId,
      position: position ?? this.position,
      name: name ?? this.name,
      lowerName: lowerName ?? this.lowerName,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      shape: shape ?? this.shape,
      foodId: foodId ?? this.foodId,
      conversionId: conversionId ?? this.conversionId,
      optional: optional ?? this.optional,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (stepId.present) {
      map['step_id'] = Variable<int>(stepId.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lowerName.present) {
      map['lower_name'] = Variable<String>(lowerName.value);
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
    if (conversionId.present) {
      map['conversion_id'] = Variable<int>(conversionId.value);
    }
    if (optional.present) {
      map['optional'] = Variable<bool>(optional.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientItemsCompanion(')
          ..write('id: $id, ')
          ..write('stepId: $stepId, ')
          ..write('position: $position, ')
          ..write('name: $name, ')
          ..write('lowerName: $lowerName, ')
          ..write('unit: $unit, ')
          ..write('quantity: $quantity, ')
          ..write('shape: $shape, ')
          ..write('foodId: $foodId, ')
          ..write('conversionId: $conversionId, ')
          ..write('optional: $optional')
          ..write(')'))
        .toString();
  }
}

class $NutrientsTable extends Nutrients with TableInfo<$NutrientsTable, NutrientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NutrientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _descENMeta = const VerificationMeta('descEN');
  @override
  late final GeneratedColumn<String> descEN = GeneratedColumn<String>(
    'desc_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descFRMeta = const VerificationMeta('descFR');
  @override
  late final GeneratedColumn<String> descFR = GeneratedColumn<String>(
    'desc_fr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta('protein');
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _waterMeta = const VerificationMeta('water');
  @override
  late final GeneratedColumn<double> water = GeneratedColumn<double>(
    'water',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lipidTotalMeta = const VerificationMeta('lipidTotal');
  @override
  late final GeneratedColumn<double> lipidTotal = GeneratedColumn<double>(
    'lipid_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _energKcalMeta = const VerificationMeta('energKcal');
  @override
  late final GeneratedColumn<double> energKcal = GeneratedColumn<double>(
    'energ_kcal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbohydratesMeta = const VerificationMeta('carbohydrates');
  @override
  late final GeneratedColumn<double> carbohydrates = GeneratedColumn<double>(
    'carbohydrates',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ashMeta = const VerificationMeta('ash');
  @override
  late final GeneratedColumn<double> ash = GeneratedColumn<double>(
    'ash',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiberMeta = const VerificationMeta('fiber');
  @override
  late final GeneratedColumn<double> fiber = GeneratedColumn<double>(
    'fiber',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sugarMeta = const VerificationMeta('sugar');
  @override
  late final GeneratedColumn<double> sugar = GeneratedColumn<double>(
    'sugar',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calciumMeta = const VerificationMeta('calcium');
  @override
  late final GeneratedColumn<double> calcium = GeneratedColumn<double>(
    'calcium',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ironMeta = const VerificationMeta('iron');
  @override
  late final GeneratedColumn<double> iron = GeneratedColumn<double>(
    'iron',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _magnesiumMeta = const VerificationMeta('magnesium');
  @override
  late final GeneratedColumn<double> magnesium = GeneratedColumn<double>(
    'magnesium',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phosphorusMeta = const VerificationMeta('phosphorus');
  @override
  late final GeneratedColumn<double> phosphorus = GeneratedColumn<double>(
    'phosphorus',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _potassiumMeta = const VerificationMeta('potassium');
  @override
  late final GeneratedColumn<double> potassium = GeneratedColumn<double>(
    'potassium',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sodiumMeta = const VerificationMeta('sodium');
  @override
  late final GeneratedColumn<double> sodium = GeneratedColumn<double>(
    'sodium',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zincMeta = const VerificationMeta('zinc');
  @override
  late final GeneratedColumn<double> zinc = GeneratedColumn<double>(
    'zinc',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _copperMeta = const VerificationMeta('copper');
  @override
  late final GeneratedColumn<double> copper = GeneratedColumn<double>(
    'copper',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _manganeseMeta = const VerificationMeta('manganese');
  @override
  late final GeneratedColumn<double> manganese = GeneratedColumn<double>(
    'manganese',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seleniumMeta = const VerificationMeta('selenium');
  @override
  late final GeneratedColumn<double> selenium = GeneratedColumn<double>(
    'selenium',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitaminCMeta = const VerificationMeta('vitaminC');
  @override
  late final GeneratedColumn<double> vitaminC = GeneratedColumn<double>(
    'vitamin_c',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thiaminMeta = const VerificationMeta('thiamin');
  @override
  late final GeneratedColumn<double> thiamin = GeneratedColumn<double>(
    'thiamin',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _riboflavinMeta = const VerificationMeta('riboflavin');
  @override
  late final GeneratedColumn<double> riboflavin = GeneratedColumn<double>(
    'riboflavin',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _niacinMeta = const VerificationMeta('niacin');
  @override
  late final GeneratedColumn<double> niacin = GeneratedColumn<double>(
    'niacin',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pantoAcidMeta = const VerificationMeta('pantoAcid');
  @override
  late final GeneratedColumn<double> pantoAcid = GeneratedColumn<double>(
    'panto_acid',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitaminB6Meta = const VerificationMeta('vitaminB6');
  @override
  late final GeneratedColumn<double> vitaminB6 = GeneratedColumn<double>(
    'vitamin_b6',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folateTotalMeta = const VerificationMeta('folateTotal');
  @override
  late final GeneratedColumn<double> folateTotal = GeneratedColumn<double>(
    'folate_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folicAcidMeta = const VerificationMeta('folicAcid');
  @override
  late final GeneratedColumn<double> folicAcid = GeneratedColumn<double>(
    'folic_acid',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodFolateMeta = const VerificationMeta('foodFolate');
  @override
  late final GeneratedColumn<double> foodFolate = GeneratedColumn<double>(
    'food_folate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _folateDFEMeta = const VerificationMeta('folateDFE');
  @override
  late final GeneratedColumn<double> folateDFE = GeneratedColumn<double>(
    'folate_dfe',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cholineTotalMeta = const VerificationMeta('cholineTotal');
  @override
  late final GeneratedColumn<double> cholineTotal = GeneratedColumn<double>(
    'choline_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitaminB12Meta = const VerificationMeta('vitaminB12');
  @override
  late final GeneratedColumn<double> vitaminB12 = GeneratedColumn<double>(
    'vitamin_b12',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitaminAIUMeta = const VerificationMeta('vitaminAIU');
  @override
  late final GeneratedColumn<double> vitaminAIU = GeneratedColumn<double>(
    'vitamin_a_iu',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitaminARAEMeta = const VerificationMeta('vitaminARAE');
  @override
  late final GeneratedColumn<double> vitaminARAE = GeneratedColumn<double>(
    'vitamin_a_rae',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retinolMeta = const VerificationMeta('retinol');
  @override
  late final GeneratedColumn<double> retinol = GeneratedColumn<double>(
    'retinol',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alphaCarotMeta = const VerificationMeta('alphaCarot');
  @override
  late final GeneratedColumn<double> alphaCarot = GeneratedColumn<double>(
    'alpha_carot',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _betaCarotMeta = const VerificationMeta('betaCarot');
  @override
  late final GeneratedColumn<double> betaCarot = GeneratedColumn<double>(
    'beta_carot',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _betaCryptMeta = const VerificationMeta('betaCrypt');
  @override
  late final GeneratedColumn<double> betaCrypt = GeneratedColumn<double>(
    'beta_crypt',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lycopeneMeta = const VerificationMeta('lycopene');
  @override
  late final GeneratedColumn<double> lycopene = GeneratedColumn<double>(
    'lycopene',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lutZeaMeta = const VerificationMeta('lutZea');
  @override
  late final GeneratedColumn<double> lutZea = GeneratedColumn<double>(
    'lut_zea',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitaminEMeta = const VerificationMeta('vitaminE');
  @override
  late final GeneratedColumn<double> vitaminE = GeneratedColumn<double>(
    'vitamin_e',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitaminDMeta = const VerificationMeta('vitaminD');
  @override
  late final GeneratedColumn<double> vitaminD = GeneratedColumn<double>(
    'vitamin_d',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitaminDIUMeta = const VerificationMeta('vitaminDIU');
  @override
  late final GeneratedColumn<double> vitaminDIU = GeneratedColumn<double>(
    'vitamin_d_iu',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vitaminKMeta = const VerificationMeta('vitaminK');
  @override
  late final GeneratedColumn<double> vitaminK = GeneratedColumn<double>(
    'vitamin_k',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _faSatMeta = const VerificationMeta('faSat');
  @override
  late final GeneratedColumn<double> faSat = GeneratedColumn<double>(
    'fa_sat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _faMonoMeta = const VerificationMeta('faMono');
  @override
  late final GeneratedColumn<double> faMono = GeneratedColumn<double>(
    'fa_mono',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _faPolyMeta = const VerificationMeta('faPoly');
  @override
  late final GeneratedColumn<double> faPoly = GeneratedColumn<double>(
    'fa_poly',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cholesterolMeta = const VerificationMeta('cholesterol');
  @override
  late final GeneratedColumn<double> cholesterol = GeneratedColumn<double>(
    'cholesterol',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    foodId,
    descEN,
    descFR,
    protein,
    water,
    lipidTotal,
    energKcal,
    carbohydrates,
    ash,
    fiber,
    sugar,
    calcium,
    iron,
    magnesium,
    phosphorus,
    potassium,
    sodium,
    zinc,
    copper,
    manganese,
    selenium,
    vitaminC,
    thiamin,
    riboflavin,
    niacin,
    pantoAcid,
    vitaminB6,
    folateTotal,
    folicAcid,
    foodFolate,
    folateDFE,
    cholineTotal,
    vitaminB12,
    vitaminAIU,
    vitaminARAE,
    retinol,
    alphaCarot,
    betaCarot,
    betaCrypt,
    lycopene,
    lutZea,
    vitaminE,
    vitaminD,
    vitaminDIU,
    vitaminK,
    faSat,
    faMono,
    faPoly,
    cholesterol,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'nutrients';
  @override
  VerificationContext validateIntegrity(
    Insertable<NutrientRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('food_id')) {
      context.handle(_foodIdMeta, foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta));
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('desc_en')) {
      context.handle(_descENMeta, descEN.isAcceptableOrUnknown(data['desc_en']!, _descENMeta));
    } else if (isInserting) {
      context.missing(_descENMeta);
    }
    if (data.containsKey('desc_fr')) {
      context.handle(_descFRMeta, descFR.isAcceptableOrUnknown(data['desc_fr']!, _descFRMeta));
    } else if (isInserting) {
      context.missing(_descFRMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(_proteinMeta, protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta));
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('water')) {
      context.handle(_waterMeta, water.isAcceptableOrUnknown(data['water']!, _waterMeta));
    } else if (isInserting) {
      context.missing(_waterMeta);
    }
    if (data.containsKey('lipid_total')) {
      context.handle(
        _lipidTotalMeta,
        lipidTotal.isAcceptableOrUnknown(data['lipid_total']!, _lipidTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_lipidTotalMeta);
    }
    if (data.containsKey('energ_kcal')) {
      context.handle(
        _energKcalMeta,
        energKcal.isAcceptableOrUnknown(data['energ_kcal']!, _energKcalMeta),
      );
    } else if (isInserting) {
      context.missing(_energKcalMeta);
    }
    if (data.containsKey('carbohydrates')) {
      context.handle(
        _carbohydratesMeta,
        carbohydrates.isAcceptableOrUnknown(data['carbohydrates']!, _carbohydratesMeta),
      );
    } else if (isInserting) {
      context.missing(_carbohydratesMeta);
    }
    if (data.containsKey('ash')) {
      context.handle(_ashMeta, ash.isAcceptableOrUnknown(data['ash']!, _ashMeta));
    } else if (isInserting) {
      context.missing(_ashMeta);
    }
    if (data.containsKey('fiber')) {
      context.handle(_fiberMeta, fiber.isAcceptableOrUnknown(data['fiber']!, _fiberMeta));
    } else if (isInserting) {
      context.missing(_fiberMeta);
    }
    if (data.containsKey('sugar')) {
      context.handle(_sugarMeta, sugar.isAcceptableOrUnknown(data['sugar']!, _sugarMeta));
    } else if (isInserting) {
      context.missing(_sugarMeta);
    }
    if (data.containsKey('calcium')) {
      context.handle(_calciumMeta, calcium.isAcceptableOrUnknown(data['calcium']!, _calciumMeta));
    } else if (isInserting) {
      context.missing(_calciumMeta);
    }
    if (data.containsKey('iron')) {
      context.handle(_ironMeta, iron.isAcceptableOrUnknown(data['iron']!, _ironMeta));
    } else if (isInserting) {
      context.missing(_ironMeta);
    }
    if (data.containsKey('magnesium')) {
      context.handle(
        _magnesiumMeta,
        magnesium.isAcceptableOrUnknown(data['magnesium']!, _magnesiumMeta),
      );
    } else if (isInserting) {
      context.missing(_magnesiumMeta);
    }
    if (data.containsKey('phosphorus')) {
      context.handle(
        _phosphorusMeta,
        phosphorus.isAcceptableOrUnknown(data['phosphorus']!, _phosphorusMeta),
      );
    } else if (isInserting) {
      context.missing(_phosphorusMeta);
    }
    if (data.containsKey('potassium')) {
      context.handle(
        _potassiumMeta,
        potassium.isAcceptableOrUnknown(data['potassium']!, _potassiumMeta),
      );
    } else if (isInserting) {
      context.missing(_potassiumMeta);
    }
    if (data.containsKey('sodium')) {
      context.handle(_sodiumMeta, sodium.isAcceptableOrUnknown(data['sodium']!, _sodiumMeta));
    } else if (isInserting) {
      context.missing(_sodiumMeta);
    }
    if (data.containsKey('zinc')) {
      context.handle(_zincMeta, zinc.isAcceptableOrUnknown(data['zinc']!, _zincMeta));
    } else if (isInserting) {
      context.missing(_zincMeta);
    }
    if (data.containsKey('copper')) {
      context.handle(_copperMeta, copper.isAcceptableOrUnknown(data['copper']!, _copperMeta));
    } else if (isInserting) {
      context.missing(_copperMeta);
    }
    if (data.containsKey('manganese')) {
      context.handle(
        _manganeseMeta,
        manganese.isAcceptableOrUnknown(data['manganese']!, _manganeseMeta),
      );
    } else if (isInserting) {
      context.missing(_manganeseMeta);
    }
    if (data.containsKey('selenium')) {
      context.handle(
        _seleniumMeta,
        selenium.isAcceptableOrUnknown(data['selenium']!, _seleniumMeta),
      );
    } else if (isInserting) {
      context.missing(_seleniumMeta);
    }
    if (data.containsKey('vitamin_c')) {
      context.handle(
        _vitaminCMeta,
        vitaminC.isAcceptableOrUnknown(data['vitamin_c']!, _vitaminCMeta),
      );
    } else if (isInserting) {
      context.missing(_vitaminCMeta);
    }
    if (data.containsKey('thiamin')) {
      context.handle(_thiaminMeta, thiamin.isAcceptableOrUnknown(data['thiamin']!, _thiaminMeta));
    } else if (isInserting) {
      context.missing(_thiaminMeta);
    }
    if (data.containsKey('riboflavin')) {
      context.handle(
        _riboflavinMeta,
        riboflavin.isAcceptableOrUnknown(data['riboflavin']!, _riboflavinMeta),
      );
    } else if (isInserting) {
      context.missing(_riboflavinMeta);
    }
    if (data.containsKey('niacin')) {
      context.handle(_niacinMeta, niacin.isAcceptableOrUnknown(data['niacin']!, _niacinMeta));
    } else if (isInserting) {
      context.missing(_niacinMeta);
    }
    if (data.containsKey('panto_acid')) {
      context.handle(
        _pantoAcidMeta,
        pantoAcid.isAcceptableOrUnknown(data['panto_acid']!, _pantoAcidMeta),
      );
    } else if (isInserting) {
      context.missing(_pantoAcidMeta);
    }
    if (data.containsKey('vitamin_b6')) {
      context.handle(
        _vitaminB6Meta,
        vitaminB6.isAcceptableOrUnknown(data['vitamin_b6']!, _vitaminB6Meta),
      );
    } else if (isInserting) {
      context.missing(_vitaminB6Meta);
    }
    if (data.containsKey('folate_total')) {
      context.handle(
        _folateTotalMeta,
        folateTotal.isAcceptableOrUnknown(data['folate_total']!, _folateTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_folateTotalMeta);
    }
    if (data.containsKey('folic_acid')) {
      context.handle(
        _folicAcidMeta,
        folicAcid.isAcceptableOrUnknown(data['folic_acid']!, _folicAcidMeta),
      );
    } else if (isInserting) {
      context.missing(_folicAcidMeta);
    }
    if (data.containsKey('food_folate')) {
      context.handle(
        _foodFolateMeta,
        foodFolate.isAcceptableOrUnknown(data['food_folate']!, _foodFolateMeta),
      );
    } else if (isInserting) {
      context.missing(_foodFolateMeta);
    }
    if (data.containsKey('folate_dfe')) {
      context.handle(
        _folateDFEMeta,
        folateDFE.isAcceptableOrUnknown(data['folate_dfe']!, _folateDFEMeta),
      );
    } else if (isInserting) {
      context.missing(_folateDFEMeta);
    }
    if (data.containsKey('choline_total')) {
      context.handle(
        _cholineTotalMeta,
        cholineTotal.isAcceptableOrUnknown(data['choline_total']!, _cholineTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_cholineTotalMeta);
    }
    if (data.containsKey('vitamin_b12')) {
      context.handle(
        _vitaminB12Meta,
        vitaminB12.isAcceptableOrUnknown(data['vitamin_b12']!, _vitaminB12Meta),
      );
    } else if (isInserting) {
      context.missing(_vitaminB12Meta);
    }
    if (data.containsKey('vitamin_a_iu')) {
      context.handle(
        _vitaminAIUMeta,
        vitaminAIU.isAcceptableOrUnknown(data['vitamin_a_iu']!, _vitaminAIUMeta),
      );
    } else if (isInserting) {
      context.missing(_vitaminAIUMeta);
    }
    if (data.containsKey('vitamin_a_rae')) {
      context.handle(
        _vitaminARAEMeta,
        vitaminARAE.isAcceptableOrUnknown(data['vitamin_a_rae']!, _vitaminARAEMeta),
      );
    } else if (isInserting) {
      context.missing(_vitaminARAEMeta);
    }
    if (data.containsKey('retinol')) {
      context.handle(_retinolMeta, retinol.isAcceptableOrUnknown(data['retinol']!, _retinolMeta));
    } else if (isInserting) {
      context.missing(_retinolMeta);
    }
    if (data.containsKey('alpha_carot')) {
      context.handle(
        _alphaCarotMeta,
        alphaCarot.isAcceptableOrUnknown(data['alpha_carot']!, _alphaCarotMeta),
      );
    } else if (isInserting) {
      context.missing(_alphaCarotMeta);
    }
    if (data.containsKey('beta_carot')) {
      context.handle(
        _betaCarotMeta,
        betaCarot.isAcceptableOrUnknown(data['beta_carot']!, _betaCarotMeta),
      );
    } else if (isInserting) {
      context.missing(_betaCarotMeta);
    }
    if (data.containsKey('beta_crypt')) {
      context.handle(
        _betaCryptMeta,
        betaCrypt.isAcceptableOrUnknown(data['beta_crypt']!, _betaCryptMeta),
      );
    } else if (isInserting) {
      context.missing(_betaCryptMeta);
    }
    if (data.containsKey('lycopene')) {
      context.handle(
        _lycopeneMeta,
        lycopene.isAcceptableOrUnknown(data['lycopene']!, _lycopeneMeta),
      );
    } else if (isInserting) {
      context.missing(_lycopeneMeta);
    }
    if (data.containsKey('lut_zea')) {
      context.handle(_lutZeaMeta, lutZea.isAcceptableOrUnknown(data['lut_zea']!, _lutZeaMeta));
    } else if (isInserting) {
      context.missing(_lutZeaMeta);
    }
    if (data.containsKey('vitamin_e')) {
      context.handle(
        _vitaminEMeta,
        vitaminE.isAcceptableOrUnknown(data['vitamin_e']!, _vitaminEMeta),
      );
    } else if (isInserting) {
      context.missing(_vitaminEMeta);
    }
    if (data.containsKey('vitamin_d')) {
      context.handle(
        _vitaminDMeta,
        vitaminD.isAcceptableOrUnknown(data['vitamin_d']!, _vitaminDMeta),
      );
    } else if (isInserting) {
      context.missing(_vitaminDMeta);
    }
    if (data.containsKey('vitamin_d_iu')) {
      context.handle(
        _vitaminDIUMeta,
        vitaminDIU.isAcceptableOrUnknown(data['vitamin_d_iu']!, _vitaminDIUMeta),
      );
    } else if (isInserting) {
      context.missing(_vitaminDIUMeta);
    }
    if (data.containsKey('vitamin_k')) {
      context.handle(
        _vitaminKMeta,
        vitaminK.isAcceptableOrUnknown(data['vitamin_k']!, _vitaminKMeta),
      );
    } else if (isInserting) {
      context.missing(_vitaminKMeta);
    }
    if (data.containsKey('fa_sat')) {
      context.handle(_faSatMeta, faSat.isAcceptableOrUnknown(data['fa_sat']!, _faSatMeta));
    } else if (isInserting) {
      context.missing(_faSatMeta);
    }
    if (data.containsKey('fa_mono')) {
      context.handle(_faMonoMeta, faMono.isAcceptableOrUnknown(data['fa_mono']!, _faMonoMeta));
    } else if (isInserting) {
      context.missing(_faMonoMeta);
    }
    if (data.containsKey('fa_poly')) {
      context.handle(_faPolyMeta, faPoly.isAcceptableOrUnknown(data['fa_poly']!, _faPolyMeta));
    } else if (isInserting) {
      context.missing(_faPolyMeta);
    }
    if (data.containsKey('cholesterol')) {
      context.handle(
        _cholesterolMeta,
        cholesterol.isAcceptableOrUnknown(data['cholesterol']!, _cholesterolMeta),
      );
    } else if (isInserting) {
      context.missing(_cholesterolMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NutrientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NutrientRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      )!,
      descEN: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}desc_en'],
      )!,
      descFR: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}desc_fr'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      water: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}water'],
      )!,
      lipidTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lipid_total'],
      )!,
      energKcal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}energ_kcal'],
      )!,
      carbohydrates: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbohydrates'],
      )!,
      ash: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}ash'])!,
      fiber: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber'],
      )!,
      sugar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sugar'],
      )!,
      calcium: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calcium'],
      )!,
      iron: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}iron'])!,
      magnesium: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}magnesium'],
      )!,
      phosphorus: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}phosphorus'],
      )!,
      potassium: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}potassium'],
      )!,
      sodium: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sodium'],
      )!,
      zinc: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}zinc'])!,
      copper: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}copper'],
      )!,
      manganese: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}manganese'],
      )!,
      selenium: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}selenium'],
      )!,
      vitaminC: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vitamin_c'],
      )!,
      thiamin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}thiamin'],
      )!,
      riboflavin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}riboflavin'],
      )!,
      niacin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}niacin'],
      )!,
      pantoAcid: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}panto_acid'],
      )!,
      vitaminB6: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vitamin_b6'],
      )!,
      folateTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}folate_total'],
      )!,
      folicAcid: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}folic_acid'],
      )!,
      foodFolate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}food_folate'],
      )!,
      folateDFE: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}folate_dfe'],
      )!,
      cholineTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}choline_total'],
      )!,
      vitaminB12: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vitamin_b12'],
      )!,
      vitaminAIU: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vitamin_a_iu'],
      )!,
      vitaminARAE: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vitamin_a_rae'],
      )!,
      retinol: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}retinol'],
      )!,
      alphaCarot: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}alpha_carot'],
      )!,
      betaCarot: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}beta_carot'],
      )!,
      betaCrypt: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}beta_crypt'],
      )!,
      lycopene: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lycopene'],
      )!,
      lutZea: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lut_zea'],
      )!,
      vitaminE: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vitamin_e'],
      )!,
      vitaminD: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vitamin_d'],
      )!,
      vitaminDIU: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vitamin_d_iu'],
      )!,
      vitaminK: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vitamin_k'],
      )!,
      faSat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fa_sat'],
      )!,
      faMono: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fa_mono'],
      )!,
      faPoly: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fa_poly'],
      )!,
      cholesterol: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cholesterol'],
      )!,
    );
  }

  @override
  $NutrientsTable createAlias(String alias) {
    return $NutrientsTable(attachedDatabase, alias);
  }
}

class NutrientRow extends DataClass implements Insertable<NutrientRow> {
  final int id;
  final int foodId;
  final String descEN;
  final String descFR;
  final double protein;
  final double water;
  final double lipidTotal;
  final double energKcal;
  final double carbohydrates;
  final double ash;
  final double fiber;
  final double sugar;
  final double calcium;
  final double iron;
  final double magnesium;
  final double phosphorus;
  final double potassium;
  final double sodium;
  final double zinc;
  final double copper;
  final double manganese;
  final double selenium;
  final double vitaminC;
  final double thiamin;
  final double riboflavin;
  final double niacin;
  final double pantoAcid;
  final double vitaminB6;
  final double folateTotal;
  final double folicAcid;
  final double foodFolate;
  final double folateDFE;
  final double cholineTotal;
  final double vitaminB12;
  final double vitaminAIU;
  final double vitaminARAE;
  final double retinol;
  final double alphaCarot;
  final double betaCarot;
  final double betaCrypt;
  final double lycopene;
  final double lutZea;
  final double vitaminE;
  final double vitaminD;
  final double vitaminDIU;
  final double vitaminK;
  final double faSat;
  final double faMono;
  final double faPoly;
  final double cholesterol;
  const NutrientRow({
    required this.id,
    required this.foodId,
    required this.descEN,
    required this.descFR,
    required this.protein,
    required this.water,
    required this.lipidTotal,
    required this.energKcal,
    required this.carbohydrates,
    required this.ash,
    required this.fiber,
    required this.sugar,
    required this.calcium,
    required this.iron,
    required this.magnesium,
    required this.phosphorus,
    required this.potassium,
    required this.sodium,
    required this.zinc,
    required this.copper,
    required this.manganese,
    required this.selenium,
    required this.vitaminC,
    required this.thiamin,
    required this.riboflavin,
    required this.niacin,
    required this.pantoAcid,
    required this.vitaminB6,
    required this.folateTotal,
    required this.folicAcid,
    required this.foodFolate,
    required this.folateDFE,
    required this.cholineTotal,
    required this.vitaminB12,
    required this.vitaminAIU,
    required this.vitaminARAE,
    required this.retinol,
    required this.alphaCarot,
    required this.betaCarot,
    required this.betaCrypt,
    required this.lycopene,
    required this.lutZea,
    required this.vitaminE,
    required this.vitaminD,
    required this.vitaminDIU,
    required this.vitaminK,
    required this.faSat,
    required this.faMono,
    required this.faPoly,
    required this.cholesterol,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['food_id'] = Variable<int>(foodId);
    map['desc_en'] = Variable<String>(descEN);
    map['desc_fr'] = Variable<String>(descFR);
    map['protein'] = Variable<double>(protein);
    map['water'] = Variable<double>(water);
    map['lipid_total'] = Variable<double>(lipidTotal);
    map['energ_kcal'] = Variable<double>(energKcal);
    map['carbohydrates'] = Variable<double>(carbohydrates);
    map['ash'] = Variable<double>(ash);
    map['fiber'] = Variable<double>(fiber);
    map['sugar'] = Variable<double>(sugar);
    map['calcium'] = Variable<double>(calcium);
    map['iron'] = Variable<double>(iron);
    map['magnesium'] = Variable<double>(magnesium);
    map['phosphorus'] = Variable<double>(phosphorus);
    map['potassium'] = Variable<double>(potassium);
    map['sodium'] = Variable<double>(sodium);
    map['zinc'] = Variable<double>(zinc);
    map['copper'] = Variable<double>(copper);
    map['manganese'] = Variable<double>(manganese);
    map['selenium'] = Variable<double>(selenium);
    map['vitamin_c'] = Variable<double>(vitaminC);
    map['thiamin'] = Variable<double>(thiamin);
    map['riboflavin'] = Variable<double>(riboflavin);
    map['niacin'] = Variable<double>(niacin);
    map['panto_acid'] = Variable<double>(pantoAcid);
    map['vitamin_b6'] = Variable<double>(vitaminB6);
    map['folate_total'] = Variable<double>(folateTotal);
    map['folic_acid'] = Variable<double>(folicAcid);
    map['food_folate'] = Variable<double>(foodFolate);
    map['folate_dfe'] = Variable<double>(folateDFE);
    map['choline_total'] = Variable<double>(cholineTotal);
    map['vitamin_b12'] = Variable<double>(vitaminB12);
    map['vitamin_a_iu'] = Variable<double>(vitaminAIU);
    map['vitamin_a_rae'] = Variable<double>(vitaminARAE);
    map['retinol'] = Variable<double>(retinol);
    map['alpha_carot'] = Variable<double>(alphaCarot);
    map['beta_carot'] = Variable<double>(betaCarot);
    map['beta_crypt'] = Variable<double>(betaCrypt);
    map['lycopene'] = Variable<double>(lycopene);
    map['lut_zea'] = Variable<double>(lutZea);
    map['vitamin_e'] = Variable<double>(vitaminE);
    map['vitamin_d'] = Variable<double>(vitaminD);
    map['vitamin_d_iu'] = Variable<double>(vitaminDIU);
    map['vitamin_k'] = Variable<double>(vitaminK);
    map['fa_sat'] = Variable<double>(faSat);
    map['fa_mono'] = Variable<double>(faMono);
    map['fa_poly'] = Variable<double>(faPoly);
    map['cholesterol'] = Variable<double>(cholesterol);
    return map;
  }

  NutrientsCompanion toCompanion(bool nullToAbsent) {
    return NutrientsCompanion(
      id: Value(id),
      foodId: Value(foodId),
      descEN: Value(descEN),
      descFR: Value(descFR),
      protein: Value(protein),
      water: Value(water),
      lipidTotal: Value(lipidTotal),
      energKcal: Value(energKcal),
      carbohydrates: Value(carbohydrates),
      ash: Value(ash),
      fiber: Value(fiber),
      sugar: Value(sugar),
      calcium: Value(calcium),
      iron: Value(iron),
      magnesium: Value(magnesium),
      phosphorus: Value(phosphorus),
      potassium: Value(potassium),
      sodium: Value(sodium),
      zinc: Value(zinc),
      copper: Value(copper),
      manganese: Value(manganese),
      selenium: Value(selenium),
      vitaminC: Value(vitaminC),
      thiamin: Value(thiamin),
      riboflavin: Value(riboflavin),
      niacin: Value(niacin),
      pantoAcid: Value(pantoAcid),
      vitaminB6: Value(vitaminB6),
      folateTotal: Value(folateTotal),
      folicAcid: Value(folicAcid),
      foodFolate: Value(foodFolate),
      folateDFE: Value(folateDFE),
      cholineTotal: Value(cholineTotal),
      vitaminB12: Value(vitaminB12),
      vitaminAIU: Value(vitaminAIU),
      vitaminARAE: Value(vitaminARAE),
      retinol: Value(retinol),
      alphaCarot: Value(alphaCarot),
      betaCarot: Value(betaCarot),
      betaCrypt: Value(betaCrypt),
      lycopene: Value(lycopene),
      lutZea: Value(lutZea),
      vitaminE: Value(vitaminE),
      vitaminD: Value(vitaminD),
      vitaminDIU: Value(vitaminDIU),
      vitaminK: Value(vitaminK),
      faSat: Value(faSat),
      faMono: Value(faMono),
      faPoly: Value(faPoly),
      cholesterol: Value(cholesterol),
    );
  }

  factory NutrientRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NutrientRow(
      id: serializer.fromJson<int>(json['id']),
      foodId: serializer.fromJson<int>(json['foodId']),
      descEN: serializer.fromJson<String>(json['descEN']),
      descFR: serializer.fromJson<String>(json['descFR']),
      protein: serializer.fromJson<double>(json['protein']),
      water: serializer.fromJson<double>(json['water']),
      lipidTotal: serializer.fromJson<double>(json['lipidTotal']),
      energKcal: serializer.fromJson<double>(json['energKcal']),
      carbohydrates: serializer.fromJson<double>(json['carbohydrates']),
      ash: serializer.fromJson<double>(json['ash']),
      fiber: serializer.fromJson<double>(json['fiber']),
      sugar: serializer.fromJson<double>(json['sugar']),
      calcium: serializer.fromJson<double>(json['calcium']),
      iron: serializer.fromJson<double>(json['iron']),
      magnesium: serializer.fromJson<double>(json['magnesium']),
      phosphorus: serializer.fromJson<double>(json['phosphorus']),
      potassium: serializer.fromJson<double>(json['potassium']),
      sodium: serializer.fromJson<double>(json['sodium']),
      zinc: serializer.fromJson<double>(json['zinc']),
      copper: serializer.fromJson<double>(json['copper']),
      manganese: serializer.fromJson<double>(json['manganese']),
      selenium: serializer.fromJson<double>(json['selenium']),
      vitaminC: serializer.fromJson<double>(json['vitaminC']),
      thiamin: serializer.fromJson<double>(json['thiamin']),
      riboflavin: serializer.fromJson<double>(json['riboflavin']),
      niacin: serializer.fromJson<double>(json['niacin']),
      pantoAcid: serializer.fromJson<double>(json['pantoAcid']),
      vitaminB6: serializer.fromJson<double>(json['vitaminB6']),
      folateTotal: serializer.fromJson<double>(json['folateTotal']),
      folicAcid: serializer.fromJson<double>(json['folicAcid']),
      foodFolate: serializer.fromJson<double>(json['foodFolate']),
      folateDFE: serializer.fromJson<double>(json['folateDFE']),
      cholineTotal: serializer.fromJson<double>(json['cholineTotal']),
      vitaminB12: serializer.fromJson<double>(json['vitaminB12']),
      vitaminAIU: serializer.fromJson<double>(json['vitaminAIU']),
      vitaminARAE: serializer.fromJson<double>(json['vitaminARAE']),
      retinol: serializer.fromJson<double>(json['retinol']),
      alphaCarot: serializer.fromJson<double>(json['alphaCarot']),
      betaCarot: serializer.fromJson<double>(json['betaCarot']),
      betaCrypt: serializer.fromJson<double>(json['betaCrypt']),
      lycopene: serializer.fromJson<double>(json['lycopene']),
      lutZea: serializer.fromJson<double>(json['lutZea']),
      vitaminE: serializer.fromJson<double>(json['vitaminE']),
      vitaminD: serializer.fromJson<double>(json['vitaminD']),
      vitaminDIU: serializer.fromJson<double>(json['vitaminDIU']),
      vitaminK: serializer.fromJson<double>(json['vitaminK']),
      faSat: serializer.fromJson<double>(json['faSat']),
      faMono: serializer.fromJson<double>(json['faMono']),
      faPoly: serializer.fromJson<double>(json['faPoly']),
      cholesterol: serializer.fromJson<double>(json['cholesterol']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'foodId': serializer.toJson<int>(foodId),
      'descEN': serializer.toJson<String>(descEN),
      'descFR': serializer.toJson<String>(descFR),
      'protein': serializer.toJson<double>(protein),
      'water': serializer.toJson<double>(water),
      'lipidTotal': serializer.toJson<double>(lipidTotal),
      'energKcal': serializer.toJson<double>(energKcal),
      'carbohydrates': serializer.toJson<double>(carbohydrates),
      'ash': serializer.toJson<double>(ash),
      'fiber': serializer.toJson<double>(fiber),
      'sugar': serializer.toJson<double>(sugar),
      'calcium': serializer.toJson<double>(calcium),
      'iron': serializer.toJson<double>(iron),
      'magnesium': serializer.toJson<double>(magnesium),
      'phosphorus': serializer.toJson<double>(phosphorus),
      'potassium': serializer.toJson<double>(potassium),
      'sodium': serializer.toJson<double>(sodium),
      'zinc': serializer.toJson<double>(zinc),
      'copper': serializer.toJson<double>(copper),
      'manganese': serializer.toJson<double>(manganese),
      'selenium': serializer.toJson<double>(selenium),
      'vitaminC': serializer.toJson<double>(vitaminC),
      'thiamin': serializer.toJson<double>(thiamin),
      'riboflavin': serializer.toJson<double>(riboflavin),
      'niacin': serializer.toJson<double>(niacin),
      'pantoAcid': serializer.toJson<double>(pantoAcid),
      'vitaminB6': serializer.toJson<double>(vitaminB6),
      'folateTotal': serializer.toJson<double>(folateTotal),
      'folicAcid': serializer.toJson<double>(folicAcid),
      'foodFolate': serializer.toJson<double>(foodFolate),
      'folateDFE': serializer.toJson<double>(folateDFE),
      'cholineTotal': serializer.toJson<double>(cholineTotal),
      'vitaminB12': serializer.toJson<double>(vitaminB12),
      'vitaminAIU': serializer.toJson<double>(vitaminAIU),
      'vitaminARAE': serializer.toJson<double>(vitaminARAE),
      'retinol': serializer.toJson<double>(retinol),
      'alphaCarot': serializer.toJson<double>(alphaCarot),
      'betaCarot': serializer.toJson<double>(betaCarot),
      'betaCrypt': serializer.toJson<double>(betaCrypt),
      'lycopene': serializer.toJson<double>(lycopene),
      'lutZea': serializer.toJson<double>(lutZea),
      'vitaminE': serializer.toJson<double>(vitaminE),
      'vitaminD': serializer.toJson<double>(vitaminD),
      'vitaminDIU': serializer.toJson<double>(vitaminDIU),
      'vitaminK': serializer.toJson<double>(vitaminK),
      'faSat': serializer.toJson<double>(faSat),
      'faMono': serializer.toJson<double>(faMono),
      'faPoly': serializer.toJson<double>(faPoly),
      'cholesterol': serializer.toJson<double>(cholesterol),
    };
  }

  NutrientRow copyWith({
    int? id,
    int? foodId,
    String? descEN,
    String? descFR,
    double? protein,
    double? water,
    double? lipidTotal,
    double? energKcal,
    double? carbohydrates,
    double? ash,
    double? fiber,
    double? sugar,
    double? calcium,
    double? iron,
    double? magnesium,
    double? phosphorus,
    double? potassium,
    double? sodium,
    double? zinc,
    double? copper,
    double? manganese,
    double? selenium,
    double? vitaminC,
    double? thiamin,
    double? riboflavin,
    double? niacin,
    double? pantoAcid,
    double? vitaminB6,
    double? folateTotal,
    double? folicAcid,
    double? foodFolate,
    double? folateDFE,
    double? cholineTotal,
    double? vitaminB12,
    double? vitaminAIU,
    double? vitaminARAE,
    double? retinol,
    double? alphaCarot,
    double? betaCarot,
    double? betaCrypt,
    double? lycopene,
    double? lutZea,
    double? vitaminE,
    double? vitaminD,
    double? vitaminDIU,
    double? vitaminK,
    double? faSat,
    double? faMono,
    double? faPoly,
    double? cholesterol,
  }) => NutrientRow(
    id: id ?? this.id,
    foodId: foodId ?? this.foodId,
    descEN: descEN ?? this.descEN,
    descFR: descFR ?? this.descFR,
    protein: protein ?? this.protein,
    water: water ?? this.water,
    lipidTotal: lipidTotal ?? this.lipidTotal,
    energKcal: energKcal ?? this.energKcal,
    carbohydrates: carbohydrates ?? this.carbohydrates,
    ash: ash ?? this.ash,
    fiber: fiber ?? this.fiber,
    sugar: sugar ?? this.sugar,
    calcium: calcium ?? this.calcium,
    iron: iron ?? this.iron,
    magnesium: magnesium ?? this.magnesium,
    phosphorus: phosphorus ?? this.phosphorus,
    potassium: potassium ?? this.potassium,
    sodium: sodium ?? this.sodium,
    zinc: zinc ?? this.zinc,
    copper: copper ?? this.copper,
    manganese: manganese ?? this.manganese,
    selenium: selenium ?? this.selenium,
    vitaminC: vitaminC ?? this.vitaminC,
    thiamin: thiamin ?? this.thiamin,
    riboflavin: riboflavin ?? this.riboflavin,
    niacin: niacin ?? this.niacin,
    pantoAcid: pantoAcid ?? this.pantoAcid,
    vitaminB6: vitaminB6 ?? this.vitaminB6,
    folateTotal: folateTotal ?? this.folateTotal,
    folicAcid: folicAcid ?? this.folicAcid,
    foodFolate: foodFolate ?? this.foodFolate,
    folateDFE: folateDFE ?? this.folateDFE,
    cholineTotal: cholineTotal ?? this.cholineTotal,
    vitaminB12: vitaminB12 ?? this.vitaminB12,
    vitaminAIU: vitaminAIU ?? this.vitaminAIU,
    vitaminARAE: vitaminARAE ?? this.vitaminARAE,
    retinol: retinol ?? this.retinol,
    alphaCarot: alphaCarot ?? this.alphaCarot,
    betaCarot: betaCarot ?? this.betaCarot,
    betaCrypt: betaCrypt ?? this.betaCrypt,
    lycopene: lycopene ?? this.lycopene,
    lutZea: lutZea ?? this.lutZea,
    vitaminE: vitaminE ?? this.vitaminE,
    vitaminD: vitaminD ?? this.vitaminD,
    vitaminDIU: vitaminDIU ?? this.vitaminDIU,
    vitaminK: vitaminK ?? this.vitaminK,
    faSat: faSat ?? this.faSat,
    faMono: faMono ?? this.faMono,
    faPoly: faPoly ?? this.faPoly,
    cholesterol: cholesterol ?? this.cholesterol,
  );
  NutrientRow copyWithCompanion(NutrientsCompanion data) {
    return NutrientRow(
      id: data.id.present ? data.id.value : this.id,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      descEN: data.descEN.present ? data.descEN.value : this.descEN,
      descFR: data.descFR.present ? data.descFR.value : this.descFR,
      protein: data.protein.present ? data.protein.value : this.protein,
      water: data.water.present ? data.water.value : this.water,
      lipidTotal: data.lipidTotal.present ? data.lipidTotal.value : this.lipidTotal,
      energKcal: data.energKcal.present ? data.energKcal.value : this.energKcal,
      carbohydrates: data.carbohydrates.present ? data.carbohydrates.value : this.carbohydrates,
      ash: data.ash.present ? data.ash.value : this.ash,
      fiber: data.fiber.present ? data.fiber.value : this.fiber,
      sugar: data.sugar.present ? data.sugar.value : this.sugar,
      calcium: data.calcium.present ? data.calcium.value : this.calcium,
      iron: data.iron.present ? data.iron.value : this.iron,
      magnesium: data.magnesium.present ? data.magnesium.value : this.magnesium,
      phosphorus: data.phosphorus.present ? data.phosphorus.value : this.phosphorus,
      potassium: data.potassium.present ? data.potassium.value : this.potassium,
      sodium: data.sodium.present ? data.sodium.value : this.sodium,
      zinc: data.zinc.present ? data.zinc.value : this.zinc,
      copper: data.copper.present ? data.copper.value : this.copper,
      manganese: data.manganese.present ? data.manganese.value : this.manganese,
      selenium: data.selenium.present ? data.selenium.value : this.selenium,
      vitaminC: data.vitaminC.present ? data.vitaminC.value : this.vitaminC,
      thiamin: data.thiamin.present ? data.thiamin.value : this.thiamin,
      riboflavin: data.riboflavin.present ? data.riboflavin.value : this.riboflavin,
      niacin: data.niacin.present ? data.niacin.value : this.niacin,
      pantoAcid: data.pantoAcid.present ? data.pantoAcid.value : this.pantoAcid,
      vitaminB6: data.vitaminB6.present ? data.vitaminB6.value : this.vitaminB6,
      folateTotal: data.folateTotal.present ? data.folateTotal.value : this.folateTotal,
      folicAcid: data.folicAcid.present ? data.folicAcid.value : this.folicAcid,
      foodFolate: data.foodFolate.present ? data.foodFolate.value : this.foodFolate,
      folateDFE: data.folateDFE.present ? data.folateDFE.value : this.folateDFE,
      cholineTotal: data.cholineTotal.present ? data.cholineTotal.value : this.cholineTotal,
      vitaminB12: data.vitaminB12.present ? data.vitaminB12.value : this.vitaminB12,
      vitaminAIU: data.vitaminAIU.present ? data.vitaminAIU.value : this.vitaminAIU,
      vitaminARAE: data.vitaminARAE.present ? data.vitaminARAE.value : this.vitaminARAE,
      retinol: data.retinol.present ? data.retinol.value : this.retinol,
      alphaCarot: data.alphaCarot.present ? data.alphaCarot.value : this.alphaCarot,
      betaCarot: data.betaCarot.present ? data.betaCarot.value : this.betaCarot,
      betaCrypt: data.betaCrypt.present ? data.betaCrypt.value : this.betaCrypt,
      lycopene: data.lycopene.present ? data.lycopene.value : this.lycopene,
      lutZea: data.lutZea.present ? data.lutZea.value : this.lutZea,
      vitaminE: data.vitaminE.present ? data.vitaminE.value : this.vitaminE,
      vitaminD: data.vitaminD.present ? data.vitaminD.value : this.vitaminD,
      vitaminDIU: data.vitaminDIU.present ? data.vitaminDIU.value : this.vitaminDIU,
      vitaminK: data.vitaminK.present ? data.vitaminK.value : this.vitaminK,
      faSat: data.faSat.present ? data.faSat.value : this.faSat,
      faMono: data.faMono.present ? data.faMono.value : this.faMono,
      faPoly: data.faPoly.present ? data.faPoly.value : this.faPoly,
      cholesterol: data.cholesterol.present ? data.cholesterol.value : this.cholesterol,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NutrientRow(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('descEN: $descEN, ')
          ..write('descFR: $descFR, ')
          ..write('protein: $protein, ')
          ..write('water: $water, ')
          ..write('lipidTotal: $lipidTotal, ')
          ..write('energKcal: $energKcal, ')
          ..write('carbohydrates: $carbohydrates, ')
          ..write('ash: $ash, ')
          ..write('fiber: $fiber, ')
          ..write('sugar: $sugar, ')
          ..write('calcium: $calcium, ')
          ..write('iron: $iron, ')
          ..write('magnesium: $magnesium, ')
          ..write('phosphorus: $phosphorus, ')
          ..write('potassium: $potassium, ')
          ..write('sodium: $sodium, ')
          ..write('zinc: $zinc, ')
          ..write('copper: $copper, ')
          ..write('manganese: $manganese, ')
          ..write('selenium: $selenium, ')
          ..write('vitaminC: $vitaminC, ')
          ..write('thiamin: $thiamin, ')
          ..write('riboflavin: $riboflavin, ')
          ..write('niacin: $niacin, ')
          ..write('pantoAcid: $pantoAcid, ')
          ..write('vitaminB6: $vitaminB6, ')
          ..write('folateTotal: $folateTotal, ')
          ..write('folicAcid: $folicAcid, ')
          ..write('foodFolate: $foodFolate, ')
          ..write('folateDFE: $folateDFE, ')
          ..write('cholineTotal: $cholineTotal, ')
          ..write('vitaminB12: $vitaminB12, ')
          ..write('vitaminAIU: $vitaminAIU, ')
          ..write('vitaminARAE: $vitaminARAE, ')
          ..write('retinol: $retinol, ')
          ..write('alphaCarot: $alphaCarot, ')
          ..write('betaCarot: $betaCarot, ')
          ..write('betaCrypt: $betaCrypt, ')
          ..write('lycopene: $lycopene, ')
          ..write('lutZea: $lutZea, ')
          ..write('vitaminE: $vitaminE, ')
          ..write('vitaminD: $vitaminD, ')
          ..write('vitaminDIU: $vitaminDIU, ')
          ..write('vitaminK: $vitaminK, ')
          ..write('faSat: $faSat, ')
          ..write('faMono: $faMono, ')
          ..write('faPoly: $faPoly, ')
          ..write('cholesterol: $cholesterol')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    foodId,
    descEN,
    descFR,
    protein,
    water,
    lipidTotal,
    energKcal,
    carbohydrates,
    ash,
    fiber,
    sugar,
    calcium,
    iron,
    magnesium,
    phosphorus,
    potassium,
    sodium,
    zinc,
    copper,
    manganese,
    selenium,
    vitaminC,
    thiamin,
    riboflavin,
    niacin,
    pantoAcid,
    vitaminB6,
    folateTotal,
    folicAcid,
    foodFolate,
    folateDFE,
    cholineTotal,
    vitaminB12,
    vitaminAIU,
    vitaminARAE,
    retinol,
    alphaCarot,
    betaCarot,
    betaCrypt,
    lycopene,
    lutZea,
    vitaminE,
    vitaminD,
    vitaminDIU,
    vitaminK,
    faSat,
    faMono,
    faPoly,
    cholesterol,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NutrientRow &&
          other.id == this.id &&
          other.foodId == this.foodId &&
          other.descEN == this.descEN &&
          other.descFR == this.descFR &&
          other.protein == this.protein &&
          other.water == this.water &&
          other.lipidTotal == this.lipidTotal &&
          other.energKcal == this.energKcal &&
          other.carbohydrates == this.carbohydrates &&
          other.ash == this.ash &&
          other.fiber == this.fiber &&
          other.sugar == this.sugar &&
          other.calcium == this.calcium &&
          other.iron == this.iron &&
          other.magnesium == this.magnesium &&
          other.phosphorus == this.phosphorus &&
          other.potassium == this.potassium &&
          other.sodium == this.sodium &&
          other.zinc == this.zinc &&
          other.copper == this.copper &&
          other.manganese == this.manganese &&
          other.selenium == this.selenium &&
          other.vitaminC == this.vitaminC &&
          other.thiamin == this.thiamin &&
          other.riboflavin == this.riboflavin &&
          other.niacin == this.niacin &&
          other.pantoAcid == this.pantoAcid &&
          other.vitaminB6 == this.vitaminB6 &&
          other.folateTotal == this.folateTotal &&
          other.folicAcid == this.folicAcid &&
          other.foodFolate == this.foodFolate &&
          other.folateDFE == this.folateDFE &&
          other.cholineTotal == this.cholineTotal &&
          other.vitaminB12 == this.vitaminB12 &&
          other.vitaminAIU == this.vitaminAIU &&
          other.vitaminARAE == this.vitaminARAE &&
          other.retinol == this.retinol &&
          other.alphaCarot == this.alphaCarot &&
          other.betaCarot == this.betaCarot &&
          other.betaCrypt == this.betaCrypt &&
          other.lycopene == this.lycopene &&
          other.lutZea == this.lutZea &&
          other.vitaminE == this.vitaminE &&
          other.vitaminD == this.vitaminD &&
          other.vitaminDIU == this.vitaminDIU &&
          other.vitaminK == this.vitaminK &&
          other.faSat == this.faSat &&
          other.faMono == this.faMono &&
          other.faPoly == this.faPoly &&
          other.cholesterol == this.cholesterol);
}

class NutrientsCompanion extends UpdateCompanion<NutrientRow> {
  final Value<int> id;
  final Value<int> foodId;
  final Value<String> descEN;
  final Value<String> descFR;
  final Value<double> protein;
  final Value<double> water;
  final Value<double> lipidTotal;
  final Value<double> energKcal;
  final Value<double> carbohydrates;
  final Value<double> ash;
  final Value<double> fiber;
  final Value<double> sugar;
  final Value<double> calcium;
  final Value<double> iron;
  final Value<double> magnesium;
  final Value<double> phosphorus;
  final Value<double> potassium;
  final Value<double> sodium;
  final Value<double> zinc;
  final Value<double> copper;
  final Value<double> manganese;
  final Value<double> selenium;
  final Value<double> vitaminC;
  final Value<double> thiamin;
  final Value<double> riboflavin;
  final Value<double> niacin;
  final Value<double> pantoAcid;
  final Value<double> vitaminB6;
  final Value<double> folateTotal;
  final Value<double> folicAcid;
  final Value<double> foodFolate;
  final Value<double> folateDFE;
  final Value<double> cholineTotal;
  final Value<double> vitaminB12;
  final Value<double> vitaminAIU;
  final Value<double> vitaminARAE;
  final Value<double> retinol;
  final Value<double> alphaCarot;
  final Value<double> betaCarot;
  final Value<double> betaCrypt;
  final Value<double> lycopene;
  final Value<double> lutZea;
  final Value<double> vitaminE;
  final Value<double> vitaminD;
  final Value<double> vitaminDIU;
  final Value<double> vitaminK;
  final Value<double> faSat;
  final Value<double> faMono;
  final Value<double> faPoly;
  final Value<double> cholesterol;
  const NutrientsCompanion({
    this.id = const Value.absent(),
    this.foodId = const Value.absent(),
    this.descEN = const Value.absent(),
    this.descFR = const Value.absent(),
    this.protein = const Value.absent(),
    this.water = const Value.absent(),
    this.lipidTotal = const Value.absent(),
    this.energKcal = const Value.absent(),
    this.carbohydrates = const Value.absent(),
    this.ash = const Value.absent(),
    this.fiber = const Value.absent(),
    this.sugar = const Value.absent(),
    this.calcium = const Value.absent(),
    this.iron = const Value.absent(),
    this.magnesium = const Value.absent(),
    this.phosphorus = const Value.absent(),
    this.potassium = const Value.absent(),
    this.sodium = const Value.absent(),
    this.zinc = const Value.absent(),
    this.copper = const Value.absent(),
    this.manganese = const Value.absent(),
    this.selenium = const Value.absent(),
    this.vitaminC = const Value.absent(),
    this.thiamin = const Value.absent(),
    this.riboflavin = const Value.absent(),
    this.niacin = const Value.absent(),
    this.pantoAcid = const Value.absent(),
    this.vitaminB6 = const Value.absent(),
    this.folateTotal = const Value.absent(),
    this.folicAcid = const Value.absent(),
    this.foodFolate = const Value.absent(),
    this.folateDFE = const Value.absent(),
    this.cholineTotal = const Value.absent(),
    this.vitaminB12 = const Value.absent(),
    this.vitaminAIU = const Value.absent(),
    this.vitaminARAE = const Value.absent(),
    this.retinol = const Value.absent(),
    this.alphaCarot = const Value.absent(),
    this.betaCarot = const Value.absent(),
    this.betaCrypt = const Value.absent(),
    this.lycopene = const Value.absent(),
    this.lutZea = const Value.absent(),
    this.vitaminE = const Value.absent(),
    this.vitaminD = const Value.absent(),
    this.vitaminDIU = const Value.absent(),
    this.vitaminK = const Value.absent(),
    this.faSat = const Value.absent(),
    this.faMono = const Value.absent(),
    this.faPoly = const Value.absent(),
    this.cholesterol = const Value.absent(),
  });
  NutrientsCompanion.insert({
    this.id = const Value.absent(),
    required int foodId,
    required String descEN,
    required String descFR,
    required double protein,
    required double water,
    required double lipidTotal,
    required double energKcal,
    required double carbohydrates,
    required double ash,
    required double fiber,
    required double sugar,
    required double calcium,
    required double iron,
    required double magnesium,
    required double phosphorus,
    required double potassium,
    required double sodium,
    required double zinc,
    required double copper,
    required double manganese,
    required double selenium,
    required double vitaminC,
    required double thiamin,
    required double riboflavin,
    required double niacin,
    required double pantoAcid,
    required double vitaminB6,
    required double folateTotal,
    required double folicAcid,
    required double foodFolate,
    required double folateDFE,
    required double cholineTotal,
    required double vitaminB12,
    required double vitaminAIU,
    required double vitaminARAE,
    required double retinol,
    required double alphaCarot,
    required double betaCarot,
    required double betaCrypt,
    required double lycopene,
    required double lutZea,
    required double vitaminE,
    required double vitaminD,
    required double vitaminDIU,
    required double vitaminK,
    required double faSat,
    required double faMono,
    required double faPoly,
    required double cholesterol,
  }) : foodId = Value(foodId),
       descEN = Value(descEN),
       descFR = Value(descFR),
       protein = Value(protein),
       water = Value(water),
       lipidTotal = Value(lipidTotal),
       energKcal = Value(energKcal),
       carbohydrates = Value(carbohydrates),
       ash = Value(ash),
       fiber = Value(fiber),
       sugar = Value(sugar),
       calcium = Value(calcium),
       iron = Value(iron),
       magnesium = Value(magnesium),
       phosphorus = Value(phosphorus),
       potassium = Value(potassium),
       sodium = Value(sodium),
       zinc = Value(zinc),
       copper = Value(copper),
       manganese = Value(manganese),
       selenium = Value(selenium),
       vitaminC = Value(vitaminC),
       thiamin = Value(thiamin),
       riboflavin = Value(riboflavin),
       niacin = Value(niacin),
       pantoAcid = Value(pantoAcid),
       vitaminB6 = Value(vitaminB6),
       folateTotal = Value(folateTotal),
       folicAcid = Value(folicAcid),
       foodFolate = Value(foodFolate),
       folateDFE = Value(folateDFE),
       cholineTotal = Value(cholineTotal),
       vitaminB12 = Value(vitaminB12),
       vitaminAIU = Value(vitaminAIU),
       vitaminARAE = Value(vitaminARAE),
       retinol = Value(retinol),
       alphaCarot = Value(alphaCarot),
       betaCarot = Value(betaCarot),
       betaCrypt = Value(betaCrypt),
       lycopene = Value(lycopene),
       lutZea = Value(lutZea),
       vitaminE = Value(vitaminE),
       vitaminD = Value(vitaminD),
       vitaminDIU = Value(vitaminDIU),
       vitaminK = Value(vitaminK),
       faSat = Value(faSat),
       faMono = Value(faMono),
       faPoly = Value(faPoly),
       cholesterol = Value(cholesterol);
  static Insertable<NutrientRow> custom({
    Expression<int>? id,
    Expression<int>? foodId,
    Expression<String>? descEN,
    Expression<String>? descFR,
    Expression<double>? protein,
    Expression<double>? water,
    Expression<double>? lipidTotal,
    Expression<double>? energKcal,
    Expression<double>? carbohydrates,
    Expression<double>? ash,
    Expression<double>? fiber,
    Expression<double>? sugar,
    Expression<double>? calcium,
    Expression<double>? iron,
    Expression<double>? magnesium,
    Expression<double>? phosphorus,
    Expression<double>? potassium,
    Expression<double>? sodium,
    Expression<double>? zinc,
    Expression<double>? copper,
    Expression<double>? manganese,
    Expression<double>? selenium,
    Expression<double>? vitaminC,
    Expression<double>? thiamin,
    Expression<double>? riboflavin,
    Expression<double>? niacin,
    Expression<double>? pantoAcid,
    Expression<double>? vitaminB6,
    Expression<double>? folateTotal,
    Expression<double>? folicAcid,
    Expression<double>? foodFolate,
    Expression<double>? folateDFE,
    Expression<double>? cholineTotal,
    Expression<double>? vitaminB12,
    Expression<double>? vitaminAIU,
    Expression<double>? vitaminARAE,
    Expression<double>? retinol,
    Expression<double>? alphaCarot,
    Expression<double>? betaCarot,
    Expression<double>? betaCrypt,
    Expression<double>? lycopene,
    Expression<double>? lutZea,
    Expression<double>? vitaminE,
    Expression<double>? vitaminD,
    Expression<double>? vitaminDIU,
    Expression<double>? vitaminK,
    Expression<double>? faSat,
    Expression<double>? faMono,
    Expression<double>? faPoly,
    Expression<double>? cholesterol,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foodId != null) 'food_id': foodId,
      if (descEN != null) 'desc_en': descEN,
      if (descFR != null) 'desc_fr': descFR,
      if (protein != null) 'protein': protein,
      if (water != null) 'water': water,
      if (lipidTotal != null) 'lipid_total': lipidTotal,
      if (energKcal != null) 'energ_kcal': energKcal,
      if (carbohydrates != null) 'carbohydrates': carbohydrates,
      if (ash != null) 'ash': ash,
      if (fiber != null) 'fiber': fiber,
      if (sugar != null) 'sugar': sugar,
      if (calcium != null) 'calcium': calcium,
      if (iron != null) 'iron': iron,
      if (magnesium != null) 'magnesium': magnesium,
      if (phosphorus != null) 'phosphorus': phosphorus,
      if (potassium != null) 'potassium': potassium,
      if (sodium != null) 'sodium': sodium,
      if (zinc != null) 'zinc': zinc,
      if (copper != null) 'copper': copper,
      if (manganese != null) 'manganese': manganese,
      if (selenium != null) 'selenium': selenium,
      if (vitaminC != null) 'vitamin_c': vitaminC,
      if (thiamin != null) 'thiamin': thiamin,
      if (riboflavin != null) 'riboflavin': riboflavin,
      if (niacin != null) 'niacin': niacin,
      if (pantoAcid != null) 'panto_acid': pantoAcid,
      if (vitaminB6 != null) 'vitamin_b6': vitaminB6,
      if (folateTotal != null) 'folate_total': folateTotal,
      if (folicAcid != null) 'folic_acid': folicAcid,
      if (foodFolate != null) 'food_folate': foodFolate,
      if (folateDFE != null) 'folate_dfe': folateDFE,
      if (cholineTotal != null) 'choline_total': cholineTotal,
      if (vitaminB12 != null) 'vitamin_b12': vitaminB12,
      if (vitaminAIU != null) 'vitamin_a_iu': vitaminAIU,
      if (vitaminARAE != null) 'vitamin_a_rae': vitaminARAE,
      if (retinol != null) 'retinol': retinol,
      if (alphaCarot != null) 'alpha_carot': alphaCarot,
      if (betaCarot != null) 'beta_carot': betaCarot,
      if (betaCrypt != null) 'beta_crypt': betaCrypt,
      if (lycopene != null) 'lycopene': lycopene,
      if (lutZea != null) 'lut_zea': lutZea,
      if (vitaminE != null) 'vitamin_e': vitaminE,
      if (vitaminD != null) 'vitamin_d': vitaminD,
      if (vitaminDIU != null) 'vitamin_d_iu': vitaminDIU,
      if (vitaminK != null) 'vitamin_k': vitaminK,
      if (faSat != null) 'fa_sat': faSat,
      if (faMono != null) 'fa_mono': faMono,
      if (faPoly != null) 'fa_poly': faPoly,
      if (cholesterol != null) 'cholesterol': cholesterol,
    });
  }

  NutrientsCompanion copyWith({
    Value<int>? id,
    Value<int>? foodId,
    Value<String>? descEN,
    Value<String>? descFR,
    Value<double>? protein,
    Value<double>? water,
    Value<double>? lipidTotal,
    Value<double>? energKcal,
    Value<double>? carbohydrates,
    Value<double>? ash,
    Value<double>? fiber,
    Value<double>? sugar,
    Value<double>? calcium,
    Value<double>? iron,
    Value<double>? magnesium,
    Value<double>? phosphorus,
    Value<double>? potassium,
    Value<double>? sodium,
    Value<double>? zinc,
    Value<double>? copper,
    Value<double>? manganese,
    Value<double>? selenium,
    Value<double>? vitaminC,
    Value<double>? thiamin,
    Value<double>? riboflavin,
    Value<double>? niacin,
    Value<double>? pantoAcid,
    Value<double>? vitaminB6,
    Value<double>? folateTotal,
    Value<double>? folicAcid,
    Value<double>? foodFolate,
    Value<double>? folateDFE,
    Value<double>? cholineTotal,
    Value<double>? vitaminB12,
    Value<double>? vitaminAIU,
    Value<double>? vitaminARAE,
    Value<double>? retinol,
    Value<double>? alphaCarot,
    Value<double>? betaCarot,
    Value<double>? betaCrypt,
    Value<double>? lycopene,
    Value<double>? lutZea,
    Value<double>? vitaminE,
    Value<double>? vitaminD,
    Value<double>? vitaminDIU,
    Value<double>? vitaminK,
    Value<double>? faSat,
    Value<double>? faMono,
    Value<double>? faPoly,
    Value<double>? cholesterol,
  }) {
    return NutrientsCompanion(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      descEN: descEN ?? this.descEN,
      descFR: descFR ?? this.descFR,
      protein: protein ?? this.protein,
      water: water ?? this.water,
      lipidTotal: lipidTotal ?? this.lipidTotal,
      energKcal: energKcal ?? this.energKcal,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      ash: ash ?? this.ash,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      calcium: calcium ?? this.calcium,
      iron: iron ?? this.iron,
      magnesium: magnesium ?? this.magnesium,
      phosphorus: phosphorus ?? this.phosphorus,
      potassium: potassium ?? this.potassium,
      sodium: sodium ?? this.sodium,
      zinc: zinc ?? this.zinc,
      copper: copper ?? this.copper,
      manganese: manganese ?? this.manganese,
      selenium: selenium ?? this.selenium,
      vitaminC: vitaminC ?? this.vitaminC,
      thiamin: thiamin ?? this.thiamin,
      riboflavin: riboflavin ?? this.riboflavin,
      niacin: niacin ?? this.niacin,
      pantoAcid: pantoAcid ?? this.pantoAcid,
      vitaminB6: vitaminB6 ?? this.vitaminB6,
      folateTotal: folateTotal ?? this.folateTotal,
      folicAcid: folicAcid ?? this.folicAcid,
      foodFolate: foodFolate ?? this.foodFolate,
      folateDFE: folateDFE ?? this.folateDFE,
      cholineTotal: cholineTotal ?? this.cholineTotal,
      vitaminB12: vitaminB12 ?? this.vitaminB12,
      vitaminAIU: vitaminAIU ?? this.vitaminAIU,
      vitaminARAE: vitaminARAE ?? this.vitaminARAE,
      retinol: retinol ?? this.retinol,
      alphaCarot: alphaCarot ?? this.alphaCarot,
      betaCarot: betaCarot ?? this.betaCarot,
      betaCrypt: betaCrypt ?? this.betaCrypt,
      lycopene: lycopene ?? this.lycopene,
      lutZea: lutZea ?? this.lutZea,
      vitaminE: vitaminE ?? this.vitaminE,
      vitaminD: vitaminD ?? this.vitaminD,
      vitaminDIU: vitaminDIU ?? this.vitaminDIU,
      vitaminK: vitaminK ?? this.vitaminK,
      faSat: faSat ?? this.faSat,
      faMono: faMono ?? this.faMono,
      faPoly: faPoly ?? this.faPoly,
      cholesterol: cholesterol ?? this.cholesterol,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (descEN.present) {
      map['desc_en'] = Variable<String>(descEN.value);
    }
    if (descFR.present) {
      map['desc_fr'] = Variable<String>(descFR.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (water.present) {
      map['water'] = Variable<double>(water.value);
    }
    if (lipidTotal.present) {
      map['lipid_total'] = Variable<double>(lipidTotal.value);
    }
    if (energKcal.present) {
      map['energ_kcal'] = Variable<double>(energKcal.value);
    }
    if (carbohydrates.present) {
      map['carbohydrates'] = Variable<double>(carbohydrates.value);
    }
    if (ash.present) {
      map['ash'] = Variable<double>(ash.value);
    }
    if (fiber.present) {
      map['fiber'] = Variable<double>(fiber.value);
    }
    if (sugar.present) {
      map['sugar'] = Variable<double>(sugar.value);
    }
    if (calcium.present) {
      map['calcium'] = Variable<double>(calcium.value);
    }
    if (iron.present) {
      map['iron'] = Variable<double>(iron.value);
    }
    if (magnesium.present) {
      map['magnesium'] = Variable<double>(magnesium.value);
    }
    if (phosphorus.present) {
      map['phosphorus'] = Variable<double>(phosphorus.value);
    }
    if (potassium.present) {
      map['potassium'] = Variable<double>(potassium.value);
    }
    if (sodium.present) {
      map['sodium'] = Variable<double>(sodium.value);
    }
    if (zinc.present) {
      map['zinc'] = Variable<double>(zinc.value);
    }
    if (copper.present) {
      map['copper'] = Variable<double>(copper.value);
    }
    if (manganese.present) {
      map['manganese'] = Variable<double>(manganese.value);
    }
    if (selenium.present) {
      map['selenium'] = Variable<double>(selenium.value);
    }
    if (vitaminC.present) {
      map['vitamin_c'] = Variable<double>(vitaminC.value);
    }
    if (thiamin.present) {
      map['thiamin'] = Variable<double>(thiamin.value);
    }
    if (riboflavin.present) {
      map['riboflavin'] = Variable<double>(riboflavin.value);
    }
    if (niacin.present) {
      map['niacin'] = Variable<double>(niacin.value);
    }
    if (pantoAcid.present) {
      map['panto_acid'] = Variable<double>(pantoAcid.value);
    }
    if (vitaminB6.present) {
      map['vitamin_b6'] = Variable<double>(vitaminB6.value);
    }
    if (folateTotal.present) {
      map['folate_total'] = Variable<double>(folateTotal.value);
    }
    if (folicAcid.present) {
      map['folic_acid'] = Variable<double>(folicAcid.value);
    }
    if (foodFolate.present) {
      map['food_folate'] = Variable<double>(foodFolate.value);
    }
    if (folateDFE.present) {
      map['folate_dfe'] = Variable<double>(folateDFE.value);
    }
    if (cholineTotal.present) {
      map['choline_total'] = Variable<double>(cholineTotal.value);
    }
    if (vitaminB12.present) {
      map['vitamin_b12'] = Variable<double>(vitaminB12.value);
    }
    if (vitaminAIU.present) {
      map['vitamin_a_iu'] = Variable<double>(vitaminAIU.value);
    }
    if (vitaminARAE.present) {
      map['vitamin_a_rae'] = Variable<double>(vitaminARAE.value);
    }
    if (retinol.present) {
      map['retinol'] = Variable<double>(retinol.value);
    }
    if (alphaCarot.present) {
      map['alpha_carot'] = Variable<double>(alphaCarot.value);
    }
    if (betaCarot.present) {
      map['beta_carot'] = Variable<double>(betaCarot.value);
    }
    if (betaCrypt.present) {
      map['beta_crypt'] = Variable<double>(betaCrypt.value);
    }
    if (lycopene.present) {
      map['lycopene'] = Variable<double>(lycopene.value);
    }
    if (lutZea.present) {
      map['lut_zea'] = Variable<double>(lutZea.value);
    }
    if (vitaminE.present) {
      map['vitamin_e'] = Variable<double>(vitaminE.value);
    }
    if (vitaminD.present) {
      map['vitamin_d'] = Variable<double>(vitaminD.value);
    }
    if (vitaminDIU.present) {
      map['vitamin_d_iu'] = Variable<double>(vitaminDIU.value);
    }
    if (vitaminK.present) {
      map['vitamin_k'] = Variable<double>(vitaminK.value);
    }
    if (faSat.present) {
      map['fa_sat'] = Variable<double>(faSat.value);
    }
    if (faMono.present) {
      map['fa_mono'] = Variable<double>(faMono.value);
    }
    if (faPoly.present) {
      map['fa_poly'] = Variable<double>(faPoly.value);
    }
    if (cholesterol.present) {
      map['cholesterol'] = Variable<double>(cholesterol.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NutrientsCompanion(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('descEN: $descEN, ')
          ..write('descFR: $descFR, ')
          ..write('protein: $protein, ')
          ..write('water: $water, ')
          ..write('lipidTotal: $lipidTotal, ')
          ..write('energKcal: $energKcal, ')
          ..write('carbohydrates: $carbohydrates, ')
          ..write('ash: $ash, ')
          ..write('fiber: $fiber, ')
          ..write('sugar: $sugar, ')
          ..write('calcium: $calcium, ')
          ..write('iron: $iron, ')
          ..write('magnesium: $magnesium, ')
          ..write('phosphorus: $phosphorus, ')
          ..write('potassium: $potassium, ')
          ..write('sodium: $sodium, ')
          ..write('zinc: $zinc, ')
          ..write('copper: $copper, ')
          ..write('manganese: $manganese, ')
          ..write('selenium: $selenium, ')
          ..write('vitaminC: $vitaminC, ')
          ..write('thiamin: $thiamin, ')
          ..write('riboflavin: $riboflavin, ')
          ..write('niacin: $niacin, ')
          ..write('pantoAcid: $pantoAcid, ')
          ..write('vitaminB6: $vitaminB6, ')
          ..write('folateTotal: $folateTotal, ')
          ..write('folicAcid: $folicAcid, ')
          ..write('foodFolate: $foodFolate, ')
          ..write('folateDFE: $folateDFE, ')
          ..write('cholineTotal: $cholineTotal, ')
          ..write('vitaminB12: $vitaminB12, ')
          ..write('vitaminAIU: $vitaminAIU, ')
          ..write('vitaminARAE: $vitaminARAE, ')
          ..write('retinol: $retinol, ')
          ..write('alphaCarot: $alphaCarot, ')
          ..write('betaCarot: $betaCarot, ')
          ..write('betaCrypt: $betaCrypt, ')
          ..write('lycopene: $lycopene, ')
          ..write('lutZea: $lutZea, ')
          ..write('vitaminE: $vitaminE, ')
          ..write('vitaminD: $vitaminD, ')
          ..write('vitaminDIU: $vitaminDIU, ')
          ..write('vitaminK: $vitaminK, ')
          ..write('faSat: $faSat, ')
          ..write('faMono: $faMono, ')
          ..write('faPoly: $faPoly, ')
          ..write('cholesterol: $cholesterol')
          ..write(')'))
        .toString();
  }
}

class $ConversionsTable extends Conversions with TableInfo<$ConversionsTable, ConversionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measureIdMeta = const VerificationMeta('measureId');
  @override
  late final GeneratedColumn<int> measureId = GeneratedColumn<int>(
    'measure_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descENMeta = const VerificationMeta('descEN');
  @override
  late final GeneratedColumn<String> descEN = GeneratedColumn<String>(
    'desc_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descFRMeta = const VerificationMeta('descFR');
  @override
  late final GeneratedColumn<String> descFR = GeneratedColumn<String>(
    'desc_fr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _factorMeta = const VerificationMeta('factor');
  @override
  late final GeneratedColumn<double> factor = GeneratedColumn<double>(
    'factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, foodId, measureId, descEN, descFR, factor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConversionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('food_id')) {
      context.handle(_foodIdMeta, foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta));
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('measure_id')) {
      context.handle(
        _measureIdMeta,
        measureId.isAcceptableOrUnknown(data['measure_id']!, _measureIdMeta),
      );
    } else if (isInserting) {
      context.missing(_measureIdMeta);
    }
    if (data.containsKey('desc_en')) {
      context.handle(_descENMeta, descEN.isAcceptableOrUnknown(data['desc_en']!, _descENMeta));
    } else if (isInserting) {
      context.missing(_descENMeta);
    }
    if (data.containsKey('desc_fr')) {
      context.handle(_descFRMeta, descFR.isAcceptableOrUnknown(data['desc_fr']!, _descFRMeta));
    } else if (isInserting) {
      context.missing(_descFRMeta);
    }
    if (data.containsKey('factor')) {
      context.handle(_factorMeta, factor.isAcceptableOrUnknown(data['factor']!, _factorMeta));
    } else if (isInserting) {
      context.missing(_factorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConversionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversionRow(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      )!,
      measureId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}measure_id'],
      )!,
      descEN: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}desc_en'],
      )!,
      descFR: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}desc_fr'],
      )!,
      factor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}factor'],
      )!,
    );
  }

  @override
  $ConversionsTable createAlias(String alias) {
    return $ConversionsTable(attachedDatabase, alias);
  }
}

class ConversionRow extends DataClass implements Insertable<ConversionRow> {
  final int id;
  final int foodId;
  final int measureId;
  final String descEN;
  final String descFR;
  final double factor;
  const ConversionRow({
    required this.id,
    required this.foodId,
    required this.measureId,
    required this.descEN,
    required this.descFR,
    required this.factor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['food_id'] = Variable<int>(foodId);
    map['measure_id'] = Variable<int>(measureId);
    map['desc_en'] = Variable<String>(descEN);
    map['desc_fr'] = Variable<String>(descFR);
    map['factor'] = Variable<double>(factor);
    return map;
  }

  ConversionsCompanion toCompanion(bool nullToAbsent) {
    return ConversionsCompanion(
      id: Value(id),
      foodId: Value(foodId),
      measureId: Value(measureId),
      descEN: Value(descEN),
      descFR: Value(descFR),
      factor: Value(factor),
    );
  }

  factory ConversionRow.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversionRow(
      id: serializer.fromJson<int>(json['id']),
      foodId: serializer.fromJson<int>(json['foodId']),
      measureId: serializer.fromJson<int>(json['measureId']),
      descEN: serializer.fromJson<String>(json['descEN']),
      descFR: serializer.fromJson<String>(json['descFR']),
      factor: serializer.fromJson<double>(json['factor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'foodId': serializer.toJson<int>(foodId),
      'measureId': serializer.toJson<int>(measureId),
      'descEN': serializer.toJson<String>(descEN),
      'descFR': serializer.toJson<String>(descFR),
      'factor': serializer.toJson<double>(factor),
    };
  }

  ConversionRow copyWith({
    int? id,
    int? foodId,
    int? measureId,
    String? descEN,
    String? descFR,
    double? factor,
  }) => ConversionRow(
    id: id ?? this.id,
    foodId: foodId ?? this.foodId,
    measureId: measureId ?? this.measureId,
    descEN: descEN ?? this.descEN,
    descFR: descFR ?? this.descFR,
    factor: factor ?? this.factor,
  );
  ConversionRow copyWithCompanion(ConversionsCompanion data) {
    return ConversionRow(
      id: data.id.present ? data.id.value : this.id,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      measureId: data.measureId.present ? data.measureId.value : this.measureId,
      descEN: data.descEN.present ? data.descEN.value : this.descEN,
      descFR: data.descFR.present ? data.descFR.value : this.descFR,
      factor: data.factor.present ? data.factor.value : this.factor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversionRow(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('measureId: $measureId, ')
          ..write('descEN: $descEN, ')
          ..write('descFR: $descFR, ')
          ..write('factor: $factor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, foodId, measureId, descEN, descFR, factor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversionRow &&
          other.id == this.id &&
          other.foodId == this.foodId &&
          other.measureId == this.measureId &&
          other.descEN == this.descEN &&
          other.descFR == this.descFR &&
          other.factor == this.factor);
}

class ConversionsCompanion extends UpdateCompanion<ConversionRow> {
  final Value<int> id;
  final Value<int> foodId;
  final Value<int> measureId;
  final Value<String> descEN;
  final Value<String> descFR;
  final Value<double> factor;
  const ConversionsCompanion({
    this.id = const Value.absent(),
    this.foodId = const Value.absent(),
    this.measureId = const Value.absent(),
    this.descEN = const Value.absent(),
    this.descFR = const Value.absent(),
    this.factor = const Value.absent(),
  });
  ConversionsCompanion.insert({
    this.id = const Value.absent(),
    required int foodId,
    required int measureId,
    required String descEN,
    required String descFR,
    required double factor,
  }) : foodId = Value(foodId),
       measureId = Value(measureId),
       descEN = Value(descEN),
       descFR = Value(descFR),
       factor = Value(factor);
  static Insertable<ConversionRow> custom({
    Expression<int>? id,
    Expression<int>? foodId,
    Expression<int>? measureId,
    Expression<String>? descEN,
    Expression<String>? descFR,
    Expression<double>? factor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (foodId != null) 'food_id': foodId,
      if (measureId != null) 'measure_id': measureId,
      if (descEN != null) 'desc_en': descEN,
      if (descFR != null) 'desc_fr': descFR,
      if (factor != null) 'factor': factor,
    });
  }

  ConversionsCompanion copyWith({
    Value<int>? id,
    Value<int>? foodId,
    Value<int>? measureId,
    Value<String>? descEN,
    Value<String>? descFR,
    Value<double>? factor,
  }) {
    return ConversionsCompanion(
      id: id ?? this.id,
      foodId: foodId ?? this.foodId,
      measureId: measureId ?? this.measureId,
      descEN: descEN ?? this.descEN,
      descFR: descFR ?? this.descFR,
      factor: factor ?? this.factor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (measureId.present) {
      map['measure_id'] = Variable<int>(measureId.value);
    }
    if (descEN.present) {
      map['desc_en'] = Variable<String>(descEN.value);
    }
    if (descFR.present) {
      map['desc_fr'] = Variable<String>(descFR.value);
    }
    if (factor.present) {
      map['factor'] = Variable<double>(factor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversionsCompanion(')
          ..write('id: $id, ')
          ..write('foodId: $foodId, ')
          ..write('measureId: $measureId, ')
          ..write('descEN: $descEN, ')
          ..write('descFR: $descFR, ')
          ..write('factor: $factor')
          ..write(')'))
        .toString();
  }
}

class $MetadataTable extends Metadata with TableInfo<$MetadataTable, MetadataEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetadataEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MetadataEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetadataEntry(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $MetadataTable createAlias(String alias) {
    return $MetadataTable(attachedDatabase, alias);
  }
}

class MetadataEntry extends DataClass implements Insertable<MetadataEntry> {
  final String key;
  final String value;
  const MetadataEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  MetadataCompanion toCompanion(bool nullToAbsent) {
    return MetadataCompanion(key: Value(key), value: Value(value));
  }

  factory MetadataEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetadataEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  MetadataEntry copyWith({String? key, String? value}) =>
      MetadataEntry(key: key ?? this.key, value: value ?? this.value);
  MetadataEntry copyWithCompanion(MetadataCompanion data) {
    return MetadataEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetadataEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetadataEntry && other.key == this.key && other.value == this.value);
}

class MetadataCompanion extends UpdateCompanion<MetadataEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const MetadataCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetadataCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<MetadataEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetadataCompanion copyWith({Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return MetadataCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetadataCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeVariantsTable recipeVariants = $RecipeVariantsTable(this);
  late final $RecipeStepsTable recipeSteps = $RecipeStepsTable(this);
  late final $IngredientItemsTable ingredientItems = $IngredientItemsTable(this);
  late final $NutrientsTable nutrients = $NutrientsTable(this);
  late final $ConversionsTable conversions = $ConversionsTable(this);
  late final $MetadataTable metadata = $MetadataTable(this);
  late final Index recipeVariantsRecipeId = Index(
    'recipe_variants_recipe_id',
    'CREATE INDEX recipe_variants_recipe_id ON recipe_variants (recipe_id)',
  );
  late final Index recipeStepsRecipeId = Index(
    'recipe_steps_recipe_id',
    'CREATE INDEX recipe_steps_recipe_id ON recipe_steps (recipe_id)',
  );
  late final Index recipeStepsVariantId = Index(
    'recipe_steps_variant_id',
    'CREATE INDEX recipe_steps_variant_id ON recipe_steps (variant_id)',
  );
  late final Index ingredientItemsStepId = Index(
    'ingredient_items_step_id',
    'CREATE INDEX ingredient_items_step_id ON ingredient_items (step_id)',
  );
  late final Index ingredientItemsLowerName = Index(
    'ingredient_items_lower_name',
    'CREATE INDEX ingredient_items_lower_name ON ingredient_items (lower_name, shape)',
  );
  late final Index conversionsFoodMeasure = Index(
    'conversions_food_measure',
    'CREATE UNIQUE INDEX conversions_food_measure ON conversions (food_id, measure_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    recipes,
    recipeVariants,
    recipeSteps,
    ingredientItems,
    nutrients,
    conversions,
    metadata,
    recipeVariantsRecipeId,
    recipeStepsRecipeId,
    recipeStepsVariantId,
    ingredientItemsStepId,
    ingredientItemsLowerName,
    conversionsFoodMeasure,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName('recipes', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('recipe_variants', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('recipes', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('recipe_steps', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('recipe_variants', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('recipe_steps', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName('recipe_steps', limitUpdateKind: UpdateKind.delete),
      result: [TableUpdate('ingredient_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  required String title,
  required String source,
  required String imagePath,
  required String notes,
  required int servings,
  Value<int?> piecesPerServing,
  required int category,
  required String countryCode,
  required int calories,
  required int fat,
  required int carbohydrates,
  required int protein,
  required int saturatedFat,
  required int transFat,
  required int sugar,
  required int fiber,
  required int cholesterol,
  required int sodium,
  required int time,
  required int cookTime,
  required int prepTime,
  required int restTime,
  required int month,
  required String makeAhead,
  required String videoUrl,
  required List<String> questions,
  required String languageTag,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> source,
  Value<String> imagePath,
  Value<String> notes,
  Value<int> servings,
  Value<int?> piecesPerServing,
  Value<int> category,
  Value<String> countryCode,
  Value<int> calories,
  Value<int> fat,
  Value<int> carbohydrates,
  Value<int> protein,
  Value<int> saturatedFat,
  Value<int> transFat,
  Value<int> sugar,
  Value<int> fiber,
  Value<int> cholesterol,
  Value<int> sodium,
  Value<int> time,
  Value<int> cookTime,
  Value<int> prepTime,
  Value<int> restTime,
  Value<int> month,
  Value<String> makeAhead,
  Value<String> videoUrl,
  Value<List<String>> questions,
  Value<String> languageTag,
});

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, RecipeRow> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeVariantsTable, List<RecipeVariantRow>> _recipeVariantsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.recipeVariants,
    aliasName: 'recipes__id__recipe_variants__recipe_id',
  );

  $$RecipeVariantsTableProcessedTableManager get recipeVariantsRefs {
    final manager = $$RecipeVariantsTableTableManager(
      $_db,
      $_db.recipeVariants,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeVariantsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RecipeStepsTable, List<RecipeStepRow>> _recipeStepsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.recipeSteps,
    aliasName: 'recipes__id__recipe_steps__recipe_id',
  );

  $$RecipeStepsTableProcessedTableManager get recipeStepsRefs {
    final manager = $$RecipeStepsTableTableManager(
      $_db,
      $_db.recipeSteps,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeStepsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RecipesTableFilterComposer extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get piecesPerServing => $composableBuilder(
    column: $table.piecesPerServing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get countryCode =>
      $composableBuilder(column: $table.countryCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get carbohydrates =>
      $composableBuilder(column: $table.carbohydrates, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get saturatedFat =>
      $composableBuilder(column: $table.saturatedFat, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get transFat =>
      $composableBuilder(column: $table.transFat, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sugar =>
      $composableBuilder(column: $table.sugar, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fiber =>
      $composableBuilder(column: $table.fiber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cholesterol =>
      $composableBuilder(column: $table.cholesterol, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sodium =>
      $composableBuilder(column: $table.sodium, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get time =>
      $composableBuilder(column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cookTime =>
      $composableBuilder(column: $table.cookTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get prepTime =>
      $composableBuilder(column: $table.prepTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get restTime =>
      $composableBuilder(column: $table.restTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get makeAhead =>
      $composableBuilder(column: $table.makeAhead, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String> get questions =>
      $composableBuilder(
        column: $table.questions,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get languageTag =>
      $composableBuilder(column: $table.languageTag, builder: (column) => ColumnFilters(column));

  Expression<bool> recipeVariantsRefs(
    Expression<bool> Function($$RecipeVariantsTableFilterComposer f) f,
  ) {
    final $$RecipeVariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeVariants,
      getReferencedColumn: (t) => t.recipeId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipeVariantsTableFilterComposer(
            $db: $db,
            $table: $db.recipeVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recipeStepsRefs(
    Expression<bool> Function($$RecipeStepsTableFilterComposer f) f,
  ) {
    final $$RecipeStepsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeSteps,
      getReferencedColumn: (t) => t.recipeId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipeStepsTableFilterComposer(
            $db: $db,
            $table: $db.recipeSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get piecesPerServing => $composableBuilder(
    column: $table.piecesPerServing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get countryCode =>
      $composableBuilder(column: $table.countryCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get carbohydrates => $composableBuilder(
    column: $table.carbohydrates,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get saturatedFat =>
      $composableBuilder(column: $table.saturatedFat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get transFat =>
      $composableBuilder(column: $table.transFat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sugar =>
      $composableBuilder(column: $table.sugar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fiber =>
      $composableBuilder(column: $table.fiber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cholesterol =>
      $composableBuilder(column: $table.cholesterol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sodium =>
      $composableBuilder(column: $table.sodium, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get time =>
      $composableBuilder(column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cookTime =>
      $composableBuilder(column: $table.cookTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get prepTime =>
      $composableBuilder(column: $table.prepTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get restTime =>
      $composableBuilder(column: $table.restTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get makeAhead =>
      $composableBuilder(column: $table.makeAhead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get questions =>
      $composableBuilder(column: $table.questions, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get languageTag =>
      $composableBuilder(column: $table.languageTag, builder: (column) => ColumnOrderings(column));
}

class $$RecipesTableAnnotationComposer extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

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

  GeneratedColumn<int> get piecesPerServing =>
      $composableBuilder(column: $table.piecesPerServing, builder: (column) => column);

  GeneratedColumn<int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get countryCode =>
      $composableBuilder(column: $table.countryCode, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<int> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<int> get carbohydrates =>
      $composableBuilder(column: $table.carbohydrates, builder: (column) => column);

  GeneratedColumn<int> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<int> get saturatedFat =>
      $composableBuilder(column: $table.saturatedFat, builder: (column) => column);

  GeneratedColumn<int> get transFat =>
      $composableBuilder(column: $table.transFat, builder: (column) => column);

  GeneratedColumn<int> get sugar =>
      $composableBuilder(column: $table.sugar, builder: (column) => column);

  GeneratedColumn<int> get fiber =>
      $composableBuilder(column: $table.fiber, builder: (column) => column);

  GeneratedColumn<int> get cholesterol =>
      $composableBuilder(column: $table.cholesterol, builder: (column) => column);

  GeneratedColumn<int> get sodium =>
      $composableBuilder(column: $table.sodium, builder: (column) => column);

  GeneratedColumn<int> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<int> get cookTime =>
      $composableBuilder(column: $table.cookTime, builder: (column) => column);

  GeneratedColumn<int> get prepTime =>
      $composableBuilder(column: $table.prepTime, builder: (column) => column);

  GeneratedColumn<int> get restTime =>
      $composableBuilder(column: $table.restTime, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<String> get makeAhead =>
      $composableBuilder(column: $table.makeAhead, builder: (column) => column);

  GeneratedColumn<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get questions =>
      $composableBuilder(column: $table.questions, builder: (column) => column);

  GeneratedColumn<String> get languageTag =>
      $composableBuilder(column: $table.languageTag, builder: (column) => column);

  Expression<T> recipeVariantsRefs<T extends Object>(
    Expression<T> Function($$RecipeVariantsTableAnnotationComposer a) f,
  ) {
    final $$RecipeVariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeVariants,
      getReferencedColumn: (t) => t.recipeId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipeVariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recipeStepsRefs<T extends Object>(
    Expression<T> Function($$RecipeStepsTableAnnotationComposer a) f,
  ) {
    final $$RecipeStepsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeSteps,
      getReferencedColumn: (t) => t.recipeId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipeStepsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          RecipeRow,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (RecipeRow, $$RecipesTableReferences),
          RecipeRow,
          PrefetchHooks Function({bool recipeVariantsRefs, bool recipeStepsRefs})
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<int> servings = const Value.absent(),
                Value<int?> piecesPerServing = const Value.absent(),
                Value<int> category = const Value.absent(),
                Value<String> countryCode = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<int> fat = const Value.absent(),
                Value<int> carbohydrates = const Value.absent(),
                Value<int> protein = const Value.absent(),
                Value<int> saturatedFat = const Value.absent(),
                Value<int> transFat = const Value.absent(),
                Value<int> sugar = const Value.absent(),
                Value<int> fiber = const Value.absent(),
                Value<int> cholesterol = const Value.absent(),
                Value<int> sodium = const Value.absent(),
                Value<int> time = const Value.absent(),
                Value<int> cookTime = const Value.absent(),
                Value<int> prepTime = const Value.absent(),
                Value<int> restTime = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<String> makeAhead = const Value.absent(),
                Value<String> videoUrl = const Value.absent(),
                Value<List<String>> questions = const Value.absent(),
                Value<String> languageTag = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                title: title,
                source: source,
                imagePath: imagePath,
                notes: notes,
                servings: servings,
                piecesPerServing: piecesPerServing,
                category: category,
                countryCode: countryCode,
                calories: calories,
                fat: fat,
                carbohydrates: carbohydrates,
                protein: protein,
                saturatedFat: saturatedFat,
                transFat: transFat,
                sugar: sugar,
                fiber: fiber,
                cholesterol: cholesterol,
                sodium: sodium,
                time: time,
                cookTime: cookTime,
                prepTime: prepTime,
                restTime: restTime,
                month: month,
                makeAhead: makeAhead,
                videoUrl: videoUrl,
                questions: questions,
                languageTag: languageTag,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String source,
                required String imagePath,
                required String notes,
                required int servings,
                Value<int?> piecesPerServing = const Value.absent(),
                required int category,
                required String countryCode,
                required int calories,
                required int fat,
                required int carbohydrates,
                required int protein,
                required int saturatedFat,
                required int transFat,
                required int sugar,
                required int fiber,
                required int cholesterol,
                required int sodium,
                required int time,
                required int cookTime,
                required int prepTime,
                required int restTime,
                required int month,
                required String makeAhead,
                required String videoUrl,
                required List<String> questions,
                required String languageTag,
              }) => RecipesCompanion.insert(
                id: id,
                title: title,
                source: source,
                imagePath: imagePath,
                notes: notes,
                servings: servings,
                piecesPerServing: piecesPerServing,
                category: category,
                countryCode: countryCode,
                calories: calories,
                fat: fat,
                carbohydrates: carbohydrates,
                protein: protein,
                saturatedFat: saturatedFat,
                transFat: transFat,
                sugar: sugar,
                fiber: fiber,
                cholesterol: cholesterol,
                sodium: sodium,
                time: time,
                cookTime: cookTime,
                prepTime: prepTime,
                restTime: restTime,
                month: month,
                makeAhead: makeAhead,
                videoUrl: videoUrl,
                questions: questions,
                languageTag: languageTag,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipesTable, RecipeRow>(table),
                  $$RecipesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeVariantsRefs = false, recipeStepsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recipeVariantsRefs) db.recipeVariants,
                if (recipeStepsRefs) db.recipeSteps,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recipeVariantsRefs)
                    await $_getPrefetchedData<RecipeRow, $RecipesTable, RecipeVariantRow>(
                      currentTable: table,
                      referencedTable: $$RecipesTableReferences._recipeVariantsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RecipesTableReferences(db, table, p0).recipeVariantsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.recipeId == item.id),
                      typedResults: items,
                    ),
                  if (recipeStepsRefs)
                    await $_getPrefetchedData<RecipeRow, $RecipesTable, RecipeStepRow>(
                      currentTable: table,
                      referencedTable: $$RecipesTableReferences._recipeStepsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RecipesTableReferences(db, table, p0).recipeStepsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.recipeId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      RecipeRow,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (RecipeRow, $$RecipesTableReferences),
      RecipeRow,
      PrefetchHooks Function({bool recipeVariantsRefs, bool recipeStepsRefs})
    >;
typedef $$RecipeVariantsTableCreateCompanionBuilder = RecipeVariantsCompanion Function({
  Value<int> id,
  required int recipeId,
  required String title,
});
typedef $$RecipeVariantsTableUpdateCompanionBuilder = RecipeVariantsCompanion Function({
  Value<int> id,
  Value<int> recipeId,
  Value<String> title,
});

final class $$RecipeVariantsTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeVariantsTable, RecipeVariantRow> {
  $$RecipeVariantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias('recipe_variants__recipe_id__recipes__id');

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$RecipeStepsTable, List<RecipeStepRow>> _recipeStepsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.recipeSteps,
    aliasName: 'recipe_variants__id__recipe_steps__variant_id',
  );

  $$RecipeStepsTableProcessedTableManager get recipeStepsRefs {
    final manager = $$RecipeStepsTableTableManager(
      $_db,
      $_db.recipeSteps,
    ).filter((f) => f.variantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeStepsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RecipeVariantsTableFilterComposer extends Composer<_$AppDatabase, $RecipeVariantsTable> {
  $$RecipeVariantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recipeStepsRefs(
    Expression<bool> Function($$RecipeStepsTableFilterComposer f) f,
  ) {
    final $$RecipeStepsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeSteps,
      getReferencedColumn: (t) => t.variantId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipeStepsTableFilterComposer(
            $db: $db,
            $table: $db.recipeSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipeVariantsTableOrderingComposer extends Composer<_$AppDatabase, $RecipeVariantsTable> {
  $$RecipeVariantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeVariantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeVariantsTable> {
  $$RecipeVariantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recipeStepsRefs<T extends Object>(
    Expression<T> Function($$RecipeStepsTableAnnotationComposer a) f,
  ) {
    final $$RecipeStepsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeSteps,
      getReferencedColumn: (t) => t.variantId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipeStepsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipeVariantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeVariantsTable,
          RecipeVariantRow,
          $$RecipeVariantsTableFilterComposer,
          $$RecipeVariantsTableOrderingComposer,
          $$RecipeVariantsTableAnnotationComposer,
          $$RecipeVariantsTableCreateCompanionBuilder,
          $$RecipeVariantsTableUpdateCompanionBuilder,
          (RecipeVariantRow, $$RecipeVariantsTableReferences),
          RecipeVariantRow,
          PrefetchHooks Function({bool recipeId, bool recipeStepsRefs})
        > {
  $$RecipeVariantsTableTableManager(_$AppDatabase db, $RecipeVariantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeVariantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeVariantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeVariantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> recipeId = const Value.absent(),
            Value<String> title = const Value.absent(),
          }) => RecipeVariantsCompanion(id: id, recipeId: recipeId, title: title),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int recipeId,
            required String title,
          }) => RecipeVariantsCompanion.insert(id: id, recipeId: recipeId, title: title),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipeVariantsTable, RecipeVariantRow>(table),
                  $$RecipeVariantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false, recipeStepsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (recipeStepsRefs) db.recipeSteps],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recipeId,
                        referencedTable: $$RecipeVariantsTableReferences._recipeIdTable(db),
                        referencedColumn: $$RecipeVariantsTableReferences._recipeIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recipeStepsRefs)
                    await $_getPrefetchedData<
                      RecipeVariantRow,
                      $RecipeVariantsTable,
                      RecipeStepRow
                    >(
                      currentTable: table,
                      referencedTable: $$RecipeVariantsTableReferences._recipeStepsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RecipeVariantsTableReferences(db, table, p0).recipeStepsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.variantId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RecipeVariantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeVariantsTable,
      RecipeVariantRow,
      $$RecipeVariantsTableFilterComposer,
      $$RecipeVariantsTableOrderingComposer,
      $$RecipeVariantsTableAnnotationComposer,
      $$RecipeVariantsTableCreateCompanionBuilder,
      $$RecipeVariantsTableUpdateCompanionBuilder,
      (RecipeVariantRow, $$RecipeVariantsTableReferences),
      RecipeVariantRow,
      PrefetchHooks Function({bool recipeId, bool recipeStepsRefs})
    >;
typedef $$RecipeStepsTableCreateCompanionBuilder = RecipeStepsCompanion Function({
  Value<int> id,
  Value<int?> recipeId,
  Value<int?> variantId,
  required String name,
  required String instruction,
  required String imagePath,
  required String videoUrl,
  required int timer,
  required int stepOrder,
});
typedef $$RecipeStepsTableUpdateCompanionBuilder = RecipeStepsCompanion Function({
  Value<int> id,
  Value<int?> recipeId,
  Value<int?> variantId,
  Value<String> name,
  Value<String> instruction,
  Value<String> imagePath,
  Value<String> videoUrl,
  Value<int> timer,
  Value<int> stepOrder,
});

final class $$RecipeStepsTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeStepsTable, RecipeStepRow> {
  $$RecipeStepsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias('recipe_steps__recipe_id__recipes__id');

  $$RecipesTableProcessedTableManager? get recipeId {
    final $_column = $_itemColumn<int>('recipe_id');
    if ($_column == null) return null;
    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RecipeVariantsTable _variantIdTable(_$AppDatabase db) =>
      db.recipeVariants.createAlias('recipe_steps__variant_id__recipe_variants__id');

  $$RecipeVariantsTableProcessedTableManager? get variantId {
    final $_column = $_itemColumn<int>('variant_id');
    if ($_column == null) return null;
    final manager = $$RecipeVariantsTableTableManager(
      $_db,
      $_db.recipeVariants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_variantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$IngredientItemsTable, List<IngredientRow>> _ingredientItemsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.ingredientItems,
    aliasName: 'recipe_steps__id__ingredient_items__step_id',
  );

  $$IngredientItemsTableProcessedTableManager get ingredientItemsRefs {
    final manager = $$IngredientItemsTableTableManager(
      $_db,
      $_db.ingredientItems,
    ).filter((f) => f.stepId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ingredientItemsRefsTable($_db));
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RecipeStepsTableFilterComposer extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get instruction =>
      $composableBuilder(column: $table.instruction, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timer =>
      $composableBuilder(column: $table.timer, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stepOrder =>
      $composableBuilder(column: $table.stepOrder, builder: (column) => ColumnFilters(column));

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipeVariantsTableFilterComposer get variantId {
    final $$RecipeVariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.recipeVariants,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipeVariantsTableFilterComposer(
            $db: $db,
            $table: $db.recipeVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ingredientItemsRefs(
    Expression<bool> Function($$IngredientItemsTableFilterComposer f) f,
  ) {
    final $$IngredientItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredientItems,
      getReferencedColumn: (t) => t.stepId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$IngredientItemsTableFilterComposer(
            $db: $db,
            $table: $db.ingredientItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipeStepsTableOrderingComposer extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instruction =>
      $composableBuilder(column: $table.instruction, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timer =>
      $composableBuilder(column: $table.timer, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stepOrder =>
      $composableBuilder(column: $table.stepOrder, builder: (column) => ColumnOrderings(column));

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipeVariantsTableOrderingComposer get variantId {
    final $$RecipeVariantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.recipeVariants,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipeVariantsTableOrderingComposer(
            $db: $db,
            $table: $db.recipeVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeStepsTableAnnotationComposer extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get instruction =>
      $composableBuilder(column: $table.instruction, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get videoUrl =>
      $composableBuilder(column: $table.videoUrl, builder: (column) => column);

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
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipeVariantsTableAnnotationComposer get variantId {
    final $$RecipeVariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.recipeVariants,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipeVariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeVariants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ingredientItemsRefs<T extends Object>(
    Expression<T> Function($$IngredientItemsTableAnnotationComposer a) f,
  ) {
    final $$IngredientItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredientItems,
      getReferencedColumn: (t) => t.stepId,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$IngredientItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredientItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipeStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeStepsTable,
          RecipeStepRow,
          $$RecipeStepsTableFilterComposer,
          $$RecipeStepsTableOrderingComposer,
          $$RecipeStepsTableAnnotationComposer,
          $$RecipeStepsTableCreateCompanionBuilder,
          $$RecipeStepsTableUpdateCompanionBuilder,
          (RecipeStepRow, $$RecipeStepsTableReferences),
          RecipeStepRow,
          PrefetchHooks Function({bool recipeId, bool variantId, bool ingredientItemsRefs})
        > {
  $$RecipeStepsTableTableManager(_$AppDatabase db, $RecipeStepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$RecipeStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$RecipeStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> recipeId = const Value.absent(),
                Value<int?> variantId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> instruction = const Value.absent(),
                Value<String> imagePath = const Value.absent(),
                Value<String> videoUrl = const Value.absent(),
                Value<int> timer = const Value.absent(),
                Value<int> stepOrder = const Value.absent(),
              }) => RecipeStepsCompanion(
                id: id,
                recipeId: recipeId,
                variantId: variantId,
                name: name,
                instruction: instruction,
                imagePath: imagePath,
                videoUrl: videoUrl,
                timer: timer,
                stepOrder: stepOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> recipeId = const Value.absent(),
                Value<int?> variantId = const Value.absent(),
                required String name,
                required String instruction,
                required String imagePath,
                required String videoUrl,
                required int timer,
                required int stepOrder,
              }) => RecipeStepsCompanion.insert(
                id: id,
                recipeId: recipeId,
                variantId: variantId,
                name: name,
                instruction: instruction,
                imagePath: imagePath,
                videoUrl: videoUrl,
                timer: timer,
                stepOrder: stepOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipeStepsTable, RecipeStepRow>(table),
                  $$RecipeStepsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({recipeId = false, variantId = false, ingredientItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (ingredientItemsRefs) db.ingredientItems],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (recipeId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.recipeId,
                            referencedTable: $$RecipeStepsTableReferences._recipeIdTable(db),
                            referencedColumn: $$RecipeStepsTableReferences._recipeIdTable(db).id,
                          ) as T;
                        }
                        if (variantId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.variantId,
                            referencedTable: $$RecipeStepsTableReferences._variantIdTable(db),
                            referencedColumn: $$RecipeStepsTableReferences._variantIdTable(db).id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ingredientItemsRefs)
                        await $_getPrefetchedData<RecipeStepRow, $RecipeStepsTable, IngredientRow>(
                          currentTable: table,
                          referencedTable: $$RecipeStepsTableReferences._ingredientItemsRefsTable(
                            db,
                          ),
                          managerFromTypedResult: (p0) =>
                              $$RecipeStepsTableReferences(db, table, p0).ingredientItemsRefs,
                          referencedItemsForCurrentItem: (item, referencedItems) =>
                              referencedItems.where((e) => e.stepId == item.id),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecipeStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeStepsTable,
      RecipeStepRow,
      $$RecipeStepsTableFilterComposer,
      $$RecipeStepsTableOrderingComposer,
      $$RecipeStepsTableAnnotationComposer,
      $$RecipeStepsTableCreateCompanionBuilder,
      $$RecipeStepsTableUpdateCompanionBuilder,
      (RecipeStepRow, $$RecipeStepsTableReferences),
      RecipeStepRow,
      PrefetchHooks Function({bool recipeId, bool variantId, bool ingredientItemsRefs})
    >;
typedef $$IngredientItemsTableCreateCompanionBuilder = IngredientItemsCompanion Function({
  Value<int> id,
  required int stepId,
  required int position,
  required String name,
  required String lowerName,
  required String unit,
  required double quantity,
  required String shape,
  required int foodId,
  required int conversionId,
  required bool optional,
});
typedef $$IngredientItemsTableUpdateCompanionBuilder = IngredientItemsCompanion Function({
  Value<int> id,
  Value<int> stepId,
  Value<int> position,
  Value<String> name,
  Value<String> lowerName,
  Value<String> unit,
  Value<double> quantity,
  Value<String> shape,
  Value<int> foodId,
  Value<int> conversionId,
  Value<bool> optional,
});

final class $$IngredientItemsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientItemsTable, IngredientRow> {
  $$IngredientItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipeStepsTable _stepIdTable(_$AppDatabase db) =>
      db.recipeSteps.createAlias('ingredient_items__step_id__recipe_steps__id');

  $$RecipeStepsTableProcessedTableManager get stepId {
    final $_column = $_itemColumn<int>('step_id')!;

    final manager = $$RecipeStepsTableTableManager(
      $_db,
      $_db.recipeSteps,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stepIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$IngredientItemsTableFilterComposer extends Composer<_$AppDatabase, $IngredientItemsTable> {
  $$IngredientItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lowerName =>
      $composableBuilder(column: $table.lowerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shape =>
      $composableBuilder(column: $table.shape, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get conversionId =>
      $composableBuilder(column: $table.conversionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get optional =>
      $composableBuilder(column: $table.optional, builder: (column) => ColumnFilters(column));

  $$RecipeStepsTableFilterComposer get stepId {
    final $$RecipeStepsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stepId,
      referencedTable: $db.recipeSteps,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipeStepsTableFilterComposer(
            $db: $db,
            $table: $db.recipeSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientItemsTable> {
  $$IngredientItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lowerName =>
      $composableBuilder(column: $table.lowerName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shape =>
      $composableBuilder(column: $table.shape, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get conversionId =>
      $composableBuilder(column: $table.conversionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get optional =>
      $composableBuilder(column: $table.optional, builder: (column) => ColumnOrderings(column));

  $$RecipeStepsTableOrderingComposer get stepId {
    final $$RecipeStepsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stepId,
      referencedTable: $db.recipeSteps,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipeStepsTableOrderingComposer(
            $db: $db,
            $table: $db.recipeSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientItemsTable> {
  $$IngredientItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get lowerName =>
      $composableBuilder(column: $table.lowerName, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get shape =>
      $composableBuilder(column: $table.shape, builder: (column) => column);

  GeneratedColumn<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<int> get conversionId =>
      $composableBuilder(column: $table.conversionId, builder: (column) => column);

  GeneratedColumn<bool> get optional =>
      $composableBuilder(column: $table.optional, builder: (column) => column);

  $$RecipeStepsTableAnnotationComposer get stepId {
    final $$RecipeStepsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stepId,
      referencedTable: $db.recipeSteps,
      getReferencedColumn: (t) => t.id,
      builder: (joinBuilder, {$addJoinBuilderToRootComposer, $removeJoinBuilderFromRootComposer}) =>
          $$RecipeStepsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer: $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientItemsTable,
          IngredientRow,
          $$IngredientItemsTableFilterComposer,
          $$IngredientItemsTableOrderingComposer,
          $$IngredientItemsTableAnnotationComposer,
          $$IngredientItemsTableCreateCompanionBuilder,
          $$IngredientItemsTableUpdateCompanionBuilder,
          (IngredientRow, $$IngredientItemsTableReferences),
          IngredientRow,
          PrefetchHooks Function({bool stepId})
        > {
  $$IngredientItemsTableTableManager(_$AppDatabase db, $IngredientItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> stepId = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> lowerName = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> shape = const Value.absent(),
                Value<int> foodId = const Value.absent(),
                Value<int> conversionId = const Value.absent(),
                Value<bool> optional = const Value.absent(),
              }) => IngredientItemsCompanion(
                id: id,
                stepId: stepId,
                position: position,
                name: name,
                lowerName: lowerName,
                unit: unit,
                quantity: quantity,
                shape: shape,
                foodId: foodId,
                conversionId: conversionId,
                optional: optional,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int stepId,
                required int position,
                required String name,
                required String lowerName,
                required String unit,
                required double quantity,
                required String shape,
                required int foodId,
                required int conversionId,
                required bool optional,
              }) => IngredientItemsCompanion.insert(
                id: id,
                stepId: stepId,
                position: position,
                name: name,
                lowerName: lowerName,
                unit: unit,
                quantity: quantity,
                shape: shape,
                foodId: foodId,
                conversionId: conversionId,
                optional: optional,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IngredientItemsTable, IngredientRow>(table),
                  $$IngredientItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({stepId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (stepId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.stepId,
                        referencedTable: $$IngredientItemsTableReferences._stepIdTable(db),
                        referencedColumn: $$IngredientItemsTableReferences._stepIdTable(db).id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IngredientItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientItemsTable,
      IngredientRow,
      $$IngredientItemsTableFilterComposer,
      $$IngredientItemsTableOrderingComposer,
      $$IngredientItemsTableAnnotationComposer,
      $$IngredientItemsTableCreateCompanionBuilder,
      $$IngredientItemsTableUpdateCompanionBuilder,
      (IngredientRow, $$IngredientItemsTableReferences),
      IngredientRow,
      PrefetchHooks Function({bool stepId})
    >;
typedef $$NutrientsTableCreateCompanionBuilder = NutrientsCompanion Function({
  Value<int> id,
  required int foodId,
  required String descEN,
  required String descFR,
  required double protein,
  required double water,
  required double lipidTotal,
  required double energKcal,
  required double carbohydrates,
  required double ash,
  required double fiber,
  required double sugar,
  required double calcium,
  required double iron,
  required double magnesium,
  required double phosphorus,
  required double potassium,
  required double sodium,
  required double zinc,
  required double copper,
  required double manganese,
  required double selenium,
  required double vitaminC,
  required double thiamin,
  required double riboflavin,
  required double niacin,
  required double pantoAcid,
  required double vitaminB6,
  required double folateTotal,
  required double folicAcid,
  required double foodFolate,
  required double folateDFE,
  required double cholineTotal,
  required double vitaminB12,
  required double vitaminAIU,
  required double vitaminARAE,
  required double retinol,
  required double alphaCarot,
  required double betaCarot,
  required double betaCrypt,
  required double lycopene,
  required double lutZea,
  required double vitaminE,
  required double vitaminD,
  required double vitaminDIU,
  required double vitaminK,
  required double faSat,
  required double faMono,
  required double faPoly,
  required double cholesterol,
});
typedef $$NutrientsTableUpdateCompanionBuilder = NutrientsCompanion Function({
  Value<int> id,
  Value<int> foodId,
  Value<String> descEN,
  Value<String> descFR,
  Value<double> protein,
  Value<double> water,
  Value<double> lipidTotal,
  Value<double> energKcal,
  Value<double> carbohydrates,
  Value<double> ash,
  Value<double> fiber,
  Value<double> sugar,
  Value<double> calcium,
  Value<double> iron,
  Value<double> magnesium,
  Value<double> phosphorus,
  Value<double> potassium,
  Value<double> sodium,
  Value<double> zinc,
  Value<double> copper,
  Value<double> manganese,
  Value<double> selenium,
  Value<double> vitaminC,
  Value<double> thiamin,
  Value<double> riboflavin,
  Value<double> niacin,
  Value<double> pantoAcid,
  Value<double> vitaminB6,
  Value<double> folateTotal,
  Value<double> folicAcid,
  Value<double> foodFolate,
  Value<double> folateDFE,
  Value<double> cholineTotal,
  Value<double> vitaminB12,
  Value<double> vitaminAIU,
  Value<double> vitaminARAE,
  Value<double> retinol,
  Value<double> alphaCarot,
  Value<double> betaCarot,
  Value<double> betaCrypt,
  Value<double> lycopene,
  Value<double> lutZea,
  Value<double> vitaminE,
  Value<double> vitaminD,
  Value<double> vitaminDIU,
  Value<double> vitaminK,
  Value<double> faSat,
  Value<double> faMono,
  Value<double> faPoly,
  Value<double> cholesterol,
});

class $$NutrientsTableFilterComposer extends Composer<_$AppDatabase, $NutrientsTable> {
  $$NutrientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descEN =>
      $composableBuilder(column: $table.descEN, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descFR =>
      $composableBuilder(column: $table.descFR, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get water =>
      $composableBuilder(column: $table.water, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lipidTotal =>
      $composableBuilder(column: $table.lipidTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get energKcal =>
      $composableBuilder(column: $table.energKcal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get carbohydrates =>
      $composableBuilder(column: $table.carbohydrates, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get ash =>
      $composableBuilder(column: $table.ash, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get fiber =>
      $composableBuilder(column: $table.fiber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sugar =>
      $composableBuilder(column: $table.sugar, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get calcium =>
      $composableBuilder(column: $table.calcium, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get iron =>
      $composableBuilder(column: $table.iron, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get magnesium =>
      $composableBuilder(column: $table.magnesium, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get phosphorus =>
      $composableBuilder(column: $table.phosphorus, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get potassium =>
      $composableBuilder(column: $table.potassium, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sodium =>
      $composableBuilder(column: $table.sodium, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get zinc =>
      $composableBuilder(column: $table.zinc, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get copper =>
      $composableBuilder(column: $table.copper, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get manganese =>
      $composableBuilder(column: $table.manganese, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get selenium =>
      $composableBuilder(column: $table.selenium, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitaminC =>
      $composableBuilder(column: $table.vitaminC, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get thiamin =>
      $composableBuilder(column: $table.thiamin, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get riboflavin =>
      $composableBuilder(column: $table.riboflavin, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get niacin =>
      $composableBuilder(column: $table.niacin, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pantoAcid =>
      $composableBuilder(column: $table.pantoAcid, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitaminB6 =>
      $composableBuilder(column: $table.vitaminB6, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get folateTotal =>
      $composableBuilder(column: $table.folateTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get folicAcid =>
      $composableBuilder(column: $table.folicAcid, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get foodFolate =>
      $composableBuilder(column: $table.foodFolate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get folateDFE =>
      $composableBuilder(column: $table.folateDFE, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cholineTotal =>
      $composableBuilder(column: $table.cholineTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitaminB12 =>
      $composableBuilder(column: $table.vitaminB12, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitaminAIU =>
      $composableBuilder(column: $table.vitaminAIU, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitaminARAE =>
      $composableBuilder(column: $table.vitaminARAE, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get retinol =>
      $composableBuilder(column: $table.retinol, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get alphaCarot =>
      $composableBuilder(column: $table.alphaCarot, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get betaCarot =>
      $composableBuilder(column: $table.betaCarot, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get betaCrypt =>
      $composableBuilder(column: $table.betaCrypt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lycopene =>
      $composableBuilder(column: $table.lycopene, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lutZea =>
      $composableBuilder(column: $table.lutZea, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitaminE =>
      $composableBuilder(column: $table.vitaminE, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitaminD =>
      $composableBuilder(column: $table.vitaminD, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitaminDIU =>
      $composableBuilder(column: $table.vitaminDIU, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get vitaminK =>
      $composableBuilder(column: $table.vitaminK, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get faSat =>
      $composableBuilder(column: $table.faSat, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get faMono =>
      $composableBuilder(column: $table.faMono, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get faPoly =>
      $composableBuilder(column: $table.faPoly, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cholesterol =>
      $composableBuilder(column: $table.cholesterol, builder: (column) => ColumnFilters(column));
}

class $$NutrientsTableOrderingComposer extends Composer<_$AppDatabase, $NutrientsTable> {
  $$NutrientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descEN =>
      $composableBuilder(column: $table.descEN, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descFR =>
      $composableBuilder(column: $table.descFR, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get water =>
      $composableBuilder(column: $table.water, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lipidTotal =>
      $composableBuilder(column: $table.lipidTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get energKcal =>
      $composableBuilder(column: $table.energKcal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get carbohydrates => $composableBuilder(
    column: $table.carbohydrates,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ash =>
      $composableBuilder(column: $table.ash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get fiber =>
      $composableBuilder(column: $table.fiber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sugar =>
      $composableBuilder(column: $table.sugar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get calcium =>
      $composableBuilder(column: $table.calcium, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get iron =>
      $composableBuilder(column: $table.iron, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get magnesium =>
      $composableBuilder(column: $table.magnesium, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get phosphorus =>
      $composableBuilder(column: $table.phosphorus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get potassium =>
      $composableBuilder(column: $table.potassium, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sodium =>
      $composableBuilder(column: $table.sodium, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get zinc =>
      $composableBuilder(column: $table.zinc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get copper =>
      $composableBuilder(column: $table.copper, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get manganese =>
      $composableBuilder(column: $table.manganese, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get selenium =>
      $composableBuilder(column: $table.selenium, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitaminC =>
      $composableBuilder(column: $table.vitaminC, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get thiamin =>
      $composableBuilder(column: $table.thiamin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get riboflavin =>
      $composableBuilder(column: $table.riboflavin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get niacin =>
      $composableBuilder(column: $table.niacin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pantoAcid =>
      $composableBuilder(column: $table.pantoAcid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitaminB6 =>
      $composableBuilder(column: $table.vitaminB6, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get folateTotal =>
      $composableBuilder(column: $table.folateTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get folicAcid =>
      $composableBuilder(column: $table.folicAcid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get foodFolate =>
      $composableBuilder(column: $table.foodFolate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get folateDFE =>
      $composableBuilder(column: $table.folateDFE, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cholineTotal =>
      $composableBuilder(column: $table.cholineTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitaminB12 =>
      $composableBuilder(column: $table.vitaminB12, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitaminAIU =>
      $composableBuilder(column: $table.vitaminAIU, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitaminARAE =>
      $composableBuilder(column: $table.vitaminARAE, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get retinol =>
      $composableBuilder(column: $table.retinol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get alphaCarot =>
      $composableBuilder(column: $table.alphaCarot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get betaCarot =>
      $composableBuilder(column: $table.betaCarot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get betaCrypt =>
      $composableBuilder(column: $table.betaCrypt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lycopene =>
      $composableBuilder(column: $table.lycopene, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lutZea =>
      $composableBuilder(column: $table.lutZea, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitaminE =>
      $composableBuilder(column: $table.vitaminE, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitaminD =>
      $composableBuilder(column: $table.vitaminD, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitaminDIU =>
      $composableBuilder(column: $table.vitaminDIU, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get vitaminK =>
      $composableBuilder(column: $table.vitaminK, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get faSat =>
      $composableBuilder(column: $table.faSat, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get faMono =>
      $composableBuilder(column: $table.faMono, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get faPoly =>
      $composableBuilder(column: $table.faPoly, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cholesterol =>
      $composableBuilder(column: $table.cholesterol, builder: (column) => ColumnOrderings(column));
}

class $$NutrientsTableAnnotationComposer extends Composer<_$AppDatabase, $NutrientsTable> {
  $$NutrientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<String> get descEN =>
      $composableBuilder(column: $table.descEN, builder: (column) => column);

  GeneratedColumn<String> get descFR =>
      $composableBuilder(column: $table.descFR, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get water =>
      $composableBuilder(column: $table.water, builder: (column) => column);

  GeneratedColumn<double> get lipidTotal =>
      $composableBuilder(column: $table.lipidTotal, builder: (column) => column);

  GeneratedColumn<double> get energKcal =>
      $composableBuilder(column: $table.energKcal, builder: (column) => column);

  GeneratedColumn<double> get carbohydrates =>
      $composableBuilder(column: $table.carbohydrates, builder: (column) => column);

  GeneratedColumn<double> get ash =>
      $composableBuilder(column: $table.ash, builder: (column) => column);

  GeneratedColumn<double> get fiber =>
      $composableBuilder(column: $table.fiber, builder: (column) => column);

  GeneratedColumn<double> get sugar =>
      $composableBuilder(column: $table.sugar, builder: (column) => column);

  GeneratedColumn<double> get calcium =>
      $composableBuilder(column: $table.calcium, builder: (column) => column);

  GeneratedColumn<double> get iron =>
      $composableBuilder(column: $table.iron, builder: (column) => column);

  GeneratedColumn<double> get magnesium =>
      $composableBuilder(column: $table.magnesium, builder: (column) => column);

  GeneratedColumn<double> get phosphorus =>
      $composableBuilder(column: $table.phosphorus, builder: (column) => column);

  GeneratedColumn<double> get potassium =>
      $composableBuilder(column: $table.potassium, builder: (column) => column);

  GeneratedColumn<double> get sodium =>
      $composableBuilder(column: $table.sodium, builder: (column) => column);

  GeneratedColumn<double> get zinc =>
      $composableBuilder(column: $table.zinc, builder: (column) => column);

  GeneratedColumn<double> get copper =>
      $composableBuilder(column: $table.copper, builder: (column) => column);

  GeneratedColumn<double> get manganese =>
      $composableBuilder(column: $table.manganese, builder: (column) => column);

  GeneratedColumn<double> get selenium =>
      $composableBuilder(column: $table.selenium, builder: (column) => column);

  GeneratedColumn<double> get vitaminC =>
      $composableBuilder(column: $table.vitaminC, builder: (column) => column);

  GeneratedColumn<double> get thiamin =>
      $composableBuilder(column: $table.thiamin, builder: (column) => column);

  GeneratedColumn<double> get riboflavin =>
      $composableBuilder(column: $table.riboflavin, builder: (column) => column);

  GeneratedColumn<double> get niacin =>
      $composableBuilder(column: $table.niacin, builder: (column) => column);

  GeneratedColumn<double> get pantoAcid =>
      $composableBuilder(column: $table.pantoAcid, builder: (column) => column);

  GeneratedColumn<double> get vitaminB6 =>
      $composableBuilder(column: $table.vitaminB6, builder: (column) => column);

  GeneratedColumn<double> get folateTotal =>
      $composableBuilder(column: $table.folateTotal, builder: (column) => column);

  GeneratedColumn<double> get folicAcid =>
      $composableBuilder(column: $table.folicAcid, builder: (column) => column);

  GeneratedColumn<double> get foodFolate =>
      $composableBuilder(column: $table.foodFolate, builder: (column) => column);

  GeneratedColumn<double> get folateDFE =>
      $composableBuilder(column: $table.folateDFE, builder: (column) => column);

  GeneratedColumn<double> get cholineTotal =>
      $composableBuilder(column: $table.cholineTotal, builder: (column) => column);

  GeneratedColumn<double> get vitaminB12 =>
      $composableBuilder(column: $table.vitaminB12, builder: (column) => column);

  GeneratedColumn<double> get vitaminAIU =>
      $composableBuilder(column: $table.vitaminAIU, builder: (column) => column);

  GeneratedColumn<double> get vitaminARAE =>
      $composableBuilder(column: $table.vitaminARAE, builder: (column) => column);

  GeneratedColumn<double> get retinol =>
      $composableBuilder(column: $table.retinol, builder: (column) => column);

  GeneratedColumn<double> get alphaCarot =>
      $composableBuilder(column: $table.alphaCarot, builder: (column) => column);

  GeneratedColumn<double> get betaCarot =>
      $composableBuilder(column: $table.betaCarot, builder: (column) => column);

  GeneratedColumn<double> get betaCrypt =>
      $composableBuilder(column: $table.betaCrypt, builder: (column) => column);

  GeneratedColumn<double> get lycopene =>
      $composableBuilder(column: $table.lycopene, builder: (column) => column);

  GeneratedColumn<double> get lutZea =>
      $composableBuilder(column: $table.lutZea, builder: (column) => column);

  GeneratedColumn<double> get vitaminE =>
      $composableBuilder(column: $table.vitaminE, builder: (column) => column);

  GeneratedColumn<double> get vitaminD =>
      $composableBuilder(column: $table.vitaminD, builder: (column) => column);

  GeneratedColumn<double> get vitaminDIU =>
      $composableBuilder(column: $table.vitaminDIU, builder: (column) => column);

  GeneratedColumn<double> get vitaminK =>
      $composableBuilder(column: $table.vitaminK, builder: (column) => column);

  GeneratedColumn<double> get faSat =>
      $composableBuilder(column: $table.faSat, builder: (column) => column);

  GeneratedColumn<double> get faMono =>
      $composableBuilder(column: $table.faMono, builder: (column) => column);

  GeneratedColumn<double> get faPoly =>
      $composableBuilder(column: $table.faPoly, builder: (column) => column);

  GeneratedColumn<double> get cholesterol =>
      $composableBuilder(column: $table.cholesterol, builder: (column) => column);
}

class $$NutrientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NutrientsTable,
          NutrientRow,
          $$NutrientsTableFilterComposer,
          $$NutrientsTableOrderingComposer,
          $$NutrientsTableAnnotationComposer,
          $$NutrientsTableCreateCompanionBuilder,
          $$NutrientsTableUpdateCompanionBuilder,
          (NutrientRow, BaseReferences<_$AppDatabase, $NutrientsTable, NutrientRow>),
          NutrientRow,
          PrefetchHooks Function()
        > {
  $$NutrientsTableTableManager(_$AppDatabase db, $NutrientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$NutrientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$NutrientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NutrientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> foodId = const Value.absent(),
                Value<String> descEN = const Value.absent(),
                Value<String> descFR = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> water = const Value.absent(),
                Value<double> lipidTotal = const Value.absent(),
                Value<double> energKcal = const Value.absent(),
                Value<double> carbohydrates = const Value.absent(),
                Value<double> ash = const Value.absent(),
                Value<double> fiber = const Value.absent(),
                Value<double> sugar = const Value.absent(),
                Value<double> calcium = const Value.absent(),
                Value<double> iron = const Value.absent(),
                Value<double> magnesium = const Value.absent(),
                Value<double> phosphorus = const Value.absent(),
                Value<double> potassium = const Value.absent(),
                Value<double> sodium = const Value.absent(),
                Value<double> zinc = const Value.absent(),
                Value<double> copper = const Value.absent(),
                Value<double> manganese = const Value.absent(),
                Value<double> selenium = const Value.absent(),
                Value<double> vitaminC = const Value.absent(),
                Value<double> thiamin = const Value.absent(),
                Value<double> riboflavin = const Value.absent(),
                Value<double> niacin = const Value.absent(),
                Value<double> pantoAcid = const Value.absent(),
                Value<double> vitaminB6 = const Value.absent(),
                Value<double> folateTotal = const Value.absent(),
                Value<double> folicAcid = const Value.absent(),
                Value<double> foodFolate = const Value.absent(),
                Value<double> folateDFE = const Value.absent(),
                Value<double> cholineTotal = const Value.absent(),
                Value<double> vitaminB12 = const Value.absent(),
                Value<double> vitaminAIU = const Value.absent(),
                Value<double> vitaminARAE = const Value.absent(),
                Value<double> retinol = const Value.absent(),
                Value<double> alphaCarot = const Value.absent(),
                Value<double> betaCarot = const Value.absent(),
                Value<double> betaCrypt = const Value.absent(),
                Value<double> lycopene = const Value.absent(),
                Value<double> lutZea = const Value.absent(),
                Value<double> vitaminE = const Value.absent(),
                Value<double> vitaminD = const Value.absent(),
                Value<double> vitaminDIU = const Value.absent(),
                Value<double> vitaminK = const Value.absent(),
                Value<double> faSat = const Value.absent(),
                Value<double> faMono = const Value.absent(),
                Value<double> faPoly = const Value.absent(),
                Value<double> cholesterol = const Value.absent(),
              }) => NutrientsCompanion(
                id: id,
                foodId: foodId,
                descEN: descEN,
                descFR: descFR,
                protein: protein,
                water: water,
                lipidTotal: lipidTotal,
                energKcal: energKcal,
                carbohydrates: carbohydrates,
                ash: ash,
                fiber: fiber,
                sugar: sugar,
                calcium: calcium,
                iron: iron,
                magnesium: magnesium,
                phosphorus: phosphorus,
                potassium: potassium,
                sodium: sodium,
                zinc: zinc,
                copper: copper,
                manganese: manganese,
                selenium: selenium,
                vitaminC: vitaminC,
                thiamin: thiamin,
                riboflavin: riboflavin,
                niacin: niacin,
                pantoAcid: pantoAcid,
                vitaminB6: vitaminB6,
                folateTotal: folateTotal,
                folicAcid: folicAcid,
                foodFolate: foodFolate,
                folateDFE: folateDFE,
                cholineTotal: cholineTotal,
                vitaminB12: vitaminB12,
                vitaminAIU: vitaminAIU,
                vitaminARAE: vitaminARAE,
                retinol: retinol,
                alphaCarot: alphaCarot,
                betaCarot: betaCarot,
                betaCrypt: betaCrypt,
                lycopene: lycopene,
                lutZea: lutZea,
                vitaminE: vitaminE,
                vitaminD: vitaminD,
                vitaminDIU: vitaminDIU,
                vitaminK: vitaminK,
                faSat: faSat,
                faMono: faMono,
                faPoly: faPoly,
                cholesterol: cholesterol,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int foodId,
                required String descEN,
                required String descFR,
                required double protein,
                required double water,
                required double lipidTotal,
                required double energKcal,
                required double carbohydrates,
                required double ash,
                required double fiber,
                required double sugar,
                required double calcium,
                required double iron,
                required double magnesium,
                required double phosphorus,
                required double potassium,
                required double sodium,
                required double zinc,
                required double copper,
                required double manganese,
                required double selenium,
                required double vitaminC,
                required double thiamin,
                required double riboflavin,
                required double niacin,
                required double pantoAcid,
                required double vitaminB6,
                required double folateTotal,
                required double folicAcid,
                required double foodFolate,
                required double folateDFE,
                required double cholineTotal,
                required double vitaminB12,
                required double vitaminAIU,
                required double vitaminARAE,
                required double retinol,
                required double alphaCarot,
                required double betaCarot,
                required double betaCrypt,
                required double lycopene,
                required double lutZea,
                required double vitaminE,
                required double vitaminD,
                required double vitaminDIU,
                required double vitaminK,
                required double faSat,
                required double faMono,
                required double faPoly,
                required double cholesterol,
              }) => NutrientsCompanion.insert(
                id: id,
                foodId: foodId,
                descEN: descEN,
                descFR: descFR,
                protein: protein,
                water: water,
                lipidTotal: lipidTotal,
                energKcal: energKcal,
                carbohydrates: carbohydrates,
                ash: ash,
                fiber: fiber,
                sugar: sugar,
                calcium: calcium,
                iron: iron,
                magnesium: magnesium,
                phosphorus: phosphorus,
                potassium: potassium,
                sodium: sodium,
                zinc: zinc,
                copper: copper,
                manganese: manganese,
                selenium: selenium,
                vitaminC: vitaminC,
                thiamin: thiamin,
                riboflavin: riboflavin,
                niacin: niacin,
                pantoAcid: pantoAcid,
                vitaminB6: vitaminB6,
                folateTotal: folateTotal,
                folicAcid: folicAcid,
                foodFolate: foodFolate,
                folateDFE: folateDFE,
                cholineTotal: cholineTotal,
                vitaminB12: vitaminB12,
                vitaminAIU: vitaminAIU,
                vitaminARAE: vitaminARAE,
                retinol: retinol,
                alphaCarot: alphaCarot,
                betaCarot: betaCarot,
                betaCrypt: betaCrypt,
                lycopene: lycopene,
                lutZea: lutZea,
                vitaminE: vitaminE,
                vitaminD: vitaminD,
                vitaminDIU: vitaminDIU,
                vitaminK: vitaminK,
                faSat: faSat,
                faMono: faMono,
                faPoly: faPoly,
                cholesterol: cholesterol,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NutrientsTable, NutrientRow>(table),
                  BaseReferences<_$AppDatabase, $NutrientsTable, NutrientRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NutrientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NutrientsTable,
      NutrientRow,
      $$NutrientsTableFilterComposer,
      $$NutrientsTableOrderingComposer,
      $$NutrientsTableAnnotationComposer,
      $$NutrientsTableCreateCompanionBuilder,
      $$NutrientsTableUpdateCompanionBuilder,
      (NutrientRow, BaseReferences<_$AppDatabase, $NutrientsTable, NutrientRow>),
      NutrientRow,
      PrefetchHooks Function()
    >;
typedef $$ConversionsTableCreateCompanionBuilder = ConversionsCompanion Function({
  Value<int> id,
  required int foodId,
  required int measureId,
  required String descEN,
  required String descFR,
  required double factor,
});
typedef $$ConversionsTableUpdateCompanionBuilder = ConversionsCompanion Function({
  Value<int> id,
  Value<int> foodId,
  Value<int> measureId,
  Value<String> descEN,
  Value<String> descFR,
  Value<double> factor,
});

class $$ConversionsTableFilterComposer extends Composer<_$AppDatabase, $ConversionsTable> {
  $$ConversionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get measureId =>
      $composableBuilder(column: $table.measureId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descEN =>
      $composableBuilder(column: $table.descEN, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descFR =>
      $composableBuilder(column: $table.descFR, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get factor =>
      $composableBuilder(column: $table.factor, builder: (column) => ColumnFilters(column));
}

class $$ConversionsTableOrderingComposer extends Composer<_$AppDatabase, $ConversionsTable> {
  $$ConversionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get measureId =>
      $composableBuilder(column: $table.measureId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descEN =>
      $composableBuilder(column: $table.descEN, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descFR =>
      $composableBuilder(column: $table.descFR, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get factor =>
      $composableBuilder(column: $table.factor, builder: (column) => ColumnOrderings(column));
}

class $$ConversionsTableAnnotationComposer extends Composer<_$AppDatabase, $ConversionsTable> {
  $$ConversionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get foodId =>
      $composableBuilder(column: $table.foodId, builder: (column) => column);

  GeneratedColumn<int> get measureId =>
      $composableBuilder(column: $table.measureId, builder: (column) => column);

  GeneratedColumn<String> get descEN =>
      $composableBuilder(column: $table.descEN, builder: (column) => column);

  GeneratedColumn<String> get descFR =>
      $composableBuilder(column: $table.descFR, builder: (column) => column);

  GeneratedColumn<double> get factor =>
      $composableBuilder(column: $table.factor, builder: (column) => column);
}

class $$ConversionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConversionsTable,
          ConversionRow,
          $$ConversionsTableFilterComposer,
          $$ConversionsTableOrderingComposer,
          $$ConversionsTableAnnotationComposer,
          $$ConversionsTableCreateCompanionBuilder,
          $$ConversionsTableUpdateCompanionBuilder,
          (ConversionRow, BaseReferences<_$AppDatabase, $ConversionsTable, ConversionRow>),
          ConversionRow,
          PrefetchHooks Function()
        > {
  $$ConversionsTableTableManager(_$AppDatabase db, $ConversionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ConversionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ConversionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> foodId = const Value.absent(),
                Value<int> measureId = const Value.absent(),
                Value<String> descEN = const Value.absent(),
                Value<String> descFR = const Value.absent(),
                Value<double> factor = const Value.absent(),
              }) => ConversionsCompanion(
                id: id,
                foodId: foodId,
                measureId: measureId,
                descEN: descEN,
                descFR: descFR,
                factor: factor,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int foodId,
                required int measureId,
                required String descEN,
                required String descFR,
                required double factor,
              }) => ConversionsCompanion.insert(
                id: id,
                foodId: foodId,
                measureId: measureId,
                descEN: descEN,
                descFR: descFR,
                factor: factor,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ConversionsTable, ConversionRow>(table),
                  BaseReferences<_$AppDatabase, $ConversionsTable, ConversionRow>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConversionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConversionsTable,
      ConversionRow,
      $$ConversionsTableFilterComposer,
      $$ConversionsTableOrderingComposer,
      $$ConversionsTableAnnotationComposer,
      $$ConversionsTableCreateCompanionBuilder,
      $$ConversionsTableUpdateCompanionBuilder,
      (ConversionRow, BaseReferences<_$AppDatabase, $ConversionsTable, ConversionRow>),
      ConversionRow,
      PrefetchHooks Function()
    >;
typedef $$MetadataTableCreateCompanionBuilder = MetadataCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$MetadataTableUpdateCompanionBuilder = MetadataCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$MetadataTableFilterComposer extends Composer<_$AppDatabase, $MetadataTable> {
  $$MetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$MetadataTableOrderingComposer extends Composer<_$AppDatabase, $MetadataTable> {
  $$MetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$MetadataTableAnnotationComposer extends Composer<_$AppDatabase, $MetadataTable> {
  $$MetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$MetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetadataTable,
          MetadataEntry,
          $$MetadataTableFilterComposer,
          $$MetadataTableOrderingComposer,
          $$MetadataTableAnnotationComposer,
          $$MetadataTableCreateCompanionBuilder,
          $$MetadataTableUpdateCompanionBuilder,
          (MetadataEntry, BaseReferences<_$AppDatabase, $MetadataTable, MetadataEntry>),
          MetadataEntry,
          PrefetchHooks Function()
        > {
  $$MetadataTableTableManager(_$AppDatabase db, $MetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$MetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$MetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => MetadataCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => MetadataCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MetadataTable, MetadataEntry>(table),
                  BaseReferences<_$AppDatabase, $MetadataTable, MetadataEntry>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetadataTable,
      MetadataEntry,
      $$MetadataTableFilterComposer,
      $$MetadataTableOrderingComposer,
      $$MetadataTableAnnotationComposer,
      $$MetadataTableCreateCompanionBuilder,
      $$MetadataTableUpdateCompanionBuilder,
      (MetadataEntry, BaseReferences<_$AppDatabase, $MetadataTable, MetadataEntry>),
      MetadataEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RecipesTableTableManager get recipes => $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeVariantsTableTableManager get recipeVariants =>
      $$RecipeVariantsTableTableManager(_db, _db.recipeVariants);
  $$RecipeStepsTableTableManager get recipeSteps =>
      $$RecipeStepsTableTableManager(_db, _db.recipeSteps);
  $$IngredientItemsTableTableManager get ingredientItems =>
      $$IngredientItemsTableTableManager(_db, _db.ingredientItems);
  $$NutrientsTableTableManager get nutrients => $$NutrientsTableTableManager(_db, _db.nutrients);
  $$ConversionsTableTableManager get conversions =>
      $$ConversionsTableTableManager(_db, _db.conversions);
  $$MetadataTableTableManager get metadata => $$MetadataTableTableManager(_db, _db.metadata);
}
