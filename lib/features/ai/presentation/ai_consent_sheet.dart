import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/glass/glass.dart';
import '../data/ai_preferences.dart';

/// Explains what the AI sees and asks for consent before first use.
///
/// Returns true if the user agreed. With [reviewOnly] it just explains
/// (from Settings) and returns null.
Future<bool?> showAiConsentSheet(
  BuildContext context, {
  bool reviewOnly = false,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _AiConsentSheet(reviewOnly: reviewOnly),
  );
}

/// Ensures consent before an AI feature runs. Returns true when AI may be used.
Future<bool> ensureAiConsent(BuildContext context, WidgetRef ref) async {
  final prefs = ref.read(aiPreferencesProvider);
  if (prefs.ready) return true;
  if (prefs.consentGiven && !prefs.enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('AI features are turned off. Turn them on in Settings > AI & Privacy.'),
      ),
    );
    return false;
  }
  return await showAiConsentSheet(context) ?? false;
}

class _AiConsentSheet extends ConsumerStatefulWidget {
  const _AiConsentSheet({required this.reviewOnly});

  final bool reviewOnly;

  @override
  ConsumerState<_AiConsentSheet> createState() => _AiConsentSheetState();
}

class _AiConsentSheetState extends ConsumerState<_AiConsentSheet> {
  late bool _shareDescriptions = ref.read(aiPreferencesProvider).shareDescriptions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glass = context.glass;

    Widget point(IconData icon, Color color, String title, String body) => Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassIcon(icon, color: color, size: 36, glow: false),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(body, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const GlassIcon(Icons.auto_awesome_rounded, color: AppColors.violet, size: 48),
                const SizedBox(width: 14),
                Expanded(
                  child: Text('How FinNest AI works', style: theme.textTheme.titleLarge),
                ),
              ],
            ),
            const SizedBox(height: 20),
            point(
              Icons.summarize_rounded,
              AppColors.cyan,
              'A summary is sent with each question',
              'Monthly income and spending by category, this month\'s budgets, '
                  'recurring bills, savings totals and your Smart Insights.',
            ),
            point(
              Icons.lock_rounded,
              glass.income,
              'Never sent',
              'Account numbers, bank names, notes, payees, locations and the names '
                  'of your savings. Your data stays stored on this phone.',
            ),
            point(
              Icons.cloud_rounded,
              AppColors.savings,
              'Processed by Google Gemini',
              'Your question and the summary go through FinNest\'s secure server to '
                  'Google\'s Gemini AI to write the answer. FinNest\'s server keeps only '
                  'a daily usage count.',
            ),
            point(
              Icons.info_rounded,
              AppColors.warning,
              'Not financial advice',
              'AI can make mistakes. Check important numbers and talk to a '
                  'professional for tax, loan or investment decisions.',
            ),
            GlassCard(
              blur: false,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              radius: AppTheme.radiusM,
              child: SwitchListTile(
                value: _shareDescriptions,
                onChanged: widget.reviewOnly
                    ? null
                    : (v) => setState(() => _shareDescriptions = v),
                title: const Text('Include recent transaction descriptions'),
                subtitle: const Text(
                  'Better answers ("Swiggy", "Rent"). Turn off to send totals only.',
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (widget.reviewOnly)
              GradientButton(
                label: 'Got it',
                onPressed: () => Navigator.of(context).pop(),
              )
            else ...[
              GradientButton(
                label: 'Agree and continue',
                icon: Icons.check_rounded,
                onPressed: () async {
                  await ref
                      .read(aiPreferencesProvider.notifier)
                      .giveConsent(shareDescriptions: _shareDescriptions);
                  if (context.mounted) Navigator.of(context).pop(true);
                },
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Not now'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
