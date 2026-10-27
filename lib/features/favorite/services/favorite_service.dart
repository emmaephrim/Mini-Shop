import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/network/dio_provider.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
import 'package:mini_shop_app/features/favorite/models/user_favorite.dart';

final favoriteServiceProvider = Provider<FavoriteService>((ref) {
  final userId = ref.watch(authServiceProvider).currentUser!.uid;
  return FavoriteService(dio: ref.read(dioProvider), uid: userId);
});

class FavoriteService {
  final Dio _dio;
  final String _uid;
  FavoriteService({required this._dio, required this._uid});

  Future<UserFavorite> fetchFavorites() async {
    final response = await _dio.get('/userFavorites/$_uid.json');
    if (response.data == null) return UserFavorite(productIds: {});
    final data = response.data as Map<String, dynamic>;
    return UserFavorite(productIds: data.keys.toSet());
  }

  Future<void> toggleFavorite(String productId, bool isFavorite) async {
    final url = '/userFavorites/$_uid/$productId.json';

    if (isFavorite) {
      _dio.put(url, data: {productId: isFavorite});
    } else {
      _dio.delete(url);
    }
  }
}
