import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/models/cart.dart';

final cartProvider = NotifierProvider<CartProvider, Map<String, Cart>>(
  CartProvider.new,
);

class CartProvider extends Notifier<Map<String, Cart>> {
  @override
  Map<String, Cart> build() {
    return {};
  }

  void addItem(String productId, double price, String title) {
    if (state.containsKey(productId)) {
      final existingCart = state[productId]!;
      state = {
        ...state,
        productId: existingCart.copyWith(quantity: existingCart.quantity + 1),
      };
    } else {
      state = {
        ...state,
        productId: Cart(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      };
    }
  }
}
