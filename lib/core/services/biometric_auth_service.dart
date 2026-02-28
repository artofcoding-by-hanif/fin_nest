import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

/// Biometric authentication service
/// Handles fingerprint, face ID, and other biometric authentication methods
class BiometricAuthService {
  static BiometricAuthService? _instance;
  static BiometricAuthService get instance {
    _instance ??= BiometricAuthService._();
    return _instance!;
  }

  BiometricAuthService._();

  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isInitialized = false;

  /// Initialize the biometric auth service
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('BiometricAuthService already initialized');
      return;
    }

    try {
      _isInitialized = true;
      debugPrint('BiometricAuthService initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize BiometricAuthService: $e');
      rethrow;
    }
  }

  /// Check if biometric authentication is available on this device
  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      debugPrint('Error checking biometrics availability: $e');
      return false;
    }
  }

  /// Check if device is capable of biometric authentication
  Future<bool> isDeviceSupported() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      debugPrint('Error checking device support: $e');
      return false;
    }
  }

  /// Get list of available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Authenticate user with biometrics
  /// Returns true if authentication was successful
  Future<BiometricAuthResult> authenticate({
    String localizedReason = 'Please authenticate to access FinNest',
    bool useErrorDialogs = true,
    bool stickyAuth = true,
    bool biometricOnly = false,
  }) async {
    try {
      // Check if biometrics are available
      final canCheck = await canCheckBiometrics();
      final isSupported = await isDeviceSupported();

      if (!canCheck || !isSupported) {
        return BiometricAuthResult(
          success: false,
          errorMessage:
              'Biometric authentication is not available on this device',
          errorCode: BiometricAuthErrorCode.notAvailable,
        );
      }

      // Attempt authentication
      final authenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: biometricOnly,
        ),
      );

      if (authenticated) {
        return BiometricAuthResult(success: true);
      } else {
        return BiometricAuthResult(
          success: false,
          errorMessage: 'Authentication failed',
          errorCode: BiometricAuthErrorCode.authenticationFailed,
        );
      }
    } on PlatformException catch (e) {
      debugPrint('Biometric authentication error: ${e.code} - ${e.message}');

      // Handle specific error codes
      BiometricAuthErrorCode errorCode;
      String errorMessage;

      switch (e.code) {
        case auth_error.notAvailable:
          errorCode = BiometricAuthErrorCode.notAvailable;
          errorMessage = 'Biometric authentication is not available';
          break;
        case auth_error.notEnrolled:
          errorCode = BiometricAuthErrorCode.notEnrolled;
          errorMessage =
              'No biometrics enrolled. Please set up biometrics in device settings';
          break;
        case auth_error.lockedOut:
          errorCode = BiometricAuthErrorCode.lockedOut;
          errorMessage = 'Too many failed attempts. Please try again later';
          break;
        case auth_error.permanentlyLockedOut:
          errorCode = BiometricAuthErrorCode.permanentlyLockedOut;
          errorMessage =
              'Biometric authentication is permanently locked. Please use device credentials';
          break;
        default:
          errorCode = BiometricAuthErrorCode.unknown;
          errorMessage = e.message ?? 'An unknown error occurred';
      }

      return BiometricAuthResult(
        success: false,
        errorMessage: errorMessage,
        errorCode: errorCode,
      );
    } catch (e) {
      debugPrint('Unexpected biometric authentication error: $e');
      return BiometricAuthResult(
        success: false,
        errorMessage: 'An unexpected error occurred',
        errorCode: BiometricAuthErrorCode.unknown,
      );
    }
  }

  /// Stop authentication (if in progress)
  Future<void> stopAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
    } catch (e) {
      debugPrint('Error stopping authentication: $e');
    }
  }
}

/// Result of biometric authentication attempt
class BiometricAuthResult {
  final bool success;
  final String? errorMessage;
  final BiometricAuthErrorCode? errorCode;

  BiometricAuthResult({
    required this.success,
    this.errorMessage,
    this.errorCode,
  });
}

/// Error codes for biometric authentication
enum BiometricAuthErrorCode {
  notAvailable,
  notEnrolled,
  lockedOut,
  permanentlyLockedOut,
  authenticationFailed,
  unknown,
}
