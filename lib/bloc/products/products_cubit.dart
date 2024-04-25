import 'package:flutter_bloc/flutter_bloc.dart';

part "products_state.dart";

class ProductCubit extends Cubit<ProductState> {
  ProductCubit(super.initialState);

  addFavorite(Map<String, dynamic> product) {
    var currentFavorites = state.favorites;

    bool found = false;

    for (int i = 0; i < currentFavorites.length; i++) {
      if (currentFavorites[i]["id"] == product["id"]) {
        found = true;
        break;
      }
    }

    if (found) {
      // product already in favorite
    } else {
      currentFavorites.add(product);
      // prepare new state
      final updatedState = ProductState(
        favorites: currentFavorites,
      );

      emit(updatedState);
    }
  }

  removeFavorite(int productID) {
    var currentFavorites = state.favorites;

    currentFavorites.removeWhere((element) => element["id"] == productID);

    final newState = ProductState(favorites: currentFavorites);

    emit(newState);
  }

  clearFavorite() {
    final updateState = ProductState(favorites: const []);
    emit(updateState);
  }

  bool isFavorite(int productID) {
    return state.favorites.any((element) => element["id"] == productID);
  }
}
