import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/repositories/recipe_repository.dart';
import 'package:shefu/widgets/home/recipe_menu_popup.dart';
import 'package:shefu/widgets/shopping_basket_modal.dart';

/// Shared scaffold with persistent menu and shopping-list actions.
class const AppScaffold({
  super.key,
  required final Widget child,
  final PreferredSizeWidget? appBar,
  final Widget? floatingActionButton,
  final Color? backgroundColor,
  final bool extendBodyBehindAppBar = false,
  final bool resizeToAvoidBottomInset = true,
  final FloatingActionButtonLocation? floatingActionButtonLocation,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final l10n = AppLocalizations.of(context)!;
    final leftActions = <Widget>[];

    if (appState.menuRecipeIds.isNotEmpty) {
      leftActions.add(
        FloatingActionButton(
          heroTag: 'app_scaffold_menu',
          onPressed: () async {
            final recipes = await context.read<RecipeRepository>().getAllRecipes();
            if (context.mounted) await showRecipeMenuPopup(context, recipes);
          },
          tooltip: l10n.menu,
          child: Badge(
            label: Text(appState.menuRecipeIds.length.toString()),
            child: const Icon(Icons.restaurant_menu),
          ),
        ),
      );
    }

    if (appState.isShoppingBasketNotEmpty) {
      leftActions.add(
        FloatingActionButton(
          heroTag: 'app_scaffold_shopping_list',
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const ShoppingBasketModal(),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
          tooltip: l10n.shoppingList,
          child: Badge(
            label: Text(appState.shoppingBasket.length.toString()),
            child: const Icon(Icons.shopping_basket_outlined),
          ),
        ),
      );
    }

    final Widget? effectiveFab;
    if (leftActions.isEmpty) {
      effectiveFab = floatingActionButton;
    } else {
      effectiveFab = SizedBox(
        width: MediaQuery.sizeOf(context).width - 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var index = 0; index < leftActions.length; index++) ...[
                  if (index > 0) const SizedBox(width: 10),
                  leftActions[index],
                ],
              ],
            ),
            floatingActionButton ?? const SizedBox.shrink(),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: SafeArea(top: false, child: child),
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: effectiveFab,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
