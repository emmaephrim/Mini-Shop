import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/config/routes/app_routes.dart';
import 'package:mini_shop_app/features/products/controllers/filter_provider.dart';

class HomeCategoryList extends ConsumerWidget {
  const HomeCategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = [
      'electronics',
      'fashion',
      'home',
      'beauty',
      'sports',
      'kids',
      'automotive',
      'stationery',
      'health',
    ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: EdgeInsets.only(right: 16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    ref
                        .read(filterControllerProvider.notifier)
                        .initializeExplorer(category: categories[index]);
                    context.pushNamed(AppRoute.explorer.name);
                  },
                  child: CircleAvatar(
                    radius: 32,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.onSecondaryContainer,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(
                        ('assets/images/categories/${categories[index]}.jpeg'),
                      ),
                      radius: 30,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.secondaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  categories[index][0].toUpperCase() +
                      categories[index].substring(1),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
