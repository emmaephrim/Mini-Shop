import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/providers/order_provider.dart';
import 'package:mini_shop_app/widgets/app_drawer.dart';
import 'package:mini_shop_app/widgets/order_item.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  static const routeName = '/orders-screen';

  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    Future.wait([ref.read(orderProvider.notifier).fetchAndSetOrders()])
        .then(
          (_) => setState(() {
            _isLoading = false;
          }),
        )
        .catchError((error) {
          setState(() {
            _isLoading = false;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Your Orders")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (ctx, index) => OrderItem(order: orders[index]),
            ),
      drawer: AppDrawer(),
    );
  }
}
