import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/utils/logger.dart';
import 'package:mini_shop_app/features/cart/models/cart.dart';
import 'package:mini_shop_app/features/orders/models/order.dart';
import 'package:mini_shop_app/features/orders/services/order_service.dart';

final orderControllerProvider =
    AsyncNotifierProvider<OrderController, List<Order>>(OrderController.new);

class OrderController extends AsyncNotifier<List<Order>> {
  @override
  FutureOr<List<Order>> build() async {
    try {
      return await ref.read(orderServiceProvider).fetchOrders();
    } catch (error, stackTrace) {
      logger.e("Failed to fetch orders", error: error, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  List<Order> get _currentList => state.value ?? [];

  Future<void> addOrder(List<Cart> cardProducts, double total) async {
    final newItem = Order(
      id: DateTime.now().toString(),
      amount: total,
      products: cardProducts,
      dateTime: DateTime.now(),
    );

    try {
      await ref.read(orderServiceProvider).addOrder(newItem);
      state = AsyncValue.data([..._currentList, newItem]);
    } catch (error, stackTrace) {
      logger.e(
        'Add new order to orders failed',
        error: error,
        stackTrace: stackTrace,
      );
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }
}
