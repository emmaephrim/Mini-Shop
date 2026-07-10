import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/widgets/products_grid.dart';

class ProductsOverviewScreen extends ConsumerWidget {
  static const routeName = '/';

  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MiniShop'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
        ],
      ),
      body: ProductsGrid(),
      drawer: Drawer(),
    );
  }
}
