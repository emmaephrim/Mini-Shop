import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/constants/filter_options.dart';
import 'package:mini_shop_app/providers/auth_controller.dart';
import 'package:mini_shop_app/providers/cart_provider.dart';
import 'package:mini_shop_app/providers/show_favorite_only_provider.dart';
import 'package:mini_shop_app/screens/cart_screen.dart';
import 'package:mini_shop_app/widgets/app_drawer.dart';
import 'package:mini_shop_app/widgets/products_grid.dart';

class ProductsOverviewScreen extends ConsumerStatefulWidget {
  static const routeName = '/products-overview';

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
            onPressed: () =>
                Navigator.of(context).pushNamed(CartScreen.routeName),
            icon: Badge.count(
              textStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              textColor: Theme.of(context).colorScheme.onErrorContainer,
              backgroundColor: Theme.of(context).colorScheme.errorContainer,
              count: ref.watch(
                cartProvider.select((list) => list.items.length),
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
                {ref.read(showFavoritesOnlyProvider.notifier).state = true}
              else
                {ref.read(showFavoritesOnlyProvider.notifier).state = false},
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
                  } catch (e) {
                    debugPrint('sign out error: ${e.toString()}');
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Something went wrong $e")),
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
