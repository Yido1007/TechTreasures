import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:techtreasure/bloc/cart/cart_cubit.dart';
import 'package:techtreasure/bloc/products/products_cubit.dart';
import 'package:techtreasure/core/themes.dart';

import 'bloc/client/client_cubit.dart';
import 'core/localizations.dart';
import 'core/routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ClientCubit(
            ClientState(language: "en", darkMode: false),
          ),
        ),
        BlocProvider(
          create: (context) => CartCubit(
            CartState(cart: []),
          ),
        ),
        BlocProvider(
          create: (context) => ProductCubit(
            ProductState(favorites: []),
          ),
        ),
      ],
      child: BlocBuilder<ClientCubit, ClientState>(builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: routes,
          themeMode: state.darkMode ? ThemeMode.dark : ThemeMode.light,
          theme: lightTheme,
          darkTheme: darkTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('tr', 'TR'),
          ],
          locale: Locale(state.language),
        );
      }),
    );
  }
}
