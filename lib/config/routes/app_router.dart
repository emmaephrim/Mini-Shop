import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/config/routes/app_routes.dart';
import 'package:mini_shop_app/core/widgets/app_shell.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
import 'package:mini_shop_app/features/auth/views/auth_screen.dart';
import 'package:mini_shop_app/features/cart/views/cart_screen.dart';
import 'package:mini_shop_app/features/categories/views/categories_screen.dart';
import 'package:mini_shop_app/features/home/views/home_screen.dart';
import 'package:mini_shop_app/features/orders/views/orders_screen.dart';
import 'package:mini_shop_app/features/products/views/edit_product_screen.dart';
import 'package:mini_shop_app/features/products/views/product_detail_screen.dart';
import 'package:mini_shop_app/features/products/views/products_overview_screen.dart';
import 'package:mini_shop_app/features/products/views/user_products_screen.dart';
import 'package:mini_shop_app/features/profile/views/profile_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );
  final authState = ref.watch(authStateProvider);

  final authStateNotifier = ValueNotifier<AsyncValue<User?>>(
    const AsyncValue.loading(),
  );

  ref.listen(authStateProvider, (_, next) {
    authStateNotifier.value = next;
  });

  final protectedRoutes = [
    AppRoute.cart.path,
    AppRoute.orders.path,
    AppRoute.profile.path,
    AppRoute.userProducts.path,
    AppRoute.addProduct.path,
  ];

  return GoRouter(
    refreshListenable: authStateNotifier,
    redirect: (context, state) {
      if (authState.isLoading) return null;

      // final bool isLoggedIn = authState.value != null;
      // final bool isGoingToLogIn = state.matchedLocation == AppRoute.auth.path;

      // if (!isLoggedIn && !isGoingToLogIn) {
      //   return AppRoute.auth.path; // KICK THEM TO LOGIN!
      // }
      // if (isLoggedIn && isGoingToLogIn) {
      //   return AppRoute.home.path; // SEND THEM HOME!
      // }
      // return null;

      final isAuthenticated = authState.value != null;

      final isGoingToProtectedRoute = protectedRoutes.any(
        (route) => state.matchedLocation.startsWith(route.toString()),
      );

      final isGoingToLogin = state.matchedLocation == AppRoute.auth.path;

      if (!isAuthenticated && isGoingToProtectedRoute) {
        // I pass the route they wanted to go to as a query parameter
        // so you can send them back there after they log in
        return '${AppRoute.auth.path}?redirect=${state.matchedLocation}';
      }
      if (isAuthenticated && isGoingToLogin) return AppRoute.home.path;

      return null;
    },
    observers: [observer],
    initialLocation: AppRoute.home.path,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // Return the built Shell widget
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // BRANCH 0: HOME
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.home.path,
                name: AppRoute.home.name,
                builder: (context, state) => const HomeScreen(),
                // Sub-routes (like Product Details) go here so the Bottom Nav
                // stays visible when viewing a product!
                routes: [
                  GoRoute(
                    path: AppRoute.productDetail.path,
                    name: AppRoute.productDetail.name,
                    builder: (context, state) {
                      final productId = state.pathParameters['id'];
                      return ProductDetailScreen(productId: productId!);
                    },
                  ),
                ],
              ),
            ],
          ),

          // BRANCH 2: CATEGORIES
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.categories.path,
                name: AppRoute.categories.name,
                builder: (context, state) => CategoriesScreen(),
              ),
            ],
          ),

          // BRANCH 1: CART
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.cart.path,
                name: AppRoute.cart.name,
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),

          // BRANCH 3: PROFILE
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.profile.path,
                name: AppRoute.profile.name,
                builder: (context, state) => ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: AppRoute.viewProducts.path,
        name: AppRoute.viewProducts.name,
        builder: (context, state) => ProductsOverviewScreen(),
      ),
      GoRoute(
        path: AppRoute.auth.path,
        name: AppRoute.auth.name,
        builder: (context, state) => AuthScreen(),
      ),

      GoRoute(
        path: AppRoute.addProduct.path,
        name: AppRoute.addProduct.name,
        builder: (context, state) => EditProductScreen(),
      ),
      GoRoute(
        path: AppRoute.editProduct.path,
        name: AppRoute.editProduct.name,
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return EditProductScreen(productId: productId);
        },
      ),
      // work on data arguments
      GoRoute(
        path: AppRoute.userProducts.path,
        name: AppRoute.userProducts.name,
        builder: (context, state) => UserProductsScreen(),
      ),
      GoRoute(
        path: AppRoute.orders.path,
        name: AppRoute.orders.name,
        builder: (context, state) => OrdersScreen(),
      ),
    ],
  );
});
