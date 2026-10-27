import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/utils/logger.dart';
import 'package:mini_shop_app/features/favorite/models/user_favorite.dart';
import 'package:mini_shop_app/features/favorite/services/favorite_service.dart';

final favoritesController =
    AsyncNotifierProvider<FavoritesControllerNotifier, UserFavorite>(
      FavoritesControllerNotifier.new,
    );

class FavoritesControllerNotifier extends AsyncNotifier<UserFavorite> {
  @override
  FutureOr<UserFavorite> build() async {
    try {
      return await ref.read(favoriteServiceProvider).fetchFavorites();
    } catch (error, stackTrace) {
      logger.e(
        'Failed to fetch user favorites',
        error: error,
        stackTrace: stackTrace,
      );
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> toggleFavorite(String productId) async {
    final currentFavorites = state.value ?? UserFavorite(productIds: {});
    final isCurrentFavorite = currentFavorites.productIds.contains(productId);

    final newFavorites = Set<String>.from(currentFavorites.productIds);
    if (isCurrentFavorite) {
      newFavorites.remove(productId);
    } else {
      newFavorites.add(productId);
    }
    state = AsyncValue.data(UserFavorite(productIds: newFavorites));
    try {
      await ref
          .read(favoriteServiceProvider)
          .toggleFavorite(productId, !isCurrentFavorite);
    } catch (error, stackTrace) {
      state = AsyncValue.data(currentFavorites);
      logger.e(
        'Failed to add product to favorites',
        error: error,
        stackTrace: stackTrace,
      );
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }
}
