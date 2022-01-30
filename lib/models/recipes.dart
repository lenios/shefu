import 'package:hive/hive.dart';
import 'recipe_steps.dart';

part 'recipes.g.dart';

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String source;

  @HiveField(2)
  String image_path;

  @HiveField(3)
  List<int> steps = [];

  @HiveField(4)
  String notes = '';

  @HiveField(5)
  int servings = 4;

  Recipe(this.title, this.source, this.image_path);
}
