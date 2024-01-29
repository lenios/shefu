// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrients.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNutrientCollection on Isar {
  IsarCollection<Nutrient> get nutrients => this.collection();
}

const NutrientSchema = CollectionSchema(
  name: r'Nutrient',
  id: -3480622997888776448,
  properties: {
    r'FAMono': PropertySchema(
      id: 0,
      name: r'FAMono',
      type: IsarType.double,
    ),
    r'FAPoly': PropertySchema(
      id: 1,
      name: r'FAPoly',
      type: IsarType.double,
    ),
    r'FASat': PropertySchema(
      id: 2,
      name: r'FASat',
      type: IsarType.double,
    ),
    r'alphaCarot': PropertySchema(
      id: 3,
      name: r'alphaCarot',
      type: IsarType.double,
    ),
    r'ash': PropertySchema(
      id: 4,
      name: r'ash',
      type: IsarType.double,
    ),
    r'betaCarot': PropertySchema(
      id: 5,
      name: r'betaCarot',
      type: IsarType.double,
    ),
    r'betaCrypt': PropertySchema(
      id: 6,
      name: r'betaCrypt',
      type: IsarType.double,
    ),
    r'calcium': PropertySchema(
      id: 7,
      name: r'calcium',
      type: IsarType.double,
    ),
    r'carbohydrates': PropertySchema(
      id: 8,
      name: r'carbohydrates',
      type: IsarType.double,
    ),
    r'cholesterol': PropertySchema(
      id: 9,
      name: r'cholesterol',
      type: IsarType.double,
    ),
    r'cholineTotal': PropertySchema(
      id: 10,
      name: r'cholineTotal',
      type: IsarType.double,
    ),
    r'conversions': PropertySchema(
      id: 11,
      name: r'conversions',
      type: IsarType.objectList,
      target: r'Conversion',
    ),
    r'copper': PropertySchema(
      id: 12,
      name: r'copper',
      type: IsarType.double,
    ),
    r'descEN': PropertySchema(
      id: 13,
      name: r'descEN',
      type: IsarType.string,
    ),
    r'descFR': PropertySchema(
      id: 14,
      name: r'descFR',
      type: IsarType.string,
    ),
    r'energKcal': PropertySchema(
      id: 15,
      name: r'energKcal',
      type: IsarType.double,
    ),
    r'fiber': PropertySchema(
      id: 16,
      name: r'fiber',
      type: IsarType.double,
    ),
    r'folateDFE': PropertySchema(
      id: 17,
      name: r'folateDFE',
      type: IsarType.double,
    ),
    r'folateTotal': PropertySchema(
      id: 18,
      name: r'folateTotal',
      type: IsarType.double,
    ),
    r'folicAcid': PropertySchema(
      id: 19,
      name: r'folicAcid',
      type: IsarType.double,
    ),
    r'foodFolate': PropertySchema(
      id: 20,
      name: r'foodFolate',
      type: IsarType.double,
    ),
    r'iron': PropertySchema(
      id: 21,
      name: r'iron',
      type: IsarType.double,
    ),
    r'lipidTotal': PropertySchema(
      id: 22,
      name: r'lipidTotal',
      type: IsarType.double,
    ),
    r'lutZea': PropertySchema(
      id: 23,
      name: r'lutZea',
      type: IsarType.double,
    ),
    r'lycopene': PropertySchema(
      id: 24,
      name: r'lycopene',
      type: IsarType.double,
    ),
    r'magnesium': PropertySchema(
      id: 25,
      name: r'magnesium',
      type: IsarType.double,
    ),
    r'manganese': PropertySchema(
      id: 26,
      name: r'manganese',
      type: IsarType.double,
    ),
    r'niacin': PropertySchema(
      id: 27,
      name: r'niacin',
      type: IsarType.double,
    ),
    r'pantoAcid': PropertySchema(
      id: 28,
      name: r'pantoAcid',
      type: IsarType.double,
    ),
    r'phosphorus': PropertySchema(
      id: 29,
      name: r'phosphorus',
      type: IsarType.double,
    ),
    r'potassium': PropertySchema(
      id: 30,
      name: r'potassium',
      type: IsarType.double,
    ),
    r'protein': PropertySchema(
      id: 31,
      name: r'protein',
      type: IsarType.double,
    ),
    r'retinol': PropertySchema(
      id: 32,
      name: r'retinol',
      type: IsarType.double,
    ),
    r'riboflavin': PropertySchema(
      id: 33,
      name: r'riboflavin',
      type: IsarType.double,
    ),
    r'selenium': PropertySchema(
      id: 34,
      name: r'selenium',
      type: IsarType.double,
    ),
    r'sodium': PropertySchema(
      id: 35,
      name: r'sodium',
      type: IsarType.double,
    ),
    r'sugar': PropertySchema(
      id: 36,
      name: r'sugar',
      type: IsarType.double,
    ),
    r'thiamin': PropertySchema(
      id: 37,
      name: r'thiamin',
      type: IsarType.double,
    ),
    r'vitaminAIU': PropertySchema(
      id: 38,
      name: r'vitaminAIU',
      type: IsarType.double,
    ),
    r'vitaminARAE': PropertySchema(
      id: 39,
      name: r'vitaminARAE',
      type: IsarType.double,
    ),
    r'vitaminB12': PropertySchema(
      id: 40,
      name: r'vitaminB12',
      type: IsarType.double,
    ),
    r'vitaminB6': PropertySchema(
      id: 41,
      name: r'vitaminB6',
      type: IsarType.double,
    ),
    r'vitaminC': PropertySchema(
      id: 42,
      name: r'vitaminC',
      type: IsarType.double,
    ),
    r'vitaminD': PropertySchema(
      id: 43,
      name: r'vitaminD',
      type: IsarType.double,
    ),
    r'vitaminDIU': PropertySchema(
      id: 44,
      name: r'vitaminDIU',
      type: IsarType.double,
    ),
    r'vitaminE': PropertySchema(
      id: 45,
      name: r'vitaminE',
      type: IsarType.double,
    ),
    r'vitaminK': PropertySchema(
      id: 46,
      name: r'vitaminK',
      type: IsarType.double,
    ),
    r'water': PropertySchema(
      id: 47,
      name: r'water',
      type: IsarType.double,
    ),
    r'zinc': PropertySchema(
      id: 48,
      name: r'zinc',
      type: IsarType.double,
    )
  },
  estimateSize: _nutrientEstimateSize,
  serialize: _nutrientSerialize,
  deserialize: _nutrientDeserialize,
  deserializeProp: _nutrientDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'Conversion': ConversionSchema},
  getId: _nutrientGetId,
  getLinks: _nutrientGetLinks,
  attach: _nutrientAttach,
  version: '3.1.0+1',
);

