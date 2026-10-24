import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/utils/logger.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
import 'package:mini_shop_app/features/products/models/product.dart';
import 'package:mini_shop_app/features/products/services/product_service.dart';

final productsControllerProvider =
    AsyncNotifierProvider<ProductControllerNotifier, List<Product>>(
      ProductControllerNotifier.new,
    );

class ProductControllerNotifier extends AsyncNotifier<List<Product>> {
  // Because it returns a Future, Riverpod automatically sets the state
  // to AsyncValue.loading() for me until this finishes
  @override
  FutureOr<List<Product>> build() async {
    try {
      return await ref.read(productServiceProvider).fetchProducts();
    } catch (error, stackTrace) {
      logger.e(
        'Failed to fetch products',
        error: error,
        stackTrace: stackTrace,
      );
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  // Helper method to safely get the current list of products
  List<Product> get _currentList => state.value ?? [];

  // ====== Add Product
  Future<void> addProduct(Product product) async {
    try {
      final currentUser = ref.read(authServiceProvider).currentUser;
      final token = await currentUser?.getIdToken();
      if (token == null) throw Exception('Security token missing');

      final newId = await ref
          .read(productServiceProvider)
          .addProduct(product.copyWith(sellerId: currentUser!.uid), token);
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
      final token = await ref
          .read(authServiceProvider)
          .currentUser
          ?.getIdToken();
      await ref
          .read(productServiceProvider)
          .toggleFavoriteStatus(id, newFavoriteStatus, token);
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
