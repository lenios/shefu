import 'package:hive/hive.dart';

part 'ingredient_tuples.g.dart';

@HiveType(typeId: 2)
class IngredientTuple extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String unit;

  @HiveField(2)
  double quantity;

  @HiveField(3)
  String shape;

  IngredientTuple(this.name, this.unit, this.quantity, this.shape);
}
