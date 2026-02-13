// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get hello => 'こんにちは';

  @override
  String get areYouSure => '本当に宜しいですか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get add => '追加';

  @override
  String get addRecipe => 'レシピを追加';

  @override
  String get addStep => '手順を追加';

  @override
  String get insertStep => '中間手順を追加';

  @override
  String get moveToPreviousStep => '前の手順に戻る';

  @override
  String get moveToNextStep => '次の手順へ進む';

  @override
  String get calories => 'カロリー';

  @override
  String get carbohydrates => '炭水化物';

  @override
  String get proteins => 'タンパク質';

  @override
  String get showCarbohydrates => '炭水化物を表示';

  @override
  String get kcps => 'kcal/人前';

  @override
  String get kc => 'kcal';

  @override
  String get gps => 'グラム/人前';

  @override
  String get g => 'グラム';

  @override
  String get editRecipe => 'レシピを編集';

  @override
  String get editStep => '手順を編集';

  @override
  String get newRecipe => '新しいレシピ';

  @override
  String get ingredients => '材料';

  @override
  String get instructions => '作り方';

  @override
  String get step => '手順';

  @override
  String get steps => '手順';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get deleteRecipe => 'レシピを削除';

  @override
  String get title => 'タイトル';

  @override
  String get timer => 'タイマー';

  @override
  String get min => '分';

  @override
  String get name => '名前';

  @override
  String get unit => '単位';

  @override
  String get quantity => '量';

  @override
  String get direction => '指示';

  @override
  String get pickImage => '画像を選択';

  @override
  String get addImage => '画像を追加';

  @override
  String get changeImage => '画像を変更';

  @override
  String get videoUrl => '動画URL';

  @override
  String get source => '出典';

  @override
  String get search => '検索';

  @override
  String get servings => '分量';

  @override
  String get usingRecipeServings => 'レシピのデフォルト分量を使用';

  @override
  String get usingAppServings => 'プロフィールに保存された分量を使用';

  @override
  String get month => '月';

  @override
  String get shape => '形';

  @override
  String get notes => 'メモ';

  @override
  String enterTextFor(Object field) {
    return '$fieldの入力をしてください';
  }

  @override
  String get noRecipe => '+ ボタンを押して、\n新しいレシピを作成してください。';

  @override
  String get noStepsAddedYet => 'まだ手順を追加していません。';

  @override
  String get category => 'カテゴリー';

  @override
  String get all => 'すべて';

  @override
  String get snacks => 'スナック';

  @override
  String get cocktails => 'カクテル';

  @override
  String get drinks => 'ドリンク';

  @override
  String get appetizers => '前菜';

  @override
  String get starters => 'スターター';

  @override
  String get soups => 'スープ';

  @override
  String get mains => 'メイン';

  @override
  String get sides => 'サイド';

  @override
  String get desserts => 'デザート';

  @override
  String get basics => '基本';

  @override
  String get sauces => 'ソース';

  @override
  String get breakfast => '朝食';

  @override
  String get countryCode => '国コード';

  @override
  String get chooseCountry => '国を選択';

  @override
  String get country => '国';

  @override
  String get allCountries => '全ての国';

  @override
  String get shoppingList => '買い物リスト';

  @override
  String get pinch => 'ひとつまみ';

  @override
  String get tsp => '小さじ';

  @override
  String get tbsp => '大さじ';

  @override
  String get bunch => '束';

  @override
  String get sprig => '小枝';

  @override
  String get packet => 'パック';

  @override
  String get leaf => '葉';

  @override
  String get cup => 'カップ';

  @override
  String get slice => '切れ';

  @override
  String get stick => '本';

  @override
  String get handful => '握り';

  @override
  String get piece => ' 個';

  @override
  String get clove => ' 片';

  @override
  String get head => ' 頭';

  @override
  String get stalk => ' 茎';

  @override
  String get recipes => 'レシピ';

  @override
  String get scrollToTop => 'トップに戻る';

  @override
  String get saveError => '保存エラー';

  @override
  String get selectNutrient => '栄養素を選択';

  @override
  String get selectFactor => '係数を選択';

  @override
  String get noIngredientsForStep => 'この手順では材料はありません';

  @override
  String get titleCannotBeEmpty => 'タイトルは空にできません';

  @override
  String get notImplementedYet => '機能はまだ利用できません';

  @override
  String get start => '開始';

  @override
  String get language => '言語';

  @override
  String get theme => 'テーマ';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get gender => '性別';

  @override
  String get male => '男性';

  @override
  String get female => '女性';

  @override
  String get other => 'その他';

  @override
  String get profileSettings => 'プロフィール設定';

  @override
  String get dietaryRestrictions => '食品制限';

  @override
  String get vegan => 'ビーガン';

  @override
  String get vegetarian => '素食者';

  @override
  String get glutenFree => '無糖';

  @override
  String get close => '閉じる';

  @override
  String searchXRecipes(Object count) {
    return '$count件のレシピを検索。。。';
  }

  @override
  String get resetFilters => 'リセット';

  @override
  String get addIngredient => '材料を追加';

  @override
  String get minutes => '分';

  @override
  String get hours => '時間';

  @override
  String get minutes_abbreviation => '分';

  @override
  String get hours_abbreviation => '時間';

  @override
  String get pauseUsage => 'タップすると一時停止/再開し、\n長押しすると停止します。';

  @override
  String get noMatchingNutrient => '該当する栄養素が見つかりませんでした';

  @override
  String get leaveWithoutSaving => '保存せずに終了しますか？';

  @override
  String get leave => '終了';

  @override
  String get unsavedChanges => '保存されていない変更があるかもしれません。';

  @override
  String get importRecipe => 'インポート';

  @override
  String importRecipeConfirmation(Object url) {
    return '$urlからレシピをインポートしますか？この場合、現在のタイトル、手順、画像が上書きされます。';
  }

  @override
  String get scrapeError => 'URLからレシピデータの取得に失敗しました。';

  @override
  String get checkIngredientsYouHave => 'すでに持っている材料をチェック:';

  @override
  String get addAllToShoppingList => 'すべての材料を\n買い物リストに追加';

  @override
  String get addMissingToShoppingList => '足りない材料を\n買い物リストに追加';

  @override
  String get shoppingListEmpty => '買い物リストは空です。';

  @override
  String get clearList => '買い物リストをクリア';

  @override
  String get remove => '削除';

  @override
  String get itemsAddedToShoppingList => 'リストに追加されたアイテム';

  @override
  String get tips => 'ヒント';

  @override
  String get tipSearch =>
      'レシピは、レシピ名、材料名、メモ、出典、または手順などの情報を入力することで検索できます。\n例えば、「ムース」、「卵」、「泡立てる」などで検索してチョコレートムースを見つけることができます。';

  @override
  String get tipIngredients => 'レシピページでは、「材料」タブをタップするか、左にスワイプして材料リストを表示できます。';

  @override
  String get tipShoppingList =>
      'レシピから買い物リストに材料を追加すると、レシピも保存されます。複数のレシピから材料を追加でき、買い物リストでレシピタイトルをタップすることでそれぞれのレシピにアクセスできます。';

  @override
  String get tipImport => 'レシピの編集時に出典フィールドに対応ウェブサイトの完全なURLを貼り付けることで、レシピをインポートできます。';

  @override
  String get tipNutritionalValues =>
      'レシピの材料を編集する際、対応する栄養素と係数を選択できます。両方を選択すると、栄養価が自動的に計算されレシピに追加されます！';

  @override
  String get gatherIngredients => '材料を収集';

  @override
  String get bowl => 'ボウル';

  @override
  String get pot => '鍋';

  @override
  String get fridge => '冷蔵庫';

  @override
  String get freezer => '冷凍庫';

  @override
  String get oven => 'オーブン';

  @override
  String get microwave => '電子レンジ';

  @override
  String get blender => 'ブレンダー';

  @override
  String get mixer => 'ミキサー';

  @override
  String get whisk => '泡立て';

  @override
  String get skillet => 'フライパン';

  @override
  String get paddle => 'ヘラ';

  @override
  String get cut => '切る';

  @override
  String get rollingPin => 'めん棒';

  @override
  String get editImage => '画像を編集';

  @override
  String get clearSelections => '選択をクリア';

  @override
  String get processing => '処理中';

  @override
  String get rectangleInstructions =>
      '重要：複数の列がある場合は、ブロックを選択してください！\n（一列だけの場合は、無視して「保存」をクリックしてください）';

  @override
  String get rectangleDetails =>
      '残念ながら、複数列のレイアウトではテキスト認識がうまく機能しません。画像を再フォーマットする必要があります。\n\nまずタイトル+材料のブロックを選択し、次に各列を選択してください。\nこれらは新しい画像に統合されます。';

  @override
  String get apple => 'リンゴ';

  @override
  String get apricot => 'アプリコット';

  @override
  String get asparagus => 'アスパラガス';

  @override
  String get avocado => 'アボカド';

  @override
  String get banana => 'バナナ';

  @override
  String get bellPepper => 'ピーマン';

  @override
  String get blackberry => 'ブラックベリー';

  @override
  String get blueberry => 'ブルーベリー';

  @override
  String get broccoli => 'ブロッコリー';

  @override
  String get butter => 'バター';

  @override
  String get cabbage => 'キャベツ';

  @override
  String get carambola => 'スターフルーツ';

  @override
  String get carrot => 'ニンジン';

  @override
  String get cauliflower => 'カリフラワー';

  @override
  String get celery => 'セロリ';

  @override
  String get cherry => 'さくらんぼ';

  @override
  String get chicken => '鶏肉';

  @override
  String get coconut => 'ココナッツ';

  @override
  String get corn => 'トウモロコシ';

  @override
  String get cucumber => 'キュウリ';

  @override
  String get chocolateDark => 'ダークチョコレート';

  @override
  String get chocolateMilk => 'ミルクチョコレート';

  @override
  String get chocolateRuby => 'ルビーチョコレート';

  @override
  String get chocolateWhite => 'ホワイトチョコレート';

  @override
  String get dragonFruit => 'ドラゴンフルーツ';

  @override
  String get egg => '卵';

  @override
  String get eggplant => 'ナス';

  @override
  String get fig => 'イチジク';

  @override
  String get garlic => 'ニンニク';

  @override
  String get grapes => 'ブドウ';

  @override
  String get greenBean => 'インゲン';

  @override
  String get kiwi => 'キウイ';

  @override
  String get leek => 'リーク';

  @override
  String get lemon => 'レモン';

  @override
  String get lettuce => 'レタス';

  @override
  String get lime => 'ライム';

  @override
  String get lychee => 'ライチ';

  @override
  String get mango => 'マンゴー';

  @override
  String get melon => 'メロン';

  @override
  String get milk => '牛乳';

  @override
  String get mushroom => 'キノコ';

  @override
  String get oliveOil => 'オリーブ油';

  @override
  String get onion => '玉ねぎ';

  @override
  String get orange => 'オレンジ';

  @override
  String get peach => '桃';

  @override
  String get pear => '梨';

  @override
  String get peas => 'エンドウ豆';

  @override
  String get pineapple => 'パイナップル';

  @override
  String get plum => 'プラム';

  @override
  String get pomegranate => 'ザクロ';

  @override
  String get potato => 'ジャガイモ';

  @override
  String get pumpkin => 'カボチャ';

  @override
  String get radish => '大根';

  @override
  String get raspberry => 'ラズベリー';

  @override
  String get salmon => '鮭';

  @override
  String get spinach => 'ほうれん草';

  @override
  String get strawberry => 'イチゴ';

  @override
  String get sweetPotato => 'サツマイモ';

  @override
  String get tomato => 'トマト';

  @override
  String get watermelon => 'スイカ';

  @override
  String get zucchini => 'ズッキーニ';

  @override
  String get measurementSystem => '計量単位';

  @override
  String get metric => 'メートル法';

  @override
  String get us => '米国単位';

  @override
  String piecesPerServing(Object pieces_count) {
    return '$pieces_count個/人前';
  }

  @override
  String get makeAhead => '事前準備と保存';

  @override
  String get preparation => '準備';

  @override
  String get cooking => '調理';

  @override
  String get rest => '休';

  @override
  String get enableCookMode => 'クッキングモード';

  @override
  String get keepScreenOn => '画面をオンのままにする（スリープモードを防止）';

  @override
  String get disableCookMode => 'クッキングモードを終了';

  @override
  String get optional => 'オプション';

  @override
  String get export => 'エクスポート';

  @override
  String get generatingPdf => 'PDFを生成しています...';

  @override
  String get questions => '質問';

  @override
  String get searchRecipesOnline => 'オンラインで検索';

  @override
  String get selectSitesToSearch => 'レシピサイトを選択';

  @override
  String get tryAgain => 'もう一度試す';

  @override
  String get searchForOnlineRecipes => 'インポートするレシピを検索';

  @override
  String get recipeImportedSuccessfully => 'レシピが正常にインポートされました！';

  @override
  String get importFailed => 'レシピのインポートに失敗しました';

  @override
  String get selectAll => 'すべてのサイト';

  @override
  String get deselectAll => 'なし';

  @override
  String get speak => 'レシピを話しかけ';

  @override
  String get enterValidServings => '整数を入力してください';

  @override
  String get about => 'アプリ情報';

  @override
  String get contact => '連絡先';

  @override
  String get author => '作者';

  @override
  String get sourceCodeAvailableAt =>
      'GNU General Public License v3.0の下で公開されています。アプリケーションのソースコードは以下のURLで入手できます';

  @override
  String get nutrition => '栄養成分';

  @override
  String get nutritionFacts => '栄養成分表示';

  @override
  String get servingSize => '1食分の量';

  @override
  String get serving => '人前';

  @override
  String get servingsPerRecipe => 'レシピあたりの分量';

  @override
  String get dailyValue => '1日の摂取基準';

  @override
  String get totalFat => '脂質';

  @override
  String get nutritionCalculatedNote => '栄養価はリンクされた材料から計算されています';

  @override
  String get nutritionImportedNote => '栄養価はインポートされたレシピデータから取得されています';

  @override
  String get dailyValueDisclaimer => '1日の摂取基準のパーセンテージは2,000カロリーの食事に基づいています。';

  @override
  String get amountPerServing => '人前の量';

  @override
  String get saturatedFat => '飽和脂肪酸';

  @override
  String get transFat => 'トランス脂肪酸';

  @override
  String get cholesterol => 'コレステロール';

  @override
  String get sodium => 'ナトリウム';

  @override
  String get dietaryFiber => '食物繊維';

  @override
  String get totalSugars => '糖質';

  @override
  String get addedSugars => '追加糖';

  @override
  String get vitaminD => 'ビタミンD';

  @override
  String get calcium => 'カルシウム';

  @override
  String get iron => '鉄';

  @override
  String get potassium => 'カリウム';
}
