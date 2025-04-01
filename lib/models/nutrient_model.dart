import 'package:drift/drift.dart';
import '../database/app_database.dart';

class NutrientModel {
  final int? id;
  final String descEN;
  final String descFR;
  final double proteins;
  final double water;
  final double fat;
  final double energKcal;
  final double carbohydrates;
  late final List<ConversionModel> conversions;

  // Id id = Isar.autoIncrement;
  // String descEN = "";
  // String descFR = "";
  // double protein = 0.0;
  // double water = 0.0;
  // double lipidTotal = 0.0;
  // double energKcal = 0;
  // double carbohydrates = 0.0;
  // double ash = 0.0;
  // double fiber = 0.0;
  // double sugar = 0.0;
  // double calcium = 0.0;
  // double iron = 0.0;
  // double magnesium = 0.0;
  // double phosphorus = 0.0;
  // double potassium = 0.0;
  // double sodium = 0.0;
  // double zinc = 0.0;
  // double copper = 0.0;
  // double manganese = 0.0;
  // double selenium = 0.0;
  // double vitaminC = 0.0;
  // double thiamin = 0.0;
  // double riboflavin = 0.0;
  // double niacin = 0.0;
  // double pantoAcid = 0.0;
  // double vitaminB6 = 0.0;
  // double folateTotal = 0.0;
  // double folicAcid = 0.0;
  // double foodFolate = 0.0;
  // double folateDFE = 0.0;
  // double cholineTotal = 0.0;
  // double vitaminB12 = 0.0;
  // double vitaminAIU = 0.0;
  // double vitaminARAE = 0.0;
  // double retinol = 0.0;
  // double alphaCarot = 0.0;
  // double betaCarot = 0.0;
  // double betaCrypt = 0.0;
  // double lycopene = 0.0;
  // double lutZea = 0.0;
  // double vitaminE = 0.0;
  // double vitaminD = 0.0;
  // double vitaminDIU = 0.0;
  // double vitaminK = 0.0;
  // double FASat = 0.0;
  // double FAMono = 0.0;
  // double FAPoly = 0.0;
  // double cholesterol = 0.0;

  NutrientModel({
    this.id,
    required this.descEN,
    required this.descFR,
    this.proteins = 0.0,
    this.water = 0.0,
    this.fat = 0.0,
    this.energKcal = 0.0,
    this.carbohydrates = 0.0,
    this.conversions = const [],
  });

  NutrientsCompanion toCompanion() {
    return NutrientsCompanion(
      id: id != null ? Value(id!) : const Value.absent(),
      descEN: Value(descEN),
      descFR: Value(descFR),
      proteins: Value(proteins),
      water: Value(water),
      fat: Value(fat),
      energKcal: Value(energKcal),
      carbohydrates: Value(carbohydrates),
    );
  }

  static NutrientModel fromNutrient(Nutrient nutrient, {List<ConversionModel> conversions = const []}) {
    return NutrientModel(
      id: nutrient.id,
      descEN: nutrient.descEN,
      descFR: nutrient.descFR,
      proteins: nutrient.proteins,
      water: nutrient.water,
      fat: nutrient.fat,
      energKcal: nutrient.energKcal,
      carbohydrates: nutrient.carbohydrates,
      conversions: conversions,
    );
  }

  // Create an empty nutrient
  static NutrientModel empty(int id) {
    return NutrientModel(
      id: id,
      descEN: "Unknown",
      descFR: "Inconnu",
      proteins: 0,
      water: 0,
      fat: 0,
      energKcal: 0,
      carbohydrates: 0,
      conversions: [],
    );
  }

  NutrientModel copyWith({
    int? id,
    String? descEN,
    String? descFR, 
    double? proteins,
    double? water,
    double? fat,
    double? energKcal,
    double? carbohydrates,
    List<ConversionModel>? conversions,
  }) {
    return NutrientModel(
      id: id ?? this.id,
      descEN: descEN ?? this.descEN,
      descFR: descFR ?? this.descFR,
      proteins: proteins ?? this.proteins,
      water: water ?? this.water,
      fat: fat ?? this.fat,
      energKcal: energKcal ?? this.energKcal,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      conversions: conversions ?? this.conversions,
    );
  }
}

class ConversionModel {
  final int? id;
  final int? nutrientId;
  final String name;
  final double factor;

  ConversionModel({
    this.id,
    this.nutrientId,
    required this.name,
    this.factor = 0.0,
  });

  get descFR => null;

  get descEN => null;

  ConversionsCompanion toCompanion() {
    return ConversionsCompanion(
      id: id != null ? Value(id!) : const Value.absent(),
      nutrientId: nutrientId != null ? Value(nutrientId!) : const Value.absent(),
      name: Value(name),
      factor: Value(factor),
    );
  }

  static ConversionModel fromConversion(Conversion conversion) {
    return ConversionModel(
      id: conversion.id,
      nutrientId: conversion.nutrientId,
      name: conversion.name,
      factor: conversion.factor,
    );
  }
}