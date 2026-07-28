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
              onPressed: () =>
                  //   ref.read(productsProvider.notifier).deleteProductById(id),
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Are you sure?"),
                        content: Text("Do you want to delete do product?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(productsProvider.notifier)
                                  .deleteProductById(id);
                              Navigator.of(context).pop();
                            },

                            child: Text("Yes"),
                          ),
                        ],
                      );
                    },
                  ),
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
