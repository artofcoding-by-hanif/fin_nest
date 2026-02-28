import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/feature_flags.dart';
import '../config/feature_flag_provider.dart';

/// Debug screen to view and toggle feature flags
/// Only available in debug mode
class FeatureFlagsDebugScreen extends ConsumerWidget {
  const FeatureFlagsDebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flags = ref.watch(featureFlagNotifierProvider);
    final notifier = ref.read(featureFlagNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Flags'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
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
        itemCount: FeatureFlag.values.length,
        itemBuilder: (context, index) {
          final flag = FeatureFlag.values[index];
          final isEnabled = flags[flag.key] ?? false;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ExpansionTile(
              leading: Icon(
                isEnabled ? Icons.check_circle : Icons.cancel,
                color: isEnabled ? Colors.green : Colors.grey,
              ),
              title: Text(
                flag.displayName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(flag.key),
              trailing: Switch(
                value: isEnabled,
                onChanged: (value) {
                  notifier.setLocalOverride(flag, value);
                },
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flag.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.clear),
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

