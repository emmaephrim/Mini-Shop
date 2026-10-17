import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_controller.dart';
import 'package:mini_shop_app/features/orders/views/orders_screen.dart';
import 'package:mini_shop_app/features/products/views/products_overview_screen.dart';
import 'package:mini_shop_app/features/products/views/user_products_screen.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Drawer(
      // backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: Text("Hello Friend!"),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            onTap: () => context.goNamed(ProductsOverviewScreen.routeName),
            leading: Icon(Icons.shop_2),
            title: Text("Shop"),
          ),
          Divider(),
          ListTile(
            onTap: () => context.goNamed(OrdersScreen.routeName),
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text("Orders"),
          ),
          Divider(),
          ListTile(
            onTap: () => context.goNamed(UserProductsScreen.routeName),
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
          ),
          Divider(),
          ListTile(
            onTap: () {
              if (authState.isLoading) return;
              ref.read(authControllerProvider.notifier).signOut();
            },
            leading: const Icon(Icons.exit_to_app),
            title: Text("Logout"),
            trailing: authState.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),
          Divider(),
        ],
      ),
    );
  }
}
