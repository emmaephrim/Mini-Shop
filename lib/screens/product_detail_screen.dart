// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mini_shop_app/data/products.dart';
import 'package:mini_shop_app/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final Product product = products.firstWhere((item) => item.id == productId);
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Placeholder(),
    );
  }
}
