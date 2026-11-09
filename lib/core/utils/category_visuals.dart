import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Maps stored icon names / hex colors (categories, accounts, savings)
/// to rounded Material icons and colors. One place instead of a copy in
/// every screen.
class CategoryVisuals {
  CategoryVisuals._();

  static const Map<String, IconData> _icons = {
    'restaurant': Icons.restaurant_rounded,
    'fastfood': Icons.fastfood_rounded,
    'directions_car': Icons.directions_car_rounded,
    'local_gas_station': Icons.local_gas_station_rounded,
    'shopping_bag': Icons.shopping_bag_rounded,
    'shopping_cart': Icons.shopping_cart_rounded,
    'movie': Icons.movie_rounded,
    'sports_esports': Icons.sports_esports_rounded,
    'receipt': Icons.receipt_long_rounded,
    'local_hospital': Icons.local_hospital_rounded,
    'medical_services': Icons.medical_services_rounded,
    'school': Icons.school_rounded,
    'spa': Icons.spa_rounded,
    'home': Icons.home_rounded,
    'account_balance': Icons.account_balance_rounded,
    'credit_card': Icons.credit_card_rounded,
    'payments': Icons.payments_rounded,
    'savings': Icons.savings_rounded,
    'work': Icons.work_rounded,
    'business': Icons.business_center_rounded,
    'trending_up': Icons.trending_up_rounded,
    'money': Icons.attach_money_rounded,
    'phone_android': Icons.phone_android_rounded,
    'flight': Icons.flight_rounded,
    'category': Icons.category_rounded,
    'help_outline': Icons.help_outline_rounded,
    'wallet': Icons.account_balance_wallet_rounded,
    'cash': Icons.payments_rounded,
  };

  /// Icon for a stored icon name, or a generic category icon.
  static IconData icon(String? name, {IconData fallback = Icons.category_rounded}) =>
      _icons[name] ?? fallback;

  /// Parses '#RRGGBB' / '#AARRGGBB'; returns [fallback] if invalid.
  static Color color(String? hex, {Color fallback = AppColors.violet}) {
    if (hex == null || hex.isEmpty) return fallback;
    var h = hex.replaceFirst('#', '');
    if (h.length == 6) h = 'FF$h';
    final v = int.tryParse(h, radix: 16);
    return v == null ? fallback : Color(v);
  }

  /// Category pastel colors are very light; deepen them so glass icons
  /// and chart slices stay vivid on both themes.
  static Color vivid(String? hex, {Color fallback = AppColors.violet}) {
    final c = color(hex, fallback: fallback);
    final hsl = HSLColor.fromColor(c);
    return hsl
        .withSaturation((hsl.saturation * 1.1).clamp(0.55, 0.95))
        .withLightness(hsl.lightness.clamp(0.45, 0.62))
        .toColor();
  }
}
