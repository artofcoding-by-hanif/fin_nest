import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/glass_tokens.dart';

/// Deep-space gradient with soft aurora light blobs.
///
/// Static by default (cheap). Pass `animate: true` on hero screens
/// (splash, onboarding, lock) for a slow drifting glow.
class AuroraBackground extends StatefulWidget {
  final bool animate;
  final Widget? child;

  const AuroraBackground({super.key, this.animate = false, this.child});

  @override
  State<AuroraBackground> createState() => _AuroraBackgroundState();
}

class _AuroraBackgroundState extends State<AuroraBackground>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _syncController();
  }

  @override
  void didUpdateWidget(covariant AuroraBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate != widget.animate) _syncController();
  }

  void _syncController() {
    if (widget.animate && _controller == null) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 18),
      )..repeat();
    } else if (!widget.animate && _controller != null) {
      _controller!.dispose();
      _controller = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glass = context.glass;
    // Respect the OS "reduce motion" setting.
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final paint = _controller == null || still
        ? CustomPaint(painter: _AuroraPainter(glass, 0))
        : AnimatedBuilder(
            animation: _controller!,
            builder: (_, _) => CustomPaint(
              painter: _AuroraPainter(glass, _controller!.value),
            ),
          );

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.expand,
        children: [
          paint,
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

class _AuroraPainter extends CustomPainter {
  final GlassTokens glass;
  final double t;

  _AuroraPainter(this.glass, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Base vertical gradient.
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          colors: [glass.baseTop, glass.baseBottom],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(rect),
    );

    // Aurora blobs: (relative x, relative y, radius factor).
    const anchors = [
      (0.05, 0.02, 0.85),
      (1.0, 0.30, 0.75),
      (0.15, 0.78, 0.80),
      (0.95, 1.0, 0.70),
    ];
    final colors = glass.auroraColors;
    final base = math.max(size.width, size.height * 0.6);

    for (var i = 0; i < anchors.length; i++) {
      final (ax, ay, r) = anchors[i];
      final phase = t * 2 * math.pi + i * 1.7;
      final dx = math.sin(phase) * size.width * 0.06;
      final dy = math.cos(phase * 0.8) * size.height * 0.04;
      final center = Offset(ax * size.width + dx, ay * size.height + dy);
      final radius = base * r;
      final color = colors[i % colors.length];

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: glass.auroraOpacity),
              color.withValues(alpha: glass.auroraOpacity * 0.35),
              color.withValues(alpha: 0),
            ],
            stops: const [0, 0.45, 1],
          ).createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AuroraPainter old) =>
      old.t != t || old.glass != glass;
}
