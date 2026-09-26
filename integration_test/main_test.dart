import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shefu/main.dart';
import 'package:shefu/models/entities.dart';
import 'package:drift/native.dart';
import 'package:shefu/database/app_database.dart';
import 'package:shefu/repositories/nutrient_repository.dart';
import 'package:shefu/repositories/recipe_repository.dart';
import 'package:shefu/router/app_router.dart';
import 'package:shefu/utils/string_extension.dart';
import 'package:shefu/views/display_recipe.dart';
import 'package:shefu/views/edit_recipe.dart';
import 'package:shefu/widgets/home/recipe_card.dart';

import '../test/support/fake_repositories.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('create a new recipe, and check it is listed on homepage', (tester) async {
      await tester.pumpWidget(
        MyApp(
          recipeRepository: RecipeRepository(_database()),
          nutrientRepository: _nutrientRepository(),
        ),
      );

      // Wait for locale and initial load
      await tester.pumpAndSettle();

      // Tap the add recipe button on home page, and choose manual recipe entry
      final addRecipeButton = find.byKey(const Key('AddRecipe'));
      expect(addRecipeButton, findsOneWidget);
      await tester.tap(addRecipeButton);
      await tester.pumpAndSettle();
      final writeRecipeButton = find.text('Write recipe');
      expect(writeRecipeButton, findsOneWidget);
      await tester.tap(writeRecipeButton);
      await tester.pumpAndSettle();

      // Fill in the title field on edit recipe page
      final mockRecipeTitle = 'Tiramisu (original recipe)';
      final titleField = find.byKey(const ValueKey('title'));
      expect(titleField, findsOneWidget);
      await tester.enterText(titleField, mockRecipeTitle);
      await tester.pump();

      // Tap the save button to go back to home page
      final saveButton = find.byKey(const Key('save'));
      expect(saveButton, findsOneWidget);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify the new recipe appears in the list, capitalized
      final recipeTitle = find.text(mockRecipeTitle.capitalize());
      expect(recipeTitle, findsOneWidget);
    });

    testWidgets('create a variant with an overriden step, and check it is saved', (tester) async {
      const variantTitle = "matcha tiramisu";
      const newIngredient = "matcha";
      final recipeRepo = FakeRecipeRepository([_mockRecipe()]);

      await tester.pumpWidget(
        MyApp(nutrientRepository: FakeNutrientRepository(), recipeRepository: recipeRepo),
      );

      // Wait for locale and initial load
      await tester.pumpAndSettle();

      // Open the recipe with id 1 from the homepage, then its edit page
      final recipeCard = find.byWidgetPredicate(
        (widget) => widget is RecipeCard && widget.recipe.id == 1 && widget.variant == null,
      );
      expect(recipeCard, findsOneWidget);
      await tester.tap(recipeCard);
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(of: find.byType(DisplayRecipe), matching: find.byIcon(Icons.edit_outlined)),
      );
      await tester.pumpAndSettle();
      expect(find.byType(EditRecipe), findsOneWidget);

      // Add a variant, and let the confirmation snack bar go away
      await tester.tap(find.byKey(const Key('add_variant')));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // The steps of a variant stay read only until they are overridden
      final firstStepCard = find.byKey(const Key('step_list_item_0_0'));
      final firstIngredientField = find.byKey(const Key('name_field_0_0'));
      expect(_ingredientIsReadOnly(tester, firstIngredientField), isTrue);

      // Click override button
      final overrideButton = find.descendant(
        of: firstStepCard,
        matching: find.byIcon(Icons.copy_outlined),
      );
      await tester.ensureVisible(overrideButton);
      await tester.tap(overrideButton);
      await tester.pumpAndSettle();
      expect(_ingredientIsReadOnly(tester, firstIngredientField), isFalse);

      // Rename the variant and its first ingredient
      final editList = find.byType(ListView).first;
      final titleField = find.byKey(const Key('title'));
      await tester.dragUntilVisible(titleField, editList, const Offset(0, 200));
      await tester.enterText(titleField, variantTitle);
      await tester.pumpAndSettle();
      await tester.dragUntilVisible(firstIngredientField, editList, const Offset(0, -200));
      await tester.enterText(firstIngredientField, newIngredient);
      // Let the ingredient matching debounce elapse
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('save')));
      await tester.pumpAndSettle();

      // Back on the display page, the variant is active
      expect(find.byType(DisplayRecipe), findsOneWidget);
      expect(find.text(variantTitle.capitalize()), findsOneWidget);
      expect(find.textContaining(newIngredient), findsWidgets);

      // The variant is listed on the homepage, and reopens with its own content
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();
      final variantCard = find.byWidgetPredicate(
        (widget) => widget is RecipeCard && widget.recipe.id == 1 && widget.variant != null,
      );
      expect(variantCard, findsOneWidget);
      // Tap variant card, only top band is tappable
      final variantRect = tester.getRect(variantCard);
      await tester.tapAt(Offset(variantRect.center.dx, variantRect.top + 10));
      await tester.pumpAndSettle();

      // Variant has correct title and ingredients
      expect(find.byType(DisplayRecipe), findsOneWidget);
      expect(find.text(variantTitle.capitalize()), findsOneWidget);
      expect(find.textContaining(newIngredient), findsWidgets);
    });

    testWidgets('add ingredient and nutrient', (tester) async {
      final recipe = _mockRecipeWithTwoFullSteps();
      final recipeRepo = FakeRecipeRepository([recipe]);

      await tester.pumpWidget(
        MyApp(nutrientRepository: _nutrientRepository(), recipeRepository: recipeRepo),
      );
      await tester.pumpAndSettle();
      // The router is a static singleton: an earlier test may have left it on a recipe page.
      AppRouter.router.go('/');
      await tester.pumpAndSettle();

      // Open the recipe from the homepage: the first step lists its three ingredients
      final recipeCard = find.byWidgetPredicate(
        (widget) => widget is RecipeCard && widget.recipe.id == 1 && widget.variant == null,
      );
      expect(recipeCard, findsOneWidget);
      await tester.tap(recipeCard);
      await tester.pumpAndSettle();
      expect(find.byType(DisplayRecipe), findsOneWidget);
      for (final name in ["flour", "milk", "egg"]) {
        expect(find.textContaining(name), findsWidgets, reason: name);
      }

      // Edit it: both steps hold exactly three ingredients
      await tester.tap(
        find.descendant(of: find.byType(DisplayRecipe), matching: find.byIcon(Icons.edit_outlined)),
      );
      await tester.pumpAndSettle();
      expect(find.byType(EditRecipe), findsOneWidget);
      final editList = find.byType(ListView).first;
      expect(find.byKey(const ValueKey('name_field_0_2')), findsOneWidget);
      expect(find.byKey(const ValueKey('name_field_0_3')), findsNothing);
      await _scrollIntoView(tester, find.byKey(const ValueKey('name_field_1_2')), editList);
      expect(find.byKey(const ValueKey('name_field_1_3')), findsNothing);

      // Add a fourth ingredient to the first step
      final addIngredientButton = find.descendant(
        of: find.byKey(const Key('step_list_item_0_0')),
        matching: find.text('Add ingredient'),
      );
      await _scrollIntoView(tester, addIngredientButton, editList);
      await tester.tap(addIngredientButton);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('name_field_0_3')), findsOneWidget);
      expect(recipe.steps.first.ingredients, hasLength(4));

      // 1 tbsp of wheat flour
      final newQuantityField = find.byKey(const ValueKey('quantity_field_0_3'));
      await _scrollIntoView(tester, newQuantityField, editList);
      await tester.enterText(newQuantityField, '1');
      await tester.pumpAndSettle();

      final newIngredientCard = find
          .ancestor(of: find.byKey(const ValueKey('name_field_0_3')), matching: find.byType(Card))
          .first;
      await tester.tap(
        find.descendant(
          of: newIngredientCard,
          matching: find.byType(DropdownButtonFormField<String>),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('tbsp').last);
      await tester.pumpAndSettle();

      final newNameField = find.byKey(const ValueKey('name_field_0_3'));
      await _scrollIntoView(tester, newNameField, editList);
      await tester.enterText(newNameField, 'wheat flour');
      // Let the ingredient matching debounce elapse
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // The unit stays editable as long as no nutrient factor is chosen
      DropdownButtonFormField<String> unitDropdown() => tester.widget(
        find.descendant(
          of: newIngredientCard,
          matching: find.byType(DropdownButtonFormField<String>),
        ),
      );
      expect(unitDropdown().onChanged, isNotNull);

      // The nutrient dropdown is populated from the name, pick the cake flour entry
      final nutrientDropdown = find.byKey(const ValueKey('nutrient_0_3_wheat flour'));
      await _scrollIntoView(tester, nutrientDropdown, editList);
      await tester.tap(nutrientDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Grains, wheat flour, white, cake flour').last);
      await tester.pumpAndSettle();

      // Picking a nutrient reveals its conversion factors: 4 x 30g of cake flour
      final factorDropdown = find.byKey(const ValueKey('factor_0_3_$_cakeFlourFoodId'));
      await _scrollIntoView(tester, factorDropdown, editList);
      await tester.tap(factorDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('30g').last);
      await tester.pumpAndSettle();
      await _scrollIntoView(tester, newQuantityField, editList);
      await tester.enterText(newQuantityField, '4');
      await tester.pumpAndSettle();

      final newIngredient = recipe.steps.first.ingredients.last;
      expect(newIngredient.name, 'wheat flour');
      expect(newIngredient.unit, 'tbsp');
      expect(newIngredient.quantity, 4);
      expect(newIngredient.foodId, _cakeFlourFoodId);

      // Insert a step between the two existing ones
      final insertStepButton = find.byTooltip('Add intermediate step').first;
      await _scrollIntoView(tester, insertStepButton, editList);
      await tester.tap(insertStepButton);
      await tester.pumpAndSettle();
      expect(recipe.steps, hasLength(3));
      final newStepInstruction = find.byKey(const ValueKey('instruction_field_1'));
      await _scrollIntoView(tester, newStepInstruction, editList);
      await tester.enterText(newStepInstruction, 'wait');
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('step_list_item_0_2')), findsOneWidget);
      expect(recipe.steps[1].instruction, 'wait');

      // Saving computes the calories per serving from the nutrient factor
      await tester.tap(find.byKey(const Key('save')));
      await tester.pumpAndSettle();
      expect(find.byType(DisplayRecipe), findsOneWidget);
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();
      // 30g factor (0.3) x 4 x 368 kcal/100g = 441.6 kcal, over 4 servings
      expect(find.descendant(of: recipeCard, matching: find.text('110 Kcal')), findsOneWidget);
    });
  });
}

