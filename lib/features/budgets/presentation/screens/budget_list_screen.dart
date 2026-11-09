import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/currency_text.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/glass/glass.dart';
import '../providers/budget_provider.dart';
import '../widgets/budget_progress_card.dart';
import 'set_category_budget_screen.dart';

/// Budget list screen showing all category budgets with progress
class BudgetListScreen extends ConsumerWidget {
  const BudgetListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetProgressAsync = ref.watch(allBudgetProgressProvider);
    final budgetSummaryAsync = ref.watch(budgetSummaryProvider);

    return GlassScaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SetCategoryBudgetScreen(),
                ),
              );
            },
            tooltip: 'Set Budget',
          ),
        ],
      ),
      body: budgetProgressAsync.when(
        data: (budgetProgress) {
          if (budgetProgress.isEmpty) {
            return _buildEmptyState(context);
          }

          return Column(
            children: [
              // Budget Summary Card
              budgetSummaryAsync.when(
                data: (summary) => _buildSummaryCard(context, ref, summary),
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
              ),

              // Budget List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: budgetProgress.length,
                  itemBuilder: (context, index) {
                    final progress = budgetProgress[index];
                    return BudgetProgressCard(
                      progress: progress,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SetCategoryBudgetScreen(
                              categoryId: progress.categoryId,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorView(
          message: 'Error loading budgets: $error',
          onRetry: () => ref.refresh(allBudgetProgressProvider),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    WidgetRef ref,
    BudgetSummary summary,
  ) {
    final theme = Theme.of(context);
    final totalBudget = formatCurrency(ref, summary.totalBudgetInCents);
    final totalSpent = formatCurrency(ref, summary.totalSpentInCents);
    final totalRemaining = formatCurrency(ref, summary.totalRemainingInCents);

    final progressPercentage = summary.totalBudgetInCents > 0
        ? (summary.totalSpentInCents / summary.totalBudgetInCents) * 100
        : 0.0;

    final Gradient statusGradient = progressPercentage >= 100
        ? AppColors.expenseGradient
        : progressPercentage >= 80
        ? AppColors.warningGradient
        : AppColors.incomeGradient;
    final Color statusColor = progressPercentage >= 100
        ? context.glass.expense
        : progressPercentage >= 80
        ? budgetWarningColor(context)
        : context.glass.income;

    return GlassCard(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const GlassIcon(
                Icons.donut_large_rounded,
                color: AppColors.violet,
                size: 40,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Overall Budget', style: theme.textTheme.titleMedium),
              ),
              Text(
                '${progressPercentage.toStringAsFixed(0)}%',
                style: AppTypography.amount(18).copyWith(color: statusColor),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Spent',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          GradientText(
            totalSpent,
            style: AppTypography.amount(30),
            gradient: statusGradient,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          BudgetGradientBar(
            value: progressPercentage / 100,
            gradient: statusGradient,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Total Budget',
                  totalBudget,
                  theme.colorScheme.onSurface,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  'Remaining',
                  totalRemaining,
                  summary.totalRemainingInCents >= 0
                      ? context.glass.income
                      : context.glass.expense,
                  alignEnd: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    Color color, {
    bool alignEnd = false,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.amount(
            16,
            weight: FontWeight.w600,
          ).copyWith(color: color),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyState(
      title: 'No Budgets Set',
      message: 'Set budgets for your expense categories to track your spending',
      icon: Icons.account_balance_wallet_rounded,
      color: AppColors.violet,
      action: GradientButton(
        label: 'Set Your First Budget',
        icon: Icons.add_rounded,
        expand: false,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SetCategoryBudgetScreen(),
            ),
          );
        },
      ),
    );
  }
}
