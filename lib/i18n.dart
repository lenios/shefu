import 'package:get/get.dart';

class I18n extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello',
          'add recipe': 'Add recipe',
          'save': 'Save',
          'title': 'Title',
          'source': 'Source',

        },
        'fr_FR': {
          'hello': 'Bonjour',
          'add recipe': 'Ajouter recette',
          'save': 'Enregistrer',
          'title': 'Titre',
          'source': 'Source',

        },
        //defaults to en_US when missing translations!
        'ja_JP': {
          'hello': 'こんにちは',
          'add recipe': 'レシピを入力',
          'save': '保存する',
        }
      };
}
