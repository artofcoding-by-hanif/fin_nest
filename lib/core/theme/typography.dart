import 'package:flutter/material.dart';

/// App typography: Sora for display/headings/amounts, Inter for UI text.
///
/// Sora has no ₹ glyph, so every Sora style falls back to Inter for
/// characters it lacks.
class AppTypography {
  AppTypography._();

  static const String display = 'Sora';
  static const String body = 'Inter';
  static const List<String> _fallback = ['Inter'];

  /// Tabular figures keep amounts from jittering as they change.
  static const List<FontFeature> tabular = [FontFeature.tabularFigures()];

  static TextStyle _sora(double size, FontWeight w, double spacing,
          [double? height]) =>
      TextStyle(
        fontFamily: display,
        fontFamilyFallback: _fallback,
        fontSize: size,
        fontWeight: w,
        letterSpacing: spacing,
        height: height,
      );

  static TextStyle _inter(double size, FontWeight w, double spacing,
          [double? height]) =>
      TextStyle(
        fontFamily: body,
        fontSize: size,
        fontWeight: w,
        letterSpacing: spacing,
        height: height,
      );

  static TextTheme textTheme(Color primary, Color muted) {
    return TextTheme(
      displayLarge: _sora(52, FontWeight.w700, -1.5, 1.1),
      displayMedium: _sora(42, FontWeight.w700, -1.2, 1.1),
      displaySmall: _sora(34, FontWeight.w700, -1.0, 1.15),
      headlineLarge: _sora(30, FontWeight.w700, -0.8, 1.2),
      headlineMedium: _sora(26, FontWeight.w700, -0.6, 1.2),
      headlineSmall: _sora(22, FontWeight.w600, -0.4, 1.25),
      titleLarge: _sora(20, FontWeight.w600, -0.3, 1.3),
      titleMedium: _sora(16, FontWeight.w600, -0.1, 1.35),
      titleSmall: _inter(14, FontWeight.w600, 0, 1.4),
      bodyLarge: _inter(16, FontWeight.w400, 0, 1.5),
      bodyMedium: _inter(14, FontWeight.w400, 0, 1.45),
      bodySmall: _inter(12, FontWeight.w400, 0.1, 1.4),
      labelLarge: _inter(14, FontWeight.w600, 0.2),
      labelMedium: _inter(12, FontWeight.w600, 0.3),
      labelSmall: _inter(11, FontWeight.w500, 0.4),
    ).apply(bodyColor: primary, displayColor: primary).copyWith(
          // Secondary text reads as muted by default.
          bodySmall: _inter(12, FontWeight.w400, 0.1, 1.4).copyWith(
            color: muted,
          ),
          labelSmall: _inter(11, FontWeight.w500, 0.4).copyWith(color: muted),
        );
  }

  /// Style for large money figures.
  static TextStyle amount(double size, {FontWeight weight = FontWeight.w700}) =>
      _sora(size, weight, -0.5, 1.1).copyWith(fontFeatures: tabular);
}
