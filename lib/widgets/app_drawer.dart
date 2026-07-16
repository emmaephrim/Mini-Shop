import 'package:flutter/material.dart';
import 'package:mini_shop_app/screens/orders_screen.dart';
import 'package:mini_shop_app/screens/products_overview_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
            onTap: () => Navigator.of(
              context,
            ).pushReplacementNamed(ProductsOverviewScreen.routeName),
            leading: Icon(Icons.shop_2),
            title: Text("Shop"),
          ),
          Divider(),
          ListTile(
            onTap: () =>
                Navigator.of(context).pushNamed(OrdersScreen.routeName),
            leading: Icon(Icons.shopping_bag_outlined),
            title: Text("Orders"),
          ),
          Divider(),
          ListTile(
            onTap: () => Navigator.of(
              context,
            ).pushReplacementNamed(ProductsOverviewScreen.routeName),
            leading: Icon(Icons.payment),
            title: Text("Payments"),
          ),
          Divider(),
        ],
      ),
    );
  }
}
