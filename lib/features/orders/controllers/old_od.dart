import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mini_shop_app/core/utils/logger.dart';
import 'package:mini_shop_app/features/cart/models/cart.dart';
import 'package:mini_shop_app/features/orders/models/order.dart';

final orderProvider = NotifierProvider<OrderProvider, List<Order>>(
  OrderProvider.new,
);

class OrderProvider extends Notifier<List<Order>> {
  @override
  List<Order> build() {
    fetchAndSetOrders();
    return [];
  }

  String get baseUrl => dotenv.env['FIREBASE_DB_URL']!;

  Future<List<Order>> fetchAndSetOrders() async {
    final List<Order> loadedOrders = [];
    try {
      var res = await http.get(Uri.https(baseUrl, 'orders.json'));
      final decoded = json.decode(res.body) as Map<String, dynamic>?;
      if (decoded == null) {
        state = [];
        return [];
      }

      decoded.forEach(((key, value) => loadedOrders.add(Order.fromMap(value))));
      state = loadedOrders;
      return loadedOrders;
    } catch (error, stackTrace) {
      logger.e('Fetching orders failed', error: error, stackTrace: stackTrace);
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
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
    } catch (error, stackTrace) {
      state = currentState;

      logger.e('Adding order failed', error: error, stackTrace: stackTrace);
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }
}