int _nutrientEstimateSize(
  Nutrient object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.conversions;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[Conversion]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount +=
              ConversionSchema.estimateSize(value, offsets, allOffsets);
        }
      }
    }
  }
  bytesCount += 3 + object.descEN.length * 3;
  bytesCount += 3 + object.descFR.length * 3;
  return bytesCount;
}

void _nutrientSerialize(
  Nutrient object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.FAMono);
  writer.writeDouble(offsets[1], object.FAPoly);
  writer.writeDouble(offsets[2], object.FASat);
  writer.writeDouble(offsets[3], object.alphaCarot);
  writer.writeDouble(offsets[4], object.ash);
  writer.writeDouble(offsets[5], object.betaCarot);
  writer.writeDouble(offsets[6], object.betaCrypt);
  writer.writeDouble(offsets[7], object.calcium);
  writer.writeDouble(offsets[8], object.carbohydrates);
  writer.writeDouble(offsets[9], object.cholesterol);
  writer.writeDouble(offsets[10], object.cholineTotal);
  writer.writeObjectList<Conversion>(
    offsets[11],
    allOffsets,
    ConversionSchema.serialize,
    object.conversions,
  );
  writer.writeDouble(offsets[12], object.copper);
  writer.writeString(offsets[13], object.descEN);
  writer.writeString(offsets[14], object.descFR);
  writer.writeDouble(offsets[15], object.energKcal);
  writer.writeDouble(offsets[16], object.fiber);
  writer.writeDouble(offsets[17], object.folateDFE);
  writer.writeDouble(offsets[18], object.folateTotal);
  writer.writeDouble(offsets[19], object.folicAcid);
  writer.writeDouble(offsets[20], object.foodFolate);
  writer.writeDouble(offsets[21], object.iron);
  writer.writeDouble(offsets[22], object.lipidTotal);
  writer.writeDouble(offsets[23], object.lutZea);
  writer.writeDouble(offsets[24], object.lycopene);
  writer.writeDouble(offsets[25], object.magnesium);
  writer.writeDouble(offsets[26], object.manganese);
  writer.writeDouble(offsets[27], object.niacin);
  writer.writeDouble(offsets[28], object.pantoAcid);
  writer.writeDouble(offsets[29], object.phosphorus);
  writer.writeDouble(offsets[30], object.potassium);
  writer.writeDouble(offsets[31], object.protein);
  writer.writeDouble(offsets[32], object.retinol);
  writer.writeDouble(offsets[33], object.riboflavin);
  writer.writeDouble(offsets[34], object.selenium);
  writer.writeDouble(offsets[35], object.sodium);
  writer.writeDouble(offsets[36], object.sugar);
  writer.writeDouble(offsets[37], object.thiamin);
  writer.writeDouble(offsets[38], object.vitaminAIU);
  writer.writeDouble(offsets[39], object.vitaminARAE);
  writer.writeDouble(offsets[40], object.vitaminB12);
  writer.writeDouble(offsets[41], object.vitaminB6);
  writer.writeDouble(offsets[42], object.vitaminC);
  writer.writeDouble(offsets[43], object.vitaminD);
  writer.writeDouble(offsets[44], object.vitaminDIU);
  writer.writeDouble(offsets[45], object.vitaminE);
  writer.writeDouble(offsets[46], object.vitaminK);
  writer.writeDouble(offsets[47], object.water);
  writer.writeDouble(offsets[48], object.zinc);
}

