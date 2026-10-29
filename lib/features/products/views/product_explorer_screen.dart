import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/features/products/controllers/filter_provider.dart';
import 'package:mini_shop_app/features/products/widgets/explorer_product_card.dart';
import 'package:mini_shop_app/features/products/widgets/filter_drawer.dart';
import 'package:mini_shop_app/features/products/widgets/product_item.dart';

class ProductExplorerScreen extends ConsumerWidget {
  const ProductExplorerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(filteredProductsControllerProvider);
    final currentFilters = ref.watch(filterControllerProvider);
    return Scaffold(
      endDrawer: FilterDrawer(),
      appBar: AppBar(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(9),
          ),
          child: TextField(
            textInputAction: TextInputAction.done,
            controller: TextEditingController(text: currentFilters.searchQuery),
            autofocus:
                currentFilters.searchQuery.isEmpty &&
                currentFilters.category == 'All',
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              hintText:
                  'Search ${currentFilters.category == 'All' ? 'products' : currentFilters.category}..',
              border: InputBorder.none,
            ),
            onSubmitted: (value) =>
                ref.read(filterControllerProvider.notifier).setQuery(value),
          ),
        ),
        actions: [
          Builder(
            builder: ((ctx) => IconButton(
              onPressed: () => Scaffold.of(ctx).openEndDrawer(),
              icon: const Icon(Icons.tune),
            )),
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(child: Text("No products found."))
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: products.length,
              itemBuilder: (ctx, index) =>
                  ExplorerProductCard(product: products[index]),
            ),
    );
  }
}
