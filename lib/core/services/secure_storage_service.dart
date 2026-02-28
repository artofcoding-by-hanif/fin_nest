import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for sensitive data
/// Uses platform-specific secure storage (Keychain on iOS, KeyStore on Android)
class SecureStorageService {
  static SecureStorageService? _instance;
  static SecureStorageService get instance {
    _instance ??= SecureStorageService._();
    return _instance!;
  }

  SecureStorageService._();

  late final FlutterSecureStorage _storage;
  bool _isInitialized = false;

  /// Initialize the secure storage service
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('SecureStorageService already initialized');
      return;
    }

    try {
      // Configure secure storage with platform-specific options
      const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
      const iosOptions = IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      );
      const linuxOptions = LinuxOptions();
      const webOptions = WebOptions();
      const macOsOptions = MacOsOptions();
      const windowsOptions = WindowsOptions();

      _storage = const FlutterSecureStorage(
        aOptions: androidOptions,
        iOptions: iosOptions,
        lOptions: linuxOptions,
        wOptions: windowsOptions,
        mOptions: macOsOptions,
        webOptions: webOptions,
      );

      _isInitialized = true;
      debugPrint('SecureStorageService initialized successfully');
    } catch (e) {
      debugPrint('Failed to initialize SecureStorageService: $e');
      rethrow;
    }
  }

  /// Write a value to secure storage
  Future<void> write({required String key, required String value}) async {
    if (!_isInitialized) {
      debugPrint('SecureStorageService not initialized');
      return;
    }

    try {
      await _storage.write(key: key, value: value);
      debugPrint('Secure storage write successful for key: $key');
    } catch (e) {
      debugPrint('Failed to write to secure storage: $e');
      rethrow;
    }
  }

  /// Read a value from secure storage
  Future<String?> read({required String key}) async {
    if (!_isInitialized) {
      debugPrint('SecureStorageService not initialized');
      return null;
    }

    try {
      final value = await _storage.read(key: key);
      debugPrint(
        'Secure storage read for key: $key - ${value != null ? 'found' : 'not found'}',
      );
      return value;
    } catch (e) {
      debugPrint('Failed to read from secure storage: $e');
      return null;
    }
  }

  /// Delete a value from secure storage
  Future<void> delete({required String key}) async {
    if (!_isInitialized) {
      debugPrint('SecureStorageService not initialized');
      return;
    }

    try {
      await _storage.delete(key: key);
      debugPrint('Secure storage delete successful for key: $key');
    } catch (e) {
      debugPrint('Failed to delete from secure storage: $e');
      rethrow;
    }
  }

  /// Clear all secure storage
  Future<void> deleteAll() async {
    if (!_isInitialized) {
      debugPrint('SecureStorageService not initialized');
      return;
    }

    try {
      await _storage.deleteAll();
      debugPrint('Secure storage cleared successfully');
    } catch (e) {
      debugPrint('Failed to clear secure storage: $e');
      rethrow;
    }
  }

  /// Check if a key exists in secure storage
  Future<bool> containsKey({required String key}) async {
    if (!_isInitialized) {
      debugPrint('SecureStorageService not initialized');
      return false;
    }

    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      debugPrint('Failed to check key in secure storage: $e');
      return false;
    }
  }

  /// Get all keys from secure storage
  Future<Map<String, String>> readAll() async {
    if (!_isInitialized) {
      debugPrint('SecureStorageService not initialized');
      return {};
    }

    try {
      final all = await _storage.readAll();
      debugPrint('Secure storage read all: ${all.length} items');
      return all;
    } catch (e) {
      debugPrint('Failed to read all from secure storage: $e');
      return {};
    }
  }
}
