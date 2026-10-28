import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/features/home/widgets/home_category_list.dart';
import 'package:mini_shop_app/features/home/widgets/home_promo_carousel.dart';
import 'package:mini_shop_app/features/home/widgets/home_search_bar.dart';
import 'package:mini_shop_app/features/home/widgets/home_section_header.dart';
import 'package:mini_shop_app/features/products/controllers/filter_provider.dart';
import 'package:mini_shop_app/features/products/controllers/product_controller.dart';
import 'package:mini_shop_app/features/products/widgets/filter_drawer.dart';
import 'package:mini_shop_app/features/products/widgets/product_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProducts = ref.watch(filteredProductsControllerProvider);
    final currentFilter = ref.watch(filterControllerProvider);
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

    return Scaffold(
      endDrawer: FilterDrawer(),
      body: CustomScrollView(
        slivers: [
          // FLOATING APP BAR & SEARCH
          SliverAppBar(
            floating: true,
            snap: true,
            title: const HomeSearchBar(),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none),
              ),
              Builder(
                builder: (ctx) => IconButton(
                  onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                  icon: const Icon(Icons.tune),
                ),
              ),
            ],
          ),

          // HERO CAROUSEL
          // SliverToBoxAdapter acts as a bridge, allowing normal widgets inside Slivers
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: HomePromoCarousel(),
            ),
          ),

          // CATEGORY PILLS
          const SliverToBoxAdapter(child: HomeCategoryList()),

          // SECTION HEADER
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: HomeSectionHeader(title: 'Featured Products'),
            ),
          ),

          // PRODUCTS GRID
          // SliverGrid is heavily optimized for rendering hundreds of items smoothly
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((ctx, index) {
                final products = ref.watch(productsControllerProvider);
                // return Container(
                //   color: Colors.grey.shade200,
                //   alignment: Alignment.center,
                //   child: Text('Product $index'),
                // );
                return products.when(
                  error: (error, stackTrace) => Text('Something went wrong!'),
                  loading: () => Center(child: CircularProgressIndicator()),
                  data: (data) => ProductCard(product: data[index]),
                );
              }, childCount: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
            ),
          ),
          // Bottom padding to ensure the last grid item isn't hidden by system navigation
          const SliverToBoxAdapter(child: SizedBox(height: 90)),
        ],
      ),
    );
  }
}
