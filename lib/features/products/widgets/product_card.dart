import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/config/routes/app_routes.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
import 'package:mini_shop_app/features/favorite/controllers/favorites_controller.dart';
import 'package:mini_shop_app/features/products/models/product.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product});

  final Product product;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesController).value?.productIds ?? {};
    final isFavorite = favorites.contains(product.id);
    final userId = ref.watch(authServiceProvider).currentUser?.uid;

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: () => context.pushNamed(
                      AppRoute.productDetail.name,
                      pathParameters: {'id': product.id},
                    ),
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),

                  // Floating button anchored to top right
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.9),
                      child: IconButton(
                        iconSize: 18,
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          if (userId == null) {
                            return context.goNamed(AppRoute.auth.name);
                          }
                          try {
                            await ref
                                .read(favoritesController.notifier)
                                .toggleFavorite(product.id);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isFavorite
                                      ? "${product.title} removed from favorites"
                                      : '${product.title} added to favorites',
                                ),
                              ),
                            );
                          } on DioException catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Oops! Something went wrong. \n$e',
                                ),
                              ),
                            );
                          }
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey.shade200,
                        ),
                      ),
                    ),
                  ),

                  // TYPOGRAPHY Section
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
