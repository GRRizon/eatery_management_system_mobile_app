import 'package:flutter/foundation.dart';
import '../exceptions/app_exceptions.dart';
import '../../utils/logger.dart';

/// Abstract base class for all application services
///
/// This class provides common functionality for all services:
/// - Consistent initialization and disposal
/// - Error handling with logging
/// - Lifecycle management
///
/// All services should extend this class and implement their specific logic.
///
/// Example:
/// ```dart
/// class UserService extends BaseService {
///   @override
///   Future<void> initialize() async {
///     await super.initialize();
///     // Initialize user service resources
///   }
///
///   @override
///   Future<void> dispose() async {
///     await super.dispose();
///     // Clean up resources
///   }
/// }
/// ```
abstract class BaseService {
  /// Indicates if the service is initialized and ready to use
  bool _isInitialized = false;

  /// Indicates if the service is disposed
  bool _isDisposed = false;

  /// Getter for initialization status
  /// Use this to check if service is ready before using it
  bool get isInitialized => _isInitialized;

  /// Getter for disposal status
  bool get isDisposed => _isDisposed;

  /// Service name for logging and debugging
  /// Override this in subclasses to provide a meaningful name
  String get serviceName => runtimeType.toString();

  /// Initialize the service
  ///
  /// This method should be called once when the app starts.
  /// Subclasses should override this to perform initialization logic.
  ///
  /// Throws [AppException] if initialization fails
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing service: $serviceName');
      _isInitialized = true;
    } catch (e) {
      AppLogger.error('Error initializing $serviceName: $e');
      rethrow;
    }
  }

  /// Dispose the service and clean up resources
  ///
  /// This method should be called when the app is shutting down.
  /// Subclasses should override this to perform cleanup logic.
  ///
  /// Throws [AppException] if disposal fails
  Future<void> dispose() async {
    try {
      AppLogger.info('Disposing service: $serviceName');
      _isDisposed = true;
      _isInitialized = false;
    } catch (e) {
      AppLogger.error('Error disposing $serviceName: $e');
      rethrow;
    }
  }

  /// Verify that service is initialized before using it
  ///
  /// Call this at the beginning of methods that require initialization
  ///
  /// Throws [AppException] if service is not initialized
  void verifyInitialized() {
    if (!_isInitialized) {
      throw AppException(
        message: '$serviceName is not initialized. Call initialize() first.',
        code: 'SERVICE_NOT_INITIALIZED',
      );
    }
    if (_isDisposed) {
      throw AppException(
        message: '$serviceName has been disposed.',
        code: 'SERVICE_DISPOSED',
      );
    }
  }

  /// Log info message with service prefix
  ///
  /// Usage: logInfo('User logged in successfully')
  @protected
  void logInfo(String message) {
    AppLogger.info('[$serviceName] $message');
  }

  /// Log warning message with service prefix
  ///
  /// Usage: logWarning('Token expiring soon')
  @protected
  void logWarning(String message) {
    AppLogger.warning('[$serviceName] $message');
  }

  /// Log error message with service prefix
  ///
  /// Usage: logError('Failed to fetch data', exception)
  @protected
  void logError(String message, [dynamic error]) {
    AppLogger.error(
      '[$serviceName] $message${error != null ? ': $error' : ''}',
    );
  }

  /// Handle exceptions with consistent error logging and rethrow
  ///
  /// This method normalizes exceptions to AppException types
  ///
  /// Usage:
  /// ```dart
  /// try {
  ///   // Some operation
  /// } catch (e) {
  ///   handleException('Operation failed', e);
  /// }
  /// ```
  @protected
  Never handleException(String context, dynamic error) {
    final appException = error is AppException
        ? error
        : UnexpectedException(message: context, originalException: error);

    logError(context, appException);
    throw appException;
  }
}
