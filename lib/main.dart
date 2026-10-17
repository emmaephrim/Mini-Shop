import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mini_shop_app/config/routes/app_router.dart';
import 'package:mini_shop_app/core/theme/create_textTheme.dart';
import 'package:mini_shop_app/core/theme/theme.dart';
import 'package:mini_shop_app/core/theme/theme_mode_provider.dart';
import 'package:mini_shop_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runApp(ProviderScope(child: const ShopApp()));
}

class ShopApp extends ConsumerWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final currentThemeMode = ref.watch(themeModeProvider);

    TextTheme textTheme = createTextTheme(context, "Lato", "Anton");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
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
      routerConfig: router,
    );
  }
}
