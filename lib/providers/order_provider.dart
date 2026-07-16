import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/models/cart.dart';
import 'package:mini_shop_app/models/order.dart';

class OrderProvider extends Notifier<List<Order>> {
  @override
  List<Order> build() => [];

  void addOrder(List<Cart> cardProducts, double total) {
    state = [
      Order(
        id: DateTime.now().toString(),
        amount: total,
        products: cardProducts,
        dateTime: DateTime.now(),
      ),
      ...state,
    ];
  }
}