Nutrient _nutrientDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Nutrient(
    id,
    reader.readString(offsets[13]),
    reader.readString(offsets[14]),
    reader.readDouble(offsets[31]),
    reader.readDouble(offsets[47]),
    reader.readDouble(offsets[22]),
    reader.readDouble(offsets[15]),
    reader.readDouble(offsets[8]),
  );
  object.FAMono = reader.readDouble(offsets[0]);
  object.FAPoly = reader.readDouble(offsets[1]);
  object.FASat = reader.readDouble(offsets[2]);
  object.alphaCarot = reader.readDouble(offsets[3]);
  object.ash = reader.readDouble(offsets[4]);
  object.betaCarot = reader.readDouble(offsets[5]);
  object.betaCrypt = reader.readDouble(offsets[6]);
  object.calcium = reader.readDouble(offsets[7]);
  object.cholesterol = reader.readDouble(offsets[9]);
  object.cholineTotal = reader.readDouble(offsets[10]);
  object.conversions = reader.readObjectList<Conversion>(
    offsets[11],
    ConversionSchema.deserialize,
    allOffsets,
    Conversion(),
  );
  object.copper = reader.readDouble(offsets[12]);
  object.fiber = reader.readDouble(offsets[16]);
  object.folateDFE = reader.readDouble(offsets[17]);
  object.folateTotal = reader.readDouble(offsets[18]);
  object.folicAcid = reader.readDouble(offsets[19]);
  object.foodFolate = reader.readDouble(offsets[20]);
  object.iron = reader.readDouble(offsets[21]);
  object.lutZea = reader.readDouble(offsets[23]);
  object.lycopene = reader.readDouble(offsets[24]);
  object.magnesium = reader.readDouble(offsets[25]);
  object.manganese = reader.readDouble(offsets[26]);
  object.niacin = reader.readDouble(offsets[27]);
  object.pantoAcid = reader.readDouble(offsets[28]);
  object.phosphorus = reader.readDouble(offsets[29]);
  object.potassium = reader.readDouble(offsets[30]);
  object.retinol = reader.readDouble(offsets[32]);
  object.riboflavin = reader.readDouble(offsets[33]);
  object.selenium = reader.readDouble(offsets[34]);
  object.sodium = reader.readDouble(offsets[35]);
  object.sugar = reader.readDouble(offsets[36]);
  object.thiamin = reader.readDouble(offsets[37]);
  object.vitaminAIU = reader.readDouble(offsets[38]);
  object.vitaminARAE = reader.readDouble(offsets[39]);
  object.vitaminB12 = reader.readDouble(offsets[40]);
  object.vitaminB6 = reader.readDouble(offsets[41]);
  object.vitaminC = reader.readDouble(offsets[42]);
  object.vitaminD = reader.readDouble(offsets[43]);
  object.vitaminDIU = reader.readDouble(offsets[44]);
  object.vitaminE = reader.readDouble(offsets[45]);
  object.vitaminK = reader.readDouble(offsets[46]);
  object.zinc = reader.readDouble(offsets[48]);
  return object;
}

