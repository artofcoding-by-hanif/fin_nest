import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/firebase/firebase_bootstrap.dart';
import '../../../../core/widgets/glass/glass.dart';
import '../../../ai/data/ai_preferences.dart';
import '../../../ai/presentation/chat_screen.dart';
import '../../../transactions/presentation/screens/add_expense_screen.dart';
import '../../../transactions/presentation/screens/recurring_transactions_list_screen.dart';
import '../../../transactions/presentation/screens/transaction_list_screen.dart';
import '../../domain/insights_engine.dart';
import '../providers/insights_provider.dart';

/// Dashboard section: on-device Smart Insights as a horizontal glass carousel
class InsightsSection extends ConsumerWidget {
  const InsightsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(smartInsightsProvider);
    final list = insights.value;
    if (list == null || list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Smart Insights'),
        SizedBox(
          height: 176,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) => SizedBox(
              width: list.length == 1
                  ? MediaQuery.sizeOf(context).width - 40
                  : 280,
              child: InsightCard(insight: list[i]),
            ),
          ),
        ),
      ],
    );
  }
}

class InsightCard extends ConsumerWidget {
  const InsightCard({super.key, required this.insight});

  final Insight insight;

  static (Color, IconData) toneStyle(BuildContext context, InsightTone tone) {
    final glass = context.glass;
    switch (tone) {
      case InsightTone.alert:
        return (glass.expense, Icons.priority_high_rounded);
      case InsightTone.warning:
        return (AppColors.warning, Icons.warning_amber_rounded);
      case InsightTone.positive:
        return (glass.income, Icons.emoji_events_rounded);
      case InsightTone.info:
        return (AppColors.cyan, Icons.lightbulb_rounded);
    }
  }

  void _open(BuildContext context) {
    final Widget? page = switch (insight.action) {
      InsightAction.viewHistory => const TransactionListScreen(),
      InsightAction.viewRecurring => const RecurringTransactionsListScreen(),
      InsightAction.addTransaction => const AddExpenseScreen(),
      InsightAction.none => null,
    };
    if (page != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final (toneColor, toneIcon) = toneStyle(context, insight.tone);
    final category = insight.categoryId == null
        ? null
        : ref.watch(insightCategoriesProvider)[insight.categoryId];
    final hasAction = insight.action != InsightAction.none;
    final prefs = ref.watch(aiPreferencesProvider);
    final canAsk =
        FirebaseBootstrap.isReady &&
        !(prefs.consentGiven && !prefs.enabled) &&
        insight.id != 'getting-started';

    return GlassCard(
      blur: false,
      tint: toneColor,
      radius: AppTheme.radiusL,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      onTap: hasAction ? () => _open(context) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GlassIcon(
                category == null
                    ? toneIcon
                    : CategoryVisuals.icon(category.icon),
                color: category == null
                    ? toneColor
                    : CategoryVisuals.vivid(category.color),
                size: 38,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  insight.title,
                  style: theme.textTheme.titleSmall?.copyWith(height: 1.25),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: toneColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: toneColor.withValues(alpha: 0.6),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              insight.body,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasAction || canAsk)
            Row(
              children: [
                if (canAsk)
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () => ChatScreen.open(
                      context,
                      ref,
                      initialPrompt:
                          'Explain this insight using my numbers and tell me what to do about it: '
                          '"${insight.title}". ${insight.body}',
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            size: 14,
                            color: AppColors.violet,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Ask AI',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.violet,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const Spacer(),
                if (hasAction) ...[
                  Text(
                    switch (insight.action) {
                      InsightAction.viewRecurring => 'View bills',
                      InsightAction.addTransaction => 'Add expense',
                      _ => 'View history',
                    },
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}
