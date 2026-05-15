import 'package:flutter/foundation.dart';
import '../exceptions/app_exceptions.dart';
import '../../utils/logger.dart';

/// Abstract base class for all ChangeNotifier providers
///
/// This class provides common functionality for all state management providers:
/// - Consistent error handling
/// - Loading state management
/// - Error message management
/// - Logging utilities
///
/// All providers should extend this class instead of directly extending ChangeNotifier.
///
/// Example:
/// ```dart
/// class UserProvider extends BaseProvider {
///   User? _user;
///
///   User? get user => _user;
///
///   Future<void> fetchUser(String id) async {
///     try {
///       setLoading(true);
///       _user = await _userService.getUser(id);
///       clearError();
///     } on AppException catch (e) {
///       handleError(e);
///     } finally {
///       setLoading(false);
///     }
///   }
/// }
/// ```
abstract class BaseProvider extends ChangeNotifier {
  /// Current loading state
  bool _isLoading = false;

  /// Current error message (null if no error)
  String? _errorMessage;

  /// Flag to track if provider is disposed
  bool _isDisposed = false;

  /// Getter for loading state
  /// Use this to show loading indicators in UI
  bool get isLoading => _isLoading;

  /// Getter for error message
  /// Use this to show error messages in UI
  String? get errorMessage => _errorMessage;

  /// Check if there is an active error
  bool get hasError => _errorMessage != null && _errorMessage!.isNotEmpty;

  /// Provider name for logging and debugging
  /// Override this in subclasses to provide a meaningful name
  String get providerName => runtimeType.toString();

  /// Set loading state
  ///
  /// Usage: setLoading(true) when operation starts
  ///        setLoading(false) when operation completes
  void setLoading(bool loading) {
    if (_isDisposed) return;
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  ///
  /// This automatically calls notifyListeners() to update UI
  ///
  /// Usage: setError('An error occurred')
  void setError(String? message) {
    if (_isDisposed) return;
    _errorMessage = message;
    notifyListeners();
  }

  /// Clear error message
  ///
  /// Usage: clearError() after successful operation
  void clearError() {
    setError(null);
  }

  /// Handle AppException with automatic error message update
  ///
  /// This method:
  /// - Logs the error
  /// - Sets error message from exception
  /// - Calls notifyListeners()
  ///
  /// Usage:
  /// ```dart
  /// try {
  ///   // operation
  /// } on AppException catch (e) {
  ///   handleException(e);
  /// }
  /// ```
  void handleException(AppException exception) {
    logError('Exception occurred', exception);
    setError(exception.message);
  }

  /// Reset provider state to initial values
  ///
  /// Override this in subclasses to reset custom state
  /// Always call super.resetState() at the end
  ///
  /// Usage:
  /// ```dart
  /// @override
  /// Future<void> resetState() async {
  ///   _user = null;
  ///   super.resetState();
  /// }
  /// ```
  void resetState() {
    if (_isDisposed) return;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Log info message with provider prefix
  ///
  /// Usage: logInfo('Data loaded successfully')
  @protected
  void logInfo(String message) {
    AppLogger.info('[$providerName] $message');
  }

  /// Log warning message with provider prefix
  ///
  /// Usage: logWarning('Data may be stale')
  @protected
  void logWarning(String message) {
    AppLogger.warning('[$providerName] $message');
  }

  /// Log error message with provider prefix
  ///
  /// Usage: logError('Failed to load data', exception)
  @protected
  void logError(String message, [dynamic error]) {
    AppLogger.error(
      '[$providerName] $message${error != null ? ': $error' : ''}',
    );
  }

  /// Check if provider is properly disposed
  ///
  /// Use this to prevent using disposed provider
  void verifyNotDisposed() {
    if (_isDisposed) {
      throw AppException(
        message: '$providerName has been disposed',
        code: 'PROVIDER_DISPOSED',
      );
    }
  }

  /// Override dispose to track disposal state
  ///
  /// Always call super.dispose() when overriding
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  /// Safe notifyListeners that checks disposed state
  ///
  /// Use this instead of notifyListeners() directly
  /// to prevent errors when notifying after disposal
  @protected
  void safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }
}
