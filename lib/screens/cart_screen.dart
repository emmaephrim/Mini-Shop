import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  static const routeName = '/cart-screen';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalFormatted = ref.watch(
      cartProvider.select((state) => state.totalAmount.toStringAsFixed(2)),
    );

    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Text("Total", style: TextStyle(fontSize: 20)),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      '\$$totalFormatted',
                      // ref.watch(
                      //   cartProvider.select((cartItems) {
                      //     final total = cartItems.values.fold<double>(
                      //       0,
                      //       (sum, cartItem) =>
                      //           sum + cartItem.price * cartItem.quantity,
                      //     );
                      //     return total.toStringAsFixed(2);
                      //   }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
