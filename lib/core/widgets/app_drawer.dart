import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/config/routes/app_routes.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_controller.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    ScaffoldMessenger.of(context).clearSnackBars();

    return Drawer(
      // backgroundColor: Theme.of(context).colorScheme.secondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: Text(
              ref.watch(authStateProvider).value?.email.toString() ??
                  "Hey there!",
            ),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            onTap: () => context.pushReplacementNamed(AppRoute.home.name),
            leading: Icon(Icons.shop_2),
            title: Text("Shop"),
          ),
          Divider(),
          ListTile(
            onTap: () => context.pushReplacementNamed(AppRoute.orders.name),
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text("Orders"),
          ),
          Divider(),
          ListTile(
            onTap: () =>
                context.pushReplacementNamed(AppRoute.userProducts.name),
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
