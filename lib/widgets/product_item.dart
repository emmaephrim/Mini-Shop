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
          icon: Icon(Icons.favorite, color: Colors.amber),
        ),
        title: Text(title, textAlign: TextAlign.center),
        trailing: IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
        backgroundColor: Colors.black54,
      ),
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}
