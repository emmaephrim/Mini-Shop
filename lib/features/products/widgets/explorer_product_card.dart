import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/config/routes/app_routes.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
import 'package:mini_shop_app/features/cart/controllers/cart_controller.dart';
import 'package:mini_shop_app/features/favorite/controllers/favorites_controller.dart';
import 'package:mini_shop_app/features/products/models/product.dart';

class ExplorerProductCard extends ConsumerStatefulWidget {
  final Product product;
  const ExplorerProductCard({super.key, required this.product});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExplorerProductCardState();
}

class _ExplorerProductCardState extends ConsumerState<ExplorerProductCard> {
  bool _isLoading = false;

  void _protectedButtons(dynamic user) {
    if (user == null) {
      showModalBottomSheet(
        context: context,
        builder: (ctx) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 50, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Sign in to add items to cart',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.pushNamed(AppRoute.auth.name);
                },
                child: const Text('Login/Register'),
              ),
            ],
          ),
        ),
      );
      throw Exception('Guest User Intercepted');
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final user = ref.watch(authServiceProvider).currentUser;
    final favorites = ref.watch(favoritesController).value?.productIds ?? {};

    final bool isCartItem = ref.watch(
      cartControllerProvider.select(
        (asyncBox) => asyncBox.value?.items.containsKey(product.id) ?? false,
      ),
    );

    final bool isFav = favorites.contains(product.id);

    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoute.productDetail.name,
        pathParameters: {'id': product.id},
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.83),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.white,
                    child: Image.network(product.imageUrl, fit: BoxFit.cover),
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.9),
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () async {
                          try {
                            _protectedButtons(user);
                            await ref
                                .read(favoritesController.notifier)
                                .toggleFavorite(product.id);
                          } catch (e) {
                            if (e.toString().contains("Guest user")) return;
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: isFav ? Colors.red : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================= DETAILS & CART
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: Colors.amber.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating} (${product.reviewCount})',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: IconButton.filled(
                          padding: EdgeInsets.zero,
                          style: IconButton.styleFrom(
                            backgroundColor: isCartItem
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary,
                          ),
                          icon: _isLoading
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  isCartItem
                                      ? Icons.shopping_bag
                                      : Icons.add_shopping_cart,
                                  size: 18,
                                  color: Colors.white,
                                ),
                          onPressed: () async {
                            try {
                              _protectedButtons(user);
                              setState(() {
                                _isLoading = true;
                              });
                              await ref
                                  .read(cartControllerProvider.notifier)
                                  .addItem(
                                    product.id,
                                    product.price,
                                    product.title,
                                  );
                              if (!context.mounted) return;

                              final messenger = ScaffoldMessenger.of(context);
                              messenger.hideCurrentSnackBar();
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product.title} added to cart!',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  action: SnackBarAction(
                                    label: 'UNDO',
                                    onPressed: () => ref
                                        .read(cartControllerProvider.notifier)
                                        .removeSingleItem(product.id),
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (e.toString().contains('Guest users')) return;
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            } finally {
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                        ),
                      ),
                    ],
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
