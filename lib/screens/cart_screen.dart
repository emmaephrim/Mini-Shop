import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/providers/cart_provider.dart';
import 'package:mini_shop_app/providers/order_provider.dart';
import 'package:mini_shop_app/widgets/cart_item.dart';

class CartScreen extends ConsumerStatefulWidget {
  static const routeName = '/cart-screen';

  const CartScreen({super.key});
  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        await ref
                            .read(orderProvider.notifier)
                            .addOrder(
                              cartItems.values.toList(),
                              double.parse(totalFormatted),
                            )
                            .then((_) async {
                              await ref.read(cartProvider.notifier).clear();
                            });
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Oops Something went wrong!')),
                        );
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Order Now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryFixedDim,
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
