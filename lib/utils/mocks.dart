import 'package:shefu/models/objectbox_models.dart';

Recipe populateMockRecipes() {
  Recipe recipe = Recipe(
    id: 0,
    title: "The Ultimate Harvest Feast",
    notes:
        "A comprehensive showcase recipe featuring all seasonal ingredients. Perfect for demonstrating the app's capabilities.",
    servings: 6,
    countryCode: "WW",
    category: Category.mains.index,
    time: 120,
    calories: 870,
    carbohydrates: 95,
  );

  // Appetizer and Salad Course
  RecipeStep saladStep = RecipeStep(
    id: 0,
    name: "Fresh Garden Salad",
    instruction:
        "Combine all vegetables in a large bowl. Toss with lemon and lime juice, olive oil, salt and pepper to taste.",
  );
  saladStep.ingredients.addAll([
    IngredientItem(id: 0, name: "lettuce", quantity: 1, unit: "head"),
    IngredientItem(id: 0, name: "cucumber", quantity: 1, unit: ""),
    IngredientItem(id: 0, name: "tomato", quantity: 2, unit: ""),
    IngredientItem(id: 0, name: "bell pepper", quantity: 1, unit: ""),
    IngredientItem(id: 0, name: "spinach", quantity: 100, unit: "g"),
    IngredientItem(id: 0, name: "radish", quantity: 4, unit: ""),
    IngredientItem(id: 0, name: "leek", quantity: 1, unit: ""),
    IngredientItem(id: 0, name: "celery", quantity: 2, unit: "stalks"),
    IngredientItem(id: 0, name: "lemon", quantity: 0.5, unit: ""),
    IngredientItem(id: 0, name: "lime", quantity: 0.5, unit: ""),
    IngredientItem(id: 0, name: "avocado", quantity: 1, unit: ""),
  ]);

  // Soup Course
  RecipeStep soupStep = RecipeStep(
    id: 0,
    name: "Harvest Vegetable Soup",
    instruction:
        "Sauté onion, garlic, and leek in butter. Add remaining vegetables and broth. Simmer for 30 minutes until vegetables are tender.",
  );
  soupStep.ingredients.addAll([
    IngredientItem(id: 0, name: "onion", quantity: 1, unit: ""),
    IngredientItem(id: 0, name: "garlic", quantity: 3, unit: "cloves"),
    IngredientItem(id: 0, name: "carrot", quantity: 2, unit: ""),
    IngredientItem(id: 0, name: "broccoli", quantity: 1, unit: "head"),
    IngredientItem(id: 0, name: "cabbage", quantity: 0.25, unit: "head"),
    IngredientItem(id: 0, name: "pumpkin", quantity: 200, unit: "g"),
    IngredientItem(id: 0, name: "sweet potato", quantity: 1, unit: ""),
    IngredientItem(id: 0, name: "butter", quantity: 2, unit: "tbsp"),
    IngredientItem(id: 0, name: "asparagus", quantity: 8, unit: "spears"),
    IngredientItem(id: 0, name: "green beans", quantity: 100, unit: "g"),
    IngredientItem(id: 0, name: "mushroom", quantity: 100, unit: "g"),
    IngredientItem(id: 0, name: "peas", quantity: 50, unit: "g"),
  ]);

  // Main Course
  RecipeStep mainStep = RecipeStep(
    id: 0,
    name: "Roasted Salmon with Vegetables",
    instruction:
        "Season salmon fillets with herbs. Roast salmon and vegetables in the oven at 180°C for 20 minutes. Serve with corn and potato sides.",
  );
  mainStep.ingredients.addAll([
    IngredientItem(id: 0, name: "salmon", quantity: 600, unit: "g"),
    IngredientItem(id: 0, name: "potato", quantity: 4, unit: ""),
    IngredientItem(id: 0, name: "corn", quantity: 2, unit: "ears"),
    IngredientItem(id: 0, name: "cauliflower", quantity: 1, unit: "head"),
    IngredientItem(id: 0, name: "zucchini", quantity: 2, unit: ""),
    IngredientItem(id: 0, name: "eggplant", quantity: 1, unit: ""),
  ]);

  // Fruit Dessert
  RecipeStep fruitDessertStep = RecipeStep(
    id: 0,
    name: "Tropical Fruit Salad",
    instruction:
        "Combine all fruit in a large bowl. Drizzle with honey if desired. Chill before serving.",
  );
  fruitDessertStep.ingredients.addAll([
    IngredientItem(id: 0, name: "banana", quantity: 2, unit: ""),
    IngredientItem(id: 0, name: "apple", quantity: 2, unit: ""),
    IngredientItem(id: 0, name: "orange", quantity: 2, unit: ""),
    IngredientItem(id: 0, name: "pear", quantity: 2, unit: ""),
    IngredientItem(id: 0, name: "watermelon", quantity: 500, unit: "g"),
    IngredientItem(id: 0, name: "pineapple", quantity: 0.5, unit: ""),
    IngredientItem(id: 0, name: "mango", quantity: 1, unit: ""),
    IngredientItem(id: 0, name: "kiwi", quantity: 3, unit: ""),
    IngredientItem(id: 0, name: "strawberry", quantity: 200, unit: "g"),
    IngredientItem(id: 0, name: "blueberry", quantity: 100, unit: "g"),
    IngredientItem(id: 0, name: "raspberry", quantity: 100, unit: "g"),
    IngredientItem(id: 0, name: "blackberry", quantity: 100, unit: "g"),
  ]);

  // Berry Dessert
  RecipeStep berryDessertStep = RecipeStep(
    id: 0,
    name: "Exotic Fruit Compote",
    instruction:
        "Cook exotic fruits with sugar until soft. Serve warm or chilled with a dollop of cream.",
  );
  berryDessertStep.ingredients.addAll([
    IngredientItem(id: 0, name: "dragon fruit", quantity: 1, unit: ""),
    IngredientItem(id: 0, name: "star fruit", quantity: 2, unit: ""),
    IngredientItem(id: 0, name: "lychee", quantity: 10, unit: ""),
    IngredientItem(id: 0, name: "coconut", quantity: 0.5, unit: ""),
    IngredientItem(id: 0, name: "plum", quantity: 4, unit: ""),
    IngredientItem(id: 0, name: "apricot", quantity: 4, unit: ""),
    IngredientItem(id: 0, name: "peach", quantity: 2, unit: ""),
    IngredientItem(id: 0, name: "melon", quantity: 0.5, unit: ""),
    IngredientItem(id: 0, name: "grapes", quantity: 100, unit: "g"),
    IngredientItem(id: 0, name: "pomegranate", quantity: 1, unit: ""),
    IngredientItem(id: 0, name: "cherry", quantity: 100, unit: "g"),
    IngredientItem(id: 0, name: "fig", quantity: 4, unit: ""),
  ]);

  // Add all steps to recipe
  recipe.steps.addAll([saladStep, soupStep, mainStep, fruitDessertStep, berryDessertStep]);

  return recipe;
}
