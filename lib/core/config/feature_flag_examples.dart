/// Examples of how to use feature flags in your code
/// 
/// This file contains practical examples for reference.
/// Delete this file once you're familiar with the feature flag system.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'feature_flags.dart';
import 'feature_flag_provider.dart';
import '../widgets/feature_flags_debug_screen.dart';

// ============================================================================
// Example 1: Simple feature check in a widget
// ============================================================================

class BiometricLoginExample extends ConsumerWidget {
  const BiometricLoginExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBiometricEnabled = ref.watch(
      watchFeatureFlagProvider(FeatureFlag.biometricAuth),
    );

    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Regular login
          },
          child: const Text('Login with Password'),
        ),
        if (isBiometricEnabled)
          ElevatedButton(
            onPressed: () {
              // Biometric login
            },
            child: const Text('Login with Biometrics'),
          ),
      ],
    );
  }
}

// ============================================================================
// Example 2: Using FeatureGate widget
// ============================================================================

class DashboardExample extends StatelessWidget {
  const DashboardExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Dashboard'),
        
        // Show AI insights only if feature is enabled
        FeatureGate(
          flag: FeatureFlag.aiInsights,
          child: const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('AI-powered insights will appear here'),
            ),
          ),
        ),
        
        // Show with fallback message
        FeatureGate(
          flag: FeatureFlag.investmentRecommendations,
          child: const InvestmentRecommendationsWidget(),
          fallback: const Text('Investment recommendations coming soon!'),
        ),
      ],
    );
  }
}

class InvestmentRecommendationsWidget extends StatelessWidget {
  const InvestmentRecommendationsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Investment recommendations'),
      ),
    );
  }
}

// ============================================================================
// Example 3: Using FeatureFlagBuilder
// ============================================================================

class NotificationSettingsExample extends StatelessWidget {
  const NotificationSettingsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FeatureFlagBuilder(
          flag: FeatureFlag.pushNotifications,
          enabled: const SwitchListTile(
            title: Text('Push Notifications'),
            value: true,
            onChanged: null,
          ),
          disabled: const ListTile(
            title: Text('Push Notifications'),
            subtitle: Text('Not available in your region'),
            enabled: false,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// Example 4: Using FeatureFlagMixin
// ============================================================================

class TransactionListExample extends ConsumerWidget with FeatureFlagMixin {
  const TransactionListExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canAttachFiles = isFeatureEnabled(ref, FeatureFlag.transactionAttachments);
    final canBulkEdit = isFeatureEnabled(ref, FeatureFlag.bulkTransactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          if (canBulkEdit)
            IconButton(
              icon: const Icon(Icons.checklist),
              onPressed: () {
                // Bulk edit mode
              },
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Transaction $index'),
            trailing: canAttachFiles
                ? IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {
                      // Attach file
                    },
                  )
                : null,
          );
        },
      ),
    );
  }
}

// ============================================================================
// Example 5: Programmatic feature check
// ============================================================================

class SyncServiceExample {
  final WidgetRef ref;

  SyncServiceExample(this.ref);

  Future<void> syncData() async {
    final cloudSyncEnabled = ref.read(
      watchFeatureFlagProvider(FeatureFlag.cloudSync),
    );
    final autoSyncEnabled = ref.read(
      watchFeatureFlagProvider(FeatureFlag.autoSync),
    );

    if (!cloudSyncEnabled) {
      print('Cloud sync is disabled');
      return;
    }

    if (autoSyncEnabled) {
      // Perform automatic sync
      print('Auto-syncing data...');
    } else {
      // Manual sync only
      print('Manual sync required');
    }
  }
}

