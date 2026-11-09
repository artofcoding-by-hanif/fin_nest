import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/glass/glass.dart';
import '../../../../core/widgets/loading_indicator.dart';

/// Splash screen shown on app launch. The parent `App` decides when to
/// move on to onboarding or the dashboard.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1600),
    vsync: this,
  )..forward();

  late final Animation<double> _logo = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
  );
  late final Animation<double> _text = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassScaffold(
      animateBackground: true,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo with a soft halo
              FadeTransition(
                opacity: _logo,
                child: ScaleTransition(
                  scale: Tween(begin: 0.7, end: 1.0).animate(_logo),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 240,
                        height: 240,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [Color(0x668B5CF6), Color(0x008B5CF6)],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.violet.withValues(alpha: 0.5),
                              blurRadius: 40,
                              spreadRadius: -6,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: const FinNestLogo(size: 128),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Name + tagline
              FadeTransition(
                opacity: _text,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(_text),
                  child: Column(
                    children: [
                      GradientText(
                        'FinNest',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Wealth Management Partner',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 56),
              const LoadingIndicator(size: 34),
            ],
          ),
        ),
      ),
    );
  }
}
