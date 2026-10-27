import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/features/favorite/controllers/favorites_controller.dart';
import 'package:mini_shop_app/features/products/models/product.dart';
import 'package:mini_shop_app/features/products/controllers/product_controller.dart';
import 'package:mini_shop_app/features/products/controllers/show_favorite_only_provider.dart';

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final asyncProducts = ref.watch(productsControllerProvider);
  final showFavoritesOnly = ref.watch(showFavoritesOnlyProvider);
  final favorites = ref.watch(favoritesController).value?.productIds;

  // .whenData automatically passes loading/error states straight to the UI,
  // but lets you filter the data if it was a success
  return asyncProducts.whenData((products) {
    if (showFavoritesOnly && favorites != null) {
      return products.where((p) => favorites.contains(p.id)).toList();
    }
    return products;
  });
});
