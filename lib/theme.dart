import "package:flutter/material.dart";

import 'theme/typography.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  /// Creates a MaterialTheme with M3 typography tokens.
  static MaterialTheme withTypography({Color? bodyColor, Color? displayColor}) {
    return MaterialTheme(
      TypographyTokens.textTheme(
        bodyColor: bodyColor,
        displayColor: displayColor,
      ),
    );
  }

  /// Website design tokens: --background-light #F4F4F0, --primary-text #0A0A0A,
  /// --accent-lime #D4FF00, --dark-panel #0A0A0A
  static const Color backgroundLight = Color(0xffF4F4F0);
  static const Color primaryText = Color(0xff0A0A0A);
  static const Color accentLime = Color(0xffD4FF00);
  static const Color darkPanel = Color(0xff0A0A0A);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffD4FF00),
      surfaceTint: Color(0xffD4FF00),
      onPrimary: Color(0xff0A0A0A),
      primaryContainer: Color(0xffE8FF66),
      onPrimaryContainer: Color(0xff0A0A0A),
      secondary: Color(0xff0A0A0A),
      onSecondary: Color(0xffF4F4F0),
      secondaryContainer: Color(0xffE8E8E2),
      onSecondaryContainer: Color(0xff0A0A0A),
      tertiary: Color(0xff0A0A0A),
      onTertiary: Color(0xffD4FF00),
      tertiaryContainer: Color(0xffE8E8E2),
      onTertiaryContainer: Color(0xff0A0A0A),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xffF4F4F0),
      onSurface: Color(0xff0A0A0A),
      onSurfaceVariant: Color(0xff3a3a3a),
      outline: Color(0xff0A0A0A),
      outlineVariant: Color(0xffd0d0cc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff0A0A0A),
      inversePrimary: Color(0xffB8E600),
      primaryFixed: Color(0xffE8FF66),
      onPrimaryFixed: Color(0xff0A0A0A),
      primaryFixedDim: Color(0xffD4FF00),
      onPrimaryFixedVariant: Color(0xff0A0A0A),
      secondaryFixed: Color(0xffE8E8E2),
      onSecondaryFixed: Color(0xff0A0A0A),
      secondaryFixedDim: Color(0xffd8d8d2),
      onSecondaryFixedVariant: Color(0xff0A0A0A),
      tertiaryFixed: Color(0xffE8E8E2),
      onTertiaryFixed: Color(0xff0A0A0A),
      tertiaryFixedDim: Color(0xffd8d8d2),
      onTertiaryFixedVariant: Color(0xff0A0A0A),
      surfaceDim: Color(0xffE8E8E2),
      surfaceBright: Color(0xffF4F4F0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffF0F0EC),
      surfaceContainer: Color(0xffEBEBE6),
      surfaceContainerHigh: Color(0xffE6E6E0),
      surfaceContainerHighest: Color(0xffE0E0DA),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffB8E600),
      surfaceTint: Color(0xffD4FF00),
      onPrimary: Color(0xff0A0A0A),
      primaryContainer: Color(0xffE8FF66),
      onPrimaryContainer: Color(0xff0A0A0A),
      secondary: Color(0xff0A0A0A),
      onSecondary: Color(0xffF4F4F0),
      secondaryContainer: Color(0xffE8E8E2),
      onSecondaryContainer: Color(0xff0A0A0A),
      tertiary: Color(0xff0A0A0A),
      onTertiary: Color(0xffD4FF00),
      tertiaryContainer: Color(0xffE8E8E2),
      onTertiaryContainer: Color(0xff0A0A0A),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xffF4F4F0),
      onSurface: Color(0xff0A0A0A),
      onSurfaceVariant: Color(0xff2a2a2a),
      outline: Color(0xff0A0A0A),
      outlineVariant: Color(0xffd0d0cc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff0A0A0A),
      inversePrimary: Color(0xffB8E600),
      primaryFixed: Color(0xffE8FF66),
      onPrimaryFixed: Color(0xff0A0A0A),
      primaryFixedDim: Color(0xffD4FF00),
      onPrimaryFixedVariant: Color(0xff0A0A0A),
      secondaryFixed: Color(0xffE8E8E2),
      onSecondaryFixed: Color(0xff0A0A0A),
      secondaryFixedDim: Color(0xffd8d8d2),
      onSecondaryFixedVariant: Color(0xff0A0A0A),
      tertiaryFixed: Color(0xffE8E8E2),
      onTertiaryFixed: Color(0xff0A0A0A),
      tertiaryFixedDim: Color(0xffd8d8d2),
      onTertiaryFixedVariant: Color(0xff0A0A0A),
      surfaceDim: Color(0xffE8E8E2),
      surfaceBright: Color(0xffF4F4F0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffF0F0EC),
      surfaceContainer: Color(0xffEBEBE6),
      surfaceContainerHigh: Color(0xffE6E6E0),
      surfaceContainerHighest: Color(0xffE0E0DA),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0A0A0A),
      surfaceTint: Color(0xffD4FF00),
      onPrimary: Color(0xffD4FF00),
      primaryContainer: Color(0xffD4FF00),
      onPrimaryContainer: Color(0xff0A0A0A),
      secondary: Color(0xff0A0A0A),
      onSecondary: Color(0xffF4F4F0),
      secondaryContainer: Color(0xffE8E8E2),
      onSecondaryContainer: Color(0xff0A0A0A),
      tertiary: Color(0xff0A0A0A),
      onTertiary: Color(0xffD4FF00),
      tertiaryContainer: Color(0xffE8E8E2),
      onTertiaryContainer: Color(0xff0A0A0A),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xffF4F4F0),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff0A0A0A),
      outlineVariant: Color(0xff0A0A0A),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff0A0A0A),
      inversePrimary: Color(0xffD4FF00),
      primaryFixed: Color(0xffD4FF00),
      onPrimaryFixed: Color(0xff0A0A0A),
      primaryFixedDim: Color(0xffB8E600),
      onPrimaryFixedVariant: Color(0xff0A0A0A),
      secondaryFixed: Color(0xffE8E8E2),
      onSecondaryFixed: Color(0xff0A0A0A),
      secondaryFixedDim: Color(0xffd8d8d2),
      onSecondaryFixedVariant: Color(0xff0A0A0A),
      tertiaryFixed: Color(0xffE8E8E2),
      onTertiaryFixed: Color(0xff0A0A0A),
      tertiaryFixedDim: Color(0xffd8d8d2),
      onTertiaryFixedVariant: Color(0xff0A0A0A),
      surfaceDim: Color(0xffE8E8E2),
      surfaceBright: Color(0xffF4F4F0),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffF0F0EC),
      surfaceContainer: Color(0xffEBEBE6),
      surfaceContainerHigh: Color(0xffE6E6E0),
      surfaceContainerHighest: Color(0xffE0E0DA),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffD4FF00),
      surfaceTint: Color(0xffD4FF00),
      onPrimary: Color(0xff0A0A0A),
      primaryContainer: Color(0xffB8E600),
      onPrimaryContainer: Color(0xff0A0A0A),
      secondary: Color(0xffD4FF00),
      onSecondary: Color(0xff0A0A0A),
      secondaryContainer: Color(0xff1a1a1a),
      onSecondaryContainer: Color(0xffF4F4F0),
      tertiary: Color(0xffD4FF00),
      onTertiary: Color(0xff0A0A0A),
      tertiaryContainer: Color(0xff1a1a1a),
      onTertiaryContainer: Color(0xffF4F4F0),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0A0A0A),
      onSurface: Color(0xffF4F4F0),
      onSurfaceVariant: Color(0xffd0d0cc),
      outline: Color(0xffD4FF00),
      outlineVariant: Color(0xff2a2a2a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffF4F4F0),
      inversePrimary: Color(0xff0A0A0A),
      primaryFixed: Color(0xffE8FF66),
      onPrimaryFixed: Color(0xff0A0A0A),
      primaryFixedDim: Color(0xffD4FF00),
      onPrimaryFixedVariant: Color(0xff0A0A0A),
      secondaryFixed: Color(0xff2a2a2a),
      onSecondaryFixed: Color(0xffF4F4F0),
      secondaryFixedDim: Color(0xff1a1a1a),
      onSecondaryFixedVariant: Color(0xffF4F4F0),
      tertiaryFixed: Color(0xff2a2a2a),
      onTertiaryFixed: Color(0xffF4F4F0),
      tertiaryFixedDim: Color(0xff1a1a1a),
      onTertiaryFixedVariant: Color(0xffF4F4F0),
      surfaceDim: Color(0xff0A0A0A),
      surfaceBright: Color(0xff1a1a1a),
      surfaceContainerLowest: Color(0xff050505),
      surfaceContainerLow: Color(0xff0f0f0f),
      surfaceContainer: Color(0xff141414),
      surfaceContainerHigh: Color(0xff1a1a1a),
      surfaceContainerHighest: Color(0xff242424),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd4b4),
      surfaceTint: Color(0xffffb77b),
      onPrimary: Color(0xff3d1e00),
      primaryContainer: Color(0xffc3824a),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffad5ba),
      onSecondary: Color(0xff352110),
      secondaryContainer: Color(0xffaa8b73),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffdae1ab),
      onTertiary: Color(0xff232804),
      tertiaryContainer: Color(0xff8e9565),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff19120c),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffecd9cc),
      outline: Color(0xffc1afa2),
      outlineVariant: Color(0xff9e8d82),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffefe0d6),
      inversePrimary: Color(0xff6d3b07),
      primaryFixed: Color(0xffffdcc2),
      onPrimaryFixed: Color(0xff1f0c00),
      primaryFixedDim: Color(0xffffb77b),
      onPrimaryFixedVariant: Color(0xff552b00),
      secondaryFixed: Color(0xffffdcc2),
      onSecondaryFixed: Color(0xff1e0d01),
      secondaryFixedDim: Color(0xffe3c0a6),
      onSecondaryFixedVariant: Color(0xff48311f),
      tertiaryFixed: Color(0xffe0e7b1),
      onTertiaryFixed: Color(0xff0f1300),
      tertiaryFixedDim: Color(0xffc4cb97),
      onTertiaryFixedVariant: Color(0xff333912),
      surfaceDim: Color(0xff19120c),
      surfaceBright: Color(0xff4c433c),
      surfaceContainerLowest: Color(0xff0c0603),
      surfaceContainerLow: Color(0xff241c16),
      surfaceContainer: Color(0xff2f2620),
      surfaceContainerHigh: Color(0xff3a312a),
      surfaceContainerHighest: Color(0xff453c35),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffede1),
      surfaceTint: Color(0xffffb77b),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xfffcb376),
      onPrimaryContainer: Color(0xff170700),
      secondary: Color(0xffffede1),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffdfbca2),
      onSecondaryContainer: Color(0xff170700),
      tertiary: Color(0xffeef5bd),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffc0c793),
      onTertiaryContainer: Color(0xff0a0d00),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff19120c),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffffede1),
      outlineVariant: Color(0xffd2bfb2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffefe0d6),
      inversePrimary: Color(0xff6d3b07),
      primaryFixed: Color(0xffffdcc2),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb77b),
      onPrimaryFixedVariant: Color(0xff1f0c00),
      secondaryFixed: Color(0xffffdcc2),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffe3c0a6),
      onSecondaryFixedVariant: Color(0xff1e0d01),
      tertiaryFixed: Color(0xffe0e7b1),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffc4cb97),
      onTertiaryFixedVariant: Color(0xff0f1300),
      surfaceDim: Color(0xff19120c),
      surfaceBright: Color(0xff584e47),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff261e18),
      surfaceContainer: Color(0xff382f28),
      surfaceContainerHigh: Color(0xff433a33),
      surfaceContainerHighest: Color(0xff4f453e),
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
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primaryText,
          selectionColor: accentLime,
          selectionHandleColor: accentLime,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
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
