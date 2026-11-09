import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/models/currency_config.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/services/biometric_auth_service.dart';
import '../../../../core/settings/app_settings.dart';
import '../../../../core/widgets/glass/glass.dart';
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

    return GlassScaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.restart_alt_rounded, color: context.glass.expense),
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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          // Theme Section
          _SettingsGroup(
            title: 'Appearance',
            children: [_buildThemeTile(context, settings, settingsNotifier)],
          ),

          // Units Section
          _SettingsGroup(
            title: 'Units & Formats',
            children: [
              _buildCurrencyFormatTile(context, settings, settingsNotifier),
              _buildDateFormatTile(context, settings, settingsNotifier),
              _buildNumberFormatTile(context, settings, settingsNotifier),
              _buildDefaultCurrencyTile(context, settings, settingsNotifier),
            ],
          ),

          // Security Section
          _SettingsGroup(
            title: 'Security',
            children: [_buildBiometricTile(settings, settingsNotifier)],
          ),

          // Notifications Section
          _SettingsGroup(
            title: 'Notifications',
            children: [_buildNotificationsTile(settings, settingsNotifier)],
          ),

          // Data Management Section
          _SettingsGroup(
            title: 'Data Management',
            children: [
              _buildExportDataTile(context, ref),
              _buildImportDataTile(context, ref),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeTile(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return _SettingsRow(
      icon: _themeIcon(settings.themeMode),
      color: AppColors.violet,
      title: 'Theme',
      subtitle: settings.themeMode.displayName,
      trailing: const _Chevron(),
      onTap: () => _showThemeDialog(context, settings, notifier),
    );
  }

  Widget _buildCurrencyFormatTile(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return _SettingsRow(
      icon: Icons.attach_money_rounded,
      color: AppColors.income,
      title: 'Currency Format',
      subtitle: settings.currencyFormat.displayName,
      trailing: const _Chevron(),
      onTap: () => _showCurrencyFormatDialog(context, settings, notifier),
    );
  }

  Widget _buildDateFormatTile(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return _SettingsRow(
      icon: Icons.calendar_today_rounded,
      color: AppColors.cyan,
      title: 'Date Format',
      subtitle: settings.dateFormat.displayName,
      trailing: const _Chevron(),
      onTap: () => _showDateFormatDialog(context, settings, notifier),
    );
  }

  Widget _buildNumberFormatTile(
    BuildContext context,
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return _SettingsRow(
      icon: Icons.numbers_rounded,
      color: AppColors.indigo,
      title: 'Number Format',
      subtitle: settings.numberFormat.displayName,
      trailing: const _Chevron(),
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
    return _SettingsRow(
      icon: Icons.monetization_on_rounded,
      color: AppColors.warning,
      title: 'Default Currency',
      subtitle: '${currency.flag ?? ''} ${currency.name} (${currency.code})',
      trailing: const _Chevron(),
      onTap: () => _showDefaultCurrencyDialog(context, settings, notifier),
    );
  }

  Widget _buildBiometricTile(AppSettings settings, SettingsNotifier notifier) {
    return _SettingsRow(
      icon: Icons.fingerprint_rounded,
      color: AppColors.pink,
      title: 'Biometric Authentication',
      subtitle: 'Use fingerprint or face ID',
      trailing: Switch(
        value: settings.biometricEnabled,
        onChanged: (value) => _handleBiometricToggle(value, notifier),
      ),
      onTap: () =>
          _handleBiometricToggle(!settings.biometricEnabled, notifier),
    );
  }

  Widget _buildNotificationsTile(
    AppSettings settings,
    SettingsNotifier notifier,
  ) {
    return _SettingsRow(
      icon: Icons.notifications_rounded,
      color: AppColors.blue,
      title: 'Notifications',
      subtitle: 'Enable push notifications',
      trailing: Switch(
        value: settings.notificationsEnabled,
        onChanged: (value) => notifier.setNotificationsEnabled(value),
      ),
      onTap: () =>
          notifier.setNotificationsEnabled(!settings.notificationsEnabled),
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
                  Icon(_themeIcon(mode), size: 20),
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
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                title: Text(currency.name),
                subtitle: Text('${currency.code} (${currency.symbol})'),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle_rounded,
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

    return _SettingsRow(
      icon: Icons.upload_file_rounded,
      color: AppColors.savings,
      title: 'Export Data',
      subtitle: 'Backup all your data to a file',
      trailing: exportState.isLoading
          ? const _RowSpinner()
          : const _Chevron(),
      enabled: !exportState.isLoading,
      onTap: () => _handleExport(context, ref),
    );
  }

  Widget _buildImportDataTile(BuildContext context, WidgetRef ref) {
    final importState = ref.watch(importProvider);

    return _SettingsRow(
      icon: Icons.download_rounded,
      color: AppColors.expense,
      title: 'Import Data',
      subtitle: 'Restore data from a backup file',
      trailing: importState.isLoading
          ? const _RowSpinner()
          : const _Chevron(),
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
              backgroundColor: context.glass.income,
            ),
          );
        }
      } else {
        // Authentication failed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.errorMessage ?? 'Authentication failed'),
              backgroundColor: context.glass.expense,
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
              backgroundColor: context.glass.expense,
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
          backgroundColor: context.glass.expense,
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
              icon: const Icon(Icons.share_rounded),
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
            style: FilledButton.styleFrom(
              backgroundColor: context.glass.expense,
            ),
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
          backgroundColor: context.glass.expense,
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
                  Text(
                    'Imported:',
                    style: Theme.of(context).textTheme.titleSmall,
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
                    style: Theme.of(context).textTheme.titleSmall,
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
            backgroundColor: context.glass.expense,
          ),
        );
      }
    }
  }
}

IconData _themeIcon(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.light:
      return Icons.light_mode_rounded;
    case AppThemeMode.dark:
      return Icons.dark_mode_rounded;
    case AppThemeMode.system:
      return Icons.brightness_auto_rounded;
  }
}

/// A labelled group of settings rows on a single glass panel.
class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) rows.add(const Divider(indent: 66, endIndent: 16));
      rows.add(children[i]);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 10),
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
          ),
          GlassCard(
            padding: EdgeInsets.zero,
            radius: AppTheme.radiusL,
            child: Column(mainAxisSize: MainAxisSize.min, children: rows),
          ),
        ],
      ),
    );
  }
}

/// One settings row: glass icon, title, subtitle and a trailing control.
class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  const _SettingsRow({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
            child: Row(
              children: [
                GlassIcon(icon, color: color, size: 36),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_right_rounded,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}

class _RowSpinner extends StatelessWidget {
  const _RowSpinner();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(4),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
