import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/providers/product_provider.dart';
import 'package:mini_shop_app/widgets/app_drawer.dart';
import 'package:mini_shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends ConsumerWidget {
  static const routeName = '/user-products-screen';

  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your products"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: ((context, index) =>
              UserProductItem(id: products[index].id)),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
