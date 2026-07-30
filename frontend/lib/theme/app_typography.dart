import 'package:flutter/material.dart';

/// Type scale from docs/design-system/design-tokens.json.
///
/// NOTE — deviation from the design doc: the design system calls for
/// bundling dedicated `Inter` and `AmiriQuran` font files so the app never
/// depends on network access for fonts (critical for offline-first). Those
/// binary font assets have not been sourced/licensed yet in this phase, so
/// this uses Flutter's built-in default font (Roboto-based on
/// Android/desktop, San Francisco on iOS) with the platform's Arabic font
/// fallback for Arabic glyphs. This still works fully offline — it just
/// isn't the bespoke typography from the design doc yet. Swap in real font
/// files under `assets/fonts/` and reference them here once sourced.
class AppTypography {
  AppTypography._();

  static const arabicBodySize = 24.0;
  static const arabicAyahSize = 28.0;

  static TextTheme textTheme(ColorScheme colors) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: colors.onSurface),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: colors.onSurface),
      titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.onSurface),
      bodyLarge: TextStyle(fontSize: 16, height: 1.5, color: colors.onSurface),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: colors.onSurfaceVariant),
      labelSmall: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
    );
  }

  /// Style for Arabic body text (dua/hadith Arabic) — larger than Latin
  /// body text at the same visual weight, per the design tokens.
  static TextStyle arabic(ColorScheme colors, {double size = arabicBodySize}) {
    return TextStyle(fontSize: size, height: 1.8, color: colors.onSurface);
  }
}
