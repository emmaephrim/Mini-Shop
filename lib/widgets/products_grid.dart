import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/providers/cart_provider.dart';
import 'package:mini_shop_app/providers/filtered_product_provider.dart';
import 'package:mini_shop_app/providers/product_controller.dart';
import 'package:mini_shop_app/widgets/product_item.dart';

class ProductsGrid extends ConsumerWidget {
  const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(filteredProductsProvider);

    return asyncProducts.when(
      data: (products) {
        // Only build the Grid and RefreshIndicator if we have actual data
        return RefreshIndicator(
          onRefresh: () async {
            // Industry standard refresh: Invalidate the providers!
            // This destroys the old data and triggers their build() methods again.
            ref.invalidate(productsProvider);
            ref.invalidate(cartProvider);

            // Wait for both of them to finish loading the new data
            // before the RefreshIndicator spinning circle disappears
            await ref.read(productsProvider.future);
            // await ref.read(cartProvider.future);
          },
          child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: ((ctx, index) =>
                ProductItem(product: products[index])),
          ),
        );
      },
      error: (error, stackTrace) =>
          Center(child: Text('Something went wrong! \n$error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
