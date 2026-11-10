/// On-device "Smart Insights": rule-based observations computed from the
/// user's own data. Free, offline, instant, and the same findings are sent to
/// the AI as "signals" so its suggestions start from verified facts.
///
/// Pure Dart (no database, no Flutter) so every rule is unit-testable with
/// fixed dates and amounts.
library;

/// A transaction as the engine sees it
class InsightTransaction {
  const InsightTransaction({
    required this.date,
    required this.amountCents,
    required this.isIncome,
    this.categoryId,
    this.description = '',
  });

  final DateTime date;
  final int amountCents;
  final bool isIncome;
  final int? categoryId;
  final String description;
}

class InsightCategory {
  const InsightCategory({
    required this.id,
    required this.name,
    this.icon,
    this.color,
    this.budgetCents,
  });

  final int id;
  final String name;
  final String? icon;
  final String? color;

  /// Monthly budget limit, if the user set one
  final int? budgetCents;
}

class InsightRecurring {
  const InsightRecurring({
    required this.description,
    required this.amountCents,
    required this.isIncome,
    required this.nextOccurrence,
  });

  final String description;
  final int amountCents;
  final bool isIncome;
  final DateTime nextOccurrence;
}

/// How an insight should look: drives its icon and color
enum InsightTone { alert, warning, positive, info }

/// What tapping an insight does
enum InsightAction { none, viewHistory, viewRecurring, addTransaction }

class Insight {
  const Insight({
    required this.id,
    required this.tone,
    required this.title,
    required this.body,
    required this.signal,
    required this.priority,
    this.categoryId,
    this.amountCents,
    this.action = InsightAction.none,
  });

  /// Stable per rule and subject, e.g. "spike:3"
  final String id;
  final InsightTone tone;
  final String title;
  final String body;

  /// Plain one-line fact for the AI prompt ("Food & Dining +38% vs 3-month average")
  final String signal;

  /// 1 = most important
  final int priority;
  final int? categoryId;

  /// Money at stake, when there is one
  final int? amountCents;
  final InsightAction action;
}

/// Formats an amount in cents as display money (e.g. "₹1,24,500")
typedef MoneyFormatter = String Function(int cents);

class InsightsEngine {
  InsightsEngine({
    required this.transactions,
    required this.categories,
    required this.recurring,
    required this.money,
  });

  final List<InsightTransaction> transactions;
  final List<InsightCategory> categories;
  final List<InsightRecurring> recurring;
  final MoneyFormatter money;

  /// Minimum transactions before trend rules say anything
  static const int minTransactions = 5;

  /// At most this many insights are returned
  static const int maxInsights = 6;

  late final Map<int, InsightCategory> _categoryById = {
    for (final c in categories) c.id: c,
  };

  String _name(int? categoryId) =>
      _categoryById[categoryId]?.name ?? 'Uncategorised';

