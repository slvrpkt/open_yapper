import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens following Material Design 3 type scale guidelines.
/// Matches website: Anton for display/headlines, Space Grotesk for body/titles/labels.
///
/// The M3 type scale is organized into five roles, each with three sizes:
///
/// **Display** — Large, expressive text for hero moments and marketing.
///   - displayLarge: 57sp, line 64, regular, -0.25 letter-spacing
///   - displayMedium: 45sp, line 52, regular, 0
///   - displaySmall: 36sp, line 44, regular, 0
///
/// **Headline** — Section headers and prominent UI labels.
///   - headlineLarge: 32sp, line 40, regular, 0
///   - headlineMedium: 28sp, line 36, regular, 0
///   - headlineSmall: 24sp, line 32, regular, 0
///
/// **Title** — Card titles, list items, dialogs.
///   - titleLarge: 22sp, line 28, regular, 0
///   - titleMedium: 16sp, line 24, medium, 0.15
///   - titleSmall: 14sp, line 20, medium, 0.1
///
/// **Body** — Primary reading content and paragraphs.
///   - bodyLarge: 16sp, line 24, regular, 0.5
///   - bodyMedium: 14sp, line 20, regular, 0.25
///   - bodySmall: 12sp, line 16, regular, 0.4
///
/// **Label** — Buttons, chips, captions, overlines.
///   - labelLarge: 14sp, line 20, medium, 0.1
///   - labelMedium: 12sp, line 16, medium, 0.5
///   - labelSmall: 11sp, line 16, medium, 0.5
///
/// Use [TypographyTokens.textTheme] to get a full [TextTheme] for your theme.
/// Apply tokens via [Theme.of(context).textTheme].
///
/// **Token usage guide:**
///   - App bar titles: titleLarge
///   - Screen section titles: titleMedium
///   - Card/list item titles: titleSmall
///   - Primary body copy: bodyLarge
///   - Secondary body: bodyMedium
///   - Captions, metadata: bodySmall
///   - Button labels: labelLarge (Material buttons use this by default)
///   - Chips, small labels: labelMedium
///   - Overlines, captions: labelSmall
///   - Hero headlines: headlineLarge / headlineMedium / headlineSmall
///   - Marketing/display: displayLarge / displayMedium / displaySmall
class TypographyTokens {
  TypographyTokens._();

  /// Display/headline: Anton (website font-display)
  static TextStyle get displayLarge => GoogleFonts.anton(
        textStyle: const TextStyle(
          fontSize: 57,
          height: 64 / 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
      );

  static TextStyle get displayMedium => GoogleFonts.anton(
        textStyle: const TextStyle(
          fontSize: 45,
          height: 52 / 45,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      );

  static TextStyle get displaySmall => GoogleFonts.anton(
        textStyle: const TextStyle(
          fontSize: 36,
          height: 44 / 36,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      );

  /// Headline styles — section headers (Anton).
  static TextStyle get headlineLarge => GoogleFonts.anton(
        textStyle: const TextStyle(
          fontSize: 32,
          height: 40 / 32,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      );

  static TextStyle get headlineMedium => GoogleFonts.anton(
        textStyle: const TextStyle(
          fontSize: 28,
          height: 36 / 28,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      );

  static TextStyle get headlineSmall => GoogleFonts.anton(
        textStyle: const TextStyle(
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      );

  /// Title styles — card titles, list items (Space Grotesk).
  static TextStyle get titleLarge => GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
      );

  static TextStyle get titleMedium => GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
      );

  static TextStyle get titleSmall => GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      );

  /// Body styles — reading content (Space Grotesk).
  static TextStyle get bodyLarge => GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 16,
          height: 24 / 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
      );

  static TextStyle get bodyMedium => GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
      );

  static TextStyle get bodySmall => GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
      );

  /// Label styles — buttons, chips, captions (Space Grotesk).
  static TextStyle get labelLarge => GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      );

  static TextStyle get labelMedium => GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 12,
          height: 16 / 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      );

  static TextStyle get labelSmall => GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontSize: 11,
          height: 16 / 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      );

  /// Returns a complete [TextTheme] with all M3 typography tokens.
  /// Display/headline: Anton. Body/title/label: Space Grotesk.
  static TextTheme textTheme({Color? bodyColor, Color? displayColor}) {
    final base = TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
    if (bodyColor != null || displayColor != null) {
      return base.apply(
        bodyColor: bodyColor,
        displayColor: displayColor,
      );
    }
    return base;
  }
}
