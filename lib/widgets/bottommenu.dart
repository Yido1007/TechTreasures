import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:techtreasure/core/localizations.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) {
        switch (value) {
          case 0:
            GoRouter.of(context).go("/home");
            break;
          case 1:
            GoRouter.of(context).go("/category");
            break;
          case 2:
            GoRouter.of(context).go("/cart");
            break;
          case 3:
            GoRouter.of(context).go("/settings");
            break;
        }
      },
      // Home Screen Navigation
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          label: AppLocalizations.of(context).getTranslate("home"),
        ),
        // Categories Screen Navigation
        BottomNavigationBarItem(
          icon: const Icon(Icons.search_outlined),
          label: AppLocalizations.of(context).getTranslate("categories"),
        ),
        // Shopping Cart Screen Navigation
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_cart_outlined),
          label: AppLocalizations.of(context).getTranslate("cart"),
        ),
        // Settings Screen Navigation
        BottomNavigationBarItem(
          icon: const Icon(Icons.settings_outlined),
          label: AppLocalizations.of(context).getTranslate("settings"),
        ),
      ],
    );
  }
}
