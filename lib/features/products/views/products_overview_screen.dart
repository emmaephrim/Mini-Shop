import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/config/routes/app_routes.dart';
import 'package:mini_shop_app/core/widgets/app_drawer.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_controller.dart';
import 'package:mini_shop_app/features/cart/controllers/cart_controller.dart';
import 'package:mini_shop_app/features/products/controllers/show_favorite_only_provider.dart';
import 'package:mini_shop_app/features/products/models/filter_options.dart';
import 'package:mini_shop_app/features/products/widgets/products_grid.dart';

class ProductsOverviewScreen extends ConsumerStatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  ConsumerState<ProductsOverviewScreen> createState() =>
      _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState
    extends ConsumerState<ProductsOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MiniShop'),
        actions: [
          IconButton(
            onPressed: () => context.pushNamed(AppRoute.cart.name),
            icon: Badge.count(
              textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              textColor: Theme.of(context).colorScheme.onErrorContainer,
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              count: ref.watch(
                cartControllerProvider.select(
                  (list) => list.value?.items.length ?? 0,
                ),
              ),
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
                {ref.read(showFavoritesOnlyProvider.notifier).showFavorites()}
              else
                {ref.read(showFavoritesOnlyProvider.notifier).showAll()},
            }),
            icon: Icon(Icons.more_vert),
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(right: 10.0),
            child: CircleAvatar(
              child: IconButton(
                onPressed: () async {
                  try {
                    await ref.read(authControllerProvider.notifier).signOut();
                  } catch (error) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Something went wrong!")),
                    );
                  }
                },
                icon: Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
      body: ProductsGrid(),
      drawer: AppDrawer(),
    );
  }
}