  /// All insights for [now], most important first
  List<Insight> compute(DateTime now) {
    if (transactions.length < minTransactions) {
      // Trend rules need history; bills and budgets don't
      return [
        ...budgetAlerts(now),
        ...upcomingRecurring(now),
        Insight(
          id: 'getting-started',
          tone: InsightTone.info,
          title: 'Insights unlock as you track',
          body:
              'Add a few weeks of income and expenses and FinNest will start '
              'spotting trends, overspending and savings wins for you.',
          signal: 'Very little data: ${transactions.length} transactions.',
          priority: 3,
          action: InsightAction.addTransaction,
        ),
      ];
    }

    final found = <Insight>[
      ...budgetAlerts(now),
      ...categorySpikes(now),
      ...monthBalance(now),
      ...savingsRateChange(now),
      ...largeTransactions(now),
      ...upcomingRecurring(now),
      ...categoryWins(now),
    ];
    found.sort((a, b) => a.priority.compareTo(b.priority));
    return found.take(maxInsights).toList();
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  static DateTime _monthStart(DateTime d, [int offset = 0]) =>
      DateTime(d.year, d.month + offset, 1);

  static int _daysInMonth(DateTime d) => DateTime(d.year, d.month + 1, 0).day;

  Iterable<InsightTransaction> _between(DateTime from, DateTime to) =>
      transactions.where((t) => !t.date.isBefore(from) && t.date.isBefore(to));

  /// Expense totals per category for [from, to)
  Map<int?, int> _expenseByCategory(DateTime from, DateTime to) {
    final totals = <int?, int>{};
    for (final t in _between(from, to)) {
      if (t.isIncome) continue;
      totals[t.categoryId] = (totals[t.categoryId] ?? 0) + t.amountCents;
    }
    return totals;
  }

  ({int income, int expense}) _totals(DateTime from, DateTime to) {
    var income = 0;
    var expense = 0;
    for (final t in _between(from, to)) {
      if (t.isIncome) {
        income += t.amountCents;
      } else {
        expense += t.amountCents;
      }
    }
    return (income: income, expense: expense);
  }

  /// Full months before [now]'s month that contain any transaction, newest
  /// first, up to [max]
  List<DateTime> _historyMonths(DateTime now, int max) {
    final months = <DateTime>[];
    for (var i = 1; i <= 12 && months.length < max; i++) {
      final start = _monthStart(now, -i);
      if (_between(start, _monthStart(now, -i + 1)).isNotEmpty) {
        months.add(start);
      }
    }
    return months;
  }

  /// Average monthly expense per category over [months]
  Map<int?, double> _averageByCategory(List<DateTime> months) {
    final sums = <int?, int>{};
    for (final m in months) {
      final totals = _expenseByCategory(m, DateTime(m.year, m.month + 1, 1));
      totals.forEach((k, v) => sums[k] = (sums[k] ?? 0) + v);
    }
    return sums.map((k, v) => MapEntry(k, v / months.length));
  }

  static String _pct(double ratio) => '${(ratio * 100).round()}%';

  // ── Rules ──────────────────────────────────────────────────────────────

  /// Categories with a budget that are at 80% or more this month
  List<Insight> budgetAlerts(DateTime now) {
    final start = _monthStart(now);
    final spent = _expenseByCategory(start, _monthStart(now, 1));
    final daysLeft = _daysInMonth(now) - now.day;
    final out = <Insight>[];

    for (final c in categories) {
      final budget = c.budgetCents;
      if (budget == null || budget <= 0) continue;
      final used = spent[c.id] ?? 0;
      final ratio = used / budget;
      if (ratio >= 1) {
        out.add(Insight(
          id: 'budget-over:${c.id}',
          tone: InsightTone.alert,
          title: '${c.name} is over budget',
          body:
              '${money(used)} spent of your ${money(budget)} budget, '
              '${money(used - budget)} over with $daysLeft days to go.',
          signal: '${c.name} over budget: ${_pct(ratio)} of ${money(budget)} used.',
          priority: 1,
          categoryId: c.id,
          amountCents: used - budget,
          action: InsightAction.viewHistory,
        ));
      } else if (ratio >= 0.8) {
        out.add(Insight(
          id: 'budget-near:${c.id}',
          tone: InsightTone.warning,
          title: '${c.name} budget ${_pct(ratio)} used',
          body:
              '${money(budget - used)} left for $daysLeft more days this month.',
          signal: '${c.name} at ${_pct(ratio)} of its ${money(budget)} budget, $daysLeft days left.',
          priority: 2,
          categoryId: c.id,
          amountCents: budget - used,
          action: InsightAction.viewHistory,
        ));
      }
    }
    return out;
  }

  /// Categories running well above their recent monthly average
  List<Insight> categorySpikes(DateTime now) {
    final history = _historyMonths(now, 3);
    if (history.length < 2) return const [];

    final averages = _averageByCategory(history);
    final mtd = _expenseByCategory(_monthStart(now), _monthStart(now, 1));
    final dayFraction = now.day / _daysInMonth(now);
    final out = <Insight>[];

    mtd.forEach((categoryId, spent) {
      final average = averages[categoryId] ?? 0;
      if (average <= 0) return;
      final expectedSoFar = average * dayFraction;
      // Clearly past a normal month (a few % over is just noise)
      final aboveTypicalMonth = spent > average * 1.15;
      // Early in the month the pace is noisy, so only flag clear overruns
      final runningHot = now.day >= 7 && spent > expectedSoFar * 1.3;
      if (!aboveTypicalMonth && !runningHot) return;
      if (spent - expectedSoFar < average * 0.1) return; // too small to matter

      final name = _name(categoryId);
      final ratio = spent / average;
      out.add(Insight(
        id: 'spike:$categoryId',
        tone: aboveTypicalMonth ? InsightTone.alert : InsightTone.warning,
        title: aboveTypicalMonth
            ? '$name already above a normal month'
            : '$name spending is running high',
        body: aboveTypicalMonth
            ? '${money(spent)} so far vs your usual ${money(average.round())} '
                  'a month (${_pct(ratio)}).'
            : '${money(spent)} by day ${now.day}; at your usual pace it would be '
                  'about ${money(expectedSoFar.round())}.',
        signal:
            '$name month-to-date ${money(spent)} vs ${history.length}-month '
            'average ${money(average.round())}/month (day ${now.day} of ${_daysInMonth(now)}).',
        priority: aboveTypicalMonth ? 1 : 2,
        categoryId: categoryId,
        amountCents: (spent - expectedSoFar).round(),
        action: InsightAction.viewHistory,
      ));
    });
    return out;
  }

  /// Last month spent more than earned; this month on course to
  List<Insight> monthBalance(DateTime now) {
    final out = <Insight>[];

    final lastStart = _monthStart(now, -1);
    final last = _totals(lastStart, _monthStart(now));
    if (last.income > 0 && last.expense > last.income) {
      out.add(Insight(
        id: 'deficit-last',
        tone: InsightTone.alert,
        title: 'Last month you spent more than you earned',
        body:
            'Expenses ${money(last.expense)} vs income ${money(last.income)}: '
            '${money(last.expense - last.income)} short.',
        signal: 'Previous month deficit: expenses ${money(last.expense)} > income ${money(last.income)}.',
        priority: 1,
        amountCents: last.expense - last.income,
        action: InsightAction.viewHistory,
      ));
    }

    final current = _totals(_monthStart(now), _monthStart(now, 1));
    if (now.day >= 10 && current.income > 0) {
      final projected = current.expense / (now.day / _daysInMonth(now));
      if (projected > current.income * 1.05) {
        out.add(Insight(
          id: 'deficit-projected',
          tone: InsightTone.warning,
          title: 'On pace to overspend this month',
          body:
              'At this rate expenses reach about ${money(projected.round())} '
              'against ${money(current.income)} of income so far.',
          signal:
              'This month projected expenses ${money(projected.round())} vs income so far ${money(current.income)}.',
          priority: 2,
          amountCents: (projected - current.income).round(),
          action: InsightAction.viewHistory,
        ));
      }
    }
    return out;
  }

  /// Savings rate last month vs the month before
  List<Insight> savingsRateChange(DateTime now) {
    final a = _totals(_monthStart(now, -1), _monthStart(now));
    final b = _totals(_monthStart(now, -2), _monthStart(now, -1));
    if (a.income <= 0 || b.income <= 0) return const [];
    final rateA = (a.income - a.expense) / a.income;
    final rateB = (b.income - b.expense) / b.income;
    final change = rateA - rateB;
    if (change.abs() < 0.05) return const [];
    if (rateA < 0) return const []; // the deficit rule covers this

    final up = change > 0;
    return [
      Insight(
        id: 'savings-rate',
        tone: up ? InsightTone.positive : InsightTone.warning,
        title: up
            ? 'You saved ${_pct(rateA)} of your income'
            : 'Savings rate dropped to ${_pct(rateA)}',
        body: up
            ? 'Up from ${_pct(rateB)} the month before. Keep it going.'
            : 'Down from ${_pct(rateB)} the month before.',
        signal: 'Savings rate last month ${_pct(rateA)} (month before ${_pct(rateB)}).',
        priority: up ? 3 : 2,
      ),
    ];
  }

  /// Expenses in the last 7 days far above that category's usual size
  List<Insight> largeTransactions(DateTime now) {
    final weekAgo = now.subtract(const Duration(days: 7));
    final windowStart = now.subtract(const Duration(days: 97));
    final out = <Insight>[];

    for (final t in transactions) {
      if (t.isIncome || t.date.isBefore(weekAgo) || t.date.isAfter(now)) continue;
      final samples = transactions
          .where((o) =>
              !o.isIncome &&
              o.categoryId == t.categoryId &&
              !identical(o, t) &&
              !o.date.isBefore(windowStart) &&
              o.date.isBefore(weekAgo))
          .map((o) => o.amountCents)
          .toList()
        ..sort();
      if (samples.length < 5) continue;
      final median = samples[samples.length ~/ 2];
      if (median <= 0 || t.amountCents < median * 2.5) continue;

      final name = _name(t.categoryId);
      final label = t.description.trim().isEmpty ? name : t.description.trim();
      out.add(Insight(
        id: 'large:${t.date.millisecondsSinceEpoch}:${t.amountCents}',
        tone: InsightTone.info,
        title: 'Unusually large: $label',
        body:
            '${money(t.amountCents)} is about ${(t.amountCents / median).toStringAsFixed(1)}× '
            'your typical $name expense of ${money(median)}.',
        signal: 'Large $name expense ${money(t.amountCents)} (typical ${money(median)}).',
        priority: 3,
        categoryId: t.categoryId,
        amountCents: t.amountCents,
        action: InsightAction.viewHistory,
      ));
    }
    out.sort((a, b) => (b.amountCents ?? 0).compareTo(a.amountCents ?? 0));
    return out.take(1).toList();
  }

  /// Recurring expenses due in the next 7 days
  List<Insight> upcomingRecurring(DateTime now) {
    final until = now.add(const Duration(days: 7));
    final due = recurring
        .where((r) =>
            !r.isIncome &&
            !r.nextOccurrence.isBefore(now) &&
            r.nextOccurrence.isBefore(until))
        .toList()
      ..sort((a, b) => a.nextOccurrence.compareTo(b.nextOccurrence));
    if (due.isEmpty) return const [];
    final total = due.fold<int>(0, (s, r) => s + r.amountCents);
    final names = due.take(3).map((r) => r.description).join(', ');
    return [
      Insight(
        id: 'upcoming-recurring',
        tone: InsightTone.info,
        title: '${due.length} ${due.length == 1 ? 'bill' : 'bills'} due this week',
        body: '${money(total)} in total: $names${due.length > 3 ? '…' : ''}.',
        signal: 'Recurring expenses due in 7 days: ${due.length}, total ${money(total)}.',
        priority: 3,
        amountCents: total,
        action: InsightAction.viewRecurring,
      ),
    ];
  }

  /// The category that dropped the most last month vs its prior average
  List<Insight> categoryWins(DateTime now) {
    final lastStart = _monthStart(now, -1);
    final before = _historyMonths(lastStart, 3);
    if (before.length < 2) return const [];
    final averages = _averageByCategory(before);
    final last = _expenseByCategory(lastStart, _monthStart(now));

    Insight? best;
    var bestDrop = 0.0;
    averages.forEach((categoryId, average) {
      if (average <= 0) return;
      final spent = last[categoryId] ?? 0;
      final drop = average - spent;
      if (spent > average * 0.75 || drop <= bestDrop) return;
      bestDrop = drop;
      final name = _name(categoryId);
      best = Insight(
        id: 'win:$categoryId',
        tone: InsightTone.positive,
        title: 'Nice: $name down ${_pct(drop / average)}',
        body:
            '${money(spent)} last month vs your usual ${money(average.round())}. '
            "That's ${money(drop.round())} kept.",
        signal: '$name last month ${money(spent)} vs average ${money(average.round())} (down).',
        priority: 3,
        categoryId: categoryId,
        amountCents: drop.round(),
      );
    });
    return best == null ? const [] : [best!];
  }
}