P _nutrientDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readObjectList<Conversion>(
        offset,
        ConversionSchema.deserialize,
        allOffsets,
        Conversion(),
      )) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readDouble(offset)) as P;
    case 17:
      return (reader.readDouble(offset)) as P;
    case 18:
      return (reader.readDouble(offset)) as P;
    case 19:
      return (reader.readDouble(offset)) as P;
    case 20:
      return (reader.readDouble(offset)) as P;
    case 21:
      return (reader.readDouble(offset)) as P;
    case 22:
      return (reader.readDouble(offset)) as P;
    case 23:
      return (reader.readDouble(offset)) as P;
    case 24:
      return (reader.readDouble(offset)) as P;
    case 25:
      return (reader.readDouble(offset)) as P;
    case 26:
      return (reader.readDouble(offset)) as P;
    case 27:
      return (reader.readDouble(offset)) as P;
    case 28:
      return (reader.readDouble(offset)) as P;
    case 29:
      return (reader.readDouble(offset)) as P;
    case 30:
      return (reader.readDouble(offset)) as P;
    case 31:
      return (reader.readDouble(offset)) as P;
    case 32:
      return (reader.readDouble(offset)) as P;
    case 33:
      return (reader.readDouble(offset)) as P;
    case 34:
      return (reader.readDouble(offset)) as P;
    case 35:
      return (reader.readDouble(offset)) as P;
    case 36:
      return (reader.readDouble(offset)) as P;
    case 37:
      return (reader.readDouble(offset)) as P;
    case 38:
      return (reader.readDouble(offset)) as P;
    case 39:
      return (reader.readDouble(offset)) as P;
    case 40:
      return (reader.readDouble(offset)) as P;
    case 41:
      return (reader.readDouble(offset)) as P;
    case 42:
      return (reader.readDouble(offset)) as P;
    case 43:
      return (reader.readDouble(offset)) as P;
    case 44:
      return (reader.readDouble(offset)) as P;
    case 45:
      return (reader.readDouble(offset)) as P;
    case 46:
      return (reader.readDouble(offset)) as P;
    case 47:
      return (reader.readDouble(offset)) as P;
    case 48:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _nutrientGetId(Nutrient object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _nutrientGetLinks(Nutrient object) {
  return [];
}

void _nutrientAttach(IsarCollection<dynamic> col, Id id, Nutrient object) {
  object.id = id;
}

extension NutrientQueryWhereSort on QueryBuilder<Nutrient, Nutrient, QWhere> {
  QueryBuilder<Nutrient, Nutrient, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NutrientQueryWhere on QueryBuilder<Nutrient, Nutrient, QWhereClause> {
  QueryBuilder<Nutrient, Nutrient, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NutrientQueryFilter
    on QueryBuilder<Nutrient, Nutrient, QFilterCondition> {
  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fAMonoEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'FAMono',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fAMonoGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'FAMono',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fAMonoLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'FAMono',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fAMonoBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'FAMono',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fAPolyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'FAPoly',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fAPolyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'FAPoly',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fAPolyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'FAPoly',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fAPolyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'FAPoly',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fASatEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'FASat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fASatGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'FASat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fASatLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'FASat',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fASatBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'FASat',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> alphaCarotEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alphaCarot',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> alphaCarotGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alphaCarot',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> alphaCarotLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alphaCarot',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> alphaCarotBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alphaCarot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> ashEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ash',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> ashGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ash',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> ashLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ash',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> ashBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> betaCarotEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'betaCarot',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> betaCarotGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'betaCarot',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> betaCarotLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'betaCarot',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> betaCarotBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'betaCarot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> betaCryptEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'betaCrypt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> betaCryptGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'betaCrypt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> betaCryptLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'betaCrypt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> betaCryptBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'betaCrypt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> calciumEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'calcium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> calciumGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'calcium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> calciumLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'calcium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> calciumBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'calcium',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> carbohydratesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carbohydrates',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition>
      carbohydratesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carbohydrates',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> carbohydratesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carbohydrates',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> carbohydratesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carbohydrates',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> cholesterolEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cholesterol',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition>
      cholesterolGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cholesterol',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> cholesterolLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cholesterol',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> cholesterolBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cholesterol',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> cholineTotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cholineTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition>
      cholineTotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cholineTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> cholineTotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cholineTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> cholineTotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cholineTotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> conversionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'conversions',
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition>
      conversionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'conversions',
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition>
      conversionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'conversions',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> conversionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'conversions',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition>
      conversionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'conversions',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition>
      conversionsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'conversions',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition>
      conversionsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'conversions',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition>
      conversionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'conversions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> copperEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'copper',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> copperGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'copper',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> copperLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'copper',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> copperBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'copper',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descENEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descEN',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descENGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'descEN',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descENLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'descEN',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descENBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'descEN',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descENStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'descEN',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descENEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'descEN',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descENContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'descEN',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descENMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'descEN',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descENIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descEN',
        value: '',
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descENIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'descEN',
        value: '',
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descFREqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descFR',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descFRGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'descFR',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descFRLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'descFR',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descFRBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'descFR',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descFRStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'descFR',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descFREndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'descFR',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descFRContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'descFR',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descFRMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'descFR',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descFRIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descFR',
        value: '',
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> descFRIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'descFR',
        value: '',
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> energKcalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'energKcal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> energKcalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'energKcal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> energKcalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'energKcal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> energKcalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'energKcal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fiberEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fiber',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fiberGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fiber',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fiberLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fiber',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> fiberBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fiber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> folateDFEEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folateDFE',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> folateDFEGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'folateDFE',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> folateDFELessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'folateDFE',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> folateDFEBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'folateDFE',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> folateTotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folateTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition>
      folateTotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'folateTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> folateTotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'folateTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> folateTotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'folateTotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> folicAcidEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'folicAcid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> folicAcidGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'folicAcid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> folicAcidLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'folicAcid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> folicAcidBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'folicAcid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> foodFolateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'foodFolate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> foodFolateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'foodFolate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> foodFolateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'foodFolate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> foodFolateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'foodFolate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> ironEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iron',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> ironGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iron',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> ironLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iron',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> ironBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iron',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> lipidTotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lipidTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> lipidTotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lipidTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> lipidTotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lipidTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> lipidTotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lipidTotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> lutZeaEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lutZea',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> lutZeaGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lutZea',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> lutZeaLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lutZea',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> lutZeaBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lutZea',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> lycopeneEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lycopene',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> lycopeneGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lycopene',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> lycopeneLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lycopene',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> lycopeneBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lycopene',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> magnesiumEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'magnesium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> magnesiumGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'magnesium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> magnesiumLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'magnesium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> magnesiumBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'magnesium',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> manganeseEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'manganese',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> manganeseGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'manganese',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> manganeseLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'manganese',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> manganeseBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'manganese',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> niacinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'niacin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> niacinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'niacin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> niacinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'niacin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> niacinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'niacin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> pantoAcidEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pantoAcid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> pantoAcidGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pantoAcid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> pantoAcidLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pantoAcid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> pantoAcidBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pantoAcid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> phosphorusEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phosphorus',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> phosphorusGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phosphorus',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> phosphorusLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phosphorus',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> phosphorusBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phosphorus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> potassiumEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'potassium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> potassiumGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'potassium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> potassiumLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'potassium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> potassiumBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'potassium',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> proteinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'protein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> proteinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'protein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> proteinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'protein',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> proteinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'protein',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> retinolEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'retinol',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> retinolGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'retinol',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> retinolLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'retinol',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> retinolBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'retinol',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> riboflavinEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'riboflavin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> riboflavinGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'riboflavin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> riboflavinLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'riboflavin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> riboflavinBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'riboflavin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> seleniumEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selenium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> seleniumGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selenium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> seleniumLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selenium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> seleniumBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selenium',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> sodiumEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sodium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> sodiumGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sodium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> sodiumLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sodium',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> sodiumBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sodium',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> sugarEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sugar',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> sugarGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sugar',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> sugarLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sugar',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> sugarBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sugar',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> thiaminEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thiamin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> thiaminGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'thiamin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> thiaminLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'thiamin',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> thiaminBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'thiamin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminAIUEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vitaminAIU',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminAIUGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vitaminAIU',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminAIULessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vitaminAIU',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminAIUBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vitaminAIU',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminARAEEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vitaminARAE',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition>
      vitaminARAEGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vitaminARAE',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminARAELessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vitaminARAE',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminARAEBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vitaminARAE',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminB12EqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vitaminB12',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminB12GreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vitaminB12',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminB12LessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vitaminB12',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminB12Between(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vitaminB12',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminB6EqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vitaminB6',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminB6GreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vitaminB6',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminB6LessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vitaminB6',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminB6Between(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vitaminB6',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminCEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vitaminC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminCGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vitaminC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminCLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vitaminC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminCBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vitaminC',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminDEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vitaminD',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminDGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vitaminD',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminDLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vitaminD',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminDBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vitaminD',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminDIUEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vitaminDIU',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminDIUGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vitaminDIU',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminDIULessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vitaminDIU',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminDIUBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vitaminDIU',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminEEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vitaminE',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminEGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vitaminE',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminELessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vitaminE',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminEBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vitaminE',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminKEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vitaminK',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminKGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vitaminK',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminKLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vitaminK',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> vitaminKBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vitaminK',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> waterEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'water',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> waterGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'water',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> waterLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'water',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> waterBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'water',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> zincEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'zinc',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> zincGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'zinc',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> zincLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'zinc',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> zincBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'zinc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension NutrientQueryObject
    on QueryBuilder<Nutrient, Nutrient, QFilterCondition> {
  QueryBuilder<Nutrient, Nutrient, QAfterFilterCondition> conversionsElement(
      FilterQuery<Conversion> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'conversions');
    });
  }
}

extension NutrientQueryLinks
    on QueryBuilder<Nutrient, Nutrient, QFilterCondition> {}

extension NutrientQuerySortBy on QueryBuilder<Nutrient, Nutrient, QSortBy> {
  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFAMono() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'FAMono', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFAMonoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'FAMono', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFAPoly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'FAPoly', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFAPolyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'FAPoly', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFASat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'FASat', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFASatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'FASat', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByAlphaCarot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alphaCarot', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByAlphaCarotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alphaCarot', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByAsh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ash', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByAshDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ash', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByBetaCarot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'betaCarot', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByBetaCarotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'betaCarot', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByBetaCrypt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'betaCrypt', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByBetaCryptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'betaCrypt', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByCalcium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calcium', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByCalciumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calcium', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByCarbohydrates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbohydrates', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByCarbohydratesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbohydrates', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByCholesterol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cholesterol', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByCholesterolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cholesterol', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByCholineTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cholineTotal', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByCholineTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cholineTotal', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByCopper() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'copper', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByCopperDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'copper', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByDescEN() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descEN', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByDescENDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descEN', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByDescFR() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descFR', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByDescFRDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descFR', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByEnergKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energKcal', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByEnergKcalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energKcal', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFiber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFiberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFolateDFE() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folateDFE', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFolateDFEDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folateDFE', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFolateTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folateTotal', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFolateTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folateTotal', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFolicAcid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folicAcid', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFolicAcidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folicAcid', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFoodFolate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodFolate', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByFoodFolateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodFolate', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByIron() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iron', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByIronDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iron', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByLipidTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lipidTotal', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByLipidTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lipidTotal', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByLutZea() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lutZea', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByLutZeaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lutZea', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByLycopene() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lycopene', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByLycopeneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lycopene', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByMagnesium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'magnesium', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByMagnesiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'magnesium', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByManganese() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manganese', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByManganeseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manganese', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByNiacin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'niacin', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByNiacinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'niacin', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByPantoAcid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pantoAcid', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByPantoAcidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pantoAcid', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByPhosphorus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phosphorus', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByPhosphorusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phosphorus', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByPotassium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potassium', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByPotassiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potassium', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByRetinol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retinol', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByRetinolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retinol', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByRiboflavin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riboflavin', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByRiboflavinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riboflavin', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortBySelenium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selenium', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortBySeleniumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selenium', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortBySodium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sodium', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortBySodiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sodium', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortBySugar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugar', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortBySugarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugar', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByThiamin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thiamin', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByThiaminDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thiamin', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminAIU() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminAIU', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminAIUDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminAIU', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminARAE() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminARAE', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminARAEDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminARAE', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminB12() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminB12', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminB12Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminB12', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminB6() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminB6', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminB6Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminB6', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminC', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminC', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminD', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminD', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminDIU() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminDIU', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminDIUDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminDIU', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminE() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminE', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminEDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminE', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminK() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminK', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByVitaminKDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminK', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByWater() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'water', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByWaterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'water', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByZinc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zinc', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> sortByZincDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zinc', Sort.desc);
    });
  }
}

