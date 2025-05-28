// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get addRecipe => 'Add recipe';

  @override
  String get addStep => 'Add step';

  @override
  String get insertStep => 'Add intermediate step';

  @override
  String get moveToNextStep => 'Move to next step';

  @override
  String get calories => 'Calories';

  @override
  String get carbohydrates => 'Carbohydrates';

  @override
  String get kcps => 'Kcal/serv.';

  @override
  String get kc => 'Kcal';

  @override
  String get gps => 'g/serv.';

  @override
  String get g => 'g';

  @override
  String get editRecipe => 'Edit recipe';

  @override
  String get editStep => 'Edit step';

  @override
  String get newRecipe => 'New recipe';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get instructions => 'Instructions';

  @override
  String get step => 'Step';

  @override
  String get steps => 'Steps';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get deleteRecipe => 'Delete the recipe';

  @override
  String get title => 'Title';

  @override
  String get timer => 'Timer';

  @override
  String get min => 'min';

  @override
  String get name => 'Name';

  @override
  String get unit => 'Unit';

  @override
  String get quantity => 'Quantity';

  @override
  String get direction => 'Direction';

  @override
  String get pickImage => 'Pick an image';

  @override
  String get addImage => 'Add an image';

  @override
  String get changeImage => 'Change the image';

  @override
  String get source => 'Source';

  @override
  String get search => 'Search';

  @override
  String get servings => 'Servings';

  @override
  String get month => 'Month';

  @override
  String get shape => 'Shape';

  @override
  String get notes => 'Notes';

  @override
  String enterTextFor(Object field) {
    return 'Please enter some text for $field';
  }

  @override
  String get noRecipe =>
      'No recipe available.\nPlease add one, using the + button on the bottom.';

  @override
  String get noStepsAddedYet => 'No steps added yet.';

  @override
  String get category => 'Category';

  @override
  String get all => 'All';

  @override
  String get snacks => 'Snacks';

  @override
  String get cocktails => 'Cocktails';

  @override
  String get drinks => 'Drinks';

  @override
  String get appetizers => 'Appetizers';

  @override
  String get starters => 'Starters';

  @override
  String get soups => 'Soups';

  @override
  String get mains => 'Mains';

  @override
  String get sides => 'Sides';

  @override
  String get desserts => 'Desserts';

  @override
  String get basics => 'Basics';

  @override
  String get sauces => 'Sauces';

  @override
  String get breakfast => 'Breakfast';

  @override
  String get countryCode => 'Country code';

  @override
  String get chooseCountry => 'Choose a country';

  @override
  String get country => 'Country';

  @override
  String get allCountries => 'All countries';

  @override
  String get shoppingList => 'Shopping list';

  @override
  String get pinch => ' pinch';

  @override
  String get tsp => 'tsp';

  @override
  String get tbsp => 'tbsp';

  @override
  String get bunch => ' bunch';

  @override
  String get sprig => ' sprig';

  @override
  String get packet => ' packet';

  @override
  String get leaf => ' leaf';

  @override
  String get cup => ' cup';

  @override
  String get slice => ' slice';

  @override
  String get stick => ' stick';

  @override
  String get handful => ' handful';

  @override
  String get piece => ' piece';

  @override
  String get clove => ' clove';

  @override
  String get head => ' head';

  @override
  String get stalk => ' stalk';

  @override
  String get recipes => 'Recipes';

  @override
  String get scrollToTop => 'Scroll to top';

  @override
  String get saveError => 'Save error';

  @override
  String get selectNutrient => 'Select nutrient';

  @override
  String get selectFactor => 'Select factor';

  @override
  String get noIngredientsForStep => 'No ingredients for this step';

  @override
  String get titleCannotBeEmpty => 'Title cannot be empty';

  @override
  String get notImplementedYet => 'Feature not yet available';

  @override
  String get start => 'Start';

  @override
  String get language => 'Language';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get profileSettings => 'Profile settings';

  @override
  String get dietaryRestrictions => 'Dietary restrictions';

  @override
  String get vegan => 'Vegan';

  @override
  String get vegetarian => 'Vegetarian';

  @override
  String get glutenFree => 'Gluten-free';

  @override
  String get close => 'Close';

  @override
  String searchXRecipes(Object count) {
    return 'Search through $count recipes...';
  }

  @override
  String get resetFilters => 'Reset filters';

  @override
  String get addIngredient => 'Add ingredient';

  @override
  String get minutes => 'minutes';

  @override
  String get hours => 'hours';

  @override
  String get minutes_abbreviation => 'min';

  @override
  String get hours_abbreviation => 'h';

  @override
  String get timerUsage =>
      'Tap to pause/resume,\nlong press to stop the timer.';

  @override
  String get noMatchingNutrient => 'No matching nutrients found';

  @override
  String get leaveWithoutSaving => 'Leave without saving?';

  @override
  String get leave => 'Leave';

  @override
  String get unsavedChanges => 'You may have unsaved changes.';

  @override
  String get importRecipe => 'Import recipe';

  @override
  String importRecipeConfirmation(Object url) {
    return 'Do you want to import the recipe from $url? This will overwrite the current title, steps, and image!';
  }

  @override
  String get scrapeError => 'Failed to import recipe data from the URL.';

  @override
  String get checkIngredientsYouHave => 'Check ingredients you already have:';

  @override
  String get addAllToShoppingList => 'Add all ingredients\n to shopping list';

  @override
  String get addMissingToShoppingList =>
      'Add missing ingredients\n to shopping list';

  @override
  String get shoppingListEmpty => 'Your shopping list is empty.';

  @override
  String get clearList => 'Clear list';

  @override
  String get remove => 'Remove';

  @override
  String get itemsAddedToShoppingList => 'Items added to shopping list';

  @override
  String get tips => 'Tips';

  @override
  String get tipSearch =>
      'You can search recipes by entering any information of a recipe: recipe name, ingredient name, notes, source or step instructions.\nFor instance, you can find chocolate mousse by searching for \'mousse\', \'egg\' or \'whisk\'.';

  @override
  String get tipIngredients =>
      'On a recipe page, tap the \'Ingredients\' tab or swipe left to view the ingredients list.';

  @override
  String get tipShoppingList =>
      'When you add ingredients from a recipe to the shopping list, the recipe is also saved there. You can add ingredients from multiple recipes and access each recipe by tapping its title in the shopping list.';

  @override
  String get tipImport =>
      'You can import a recipe by pasting the full URL from a supported website into the source field when editing a recipe.';

  @override
  String get tipNutritionalValues =>
      'When editing an ingredient in a recipe, you can select a matching nutrient and factor. If you select both, nutritional values will be automatically computed and added to the recipe!';

  @override
  String get gatherIngredients => 'Gather ingredients';

  @override
  String get bowl => 'bowl';

  @override
  String get pot => 'pot';

  @override
  String get fridge => 'fridge';

  @override
  String get freezer => 'freezer';

  @override
  String get oven => 'oven';

  @override
  String get microwave => 'microwave';

  @override
  String get blender => 'blender';

  @override
  String get mixer => 'mixer';

  @override
  String get whisk => 'whisk';

  @override
  String get skillet => 'skillet';

  @override
  String get paddle => 'paddle';

  @override
  String get cut => 'cut';

  @override
  String get rollingPin => 'rolling pin';

  @override
  String get editImage => 'Edit image';

  @override
  String get clearSelections => 'Clear selections';

  @override
  String get processing => 'Processing';

  @override
  String get rectangleInstructions =>
      'Important: If layout has multiple columns, select blocks!\n(if there is only one column, ignore and click on \'save\')';

  @override
  String get rectangleDetails =>
      'Unfortunately, OCR is not working well on layouts with multiple columns. We will need to reformat the image.\n\nFirst select the title+ingredients block, then each column.\nThey will be merged in a new image.';

  @override
  String get apple => 'apple';

  @override
  String get apricot => 'apricot';

  @override
  String get asparagus => 'asparagus';

  @override
  String get avocado => 'avocado';

  @override
  String get banana => 'banana';

  @override
  String get bellPepper => 'bell pepper';

  @override
  String get blackberry => 'blackberry';

  @override
  String get blueberry => 'blueberry';

  @override
  String get broccoli => 'broccoli';

  @override
  String get butter => 'butter';

  @override
  String get cabbage => 'cabbage';

  @override
  String get carambola => 'star fruit';

  @override
  String get carrot => 'carrot';

  @override
  String get cauliflower => 'cauliflower';

  @override
  String get celery => 'celery';

  @override
  String get cherry => 'cherry';

  @override
  String get chicken => 'chicken';

  @override
  String get coconut => 'coconut';

  @override
  String get corn => 'corn';

  @override
  String get cucumber => 'cucumber';

  @override
  String get chocolateDark => 'dark chocolate';

  @override
  String get chocolateMilk => 'milk chocolate';

  @override
  String get chocolateRuby => 'ruby chocolate';

  @override
  String get chocolateWhite => 'white chocolate';

  @override
  String get dragonFruit => 'dragon fruit';

  @override
  String get egg => 'egg';

  @override
  String get eggplant => 'eggplant';

  @override
  String get fig => 'fig';

  @override
  String get garlic => 'garlic';

  @override
  String get grapes => 'grapes';

  @override
  String get greenBean => 'green beans';

  @override
  String get kiwi => 'kiwi';

  @override
  String get leek => 'leek';

  @override
  String get lemon => 'lemon';

  @override
  String get lettuce => 'lettuce';

  @override
  String get lime => 'lime';

  @override
  String get lychee => 'lychee';

  @override
  String get mango => 'mango';

  @override
  String get melon => 'melon';

  @override
  String get milk => 'milk';

  @override
  String get mushroom => 'mushroom';

  @override
  String get oliveOil => 'olive oil';

  @override
  String get onion => 'onion';

  @override
  String get orange => 'orange';

  @override
  String get peach => 'peach';

  @override
  String get pear => 'pear';

  @override
  String get peas => 'peas';

  @override
  String get pineapple => 'pineapple';

  @override
  String get plum => 'plum';

  @override
  String get pomegranate => 'pomegranate';

  @override
  String get potato => 'potato';

  @override
  String get pumpkin => 'pumpkin';

  @override
  String get radish => 'radish';

  @override
  String get raspberry => 'raspberry';

  @override
  String get salmon => 'salmon';

  @override
  String get spinach => 'spinach';

  @override
  String get strawberry => 'strawberry';

  @override
  String get sweetPotato => 'sweet potato';

  @override
  String get tomato => 'tomato';

  @override
  String get watermelon => 'watermelon';

  @override
  String get zucchini => 'zucchini';

  @override
  String get measurementSystem => 'Measurement System';

  @override
  String get metric => 'Metric';

  @override
  String get us => 'US';

  @override
  String piecesPerServing(Object pieces_count) {
    return '$pieces_count per serving';
  }

  @override
  String get makeAhead => 'Make ahead and storage';

  @override
  String get preparation => 'preparation';

  @override
  String get cooking => 'cooking';

  @override
  String get rest => 'rest';

  @override
  String get enableCookMode => 'Cook mode';

  @override
  String get keepScreenOn => 'keep the screen on (prevent sleep mode)';

  @override
  String get disableCookMode => 'Disable cook mode';
}
