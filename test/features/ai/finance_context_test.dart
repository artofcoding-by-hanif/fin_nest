import 'dart:convert';

import 'package:fin_nest/features/ai/domain/finance_context.dart';
import 'package:fin_nest/features/insights/domain/insights_engine.dart';
import 'package:flutter_test/flutter_test.dart';

int r(int rupees) => rupees * 100;

final now = DateTime(2026, 11, 10, 12);

FinanceSnapshot snapshot({List<InsightTransaction>? transactions}) => FinanceSnapshot(
  currency: 'INR',
  transactions: transactions ??
      [
        InsightTransaction(date: DateTime(2026, 10, 1), amountCents: r(100000), isIncome: true, categoryId: 10, description: 'Salary Oct'),
        InsightTransaction(date: DateTime(2026, 10, 5), amountCents: r(6000), isIncome: false, categoryId: 1, description: 'Groceries'),
        InsightTransaction(date: DateTime(2026, 10, 12), amountCents: r(5000), isIncome: false, categoryId: 2, description: 'Shoes'),
        InsightTransaction(date: DateTime(2026, 11, 1), amountCents: r(100000), isIncome: true, categoryId: 10, description: 'Salary Nov'),
        InsightTransaction(date: DateTime(2026, 11, 3), amountCents: 123456, isIncome: false, categoryId: 1, description: 'Dinner  '),
      ],
  categories: const [
    InsightCategory(id: 1, name: 'Food & Dining', budgetCents: 800000),
    InsightCategory(id: 2, name: 'Shopping'),
    InsightCategory(id: 10, name: 'Salary'),
  ],
  recurring: [
    ContextRecurring(description: 'Netflix', amountCents: r(649), isIncome: false, frequency: 'monthly', nextOccurrence: DateTime(2026, 11, 14)),
  ],
  savings: const [ContextSaving(category: 'ppf', investedCents: 17500000, currentCents: 18200000)],
  signals: const ['Food & Dining at 15% of its ₹8,000 budget'],
);

void main() {
  test('monthly history, this month, budgets and balance in whole units', () {
    final c = FinanceContextBuilder.build(snapshot(), now: now, shareDescriptions: true);
    expect(c['currency'], 'INR');
    expect(c['today'], '2026-11-10');
    expect(c['balance'], 100000 + 100000 - 6000 - 5000 - 1235);

    final monthly = c['monthly'] as List;
    expect(monthly, hasLength(1)); // only October has data
    expect(monthly.single, {
      'month': '2026-10',
      'income': 100000,
      'expense': 11000,
      'byCategory': {'Food & Dining': 6000, 'Shopping': 5000},
    });

    final thisMonth = c['thisMonth'] as Map;
    expect(thisMonth['month'], '2026-11');
    expect(thisMonth['expense'], 1235); // 1234.56 rounded
    expect(thisMonth['daysLeft'], 20);
    expect(thisMonth['budgets'], [
      {'category': 'Food & Dining', 'limit': 8000, 'spent': 1235},
    ]);

    expect((c['recurring'] as List).single['next'], '2026-11-14');
    expect(c['savings'], [
      {'category': 'ppf', 'invested': 175000, 'current': 182000},
    ]);
    expect(c['signals'], ['Food & Dining at 15% of its ₹8,000 budget']);
  });

  test('descriptions are sent only with consent', () {
    final withConsent = FinanceContextBuilder.build(snapshot(), now: now, shareDescriptions: true);
    final recent = withConsent['recentTransactions'] as List;
    expect(recent.first, {
      'date': '2026-11-03',
      'type': 'expense',
      'amount': 1235,
      'category': 'Food & Dining',
      'description': 'Dinner',
    });
    expect(withConsent['descriptionsShared'], isTrue);

    final without = FinanceContextBuilder.build(snapshot(), now: now, shareDescriptions: false);
    expect(without.containsKey('recentTransactions'), isFalse);
    expect(without['descriptionsShared'], isFalse);
    final json = jsonEncode(without);
    for (final text in ['Groceries', 'Shoes', 'Dinner', 'Salary Oct']) {
      expect(json, isNot(contains(text)), reason: '"$text" must not leak');
    }
  });

  test('never includes sensitive fields', () {
    final json = jsonEncode(
      FinanceContextBuilder.build(snapshot(), now: now, shareDescriptions: true),
    );
    for (final key in ['accountNumber', 'bankName', 'institution', 'notes', 'payee', 'location', 'tags']) {
      expect(json, isNot(contains(key)));
    }
  });

  test('long descriptions are truncated and old transactions skipped', () {
    final c = FinanceContextBuilder.build(
      snapshot(transactions: [
        InsightTransaction(date: DateTime(2026, 11, 2), amountCents: r(10), isIncome: false, categoryId: 1, description: 'x' * 200),
        InsightTransaction(date: DateTime(2026, 8, 1), amountCents: r(10), isIncome: false, categoryId: 1, description: 'too old'),
      ]),
      now: now,
      shareDescriptions: true,
    );
    final recent = c['recentTransactions'] as List;
    expect(recent, hasLength(1));
    expect((recent.single['description'] as String).length, FinanceContextBuilder.descriptionChars);
  });

  test('extra categories are folded into "Other (combined)"', () {
    final c = FinanceContextBuilder.build(
      FinanceSnapshot(
        currency: 'INR',
        transactions: [
          for (var i = 0; i < 14; i++)
            InsightTransaction(date: DateTime(2026, 10, 2), amountCents: r(100 + i), isIncome: false, categoryId: i),
        ],
        categories: [for (var i = 0; i < 14; i++) InsightCategory(id: i, name: 'Cat $i')],
        recurring: const [],
        savings: const [],
        signals: const [],
      ),
      now: now,
      shareDescriptions: false,
    );
    final byCategory = ((c['monthly'] as List).single as Map)['byCategory'] as Map;
    expect(byCategory, hasLength(FinanceContextBuilder.categoriesPerMonth + 1));
    expect(byCategory['Other (combined)'], 100 + 101 + 102 + 103);
    expect(c.containsKey('recurring'), isFalse);
    expect(c.containsKey('signals'), isFalse);
  });
}
