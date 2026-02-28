/// Transaction type enumeration
enum TransactionType {
  income,
  expense,
  transfer,
  investment,
}

extension TransactionTypeExtension on TransactionType {
  String get displayName {
    switch (this) {
      case TransactionType.income:
        return 'Income';
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.transfer:
        return 'Transfer';
      case TransactionType.investment:
        return 'Investment';
    }
  }
}

