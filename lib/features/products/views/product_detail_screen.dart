import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/config/routes/app_routes.dart';
import 'package:mini_shop_app/core/utils/logger.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
import 'package:mini_shop_app/features/chat/controllers/chat_provider.dart';
import 'package:mini_shop_app/features/products/models/product.dart';
import 'package:mini_shop_app/features/products/controllers/product_controller.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.read(productsControllerProvider.notifier);

    final Product product = products.findById(productId);
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(product.imageUrl, fit: BoxFit.cover),
            ),
            SizedBox(height: 10),
            Text(
              '\$${product.price}',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.surfaceTint,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () async {
                final currentUser = ref.read(authServiceProvider).currentUser;
                // Show login bottom sheet
                if (currentUser == null) return;

                if (currentUser.uid == product.sellerId) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You cannot message yourself'),
                    ),
                  );
                  return;
                }

                try {
                  // initialize the chat room securely
                  final chatId = await ref
                      .read(chatServiceProvider)
                      .initializeChat(currentUser.uid, product.sellerId);

                  if (!context.mounted) return;

                  // Navigate to the chat room
                  context.pushNamed(
                    AppRoute.chat.name,
                    pathParameters: {'chatId': chatId},
                    extra: 'Seller Name',
                  );
                } catch (e, stackTrace) {
                  logger.e(
                    'Failed to start chat',
                    error: e,
                    stackTrace: stackTrace,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to start chat')),
                  );
                }
              },
              icon: Icon(Icons.bubble_chart_outlined),
              label: const Text("Contact Seller"),
            ),
          ],
        ),
      ),
    );
  }
}
