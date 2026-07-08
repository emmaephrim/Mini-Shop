// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GridTile(
      footer: GridTileBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite,
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
            Icons.shopping_cart,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      ),
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}
