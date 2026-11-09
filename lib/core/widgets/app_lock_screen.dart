import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_lock_provider.dart';
import 'glass/glass.dart';
import 'loading_indicator.dart';

/// Screen shown when app is locked
/// Displays biometric authentication prompt
class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  bool _hasAttemptedAuth = false;

  @override
  void initState() {
    super.initState();
    // Trigger authentication after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticate();
    });
  }

  Future<void> _authenticate() async {
    if (_hasAttemptedAuth) {
      return;
    }

    _hasAttemptedAuth = true;
    final authService = ref.read(appLockAuthProvider);
    await authService.authenticate();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAuthenticating = ref.watch(isAuthenticatingProvider);

    return GlassScaffold(
      animateBackground: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FinNestLogo(size: 72),
                const SizedBox(height: 16),
                Text('FinNest', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 40),
                GlassCard(
                  radius: AppTheme.radiusXL,
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: Column(
                    children: [
                      const GlassIcon(
                        Icons.fingerprint_rounded,
                        color: AppColors.cyan,
                        size: 92,
                      ),
                      const SizedBox(height: 24),
                      Text('App Locked', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text(
                        isAuthenticating
                            ? 'Authenticating...'
                            : 'Authenticate to continue',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),
                      if (isAuthenticating)
                        const LoadingIndicator(size: 34)
                      else
                        GradientButton(
                          label: 'Unlock',
                          icon: Icons.lock_open_rounded,
                          onPressed: () {
                            setState(() {
                              _hasAttemptedAuth = false;
                            });
                            _authenticate();
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
