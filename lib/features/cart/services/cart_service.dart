import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:mini_shop_app/features/cart/models/cart.dart';
import 'package:mini_shop_app/features/cart/models/cart_state.dart';

final cartServiceProvider = Provider<CartService>((ref) => CartService());

class CartService {
  String get baseUrl => dotenv.env['FIREBASE_DB_URL']!;

  Future<CartState> fetchCart() async {
    final res = await http.get(Uri.https(baseUrl, 'cart.json'));

    final decoded = json.decode(res.body) as Map<String, dynamic>?;
    if (decoded == null) {
      return CartState(items: {});
    }

    final data = decoded.map(
      (key, value) =>
          MapEntry(key, Cart.fromMap(value as Map<String, dynamic>)),
    );
    return CartState(items: data);
  }

  Future<void> addNewItem(Cart cart) async {
    await http.put(
      Uri.https(baseUrl, 'cart/${cart.id}.json'),
      body: cart.toJson(),
    );
  }

  Future<void> updateItemQuantity(String productId, int quantity) async {
    await http.patch(
      Uri.https(baseUrl, 'cart/$productId.json'),
      body: json.encode({'quantity': quantity}),
    );
  }

  Future<void> clear() async {
    await http.delete(Uri.https(baseUrl, 'cart.json'));
  }

  // Deletes one specific product from the cart in the database
  Future<void> removeItem(String productId) async {
    await http.delete(Uri.https(baseUrl, 'cart/$productId.json'));
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
