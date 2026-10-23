import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/config/routes/app_routes.dart';
import 'package:mini_shop_app/core/widgets/app_drawer.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
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
    final user = ref.watch(authServiceProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('MiniShop'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              if (user == null) {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 50,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Sign in to add items to your cart",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.pushNamed(AppRoute.auth.name);
                          },
                          child: const Text("Login In / Register"),
                        ),
                      ],
                    ),
                  ),
                );
                return;
              }
              context.pushNamed(AppRoute.cart.name);
            },
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
        ],
      ),
      body: ProductsGrid(),
      drawer: AppDrawer(),
    );
  }
}
