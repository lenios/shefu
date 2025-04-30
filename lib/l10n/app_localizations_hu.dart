// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get hello => 'Szia';

  @override
  String get areYouSure => 'Biztos vagy benne?';

  @override
  String get cancel => 'Mégse';

  @override
  String get add => 'Hozzáadás';

  @override
  String get addRecipe => 'Recept hozzáadása';

  @override
  String get addStep => 'Lépés hozzáadása';

  @override
  String get calories => 'Kalória';

  @override
  String get carbohydrates => 'Szénhidrát';

  @override
  String get kcps => 'Kcal/adag';

  @override
  String get kc => 'Kcal';

  @override
  String get gps => 'g/adag';

  @override
  String get g => 'g';

  @override
  String get editRecipe => 'Recept szerkesztése';

  @override
  String get editStep => 'Lépés szerkesztése';

  @override
  String get newRecipe => 'Új recept';

  @override
  String get ingredients => 'Hozzávalók';

  @override
  String get instructions => 'Utasítások';

  @override
  String get step => 'Lépés';

  @override
  String get steps => 'Lépések';

  @override
  String get save => 'Mentés';

  @override
  String get delete => 'Törlés';

  @override
  String get deleteRecipe => 'Recept törlése';

  @override
  String get title => 'Cím';

  @override
  String get timer => 'Időzítő';

  @override
  String get min => 'perc';

  @override
  String get name => 'Név';

  @override
  String get unit => 'Egység';

  @override
  String get quantity => 'Mennyiség';

  @override
  String get direction => 'Elkészítés';

  @override
  String get pickImage => 'Kép kiválasztása';

  @override
  String get source => 'Forrás';

  @override
  String get search => 'Keresés';

  @override
  String get servings => 'Adagok';

  @override
  String get month => 'Hónap';

  @override
  String get shape => 'Forma';

  @override
  String get notes => 'Jegyzetek';

  @override
  String enterTextFor(Object field) {
    return 'Kérjük, töltse ki a(z) $field mezőt';
  }

  @override
  String get noRecipe => 'Nincs elérhető recept. Kérjük, hozzon létre egyet az alul található + gombbal.';

  @override
  String get noStepsAddedYet => 'Még nincsenek lépések hozzáadva.';

  @override
  String get category => 'Kategória';

  @override
  String get all => 'Mind';

  @override
  String get snacks => 'Rágcsálnivalók';

  @override
  String get cocktails => 'Koktélok';

  @override
  String get drinks => 'Italok';

  @override
  String get appetizers => 'Előételek';

  @override
  String get starters => 'Kezdőételek';

  @override
  String get soups => 'Levesek';

  @override
  String get mains => 'Főételek';

  @override
  String get sides => 'Köretek';

  @override
  String get desserts => 'Desszertek';

  @override
  String get basics => 'Alapok';

  @override
  String get sauces => 'Szószok';

  @override
  String get countryCode => 'Országkód';

  @override
  String get chooseCountry => 'Ország kiválasztása';

  @override
  String get country => 'Ország';

  @override
  String get allCountries => 'Minden ország';

  @override
  String get shoppingList => 'Bevásárlólista';

  @override
  String get pinch => 'Csipet';

  @override
  String get tsp => 'tk';

  @override
  String get tbsp => 'ek';

  @override
  String get bunch => 'csokor';

  @override
  String get sprig => 'ágacska';

  @override
  String get packet => 'csomag';

  @override
  String get leaf => 'levél';

  @override
  String get cup => 'csésze';

  @override
  String get recipes => 'Receptek';

  @override
  String get scrollToTop => 'Görgessen a tetejére';

  @override
  String get saveError => 'Mentési hiba';

  @override
  String get selectNutrient => 'Válasszon hozzávalót';

  @override
  String get noIngredientsForStep => 'Nincs hozzávaló ebben a lépésben';

  @override
  String get titleCannotBeEmpty => 'A cím nem lehet üres';

  @override
  String get notImplementedYet => 'Funkció még nem elérhető';

  @override
  String get start => 'Indítás';

  @override
  String get language => 'Nyelv';

  @override
  String get gender => 'Nem';

  @override
  String get male => 'Férfi';

  @override
  String get female => 'Nő';

  @override
  String get other => 'Egyéb';

  @override
  String get profileSettings => 'Profilbeállítások';

  @override
  String get dietaryRestrictions => 'Étkezési korlátozások';

  @override
  String get vegan => 'Vegán';

  @override
  String get vegetarian => 'Vegetáriánus';

  @override
  String get glutenFree => 'Gluténmentes';

  @override
  String get close => 'Bezárás';

  @override
  String searchXRecipes(Object count) {
    return 'Keresés $count recept között...';
  }

  @override
  String get resetFilters => 'Szűrők visszaállítása';

  @override
  String get addIngredient => 'Hozzávaló hozzáadása';

  @override
  String get minutes => 'perc';

  @override
  String get hours => 'óra';

  @override
  String get timerUsage => 'Érintse meg a szüneteltetéshez/folytatáshoz, tartsa lenyomva az időzítő leállításához.';

  @override
  String get noMatchingNutrient => 'Nincs megfelelő hozzávaló';

  @override
  String get leaveWithoutSaving => 'Kilépés mentés nélkül?';

  @override
  String get leave => 'Kilépés';

  @override
  String get unsavedChanges => 'Lehet, hogy nem mentett változtatásai vannak.';

  @override
  String get importRecipe => 'Recept importálása';

  @override
  String importRecipeConfirmation(Object url) {
    return 'Szeretné importálni a receptet az $url? Ez felülírja a címet, a lépéseket és a képet.';
  }

  @override
  String get scrapeError => 'Nem sikerült importálni a receptet az URL-ről.';
}