extension NutrientQuerySortThenBy
    on QueryBuilder<Nutrient, Nutrient, QSortThenBy> {
  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFAMono() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'FAMono', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFAMonoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'FAMono', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFAPoly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'FAPoly', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFAPolyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'FAPoly', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFASat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'FASat', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFASatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'FASat', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByAlphaCarot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alphaCarot', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByAlphaCarotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alphaCarot', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByAsh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ash', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByAshDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ash', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByBetaCarot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'betaCarot', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByBetaCarotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'betaCarot', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByBetaCrypt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'betaCrypt', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByBetaCryptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'betaCrypt', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByCalcium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calcium', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByCalciumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'calcium', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByCarbohydrates() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbohydrates', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByCarbohydratesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbohydrates', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByCholesterol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cholesterol', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByCholesterolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cholesterol', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByCholineTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cholineTotal', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByCholineTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cholineTotal', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByCopper() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'copper', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByCopperDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'copper', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByDescEN() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descEN', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByDescENDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descEN', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByDescFR() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descFR', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByDescFRDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'descFR', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByEnergKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energKcal', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByEnergKcalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energKcal', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFiber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFiberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fiber', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFolateDFE() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folateDFE', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFolateDFEDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folateDFE', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFolateTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folateTotal', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFolateTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folateTotal', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFolicAcid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folicAcid', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFolicAcidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'folicAcid', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFoodFolate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodFolate', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByFoodFolateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'foodFolate', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByIron() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iron', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByIronDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iron', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByLipidTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lipidTotal', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByLipidTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lipidTotal', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByLutZea() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lutZea', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByLutZeaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lutZea', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByLycopene() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lycopene', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByLycopeneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lycopene', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByMagnesium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'magnesium', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByMagnesiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'magnesium', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByManganese() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manganese', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByManganeseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manganese', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByNiacin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'niacin', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByNiacinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'niacin', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByPantoAcid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pantoAcid', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByPantoAcidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pantoAcid', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByPhosphorus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phosphorus', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByPhosphorusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phosphorus', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByPotassium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potassium', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByPotassiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'potassium', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByProteinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'protein', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByRetinol() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retinol', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByRetinolDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'retinol', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByRiboflavin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riboflavin', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByRiboflavinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'riboflavin', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenBySelenium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selenium', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenBySeleniumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selenium', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenBySodium() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sodium', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenBySodiumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sodium', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenBySugar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugar', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenBySugarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sugar', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByThiamin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thiamin', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByThiaminDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thiamin', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminAIU() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminAIU', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminAIUDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminAIU', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminARAE() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminARAE', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminARAEDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminARAE', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminB12() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminB12', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminB12Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminB12', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminB6() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminB6', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminB6Desc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminB6', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminC', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminC', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminD', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminD', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminDIU() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminDIU', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminDIUDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminDIU', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminE() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminE', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminEDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminE', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminK() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminK', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByVitaminKDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vitaminK', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByWater() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'water', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByWaterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'water', Sort.desc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByZinc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zinc', Sort.asc);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QAfterSortBy> thenByZincDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'zinc', Sort.desc);
    });
  }
}

