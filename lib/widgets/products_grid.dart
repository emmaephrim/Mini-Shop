import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/providers/cart_provider.dart';
import 'package:mini_shop_app/providers/filtered_product_provider.dart';
import 'package:mini_shop_app/providers/product_provider.dart';
import 'package:mini_shop_app/widgets/product_item.dart';

class ProductsGrid extends ConsumerStatefulWidget {
  const ProductsGrid({super.key});

  @override
  ConsumerState<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends ConsumerState<ProductsGrid> {
  bool _isInitLoading = false;
  @override
  void initState() {
    super.initState();
    _isInitLoading = true;
    Future.wait([
      ref.read(productsProvider.notifier).fetchAndSetProducts(),
      ref.read(cartProvider.notifier).fetchAndSetCart(),
    ]).then((_) {
      setState(() {
        _isInitLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(filteredProductsProvider);

    return _isInitLoading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                ref.read(productsProvider.notifier).fetchAndSetProducts(),
                ref.read(cartProvider.notifier).fetchAndSetCart(),
              ]);
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (ctx, index) => ProductItem(id: products[index].id),
            ),
          );
  }
}
