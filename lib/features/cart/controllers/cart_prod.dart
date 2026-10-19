import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/utils/logger.dart';
import 'package:mini_shop_app/features/cart/models/cart.dart';
import 'package:mini_shop_app/features/cart/models/cart_state.dart';
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

  String get baseUrl => dotenv.env['FIREBASE_DB_URL']!;

  Future<Map<String, Cart>> fetchAndSetCart() async {
    try {
      var res = await http.get(Uri.https(baseUrl, 'cart.json'));

      final decoded = json.decode(res.body) as Map<String, dynamic>?;
      if (decoded == null) {
        state = CartState(items: {});
        return {};
      }

      var data = decoded.map(
        (key, value) =>
            MapEntry(key, Cart.fromMap(value as Map<String, dynamic>)),
      );
      state = CartState(items: data);
      return data;
    } catch (error, stackTrace) {
      logger.e('Fetching cart failed', error: error, stackTrace: stackTrace);

      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> addItem(String productId, double price, String title) async {
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
    } catch (error, stackTrace) {
      logger.e('Add item to cart failed', error: error, stackTrace: stackTrace);
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);

      state.items = currentItems;
      rethrow;
    }
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

  Future<void> clear() async {
    try {
      state = CartState(items: {});
      await http.delete(Uri.https(baseUrl, 'cart.json'));
    } catch (error, stackTrace) {
      logger.e('Clearing cart failed', error: error, stackTrace: stackTrace);
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }
}
