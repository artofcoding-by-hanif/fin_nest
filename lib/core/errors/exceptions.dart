/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});
}

/// Server exception
class ServerException extends AppException {
  ServerException(super.message, {super.code});
}

/// Cache exception
class CacheException extends AppException {
  CacheException(super.message, {super.code});
}

/// Network exception
class NetworkException extends AppException {
  NetworkException(super.message, {super.code});
}

/// Authentication exception
class AuthException extends AppException {
  AuthException(super.message, {super.code});
}

