import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/data/products.dart';
import 'package:mini_shop_app/models/product.dart';

final productsProvider = NotifierProvider<ProductNotifier, List<Product>>(
  ProductNotifier.new,
);

class ProductNotifier extends Notifier<List<Product>> {
  @override
  build() => products;

  void addProduct(Product product) {
    state = [...state, product];
  }

  Product findById(String id) => state.firstWhere((item) => item.id == id);

  void toggleFavoriteStatus(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(isFavorite: !item.isFavorite)
        else
          item,
    ];
  }

  void updateProduct(Product product) {
    state = [
      for (final item in state)
        if (item.id == product.id) product else item,
    ];
  }

  void deleteProductById(String id) {
    // create a new list and remove the matching item for clarity
    final updated = List<Product>.from(state)
      ..removeWhere((item) => item.id == id);
    state = updated;
  }
}
