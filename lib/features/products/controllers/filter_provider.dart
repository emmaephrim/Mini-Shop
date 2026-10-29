// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/features/products/controllers/product_controller.dart';
import 'package:mini_shop_app/features/products/models/filter_state.dart';
import 'package:mini_shop_app/features/products/models/product.dart';
import 'package:mini_shop_app/features/products/models/sort_option.dart';

final filterControllerProvider =
    NotifierProvider<FilterController, FilterState>(FilterController.new);

class FilterController extends Notifier<FilterState> {
  @override
  FilterState build() => FilterState();

  void setQuery(String query) => state = state.copyWith(searchQuery: query);
  void setCategory(String category) =>
      state = state.copyWith(category: category);
  void setPriceRange(double min, double max) =>
      state = state.copyWith(minPrice: min, maxPrice: max);
  void setSortOption(SortOption option) =>
      state = state.copyWith(sortOption: option);
  // Used when navigating from home screen to present the Exp screen
  void initializeExplorer({String query = '', String category = 'All'}) {
    state = FilterState(searchQuery: query, category: category);
  }

  void reset() => state = FilterState();
}

final filteredProductsControllerProvider = Provider<List<Product>>((ref) {
  final rawProducts = ref.watch(productsControllerProvider).value ?? [];
  final filters = ref.watch(filterControllerProvider);

  final filtered = rawProducts.where((product) {
    final matchesCategory =
        filters.category == 'All' || product.category == filters.category;
    final matchesPrice =
        product.price >= filters.minPrice && product.price <= filters.maxPrice;
    final matchesSearch =
        filters.searchQuery.isEmpty ||
        product.title.toLowerCase().contains(filters.searchQuery.toLowerCase());

    return matchesCategory && matchesPrice && matchesSearch;
  }).toList();

  final sortedList = [...filtered];
  sortedList.sort((a, b) {
    switch (filters.sortOption) {
      case SortOption.priceAsc:
        return a.price.compareTo(b.price);
      case SortOption.priceDsc:
        return b.price.compareTo(a.price);
      case SortOption.topReview:
        return b.reviewCount.compareTo(a.reviewCount);
      case SortOption.oldest:
        return a.createdAt.compareTo(b.createdAt);
      case SortOption.newest:
        return b.createdAt.compareTo(a.createdAt);
    }
  });

  return sortedList;
});
