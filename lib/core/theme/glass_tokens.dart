import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Glass-specific design tokens, available via `context.glass`.
@immutable
class GlassTokens extends ThemeExtension<GlassTokens> {
  /// Base background colors (top → bottom).
  final Color baseTop;
  final Color baseBottom;

  /// Aurora blob colors painted behind the content.
  final List<Color> auroraColors;
  final double auroraOpacity;

  /// Frosted panel fill (top-left → bottom-right).
  final Color fillStart;
  final Color fillEnd;

  /// Hairline border and the brighter top-edge highlight.
  final Color border;
  final Color highlight;

  /// Backdrop blur strength.
  final double blur;

  /// Soft shadow under glass panels.
  final Color shadow;

  /// Text colors.
  final Color textPrimary;
  final Color textMuted;

  /// Income / expense colors tuned for this brightness.
  final Color income;
  final Color expense;

  const GlassTokens({
    required this.baseTop,
    required this.baseBottom,
    required this.auroraColors,
    required this.auroraOpacity,
    required this.fillStart,
    required this.fillEnd,
    required this.border,
    required this.highlight,
    required this.blur,
    required this.shadow,
    required this.textPrimary,
    required this.textMuted,
    required this.income,
    required this.expense,
  });

  static const dark = GlassTokens(
    baseTop: AppColors.darkBase2,
    baseBottom: AppColors.darkBase,
    auroraColors: [
      AppColors.violet,
      AppColors.cyan,
      AppColors.pink,
      AppColors.blue,
    ],
    auroraOpacity: 0.45,
    fillStart: Color(0x24FFFFFF), // 14%
    fillEnd: Color(0x0AFFFFFF), // 4%
    border: Color(0x26FFFFFF), // 15%
    highlight: Color(0x59FFFFFF), // 35%
    blur: 24,
    shadow: Color(0x66000000),
    textPrimary: AppColors.darkText,
    textMuted: AppColors.darkTextMuted,
    income: AppColors.income,
    expense: AppColors.expense,
  );

  static const light = GlassTokens(
    baseTop: AppColors.lightBase,
    baseBottom: AppColors.lightBase2,
    auroraColors: [
      Color(0xFFB9A6FF),
      Color(0xFF8BE9F7),
      Color(0xFFFFB3D9),
      Color(0xFFA9C8FF),
    ],
    auroraOpacity: 0.75,
    fillStart: Color(0xB3FFFFFF), // 70%
    fillEnd: Color(0x73FFFFFF), // 45%
    border: Color(0xCCFFFFFF), // 80%
    highlight: Color(0xFFFFFFFF),
    blur: 24,
    shadow: Color(0x1F4C3F99),
    textPrimary: AppColors.lightText,
    textMuted: AppColors.lightTextMuted,
    income: AppColors.incomeDeep,
    expense: AppColors.expenseDeep,
  );

  /// Default frosted fill gradient.
  LinearGradient get fill => LinearGradient(
        colors: [fillStart, fillEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Gradient used for the 1px glass rim (bright top-left → faint).
  LinearGradient get rim => LinearGradient(
        colors: [highlight, border, border.withValues(alpha: border.a * 0.4)],
        stops: const [0, 0.45, 1],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  GlassTokens copyWith({
    Color? baseTop,
    Color? baseBottom,
    List<Color>? auroraColors,
    double? auroraOpacity,
    Color? fillStart,
    Color? fillEnd,
    Color? border,
    Color? highlight,
    double? blur,
    Color? shadow,
    Color? textPrimary,
    Color? textMuted,
    Color? income,
    Color? expense,
  }) {
    return GlassTokens(
      baseTop: baseTop ?? this.baseTop,
      baseBottom: baseBottom ?? this.baseBottom,
      auroraColors: auroraColors ?? this.auroraColors,
      auroraOpacity: auroraOpacity ?? this.auroraOpacity,
      fillStart: fillStart ?? this.fillStart,
      fillEnd: fillEnd ?? this.fillEnd,
      border: border ?? this.border,
      highlight: highlight ?? this.highlight,
      blur: blur ?? this.blur,
      shadow: shadow ?? this.shadow,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      income: income ?? this.income,
      expense: expense ?? this.expense,
    );
  }

  @override
  GlassTokens lerp(GlassTokens? other, double t) {
    if (other == null) return this;
    return GlassTokens(
      baseTop: Color.lerp(baseTop, other.baseTop, t)!,
      baseBottom: Color.lerp(baseBottom, other.baseBottom, t)!,
      auroraColors: List.generate(
        auroraColors.length,
        (i) => Color.lerp(auroraColors[i], other.auroraColors[i], t)!,
      ),
      auroraOpacity: auroraOpacity + (other.auroraOpacity - auroraOpacity) * t,
      fillStart: Color.lerp(fillStart, other.fillStart, t)!,
      fillEnd: Color.lerp(fillEnd, other.fillEnd, t)!,
      border: Color.lerp(border, other.border, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      blur: blur + (other.blur - blur) * t,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
    );
  }
}

extension GlassContext on BuildContext {
  /// Glass design tokens for the current theme.
  GlassTokens get glass =>
      Theme.of(this).extension<GlassTokens>() ?? GlassTokens.dark;
}
