import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/providers/cart_provider.dart';

class CartItem extends ConsumerWidget {
  final String id;
  CartItem({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemInCart = ref.watch(cartProvider).items[id];

    if (itemInCart == null) return const SizedBox.shrink();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          subtitle: Text(
            'Total: \$${(itemInCart.price * itemInCart.quantity).toStringAsFixed(2)}',
          ),
          title: Text(itemInCart.title),
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: FittedBox(child: Text('\$${itemInCart.price}')),
            ),
          ),
          trailing: Text('${itemInCart.quantity} x'),
          //   trailing: ListTile(
          //     title: Text('${itemInCart.quantity} x'),
          //     leading: IconButton(onPressed: () {}, icon: Icon(Icons.minimize)),
          //     trailing: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
          //   ),
        ),
      ),
    );
  }
}
