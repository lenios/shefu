import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isar/isar.dart';
import '../models/nutrients.dart';
import 'package:path_provider/path_provider.dart';

capitalize(string) {
  return "${string[0].toUpperCase()}${string.substring(1).toLowerCase()}";
}

class NutrientsProvider with ChangeNotifier {
  NutrientsProvider() {
    init();
  }

  List<Nutrient> _nutrients = [];

  List<Nutrient> get nutrients => _nutrients;

  Isar? isar;

  void init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar ??= await Isar.open(
      [NutrientSchema],
      name: "nutrients",
      directory: dir.path,
    );

    // //clear
    // await isar!.writeTxn(() async {
    //   await isar!.nutrients.clear();
    // });

    _nutrients = await isar!.nutrients.where().findAll();
    populateNutrients(_nutrients);
    notifyListeners();
  }

  Nutrient getNutrient(int id) {
    var list = _nutrients.where((element) => (element.id == id)).toList();
    if (list.isNotEmpty) {
      return list.first;
    }
    return Nutrient.empty(0);
  }

  List<Conversion>? getNutrientConversions(int id) {
    var list = _nutrients.where((element) => (element.id == id));
    if (list.isNotEmpty) {
      return list.first.conversions;
    }
    return [];
  }

  List<Nutrient> filterNutrients(filter) {
    var filtered = _nutrients
        .where((n) => (n.descFR.contains(filter) ||
            n.descFR.contains(capitalize(filter))))
        .toList();
    return filtered;
  }

  void addNutrient(Nutrient nutrient) async {
    await isar!.writeTxn(() async {
      await isar!.nutrients.put(nutrient);
    });
    _nutrients.add(nutrient);
    notifyListeners();
  }

  populateNutrients(nutrients) async {
    if (nutrients.isEmpty) {
      //we populate the database from the csv file

      final rawData = await rootBundle.loadString("assets/nutrients_full.csv");
      List<List<dynamic>> listData = const CsvToListConverter()
          .convert(rawData, convertEmptyTo: 0.0, eol: '\n');

      final convRawData =
          await rootBundle.loadString("assets/conversions_full.csv");
      List<List<dynamic>> convListData =
          const CsvToListConverter().convert(convRawData, eol: '\n');

      for (var item in listData.sublist(1)) {
        var nutrient = Nutrient(
            item[0], //foodid
            item[1], //descen
            item[2], //descfr
            item[9] + 0.0, //prot
            item[10] + 0.0, //h2o
            item[15] + 0.0, //fat
            item[16] + 0.0, //kcal
            item[17] + 0.0 //carb
            );

        for (var convItem in convListData.sublist(1)) {
          if (convItem[0] == item[0]) {
            var conversion = Conversion();
            conversion.id = convItem[1];
            conversion.descEN = convItem[2];
            conversion.descFR = convItem[3];
            conversion.factor = convItem[4];
            nutrient.conversions!.add(conversion);
          }
        }

        addNutrient(nutrient);
      }
    }
  }
}
