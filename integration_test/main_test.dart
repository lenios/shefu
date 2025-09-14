import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shefu/main.dart';
import 'package:shefu/repositories/objectbox.dart';
import 'package:shefu/repositories/objectbox_nutrient_repository.dart';
import 'package:shefu/utils/string_extension.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('create a new recipe, and check it is listed on homepage', (tester) async {
      await tester.pumpWidget(MyApp(objectBoxNutrientRepo: await mockObjectBoxNutrientRepo()));

      // Wait for locale and initial load
      await tester.pumpAndSettle();

      // Tap the add recipe button on home page
      final addRecipeButton = find.byKey(const Key('AddRecipe'));
      expect(addRecipeButton, findsOneWidget);
      await tester.tap(addRecipeButton);
      await tester.pumpAndSettle();

      // Fill in the title field on edit recipe page
      final titleField = find.byType(TextField).first;
      await tester.enterText(titleField, 'Test Recipe INTEG');
      await tester.pump();

      // Tap the save button to go back to home page
      final saveButton = find.byIcon(Icons.save);
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify the new recipe appears in the list, capitalized
      final recipeTitle = find.text('Test Recipe INTEG'.capitalize());
      expect(recipeTitle, findsOneWidget);
    });
  });
}

// Return a mock or real instance of ObjectBoxNutrientRepository as needed for testing.
Future<ObjectBoxNutrientRepository> mockObjectBoxNutrientRepo() async {
  objectBox = await ObjectBox.create();
  return ObjectBoxNutrientRepository(objectBox);
}
