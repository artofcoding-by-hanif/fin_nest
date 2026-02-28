import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/models/currency_config.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/services/biometric_auth_service.dart';
import '../../../../core/settings/app_settings.dart';
import '../../../data_export/presentation/providers/export_provider.dart';

/// Settings screen for app preferences
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await settingsNotifier.resetToDefaults();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings reset to defaults')),
                );
              }
            },
            tooltip: 'Reset to defaults',
          ),
        ],
      ),
      body: ListView(
        children: [
          // Theme Section
          _buildSectionHeader('Appearance'),
          _buildThemeTile(context, settings, settingsNotifier),
          const Divider(),

          // Units Section
          _buildSectionHeader('Units & Formats'),
          _buildCurrencyFormatTile(context, settings, settingsNotifier),
          _buildDateFormatTile(context, settings, settingsNotifier),
          _buildNumberFormatTile(context, settings, settingsNotifier),
          _buildDefaultCurrencyTile(context, settings, settingsNotifier),
          const Divider(),

          // Security Section
          _buildSectionHeader('Security'),
          _buildBiometricTile(settings, settingsNotifier),
          const Divider(),

          // Notifications Section
          _buildSectionHeader('Notifications'),
          _buildNotificationsTile(settings, settingsNotifier),
          const Divider(),

          // Data Management Section
          _buildSectionHeader('Data Management'),
          _buildExportDataTile(context, ref),
          _buildImportDataTile(context, ref),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildThemeTile(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return ListTile(
      leading: Icon(settings.themeMode.icon),
      title: const Text('Theme'),
      subtitle: Text(settings.themeMode.displayName),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showThemeDialog(context, settings, notifier),
    );
  }

  Widget _buildCurrencyFormatTile(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return ListTile(
      leading: const Icon(Icons.attach_money),
      title: const Text('Currency Format'),
      subtitle: Text(settings.currencyFormat.displayName),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showCurrencyFormatDialog(context, settings, notifier),
    );
  }

  Widget _buildDateFormatTile(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: const Text('Date Format'),
      subtitle: Text(settings.dateFormat.displayName),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showDateFormatDialog(context, settings, notifier),
    );
  }

  Widget _buildNumberFormatTile(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return ListTile(
      leading: const Icon(Icons.numbers),
      title: const Text('Number Format'),
      subtitle: Text(settings.numberFormat.displayName),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showNumberFormatDialog(context, settings, notifier),
    );
  }

  Widget _buildDefaultCurrencyTile(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    final currency = SupportedCurrencies.getByCodeOrDefault(
      settings.defaultCurrency,
    );
    return ListTile(
      leading: const Icon(Icons.monetization_on),
      title: const Text('Default Currency'),
      subtitle: Text(
        '${currency.flag ?? ''} ${currency.name} (${currency.code})',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showDefaultCurrencyDialog(context, settings, notifier),
    );
  }

  Widget _buildBiometricTile(AppSettings settings, SettingsNotifier notifier) {
    return SwitchListTile(
      secondary: const Icon(Icons.fingerprint),
      title: const Text('Biometric Authentication'),
      subtitle: const Text('Use fingerprint or face ID'),
      value: settings.biometricEnabled,
      onChanged: (value) => _handleBiometricToggle(value, notifier),
    );
  }

  Widget _buildNotificationsTile(
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return SwitchListTile(
      secondary: const Icon(Icons.notifications),
      title: const Text('Notifications'),
      subtitle: const Text('Enable push notifications'),
      value: settings.notificationsEnabled,
      onChanged: (value) => notifier.setNotificationsEnabled(value),
    );
  }

  // Dialog methods
  void _showThemeDialog(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppThemeMode.values.map((mode) {
            return RadioListTile<AppThemeMode>(
              title: Row(
                children: [
                  Icon(mode.icon, size: 20),
                  const SizedBox(width: 12),
                  Text(mode.displayName),
                ],
              ),
              value: mode,
              groupValue: settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  notifier.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCurrencyFormatDialog(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: CurrencyFormat.values.map((format) {
            return RadioListTile<CurrencyFormat>(
              title: Text(format.displayName),
              value: format,
              groupValue: settings.currencyFormat,
              onChanged: (value) {
                if (value != null) {
                  notifier.setCurrencyFormat(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDateFormatDialog(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Date Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DateFormatPreference.values.map((format) {
            return RadioListTile<DateFormatPreference>(
              title: Text(format.displayName),
              value: format,
              groupValue: settings.dateFormat,
              onChanged: (value) {
                if (value != null) {
                  notifier.setDateFormat(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showNumberFormatDialog(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Number Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: NumberFormatPreference.values.map((format) {
            return RadioListTile<NumberFormatPreference>(
              title: Text(format.displayName),
              value: format,
              groupValue: settings.numberFormat,
              onChanged: (value) {
                if (value != null) {
                  notifier.setNumberFormat(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDefaultCurrencyDialog(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: SupportedCurrencies.all.length,
            itemBuilder: (context, index) {
              final currency = SupportedCurrencies.all[index];
              final isSelected = currency.code == settings.defaultCurrency;

              return ListTile(
                leading: Text(
                  currency.flag ?? currency.symbol,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(currency.name),
                subtitle: Text('${currency.code} (${currency.symbol})'),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                selected: isSelected,
                onTap: () {
                  notifier.setDefaultCurrency(currency.code);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildExportDataTile(BuildContext context, WidgetRef ref) {
    final exportState = ref.watch(exportProvider);

    return ListTile(
      leading: const Icon(Icons.upload_file),
      title: const Text('Export Data'),
      subtitle: const Text('Backup all your data to a file'),
      trailing: exportState.isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_right),
      enabled: !exportState.isLoading,
      onTap: () => _handleExport(context, ref),
    );
  }

  Widget _buildImportDataTile(BuildContext context, WidgetRef ref) {
    final importState = ref.watch(importProvider);

    return ListTile(
      leading: const Icon(Icons.download),
      title: const Text('Import Data'),
      subtitle: const Text('Restore data from a backup file'),
      trailing: importState.isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_right),
      enabled: !importState.isLoading,
      onTap: () => _handleImport(context, ref),
    );
  }

  Future<void> _handleBiometricToggle(
    bool value,
    SettingsNotifier notifier,
  ) async {
    if (value) {
      // Enabling biometric authentication
      final biometricService = BiometricAuthService.instance;

      // Check if device supports biometrics
      final canCheck = await biometricService.canCheckBiometrics();
      final isSupported = await biometricService.isDeviceSupported();

      if (!canCheck || !isSupported) {
        // Show error dialog
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Biometric Not Available'),
              content: const Text(
                'Biometric authentication is not available on this device. '
                'Please make sure your device supports biometrics and that '
                'you have enrolled at least one biometric (fingerprint or face).',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return;
      }

      // Check available biometrics
      final availableBiometrics = await biometricService
          .getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        // No biometrics enrolled
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('No Biometrics Enrolled'),
              content: const Text(
                'You have not enrolled any biometrics on this device. '
                'Please go to your device settings and set up fingerprint or face recognition.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
        return;
      }

      // Get biometric type name for display
      String biometricType = 'biometric';
      if (availableBiometrics.contains(BiometricType.face)) {
        biometricType = 'Face ID';
      } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
        biometricType = 'fingerprint';
      } else if (availableBiometrics.contains(BiometricType.iris)) {
        biometricType = 'iris';
      }

      // Authenticate to enable
      final result = await biometricService.authenticate(
        localizedReason: 'Authenticate to enable $biometricType for FinNest',
      );

      if (result.success) {
        // Enable biometric authentication
        await notifier.setBiometricEnabled(true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$biometricType authentication enabled'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Authentication failed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.errorMessage ?? 'Authentication failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Disabling biometric authentication - require authentication first
      final biometricService = BiometricAuthService.instance;

      final result = await biometricService.authenticate(
        localizedReason: 'Authenticate to disable biometric authentication',
      );

      if (result.success) {
        // Disable biometric authentication
        await notifier.setBiometricEnabled(false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Biometric authentication disabled')),
          );
        }
      } else {
        // Authentication failed - keep it enabled
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.errorMessage ?? 'Authentication required to disable',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleExport(BuildContext context, WidgetRef ref) async {
    final exportNotifier = ref.read(exportProvider.notifier);

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'This will export all your data including transactions, accounts, '
          'categories, budgets, and settings to a JSON file.\n\n'
          'You can use this file to restore your data later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Export'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Perform export
    await exportNotifier.exportData();

    if (!context.mounted) return;

    final exportState = ref.read(exportProvider);

    if (exportState.error != null) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(exportState.error!),
          backgroundColor: Colors.red,
        ),
      );
    } else if (exportState.filePath != null) {
      // Show success and offer to share
      final share = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Export Successful'),
          content: Text(
            'Data exported successfully!\n\n'
            'File saved to:\n${exportState.filePath}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('OK'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.share),
              label: const Text('Share'),
            ),
          ],
        ),
      );

      if (share == true && context.mounted) {
        await exportNotifier.shareExportedFile();
      }
    }
  }

  Future<void> _handleImport(BuildContext context, WidgetRef ref) async {
    final importNotifier = ref.read(importProvider.notifier);

    // Show warning dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Data'),
        content: const Text(
          'WARNING: This will replace all your current data with the data '
          'from the backup file.\n\n'
          'This action cannot be undone. Make sure you have a recent backup '
          'before proceeding.\n\n'
          'Do you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Import'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Perform import
    await importNotifier.importData();

    if (!context.mounted) return;

    final importState = ref.read(importProvider);

    if (importState.error != null) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(importState.error!),
          backgroundColor: Colors.red,
        ),
      );
    } else if (importState.result != null) {
      final result = importState.result!;

      if (result.success) {
        // Show success with stats
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Import Successful'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result.message),
                  const SizedBox(height: 16),
                  const Text(
                    'Imported:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('• ${result.stats.usersImported} users'),
                  Text('• ${result.stats.accountsImported} accounts'),
                  Text('• ${result.stats.categoriesImported} categories'),
                  Text('• ${result.stats.transactionsImported} transactions'),
                  Text(
                    '• ${result.stats.recurringTransactionsImported} recurring transactions',
                  ),
                  Text('• ${result.stats.budgetsImported} budgets'),
                  Text(
                    '• ${result.stats.budgetCategoriesImported} budget categories',
                  ),
                  Text('• ${result.stats.goalsImported} goals'),
                  if (result.stats.settingsImported)
                    const Text('• Settings imported'),
                  const SizedBox(height: 8),
                  Text(
                    'Total: ${result.stats.totalItems} items',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Show error from result
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error ?? 'Import failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
