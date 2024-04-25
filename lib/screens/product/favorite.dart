import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:techtreasure/bloc/cart/cart_cubit.dart';
import 'package:techtreasure/bloc/products/products_cubit.dart';
import 'package:techtreasure/core/localizations.dart';
import 'package:techtreasure/widgets/bottommenu.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // Define Cubit State

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
        // Favorite page title
        title: Text(
          AppLocalizations.of(context).getTranslate("favorites"),
        ),
        centerTitle: true,
        actions: [
          // Clear favorite button and button tooltip
          Tooltip(
            message: AppLocalizations.of(context).getTranslate("clear"),
            child: IconButton(
                onPressed: () {
                  productCubit.clearFavorite();
                },
                icon: const Icon(Icons.clear)),
          )
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
        return SafeArea(
          child: SizedBox.expand(
            child: ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Image.network(state.favorites[index]["image"].toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(state.favorites[index]["name"].toString()),
                        if (productCubit.isFavorite(state.favorites[index]["id"] as int))
                          IconButton(
                            onPressed: () {
                              productCubit.removeFavorite(state.favorites[index]["id"] as int);
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                          )
                        else
                          IconButton(
                            onPressed: () {
                              productCubit.addFavorite(state.favorites[index]);
                            },
                            icon: const Icon(Icons.favorite_border),
                          )
                      ],
                    ),
                    if (state.favorites[index]["in-stock"] as bool)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_box),
                              Text(AppLocalizations.of(context).getTranslate("in-stock")),
                            ],
                          ),
                          Text(state.favorites[index]["price"].toString() +
                              AppLocalizations.of(context).getTranslate("currency")),
                        ],
                      )
                    else
                      const Row(
                        children: [
                          Icon(Icons.block),
                          Text("not in-stock"),
                        ],
                      ),
                    if (state.favorites[index]["in-stock"] as bool)
                      ElevatedButton(
                        onPressed: () {
                          cartCubit.addCart(
                            id: state.favorites[index]["id"] as int,
                            image: state.favorites[index]["image"].toString(),
                            name: state.favorites[index]["name"].toString(),
                            piece: 1,
                            price: state.favorites[index]["price"] as double,
                          );
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title:
                                  Text(AppLocalizations.of(context).getTranslate("added_to_cart")),
                              content: Text(
                                  AppLocalizations.of(context).getTranslate("succesfully_added")),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    GoRouter.of(context).go("/cart");
                                  },
                                  child:
                                      Text(AppLocalizations.of(context).getTranslate("go_basket")),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    GoRouter.of(context).pop();
                                  },
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
            ),
          ),
        );
      }),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
