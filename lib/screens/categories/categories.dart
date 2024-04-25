import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:techtreasure/bloc/client/client_cubit.dart';

import 'package:techtreasure/core/localizations.dart';
import 'package:techtreasure/widgets/bottommenu.dart';

import '../../bloc/cart/cart_cubit.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreeStaten();
}

class _CategoriesScreeStaten extends State<CategoriesScreen> {
  // Define Cubit state
  late ClientCubit clientCubit;
  late CartCubit cartCubit;
  // Call cubit state
  @override
  void initState() {
    super.initState();
    clientCubit = context.read<ClientCubit>();
    cartCubit = context.read<CartCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientCubit, ClientState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            // Categories Screen title
            AppLocalizations.of(context).getTranslate("categories"),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Tooltip(
                // Go favorite button and tooltip
                message: AppLocalizations.of(context).getTranslate("favorites"),
                child: IconButton(
                  onPressed: () {
                    GoRouter.of(context).push("/favorite");
                  },
                  icon: const Icon(Icons.favorite),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                // first categories 'Computers'
                ExpansionTile(
                  title: Text(AppLocalizations.of(context).getTranslate("computer")),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Desktop computer categories
                        GestureDetector(
                          onTap: () => GoRouter.of(context).push("/desktop"),
                          child: Column(
                            children: [
                              // desktop image
                              Image.asset(
                                "assets/images/kasa.png",
                                width: 150,
                              ),
                              // desktop text
                              const Text("PC"),
                            ],
                          ),
                        ),
                        // Laptop categories
                        GestureDetector(
                          onTap: () => GoRouter.of(context).push("/laptop"),
                          child: Column(
                            children: [
                              // Laptop image
                              Image.asset(
                                "assets/images/laptop.png",
                                width: 150,
                              ),
                              // Laptop text
                              const Text("Laptop"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Console categories
                        GestureDetector(
                          onTap: () => GoRouter.of(context).push("/console"),
                          child: Column(
                            children: [
                              // console image
                              Image.asset(
                                "assets/images/konsol.webp",
                                width: 150,
                              ),
                              // console text
                              const Text("Console"),
                            ],
                          ),
                        ),
                        // tablet categories
                        GestureDetector(
                          onTap: () => GoRouter.of(context).push("/tablet"),
                          child: Column(
                            children: [
                              // tablet image
                              Image.asset(
                                "assets/images/tablet.png",
                                width: 150,
                              ),
                              // tablet text
                              const Text("Tablet"),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                // second categories 'Peripherals'
                ExpansionTile(
                  title: Text(AppLocalizations.of(context).getTranslate("peripherals")),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // mouse categories
                        GestureDetector(
                          onTap: () => GoRouter.of(context).push("/mouse"),
                          child: Column(
                            children: [
                              // mouse image
                              Image.asset(
                                "assets/images/mouse.png",
                                width: 150,
                              ),
                              // mouse text
                              const Text("Mouse"),
                            ],
                          ),
                        ),
                        // keyboard categories
                        GestureDetector(
                          onTap: () => GoRouter.of(context).push("/keyboard"),
                          child: Column(
                            children: [
                              // keyboard image
                              Image.asset(
                                "assets/images/klavye.png",
                                width: 150,
                              ),
                              // keyboard text
                              const Text("Keyboard"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // headphone categories
                        GestureDetector(
                          onTap: () => GoRouter.of(context).push("/headphone"),
                          child: Column(
                            children: [
                              // headphone image
                              Image.asset(
                                "assets/images/kulaklık.png",
                                width: 150,
                              ),
                              // headphone text
                              const Text("Headphone"),
                            ],
                          ),
                        ),
                        // monitor categories
                        GestureDetector(
                          onTap: () => GoRouter.of(context).push("/monitor"),
                          child: Column(
                            children: [
                              // headphone image
                              Image.asset(
                                "assets/images/monitör.png",
                                width: 150,
                              ),
                              // headphone text
                              const Text("Monitor"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        // bottom navigation bar widget
        bottomNavigationBar: const BottomMenu(),
      );
    });
  }
}
