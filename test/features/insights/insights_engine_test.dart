import 'package:fin_nest/features/insights/domain/insights_engine.dart';
import 'package:flutter_test/flutter_test.dart';

/// Whole rupees → cents
int r(int rupees) => rupees * 100;

String money(int cents) => '₹${cents ~/ 100}';

const food = InsightCategory(id: 1, name: 'Food & Dining');
const shopping = InsightCategory(id: 2, name: 'Shopping');
const salary = InsightCategory(id: 10, name: 'Salary');

InsightTransaction exp(DateTime d, int rupees, {int cat = 1, String desc = ''}) =>
    InsightTransaction(
      date: d,
      amountCents: r(rupees),
      isIncome: false,
      categoryId: cat,
      description: desc,
    );

InsightTransaction inc(DateTime d, int rupees) => InsightTransaction(
  date: d,
  amountCents: r(rupees),
  isIncome: true,
  categoryId: 10,
);

InsightsEngine engine(
  List<InsightTransaction> txs, {
  List<InsightCategory> categories = const [food, shopping, salary],
  List<InsightRecurring> recurring = const [],
}) => InsightsEngine(
  transactions: txs,
  categories: categories,
  recurring: recurring,
  money: money,
);

/// Three steady past months (Aug–Oct 2026): salary 1,00,000, food 10,000,
/// shopping 5,000 each
List<InsightTransaction> steadyHistory() => [
  for (final m in [8, 9, 10]) ...[
    inc(DateTime(2026, m, 1), 100000),
    exp(DateTime(2026, m, 5), 6000),
    exp(DateTime(2026, m, 20), 4000),
    exp(DateTime(2026, m, 12), 5000, cat: 2),
  ],
];

