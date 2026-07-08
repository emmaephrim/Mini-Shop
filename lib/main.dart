import 'package:flutter/material.dart';
import 'package:mini_shop_app/config/theme.dart';
import 'package:mini_shop_app/config/util.dart';
import 'package:mini_shop_app/screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Mini Shop',
    //   theme: ThemeData(
    //     useMaterial3: true,
    //     fontFamily: 'Lato',
    //     colorScheme: MaterialTheme.darkHighContrastScheme(),
    //     appBarTheme: AppBarTheme(
    //       backgroundColor: Colors.amber,
    //       titleTextStyle: TextStyle(color: Colors.black, fontSize: 22),
    //     ),
    //   ),
    //   routes: {'/': (context) => ProductsOverviewScreen()},
    // );

    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    //TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Lato", "Anton");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Shop',
      theme: brightness == Brightness.light
          ? theme.light()
          : theme.darkHighContrast(),

      // theme: ThemeData(
      //   colorScheme: MaterialTheme.darkHighContrastScheme(),
      //   appBarTheme: AppBarTheme(
      //     backgroundColor: MaterialTheme.darkHighContrastScheme().surfaceTint,
      //     // foregroundColor: Theme.of(context).,
      //   ),
      // ),
      routes: {'/': (context) => ProductsOverviewScreen()},
    );
  }
}
