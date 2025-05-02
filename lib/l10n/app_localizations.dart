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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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
    Locale('ja')
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

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @carbohydrates.
  ///
  /// In en, this message translates to:
  /// **'carbohydrates'**
  String get carbohydrates;

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
  /// **'No recipe available.\nPlease create one, using the + button on the bottom.'**
  String get noRecipe;

  /// No description provided for @noStepsAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No steps added yet.'**
  String get noStepsAddedYet;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'category'**
  String get category;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get all;

  /// No description provided for @snacks.
  ///
  /// In en, this message translates to:
  /// **'snacks'**
  String get snacks;

  /// No description provided for @cocktails.
  ///
  /// In en, this message translates to:
  /// **'cocktails'**
  String get cocktails;

  /// No description provided for @drinks.
  ///
  /// In en, this message translates to:
  /// **'drinks'**
  String get drinks;

  /// No description provided for @appetizers.
  ///
  /// In en, this message translates to:
  /// **'appetizers'**
  String get appetizers;

  /// No description provided for @starters.
  ///
  /// In en, this message translates to:
  /// **'starters'**
  String get starters;

  /// No description provided for @soups.
  ///
  /// In en, this message translates to:
  /// **'soups'**
  String get soups;

  /// No description provided for @mains.
  ///
  /// In en, this message translates to:
  /// **'mains'**
  String get mains;

  /// No description provided for @sides.
  ///
  /// In en, this message translates to:
  /// **'sides'**
  String get sides;

  /// No description provided for @desserts.
  ///
  /// In en, this message translates to:
  /// **'deserts'**
  String get desserts;

  /// No description provided for @basics.
  ///
  /// In en, this message translates to:
  /// **'basics'**
  String get basics;

  /// No description provided for @sauces.
  ///
  /// In en, this message translates to:
  /// **'sauces'**
  String get sauces;

  /// No description provided for @countryCode.
  ///
  /// In en, this message translates to:
  /// **'country code'**
  String get countryCode;

  /// No description provided for @chooseCountry.
  ///
  /// In en, this message translates to:
  /// **'Choose a country'**
  String get chooseCountry;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'country'**
  String get country;

  /// No description provided for @allCountries.
  ///
  /// In en, this message translates to:
  /// **'all countries'**
  String get allCountries;

  /// No description provided for @shoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping list'**
  String get shoppingList;

  /// No description provided for @pinch.
  ///
  /// In en, this message translates to:
  /// **'pinch'**
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
  /// **'bunch'**
  String get bunch;

  /// No description provided for @sprig.
  ///
  /// In en, this message translates to:
  /// **'sprig'**
  String get sprig;

  /// No description provided for @packet.
  ///
  /// In en, this message translates to:
  /// **'packet'**
  String get packet;

  /// No description provided for @leaf.
  ///
  /// In en, this message translates to:
  /// **'leaf'**
  String get leaf;

  /// No description provided for @cup.
  ///
  /// In en, this message translates to:
  /// **'cup'**
  String get cup;

  /// No description provided for @recipes.
  ///
  /// In en, this message translates to:
  /// **'recipes'**
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

  /// No description provided for @notImplementedYet.
  ///
  /// In en, this message translates to:
  /// **'Feature not yet available'**
  String get notImplementedYet;

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

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset filters'**
  String get resetFilters;

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

  /// No description provided for @timerUsage.
  ///
  /// In en, this message translates to:
  /// **'Tap to pause/resume, long press to stop the timer.'**
  String get timerUsage;

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
  /// **'You may have unsaved changes.'**
  String get unsavedChanges;

  /// No description provided for @importRecipe.
  ///
  /// In en, this message translates to:
  /// **'Import recipe'**
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
  /// **'You can search recipes by entering anything you filled when adding a recipe: name, source, notes, step instructions or ingredients name. For example, you can find chocolate mousse by searching for egg.'**
  String get tipSearch;

  /// No description provided for @tipShoppingList.
  ///
  /// In en, this message translates to:
  /// **'On a display recipe page, click the \'ingredients\' tab (or swipe left) to see the ingredients list.\nYou can add multiple recipes to the shopping list, and switch between them from the shopping list floating button (click on the recipe title).'**
  String get tipShoppingList;

  /// No description provided for @tipImport.
  ///
  /// In en, this message translates to:
  /// **'You can import a recipe by pasting the full URL from a supported website into the source field when editing a recipe.\nFor now, only www.marmiton.org is supported.'**
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
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
    case 'hu': return AppLocalizationsHu();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
