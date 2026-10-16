import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/core/theme/theme.dart';
import 'package:mini_shop_app/core/theme/create_textTheme.dart';
import 'package:mini_shop_app/features/auth/controllers/auth_provider.dart';
import 'package:mini_shop_app/firebase_options.dart';
import 'package:mini_shop_app/core/theme/theme_mode_provider.dart';
import 'package:mini_shop_app/features/auth/views/auth_screen.dart';
import 'package:mini_shop_app/features/cart/views/cart_screen.dart';
import 'package:mini_shop_app/features/products/views/edit_product_screen.dart';
import 'package:mini_shop_app/features/orders/views/orders_screen.dart';
import 'package:mini_shop_app/features/products/views/product_detail_screen.dart';
import 'package:mini_shop_app/features/products/views/products_overview_screen.dart';
import 'package:mini_shop_app/features/products/views/user_products_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(ProviderScope(child: const ShopApp()));
}

class ShopApp extends ConsumerWidget {
  const ShopApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeModeProvider);
    final authState = ref.watch(authStateProvider);

    TextTheme textTheme = createTextTheme(context, "Lato", "Anton");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [observer],
      title: 'Mini Shop',
      theme: theme.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: MaterialTheme.lightScheme().primary,
          foregroundColor: MaterialTheme.lightScheme().onPrimary,
        ),
      ),
      darkTheme: theme.darkHighContrast().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: MaterialTheme.darkHighContrastScheme().primary,
          foregroundColor: MaterialTheme.darkHighContrastScheme().onPrimary,
        ),
      ),
      themeMode: currentThemeMode,
      home: authState.when(
        data: (user) =>
            user != null ? const ProductsOverviewScreen() : const AuthScreen(),
        error: (err, stack) =>
            Scaffold(body: Center(child: Text('Error: $err'))),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      routes: {
        ProductsOverviewScreen.routeName: (context) => ProductsOverviewScreen(),
        ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
        CartScreen.routeName: (context) => CartScreen(),
        OrdersScreen.routeName: (context) => OrdersScreen(),
        UserProductsScreen.routeName: (context) => UserProductsScreen(),
        EditProductScreen.routeName: (context) => EditProductScreen(),
      },
    );
  }
}
