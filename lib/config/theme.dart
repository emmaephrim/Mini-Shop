import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff785900),
      surfaceTint: Color(0xff785900),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffc107),
      onPrimaryContainer: Color(0xff6d5100),
      secondary: Color(0xff745b1f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdb92),
      onSecondaryContainer: Color(0xff795f23),
      tertiary: Color(0xff785900),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffc107),
      onTertiaryContainer: Color(0xff6d5100),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff1b1b1b),
      onSurfaceVariant: Color(0xff4c4546),
      outline: Color(0xff7e7576),
      outlineVariant: Color(0xffcfc4c5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inversePrimary: Color(0xfffabd00),
      primaryFixed: Color(0xffffdf9e),
      onPrimaryFixed: Color(0xff261a00),
      primaryFixedDim: Color(0xfffabd00),
      onPrimaryFixedVariant: Color(0xff5b4300),
      secondaryFixed: Color(0xffffdf9e),
      onSecondaryFixed: Color(0xff261a00),
      secondaryFixedDim: Color(0xffe4c27c),
      onSecondaryFixedVariant: Color(0xff5a4307),
      tertiaryFixed: Color(0xffffdf9e),
      onTertiaryFixed: Color(0xff261a00),
      tertiaryFixedDim: Color(0xfffabd00),
      onTertiaryFixedVariant: Color(0xff5b4300),
      surfaceDim: Color(0xffdadada),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f3),
      surfaceContainer: Color(0xffeeeeee),
      surfaceContainerHigh: Color(0xffe8e8e8),
      surfaceContainerHighest: Color(0xffe2e2e2),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff473300),
      surfaceTint: Color(0xff785900),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff8b6700),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff473300),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff84692c),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff473300),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff8b6700),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff111111),
      onSurfaceVariant: Color(0xff3b3436),
      outline: Color(0xff585152),
      outlineVariant: Color(0xff736b6c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inversePrimary: Color(0xfffabd00),
      primaryFixed: Color(0xff8b6700),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff6d5000),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff84692c),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff6a5116),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff8b6700),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff6d5000),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc6c6c6),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3f3),
      surfaceContainer: Color(0xffe8e8e8),
      surfaceContainerHigh: Color(0xffdddddd),
      surfaceContainerHighest: Color(0xffd1d1d1),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3a2900),
      surfaceTint: Color(0xff785900),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff5e4500),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3a2900),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff5d460a),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3a2900),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5e4500),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9f9),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff312b2c),
      outlineVariant: Color(0xff4f4749),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030),
      inversePrimary: Color(0xfffabd00),
      primaryFixed: Color(0xff5e4500),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff423000),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff5d460a),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff423000),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5e4500),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff423000),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb9b9b9),
      surfaceBright: Color(0xfff9f9f9),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff1f1f1),
      surfaceContainer: Color(0xffe2e2e2),
      surfaceContainerHigh: Color(0xffd4d4d4),
      surfaceContainerHighest: Color(0xffc6c6c6),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffe4af),
      surfaceTint: Color(0xfffabd00),
      onPrimary: Color(0xff3f2e00),
      primaryContainer: Color(0xffffc107),
      onPrimaryContainer: Color(0xff6d5100),
      secondary: Color(0xffe4c27c),
      onSecondary: Color(0xff3f2e00),
      secondaryContainer: Color(0xff5d460a),
      onSecondaryContainer: Color(0xffd5b46f),
      tertiary: Color(0xffffe4af),
      onTertiary: Color(0xff3f2e00),
      tertiaryContainer: Color(0xffffc107),
      onTertiaryContainer: Color(0xff6d5100),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff131313),
      onSurface: Color(0xffe2e2e2),
      onSurfaceVariant: Color(0xffcfc4c5),
      outline: Color(0xff988e90),
      outlineVariant: Color(0xff4c4546),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inversePrimary: Color(0xff785900),
      primaryFixed: Color(0xffffdf9e),
      onPrimaryFixed: Color(0xff261a00),
      primaryFixedDim: Color(0xfffabd00),
      onPrimaryFixedVariant: Color(0xff5b4300),
      secondaryFixed: Color(0xffffdf9e),
      onSecondaryFixed: Color(0xff261a00),
      secondaryFixedDim: Color(0xffe4c27c),
      onSecondaryFixedVariant: Color(0xff5a4307),
      tertiaryFixed: Color(0xffffdf9e),
      onTertiaryFixed: Color(0xff261a00),
      tertiaryFixedDim: Color(0xfffabd00),
      onTertiaryFixedVariant: Color(0xff5b4300),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff393939),
      surfaceContainerLowest: Color(0xff0e0e0e),
      surfaceContainerLow: Color(0xff1b1b1b),
      surfaceContainer: Color(0xff1f1f1f),
      surfaceContainerHigh: Color(0xff2a2a2a),
      surfaceContainerHighest: Color(0xff353535),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffe4af),
      surfaceTint: Color(0xfffabd00),
      onPrimary: Color(0xff3b2a00),
      primaryContainer: Color(0xffffc107),
      onPrimaryContainer: Color(0xff4a3600),
      secondary: Color(0xfffbd88f),
      onSecondary: Color(0xff322300),
      secondaryContainer: Color(0xffab8d4c),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffe4af),
      onTertiary: Color(0xff3b2a00),
      tertiaryContainer: Color(0xffffc107),
      onTertiaryContainer: Color(0xff4a3600),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff131313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe5dadb),
      outline: Color(0xffbaafb1),
      outlineVariant: Color(0xff988e8f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inversePrimary: Color(0xff5d4400),
      primaryFixed: Color(0xffffdf9e),
      onPrimaryFixed: Color(0xff191000),
      primaryFixedDim: Color(0xfffabd00),
      onPrimaryFixedVariant: Color(0xff473300),
      secondaryFixed: Color(0xffffdf9e),
      onSecondaryFixed: Color(0xff191000),
      secondaryFixedDim: Color(0xffe4c27c),
      onSecondaryFixedVariant: Color(0xff473300),
      tertiaryFixed: Color(0xffffdf9e),
      onTertiaryFixed: Color(0xff191000),
      tertiaryFixedDim: Color(0xfffabd00),
      onTertiaryFixedVariant: Color(0xff473300),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff444444),
      surfaceContainerLowest: Color(0xff070707),
      surfaceContainerLow: Color(0xff1d1d1d),
      surfaceContainer: Color(0xff282828),
      surfaceContainerHigh: Color(0xff323232),
      surfaceContainerHighest: Color(0xff3e3e3e),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffeed1),
      surfaceTint: Color(0xfffabd00),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffc107),
      onPrimaryContainer: Color(0xff1f1500),
      secondary: Color(0xffffeed1),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffe0be78),
      onSecondaryContainer: Color(0xff110a00),
      tertiary: Color(0xffffeed1),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffffc107),
      onTertiaryContainer: Color(0xff1f1500),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff131313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff9edef),
      outlineVariant: Color(0xffcbc0c1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e2),
      inversePrimary: Color(0xff5d4400),
      primaryFixed: Color(0xffffdf9e),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xfffabd00),
      onPrimaryFixedVariant: Color(0xff191000),
      secondaryFixed: Color(0xffffdf9e),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe4c27c),
      onSecondaryFixedVariant: Color(0xff191000),
      tertiaryFixed: Color(0xffffdf9e),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xfffabd00),
      onTertiaryFixedVariant: Color(0xff191000),
      surfaceDim: Color(0xff131313),
      surfaceBright: Color(0xff505050),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1f1f1f),
      surfaceContainer: Color(0xff303030),
      surfaceContainerHigh: Color(0xff3b3b3b),
      surfaceContainerHighest: Color(0xff474747),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
    canvasColor: colorScheme.surface,
  );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
