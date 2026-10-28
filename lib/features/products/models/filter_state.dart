class FilterState {
  final String category;
  final double minPrice;
  final double maxPrice;

  FilterState({
    this.category = 'All',
    this.minPrice = 0,
    this.maxPrice = 10000,
  });

  FilterState copyWith({String? category, double? minPrice, double? maxPrice}) {
    return FilterState(
      category: category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }
}
