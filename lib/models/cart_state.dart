import 'package:mini_shop_app/models/cart.dart';

class CartState {
  Map<String, Cart> items;

  CartState({required this.items});

  double get totalAmount {
    return items.values.fold<double>(
      0,
      (sum, cartItem) => sum + (cartItem.price * cartItem.quantity),
    );
  }
}
