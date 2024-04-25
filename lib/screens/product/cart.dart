import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:techtreasure/bloc/cart/cart_cubit.dart';
import 'package:techtreasure/bloc/products/products_cubit.dart';
import 'package:techtreasure/core/localizations.dart';

import '../../widgets/bottommenu.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
        // Cart page title
        title: Text(
          AppLocalizations.of(context).getTranslate("cart"),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            // Payment screen button and tooltip
            child: Tooltip(
              message: AppLocalizations.of(context).getTranslate("payment"),
              child: IconButton(
                onPressed: () {
                  GoRouter.of(context).push("/payment");
                },
                icon: const Icon(Icons.credit_card_outlined),
              ),
            ),
          ),
          // Clear cart button and button tooltip
          Tooltip(
            message: AppLocalizations.of(context).getTranslate("clear"),
            child: IconButton(
              onPressed: () {
                cartCubit.clearCart();
              },
              icon: const Icon(Icons.clear),
            ),
          )
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return SafeArea(
            child: SizedBox.expand(
              child: state.cart.isEmpty
                  // Cart Status message
                  ? Center(child: Text(AppLocalizations.of(context).getTranslate("cart_status")))
                  : ListView.builder(
                      itemCount: state.cart.length,
                      itemBuilder: (context, index) => Container(
                        // Design Product Card
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        // Product cart design
                        child: Column(
                          children: [
                            Image.network(state.cart[index]["image"].toString()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Product name
                                Text(state.cart[index]["name"].toString()),
                                // Product price
                                Text(state.cart[index]["price"].toString() +
                                    AppLocalizations.of(context).getTranslate("currency")),
                              ],
                            ),
                            const Gap(10),
                            // product in stock state
                            if (state.cart[index]["in-stock"] as bool)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${state.cart[index]["piece"]} x",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      cartCubit.removeCart(id: state.cart[index]["id"] as int);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context).getTranslate("remove_cart")),
                                  )
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
