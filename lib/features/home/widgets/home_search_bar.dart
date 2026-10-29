import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/config/routes/app_routes.dart';
import 'package:mini_shop_app/features/products/controllers/filter_provider.dart';

class HomeSearchBar extends ConsumerWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        readOnly: true,
        onTap: () {
          ref.read(filterControllerProvider.notifier).initializeExplorer();
          context.pushNamed(AppRoute.explorer.name);
        },
        decoration: InputDecoration(
          hintText: 'Search for products...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
