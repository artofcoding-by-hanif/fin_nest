import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options_development.dart' as dev_options;
import '../../firebase_options_production.dart' as prod_options;
import '../../firebase_options_staging.dart' as staging_options;
import '../config/flavor_config.dart';

/// Starts Firebase if this build has been configured for it.
///
/// Firebase only powers online extras (the AI assistant and the server-side
/// subscription check). A missing or broken configuration is logged and the
/// app carries on fully offline.
class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool _ready = false;

  /// Whether Firebase initialized and online features can be used
  static bool get isReady => _ready;

  /// Optional fixed App Check debug token for debug builds, registered in the
  /// Firebase console. Pass with --dart-define=APP_CHECK_DEBUG_TOKEN=...
  /// Without it, the SDK logs a generated token on first launch.
  static const String _debugToken = String.fromEnvironment(
    'APP_CHECK_DEBUG_TOKEN',
  );

  static FirebaseOptions _optionsFor(Flavor flavor) {
    switch (flavor) {
      case Flavor.development:
        return dev_options.DefaultFirebaseOptions.currentPlatform;
      case Flavor.staging:
        return staging_options.DefaultFirebaseOptions.currentPlatform;
      case Flavor.production:
        return prod_options.DefaultFirebaseOptions.currentPlatform;
    }
  }

  static Future<void> initialize(Flavor flavor) async {
    try {
      await Firebase.initializeApp(options: _optionsFor(flavor));
      await FirebaseAppCheck.instance.activate(
        providerAndroid: kDebugMode
            ? AndroidDebugProvider(
                debugToken: _debugToken.isEmpty ? null : _debugToken,
              )
            : const AndroidPlayIntegrityProvider(),
      );
      _ready = true;
      debugPrint('Firebase ready (${flavor.name})');
      if (kDebugMode) _logDiagnostics();
    } catch (error) {
      debugPrint('Firebase unavailable, online features disabled: $error');
    }
  }

  /// Debug builds: check that App Check and anonymous sign-in work, so a
  /// missing debug-token registration or disabled auth provider is obvious.
  static Future<void> _logDiagnostics() async {
    try {
      final token = await FirebaseAppCheck.instance.getToken(true);
      debugPrint('App Check OK (token ${token?.length ?? 0} chars)');
    } catch (error) {
      debugPrint(
        'App Check token exchange FAILED: $error\n'
        'Register the debug token printed above in Firebase console > '
        'App Check > Apps > Manage debug tokens.',
      );
    }
    try {
      final uid = await FirebaseIdentity.ensureSignedIn();
      debugPrint('Anonymous sign-in OK (uid $uid)');
    } catch (error) {
      debugPrint(
        'Anonymous sign-in FAILED: $error\n'
        'Enable Firebase console > Authentication > Sign-in method > Anonymous.',
      );
    }
  }
}

/// The user's cloud identity: a Firebase anonymous account, created on first
/// use. Its uid is what RevenueCat and the AI Cloud Functions know the user
/// by. It is separate from the local Drift user id.
class FirebaseIdentity {
  FirebaseIdentity._();

  /// Current uid, or null if Firebase is off or nobody has signed in yet
  static String? get uid =>
      FirebaseBootstrap.isReady ? FirebaseAuth.instance.currentUser?.uid : null;

  /// Signs in anonymously if needed and returns the uid.
  ///
  /// Throws [StateError] when Firebase isn't configured in this build.
  static Future<String> ensureSignedIn() async {
    if (!FirebaseBootstrap.isReady) {
      throw StateError('Firebase is not configured in this build.');
    }
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser ?? (await auth.signInAnonymously()).user;
    final id = user?.uid;
    if (id == null) throw StateError('Anonymous sign-in returned no user.');
    return id;
  }
}
