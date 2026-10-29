// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:mini_shop_app/features/products/models/sort_option.dart';

class FilterState {
  final String searchQuery;
  final String category;
  final double minPrice;
  final double maxPrice;
  final SortOption sortOption;

  FilterState({
    this.searchQuery = '',
    this.category = 'All',
    this.minPrice = 0,
    this.maxPrice = 10000,
    this.sortOption = SortOption.newest,
  });

  FilterState copyWith({
    String? searchQuery,
    String? category,
    double? minPrice,
    double? maxPrice,
    SortOption? sortOption,
  }) {
    return FilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
