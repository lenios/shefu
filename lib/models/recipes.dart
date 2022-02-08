import 'package:hive/hive.dart';
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

  @HiveField(5, defaultValue: 4)
  int servings = 4;

  @HiveField(6, defaultValue: [])
  List<String> tags = [];

  @HiveField(7, defaultValue: '')
  String category = Category.all.toString();

  //ISO 3166-1-alpha-2 Flags
  @HiveField(8, defaultValue: '')
  String country_code = '';

  Recipe(this.title, this.source, this.image_path);
}

enum Category {
  all,
  snacks,
  cocktails,
  drinks,
  appetizers,
  starters,
  soups,
  mains,
  sides,
  desserts,
  basics,
}
