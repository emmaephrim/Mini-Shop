// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/models/product.dart';
import 'package:mini_shop_app/providers/product_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  static const routeName = "/product-detail";
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.read(productsProvider.notifier);

    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final Product product = products.findById(productId);
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Placeholder(),
    );
  }
}
