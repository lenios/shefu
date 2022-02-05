import 'package:hive/hive.dart';

part 'recipe_steps.g.dart';

@HiveType(typeId: 1)
class RecipeStep extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String direction;

  @HiveField(2)
  String image_path = '';

  @HiveField(3)
  int timer = 0;

  @HiveField(4)
  List<int> ingredients = [];

  RecipeStep(this.name, this.direction, this.image_path);
}
