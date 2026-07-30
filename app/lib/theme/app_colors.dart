import 'package:flutter/material.dart';

/// Hardcoded from docs/design-system/design-tokens.json — that file is the
/// source of truth. Values are duplicated here (not derived algorithmically)
/// because the palette is hand-designed, not seed-generated.
class AppColors {
  AppColors._();

  static const light = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2E7D5B),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD7EEE1),
    onPrimaryContainer: Color(0xFF0B3B26),
    secondary: Color(0xFFD4A24C),
    onSecondary: Color(0xFF3A2B0A),
    secondaryContainer: Color(0xFFF6E6C8),
    onSecondaryContainer: Color(0xFF4A3610),
    tertiary: Color(0xFF3E6B8A),
    onTertiary: Color(0xFFFFFFFF),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1B1B18),
    surfaceContainerHighest: Color(0xFFF1ECE1),
    onSurfaceVariant: Color(0xFF5C5C55),
    outline: Color(0xFFD8D2C4),
  );

  static const dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF8FD4B3),
    onPrimary: Color(0xFF0B3B26),
    primaryContainer: Color(0xFF0F4A32),
    onPrimaryContainer: Color(0xFFD7EEE1),
    secondary: Color(0xFFE8C077),
    onSecondary: Color(0xFF3A2B0A),
    secondaryContainer: Color(0xFF5A4415),
    onSecondaryContainer: Color(0xFFF6E6C8),
    tertiary: Color(0xFF9CC6E0),
    onTertiary: Color(0xFF063247),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
    surface: Color(0xFF1E2018),
    onSurface: Color(0xFFEAE8DD),
    surfaceContainerHighest: Color(0xFF2A2C21),
    onSurfaceVariant: Color(0xFFC7C4B6),
    outline: Color(0xFF4A4C40),
  );
}