void main() {
  group('getting started', () {
    test('too little data gives one onboarding insight', () {
      final out = engine([
        exp(DateTime(2026, 11, 2), 100),
      ]).compute(DateTime(2026, 11, 10));
      expect(out, hasLength(1));
      expect(out.single.id, 'getting-started');
      expect(out.single.action, InsightAction.addTransaction);
    });

    test('new users still see bills due this week', () {
      final out = engine(
        [exp(DateTime(2026, 11, 2), 100)],
        recurring: [
          InsightRecurring(
            description: 'Netflix',
            amountCents: r(649),
            isIncome: false,
            nextOccurrence: DateTime(2026, 11, 14),
          ),
        ],
      ).compute(DateTime(2026, 11, 10));
      expect(out.map((i) => i.id), ['upcoming-recurring', 'getting-started']);
    });
  });

  group('budget alerts', () {
    final now = DateTime(2026, 11, 20); // 10 days left in November
    final budgeted = [
      const InsightCategory(id: 1, name: 'Food & Dining', budgetCents: 1000000), // ₹10,000
      shopping,
      salary,
    ];

    List<InsightTransaction> spending(int foodRupees) => [
      ...steadyHistory(),
      inc(DateTime(2026, 11, 1), 100000),
      exp(DateTime(2026, 11, 3), foodRupees),
    ];

    test('over budget is an alert with the overrun', () {
      final out = engine(spending(12000), categories: budgeted).budgetAlerts(now);
      expect(out.single.id, 'budget-over:1');
      expect(out.single.tone, InsightTone.alert);
      expect(out.single.amountCents, r(2000));
      expect(out.single.body, contains('10 days to go'));
    });

    test('80% or more is a warning with what is left', () {
      final out = engine(spending(8500), categories: budgeted).budgetAlerts(now);
      expect(out.single.id, 'budget-near:1');
      expect(out.single.tone, InsightTone.warning);
      expect(out.single.amountCents, r(1500));
    });

    test('under 80% says nothing; no budget says nothing', () {
      expect(engine(spending(7000), categories: budgeted).budgetAlerts(now), isEmpty);
      expect(engine(spending(12000)).budgetAlerts(now), isEmpty);
    });
  });

  group('category spikes', () {
    test('already above a typical month is a priority-1 alert', () {
      final out = engine([
        ...steadyHistory(),
        exp(DateTime(2026, 11, 3), 12000), // food avg 10,000
      ]).categorySpikes(DateTime(2026, 11, 5));
      expect(out.single.id, 'spike:1');
      expect(out.single.tone, InsightTone.alert);
      expect(out.single.priority, 1);
    });

    test('running hot mid-month is a warning', () {
      // Day 15 of 30: expected ~5,000; 7,000 is 40% over pace
      final out = engine([
        ...steadyHistory(),
        exp(DateTime(2026, 11, 10), 7000),
      ]).categorySpikes(DateTime(2026, 11, 15));
      expect(out.single.tone, InsightTone.warning);
      expect(out.single.signal, contains('day 15 of 30'));
    });

    test('pace rule stays quiet in the first week', () {
      // Day 3: expected ~1,000; 2,000 is "200%" but too early to judge
      final out = engine([
        ...steadyHistory(),
        exp(DateTime(2026, 11, 2), 2000),
      ]).categorySpikes(DateTime(2026, 11, 3));
      expect(out, isEmpty);
    });

    test('a few percent over a normal month is not flagged early', () {
      // Day 5: 10,800 vs 10,000 average is only 8% over a full month
      final out = engine([
        ...steadyHistory(),
        exp(DateTime(2026, 11, 3), 10800),
      ]).categorySpikes(DateTime(2026, 11, 5));
      expect(out, isEmpty);
    });

    test('needs at least two months of history', () {
      final out = engine([
        inc(DateTime(2026, 10, 1), 100000),
        exp(DateTime(2026, 10, 5), 1000),
        exp(DateTime(2026, 10, 6), 1000),
        exp(DateTime(2026, 11, 3), 9000),
        exp(DateTime(2026, 11, 4), 9000),
      ]).categorySpikes(DateTime(2026, 11, 20));
      expect(out, isEmpty);
    });
  });

  group('month balance', () {
    test('last month deficit is an alert', () {
      final out = engine([
        ...steadyHistory().where((t) => t.date.month != 10),
        inc(DateTime(2026, 10, 1), 20000),
        exp(DateTime(2026, 10, 5), 26000),
      ]).monthBalance(DateTime(2026, 11, 4));
      expect(out.single.id, 'deficit-last');
      expect(out.single.amountCents, r(6000));
    });

    test('projected overspend from day 10 on', () {
      // Day 15 of 30, income 20,000, expenses 12,000 → projected 24,000
      final txs = [
        ...steadyHistory(),
        inc(DateTime(2026, 11, 1), 20000),
        exp(DateTime(2026, 11, 8), 12000, cat: 2),
      ];
      final out = engine(txs).monthBalance(DateTime(2026, 11, 15));
      expect(out.map((i) => i.id), contains('deficit-projected'));
      // Not before day 10
      expect(engine(txs).monthBalance(DateTime(2026, 11, 9)), isEmpty);
    });
  });

  group('savings rate', () {
    test('a 5+ point improvement is positive', () {
      final out = engine([
        inc(DateTime(2026, 9, 1), 100000),
        exp(DateTime(2026, 9, 5), 70000),
        inc(DateTime(2026, 10, 1), 100000),
        exp(DateTime(2026, 10, 5), 50000),
        exp(DateTime(2026, 10, 6), 100),
      ]).savingsRateChange(DateTime(2026, 11, 5));
      expect(out.single.tone, InsightTone.positive);
      expect(out.single.title, contains('50%'));
      expect(out.single.body, contains('30%'));
    });

    test('a drop is a warning; small changes say nothing', () {
      final drop = engine([
        inc(DateTime(2026, 9, 1), 100000),
        exp(DateTime(2026, 9, 5), 40000),
        inc(DateTime(2026, 10, 1), 100000),
        exp(DateTime(2026, 10, 5), 70000),
        exp(DateTime(2026, 10, 6), 100),
      ]).savingsRateChange(DateTime(2026, 11, 5));
      expect(drop.single.tone, InsightTone.warning);

      final flat = engine(steadyHistory()).savingsRateChange(DateTime(2026, 11, 5));
      expect(flat, isEmpty);
    });
  });

  group('large transactions', () {
    test('2.5× the category median in the last week is flagged', () {
      final out = engine([
        ...steadyHistory(),
        exp(DateTime(2026, 11, 8), 15000, desc: 'Anniversary dinner'),
      ]).largeTransactions(DateTime(2026, 11, 10));
      expect(out.single.title, 'Unusually large: Anniversary dinner');
      expect(out.single.amountCents, r(15000));
    });

    test('normal sizes and thin history are ignored', () {
      expect(
        engine([
          ...steadyHistory(),
          exp(DateTime(2026, 11, 8), 6000),
        ]).largeTransactions(DateTime(2026, 11, 10)),
        isEmpty,
      );
      // Shopping has only 3 samples: not enough to judge
      expect(
        engine([
          ...steadyHistory(),
          exp(DateTime(2026, 11, 8), 50000, cat: 2),
        ]).largeTransactions(DateTime(2026, 11, 10)),
        isEmpty,
      );
    });
  });

  group('upcoming recurring', () {
    test('sums expense bills due within 7 days, ignores income and later', () {
      final now = DateTime(2026, 11, 10);
      final out = engine(steadyHistory(), recurring: [
        InsightRecurring(description: 'Netflix', amountCents: r(649), isIncome: false, nextOccurrence: DateTime(2026, 11, 12)),
        InsightRecurring(description: 'Rent', amountCents: r(26000), isIncome: false, nextOccurrence: DateTime(2026, 11, 15)),
        InsightRecurring(description: 'Salary', amountCents: r(100000), isIncome: true, nextOccurrence: DateTime(2026, 11, 11)),
        InsightRecurring(description: 'Gym', amountCents: r(1500), isIncome: false, nextOccurrence: DateTime(2026, 11, 25)),
      ]).upcomingRecurring(now);
      expect(out.single.title, '2 bills due this week');
      expect(out.single.amountCents, r(26649));
      expect(out.single.body, contains('Netflix, Rent'));
      expect(out.single.action, InsightAction.viewRecurring);
    });
  });

  group('category wins', () {
    test('the biggest drop last month is celebrated', () {
      final out = engine([
        // Jul–Sep: food 10,000 a month; Oct: 4,000
        for (final m in [7, 8, 9]) ...[
          inc(DateTime(2026, m, 1), 100000),
          exp(DateTime(2026, m, 5), 10000),
        ],
        inc(DateTime(2026, 10, 1), 100000),
        exp(DateTime(2026, 10, 5), 4000),
      ]).categoryWins(DateTime(2026, 11, 5));
      expect(out.single.tone, InsightTone.positive);
      expect(out.single.title, 'Nice: Food & Dining down 60%');
      expect(out.single.amountCents, r(6000));
    });
  });

  group('compute', () {
    test('sorts by priority and caps the list', () {
      final out = engine(
        [
          ...steadyHistory(),
          inc(DateTime(2026, 11, 1), 100000),
          exp(DateTime(2026, 11, 3), 11000),
          exp(DateTime(2026, 11, 4), 30000, cat: 2),
        ],
        recurring: [
          InsightRecurring(description: 'Netflix', amountCents: r(649), isIncome: false, nextOccurrence: DateTime(2026, 11, 12)),
        ],
      ).compute(DateTime(2026, 11, 10));
      expect(out.length, lessThanOrEqualTo(InsightsEngine.maxInsights));
      final priorities = out.map((i) => i.priority).toList();
      expect(priorities, orderedEquals([...priorities]..sort()));
      expect(out.first.priority, 1);
      expect(out.map((i) => i.id), contains('upcoming-recurring'));
    });
  });
}
