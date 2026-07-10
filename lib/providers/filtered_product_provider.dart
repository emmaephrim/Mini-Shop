import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/models/product.dart';
import 'package:mini_shop_app/providers/show_favorite_only_provider.dart';
import './product_provider.dart';

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final allProducts = ref.watch(productsProvider);

  final showFavoritesOnly = ref.watch(showFavoritesOnlyProvider);

  if (showFavoritesOnly) {
    return allProducts.where((item) => item.isFavorite == true).toList();
  }

  return allProducts;
});
