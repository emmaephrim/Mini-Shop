import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/utils/logger.dart';
import 'package:mini_shop_app/features/products/models/product.dart';
import 'package:mini_shop_app/features/products/services/product_service.dart';

final productsProvider = AsyncNotifierProvider<ProductNotifier, List<Product>>(
  ProductNotifier.new,
);

class ProductNotifier extends AsyncNotifier<List<Product>> {
  // Because it returns a Future, Riverpod automatically sets the state
  // to AsyncValue.loading() for me until this finishes
  @override
  FutureOr<List<Product>> build() async {
    return await ref.read(productServiceProvider).fetchProducts();
  }

  // Helper method to safely get the current list of products
  List<Product> get _currentList => state.value ?? [];

  // ====== Add Product
  Future<void> addProduct(Product product) async {
    // I do not set state to loading here, because I want the user to
    // keep seeing the old products while the new one uploads
    try {
      final newId = await ref.read(productServiceProvider).addProduct(product);
      final Product newProduct = product.copyWith(id: newId);
      state = AsyncValue.data([..._currentList, newProduct]);
    } catch (error, stackTrace) {
      logger.e(
        "Add item to product failed",
        error: error,
        stackTrace: stackTrace,
      );
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  // ===== Find product by ID SYNCHRONOUS read
  Product findById(String id) =>
      _currentList.firstWhere((item) => item.id == id);

  // ===== Toggle Favorites Status (Optimistic update)
  Future<void> toggleFavoriteStatus(String id) async {
    final previousState = state;
    final Product productToToggle = findById(id);
    final bool newFavoriteStatus = !productToToggle.isFavorite;

    // Instantly update UI before the internet finishes (Optimistic update)
    state = AsyncValue.data([
      for (final item in _currentList)
        if (item.id == id)
          item.copyWith(isFavorite: newFavoriteStatus)
        else
          item,
    ]);

    try {
      await ref
          .read(productServiceProvider)
          .toggleFavoriteStatus(id, newFavoriteStatus);
    } catch (error, stackTrace) {
      state = previousState;
      logger.e('Toggle favorite failed', error: error, stackTrace: stackTrace);
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    final previousState = state;

    state = AsyncValue.data([
      for (final item in _currentList)
        if (item.id == product.id) product else item,
    ]);
    try {
      await ref.read(productServiceProvider).updateProduct(product);
    } catch (error, stackTrace) {
      state = previousState;
      logger.e('Update product failed', error: error, stackTrace: stackTrace);
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteProductById(String id) async {
    final previousState = state;

    final updateList = List<Product>.from(_currentList)
      ..removeWhere((item) => item.id == id);
    state = AsyncValue.data(updateList);
    try {
      await ref.read(productServiceProvider).deleteProduct(id);
    } catch (error, stackTrace) {
      state = previousState;
      logger.e('Deleting product failed', error: error, stackTrace: stackTrace);
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }
}
