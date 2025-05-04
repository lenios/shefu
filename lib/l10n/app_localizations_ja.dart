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
  String get calories => 'カロリー';

  @override
  String get carbohydrates => '炭水化物';

  @override
  String get kcps => 'kcal/人';

  @override
  String get kc => 'kcal';

  @override
  String get gps => 'グラム/人';

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
  String get source => '出典';

  @override
  String get search => '検索';

  @override
  String get servings => '分量';

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
  String get timerUsage => 'タップすると一時停止/再開し、長押しするとタイマーを停止します。';

  @override
  String get noMatchingNutrient => '該当する栄養素が見つかりませんでした';

  @override
  String get leaveWithoutSaving => '保存せずに終了しますか？';

  @override
  String get leave => '終了';

  @override
  String get unsavedChanges => '保存されていない変更があるかもしれません。';

  @override
  String get importRecipe => 'レシピをインポート';

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
  String get tipSearch => 'レシピは、レシピ名、材料名、メモ、出典、または手順などの情報を入力することで検索できます。\n例えば、「ムース」、「卵」、「泡立てる」などで検索してチョコレートムースを見つけることができます。';

  @override
  String get tipIngredients => 'レシピページでは、「材料」タブをタップするか、左にスワイプして材料リストを表示できます。';

  @override
  String get tipShoppingList => 'レシピから買い物リストに材料を追加すると、レシピも保存されます。複数のレシピから材料を追加でき、買い物リストでレシピタイトルをタップすることでそれぞれのレシピにアクセスできます。';

  @override
  String get tipImport => 'レシピの編集時に出典フィールドに対応ウェブサイトの完全なURLを貼り付けることで、レシピをインポートできます。\n現在は、www.marmiton.orgのみ対応しています。';

  @override
  String get tipNutritionalValues => 'レシピの材料を編集する際、対応する栄養素と係数を選択できます。両方を選択すると、栄養価が自動的に計算されレシピに追加されます！';

  @override
  String get gatherIngredients => '材料を収集';
}
