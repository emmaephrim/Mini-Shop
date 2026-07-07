import 'package:flutter/material.dart';
import 'package:mini_shop_app/screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Shop',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.amberAccent),
        appBarTheme: AppBarTheme(backgroundColor: Colors.amber),
      ),
      routes: {'/': (context) => ProductsOverviewScreen()},
    );
  }
}
