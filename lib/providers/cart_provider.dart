import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/models/cart.dart';
import 'package:mini_shop_app/models/cart_state.dart';
import 'package:http/http.dart' as http;

final cartProvider = NotifierProvider<CartProvider, CartState>(
  CartProvider.new,
);

class CartProvider extends Notifier<CartState> {
  @override
  CartState build() {
    fetchAndSetCart().then((items) {
      state = CartState(items: items);
    });
    return CartState(items: {});
  }

  final String baseUrl =
      'mini-shop-flutter-default-rtdb.asia-southeast1.firebasedatabase.app';
  bool loading = false;

  Future<Map<String, Cart>> fetchAndSetCart() async {
    try {
      var res = await http.get(Uri.https(baseUrl, 'cart.json'));

      final decoded = json.decode(res.body) as Map<String, dynamic>?;
      if (decoded == null) {
        return {};
      }

      var data = decoded.map(
        (key, value) =>
            MapEntry(key, Cart.fromMap(value as Map<String, dynamic>)),
      );
      developer.log(data.toString(), name: 'Cart server data:');
      return data;
    } catch (e) {
      developer.log(e.toString(), name: 'fetchAndSetCart error:');
      rethrow;
    }
  }

  Future<void> addItem(String productId, double price, String title) async {
    loading = true;
    final currentItems = state.items;
    try {
      if (currentItems.containsKey(productId)) {
        final existingCart = currentItems[productId]!;
        final newQuantity = existingCart.quantity + 1;

        state = CartState(
          items: {
            ...currentItems,
            productId: existingCart.copyWith(quantity: newQuantity),
          },
        );
        await http.patch(
          Uri.https(baseUrl, 'cart/$productId.json'),
          body: json.encode({'quantity': newQuantity}),
        );
      } else {
        final newItem = Cart(
          id: productId,
          title: title,
          quantity: 1,
          price: price,
        );
        state = CartState(items: {...currentItems, productId: newItem});

        await http.put(
          Uri.https(baseUrl, 'cart/$productId.json'),
          body: newItem.toJson(),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      state.items = currentItems;
      rethrow;
    } finally {
      loading = false;
    }
  }

  void removeItem(String key) {
    final currentItems = state.items;
    currentItems.remove(key);
    state = CartState(items: currentItems);
  }

  void removeSingleItem(String key) {
    if (!state.items.containsKey(key)) {
      return;
    }

    final existingCart = state.items[key]!;

    if (existingCart.quantity > 1) {
      state = CartState(
        items: {
          ...state.items,
          key: existingCart.copyWith(quantity: existingCart.quantity - 1),
        },
      );
    } else {
      final updatedItems = {...state.items};
      updatedItems.remove(key);
      state = CartState(items: updatedItems);
    }
  }

  void clear() {
    state = CartState(items: {});
  }
}