// Real repositories, on an in-memory database shared by the tests.
AppDatabase? _sharedDatabase;
NutrientRepository? _sharedNutrientRepository;

AppDatabase _database() =>
    _sharedDatabase ??= AppDatabase(NativeDatabase.memory(setup: configureConnection));

NutrientRepository _nutrientRepository() =>
    _sharedNutrientRepository ??= NutrientRepository(_database());

// Recipe with a category and two steps, the first one holding three ingredients.
Recipe _mockRecipe() {
  final recipe = Recipe(id: 1, title: "Tiramisu", category: Category.desserts.index);
  final mixStep = RecipeStep(name: "batter", instruction: "Mix everything", order: 0);
  for (final name in ["coffee", "flour", "milk", "egg"]) {
    mixStep.ingredients.add(IngredientItem(name: name, quantity: 100, unit: "g"));
  }
  recipe.steps.add(mixStep);
  recipe.steps.add(RecipeStep(name: "cooking", instruction: "Cook both sides", order: 1));
  return recipe;
}

/// "Grains, wheat flour, white, cake flour" in the bundled nutrient database.
const _cakeFlourFoodId = 4446;

// Recipe with two steps, each holding three ingredients.
Recipe _mockRecipeWithTwoFullSteps() {
  final recipe = Recipe(id: 1, title: "Pancakes", category: Category.desserts.index);
  const stepIngredients = [
    ["flour", "milk", "egg"],
    ["butter", "sugar", "salt"],
  ];
  for (var index = 0; index < stepIngredients.length; index++) {
    final step = RecipeStep(
      name: index == 0 ? "batter" : "cooking",
      instruction: index == 0 ? "Mix everything" : "Cook both sides",
      order: index,
    );
    for (final name in stepIngredients[index]) {
      step.ingredients.add(IngredientItem(name: name, quantity: 100, unit: "g"));
    }
    recipe.steps.add(step);
  }
  return recipe;
}

/// A variant may only edit the ingredients of the steps it overrides.
bool _ingredientIsReadOnly(WidgetTester tester, Finder ingredientNameField) {
  expect(ingredientNameField, findsOneWidget);
  return tester
      .widget<IgnorePointer>(
        find.ancestor(of: ingredientNameField, matching: find.byType(IgnorePointer)).first,
      )
      .ignoring;
}

Future<void> _scrollIntoView(WidgetTester tester, Finder target, Finder list) async {
  const step = 200.0;
  for (var attempt = 0; attempt < 30; attempt++) {
    final listRect = tester.getRect(list);
    final targetRect = tester.getRect(target);
    if (targetRect.top >= listRect.top && targetRect.bottom <= listRect.bottom) return;
    final delta = targetRect.top < listRect.top ? step : -step;
    await tester.drag(list, Offset(0, delta));
    await tester.pumpAndSettle();
  }
  fail('could not scroll ${target.describeMatch(Plurality.one)} into view');
}
