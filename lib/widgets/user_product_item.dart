import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/providers/product_provider.dart';
import 'package:mini_shop_app/screens/edit_product_screen.dart';

class UserProductItem extends ConsumerWidget {
  final String id;

  const UserProductItem({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref
        .watch(productsProvider)
        .firstWhere((element) => element.id == id);

    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(
                context,
              ).pushNamed(EditProductScreen.routeName, arguments: id),
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
