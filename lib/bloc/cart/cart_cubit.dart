import 'package:bloc/bloc.dart';

part "cart_state.dart";

class CartCubit extends Cubit<CartState> {
  CartCubit(super.initialState);

  // Create for adding to cart
  addCart(
      {required int id,
      required String image,
      required String name,
      required int piece,
      required double price}) {
    var currentCart = state.cart;
    // matching cart id 
    if (currentCart.any((element) => element["id"] == id)) {
      currentCart.firstWhere((element) => element["id"] == id)["piece"]++;
    } else {
      currentCart.add({
        "id": id,
        "image": image,
        "name": name,
        "in-stock": true,
        "piece": piece,
        "price": price,
      });
    }

    final newState = CartState(
      cart: currentCart,
    );
    emit(newState);
  }
  // create for removing cart
  removeCart({
    required int id,
  }) {
    var currentCart = state.cart;
    currentCart.removeWhere((element) => element["id"] == id);

    final newState = CartState(
      cart: currentCart,
    );
    emit(newState);
  }
  // create for clear cart
  clearCart() {
    final newState = CartState(cart: []);
    emit(newState);
  }
}
