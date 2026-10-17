import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/config/routes/app_routes.dart';
import 'package:mini_shop_app/features/products/controllers/product_controller.dart';
import 'package:mini_shop_app/features/products/models/product.dart';

class UserProductItem extends ConsumerStatefulWidget {
  final Product product;

  const UserProductItem({super.key, required this.product});

  @override
  ConsumerState<UserProductItem> createState() => _UserProductItemState();
}

class _UserProductItemState extends ConsumerState<UserProductItem> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(backgroundImage: NetworkImage(product.imageUrl)),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () => context.pushNamed(
                AppRoute.editProduct.name,
                pathParameters: {'id': product.id},
              ),
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            _isLoading
                ? CircularProgressIndicator()
                : IconButton(
                    onPressed: () =>
                        //   ref.read(productsProvider.notifier).deleteProductById(id),
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Are you sure?"),
                              content: Text(
                                "Do you want to delete this product?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => context.pop(),
                                  child: Text("No"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    try {
                                      if (!context.mounted) return;
                                      context.pop();

                                      await ref
                                          .read(productsProvider.notifier)
                                          .deleteProductById(product.id)
                                          .then((_) {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          });
                                    } catch (error) {
                                      if (!context.mounted) return;
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text("An error occurred"),
                                          content: Text(
                                            "Something went wrong!",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                context.pop();
                                              },
                                              child: Text('Cancel'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },

                                  child: Text(
                                    "Yes",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                  ),
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
