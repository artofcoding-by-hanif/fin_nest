import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/currency_config.dart';
import '../providers/settings_provider.dart';
import '../settings/app_settings.dart';

/// Widget that displays currency amount using app settings
class CurrencyText extends ConsumerWidget {
  final int amountInCents;
  final TextStyle? style;
  final bool compact;
  final String? prefix;
  final Color? color;

  const CurrencyText({
    super.key,
    required this.amountInCents,
    this.style,
    this.compact = false,
    this.prefix,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currentCurrencyProvider);
    final currencyFormat = ref.watch(currencyFormatProvider);
    final amount = amountInCents / 100.0;

    final formattedAmount = _formatAmount(
      amount,
      currency,
      currencyFormat,
      compact,
    );

    final displayText = prefix != null
        ? '$prefix$formattedAmount'
        : formattedAmount;

    return Text(
      displayText,
      style: style?.copyWith(color: color) ?? TextStyle(color: color),
    );
  }
}

/// Helper function to format amount with currency settings
String _formatAmount(
  double amount,
  CurrencyConfig currency,
  CurrencyFormat format,
  bool compact,
) {
  String baseFormatted;

  if (compact) {
    final formatter = NumberFormat.compactCurrency(
      symbol: '',
      locale: currency.locale,
      decimalDigits: 1,
    );
    baseFormatted = formatter.format(amount).trim();
  } else {
    final formatter = NumberFormat.currency(
      symbol: '',
      locale: currency.locale,
      decimalDigits: currency.decimalDigits,
    );
    baseFormatted = formatter.format(amount).trim();
  }

  // Apply currency format preference
  switch (format) {
    case CurrencyFormat.symbol:
      return '${currency.symbol}$baseFormatted';
    case CurrencyFormat.code:
      return '${currency.code} $baseFormatted';
    case CurrencyFormat.symbolCode:
      return '${currency.symbol}$baseFormatted ${currency.code}';
  }
}

/// Helper function to format currency amount using settings
String formatCurrency(
  WidgetRef ref,
  int amountInCents, {
  bool compact = false,
}) {
  final currency = ref.read(currentCurrencyProvider);
  final currencyFormat = ref.read(currencyFormatProvider);
  final amount = amountInCents / 100.0;

  return _formatAmount(amount, currency, currencyFormat, compact);
}

/// Helper function to format currency from double amount
String formatCurrencyFromDouble(
  WidgetRef ref,
  double amount, {
  bool compact = false,
}) {
  final currency = ref.read(currentCurrencyProvider);
  final currencyFormat = ref.read(currencyFormatProvider);

  return _formatAmount(amount, currency, currencyFormat, compact);
}
