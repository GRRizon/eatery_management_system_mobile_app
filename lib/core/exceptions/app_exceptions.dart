/// Core exception hierarchy for the Eatery Management System
/// This file provides structured exception handling with specific exception types
/// for different error scenarios, making error handling more predictable and maintainable.
///
/// Usage:
/// ```dart
/// try {
///   await authService.login('user', 'pass');
/// } on AuthException catch (e) {
///   print('Auth error: ${e.message}');
/// } on NetworkException catch (e) {
///   print('Network error: ${e.message}');
/// }
/// ```
library;

/// Base exception class for all app-level exceptions
/// All custom exceptions should inherit from this class
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  AppException({required this.message, this.code, this.originalException});

  @override
  String toString() =>
      'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Authentication-related exceptions
/// Thrown when authentication operations fail
class AuthException extends AppException {
  /// Creates an AuthException with a descriptive message
  ///
  /// Parameters:
  ///   - message: Human-readable error description
  ///   - code: Optional error code for error tracking
  ///   - originalException: Original exception if thrown from another layer
  AuthException({required super.message, String? code, super.originalException})
    : super(code: code ?? 'AUTH_ERROR');

  @override
  String toString() => 'AuthException: $message';
}

/// Validation-related exceptions
/// Thrown when input validation fails
class ValidationException extends AppException {
  /// Field name that failed validation
  final String? fieldName;

  ValidationException({
    required super.message,
    this.fieldName,
    String? code,
    super.originalException,
  }) : super(code: code ?? 'VALIDATION_ERROR');

  @override
  String toString() =>
      'ValidationException${fieldName != null ? ' ($fieldName)' : ''}: $message';
}

/// Network-related exceptions
/// Thrown when network operations fail
class NetworkException extends AppException {
  /// HTTP status code if available
  final int? statusCode;

  NetworkException({
    required super.message,
    this.statusCode,
    String? code,
    super.originalException,
  }) : super(code: code ?? 'NETWORK_ERROR');

  @override
  String toString() =>
      'NetworkException${statusCode != null ? ' ($statusCode)' : ''}: $message';
}

/// Storage-related exceptions
/// Thrown when local or secure storage operations fail
class StorageException extends AppException {
  StorageException({
    required super.message,
    String? code,
    super.originalException,
  }) : super(code: code ?? 'STORAGE_ERROR');

  @override
  String toString() => 'StorageException: $message';
}

/// Business logic exceptions
/// Thrown when business logic rules are violated
class BusinessException extends AppException {
  BusinessException({
    required super.message,
    String? code,
    super.originalException,
  }) : super(code: code ?? 'BUSINESS_ERROR');

  @override
  String toString() => 'BusinessException: $message';
}

/// Timeout-related exceptions
/// Thrown when operations exceed timeout limits
class TimeoutException extends AppException {
  /// Duration that was exceeded
  final Duration? duration;

  TimeoutException({
    required super.message,
    this.duration,
    String? code,
    super.originalException,
  }) : super(code: code ?? 'TIMEOUT_ERROR');

  @override
  String toString() =>
      'TimeoutException${duration != null ? ' (${duration!.inSeconds}s)' : ''}: $message';
}

/// Unknown/Unexpected exceptions
/// Thrown when an unexpected error occurs
class UnexpectedException extends AppException {
  UnexpectedException({
    required super.message,
    String? code,
    super.originalException,
  }) : super(code: code ?? 'UNEXPECTED_ERROR');

  @override
  String toString() => 'UnexpectedException: $message';
}
