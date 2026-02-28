import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/widgets/currency_text.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
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
                  padding: const EdgeInsets.all(16),
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
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading budgets: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(allBudgetProgressProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
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

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Budget',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                  context,
                  'Total Budget',
                  totalBudget,
                  Colors.blue,
                ),
                _buildSummaryItem(context, 'Spent', totalSpent, Colors.orange),
                _buildSummaryItem(
                  context,
                  'Remaining',
                  totalRemaining,
                  summary.totalRemainingInCents >= 0
                      ? Colors.green
                      : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progressPercentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                progressPercentage >= 100
                    ? Colors.red
                    : progressPercentage >= 80
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'No Budgets Set',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Set budgets for your expense categories to track your spending',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SetCategoryBudgetScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Set Your First Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