extension NutrientQueryWhereDistinct
    on QueryBuilder<Nutrient, Nutrient, QDistinct> {
  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByFAMono() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'FAMono');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByFAPoly() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'FAPoly');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByFASat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'FASat');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByAlphaCarot() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alphaCarot');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByAsh() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ash');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByBetaCarot() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'betaCarot');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByBetaCrypt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'betaCrypt');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByCalcium() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'calcium');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByCarbohydrates() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbohydrates');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByCholesterol() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cholesterol');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByCholineTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cholineTotal');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByCopper() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'copper');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByDescEN(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'descEN', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByDescFR(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'descFR', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByEnergKcal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'energKcal');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByFiber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fiber');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByFolateDFE() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'folateDFE');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByFolateTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'folateTotal');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByFolicAcid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'folicAcid');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByFoodFolate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'foodFolate');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByIron() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iron');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByLipidTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lipidTotal');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByLutZea() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lutZea');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByLycopene() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lycopene');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByMagnesium() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'magnesium');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByManganese() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'manganese');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByNiacin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'niacin');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByPantoAcid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pantoAcid');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByPhosphorus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phosphorus');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByPotassium() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'potassium');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByProtein() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'protein');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByRetinol() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'retinol');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByRiboflavin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'riboflavin');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctBySelenium() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selenium');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctBySodium() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sodium');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctBySugar() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sugar');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByThiamin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'thiamin');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByVitaminAIU() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vitaminAIU');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByVitaminARAE() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vitaminARAE');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByVitaminB12() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vitaminB12');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByVitaminB6() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vitaminB6');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByVitaminC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vitaminC');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByVitaminD() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vitaminD');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByVitaminDIU() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vitaminDIU');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByVitaminE() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vitaminE');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByVitaminK() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vitaminK');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByWater() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'water');
    });
  }

  QueryBuilder<Nutrient, Nutrient, QDistinct> distinctByZinc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'zinc');
    });
  }
}

