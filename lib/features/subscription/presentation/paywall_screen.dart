import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/subscription_config.dart';
import '../../../core/widgets/glass/glass.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../data/subscription_service.dart';
import 'controllers/subscription_providers.dart';

/// Why the paywall opened; tailors the headline
enum PaywallReason {
  general(
    'Unlock FinNest Premium',
    'More AI help to understand and grow your money.',
  ),
  aiLimit(
    "You've used today's free AI",
    'Free accounts get ${SubscriptionConfig.freeChatDaily} AI messages a day. '
        'Premium gives you up to ${SubscriptionConfig.premiumChatDaily}.',
  ),
  premiumFeature(
    'This is a Premium feature',
    'Upgrade to unlock it, along with everything else in Premium.',
  );

  const PaywallReason(this.title, this.subtitle);

  final String title;
  final String subtitle;
}

/// Opens the paywall; resolves to true if the user is Premium afterwards
Future<bool> showPaywall(
  BuildContext context, {
  PaywallReason reason = PaywallReason.general,
}) async {
  final result = await Navigator.of(context).push<bool>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => PaywallScreen(reason: reason),
    ),
  );
  return result ?? false;
}

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key, this.reason = PaywallReason.general});

  final PaywallReason reason;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  Package? _selected;
  bool _busy = false;
  String? _error;

  /// (icon, color, title, detail, available now)
  static const _benefits = [
    (
      Icons.auto_awesome_rounded,
      AppColors.violet,
      'Ask FinNest, all day',
      'Up to ${SubscriptionConfig.premiumChatDaily} AI messages a day instead of '
          '${SubscriptionConfig.freeChatDaily}',
      true,
    ),
    (
      Icons.tips_and_updates_rounded,
      AppColors.cyan,
      'Personal AI suggestions',
      'A full feed of tips built from your spending, refreshed any time',
      false,
    ),
    (
      Icons.summarize_rounded,
      AppColors.pink,
      'Monthly AI report',
      'A score, wins, concerns and goals for every month',
      false,
    ),
    (
      Icons.category_rounded,
      AppColors.income,
      'Smart categories',
      'Picks the category as you type a description',
      false,
    ),
  ];

  List<Package> _plans(Offering offering) {
    final plans = [?offering.annual, ?offering.monthly];
    return plans.isNotEmpty ? plans : offering.availablePackages;
  }

  Future<void> _buy() async {
    final package = _selected;
    if (package == null) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final unlocked = await ref.read(subscriptionServiceProvider).purchase(package);
      if (unlocked && mounted) Navigator.pop(context, true);
    } on PurchaseFailure catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final unlocked = await ref.read(subscriptionServiceProvider).restore();
      if (!mounted) return;
      if (unlocked) {
        Navigator.pop(context, true);
      } else {
        setState(() => _error = 'No active Premium purchase was found.');
      }
    } on PurchaseFailure catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPremium = ref.watch(isPremiumProvider);
    final offering = ref.watch(currentOfferingProvider);

    return GlassScaffold(
      animateBackground: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Close',
          onPressed: () => Navigator.pop(context, isPremium),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            const Center(
              child: GlassIcon(
                Icons.workspace_premium_rounded,
                color: AppColors.warning,
                size: 88,
              ),
            ),
            const SizedBox(height: 20),
            GradientText(
              isPremium ? "You're Premium" : widget.reason.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              isPremium
                  ? 'Thanks for supporting FinNest. Everything is unlocked.'
                  : widget.reason.subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Column(
                children: [
                  for (final (icon, color, title, detail, available) in _benefits)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          GlassIcon(icon, color: color, size: 40, glow: false),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(title, style: theme.textTheme.titleSmall),
                                    ),
                                    if (!available) ...[
                                      const SizedBox(width: 8),
                                      const _Pill('Soon', AppColors.cyan),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(detail, style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (isPremium)
              GradientButton(
                label: 'Done',
                onPressed: () => Navigator.pop(context, true),
              )
            else
              offering.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: LoadingIndicator(size: 32),
                ),
                error: (e, _) => _Notice(
                  'Could not load plans. Check your connection and try again.',
                  onRetry: () => ref.invalidate(currentOfferingProvider),
                ),
                data: (offering) {
                  if (offering == null) {
                    return const _Notice(
                      "Subscriptions aren't available in this build yet.",
                    );
                  }
                  final plans = _plans(offering);
                  _selected ??= plans.firstOrNull;
                  return _buildPlans(context, plans);
                },
              ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(color: context.glass.expense),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlans(BuildContext context, List<Package> plans) {
    final theme = Theme.of(context);
    final selected = _selected;
    final trial = selected == null ? null : trialLabel(selected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final plan in plans)
          _PlanCard(
            package: plan,
            selected: plan == selected,
            trial: trialLabel(plan),
            onTap: _busy ? null : () => setState(() => _selected = plan),
          ),
        const SizedBox(height: 8),
        GradientButton(
          label: trial != null ? 'Start $trial' : 'Continue',
          icon: Icons.workspace_premium_rounded,
          isLoading: _busy,
          gradient: AppColors.primaryGradient,
          onPressed: _busy || selected == null ? null : _buy,
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _busy ? null : _restore,
          child: const Text('Restore purchases'),
        ),
        Text(
          'Payment is charged to your Google Play account. Subscriptions renew '
          'automatically unless cancelled at least 24 hours before the end of the '
          'period. Manage or cancel anytime in Google Play.',
          textAlign: TextAlign.center,
          style: theme.textTheme.labelSmall,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final (label, url) in [
              ('Privacy Policy', LegalLinks.privacyPolicy),
              ('Terms', LegalLinks.terms),
            ])
              if (url.isNotEmpty)
                TextButton(
                  onPressed: () => launchUrl(
                    Uri.parse(url),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Text(label),
                ),
          ],
        ),
      ],
    );
  }

  /// "7-day free trial" when the plan has a free introductory phase
  static String? trialLabel(Package package) {
    final period = package.storeProduct.defaultOption?.freePhase?.billingPeriod;
    if (period != null) return '${_periodText(period.value, period.unit)} free trial';
    final intro = package.storeProduct.introductoryPrice;
    if (intro != null && intro.price == 0) {
      return '${_periodText(intro.periodNumberOfUnits, intro.periodUnit)} free trial';
    }
    return null;
  }

  static String _periodText(int value, PeriodUnit unit) {
    final name = switch (unit) {
      PeriodUnit.day => 'day',
      PeriodUnit.week => 'week',
      PeriodUnit.month => 'month',
      PeriodUnit.year => 'year',
      PeriodUnit.unknown => 'day',
    };
    return '$value-$name';
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.package,
    required this.selected,
    required this.trial,
    required this.onTap,
  });

  final Package package;
  final bool selected;
  final String? trial;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = package.storeProduct;
    final isAnnual = package.packageType == PackageType.annual;
    final accent = theme.colorScheme.primary;
    final period = switch (package.packageType) {
      PackageType.annual => 'per year',
      PackageType.monthly => 'per month',
      PackageType.weekly => 'per week',
      PackageType.lifetime => 'one time',
      _ => '',
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          GlassCard(
            blur: false,
            tint: selected ? accent : null,
            padding: const EdgeInsets.all(16),
            onTap: onTap,
            child: Row(
              children: [
                Icon(
                  selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                  color: selected ? accent : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(isAnnual ? 'Yearly' : 'Monthly', style: theme.textTheme.titleSmall),
                          if (isAnnual) ...[
                            const SizedBox(width: 8),
                            _Pill('Best value', context.glass.income),
                          ],
                        ],
                      ),
                      if (isAnnual && product.pricePerMonthString != null)
                        Text(
                          '${product.pricePerMonthString} / month',
                          style: theme.textTheme.bodySmall,
                        ),
                      if (trial != null)
                        Text(
                          trial!,
                          style: theme.textTheme.bodySmall?.copyWith(color: context.glass.income),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(product.priceString, style: AppTypography.amount(18)),
                    Text(period, style: theme.textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ),
          if (selected)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                    border: Border.all(color: accent.withValues(alpha: 0.8), width: 1.5),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice(this.message, {this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
