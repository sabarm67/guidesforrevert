import 'package:flutter/material.dart';

/// Type scale from docs/design-system/design-tokens.json.
///
/// NOTE — deviation from the design doc: the design system calls for
/// bundling a dedicated `Inter` font file for Latin text so the app never
/// depends on network access for fonts (critical for offline-first). That
/// binary font asset has not been sourced/licensed yet in this phase, so
/// Latin text still uses Flutter's built-in default font (Roboto-based on
/// Android/desktop, San Francisco on iOS). Arabic text, however, is now
/// bundled: `UthmanicHafs` (KFGQPC "Uthmanic Script Hafs") is the same
/// font the Al-Quran Hafazan System uses for its own Uthmani text — see
/// [arabic] and content/seed/SOURCES.md.
class AppTypography {
  AppTypography._();

  static const arabicFontFamily = 'UthmanicHafs';
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

  /// Style for Arabic body text (Quran/dua/hadith Arabic) — larger than
  /// Latin body text at the same visual weight, per the design tokens, and
  /// rendered in the bundled Uthmanic Hafs font rather than the platform's
  /// generic Arabic fallback.
  static TextStyle arabic(ColorScheme colors, {double size = arabicBodySize}) {
    return TextStyle(fontFamily: arabicFontFamily, fontSize: size, height: 1.8, color: colors.onSurface);
  }
}
