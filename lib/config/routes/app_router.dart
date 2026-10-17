import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_shop_app/config/routes/app_routes.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
import 'package:mini_shop_app/features/auth/views/auth_screen.dart';
import 'package:mini_shop_app/features/cart/views/cart_screen.dart';
import 'package:mini_shop_app/features/orders/views/orders_screen.dart';
import 'package:mini_shop_app/features/products/views/edit_product_screen.dart';
import 'package:mini_shop_app/features/products/views/product_detail_screen.dart';
import 'package:mini_shop_app/features/products/views/products_overview_screen.dart';
import 'package:mini_shop_app/features/products/views/user_products_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  // THE BRIDGE: GoRouter needs a "Listenable" to know when to refresh.
  // We create a simple ValueNotifier that holds our auth state.
  final authStateNotifier = ValueNotifier<AsyncValue<User?>>(
    const AsyncValue.loading(),
  );

  // We tell Riverpod: "Every time the auth state changes, update the bridge."
  ref.listen(authStateProvider, (_, next) {
    authStateNotifier.value = next;
  });

  return GoRouter(
    // THE TRIGGER: We give GoRouter the bridge. Now, any time the user
    // logs in or logs out, GoRouter instantly forces a new redirect check!
    refreshListenable: authStateNotifier,
    // This runs before EVERY single navigation.
    redirect: (context, state) {
      // Get the current user state
      final authState = ref.read(authStateProvider);
      // We don't want to redirect while Firebase is still loading
      if (authState.isLoading) return null;

      final bool isLoggedIn = authState.value != null;
      final bool isGoingToLogIn = state.matchedLocation == AppRoute.auth.path;

      // Rule 2: If they ARE logged in, but trying to go to the login screen...
      if (!isLoggedIn && !isGoingToLogIn) {
        return AppRoute.auth.path; // KICK THEM TO LOGIN!
      }
      if (isLoggedIn && isGoingToLogIn) {
        return AppRoute.home.path; // SEND THEM HOME!
      }

      // Rule 3: Otherwise, let them pass normally.
      return null;
    },
    observers: [observer],
    initialLocation: AppRoute.home.path,
    routes: [
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (context, state) => const ProductsOverviewScreen(),
      ),
      GoRoute(
        path: AppRoute.auth.path,
        name: AppRoute.auth.name,
        builder: (context, state) => AuthScreen(),
      ),
      GoRoute(
        path: AppRoute.cart.path,
        name: AppRoute.cart.name,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppRoute.productDetail.path,
        name: AppRoute.productDetail.name,
        builder: (context, state) {
          final productId = state.pathParameters['id'];
          return ProductDetailScreen(productId: productId!);
        },
      ),
      GoRoute(
        path: AppRoute.editProduct.path,
        name: AppRoute.editProduct.name,
        builder: (context, state) {
          final productId = state.pathParameters['id'];
          return EditProductScreen(productId: productId!);
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
