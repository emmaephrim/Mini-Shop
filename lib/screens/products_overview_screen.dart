import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/constants/filter_options.dart';
import 'package:mini_shop_app/providers/show_favorite_only_provider.dart';
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
          IconButton(
            onPressed: () {},
            icon: Badge.count(
              textColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.scrim,
              count: 2,
              child: const Icon(Icons.shopping_cart),
            ),
          ),

          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text("Only Favorites"),
              ),
              PopupMenuItem(value: FilterOptions.all, child: Text('Show All')),
            ],
            onSelected: ((FilterOptions selectedValue) => {
              if (selectedValue == FilterOptions.favorites)
                {ref.read(showFavoritesOnlyProvider.notifier).state = true}
              else
                {ref.read(showFavoritesOnlyProvider.notifier).state = false},
            }),
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ProductsGrid(),
      drawer: Drawer(),
    );
  }
}
