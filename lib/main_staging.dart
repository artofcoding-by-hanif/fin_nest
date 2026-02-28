import 'bootstrap.dart';
import 'core/config/flavor_config.dart';

/// Main entry point for STAGING flavor
void main() async {
  await bootstrap(Flavor.staging);
}

