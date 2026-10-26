import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/network/dio_provider.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
import 'package:mini_shop_app/features/orders/models/order.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  final userId = ref.watch(authServiceProvider).currentUser!.uid;
  return OrderService(dio: ref.read(dioProvider), uid: userId);
});

class OrderService {
  final Dio _dio;
  final String _uid;
  OrderService({required this._dio, required this._uid});

  Future<List<Order>> fetchOrders() async {
    final List<Order> loadedOrders = [];
    final res = await _dio.get('/orders/$_uid.json');
    if (res.data == null) return [];
    final decoded = res.data as Map<String, dynamic>;

    decoded.forEach(((key, value) => loadedOrders.add(Order.fromMap(value))));
    return loadedOrders;
  }

  Future<void> addOrder(Order order) async {
    await _dio.post('/orders/$_uid.json', data: order.toJson());
  }
}
