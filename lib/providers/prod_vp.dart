/* import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/utils/logger.dart';
import 'package:mini_shop_app/models/http_exception.dart';
import 'package:mini_shop_app/models/product.dart';
import 'package:http/http.dart' as http;

final productsProvider = NotifierProvider<ProductNotifier, List<Product>>(
  ProductNotifier.new,
);

class ProductNotifier extends Notifier<List<Product>> {
  @override
  List<Product> build() {
    fetchAndSetProducts();
    return [];
  }

  final String baseUrl =
      'mini-shop-flutter-default-rtdb.asia-southeast1.firebasedatabase.app';

  // ============ Fetch and Set Products
  Future<List<Product>> fetchAndSetProducts() async {
    final currentState = state;

    try {
      final List<Product> loadedProducts = [];
      final res = await http.get(Uri.https(baseUrl, 'products.json'));
      final decoded = json.decode(res.body) as Map<String, dynamic>?;
      if (decoded == null) loadedProducts;

      decoded!.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'] ?? '',
            description: prodData['description'] ?? '',
            price: (prodData['price'] as num?)?.toDouble() ?? 0.0,
            imageUrl: prodData['imageUrl'] ?? '',
            isFavorite: prodData['isFavorite'] ?? false,
          ),
        );
      });

      state = loadedProducts;
      return loadedProducts;
    } catch (error, stackTrace) {
      state = currentState;

      logger.e(
        'Fetching products failed',
        error: error,
        stackTrace: stackTrace,
      );
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  //========== Add product
  Future<void> addProduct(Product product) async {
    final currentState = state;
    try {
      final res = await http.post(
        Uri.https(baseUrl, 'products.json'),
        body: json.encode({
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
          'price': product.price,
          'title': product.title,
        }),
      );
      state = [...state, product.copyWith(id: json.decode(res.body)['name'])];
    } catch (error, stackTrace) {
      state = currentState;

      logger.e(
        'Add item to products failed',
        error: error,
        stackTrace: stackTrace,
      );
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  // ======== find product by id
  Product findById(String id) => state.firstWhere((item) => item.id == id);

  //=========== Toggle Favorite Status
  Future<void> toggleFavoriteStatus(String id) async {
    final oldState = state;
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(isFavorite: !item.isFavorite)
        else
          item,
    ];
    try {
      final prod = state.firstWhere((item) => id == item.id);
      var url = Uri.https(baseUrl, 'products/$id.json');
      final res = await http.patch(
        url,
        body: json.encode({'isFavorite': prod.isFavorite}),
      );
      if (res.statusCode >= 400) {
        throw HttpException("Oops, Could not add product to favorites!");
      }
    } catch (error, stackTrace) {
      state = oldState;

      logger.e('Toggle favorite failed', error: error, stackTrace: stackTrace);
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  // ========== Update Products
  Future<void> updateProduct(Product product) async {
    final currentState = state;

    try {
      await http.patch(
        Uri.https(baseUrl, 'products/${product.id}.json'),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      state = [
        for (final item in state)
          if (item.id == product.id) product else item,
      ];
    } catch (error, stackTrace) {
      state = currentState;

      logger.e('Update product failed', error: error, stackTrace: stackTrace);
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }

  // ======== Delete Product by id
  Future<void> deleteProductById(String id) async {
    // create a new list and remove the matching item for clarity
    final currentState = state;
    try {
      final response = await http.delete(
        Uri.https(baseUrl, 'products/$id.json'),
      );
      if (response.statusCode >= 500) {
        throw HttpException("Could not delete product");
      }
      final updated = List<Product>.from(state)
        ..removeWhere((item) => item.id == id);
      state = updated;
    } catch (error, stackTrace) {
      state = currentState;

      logger.e('Deleting product failed', error: error, stackTrace: stackTrace);
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      rethrow;
    }
  }
}


*/
