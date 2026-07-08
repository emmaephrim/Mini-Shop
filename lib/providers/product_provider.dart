import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/data/products.dart';
import 'package:mini_shop_app/models/product.dart';

final productsProvider = NotifierProvider<ProductNotifier, List<Product>>(
  ProductNotifier.new,
);

class ProductNotifier extends Notifier<List<Product>> {
  @override
  build() => products;
}
