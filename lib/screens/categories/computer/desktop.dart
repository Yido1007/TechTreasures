import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:techtreasure/bloc/cart/cart_cubit.dart';

import 'package:techtreasure/bloc/products/products_cubit.dart';
import 'package:techtreasure/core/data.dart';
import 'package:techtreasure/widgets/bottommenu.dart';

import '../../../core/localizations.dart';

class PcScreen extends StatefulWidget {
  const PcScreen({super.key});

  @override
  State<PcScreen> createState() => _PcScreenState();
}

class _PcScreenState extends State<PcScreen> {
  // Define Cubit state
  bool isGridView = true;
  late ProductCubit productCubit;
  late CartCubit cartCubit;
  // Call Cubit State
  @override
  void initState() {
    super.initState();
    productCubit = context.read<ProductCubit>();
    cartCubit = context.read<CartCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Gaming desktop Screen title
        title: Text(
          AppLocalizations.of(context).getTranslate("desktop"),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            // Favorite Screen button and tooltip
            child: Tooltip(
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
      body: BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
        return SafeArea(
          child: SizedBox.expand(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // GridView Icon
                      Tooltip(
                        message: "Grid",
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                isGridView = true; // GridView
                              });
                            },
                            icon: const Icon(
                              Icons.grid_view_outlined,
                            ),
                            color:
                                isGridView ? Theme.of(context).colorScheme.tertiary : Colors.grey),
                      ),
                      // ListView Icon
                      Tooltip(
                        message: "List",
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                isGridView = false; // ListView
                              });
                            },
                            icon: const Icon(Icons.circle_outlined),
                            color:
                                !isGridView ? Theme.of(context).colorScheme.tertiary : Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isGridView ? isGrid() : isList(),
                )
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: const BottomMenu(),
    );
  }

  // Gridview Widget
  GridView isGrid() {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 30),
      itemCount: desktop.length,
      itemBuilder: (context, index) => Container(
        // Design Product Card
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Product image
            Image.network(
              desktop[index]["image"].toString(),
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Product Nanem
                Text(desktop[index]["name"].toString()),
                if (productCubit.isFavorite(desktop[index]["id"] as int))
                  // Button to remove the product to favorites
                  IconButton(
                    onPressed: () {
                      productCubit.removeFavorite(desktop[index]["id"] as int);
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  )
                else
                  // Button to add the product to favorites
                  IconButton(
                    onPressed: () {
                      productCubit.addFavorite(desktop[index]);
                    },
                    icon: const Icon(Icons.favorite_border),
                  )
              ],
            ),
            // Checking it is in stock or not
            if (desktop[index]["in-stock"] as bool)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // If in stock type 'In stock'
                  Row(
                    children: [
                      const Icon(Icons.check_box),
                      Text(AppLocalizations.of(context).getTranslate("in-stock")),
                    ],
                  ),
                  // Product price and currency
                  Text(desktop[index]["price"].toString() +
                      AppLocalizations.of(context).getTranslate("currency"))
                ],
              )
            else
              Row(
                children: [
                  // if not in stock type "Not available"
                  const Icon(Icons.block),
                  Text(AppLocalizations.of(context).getTranslate("not_available")),
                ],
              ),
            // if product in stock you can add the cart
            if (desktop[index]["in-stock"] as bool)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                // product information
                onPressed: () {
                  cartCubit.addCart(
                    id: desktop[index]["id"] as int,
                    image: desktop[index]["image"].toString(),
                    name: desktop[index]["name"].toString(),
                    piece: 1,
                    price: desktop[index]["price"] as double,
                  );
                  // successfully added the screen
                  showDialog(
                    context: context,
                    // Titles
                    builder: (context) => AlertDialog(
                      title: Text(AppLocalizations.of(context).getTranslate("added_to_cart")),
                      content: Text(AppLocalizations.of(context).getTranslate("succesfully_added")),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            // Go payment screen
                            GoRouter.of(context).go("/cart");
                          },
                          // Go cart
                          child: Text(AppLocalizations.of(context).getTranslate("go_basket")),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          // Keep shopping
                          child: Text(
                            AppLocalizations.of(context).getTranslate("go_back"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(AppLocalizations.of(context).getTranslate("add_to_cart")),
              ),
          ],
        ),
      ),
    );
  }

  // Listview Wİdget
  ListView isList() {
    return ListView.builder(
      itemCount: desktop.length,
      itemBuilder: (context, index) => Container(
        // Design Product Card
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            // Product image
            Image.network(
              desktop[index]["image"].toString(),
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Product Nanem
                Text(desktop[index]["name"].toString()),
                if (productCubit.isFavorite(desktop[index]["id"] as int))
                  // Button to remove the product to favorites
                  IconButton(
                    onPressed: () {
                      productCubit.removeFavorite(desktop[index]["id"] as int);
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  )
                else
                  // Button to add the product to favorites
                  IconButton(
                    onPressed: () {
                      productCubit.addFavorite(desktop[index]);
                    },
                    icon: const Icon(Icons.favorite_border),
                  )
              ],
            ),
            // Checking it is in stock or not
            if (desktop[index]["in-stock"] as bool)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // If in stock type 'In stock'
                  Row(
                    children: [
                      const Icon(Icons.check_box),
                      Text(AppLocalizations.of(context).getTranslate("in-stock")),
                    ],
                  ),
                  // Product price and currency
                  Text(desktop[index]["price"].toString() +
                      AppLocalizations.of(context).getTranslate("currency"))
                ],
              )
            else
              Row(
                children: [
                  // if not in stock type "Not available"
                  const Icon(Icons.block),
                  Text(AppLocalizations.of(context).getTranslate("not_available")),
                ],
              ),
            // if product in stock you can add the cart
            if (desktop[index]["in-stock"] as bool)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                // product information
                onPressed: () {
                  cartCubit.addCart(
                    id: desktop[index]["id"] as int,
                    image: desktop[index]["image"].toString(),
                    name: desktop[index]["name"].toString(),
                    piece: 1,
                    price: desktop[index]["price"] as double,
                  );
                  // successfully added the screen
                  showDialog(
                    context: context,
                    // Titles
                    builder: (context) => AlertDialog(
                      title: Text(AppLocalizations.of(context).getTranslate("added_to_cart")),
                      content: Text(AppLocalizations.of(context).getTranslate("succesfully_added")),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            // Go payment screen
                            GoRouter.of(context).go("/cart");
                          },
                          // Go cart
                          child: Text(AppLocalizations.of(context).getTranslate("go_basket")),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          // Keep shopping
                          child: Text(
                            AppLocalizations.of(context).getTranslate("go_back"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(AppLocalizations.of(context).getTranslate("add_to_cart")),
              ),
          ],
        ),
      ),
    );
  }
}
