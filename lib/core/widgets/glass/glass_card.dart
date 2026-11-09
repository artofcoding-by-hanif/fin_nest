import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Frosted glass panel: translucent gradient fill, backdrop blur, a 1px
/// light rim that's brighter at the top-left, and a soft shadow.
///
/// Use `blur: false` for items in long lists; over the aurora background
/// it looks almost identical and is much cheaper to scroll.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool blur;

  /// Optional color wash mixed into the glass (e.g. income green).
  final Color? tint;

  /// Replaces the frosted fill entirely (e.g. a vivid hero gradient).
  final Gradient? gradient;
  final double? width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin,
    this.radius = AppTheme.radiusL,
    this.onTap,
    this.onLongPress,
    this.blur = true,
    this.tint,
    this.gradient,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final glass = context.glass;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderRadius = BorderRadius.circular(radius);

    final Gradient fill = gradient ??
        (tint == null
            ? glass.fill
            : LinearGradient(
                colors: [
                  Color.alphaBlend(
                    tint!.withValues(alpha: isDark ? 0.22 : 0.16),
                    glass.fillStart,
                  ),
                  Color.alphaBlend(
                    tint!.withValues(alpha: isDark ? 0.06 : 0.05),
                    glass.fillEnd,
                  ),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ));

    Widget content = Padding(padding: padding, child: child);

    if (onTap != null || onLongPress != null) {
      content = Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: borderRadius,
          child: content,
        ),
      );
    }

    Widget panel = DecoratedBox(
      decoration: BoxDecoration(gradient: fill),
      position: DecorationPosition.background,
      child: CustomPaint(
        foregroundPainter: GlassRimPainter(
          radius: radius,
          gradient: glass.rim,
        ),
        child: content,
      ),
    );

    if (blur) {
      panel = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: glass.blur, sigmaY: glass.blur),
        child: panel,
      );
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      // Only opaque (gradient) cards cast a shadow: under a translucent
      // glass fill the shadow would show through as a dark band.
      decoration: gradient == null
          ? null
          : BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: gradient!.colors.first.withValues(alpha: 0.35),
                  blurRadius: 32,
                  spreadRadius: -10,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
      child: ClipRRect(borderRadius: borderRadius, child: panel),
    );
  }
}

/// Paints a 1px gradient stroke around a rounded rect — the glass "rim".
class GlassRimPainter extends CustomPainter {
  final double radius;
  final Gradient gradient;
  final double strokeWidth;

  const GlassRimPainter({
    required this.radius,
    required this.gradient,
    this.strokeWidth = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..shader = gradient.createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(covariant GlassRimPainter old) =>
      old.radius != radius ||
      old.gradient != gradient ||
      old.strokeWidth != strokeWidth;
}
