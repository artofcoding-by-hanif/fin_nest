import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/feature_flags.dart';
import '../config/feature_flag_provider.dart';
import 'glass/glass.dart';

/// Debug screen to view and toggle feature flags
/// Only available in debug mode
class FeatureFlagsDebugScreen extends ConsumerWidget {
  const FeatureFlagsDebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flags = ref.watch(featureFlagNotifierProvider);
    final notifier = ref.read(featureFlagNotifierProvider.notifier);

    final theme = Theme.of(context);

    return GlassScaffold(
      appBar: AppBar(
        title: const Text('Feature Flags'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              notifier.clearAllOverrides();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All overrides cleared')),
              );
            },
            tooltip: 'Clear all overrides',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        itemCount: FeatureFlag.values.length,
        itemBuilder: (context, index) {
          final flag = FeatureFlag.values[index];
          final isEnabled = flags[flag.key] ?? false;

          return GlassCard(
            blur: false,
            margin: const EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.zero,
            radius: AppTheme.radiusM,
            child: ExpansionTile(
              shape: const Border(),
              collapsedShape: const Border(),
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 4,
              ),
              leading: GlassIcon(
                isEnabled ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isEnabled
                    ? context.glass.income
                    : theme.colorScheme.onSurfaceVariant,
                size: 36,
                glow: isEnabled,
              ),
              title: Text(
                flag.displayName,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                flag.key,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Switch(
                value: isEnabled,
                onChanged: (value) {
                  notifier.setLocalOverride(flag, value);
                },
              ),
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flag.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.clear_rounded),
                            label: const Text('Clear Override'),
                            onPressed: () {
                              notifier.clearLocalOverride(flag);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Widget to conditionally show content based on feature flag
class FeatureGate extends ConsumerWidget {
  const FeatureGate({
    super.key,
    required this.flag,
    required this.child,
    this.fallback,
  });

  final FeatureFlag flag;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(watchFeatureFlagProvider(flag));

    if (isEnabled) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}

/// Widget to show different content based on feature flag state
class FeatureFlagBuilder extends ConsumerWidget {
  const FeatureFlagBuilder({
    super.key,
    required this.flag,
    required this.enabled,
    required this.disabled,
  });

  final FeatureFlag flag;
  final Widget enabled;
  final Widget disabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(watchFeatureFlagProvider(flag));
    return isEnabled ? enabled : disabled;
  }
}

/// Mixin to easily check feature flags in widgets
mixin FeatureFlagMixin on ConsumerWidget {
  bool isFeatureEnabled(WidgetRef ref, FeatureFlag flag) {
    return ref.watch(watchFeatureFlagProvider(flag));
  }
}

