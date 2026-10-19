import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/widgets/app_drawer.dart';
import 'package:mini_shop_app/features/orders/controllers/order_controller.dart';
import 'package:mini_shop_app/features/orders/widgets/order_item.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncOrders = ref.watch(orderControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Your Orders")),
      body: asyncOrders.when(
        data: (orders) => ListView.builder(
          itemCount: orders.length,
          itemBuilder: (ctx, index) => OrderItem(order: orders[index]),
        ),
        error: (error, stackTrace) => Text('Something went wrong! \n$error'),
        loading: () => Center(child: CircularProgressIndicator()),
      ),

      drawer: AppDrawer(),
    );
  }
}
