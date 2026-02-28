/// Currency configuration model
class CurrencyConfig {
  final String code;
  final String name;
  final String symbol;
  final String locale;
  final int decimalDigits;
  final String? flag;

  const CurrencyConfig({
    required this.code,
    required this.name,
    required this.symbol,
    required this.locale,
    this.decimalDigits = 2,
    this.flag,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyConfig &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}

/// Supported currencies
class SupportedCurrencies {
  static const inr = CurrencyConfig(
    code: 'INR',
    name: 'Indian Rupee',
    symbol: '₹',
    locale: 'en_IN',
    flag: '🇮🇳',
  );

  static const usd = CurrencyConfig(
    code: 'USD',
    name: 'US Dollar',
    symbol: '\$',
    locale: 'en_US',
    flag: '🇺🇸',
  );

  static const eur = CurrencyConfig(
    code: 'EUR',
    name: 'Euro',
    symbol: '€',
    locale: 'en_EU',
    flag: '🇪🇺',
  );

  static const gbp = CurrencyConfig(
    code: 'GBP',
    name: 'British Pound',
    symbol: '£',
    locale: 'en_GB',
    flag: '🇬🇧',
  );

  static const jpy = CurrencyConfig(
    code: 'JPY',
    name: 'Japanese Yen',
    symbol: '¥',
    locale: 'ja_JP',
    decimalDigits: 0,
    flag: '🇯🇵',
  );

  static const cny = CurrencyConfig(
    code: 'CNY',
    name: 'Chinese Yuan',
    symbol: '¥',
    locale: 'zh_CN',
    flag: '🇨🇳',
  );

  static const aud = CurrencyConfig(
    code: 'AUD',
    name: 'Australian Dollar',
    symbol: 'A\$',
    locale: 'en_AU',
    flag: '🇦🇺',
  );

  static const cad = CurrencyConfig(
    code: 'CAD',
    name: 'Canadian Dollar',
    symbol: 'C\$',
    locale: 'en_CA',
    flag: '🇨🇦',
  );

  static const chf = CurrencyConfig(
    code: 'CHF',
    name: 'Swiss Franc',
    symbol: 'CHF',
    locale: 'de_CH',
    flag: '🇨🇭',
  );

  static const sgd = CurrencyConfig(
    code: 'SGD',
    name: 'Singapore Dollar',
    symbol: 'S\$',
    locale: 'en_SG',
    flag: '🇸🇬',
  );

  static const aed = CurrencyConfig(
    code: 'AED',
    name: 'UAE Dirham',
    symbol: 'د.إ',
    locale: 'ar_AE',
    flag: '🇦🇪',
  );

  static const sar = CurrencyConfig(
    code: 'SAR',
    name: 'Saudi Riyal',
    symbol: '﷼',
    locale: 'ar_SA',
    flag: '🇸🇦',
  );

  /// List of all supported currencies
  static const List<CurrencyConfig> all = [
    inr,
    usd,
    eur,
    gbp,
    jpy,
    cny,
    aud,
    cad,
    chf,
    sgd,
    aed,
    sar,
  ];

  /// Get currency by code
  static CurrencyConfig? getByCode(String code) {
    try {
      return all.firstWhere((c) => c.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Get currency by code or return default (INR)
  static CurrencyConfig getByCodeOrDefault(String code) {
    return getByCode(code) ?? inr;
  }
}

