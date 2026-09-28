import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('hu'),
    Locale('ja'),
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addRecipe.
  ///
  /// In en, this message translates to:
  /// **'Add recipe'**
  String get addRecipe;

  /// No description provided for @addStep.
  ///
  /// In en, this message translates to:
  /// **'Add step'**
  String get addStep;

  /// No description provided for @insertStep.
  ///
  /// In en, this message translates to:
  /// **'Add intermediate step'**
  String get insertStep;

  /// No description provided for @moveToPreviousStep.
  ///
  /// In en, this message translates to:
  /// **'Move to previous step'**
  String get moveToPreviousStep;

  /// No description provided for @moveToNextStep.
  ///
  /// In en, this message translates to:
  /// **'Move to next step'**
  String get moveToNextStep;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @carbohydrates.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get carbohydrates;

  /// No description provided for @proteins.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get proteins;

  /// No description provided for @showCarbohydrates.
  ///
  /// In en, this message translates to:
  /// **'Display carbohydrates'**
  String get showCarbohydrates;

  /// No description provided for @kcps.
  ///
  /// In en, this message translates to:
  /// **'Kcal/serv.'**
  String get kcps;

  /// No description provided for @kc.
  ///
  /// In en, this message translates to:
  /// **'Kcal'**
  String get kc;

  /// No description provided for @gps.
  ///
  /// In en, this message translates to:
  /// **'g/serv.'**
  String get gps;

  /// No description provided for @g.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get g;

  /// No description provided for @editRecipe.
  ///
  /// In en, this message translates to:
  /// **'Edit recipe'**
  String get editRecipe;

  /// No description provided for @editStep.
  ///
  /// In en, this message translates to:
  /// **'Edit step'**
  String get editStep;

  /// No description provided for @newRecipe.
  ///
  /// In en, this message translates to:
  /// **'New recipe'**
  String get newRecipe;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @steps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get steps;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveRecipe.
  ///
  /// In en, this message translates to:
  /// **'Save recipe and all variants'**
  String get saveRecipe;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteRecipe.
  ///
  /// In en, this message translates to:
  /// **'Delete the recipe'**
  String get deleteRecipe;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @direction.
  ///
  /// In en, this message translates to:
  /// **'Direction'**
  String get direction;

  /// No description provided for @pickImage.
  ///
  /// In en, this message translates to:
  /// **'Pick an image'**
  String get pickImage;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add an image'**
  String get addImage;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change the image'**
  String get changeImage;

  /// No description provided for @videoUrl.
  ///
  /// In en, this message translates to:
  /// **'Video url'**
  String get videoUrl;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @servings.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get servings;

  /// No description provided for @usingRecipeServings.
  ///
  /// In en, this message translates to:
  /// **'Using recipe default servings'**
  String get usingRecipeServings;

  /// No description provided for @usingAppServings.
  ///
  /// In en, this message translates to:
  /// **'Using user set servings'**
  String get usingAppServings;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @shape.
  ///
  /// In en, this message translates to:
  /// **'Shape'**
  String get shape;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @enterTextFor.
  ///
  /// In en, this message translates to:
  /// **'Please enter some text for {field}'**
  String enterTextFor(Object field);

  /// No description provided for @noRecipe.
  ///
  /// In en, this message translates to:
  /// **'No recipe available.\nPlease add one, using the + button on the bottom.'**
  String get noRecipe;

  /// No description provided for @noStepsAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No steps added yet.'**
  String get noStepsAddedYet;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @snacks.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get snacks;

  /// No description provided for @cocktails.
  ///
  /// In en, this message translates to:
  /// **'Cocktail'**
  String get cocktails;

  /// No description provided for @drinks.
  ///
  /// In en, this message translates to:
  /// **'Drink'**
  String get drinks;

  /// No description provided for @appetizers.
  ///
  /// In en, this message translates to:
  /// **'Appetizer'**
  String get appetizers;

  /// No description provided for @starters.
  ///
  /// In en, this message translates to:
  /// **'Starter'**
  String get starters;

  /// No description provided for @soups.
  ///
  /// In en, this message translates to:
  /// **'Soup'**
  String get soups;

  /// No description provided for @mains.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get mains;

  /// No description provided for @sides.
  ///
  /// In en, this message translates to:
  /// **'Side'**
  String get sides;

  /// No description provided for @desserts.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get desserts;

  /// No description provided for @basics.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basics;

  /// No description provided for @sauces.
  ///
  /// In en, this message translates to:
  /// **'Sauce'**
  String get sauces;

  /// No description provided for @breakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get breakfast;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'Country code'**
  String get countryCode;

  /// No description provided for @chooseCountry.
  ///
  /// In en, this message translates to:
  /// **'Choose a country'**
  String get chooseCountry;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @allCountries.
  ///
  /// In en, this message translates to:
  /// **'All countries'**
  String get allCountries;

  /// No description provided for @shoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping list'**
  String get shoppingList;

  /// No description provided for @pinch.
  ///
  /// In en, this message translates to:
  /// **' pinch'**
  String get pinch;

  /// No description provided for @tsp.
  ///
  /// In en, this message translates to:
  /// **'tsp'**
  String get tsp;

  /// No description provided for @tbsp.
  ///
  /// In en, this message translates to:
  /// **'tbsp'**
  String get tbsp;

  /// No description provided for @bunch.
  ///
  /// In en, this message translates to:
  /// **' bunch'**
  String get bunch;

  /// No description provided for @sprig.
  ///
  /// In en, this message translates to:
  /// **' sprig'**
  String get sprig;

  /// No description provided for @packet.
  ///
  /// In en, this message translates to:
  /// **' packet'**
  String get packet;

  /// No description provided for @leaf.
  ///
  /// In en, this message translates to:
  /// **' leaf'**
  String get leaf;

  /// No description provided for @cup.
  ///
  /// In en, this message translates to:
  /// **' cup'**
  String get cup;

  /// No description provided for @slice.
  ///
  /// In en, this message translates to:
  /// **' slice'**
  String get slice;

  /// No description provided for @stick.
  ///
  /// In en, this message translates to:
  /// **' stick'**
  String get stick;

  /// No description provided for @handful.
  ///
  /// In en, this message translates to:
  /// **' handful'**
  String get handful;

  /// No description provided for @piece.
  ///
  /// In en, this message translates to:
  /// **' piece'**
  String get piece;

  /// No description provided for @clove.
  ///
  /// In en, this message translates to:
  /// **' clove'**
  String get clove;

  /// No description provided for @head.
  ///
  /// In en, this message translates to:
  /// **' head'**
  String get head;

  /// No description provided for @stalk.
  ///
  /// In en, this message translates to:
  /// **' stalk'**
  String get stalk;

  /// No description provided for @recipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipes;

  /// No description provided for @scrollToTop.
  ///
  /// In en, this message translates to:
  /// **'Scroll to top'**
  String get scrollToTop;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Save error'**
  String get saveError;

  /// No description provided for @selectNutrient.
  ///
  /// In en, this message translates to:
  /// **'Select nutrient'**
  String get selectNutrient;

  /// No description provided for @selectFactor.
  ///
  /// In en, this message translates to:
  /// **'Select factor'**
  String get selectFactor;

  /// No description provided for @noIngredientsForStep.
  ///
  /// In en, this message translates to:
  /// **'No ingredients for this step'**
  String get noIngredientsForStep;

  /// No description provided for @titleCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Title cannot be empty'**
  String get titleCannotBeEmpty;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @useMaterialYou.
  ///
  /// In en, this message translates to:
  /// **'Use Material You design'**
  String get useMaterialYou;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @profileSettings.
  ///
  /// In en, this message translates to:
  /// **'Profile settings'**
  String get profileSettings;

  /// No description provided for @dietaryRestrictions.
  ///
  /// In en, this message translates to:
  /// **'Dietary restrictions'**
  String get dietaryRestrictions;

  /// No description provided for @vegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get vegan;

  /// No description provided for @vegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get vegetarian;

  /// No description provided for @glutenFree.
  ///
  /// In en, this message translates to:
  /// **'Gluten-free'**
  String get glutenFree;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @searchXRecipes.
  ///
  /// In en, this message translates to:
  /// **'Search through {count} recipes...'**
  String searchXRecipes(Object count);

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @addIngredient.
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get addIngredient;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @minutes_abbreviation.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes_abbreviation;

  /// No description provided for @hours_abbreviation.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get hours_abbreviation;

  /// No description provided for @pauseUsage.
  ///
  /// In en, this message translates to:
  /// **'Tap to pause/resume,\nlong press to stop.'**
  String get pauseUsage;

  /// No description provided for @noMatchingNutrient.
  ///
  /// In en, this message translates to:
  /// **'No matching nutrients found'**
  String get noMatchingNutrient;

  /// No description provided for @leaveWithoutSaving.
  ///
  /// In en, this message translates to:
  /// **'Leave without saving?'**
  String get leaveWithoutSaving;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'You may have unsaved changes. Click \'Save\' to save all changes, in the recipe and its variants. Leave to discard.'**
  String get unsavedChanges;

  /// No description provided for @importRecipe.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importRecipe;

  /// No description provided for @importRecipeConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to import the recipe from {url}? This will overwrite the current title, steps, and image!'**
  String importRecipeConfirmation(Object url);

  /// No description provided for @scrapeError.
  ///
  /// In en, this message translates to:
  /// **'Failed to import recipe data from the URL.'**
  String get scrapeError;

  /// No description provided for @checkIngredientsYouHave.
  ///
  /// In en, this message translates to:
  /// **'Check ingredients you already have:'**
  String get checkIngredientsYouHave;

  /// No description provided for @addAllToShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Add all ingredients\n to shopping list'**
  String get addAllToShoppingList;

  /// No description provided for @addMissingToShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Add missing ingredients\n to shopping list'**
  String get addMissingToShoppingList;

  /// No description provided for @shoppingListEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your shopping list is empty.'**
  String get shoppingListEmpty;

  /// No description provided for @clearList.
  ///
  /// In en, this message translates to:
  /// **'Clear list'**
  String get clearList;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @itemsAddedToShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Items added to shopping list'**
  String get itemsAddedToShoppingList;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @tipSearch.
  ///
  /// In en, this message translates to:
  /// **'You can search recipes by entering any information of a recipe: recipe name, ingredient name, notes, source or step instructions.\nFor instance, you can find chocolate mousse by searching for \'mousse\', \'egg\' or \'whisk\'.'**
  String get tipSearch;

  /// No description provided for @tipIngredients.
  ///
  /// In en, this message translates to:
  /// **'On a recipe page, tap the \'Ingredients\' tab or swipe left to view the ingredients list.'**
  String get tipIngredients;

  /// No description provided for @tipShoppingList.
  ///
  /// In en, this message translates to:
  /// **'When you add ingredients from a recipe to the shopping list, the recipe is also saved there. You can add ingredients from multiple recipes and access each recipe by tapping its title in the shopping list.'**
  String get tipShoppingList;

  /// No description provided for @expertSettings.
  ///
  /// In en, this message translates to:
  /// **'Expert settings'**
  String get expertSettings;

  /// No description provided for @tipImport.
  ///
  /// In en, this message translates to:
  /// **'You can import a recipe by pasting the full URL from a supported website into the source field when editing a recipe.'**
  String get tipImport;

  /// No description provided for @tipNutritionalValues.
  ///
  /// In en, this message translates to:
  /// **'When editing an ingredient in a recipe, you can select a matching nutrient and factor. If you select both, nutritional values will be automatically computed and added to the recipe!'**
  String get tipNutritionalValues;

  /// No description provided for @gatherIngredients.
  ///
  /// In en, this message translates to:
  /// **'Gather ingredients'**
  String get gatherIngredients;

  /// No description provided for @editImage.
  ///
  /// In en, this message translates to:
  /// **'Edit image'**
  String get editImage;

  /// No description provided for @clearSelections.
  ///
  /// In en, this message translates to:
  /// **'Clear selections'**
  String get clearSelections;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @rectangleInstructions.
  ///
  /// In en, this message translates to:
  /// **'Important: If layout has multiple columns, select blocks!\n(if there is only one column, ignore and click on \'save\')'**
  String get rectangleInstructions;

  /// No description provided for @rectangleDetails.
  ///
  /// In en, this message translates to:
  /// **'Unfortunately, OCR is not working well on layouts with multiple columns. We will need to reformat the image.\n\nFirst select the title+ingredients block, then each column.\nThey will be merged in a new image.'**
  String get rectangleDetails;

  /// No description provided for @measurementSystem.
  ///
  /// In en, this message translates to:
  /// **'Measurement System'**
  String get measurementSystem;

  /// No description provided for @metric.
  ///
  /// In en, this message translates to:
  /// **'Metric'**
  String get metric;

  /// No description provided for @us.
  ///
  /// In en, this message translates to:
  /// **'US'**
  String get us;

  /// No description provided for @piecesPerServing.
  ///
  /// In en, this message translates to:
  /// **'{pieces_count} per serving'**
  String piecesPerServing(Object pieces_count);

  /// No description provided for @makeAhead.
  ///
  /// In en, this message translates to:
  /// **'Make ahead and storage'**
  String get makeAhead;

  /// No description provided for @preparation.
  ///
  /// In en, this message translates to:
  /// **'preparation'**
  String get preparation;

  /// No description provided for @cooking.
  ///
  /// In en, this message translates to:
  /// **'cooking'**
  String get cooking;

  /// No description provided for @rest.
  ///
  /// In en, this message translates to:
  /// **'rest'**
  String get rest;

  /// No description provided for @enableCookMode.
  ///
  /// In en, this message translates to:
  /// **'Cook mode'**
  String get enableCookMode;

  /// No description provided for @keepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'keep the screen on (prevent sleep mode)'**
  String get keepScreenOn;

  /// No description provided for @disableCookMode.
  ///
  /// In en, this message translates to:
  /// **'Disable cook mode'**
  String get disableCookMode;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'export'**
  String get export;

  /// No description provided for @generatingPdf.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF...'**
  String get generatingPdf;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questions;

  /// No description provided for @searchRecipesOnline.
  ///
  /// In en, this message translates to:
  /// **'Search Online'**
  String get searchRecipesOnline;

  /// No description provided for @selectSitesToSearch.
  ///
  /// In en, this message translates to:
  /// **'Select Recipe Sites'**
  String get selectSitesToSearch;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @searchForOnlineRecipes.
  ///
  /// In en, this message translates to:
  /// **'Search for recipes to import'**
  String get searchForOnlineRecipes;

  /// No description provided for @recipeImportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Recipe imported successfully!'**
  String get recipeImportedSuccessfully;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed'**
  String get importFailed;

  /// No description provided for @selectAllSites.
  ///
  /// In en, this message translates to:
  /// **'All Sites'**
  String get selectAllSites;

  /// No description provided for @deselectAllSites.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get deselectAllSites;

  /// No description provided for @speak.
  ///
  /// In en, this message translates to:
  /// **'Read recipe aloud'**
  String get speak;

  /// No description provided for @enterValidServings.
  ///
  /// In en, this message translates to:
  /// **'Please enter an integer number'**
  String get enterValidServings;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @sourceCodeAvailableAt.
  ///
  /// In en, this message translates to:
  /// **'Published under GNU General Public License v3.0. Application source code available at:'**
  String get sourceCodeAvailableAt;

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @nutritionFacts.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Facts'**
  String get nutritionFacts;

  /// No description provided for @servingSize.
  ///
  /// In en, this message translates to:
  /// **'Serving size'**
  String get servingSize;

  /// No description provided for @serving.
  ///
  /// In en, this message translates to:
  /// **'serving'**
  String get serving;

  /// No description provided for @servingsPerRecipe.
  ///
  /// In en, this message translates to:
  /// **'Servings per recipe'**
  String get servingsPerRecipe;

  /// No description provided for @dailyValue.
  ///
  /// In en, this message translates to:
  /// **'Daily Value'**
  String get dailyValue;

  /// No description provided for @totalFat.
  ///
  /// In en, this message translates to:
  /// **'Total Fat'**
  String get totalFat;

  /// No description provided for @nutritionCalculatedNote.
  ///
  /// In en, this message translates to:
  /// **'Nutritional values calculated from linked ingredients'**
  String get nutritionCalculatedNote;

  /// No description provided for @nutritionImportedNote.
  ///
  /// In en, this message translates to:
  /// **'Nutritional values from imported recipe data'**
  String get nutritionImportedNote;

  /// No description provided for @dailyValueDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Percent Daily Values are based on a 2,000 calorie diet. Your daily values may be higher or lower depending on your calorie needs.'**
  String get dailyValueDisclaimer;

  /// No description provided for @amountPerServing.
  ///
  /// In en, this message translates to:
  /// **'Amount per serving'**
  String get amountPerServing;

  /// No description provided for @saturatedFat.
  ///
  /// In en, this message translates to:
  /// **'Saturated Fat'**
  String get saturatedFat;

  /// No description provided for @transFat.
  ///
  /// In en, this message translates to:
  /// **'Trans Fat'**
  String get transFat;

  /// No description provided for @cholesterol.
  ///
  /// In en, this message translates to:
  /// **'Cholesterol'**
  String get cholesterol;

  /// No description provided for @sodium.
  ///
  /// In en, this message translates to:
  /// **'Sodium'**
  String get sodium;

  /// No description provided for @dietaryFiber.
  ///
  /// In en, this message translates to:
  /// **'Dietary Fiber'**
  String get dietaryFiber;

  /// No description provided for @totalSugars.
  ///
  /// In en, this message translates to:
  /// **'Total Sugars'**
  String get totalSugars;

  /// No description provided for @addedSugars.
  ///
  /// In en, this message translates to:
  /// **'Added Sugars'**
  String get addedSugars;

  /// No description provided for @vitaminD.
  ///
  /// In en, this message translates to:
  /// **'Vitamin D'**
  String get vitaminD;

  /// No description provided for @calcium.
  ///
  /// In en, this message translates to:
  /// **'Calcium'**
  String get calcium;

  /// No description provided for @iron.
  ///
  /// In en, this message translates to:
  /// **'Iron'**
  String get iron;

  /// No description provided for @potassium.
  ///
  /// In en, this message translates to:
  /// **'Potassium'**
  String get potassium;

  /// No description provided for @vitaminC.
  ///
  /// In en, this message translates to:
  /// **'Vitamin C'**
  String get vitaminC;

  /// No description provided for @nutriScoreNote.
  ///
  /// In en, this message translates to:
  /// **'Estimated for the whole recipe as a general food, from the raw weights of the linked ingredients'**
  String get nutriScoreNote;

  /// No description provided for @postedOnBy.
  ///
  /// In en, this message translates to:
  /// **'Posted on {date} by {author}'**
  String postedOnBy(Object author, Object date);

  /// No description provided for @exportRecipes.
  ///
  /// In en, this message translates to:
  /// **'Export recipes'**
  String get exportRecipes;

  /// No description provided for @importRecipes.
  ///
  /// In en, this message translates to:
  /// **'Import recipes'**
  String get importRecipes;

  /// No description provided for @allRecipes.
  ///
  /// In en, this message translates to:
  /// **'All recipes'**
  String get allRecipes;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @exportedRecipes.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, one{recipe exported} other{{count} recipes exported}}'**
  String exportedRecipes(num count);

  /// No description provided for @importedRecipes.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, one{recipe imported} other{{count} recipes imported}}'**
  String importedRecipes(num count);

  /// No description provided for @importSkipped.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =1{duplicate recipe skipped} other{{count} duplicate recipes skipped}}'**
  String importSkipped(num count);

  /// No description provided for @importZipHint.
  ///
  /// In en, this message translates to:
  /// **'Select a zip file to import recipes. The zip file must have been generated by the Shefu application.'**
  String get importZipHint;

  /// No description provided for @importFromZip.
  ///
  /// In en, this message translates to:
  /// **'Import from zip file'**
  String get importFromZip;

  /// No description provided for @importFromUrl.
  ///
  /// In en, this message translates to:
  /// **'Import from a web url'**
  String get importFromUrl;

  /// No description provided for @writeRecipe.
  ///
  /// In en, this message translates to:
  /// **'Write recipe'**
  String get writeRecipe;

  /// No description provided for @importInternalError.
  ///
  /// In en, this message translates to:
  /// **'Import failed. This is an internal error. Please open a bug through https://github.com/lenios/shefu/issues and provide the import file if possible for analysis.'**
  String get importInternalError;

  /// No description provided for @exportAsPdf.
  ///
  /// In en, this message translates to:
  /// **'Export as PDF'**
  String get exportAsPdf;

  /// No description provided for @exportAsZip.
  ///
  /// In en, this message translates to:
  /// **'Export as ZIP'**
  String get exportAsZip;

  /// No description provided for @copyAsText.
  ///
  /// In en, this message translates to:
  /// **'Copy as text'**
  String get copyAsText;

  /// No description provided for @shareSourceLink.
  ///
  /// In en, this message translates to:
  /// **'Share source link'**
  String get shareSourceLink;

  /// No description provided for @recipeCopied.
  ///
  /// In en, this message translates to:
  /// **'Recipe copied to the clipboard'**
  String get recipeCopied;

  /// No description provided for @exportFormatHint.
  ///
  /// In en, this message translates to:
  /// **'Select PDF format to print or view on a screen, and ZIP format to import later.'**
  String get exportFormatHint;

  /// No description provided for @exportCount.
  ///
  /// In en, this message translates to:
  /// **'{count,plural, =0{Export 0 recipe} =1{Export 1 recipe} other{Export {count} recipes}}'**
  String exportCount(num count);

  /// No description provided for @zipSavedTo.
  ///
  /// In en, this message translates to:
  /// **'Saved to {path}'**
  String zipSavedTo(Object path);

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect all'**
  String get deselectAll;

  /// No description provided for @invalidZipFile.
  ///
  /// In en, this message translates to:
  /// **'Invalid file: the zip file is not a Shefu export archive.'**
  String get invalidZipFile;

  /// No description provided for @supportedWebsitesNote.
  ///
  /// In en, this message translates to:
  /// **'See the list of supported websites at: '**
  String get supportedWebsitesNote;

  /// No description provided for @variant.
  ///
  /// In en, this message translates to:
  /// **'Variant'**
  String get variant;

  /// No description provided for @addVariant.
  ///
  /// In en, this message translates to:
  /// **'Add variant'**
  String get addVariant;

  /// No description provided for @deleteVariant.
  ///
  /// In en, this message translates to:
  /// **'Delete variant'**
  String get deleteVariant;

  /// No description provided for @deleteVariantQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this variant?'**
  String get deleteVariantQuestion;

  /// No description provided for @deleteVariantConfirmation.
  ///
  /// In en, this message translates to:
  /// **'The {variant} variant will be deleted.'**
  String deleteVariantConfirmation(Object variant);

  /// No description provided for @deleteVariantWarning.
  ///
  /// In en, this message translates to:
  /// **'The variant is deleted.'**
  String get deleteVariantWarning;

  /// No description provided for @overrideStep.
  ///
  /// In en, this message translates to:
  /// **'Override'**
  String get overrideStep;

  /// No description provided for @removeOverride.
  ///
  /// In en, this message translates to:
  /// **'Remove override'**
  String get removeOverride;

  /// No description provided for @exportRecipe.
  ///
  /// In en, this message translates to:
  /// **'Export recipe'**
  String get exportRecipe;

  /// No description provided for @showVariants.
  ///
  /// In en, this message translates to:
  /// **'Display the recipe variants'**
  String get showVariants;

  /// No description provided for @recipeSaved.
  ///
  /// In en, this message translates to:
  /// **'Recipe saved'**
  String get recipeSaved;

  /// No description provided for @variantSaved.
  ///
  /// In en, this message translates to:
  /// **'Variant {variant} saved'**
  String variantSaved(Object variant);

  /// No description provided for @legacyMigrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Your recipes from the previous version could not be migrated yet. They are kept safe and the migration will be retried at the next start. If this persists, please open a bug at https://github.com/lenios/shefu/issues.'**
  String get legacyMigrationFailed;

  /// No description provided for @addRecipeAsStep.
  ///
  /// In en, this message translates to:
  /// **'Add a recipe'**
  String get addRecipeAsStep;

  /// No description provided for @chooseRecipe.
  ///
  /// In en, this message translates to:
  /// **'Choose a recipe to use as a step'**
  String get chooseRecipe;

  /// No description provided for @noLinkableRecipe.
  ///
  /// In en, this message translates to:
  /// **'No other recipe available'**
  String get noLinkableRecipe;

  /// No description provided for @linkedRecipeInfo.
  ///
  /// In en, this message translates to:
  /// **'Recipe for {servings} servings: its quantities follow this recipe'**
  String linkedRecipeInfo(int servings);

  /// No description provided for @openLinkedRecipe.
  ///
  /// In en, this message translates to:
  /// **'See recipe'**
  String get openLinkedRecipe;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr', 'hu', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'hu':
      return AppLocalizationsHu();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
