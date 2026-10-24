import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/features/cart/controllers/cart_controller.dart';
import 'package:mini_shop_app/features/cart/widgets/cart_item.dart';
import 'package:mini_shop_app/features/orders/controllers/order_controller.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});
  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _isOrdering = false;

  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: cartAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text("Oops $error")),
        data: (cartState) {
          final cartItemsList = cartState.items.values.toList();
          final totalAmount = cartState.totalAmount;

          return Column(
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
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                        label: Text('\$${totalAmount.toStringAsFixed(2)}'),
                      ),
                      TextButton(
                        // 3. Disable the button if cart is empty OR currently ordering
                        onPressed: (cartItemsList.isEmpty || _isOrdering)
                            ? null
                            : () async {
                                setState(() {
                                  _isOrdering = true;
                                });

                                try {
                                  // 4. Clean async/await (No more .then!)
                                  await ref
                                      .read(orderControllerProvider.notifier)
                                      .addOrder(cartItemsList, totalAmount);

                                  // Wait for the order to succeed, THEN clear the cart
                                  await ref
                                      .read(cartControllerProvider.notifier)
                                      .clear();
                                } on DioException catch (e) {
                                  final message = e.error.toString();
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                } finally {
                                  if (context.mounted) {
                                    setState(() {
                                      _isOrdering = false;
                                    });
                                  }
                                }
                              },
                        child: _isOrdering
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Order Now",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // If it's disabled (onPressed is null), Flutter automatically
                                  // changes this color to grey for you!
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
                  itemCount: cartItemsList.length,
                  itemBuilder: (ctx, index) =>
                      CartItem(cartItem: cartItemsList[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
