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
  String get insertStep => 'Köztes lépés beszúrása';

  @override
  String get moveToPreviousStep => 'Lépés előtti lépésre';

  @override
  String get moveToNextStep => 'Lépés a következő lépésre';

  @override
  String get calories => 'Kalória';

  @override
  String get carbohydrates => 'Szénhidrát';

  @override
  String get proteins => 'Proteinok';

  @override
  String get showCarbohydrates => 'Szénhidrát megjelenítése';

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
  String get videoUrl => 'Videó URL';

  @override
  String get source => 'Forrás';

  @override
  String get search => 'Keresés';

  @override
  String get servings => 'Adagok';

  @override
  String get usingRecipeServings => 'Recept alapértelmezett adagainak használata';

  @override
  String get usingAppServings => 'A profilban mentett adagok használata';

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
  String get noRecipe =>
      'Nincs elérhető recept.\nKérjük, hozzon létre egyet az alul található + gombbal.';

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
  String get breakfast => 'Reggeli';

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
  String get pinch => ' csipet';

  @override
  String get tsp => 'tk';

  @override
  String get tbsp => 'ek';

  @override
  String get bunch => ' csokor';

  @override
  String get sprig => ' ágacska';

  @override
  String get packet => ' csomag';

  @override
  String get leaf => ' levél';

  @override
  String get cup => ' csésze';

  @override
  String get slice => ' szelet';

  @override
  String get stick => ' rúd';

  @override
  String get handful => ' maréknyi';

  @override
  String get piece => ' darab';

  @override
  String get clove => ' gerezd';

  @override
  String get head => ' fej';

  @override
  String get stalk => ' szár';

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
  String get theme => 'Téma';

  @override
  String get themeSystem => 'Rendszer';

  @override
  String get themeLight => 'Világos';

  @override
  String get themeDark => 'Sötét';

  @override
  String get useMaterialYou => 'Material You használata';

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
  String get pauseUsage =>
      'Koppintson a szüneteltetéshez/folytatáshoz,\ntartsa hosszan lenyomva a leállításhoz.';

  @override
  String get noMatchingNutrient => 'Nincs megfelelő hozzávaló';

  @override
  String get leaveWithoutSaving => 'Kilépés mentés nélkül?';

  @override
  String get leave => 'Kilépés';

  @override
  String get unsavedChanges => 'Lehet, hogy nem mentett változtatásai vannak.';

  @override
  String get importRecipe => 'importálása';

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
  String get tipSearch =>
      'Recepteket kereshet bármilyen recept információ beírásával: recept neve, hozzávaló neve, jegyzetek, forrás vagy lépések leírása.\nPéldául, csokoládé mousse-t találhat \'mousse\', \'tojás\' vagy \'felver\' keresésével.';

  @override
  String get tipIngredients =>
      'A recept oldalon, érintse meg a \'Hozzávalók\' fület vagy húzza balra a képernyőt a hozzávalók listájának megtekintéséhez.';

  @override
  String get tipShoppingList =>
      'Amikor hozzáadja egy recept hozzávalóit a bevásárlólistához, a recept is mentésre kerül. Több receptből is hozzáadhat hozzávalókat, és elérheti az egyes recepteket a címükre kattintva a bevásárlólistában.';

  @override
  String get expertSettings => 'Haladó beállítások';

  @override
  String get tipImport =>
      'Importálhat receptet úgy, hogy beilleszti a teljes URL-t egy támogatott weboldalról a forrás mezőbe a recept szerkesztésekor.';

  @override
  String get tipNutritionalValues =>
      'Amikor szerkeszt egy hozzávalót a receptben, kiválaszthat egy megfelelő tápanyagot és szorzót. Ha mindkettőt kiválasztja, a tápértékek automatikusan kiszámításra és hozzáadásra kerülnek a recepthez!';

  @override
  String get gatherIngredients => 'Hozzávalók összegyűjtése';

  @override
  String get bowl => 'tál';

  @override
  String get pot => 'fazék';

  @override
  String get fridge => 'hűtőszekrény';

  @override
  String get freezer => 'fagyasztó';

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
  String get paddle => 'spatula';

  @override
  String get cut => 'vágódeszka';

  @override
  String get rollingPin => 'nyújtófa';

  @override
  String get editImage => 'Kép szerkesztése';

  @override
  String get clearSelections => 'Kijelölések törlése';

  @override
  String get processing => 'Feldolgozás folyamatban';

  @override
  String get rectangleInstructions =>
      'Fontos: Ha több oszlop van, jelölje ki a blokkokat!\n(ha csak egy oszlop van, hagyja figyelmen kívül és kattintson a \'Mentés\' gombra)';

  @override
  String get rectangleDetails =>
      'Sajnos a szövegfelismerés nem működik jól a többoszlopos elrendezéseknél. Át kell formáznunk a képet.\n\nElőször válassza ki a cím+hozzávalók blokkot, majd minden oszlopot.\nEzeket egy új képpé fogjuk egyesíteni.';

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
  String get chicken => 'csirke';

  @override
  String get coconut => 'kókuszdió';

  @override
  String get corn => 'kukorica';

  @override
  String get cucumber => 'uborka';

  @override
  String get chocolateDark => 'étcsokoládé';

  @override
  String get chocolateMilk => 'tejcsokoládé';

  @override
  String get chocolateRuby => 'rubincsokoládé';

  @override
  String get chocolateWhite => 'fehércsokoládé';

  @override
  String get dragonFruit => 'sárkánygyümölcs';

  @override
  String get egg => 'hús';

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
  String get lychee => 'licsi';

  @override
  String get mango => 'mangó';

  @override
  String get melon => 'dinnye';

  @override
  String get milk => 'tej';

  @override
  String get mushroom => 'gomba';

  @override
  String get oliveOil => 'olívaolaj';

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

  @override
  String get measurementSystem => 'Mértékegység rendszer';

  @override
  String get metric => 'Metrikus';

  @override
  String get us => 'Amerikai';

  @override
  String piecesPerServing(Object pieces_count) {
    return '$pieces_count darab adagonként';
  }

  @override
  String get makeAhead => 'Előkészítés és tárolás';

  @override
  String get preparation => 'előkészítés';

  @override
  String get cooking => 'sütés-főzés';

  @override
  String get rest => 'pihentetés';

  @override
  String get enableCookMode => 'Főzés mód';

  @override
  String get keepScreenOn => 'képernyő ébren tartása (alvó mód megakadályozása)';

  @override
  String get disableCookMode => 'Főzés mód kikapcsolása';

  @override
  String get optional => 'opcionális';

  @override
  String get export => 'exportálása';

  @override
  String get generatingPdf => 'PDF generálása...';

  @override
  String get questions => 'Kérdések';

  @override
  String get searchRecipesOnline => 'Online keresés';

  @override
  String get selectSitesToSearch => 'Receptoldalak kiválasztása';

  @override
  String get tryAgain => 'Próbálja újra';

  @override
  String get searchForOnlineRecipes => 'Receptek keresése importáláshoz';

  @override
  String get recipeImportedSuccessfully => 'A recept sikeresen importálva!';

  @override
  String get importFailed => 'Nem sikerült importálni a receptet';

  @override
  String get selectAll => 'Összes oldal';

  @override
  String get deselectAll => 'Nincs';

  @override
  String get speak => 'Recept felolvasása';

  @override
  String get enterValidServings => 'Kérjük, egész számot adjon meg';

  @override
  String get about => 'Névjegy';

  @override
  String get contact => 'Kapcsolat';

  @override
  String get author => 'Szerző';

  @override
  String get sourceCodeAvailableAt =>
      'Kiadva GNU General Public License v3.0 alatt. Az alkalmazás forráskódja elérhető itt:';

  @override
  String get nutrition => 'Tápérték';

  @override
  String get nutritionFacts => 'Tápértékek';

  @override
  String get servingSize => 'Adagméret';

  @override
  String get serving => 'adag';

  @override
  String get servingsPerRecipe => 'Adagok receptenként';

  @override
  String get dailyValue => 'Napi érték';

  @override
  String get totalFat => 'Összes zsír';

  @override
  String get nutritionCalculatedNote =>
      'A tápértékek a kapcsolt összetevőkből kerültek kiszámításra';

  @override
  String get nutritionImportedNote => 'A tápértékek az importált recept adataiból származnak';

  @override
  String get dailyValueDisclaimer => 'A napi érték százalékai 2000 kalóriás étren-den alapulnak.';

  @override
  String get amountPerServing => 'Adagonkénti mennyiség';

  @override
  String get saturatedFat => 'Telített zsír';

  @override
  String get transFat => 'Transzzsír';

  @override
  String get cholesterol => 'Koleszterin';

  @override
  String get sodium => 'Nátrium';

  @override
  String get dietaryFiber => 'Élelmi rost';

  @override
  String get totalSugars => 'Összes cukor';

  @override
  String get addedSugars => 'Hozzáadott cukor';

  @override
  String get vitaminD => 'D-vitamin';

  @override
  String get calcium => 'Kalcium';

  @override
  String get iron => 'Vas';

  @override
  String get potassium => 'Kálium';
}
