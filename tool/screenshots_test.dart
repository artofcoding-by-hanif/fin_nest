// Renders key screens to PNGs (dark + light) with real fonts and sample
// data, for reviewing the design without a device.
//
// Run: flutter test tool/screenshots_test.dart
// Output: build/screenshots/*.png
import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:fin_nest/core/config/flavor_config.dart';
import 'package:fin_nest/core/database/app_database.dart';
import 'package:fin_nest/core/database/tables/savings_table.dart';
import 'package:fin_nest/core/database/tables/transactions_table.dart';
import 'package:fin_nest/core/services/settings_service.dart';
import 'package:fin_nest/core/theme/app_theme.dart';
import 'package:fin_nest/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:fin_nest/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:fin_nest/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:fin_nest/features/savings/presentation/screens/savings_list_screen.dart';
import 'package:fin_nest/features/transactions/presentation/screens/add_expense_screen.dart';
import 'package:fin_nest/features/transactions/presentation/screens/transaction_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _flutterRoot = '/Users/hanifmohammed/Projects/development/flutter';

Future<void> _loadFonts() async {
  Future<void> load(String family, List<String> paths) async {
    final loader = FontLoader(family);
    for (final p in paths) {
      final bytes = File(p).readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }

  await load('Sora', [
    for (final w in ['Light', 'Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold'])
      'assets/fonts/Sora-$w.ttf',
  ]);
  await load('Inter', [
    for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold'])
      'assets/fonts/Inter-$w.ttf',
  ]);
  await load('MaterialIcons', [
    '$_flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  ]);
}

Future<void> _seed(AppDatabase db) async {
  final now = DateTime.now();
  final cats = await db.select(db.categories).get();
  int cat(String name) => cats.firstWhere((c) => c.name == name).id;

  Future<void> tx(TransactionType type, int rupees, String desc, String c,
      DateTime date) {
    return db.transactionsDao.createTransaction(
      TransactionsCompanion.insert(
        userId: 1,
        accountId: 2,
        type: type,
        amountInCents: rupees * 100,
        description: desc,
        transactionDate: date,
        categoryId: Value(cat(c)),
      ),
    );
  }

  for (var m = 0; m < 6; m++) {
    final d = DateTime(now.year, now.month - m, 3);
    await tx(TransactionType.income, 92000 + m * 1500, 'Salary', 'Salary', d);
    if (m.isEven) {
      await tx(TransactionType.income, 14000, 'Freelance', 'Business', d);
    }
    await tx(TransactionType.expense, 26000, 'Rent', 'Home Loan', d);
    await tx(TransactionType.expense, 7800 + m * 600, 'Groceries',
        'Food & Dining', d.add(const Duration(days: 4)));
    await tx(TransactionType.expense, 3200 + m * 300, 'Fuel', 'Transportation',
        d.add(const Duration(days: 6)));
    await tx(TransactionType.expense, 5400 - m * 200, 'Shopping', 'Shopping',
        d.add(const Duration(days: 9)));
    await tx(TransactionType.expense, 2100, 'Movies', 'Entertainment',
        d.add(const Duration(days: 11)));
    await tx(TransactionType.expense, 3900, 'Electricity', 'Bills & Utilities',
        d.add(const Duration(days: 2)));
  }

  Future<void> saving(SavingsCategory c, String name, int value, int invested) {
    return db.into(db.savings).insert(
          SavingsCompanion.insert(
            userId: 1,
            category: c,
            name: name,
            currentValueInCents: value * 100,
            investedAmountInCents: invested * 100,
          ),
        );
  }

  await saving(SavingsCategory.mutualFund, 'Nifty 50 Index Fund', 248000, 210000);
  await saving(SavingsCategory.ppf, 'PPF Account', 182000, 175000);
  await saving(SavingsCategory.gold, 'Sovereign Gold Bond', 96000, 82000);
  await saving(SavingsCategory.stocks, 'Tech Portfolio', 61000, 68000);
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;

  setUpAll(() async {
    await _loadFonts();
    FlavorConfig.initialize(Flavor.production);
    SharedPreferences.setMockInitialValues({});
    await SettingsService.instance.initialize();
    Directory('build/screenshots').createSync(recursive: true);
  });

  Future<void> shot(
    WidgetTester tester,
    String name,
    Widget screen, {
    required ThemeMode mode,
    double height = 844,
    bool needsDb = false,
  }) async {
    tester.view.physicalSize = Size(390 * 3, height * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    if (needsDb) {
      await tester.runAsync(() async {
        db = AppDatabase.test(NativeDatabase.memory());
        await db.select(db.users).get(); // run onCreate + seed
        await _seed(db);
      });
      GetIt.instance.allowReassignment = true;
      GetIt.instance.registerSingleton<AppDatabase>(db);
    }

    final key = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(
        key: key,
        child: ProviderScope(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            home: screen,
          ),
        ),
      ),
    );

    // Let streams/futures resolve and entrance animations finish.
    for (var i = 0; i < 12; i++) {
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 30)));
      await tester.pump(const Duration(milliseconds: 200));
    }

    await tester.runAsync(() async {
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      File('build/screenshots/$name.png')
          .writeAsBytesSync(bytes!.buffer.asUint8List());
    });

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    if (needsDb) {
      await tester.runAsync(
        () => db.close().timeout(const Duration(seconds: 2), onTimeout: () {}),
      );
    }
  }

  for (final mode in [ThemeMode.dark, ThemeMode.light]) {
    final m = mode.name;
    testWidgets('dashboard $m', (t) => shot(t, 'dashboard_$m',
        const DashboardScreen(), mode: mode, height: 2050, needsDb: true));
    testWidgets('onboarding $m', (t) => shot(t, 'onboarding_$m',
        OnboardingScreen(onComplete: () {}), mode: mode));
    testWidgets('transactions $m', (t) => shot(t, 'transactions_$m',
        const TransactionListScreen(), mode: mode, needsDb: true));
    testWidgets('savings $m', (t) => shot(t, 'savings_$m',
        const SavingsListScreen(), mode: mode, height: 1300, needsDb: true));
    testWidgets('add_expense $m', (t) => shot(t, 'add_expense_$m',
        const AddExpenseScreen(), mode: mode, needsDb: true));
  }
  testWidgets('splash dark', (t) =>
      shot(t, 'splash_dark', const SplashScreen(), mode: ThemeMode.dark));
}
