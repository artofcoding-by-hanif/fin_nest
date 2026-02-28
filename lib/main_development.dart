import 'bootstrap.dart';
import 'core/config/flavor_config.dart';

/// Main entry point for DEVELOPMENT flavor
void main() async {
  await bootstrap(Flavor.development);
}

