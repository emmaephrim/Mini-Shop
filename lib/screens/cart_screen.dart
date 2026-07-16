import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/providers/cart_provider.dart';
import 'package:mini_shop_app/providers/order_provider.dart';
import 'package:mini_shop_app/widgets/cart_item.dart';

class CartScreen extends ConsumerWidget {
  static const routeName = '/cart-screen';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider).items;

    final totalFormatted = ref.watch(
      cartProvider.select((state) => state.totalAmount.toStringAsFixed(2)),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: Column(
        children: [
          Card(
            color: Theme.of(context).colorScheme.onSurface,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    label: Text('\$$totalFormatted'),
                  ),
                  TextButton(
                    onPressed: () {
                      ref
                          .read(orderProvider.notifier)
                          .addOrder(
                            cartItems.values.toList(),
                            double.parse(totalFormatted),
                          );
                      ref.read(cartProvider.notifier).clear();
                    },
                    child: Text(
                      "Order Now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primaryFixedDim,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, index) =>
                  CartItem(id: cartItems.keys.toList()[index]),
            ),
          ),
        ],
      ),
    );
  }
}
