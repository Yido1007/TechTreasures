import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:techtreasure/bloc/cart/cart_cubit.dart';

import 'package:techtreasure/bloc/products/products_cubit.dart';
import 'package:techtreasure/core/data.dart';
import 'package:techtreasure/widgets/bottommenu.dart';

import '../../../core/localizations.dart';

class HeadphoneScreen extends StatefulWidget {
  const HeadphoneScreen({super.key});

  @override
  State<HeadphoneScreen> createState() => _HeadphoneScreenState();
}

class _HeadphoneScreenState extends State<HeadphoneScreen> {
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
        // headphone Screen title
        title: Text(
          AppLocalizations.of(context).getTranslate("headphone"),
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
      itemCount: headphone.length,
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
              headphone[index]["image"].toString(),
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Product Nanem
                Text(headphone[index]["name"].toString()),
                if (productCubit.isFavorite(headphone[index]["id"] as int))
                  // Button to remove the product to favorites
                  IconButton(
                    onPressed: () {
                      productCubit.removeFavorite(headphone[index]["id"] as int);
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
                      productCubit.addFavorite(headphone[index]);
                    },
                    icon: const Icon(Icons.favorite_border),
                  )
              ],
            ),
            // Checking it is in stock or not
            if (headphone[index]["in-stock"] as bool)
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
                  Text(headphone[index]["price"].toString() +
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
            if (headphone[index]["in-stock"] as bool)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                // product information
                onPressed: () {
                  cartCubit.addCart(
                    id: headphone[index]["id"] as int,
                    image: headphone[index]["image"].toString(),
                    name: headphone[index]["name"].toString(),
                    piece: 1,
                    price: headphone[index]["price"] as double,
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
      itemCount: headphone.length,
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
              headphone[index]["image"].toString(),
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Product Nanem
                Text(headphone[index]["name"].toString()),
                if (productCubit.isFavorite(headphone[index]["id"] as int))
                  // Button to remove the product to favorites
                  IconButton(
                    onPressed: () {
                      productCubit.removeFavorite(headphone[index]["id"] as int);
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
                      productCubit.addFavorite(headphone[index]);
                    },
                    icon: const Icon(Icons.favorite_border),
                  )
              ],
            ),
            // Checking it is in stock or not
            if (headphone[index]["in-stock"] as bool)
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
                  Text(headphone[index]["price"].toString() +
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
            if (headphone[index]["in-stock"] as bool)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                ),
                // product information
                onPressed: () {
                  cartCubit.addCart(
                    id: headphone[index]["id"] as int,
                    image: headphone[index]["image"].toString(),
                    name: headphone[index]["name"].toString(),
                    piece: 1,
                    price: headphone[index]["price"] as double,
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
