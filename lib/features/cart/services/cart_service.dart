import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/network/dio_provider.dart';
import 'package:mini_shop_app/features/cart/models/cart.dart';
import 'package:mini_shop_app/features/cart/models/cart_state.dart';

final cartServiceProvider = Provider<CartService>(
  (ref) => CartService(dio: ref.read(dioProvider)),
);

class CartService {
  final Dio _dio;
  CartService({required this._dio});

  Future<CartState> fetchCart() async {
    final res = await _dio.get('/cart.json');

    if (res.data == null) {
      return CartState(items: {});
    }
    final data = res.data as Map<String, dynamic>;

    final result = data.map(
      (key, value) =>
          MapEntry(key, Cart.fromMap(value as Map<String, dynamic>)),
    );
    return CartState(items: result);
  }

  Future<void> addNewItem(Cart cart) async {
    await _dio.put('/cart/${cart.id}.json', data: cart);
  }

  Future<void> updateItemQuantity(String productId, int quantity) async {
    await _dio.patch('/cart/$productId.json', data: {'quantity': quantity});
  }

  Future<void> clear() async {
    await _dio.delete('/cart.json');
  }

  // Deletes one specific product from the cart in the database
  Future<void> removeItem(String productId) async {
    await _dio.delete('/cart/$productId.json');
  }
  // void removeItem(String key) {
  //   final currentItems = state.items;
  //   currentItems.remove(key);
  //   state = CartState(items: currentItems);
  // }

  // void removeSingleItem(String key) {
  //   if (!state.items.containsKey(key)) {
  //     return;
  //   }

  //   final existingCart = state.items[key]!;

  //   if (existingCart.quantity > 1) {
  //     state = CartState(
  //       items: {
  //         ...state.items,
  //         key: existingCart.copyWith(quantity: existingCart.quantity - 1),
  //       },
  //     );
  //   } else {
  //     final updatedItems = {...state.items};
  //     updatedItems.remove(key);
  //     state = CartState(items: updatedItems);
  //   }
  // }
}
