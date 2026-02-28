import 'package:equatable/equatable.dart';

/// Money value object
class Money extends Equatable {
  final double amount;
  final String currency;

  const Money({
    required this.amount,
    this.currency = 'USD',
  });

  Money operator +(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot add money with different currencies');
    }
    return Money(amount: amount + other.amount, currency: currency);
  }

  Money operator -(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot subtract money with different currencies');
    }
    return Money(amount: amount - other.amount, currency: currency);
  }

  @override
  List<Object?> get props => [amount, currency];

  @override
  String toString() => '$currency $amount';
}

