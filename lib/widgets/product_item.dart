// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/providers/filtered_product_provider.dart';
import 'package:mini_shop_app/providers/product_provider.dart';

import 'package:mini_shop_app/screens/product_detail_screen.dart';

class ProductItem extends ConsumerWidget {
  final String id;
  final String title;
  final String imageUrl;

  const ProductItem({
    super.key,
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(
      filteredProductsProvider.select(
        (list) => list.firstWhere((item) => item.id == id).isFavorite,
      ),
    );

    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).pushNamed(ProductDetailScreen.routeName, arguments: id),
      child: GridTile(
        footer: GridTileBar(
          leading: IconButton(
            onPressed: () =>
                ref.read(productsProvider.notifier).toggleFavoriteStatus(id),
            icon: Icon(
              (isFavorite ? Icons.favorite : Icons.favorite_outline_outlined),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surface.withOpacity(0.7),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
