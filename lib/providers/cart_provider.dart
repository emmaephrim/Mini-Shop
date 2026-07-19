import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/models/cart.dart';
import 'package:mini_shop_app/models/cart_state.dart';

final cartProvider = NotifierProvider<CartProvider, CartState>(
  CartProvider.new,
);

class CartProvider extends Notifier<CartState> {
  @override
  CartState build() => CartState(items: {});

  void addItem(String productId, double price, String title) {
    final currentItems = state.items;

    if (currentItems.containsKey(productId)) {
      final existingCart = currentItems[productId]!;
      state = CartState(
        items: {
          ...currentItems,
          productId: existingCart.copyWith(quantity: existingCart.quantity + 1),
        },
      );
    } else {
      state = CartState(
        items: {
          ...currentItems,
          productId: Cart(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price,
          ),
        },
      );
    }
  }

  void removeItem(String key) {
    final currentItems = state.items;
    currentItems.remove(key);
    state = CartState(items: currentItems);
  }

  void removeSingleItem(String key) {
    if (!state.items.containsKey(key)) {
      return;
    }

    final existingCart = state.items[key]!;

    if (existingCart.quantity > 1) {
      state = CartState(
        items: {
          ...state.items,
          key: existingCart.copyWith(quantity: existingCart.quantity - 1),
        },
      );
    } else {
      final updatedItems = {...state.items};
      updatedItems.remove(key);
      state = CartState(items: updatedItems);
    }
  }

  void clear() {
    state = CartState(items: {});
  }
}