extension NutrientQueryProperty
    on QueryBuilder<Nutrient, Nutrient, QQueryProperty> {
  QueryBuilder<Nutrient, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> FAMonoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'FAMono');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> FAPolyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'FAPoly');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> FASatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'FASat');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> alphaCarotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alphaCarot');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> ashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ash');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> betaCarotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'betaCarot');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> betaCryptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'betaCrypt');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> calciumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'calcium');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> carbohydratesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbohydrates');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> cholesterolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cholesterol');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> cholineTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cholineTotal');
    });
  }

  QueryBuilder<Nutrient, List<Conversion>?, QQueryOperations>
      conversionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'conversions');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> copperProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'copper');
    });
  }

  QueryBuilder<Nutrient, String, QQueryOperations> descENProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'descEN');
    });
  }

  QueryBuilder<Nutrient, String, QQueryOperations> descFRProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'descFR');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> energKcalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energKcal');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> fiberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fiber');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> folateDFEProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'folateDFE');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> folateTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'folateTotal');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> folicAcidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'folicAcid');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> foodFolateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'foodFolate');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> ironProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iron');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> lipidTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lipidTotal');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> lutZeaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lutZea');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> lycopeneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lycopene');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> magnesiumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'magnesium');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> manganeseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'manganese');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> niacinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'niacin');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> pantoAcidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pantoAcid');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> phosphorusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phosphorus');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> potassiumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'potassium');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> proteinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'protein');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> retinolProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'retinol');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> riboflavinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'riboflavin');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> seleniumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selenium');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> sodiumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sodium');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> sugarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sugar');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> thiaminProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thiamin');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> vitaminAIUProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vitaminAIU');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> vitaminARAEProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vitaminARAE');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> vitaminB12Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vitaminB12');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> vitaminB6Property() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vitaminB6');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> vitaminCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vitaminC');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> vitaminDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vitaminD');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> vitaminDIUProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vitaminDIU');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> vitaminEProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vitaminE');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> vitaminKProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vitaminK');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> waterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'water');
    });
  }

  QueryBuilder<Nutrient, double, QQueryOperations> zincProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'zinc');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ConversionSchema = Schema(
  name: r'Conversion',
  id: 5946022360863458199,
  properties: {
    r'descEN': PropertySchema(
      id: 0,
      name: r'descEN',
      type: IsarType.string,
    ),
    r'descFR': PropertySchema(
      id: 1,
      name: r'descFR',
      type: IsarType.string,
    ),
    r'factor': PropertySchema(
      id: 2,
      name: r'factor',
      type: IsarType.double,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.long,
    )
  },
  estimateSize: _conversionEstimateSize,
  serialize: _conversionSerialize,
  deserialize: _conversionDeserialize,
  deserializeProp: _conversionDeserializeProp,
);

