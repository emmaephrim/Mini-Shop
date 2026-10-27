// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/config/routes/app_routes.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
import 'package:mini_shop_app/features/cart/controllers/cart_controller.dart';
import 'package:mini_shop_app/features/favorite/controllers/favorites_controller.dart';
import 'package:mini_shop_app/features/products/models/product.dart';

class ProductItem extends ConsumerStatefulWidget {
  final Product product;

  const ProductItem({super.key, required this.product});
  @override
  ConsumerState<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends ConsumerState<ProductItem> {
  bool _isLoading = false;
  void protectButtons(dynamic user) {
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
                "Sign in to add items to your cart",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.pushNamed(AppRoute.auth.name);
                },
                child: const Text("Login In / Register"),
              ),
            ],
          ),
        ),
      );
      return;
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

    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoute.productDetail.name,
        pathParameters: {'id': product.id},
      ),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surface.withValues(alpha: 0.7),

          // ================= FAVORITE BUTTON =================
          leading: IconButton(
            onPressed: () async {
              protectButtons(user);
              try {
                // Call the toggle method. Because of your Optimistic Update,
                // the UI will react instantly
                await ref
                    .read(favoritesController.notifier)
                    .toggleFavorite(product.id);
              } on DioException catch (e) {
                final message = e.error.toString();
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message)));
              }
            },
            icon: Icon(
              favorites.contains(product.id)
                  ? Icons.favorite
                  : Icons.favorite_outline_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),

          // ================= CART BUTTON =================
          trailing: IconButton(
            onPressed: () async {
              protectButtons(user);
              setState(() {
                _isLoading = true;
              });
              try {
                await ref
                    .read(cartControllerProvider.notifier)
                    .addItem(product.id, product.price, product.title);

                if (!context.mounted) return;

                final messenger = ScaffoldMessenger.of(context);
                messenger.hideCurrentSnackBar();
                messenger.showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 2),
                    content: Text("${product.title} added to cart!"),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        ref
                            .read(cartControllerProvider.notifier)
                            .removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              } on DioException catch (e) {
                final message = e.error.toString();
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(message)));
              } finally {
                // This ensures the spinner stops whether it succeeds OR fails
                if (context.mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
            icon: Icon(
              _isLoading
                  ? Icons.sync
                  : isCartItem
                  ? Icons.shopping_cart
                  : Icons.shopping_cart_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
