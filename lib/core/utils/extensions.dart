import 'package:flutter/material.dart';

/// String extensions
extension StringExtensions on String {
  // TODO: Add string utility extensions
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// DateTime extensions
extension DateTimeExtensions on DateTime {
  // TODO: Add datetime utility extensions
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}

/// BuildContext extensions
extension BuildContextExtensions on BuildContext {
  // TODO: Add context utility extensions
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

