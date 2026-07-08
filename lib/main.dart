import 'package:flutter/material.dart';
import 'package:mini_shop_app/config/theme.dart';
import 'package:mini_shop_app/config/util.dart';
import 'package:mini_shop_app/screens/product_detail_screen.dart';
import 'package:mini_shop_app/screens/products_overview_screen.dart';

void main() {
  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(context, "Lato", "Anton");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Shop',
      theme: brightness == Brightness.light
          ? theme.light().copyWith(
              appBarTheme: AppBarTheme(
                backgroundColor: MaterialTheme.lightScheme().primary,
                foregroundColor: MaterialTheme.lightScheme().onPrimary,
              ),
            )
          : theme.darkHighContrast().copyWith(
              appBarTheme: AppBarTheme(
                backgroundColor: MaterialTheme.darkHighContrastScheme().primary,
                foregroundColor:
                    MaterialTheme.darkHighContrastScheme().onPrimary,
              ),
            ),
      routes: {
        ProductsOverviewScreen.routeName: (context) => ProductsOverviewScreen(),
        ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
      },
    );
  }
}
