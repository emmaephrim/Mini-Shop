// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/models/product.dart';
import 'package:mini_shop_app/providers/cart_provider.dart';
import 'package:mini_shop_app/providers/filtered_product_provider.dart';
import 'package:mini_shop_app/providers/product_provider.dart';
import 'package:mini_shop_app/screens/product_detail_screen.dart';

class ProductItem extends ConsumerStatefulWidget {
  final String id;

  const ProductItem({super.key, required this.id});
  @override
  ConsumerState<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends ConsumerState<ProductItem> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final product = ref.read(productsProvider.notifier).findById(widget.id);

    final bool isFavorite = ref.watch(
      filteredProductsProvider.select(
        (list) => list
            .firstWhere(
              (item) => item.id == widget.id,
              orElse: () => Product(
                id: '',
                title: '',
                description: '',
                price: 0,
                imageUrl: '',
              ),
            )
            .isFavorite,
      ),
    );

    final bool isCartItem = ref.watch(
      cartProvider.select((map) => map.items.containsKey(widget.id)),
    );

    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).pushNamed(ProductDetailScreen.routeName, arguments: widget.id),
      child: GridTile(
        footer: GridTileBar(
          leading: IconButton(
            onPressed: () async {
              try {
                await ref
                    .read(productsProvider.notifier)
                    .toggleFavoriteStatus(widget.id);
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Oops something went wrong")),
                );
              }
            },
            icon: Icon(
              (isFavorite ? Icons.favorite : Icons.favorite_outline_outlined),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          trailing: IconButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              try {
                final messenger = ScaffoldMessenger.of(context);
                await ref
                    .read(cartProvider.notifier)
                    .addItem(widget.id, product.price, product.title)
                    .then((res) {
                      messenger.hideCurrentSnackBar();
                      messenger.showSnackBar(
                        SnackBar(
                          persist: false,
                          action: SnackBarAction(
                            label: "UNDO",
                            onPressed: () {
                              ref
                                  .read(cartProvider.notifier)
                                  .removeSingleItem(widget.id);
                            },
                          ),
                          duration: Duration(seconds: 2),
                          content: Text("${product.title} added to cart!"),
                        ),
                      );
                    });
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Oops something went wrong")),
                );
              } finally {
                setState(() {
                  _isLoading = false;
                });
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
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surface.withOpacity(0.7),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(product.imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
