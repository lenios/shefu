import 'package:get/get.dart';

class I18n extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello',
          'add': 'Add',
          'add recipe': 'Add recipe',
          'add step': 'Add step',
          'edit recipe': 'Edit recipe',
          'edit step': 'Edit step',
          'save': 'Save',
          'delete': 'Delete',
          'title': 'Title',
          'timer': 'Timer',
          'name': 'Name',
          'unit': 'Unit',
          'quantity': 'Quantity',
          'direction': 'Direction',
          'pick image': 'Pick an image',
          'source': 'Source',
          'search': 'Search',
          'notes': 'Notes',
          'no_recipe':
              'No recipe in database. Please create one using the + icon.',
        },
        'fr_FR': {
          'hello': 'Bonjour',
          'add': 'Ajouter',
          'add recipe': 'Ajouter une recette',
          'add step': 'Ajouter une étape',
          'edit recipe': 'Modifier la recette',
          'edit step': 'Modifier l\'étape',
          'save': 'Enregistrer',
          'delete': 'Supprimer',
          'title': 'Titre',
          'timer': 'Durée',
          'name': 'Nom',
          'unit': 'Unité',
          'quantity': 'Quantité',
          'direction': 'instructions',
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
