import 'package:go_router/go_router.dart';
import 'package:techtreasure/screens/categories/computer/console.dart';
import 'package:techtreasure/screens/categories/computer/laptop.dart';
import 'package:techtreasure/screens/categories/computer/desktop.dart';
import 'package:techtreasure/screens/categories/categories.dart';
import 'package:techtreasure/screens/categories/computer/tablet.dart';
import 'package:techtreasure/screens/categories/peripherals/headphone.dart';
import 'package:techtreasure/screens/categories/peripherals/keyboard.dart';
import 'package:techtreasure/screens/categories/peripherals/monitor.dart';
import 'package:techtreasure/screens/categories/peripherals/mouse.dart';
import 'package:techtreasure/screens/payment/payment.dart';

import '../screens/client/languages.dart';
import '../screens/core/eror.dart';
import '../screens/core/loader.dart';
import '../screens/core/notifications.dart';
import '../screens/home.dart';
import '../screens/product/cart.dart';
import '../screens/product/favorite.dart';
import '../screens/static/boarding.dart';
import '../screens/static/settings.dart';

// GoRouter configuration
final routes = GoRouter(
  errorBuilder: (context, state) => const ErorScreen(),
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoaderScreen(),
    ),
    GoRoute(
      path: '/category',
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/boarding',
      builder: (context, state) => const BoardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/favorite',
      builder: (context, state) => const FavoriteScreen(),
    ),
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: '/notification',
      builder: (context, state) => const NotificationScreen(),
    ),
    GoRoute(
      path: '/payment',
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: '/desktop',
      builder: (context, state) => const PcScreen(),
    ),
    GoRoute(
      path: '/laptop',
      builder: (context, state) => const LaptopScreen(),
    ),
    GoRoute(
      path: '/console',
      builder: (context, state) => const ConsoleScreen(),
    ),
    GoRoute(
      path: '/tablet',
      builder: (context, state) => const TabletScreen(),
    ),
    GoRoute(
      path: '/monitor',
      builder: (context, state) => const MonitorScreen(),
    ),
    GoRoute(
      path: '/mouse',
      builder: (context, state) => const MouseScreen(),
    ),
    GoRoute(
      path: '/headphone',
      builder: (context, state) => const HeadphoneScreen(),
    ),
    GoRoute(
      path: '/keyboard',
      builder: (context, state) => const KeyboardScreen(),
    ),
  ],
);
