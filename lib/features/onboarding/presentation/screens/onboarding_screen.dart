import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/glass/glass.dart';
import '../../domain/models/onboarding_page.dart';

/// Onboarding screen with multiple slides
class OnboardingScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({
    super.key,
    required this.onComplete,
  });

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < OnboardingPages.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pages = OnboardingPages.pages;
    final isLastPage = _currentPage == pages.length - 1;
    final pageColor = pages[_currentPage].color ?? AppColors.violet;

    return GlassScaffold(
      animateBackground: true,
      body: SafeArea(
        child: Column(
          children: [
            // Brand + Skip
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 12, 0),
              child: Row(
                children: [
                  const FinNestLogo(size: 30),
                  const SizedBox(width: 10),
                  Text('FinNest', style: theme.textTheme.titleMedium),
                  const Spacer(),
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: const Text('Skip'),
                  ),
                ],
              ),
            ),

            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPageWidget(page: pages[index]);
                },
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => _PageIndicator(
                    isActive: index == _currentPage,
                    color: pages[index].color,
                  ),
                ),
              ),
            ),

            // Next/Get Started button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: GradientButton(
                label: isLastPage ? 'Get Started' : 'Next',
                icon: isLastPage
                    ? Icons.rocket_launch_rounded
                    : Icons.arrow_forward_rounded,
                gradient: isLastPage
                    ? AppColors.primaryGradient
                    : AppColors.tintGradient(pageColor),
                onPressed: _nextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for a single onboarding page
class _OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const _OnboardingPageWidget({required this.page});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = page.color ?? theme.colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Scale the hero icon down on short screens.
        final iconSize = (constraints.maxHeight * 0.32).clamp(96.0, 148.0);
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Halo + glass icon
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: iconSize * 1.9,
                      height: iconSize * 1.9,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            color.withValues(alpha: 0.35),
                            color.withValues(alpha: 0),
                          ],
                        ),
                      ),
                    ),
                    GlassIcon(page.icon, color: color, size: iconSize),
                  ],
                ),
                const SizedBox(height: 8),

                // Text on a glass card
                GlassCard(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                  radius: AppTheme.radiusXL,
                  child: Column(
                    children: [
                      Text(
                        page.title,
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        page.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Page indicator pill
class _PageIndicator extends StatelessWidget {
  final bool isActive;
  final Color? color;

  const _PageIndicator({
    required this.isActive,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? Theme.of(context).colorScheme.primary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 28 : 8,
      height: 8,
      decoration: BoxDecoration(
        gradient: isActive ? AppColors.tintGradient(indicatorColor) : null,
        color: isActive ? null : indicatorColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: indicatorColor.withValues(alpha: 0.6),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
    );
  }
}
