import 'package:get/get.dart';

class I18n extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello',
          'add recipe': 'Add recipe',
          'save': 'Save',
          'title': 'Title',
          'pick image': 'Pick an image',
          'source': 'Source',
          'search': 'Search',
          'no_recipe':
              'No recipe in database. Please create one using the + icon.',
        },
        'fr_FR': {
          'hello': 'Bonjour',
          'add recipe': 'Ajouter une recette',
          'save': 'Enregistrer',
          'title': 'Titre',
          'pick image': 'Sélectionner une image',
          'source': 'Source',
          'search': 'Recherche',
          'no_recipe':
              'Aucune recette en base. Veuillez en créer une avec l\'icone +.',
        },
        //defaults to en_US when missing translations!
        'ja_JP': {
          'hello': 'こんにちは',
          'add recipe': 'レシピを入力',
          'save': '保存する',
        }
      };
}
