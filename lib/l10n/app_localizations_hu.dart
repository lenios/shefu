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
  String get addImage => 'Kép hozzáadása';

  @override
  String get changeImage => 'Kép megváltoztatása';

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
  String get noRecipe => 'Nincs elérhető recept.\nKérjük, hozzon létre egyet az alul található + gombbal.';

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
  String get slice => 'szelet';

  @override
  String get stick => 'rúd';

  @override
  String get handful => 'maréknyi';

  @override
  String get recipes => 'Receptek';

  @override
  String get scrollToTop => 'Görgessen a tetejére';

  @override
  String get saveError => 'Mentési hiba';

  @override
  String get selectNutrient => 'Válasszon hozzávalót';

  @override
  String get selectFactor => 'Válasszon egyxefaktorot';

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
  String get minutes_abbreviation => 'perc';

  @override
  String get hours_abbreviation => 'óra';

  @override
  String get timerUsage => 'Érintse meg a szüneteltetéshez/folytatáshoz,\ntartsa lenyomva az időzítő leállításához.';

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

  @override
  String get checkIngredientsYouHave => 'Jelölje be a már meglévő hozzávalókat:';

  @override
  String get addAllToShoppingList => 'Összes hozzávaló hozzáadása\n a bevásárlólistához';

  @override
  String get addMissingToShoppingList => 'Hiányzó hozzávalók hozzáadása\n a bevásárlólistához';

  @override
  String get shoppingListEmpty => 'A bevásárlólista üres.';

  @override
  String get clearList => 'Lista ürítése';

  @override
  String get remove => 'Eltávolítás';

  @override
  String get itemsAddedToShoppingList => 'Elemek hozzáadva a bevásárlólistához';

  @override
  String get tips => 'Tippek';

  @override
  String get tipSearch => 'Recepteket kereshet bármilyen recept információ beírásával: recept neve, hozzávaló neve, jegyzetek, forrás vagy lépések leírása.\nPéldául, csokoládé mousse-t találhat \'mousse\', \'tojás\' vagy \'felver\' keresésével.';

  @override
  String get tipIngredients => 'A recept oldalon, érintse meg a \'Hozzávalók\' fület vagy húzza balra a képernyőt a hozzávalók listájának megtekintéséhez.';

  @override
  String get tipShoppingList => 'Amikor hozzáadja egy recept hozzávalóit a bevásárlólistához, a recept is mentésre kerül. Több receptből is hozzáadhat hozzávalókat, és elérheti az egyes recepteket a címükre kattintva a bevásárlólistában.';

  @override
  String get tipImport => 'Importálhat receptet úgy, hogy beilleszti a teljes URL-t egy támogatott weboldalról a forrás mezőbe a recept szerkesztésekor.\nJelenleg csak a www.marmiton.org támogatott.';

  @override
  String get tipNutritionalValues => 'Amikor szerkeszt egy hozzávalót a receptben, kiválaszthat egy megfelelő tápanyagot és szorzót. Ha mindkettőt kiválasztja, a tápértékek automatikusan kiszámításra és hozzáadásra kerülnek a recepthez!';

  @override
  String get gatherIngredients => 'Hozzávalók összegyűjtése';

  @override
  String get bowl => 'tál';

  @override
  String get pot => 'fazék';

  @override
  String get oven => 'sütő';

  @override
  String get microwave => 'mikró';

  @override
  String get blender => 'turmixgép';

  @override
  String get mixer => 'mixer';

  @override
  String get whisk => 'habverő';

  @override
  String get skillet => 'serpenyő';

  @override
  String get editImage => 'Kép szerkesztése';

  @override
  String get clearSelections => 'Kijelölések törlése';

  @override
  String get processing => 'Feldolgozás folyamatban';

  @override
  String get rectangleInstructions => 'Fontos: Ha több oszlop van, jelölje ki a blokkokat!\n(ha csak egy oszlop van, hagyja figyelmen kívül és kattintson a \'Mentés\' gombra)';

  @override
  String get rectangleDetails => 'Sajnos a szövegfelismerés nem működik jól a többoszlopos elrendezéseknél. Át kell formáznunk a képet.\n\nElőször válassza ki a cím+hozzávalók blokkot, majd minden oszlopot.\nEzeket egy új képpé fogjuk egyesíteni.';

  @override
  String get apple => 'alma';

  @override
  String get apricot => 'sárgabarack';

  @override
  String get asparagus => 'spárga';

  @override
  String get avocado => 'avokádó';

  @override
  String get banana => 'banán';

  @override
  String get bellPepper => 'kaliforniai paprika';

  @override
  String get blackberry => 'szeder';

  @override
  String get blueberry => 'áfonya';

  @override
  String get broccoli => 'brokkoli';

  @override
  String get butter => 'vaj';

  @override
  String get cabbage => 'káposzta';

  @override
  String get carambola => 'csillaggyümölcs';

  @override
  String get carrot => 'répa';

  @override
  String get cauliflower => 'karfiol';

  @override
  String get celery => 'zeller';

  @override
  String get cherry => 'cseresznye';

  @override
  String get coconut => 'kókuszdió';

  @override
  String get corn => 'kukorica';

  @override
  String get cucumber => 'uborka';

  @override
  String get dragonFruit => 'sárkánygyümölcs';

  @override
  String get eggplant => 'padlizsán';

  @override
  String get fig => 'füge';

  @override
  String get garlic => 'fokhagyma';

  @override
  String get grapes => 'szőlő';

  @override
  String get greenBean => 'zöldbab';

  @override
  String get kiwi => 'kiwi';

  @override
  String get leek => 'póréhagyma';

  @override
  String get lemon => 'citrom';

  @override
  String get lettuce => 'saláta';

  @override
  String get lime => 'lime';

  @override
  String get litchi => 'licsi';

  @override
  String get mango => 'mangó';

  @override
  String get melon => 'dinnye';

  @override
  String get mushroom => 'gomba';

  @override
  String get onion => 'hagyma';

  @override
  String get orange => 'narancs';

  @override
  String get peach => 'őszibarack';

  @override
  String get pear => 'körte';

  @override
  String get peas => 'borsó';

  @override
  String get pineapple => 'ananász';

  @override
  String get plum => 'szilva';

  @override
  String get pomegranate => 'gránátalma';

  @override
  String get potato => 'burgonya';

  @override
  String get pumpkin => 'tök';

  @override
  String get radish => 'retek';

  @override
  String get raspberry => 'málna';

  @override
  String get salmon => 'lazac';

  @override
  String get spinach => 'spenót';

  @override
  String get strawberry => 'eper';

  @override
  String get sweetPotato => 'édesburgonya';

  @override
  String get tomato => 'paradicsom';

  @override
  String get watermelon => 'görögdinnye';

  @override
  String get zucchini => 'cukkini';
}
