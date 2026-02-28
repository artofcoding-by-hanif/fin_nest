import 'package:intl/intl.dart';

/// Utility class for formatting values
class Formatters {
  /// Format currency amount in cents to display string
  ///
  /// [amountInCents] - Amount in cents (e.g., 100000 for ₹1,000.00)
  /// [symbol] - Currency symbol (default: '₹' for INR)
  /// [locale] - Locale for formatting (default: 'en_IN' for Indian format)
  /// [decimalDigits] - Number of decimal digits (default: 2)
  static String currency(
    int amountInCents, {
    String symbol = '₹',
    String locale = 'en_IN',
    int decimalDigits = 2,
  }) {
    final amount = amountInCents / 100.0;
    final formatter = NumberFormat.currency(
      symbol: symbol,
      locale: locale,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Format currency from double amount
  static String currencyFromDouble(
    double amount, {
    String symbol = '₹',
    String locale = 'en_IN',
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      locale: locale,
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Format currency with compact notation (e.g., ₹1.2K, ₹1.5M)
  static String currencyCompact(
    int amountInCents, {
    String symbol = '₹',
    String locale = 'en_IN',
  }) {
    final amount = amountInCents / 100.0;
    final formatter = NumberFormat.compactCurrency(
      symbol: symbol,
      locale: locale,
      decimalDigits: 1,
    );
    return formatter.format(amount);
  }

  /// Date formatter
  static String date(DateTime date, {String pattern = 'dd/MM/yyyy'}) {
    final formatter = DateFormat(pattern);
    return formatter.format(date);
  }

  /// Percentage formatter
  static String percentage(double value, {int decimals = 2}) {
    return '${(value * 100).toStringAsFixed(decimals)}%';
  }

  /// Format number with Indian numbering system (lakhs, crores)
  static String indianNumber(double number) {
    final formatter = NumberFormat('#,##,###.##', 'en_IN');
    return formatter.format(number);
  }
}
