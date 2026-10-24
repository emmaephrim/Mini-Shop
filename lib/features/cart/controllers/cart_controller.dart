import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/utils/logger.dart';
import 'package:mini_shop_app/features/cart/models/cart.dart';
import 'package:mini_shop_app/features/cart/models/cart_state.dart';
import 'package:mini_shop_app/features/cart/services/cart_service.dart';

final cartControllerProvider =
    AsyncNotifierProvider<CartControllerNotifier, CartState>(
      CartControllerNotifier.new,
    );

class CartControllerNotifier extends AsyncNotifier<CartState> {
  @override
  FutureOr<CartState> build() async {
    try {
      return await ref.read(cartServiceProvider).fetchCart();
    } catch (error, stackTrace) {
      logger.e("Failed to fetch cart", error: error, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  CartState get _currentMap => state.value ?? CartState(items: {});

  Future<void> addItem(String productId, double price, String title) async {
    final previousState = state;

    try {
      if (_currentMap.items.containsKey(productId)) {
        final existingCart = _currentMap.items[productId]!;
        final newQuantity = existingCart.quantity + 1;

        state = AsyncValue.data(
          CartState(
            items: {
              ..._currentMap.items,
              productId: existingCart.copyWith(quantity: newQuantity),
            },
          ),
        );
        await ref
            .read(cartServiceProvider)
            .updateItemQuantity(productId, newQuantity);
      } else {
        final newItem = Cart(
          id: productId,
          title: title,
          quantity: 1,
          price: price,
        );

        state = AsyncValue.data(
          CartState(items: {..._currentMap.items, productId: newItem}),
        );
        await ref.read(cartServiceProvider).addNewItem(newItem);
      }
    } catch (error, stackTrace) {
      state = previousState;
      logger.e(
        'Add new item to cart failed',
        error: error,
        stackTrace: stackTrace,
      );
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> clear() async {
    final previousState = state;
    state = AsyncValue.data(CartState(items: {}));
    try {
      await ref.read(cartServiceProvider).clear();
    } catch (error, stackTrace) {
      state = previousState;
      logger.e('Clearing cart error', error: error, stackTrace: stackTrace);
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  // ================= REMOVE ENTIRE ITEM (Swipe to delete) =================
  Future<void> removeItem(String productId) async {
    final previousState = state;

    // Instantly remove it from the UI map
    final updatedItems = {..._currentMap.items};
    updatedItems.remove(productId);
    state = AsyncValue.data(CartState(items: updatedItems));

    try {
      await ref.read(cartServiceProvider).removeItem(productId);
    } catch (error, stackTrace) {
      state = previousState; // Rollback
      logger.e('Removing item failed', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  // ================= REMOVE SINGLE ITEM (Clicking "UNDO" on a Snackbar) =================
  Future<void> removeSingleItem(String productId) async {
    if (!_currentMap.items.containsKey(productId)) return;

    final previousState = state;
    final existingCart = _currentMap.items[productId]!;

    try {
      if (existingCart.quantity > 1) {
        // Decrease quantity by 1 instantly
        final newQuantity = existingCart.quantity - 1;
        state = AsyncValue.data(
          CartState(
            items: {
              ..._currentMap.items,
              productId: existingCart.copyWith(quantity: newQuantity),
            },
          ),
        );
        await ref
            .read(cartServiceProvider)
            .updateItemQuantity(productId, newQuantity);
      } else {
        // Quantity is 1, so remove it entirely
        final updatedItems = {..._currentMap.items};
        updatedItems.remove(productId);
        state = AsyncValue.data(CartState(items: updatedItems));

        await ref.read(cartServiceProvider).removeItem(productId);
      }
    } catch (error, stackTrace) {
      state = previousState; // Rollback
      logger.e(
        'Removing single item failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
