// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get hello => 'Bonjour';

  @override
  String get areYouSure => 'Êtes-vous sûr ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get add => 'Ajouter';

  @override
  String get addRecipe => 'Ajouter une recette';

  @override
  String get addStep => 'Ajouter une étape';

  @override
  String get calories => 'Calories';

  @override
  String get carbohydrates => 'Glucides';

  @override
  String get kcps => 'Kcal/part';

  @override
  String get kc => 'Kcal';

  @override
  String get gps => 'g/part';

  @override
  String get g => 'g';

  @override
  String get editRecipe => 'Modifier la recette';

  @override
  String get editStep => 'Modifier l\'étape';

  @override
  String get newRecipe => 'Nouvelle recette';

  @override
  String get ingredients => 'Ingrédients';

  @override
  String get instructions => 'Instructions';

  @override
  String get step => 'Étape';

  @override
  String get steps => 'Étapes';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteRecipe => 'Supprimer la recette';

  @override
  String get title => 'Titre';

  @override
  String get timer => 'Durée';

  @override
  String get min => 'min';

  @override
  String get name => 'Nom';

  @override
  String get unit => 'Unité';

  @override
  String get quantity => 'Quantité';

  @override
  String get direction => 'Préparation';

  @override
  String get pickImage => 'Sélectionner une image';

  @override
  String get source => 'Source';

  @override
  String get search => 'Recherche';

  @override
  String get servings => 'Parts';

  @override
  String get month => 'Mois';

  @override
  String get shape => 'Forme';

  @override
  String get notes => 'Notes';

  @override
  String enterTextFor(Object field) {
    return 'Merci de renseigner le champ $field';
  }

  @override
  String get noRecipe => 'Aucune recette disponible. Veuillez en créer une avec le bouton + en bas.';

  @override
  String get noStepsAddedYet => 'Aucune étape ajoutée.';

  @override
  String get category => 'Catégorie';

  @override
  String get all => 'Tout';

  @override
  String get snacks => 'Collations';

  @override
  String get cocktails => 'Cocktails';

  @override
  String get drinks => 'Boissons';

  @override
  String get appetizers => 'Amuse-bouches';

  @override
  String get starters => 'Entrées';

  @override
  String get soups => 'Soupes';

  @override
  String get mains => 'Plats';

  @override
  String get sides => 'Accompagnements';

  @override
  String get desserts => 'Desserts';

  @override
  String get basics => 'Bases';

  @override
  String get sauces => 'Sauces';

  @override
  String get countryCode => 'Code pays';

  @override
  String get chooseCountry => 'Choisir un pays';

  @override
  String get country => 'Pays';

  @override
  String get allCountries => 'Tous les pays';

  @override
  String get shoppingList => 'Liste de courses';

  @override
  String get pinch => 'Pincée';

  @override
  String get tsp => 'cc';

  @override
  String get tbsp => 'cs';

  @override
  String get bunch => 'bouquet';

  @override
  String get sprig => 'brin';

  @override
  String get packet => 'sachet';

  @override
  String get leaf => 'feuille';

  @override
  String get cup => 'verre';

  @override
  String get recipes => 'Recettes';

  @override
  String get scrollToTop => 'Remonter en haut';

  @override
  String get saveError => 'Erreur d\'enregistrement';

  @override
  String get selectNutrient => 'Sélectionnez un ingredient';

  @override
  String get noIngredientsForStep => 'Aucun ingrédient dans cette étape';

  @override
  String get titleCannotBeEmpty => 'Le titre ne peut pas être vide';

  @override
  String get notImplementedYet => 'Fonctionnalité non disponible';

  @override
  String get start => 'Démarrer';

  @override
  String get language => 'Langue';

  @override
  String get gender => 'Genre';

  @override
  String get male => 'Homme';

  @override
  String get female => 'Femme';

  @override
  String get other => 'Autre';

  @override
  String get profileSettings => 'Paramètres de profil';

  @override
  String get dietaryRestrictions => 'Restrictions alimentaires';

  @override
  String get vegan => 'Vegan';

  @override
  String get vegetarian => 'Végétarien';

  @override
  String get glutenFree => 'Sans gluten';

  @override
  String get close => 'Fermer';

  @override
  String searchXRecipes(Object count) {
    return 'Rechercher parmi $count recettes...';
  }

  @override
  String get resetFilters => 'Reinitialiser';

  @override
  String get addIngredient => 'Ajouter un ingrédient';

  @override
  String get minutes => 'minutes';

  @override
  String get hours => 'heures';

  @override
  String get timerUsage => 'Appuyez pour mettre en pause/reprendre, Faites un appui long pour arrêter le minuteur.';

  @override
  String get noMatchingNutrient => 'Aucun ingrédient correspondant trouvé';

  @override
  String get leaveWithoutSaving => 'Quitter sans enregistrer ?';

  @override
  String get leave => 'Quitter';

  @override
  String get unsavedChanges => 'Vous avez des changements non enregistrés.';

  @override
  String get importRecipe => 'Importer la recette';

  @override
  String importRecipeConfirmation(Object url) {
    return 'Voulez-vous importer la recette depuis $url? Cela écrasera le titre, les étapes et l\'image.';
  }

  @override
  String get scrapeError => 'Echec d\'importation de la recette depuis l\'URL.';
}
