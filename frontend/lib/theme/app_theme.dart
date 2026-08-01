import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(AppColors.light);

  static ThemeData dark() => _build(AppColors.dark);

  static ThemeData _build(ColorScheme colors) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: colors.surface,
      textTheme: AppTypography.textTheme(colors),
      cardTheme: CardThemeData(
        elevation: 1,
        color: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.chip)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.primaryContainer,
        // Six top-level destinations no longer fit comfortably at the
        // default label size on narrow phone widths (the longest label,
        // "Community", was wrapping onto two lines) — a slightly smaller,
        // fixed label size keeps every label on one line down to small
        // phone widths.
        labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 11)),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colors.surface,
        selectedIconTheme: IconThemeData(color: colors.primary),
        indicatorColor: colors.primaryContainer,
      ),
    );
  }
}
