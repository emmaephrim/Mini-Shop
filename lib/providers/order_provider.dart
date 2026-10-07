import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/models/cart.dart';
import 'package:mini_shop_app/models/order.dart';
import 'package:http/http.dart' as http;

final orderProvider = NotifierProvider<OrderProvider, List<Order>>(
  OrderProvider.new,
);

class OrderProvider extends Notifier<List<Order>> {
  @override
  List<Order> build() {
    fetchAndSetOrders();
    return [];
  }

  final String baseUrl =
      'mini-shop-flutter-default-rtdb.asia-southeast1.firebasedatabase.app';

  Future<List<Order>> fetchAndSetOrders() async {
    final List<Order> loadedOrders = [];
    try {
      var res = await http.get(Uri.https(baseUrl, 'orders.json'));
      final decoded = json.decode(res.body) as Map<String, dynamic>?;
      if (decoded == null) {
        state = [];
        return [];
      }

      decoded.forEach(((key, value) => loadedOrders.add(value)));
      state = loadedOrders;
      return loadedOrders;
    } catch (error) {
      log(error.toString(), name: 'fetchAndSetOrders error: ');
      rethrow;
    }
  }

  Future<void> addOrder(List<Cart> cardProducts, double total) async {
    final currentState = state;
    try {
      final newItem = Order(
        id: DateTime.now().toString(),
        amount: total,
        products: cardProducts,
        dateTime: DateTime.now(),
      );

      state = [newItem, ...state];
      await http.post(
        Uri.https(baseUrl, 'orders.json'),
        body: newItem.toJson(),
      );
    } catch (e) {
      state = currentState;
      log(e.toString(), name: 'addOrder error:');
      rethrow;
    }
  }
}
