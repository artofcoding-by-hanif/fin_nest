import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fin_nest/core/database/app_database.dart';
import 'package:fin_nest/core/database/tables/categories_table.dart';

/// Tests for database creation, seeding and schema setup.
///
/// Each test uses a fresh in-memory database, so `onCreate` and
/// `beforeOpen` (which seeds initial data) run every time.
void main() {
  // Several tests open a new AppDatabase; silence drift's warning about
  // multiple instances, which is expected here.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;

  setUp(() {
    db = AppDatabase.test(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Database schema', () {
    test('uses the current schema version', () {
      expect(db.schemaVersion, 10);
    });

    test('creates every table', () async {
      // Selecting from each table fails if it was not created.
      for (final table in db.allTables) {
        await db.select(table).get();
      }
      expect(db.allTables.map((t) => t.actualTableName), containsAll([
        'users',
        'accounts',
        'categories',
        'transactions',
        'budgets',
        'budget_categories',
        'goals',
        'recurring_transactions',
        'savings',
        'savings_transactions',
        'ai_conversations',
        'ai_messages',
      ]));
    });

    test('enables foreign keys', () async {
      final result = await db.customSelect('PRAGMA foreign_keys').get();
      expect(result.first.data['foreign_keys'], 1);
    });

    test('recurring_transactions has the v9 notification columns', () async {
      final columns = await db
          .customSelect('PRAGMA table_info(recurring_transactions)')
          .get();
      final names = columns.map((r) => r.data['name']).toList();
      expect(
        names,
        containsAll(['enable_notifications', 'notification_minutes_before']),
      );
    });
  });

  group('AI chat history', () {
    test('stores conversations and messages, newest activity first', () async {
      final chat = db.aiChatDao;
      final first = await chat.createConversation('Where did my money go?');
      final second = await chat.createConversation('Can I save more?');
      await chat.addMessage(conversationId: first, fromUser: true, body: 'Hi');
      await chat.addMessage(conversationId: first, fromUser: false, body: 'Hello!');

      final messages = await chat.getMessages(first);
      expect(messages.map((m) => m.body), ['Hi', 'Hello!']);
      expect(messages.first.fromUser, isTrue);
      expect(messages.last.isError, isFalse);

      final conversations = await chat.watchConversations().first;
      expect(conversations.first.id, first); // bumped by the new messages
      expect(conversations.map((c) => c.id), containsAll([first, second]));
    });

    test('deleting a conversation removes its messages', () async {
      final chat = db.aiChatDao;
      final id = await chat.createConversation('Temp');
      await chat.addMessage(conversationId: id, fromUser: true, body: 'x');
      await chat.deleteConversation(id);
      expect(await chat.getMessages(id), isEmpty);
    });

    test('long titles are shortened', () async {
      final chat = db.aiChatDao;
      final id = await chat.createConversation('a' * 200);
      final c = (await chat.watchConversations().first).firstWhere((c) => c.id == id);
      expect(c.title.length, lessThanOrEqualTo(120));
    });
  });

  group('Initial seed data', () {
    test('creates the demo user', () async {
      final users = await db.select(db.users).get();
      expect(users, hasLength(1));
      expect(users.single.uid, 'demo-user-001');
      expect(users.single.id, 1);
    });

    test('creates default accounts with exactly one default', () async {
      final accounts = await db.select(db.accounts).get();
      expect(
        accounts.map((a) => a.name),
        containsAll(['Cash', 'Bank Account', 'Credit Card']),
      );
      expect(await db.accountsDao.getDefaultAccount(1), isNotNull);
    });

    test('creates expense and income categories', () async {
      final expense = await db.categoriesDao
          .getCategoriesByType(1, CategoryType.expense);
      final income = await db.categoriesDao
          .getCategoriesByType(1, CategoryType.income);

      expect(
        expense.map((c) => c.name),
        containsAll(['Food & Dining', 'Home Loan', 'Other']),
      );
      expect(income.map((c) => c.name), contains('Salary'));
    });

    test('does not duplicate category names', () async {
      final categories = await db.select(db.categories).get();
      final keys = categories.map((c) => '${c.type.name}:${c.name}').toList();
      expect(keys.toSet().length, keys.length);
    });

    test('creates default recurring transactions', () async {
      final recurring = await db.select(db.recurringTransactions).get();
      expect(recurring, isNotEmpty);
    });

    test('creates the Savings expense category', () async {
      // Savings deposits look this category up by name and throw if it is
      // missing (savings_transactions_provider.dart).
      final expense = await db.categoriesDao
          .getCategoriesByType(1, CategoryType.expense);
      expect(expense.map((c) => c.name), contains('Savings'));
    });
  });
}
