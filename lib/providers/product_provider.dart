import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
// import 'package:mini_shop_app/data/products.dart';
import 'package:mini_shop_app/models/product.dart';
import 'package:http/http.dart' as http;

final productsProvider = NotifierProvider<ProductNotifier, List<Product>>(
  ProductNotifier.new,
);

class ProductNotifier extends Notifier<List<Product>> {
  var url = Uri.https(
    'mini-shop-flutter-default-rtdb.asia-southeast1.firebasedatabase.app',
    'products.json',
  );

  @override
  List<Product> build() {
    fetchAndSetProducts();
    return [];
  }

  bool isLoading = false;

  Future<List<Product>> fetchAndSetProducts() async {
    isLoading = true;

    try {
      final List<Product> loadedProducts = [];
      final res = await http.get(url);
      final decoded = json.decode(res.body) as Map<String, dynamic>?;
      developer.log(res.body, name: 'ProductNotifier._fetchAndSetProducts');
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
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final res = await http.post(
        url,
        body: json.encode({
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
          'price': product.price,
          'title': product.title,
        }),
      );
      state = [...state, product.copyWith(id: json.decode(res.body)['name'])];
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Product findById(String id) => state.firstWhere((item) => item.id == id);

  void toggleFavoriteStatus(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(isFavorite: !item.isFavorite)
        else
          item,
    ];
  }

  Future<void> updateProduct(Product product) async {
    try {
      var baseUrl = Uri.https(
        'mini-shop-flutter-default-rtdb.asia-southeast1.firebasedatabase.app',
        'products/${product.id}.json',
      );
      final res = await http.patch(
        baseUrl,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      developer.log(
        name: "Product update:",
        res.statusCode.toString() + res.body,
      );
      state = [
        for (final item in state)
          if (item.id == product.id) product else item,
      ];
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProductById(String id) async {
    // create a new list and remove the matching item for clarity
    try {
      var baseUrl = Uri.https(
        'mini-shop-flutter-default-rtdb.asia-southeast1.firebasedatabase.app',
        'products/$id.json',
      );
      await http.delete(baseUrl);
      final updated = List<Product>.from(state)
        ..removeWhere((item) => item.id == id);
      state = updated;
    } catch (e) {
      rethrow;
    }
  }
}
