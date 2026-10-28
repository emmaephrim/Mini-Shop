// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/features/products/controllers/product_controller.dart';
import 'package:mini_shop_app/features/products/models/filter_state.dart';
import 'package:mini_shop_app/features/products/models/product.dart';

final filterControllerProvider =
    NotifierProvider<FilterController, FilterState>(FilterController.new);

class FilterController extends Notifier<FilterState> {
  @override
  FilterState build() => FilterState();

  void setCategory(String category) =>
      state = state.copyWith(category: category);
  void setPriceRange(double min, double max) =>
      state = state.copyWith(minPrice: min, maxPrice: max);
  void reset() => state = FilterState();
}

final filteredProductsControllerProvider = Provider<List<Product>>((ref) {
  final rawProducts = ref.watch(productsControllerProvider).value ?? [];
  final filters = ref.watch(filterControllerProvider);

  return rawProducts.where((product) {
    final matchesCategory =
        filters.category == 'All' || product.category == filters.category;
    final matchesPrice =
        product.price >= filters.minPrice && product.price <= filters.maxPrice;

    return matchesCategory && matchesPrice;
  }).toList();
});
