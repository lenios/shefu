import 'package:hive/hive.dart';

part 'recipe_steps.g.dart';

@HiveType(typeId: 1)
class RecipeStep extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String instructions;

  @HiveField(2)
  String image_path = '';

  RecipeStep(this.name, this.instructions, this.image_path);
}
