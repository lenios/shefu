import 'package:shefu/models/objectbox_models.dart';

List<Recipe> populateMockRecipes() {
  // First recipe - The Ultimate Harvest Feast
  Recipe harvestRecipe = Recipe(
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
  harvestRecipe.steps.addAll([saladStep, soupStep, mainStep, fruitDessertStep, berryDessertStep]);

  // Second recipe - Chocolate Mousse
  Recipe chocolateMousse = Recipe(
    id: 0,
    title: "Decadent Chocolate Mousse",
    notes: "A silky smooth chocolate dessert that's easy to make but impressive to serve.",
    servings: 4,
    countryCode: "FR",
    category: Category.desserts.index,
    time: 30,
    calories: 380,
    carbohydrates: 22,
    imagePath: "assets/mocks/chocolate-mousse.jpg",
  );

  // Step 1: Prepare the chocolate mixture
  RecipeStep prepareChocolateStep = RecipeStep(
    id: 0,
    name: "",
    instruction:
        "Melt in a heatproof bowl over simmering water. Remove from heat and let cool slightly.",
  );
  prepareChocolateStep.ingredients.addAll([
    IngredientItem(
      id: 0,
      name: "chocolate, dark",
      quantity: 5,
      unit: "g",
      foodId: 501894,
      conversionId: 16982,
    ),
    IngredientItem(id: 0, name: "butter", quantity: 3, unit: "g", foodId: 118, conversionId: 405),
  ]);

  RecipeStep prepareEggStep = RecipeStep(
    id: 0,
    name: "",
    instruction: "Whisk, then mix into the chocolate.",
  );
  prepareEggStep.ingredients.addAll([
    IngredientItem(
      id: 0,
      name: "egg",
      quantity: 4,
      unit: "",
      shape: "yolk",
      foodId: 127,
      conversionId: 455,
    ),
    IngredientItem(id: 0, name: "sugar", quantity: 50, unit: "g", shape: ""),
    IngredientItem(id: 0, name: "vanilla extract", quantity: 1, unit: "tsp"),
    IngredientItem(id: 0, name: "salt", quantity: 0.25, unit: "tsp"),
  ]);

  // Step 2: Prepare the whipped cream
  RecipeStep whipCreamStep = RecipeStep(
    id: 0,
    instruction: "In a clean bowl, whip egg whites until soft peaks form.",
  );
  whipCreamStep.ingredients.addAll([
    IngredientItem(id: 0, name: "egg", quantity: 4, unit: "", shape: "white"),
  ]);

  // Step 2: Prepare the whipped cream
  RecipeStep whipCreamStep2 = RecipeStep(
    id: 0,
    instruction: "In mixer, whip heavy cream until soft peaks form (5 minutes).",
    timer: 5,
  );
  whipCreamStep2.ingredients.addAll([
    IngredientItem(id: 0, name: "heavy cream", quantity: 240, unit: "ml", shape: "cold"),
  ]);

  // Step 3: Combine and chill
  RecipeStep combineChillStep = RecipeStep(
    id: 0,
    instruction:
        "Fold whipped egg whites into chocolate mixture, then gently fold in whipped cream. Divide into serving glasses and refrigerate for at least 3 hours or overnight.",
    timer: 10 * 60, // 10 minutes in seconds (for combining - not including chill time)
  );

  // Add all steps to the chocolate mousse recipe
  chocolateMousse.steps.addAll([
    prepareChocolateStep,
    prepareEggStep,
    whipCreamStep,
    whipCreamStep2,
    combineChillStep,
  ]);

  Recipe pancakeRecipe = Recipe(
    id: 0,
    title: "Fluffy Buttermilk Pancakes",
    notes:
        "Classic, fluffy pancakes that are perfect for a weekend breakfast. Serve with fresh fruits and maple syrup.",
    servings: 4,
    countryCode: "US",
    category: Category.desserts.index,
    time: 25,
    calories: 310,
    carbohydrates: 42,
    imagePath: "assets/mocks/pancakes.jpg",
  );

  // Step 1: Mix dry ingredients
  RecipeStep preheatStep = RecipeStep(
    id: 0,
    instruction: "Preheat oven to 400°F to keep pancakes warm.",
  );

  RecipeStep dryIngredientsStep = RecipeStep(
    id: 0,
    instruction: "In a large bowl, whisk and set aside.",
  );
  dryIngredientsStep.ingredients.addAll([
    IngredientItem(id: 0, name: "all-purpose flour", quantity: 220, unit: "g", shape: ""),
    IngredientItem(id: 0, name: "baking powder", quantity: 2, unit: "tsp"),
    IngredientItem(id: 0, name: "salt", quantity: 0.5, unit: "tsp"),
    IngredientItem(id: 0, name: "sugar", quantity: 30, unit: "g"),
  ]);

  // Step 2: Mix wet ingredients
  RecipeStep wetIngredientsStep = RecipeStep(id: 0, instruction: "In another medium bowl, whisk.");
  wetIngredientsStep.ingredients.addAll([
    IngredientItem(id: 0, name: "buttermilk", quantity: 360, unit: "ml"),
    IngredientItem(id: 0, name: "egg", quantity: 2, unit: "", foodId: 127, conversionId: 455),
    IngredientItem(
      id: 0,
      name: "butter",
      quantity: 45,
      unit: "g",
      shape: "melted",
      foodId: 118,
      conversionId: 405,
    ),
    IngredientItem(id: 0, name: "vanilla extract", quantity: 1, unit: "tsp"),
  ]);

  // Step 3: Combine and cook
  RecipeStep cookPancakesStep = RecipeStep(
    id: 0,
    instruction:
        "Pour wet ingredients into dry ingredients and stir until just combined (lumps are okay).",
    timer: 3 * 60, // 3 minutes in seconds for cooking time
  );

  // Step 4: Serve with toppings
  RecipeStep servePancakesStep = RecipeStep(
    id: 0,
    name: "Heat",
    instruction:
        "Stack pancakes on plates and serve with your choice of fresh fruits, maple syrup, and a pat of butter.",
  );
  servePancakesStep.ingredients.addAll([
    IngredientItem(id: 0, name: "maple syrup", quantity: 120, unit: "ml"),
    IngredientItem(id: 0, name: "strawberry", quantity: 150, unit: "g", shape: "sliced"),
    IngredientItem(id: 0, name: "banana", quantity: 2, unit: "", shape: "sliced"),
    IngredientItem(id: 0, name: "blueberry", quantity: 100, unit: "g"),
    IngredientItem(id: 0, name: "butter", quantity: 15, unit: "g"),
  ]);

  // // Add all steps to the pancake recipe
  // pancakeRecipe.steps.addAll([
  //   dryIngredientsStep,
  //   wetIngredientsStep,
  //   cookPancakesStep,
  //   servePancakesStep,
  // ]);

  // Return all three recipes
  return [harvestRecipe, chocolateMousse, pancakeRecipe];
}
