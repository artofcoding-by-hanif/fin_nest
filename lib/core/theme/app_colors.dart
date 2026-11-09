import 'package:flutter/material.dart';

/// FinNest "Aurora Glass" palette.
///
/// Dark is the hero look: deep-space navy with violet/cyan/pink aurora
/// light. Light mode uses the same accents over a soft lavender sky.
class AppColors {
  AppColors._();

  // ── Brand accents (shared by both modes) ──────────────────────────────
  static const Color cyan = Color(0xFF22D3EE);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color indigo = Color(0xFF6366F1);
  static const Color pink = Color(0xFFEC4899);
  static const Color blue = Color(0xFF3B82F6);

  // ── Semantic ──────────────────────────────────────────────────────────
  static const Color income = Color(0xFF34D399); // emerald
  static const Color incomeDeep = Color(0xFF059669);
  static const Color expense = Color(0xFFFB7185); // rose
  static const Color expenseDeep = Color(0xFFE11D48);
  static const Color warning = Color(0xFFFBBF24);
  static const Color savings = Color(0xFF60A5FA);

  // ── Dark surfaces ─────────────────────────────────────────────────────
  static const Color darkBase = Color(0xFF060918);
  static const Color darkBase2 = Color(0xFF0C1230);
  static const Color darkText = Color(0xFFF1F4FF);
  static const Color darkTextMuted = Color(0xFFA3ABCB);

  // ── Light surfaces ────────────────────────────────────────────────────
  static const Color lightBase = Color(0xFFF1F0FF);
  static const Color lightBase2 = Color(0xFFE6F4FF);
  static const Color lightText = Color(0xFF0E1330);
  static const Color lightTextMuted = Color(0xFF5B6386);

  // ── Gradients ─────────────────────────────────────────────────────────
  /// Signature accent: cyan → violet → pink.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [cyan, violet, pink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Calmer two-stop accent for buttons and highlights.
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF6D5DFC), Color(0xFFB04CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF34D399), Color(0xFF22D3EE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFFB7185), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient savingsGradient = LinearGradient(
    colors: [Color(0xFF60A5FA), Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Two-stop gradient derived from any color (used for category tints).
  static LinearGradient tintGradient(Color color) {
    final hsl = HSLColor.fromColor(color);
    final shifted = hsl
        .withHue((hsl.hue + 28) % 360)
        .withLightness((hsl.lightness * 0.92).clamp(0.0, 1.0))
        .toColor();
    return LinearGradient(
      colors: [color, shifted],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Income/expense color that reads well on the current brightness.
  static Color incomeOn(Brightness b) =>
      b == Brightness.dark ? income : incomeDeep;
  static Color expenseOn(Brightness b) =>
      b == Brightness.dark ? expense : expenseDeep;
}
