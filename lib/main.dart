import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/config/theme.dart';
import 'package:mini_shop_app/config/util.dart';
import 'package:mini_shop_app/providers/theme_mode_provider.dart';
import 'package:mini_shop_app/screens/cart_screen.dart';
import 'package:mini_shop_app/screens/orders_screen.dart';
import 'package:mini_shop_app/screens/product_detail_screen.dart';
import 'package:mini_shop_app/screens/products_overview_screen.dart';

void main() {
  runApp(ProviderScope(child: const ShopApp()));
}

class ShopApp extends ConsumerWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);

    TextTheme textTheme = createTextTheme(context, "Lato", "Anton");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Shop',
      theme: theme.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: MaterialTheme.lightScheme().primary,
          foregroundColor: MaterialTheme.lightScheme().onPrimary,
        ),
      ),
      darkTheme: theme.darkHighContrast().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: MaterialTheme.darkHighContrastScheme().primary,
          foregroundColor: MaterialTheme.darkHighContrastScheme().onPrimary,
        ),
      ),
      themeMode: currentThemeMode,
      routes: {
        ProductsOverviewScreen.routeName: (context) => ProductsOverviewScreen(),
        ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        CartScreen.routeName: (context) => CartScreen(),
        OrdersScreen.routeName: (context) => OrdersScreen(),
      },
    );
  }
}
