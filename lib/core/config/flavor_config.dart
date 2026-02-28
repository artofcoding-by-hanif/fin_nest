/// Flavor configuration for different environments
enum Flavor {
  development,
  staging,
  production;

  bool get isDevelopment => this == Flavor.development;
  bool get isStaging => this == Flavor.staging;
  bool get isProduction => this == Flavor.production;
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableAnalytics;
  final int apiTimeout;

  FlavorConfig._({
    required this.flavor,
    required this.name,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.apiTimeout,
  });

  static FlavorConfig? _instance;

  /// Get the current flavor configuration
  static FlavorConfig get instance {
    if (_instance == null) {
      throw Exception(
        'FlavorConfig has not been initialized. Call FlavorConfig.initialize() first.',
      );
    }
    return _instance!;
  }

  /// Check if flavor is initialized
  static bool get isInitialized => _instance != null;

  /// Initialize flavor configuration
  static void initialize(Flavor flavor) {
    _instance = _createConfig(flavor);
  }

  /// Create configuration based on flavor
  static FlavorConfig _createConfig(Flavor flavor) {
    switch (flavor) {
      case Flavor.development:
        return FlavorConfig._(
          flavor: Flavor.development,
          name: 'Development',
          apiBaseUrl: 'https://dev-api.finnest.com',
          enableLogging: true,
          enableAnalytics: false,
          apiTimeout: 30000,
        );
      case Flavor.staging:
        return FlavorConfig._(
          flavor: Flavor.staging,
          name: 'Staging',
          apiBaseUrl: 'https://staging-api.finnest.com',
          enableLogging: true,
          enableAnalytics: true,
          apiTimeout: 30000,
        );
      case Flavor.production:
        return FlavorConfig._(
          flavor: Flavor.production,
          name: 'Production',
          apiBaseUrl: 'https://api.finnest.com',
          enableLogging: false,
          enableAnalytics: true,
          apiTimeout: 30000,
        );
    }
  }

  @override
  String toString() {
    return 'FlavorConfig(flavor: $flavor, name: $name, apiBaseUrl: $apiBaseUrl)';
  }
}
