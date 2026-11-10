/// Builds the compact, privacy-safe summary the AI sees.
///
/// Pure Dart so the redaction and shape can be unit-tested. What is NEVER
/// included: account numbers, bank/institution names, notes, payees,
/// locations, tags, attachments, savings names. Recent transaction
/// descriptions are included only when the user allows it.
library;

import '../../insights/domain/insights_engine.dart';

class ContextRecurring {
  const ContextRecurring({
    required this.description,
    required this.amountCents,
    required this.isIncome,
    required this.frequency,
    required this.nextOccurrence,
  });

  final String description;
  final int amountCents;
  final bool isIncome;

  /// e.g. "monthly"
  final String frequency;
  final DateTime nextOccurrence;
}

class ContextSaving {
  const ContextSaving({
    required this.category,
    required this.investedCents,
    required this.currentCents,
  });

  /// Savings category, e.g. "mutualFund" (never the user's own name for it)
  final String category;
  final int investedCents;
  final int currentCents;
}

/// Everything the builder needs, already read from the database
class FinanceSnapshot {
  const FinanceSnapshot({
    required this.currency,
    required this.transactions,
    required this.categories,
    required this.recurring,
    required this.savings,
    required this.signals,
  });

  final String currency;
  final List<InsightTransaction> transactions;
  final List<InsightCategory> categories;
  final List<ContextRecurring> recurring;
  final List<ContextSaving> savings;

  /// One-line facts from the on-device InsightsEngine
  final List<String> signals;
}

class FinanceContextBuilder {
  FinanceContextBuilder._();

  /// Months of history (besides the current month)
  static const int historyMonths = 6;

  /// Categories listed per month; the rest are summed as "Other"
  static const int categoriesPerMonth = 10;

  /// Recent transactions sent when descriptions are allowed
  static const int recentTransactions = 60;
  static const int recentDays = 60;
  static const int descriptionChars = 80;

  /// Whole currency units (the server prompt expects these)
  static int units(int cents) => (cents / 100).round();

  static String _ymd(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String _ym(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}';

  static Map<String, Object?> build(
    FinanceSnapshot s, {
    required DateTime now,
    required bool shareDescriptions,
  }) {
    final names = {for (final c in s.categories) c.id: c.name};
    String nameOf(int? id) => names[id] ?? 'Uncategorised';

    // ── Monthly totals ────────────────────────────────────────────────
    Map<String, Object?> month(DateTime start) {
      final end = DateTime(start.year, start.month + 1, 1);
      var income = 0;
      var expense = 0;
      final byCategory = <String, int>{};
      for (final t in s.transactions) {
        if (t.date.isBefore(start) || !t.date.isBefore(end)) continue;
        if (t.isIncome) {
          income += t.amountCents;
        } else {
          expense += t.amountCents;
          final n = nameOf(t.categoryId);
          byCategory[n] = (byCategory[n] ?? 0) + t.amountCents;
        }
      }
      final sorted = byCategory.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      final top = sorted.take(categoriesPerMonth);
      final rest = sorted.skip(categoriesPerMonth).fold<int>(0, (a, e) => a + e.value);
      return {
        'month': _ym(start),
        'income': units(income),
        'expense': units(expense),
        'byCategory': {
          for (final e in top) e.key: units(e.value),
          if (rest > 0) 'Other (combined)': units(rest),
        },
      };
    }

    final monthly = <Map<String, Object?>>[];
    for (var i = historyMonths; i >= 1; i--) {
      final start = DateTime(now.year, now.month - i, 1);
      final m = month(start);
      if (m['income'] != 0 || m['expense'] != 0) monthly.add(m);
    }

    // ── This month ────────────────────────────────────────────────────
    final monthStart = DateTime(now.year, now.month, 1);
    final current = month(monthStart);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final spentThisMonth = <int?, int>{};
    for (final t in s.transactions) {
      if (t.isIncome || t.date.isBefore(monthStart) || t.date.isAfter(now)) continue;
      spentThisMonth[t.categoryId] = (spentThisMonth[t.categoryId] ?? 0) + t.amountCents;
    }
    final budgets = [
      for (final c in s.categories)
        if ((c.budgetCents ?? 0) > 0)
          {
            'category': c.name,
            'limit': units(c.budgetCents!),
            'spent': units(spentThisMonth[c.id] ?? 0),
          },
    ];

    // ── Balance from all completed transactions ───────────────────────
    final balance = s.transactions.fold<int>(
      0,
      (sum, t) => t.isIncome ? sum + t.amountCents : sum - t.amountCents,
    );

    // ── Recent transactions (consent-gated) ───────────────────────────
    List<Map<String, Object?>>? recent;
    if (shareDescriptions) {
      final since = now.subtract(const Duration(days: recentDays));
      final list = s.transactions
          .where((t) => !t.date.isBefore(since) && !t.date.isAfter(now))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      recent = [
        for (final t in list.take(recentTransactions))
          {
            'date': _ymd(t.date),
            'type': t.isIncome ? 'income' : 'expense',
            'amount': units(t.amountCents),
            'category': nameOf(t.categoryId),
            if (t.description.trim().isNotEmpty)
              'description': t.description.trim().length > descriptionChars
                  ? t.description.trim().substring(0, descriptionChars)
                  : t.description.trim(),
          },
      ];
    }

    return {
      'currency': s.currency,
      'today': _ymd(now),
      'balance': units(balance),
      'monthly': monthly,
      'thisMonth': {
        'month': current['month'],
        'income': current['income'],
        'expense': current['expense'],
        'byCategory': current['byCategory'],
        'day': now.day,
        'daysLeft': daysInMonth - now.day,
        if (budgets.isNotEmpty) 'budgets': budgets,
      },
      if (s.recurring.isNotEmpty)
        'recurring': [
          for (final r in s.recurring)
            {
              'description': r.description,
              'amount': units(r.amountCents),
              'type': r.isIncome ? 'income' : 'expense',
              'frequency': r.frequency,
              'next': _ymd(r.nextOccurrence),
            },
        ],
      if (s.savings.isNotEmpty)
        'savings': [
          for (final v in s.savings)
            {
              'category': v.category,
              'invested': units(v.investedCents),
              'current': units(v.currentCents),
            },
        ],
      if (s.signals.isNotEmpty) 'signals': s.signals,
      'recentTransactions': ?recent,
      'descriptionsShared': shareDescriptions,
    };
  }
}
