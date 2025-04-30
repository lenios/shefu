import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shefu/l10n/app_localizations.dart';
import 'package:shefu/provider/my_app_state.dart';
import 'package:shefu/utils/app_color.dart';
import 'package:shefu/widgets/shopping_basket_modal.dart';

/// A wrapper scaffold that adds the Shopping Basket FAB to any screen
class AppScaffold extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const AppScaffold({
    super.key,
    required this.child,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.floatingActionButtonLocation,
  });

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);
    final l10n = AppLocalizations.of(context)!;

    // Set up the final FAB configuration
    Widget? effectiveFAB;

    // Only create and show shopping basket FAB if basket is not empty
    if (appState.isShoppingBasketNotEmpty) {
      Widget shoppingBasketFab = FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (modalContext) => const ShoppingBasketModal(),
          );
        },
        backgroundColor: AppColor.primarySoft,
        foregroundColor: Colors.white,
        tooltip: l10n.shoppingList,
        child: Badge(
          label: Text(appState.shoppingBasket.length.toString()),
          isLabelVisible: true,
          child: const Icon(Icons.shopping_basket_outlined),
        ),
      );

      if (floatingActionButton != null) {
        effectiveFAB = Row(
          mainAxisSize: MainAxisSize.min,
          children: [shoppingBasketFab, const SizedBox(width: 10), floatingActionButton!],
        );
      } else {
        effectiveFAB = shoppingBasketFab;
      }
    } else {
      // If basket is empty, only show the provided FAB if available
      effectiveFAB = floatingActionButton;
    }

    return Scaffold(
      appBar: appBar,
      body: child,
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: effectiveFAB,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
