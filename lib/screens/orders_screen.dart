import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/providers/order_provider.dart';
import 'package:mini_shop_app/widgets/order_item.dart';

class OrdersScreen extends ConsumerWidget {
  static const routeName = '/orders-screen';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Your Orders")),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, index) => OrderItem(order: orders[index]),
      ),
    );
  }
}
