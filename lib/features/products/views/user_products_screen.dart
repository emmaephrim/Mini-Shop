import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/features/products/controllers/product_controller.dart';
import 'package:mini_shop_app/features/products/views/edit_product_screen.dart';
import 'package:mini_shop_app/core/widgets/app_drawer.dart';
import 'package:mini_shop_app/features/products/widgets/user_product_item.dart';

class UserProductsScreen extends ConsumerWidget {
  static const routeName = '/user-products-screen';

  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: asyncProducts.when(
          data: (products) {
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: ((context, index) => Column(
                children: [
                  UserProductItem(product: products[index]),
                  Divider(),
                ],
              )),
            );
          },
          error: (error, stackTrace) => Text('Something went wrong! \n$error'),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
