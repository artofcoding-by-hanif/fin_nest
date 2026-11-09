import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'glass_card.dart';

/// An icon on a glossy glass tile: tinted translucent fill, light rim,
/// a specular highlight across the top, a gradient glyph and a soft glow.
class GlassIcon extends StatelessWidget {
  final IconData icon;

  /// Tint color; the glyph gradient and glow are derived from it.
  final Color color;

  /// Overrides the glyph gradient.
  final Gradient? gradient;
  final double size;
  final bool circle;
  final bool glow;

  const GlassIcon(
    this.icon, {
    super.key,
    this.color = AppColors.violet,
    this.gradient,
    this.size = 44,
    this.circle = false,
    this.glow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = circle ? size / 2 : size * 0.32;
    final borderRadius = BorderRadius.circular(radius);

    // Glyph: brighter on dark, deeper on light, so it always pops.
    final hsl = HSLColor.fromColor(color);
    final glyphA = hsl
        .withLightness(isDark ? 0.80 : 0.42)
        .withSaturation((hsl.saturation + 0.1).clamp(0, 1))
        .toColor();
    final glyphB = hsl
        .withHue((hsl.hue + 30) % 360)
        .withLightness(isDark ? 0.66 : 0.34)
        .toColor();
    final glyphGradient = gradient ??
        LinearGradient(
          colors: [glyphA, glyphB],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: glow
            ? [
                BoxShadow(
                  color: color.withValues(alpha: isDark ? 0.35 : 0.22),
                  blurRadius: size * 0.45,
                  spreadRadius: -size * 0.12,
                  offset: Offset(0, size * 0.12),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Tinted glass body.
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: isDark ? 0.42 : 0.28),
                    color.withValues(alpha: isDark ? 0.10 : 0.10),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Specular highlight across the top half.
            Align(
              alignment: Alignment.topCenter,
              child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 0.55,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: isDark ? 0.28 : 0.65),
                        Colors.white.withValues(alpha: 0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            // Rim.
            CustomPaint(
              painter: GlassRimPainter(
                radius: radius,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: isDark ? 0.55 : 0.95),
                    color.withValues(alpha: 0.25),
                    Colors.white.withValues(alpha: isDark ? 0.10 : 0.4),
                  ],
                  stops: const [0, 0.6, 1],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // Gradient glyph.
            Center(
              child: ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => glyphGradient.createShader(bounds),
                child: Icon(icon, size: size * 0.5, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
