import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mini_shop_app/features/orders/models/order.dart';

final orderServiceProvider = Provider<OrderService>((ref) => OrderService());

class OrderService {
  String get baseUrl => dotenv.env['FIREBASE_DB_RUL']!;

  Future<List<Order>> fetchOrders() async {
    final List<Order> loadedOrders = [];
    final res = await http.get(Uri.https(baseUrl, 'orders.json'));
    final decoded = json.decode(res.body) as Map<String, dynamic>?;
    if (decoded == null) {
      return [];
    }

    decoded.forEach(((key, value) => loadedOrders.add(Order.fromMap(value))));
    return loadedOrders;
  }

  Future<void> addOrder(Order order) async {
    await http.post(Uri.https(baseUrl, 'orders.json'), body: order.toJson());
  }
}