int _conversionEstimateSize(
  Conversion object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.descEN.length * 3;
  bytesCount += 3 + object.descFR.length * 3;
  return bytesCount;
}

void _conversionSerialize(
  Conversion object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.descEN);
  writer.writeString(offsets[1], object.descFR);
  writer.writeDouble(offsets[2], object.factor);
  writer.writeLong(offsets[3], object.id);
}

Conversion _conversionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Conversion();
  object.descEN = reader.readString(offsets[0]);
  object.descFR = reader.readString(offsets[1]);
  object.factor = reader.readDouble(offsets[2]);
  object.id = reader.readLong(offsets[3]);
  return object;
}

P _conversionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ConversionQueryFilter
    on QueryBuilder<Conversion, Conversion, QFilterCondition> {
  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descENEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descEN',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descENGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'descEN',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descENLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'descEN',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descENBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'descEN',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descENStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'descEN',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descENEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'descEN',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descENContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'descEN',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descENMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'descEN',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descENIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descEN',
        value: '',
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition>
      descENIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'descEN',
        value: '',
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descFREqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descFR',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descFRGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'descFR',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descFRLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'descFR',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descFRBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'descFR',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descFRStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'descFR',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descFREndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'descFR',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descFRContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'descFR',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descFRMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'descFR',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> descFRIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'descFR',
        value: '',
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition>
      descFRIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'descFR',
        value: '',
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> factorEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'factor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> factorGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'factor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> factorLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'factor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> factorBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'factor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> idEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Conversion, Conversion, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ConversionQueryObject
    on QueryBuilder<Conversion, Conversion, QFilterCondition> {}
