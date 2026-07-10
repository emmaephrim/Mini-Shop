import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/data/products.dart';
import 'package:mini_shop_app/models/product.dart';

final productsProvider = NotifierProvider<ProductNotifier, List<Product>>(
  ProductNotifier.new,
);

class ProductNotifier extends Notifier<List<Product>> {
  @override
  build() => products;

  bool showFavoritesOnly = false;

  List<Product> get items {
    if (showFavoritesOnly) {
      return state.where((item) => item.isFavorite == true).toList();
    }
    return state;
  }

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
}
