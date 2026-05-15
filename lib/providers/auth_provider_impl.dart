import '../core/base/base_provider.dart';
import '../core/exceptions/app_exceptions.dart';
import '../core/interfaces/services.dart';
import '../models/user_model.dart';

/// Enhanced Authentication Provider with improved OOP and error handling
///
/// This provider manages authentication state and operations.
/// It extends BaseProvider to inherit common functionality like:
/// - Loading state management
/// - Error message handling
/// - Logging utilities
/// - Disposal tracking
///
/// It uses the IAuthService interface for dependency injection,
/// making it easy to swap implementations for testing or alternatives.
///
/// Example usage:
/// ```dart
/// // In main.dart
/// ChangeNotifierProvider(
///   create: (_) => AuthProviderImpl(authService),
///   child: MyApp(),
/// )
///
/// // In a widget
/// context.watch<AuthProviderImpl>().currentUser
/// context.watch<AuthProviderImpl>().isLoading
/// context.read<AuthProviderImpl>().login(...)
/// ```

class AuthProviderImpl extends BaseProvider {
  /// Authentication service instance
  final IAuthService _authService;

  /// Current authenticated user
  User? _currentUser;

  /// Authentication role (for multi-role apps)
  UserRole? _userRole;

  /// Session timeout timer (if needed)
  // DateTime? _lastActivity;

  AuthProviderImpl(this._authService) {
    _initialize();
  }

  // ==================== Getters ====================

  /// Get current authenticated user
  User? get currentUser => _currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated =>
      _currentUser != null && _authService.authToken != null;

  /// Get current user's role
  UserRole? get userRole => _userRole;

  /// Get authentication token
  String? get authToken => _authService.authToken;

  /// Get user's full name
  String get currentUserName => _currentUser?.fullName ?? 'Guest';

  /// Get user's email
  String? get currentUserEmail => _currentUser?.email;

  /// Check if user is admin
  bool get isAdmin => _userRole == UserRole.admin;

  /// Check if user is driver
  bool get isDriver => _userRole == UserRole.driver;

  /// Check if user is customer
  bool get isCustomer => _userRole == UserRole.user;

  @override
  String get providerName => 'AuthProvider';

  // ==================== Initialization ====================

  /// Initialize provider by restoring session
  /// Called automatically in constructor
  Future<void> _initialize() async {
    try {
      logInfo('Initializing authentication provider...');

      // Check if user is already authenticated
      final user = await _authService.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        _userRole = user.role;
        logInfo('User session restored: ${user.username}');
      }

      safeNotifyListeners();
    } catch (e) {
      logError('Error initializing auth provider', e);
      handleException(
        UnexpectedException(
          message: 'Failed to initialize authentication',
          originalException: e,
        ),
      );
    }
  }

  // ==================== Authentication Methods ====================

  /// Login user with username and password
  ///
  /// This method:
  /// 1. Shows loading indicator
  /// 2. Calls auth service login method
  /// 3. Updates provider state on success
  /// 4. Handles errors with user-friendly messages
  ///
  /// Returns true if login successful, false otherwise
  ///
  /// Usage:
  /// ```dart
  /// final success = await authProvider.login(
  ///   username: 'user@example.com',
  ///   password: 'password123',
  /// );
  /// if (success) {
  ///   // Navigate to home
  /// }
  /// ```
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      verifyNotDisposed();

      logInfo('Attempting login for user: $username');
      setLoading(true);
      clearError();

      // Call auth service
      final user = await _authService.login(
        username: username,
        password: password,
      );

      // Update state
      _currentUser = user;
      _userRole = user.role;

      logInfo('Login successful for user: $username');
      setLoading(false);
      return true;
    } on ValidationException catch (e) {
      logWarning('Validation error: ${e.message}');
      handleException(e);
      setLoading(false);
      return false;
    } on AuthException catch (e) {
      logWarning('Authentication error: ${e.message}');
      handleException(e);
      setLoading(false);
      return false;
    } catch (e) {
      logError('Unexpected error during login', e);
      handleException(
        UnexpectedException(
          message: 'An unexpected error occurred during login',
          originalException: e,
        ),
      );
      setLoading(false);
      return false;
    }
  }

  /// Register new user
  ///
  /// Parameters:
  ///   - username: Unique username
  ///   - email: User email
  ///   - password: User password
  ///   - fullName: User's full name
  ///   - phoneNumber: Contact number
  ///
  /// Returns true if signup successful, false otherwise
  ///
  /// Usage:
  /// ```dart
  /// final success = await authProvider.signup(
  ///   username: 'newuser',
  ///   email: 'user@example.com',
  ///   password: 'SecurePass123!',
  ///   fullName: 'John Doe',
  ///   phoneNumber: '+1234567890',
  /// );
  /// ```
  Future<bool> signup({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required UserRole role,
  }) async {
    try {
      verifyNotDisposed();

      logInfo('Attempting signup for user: $username');
      setLoading(true);
      clearError();

      // Call auth service
      final user = await _authService.signup(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        role: role,
      );

      // Update state
      _currentUser = user;
      _userRole = user.role;

      logInfo('Signup successful for user: $username');
      setLoading(false);
      return true;
    } on ValidationException catch (e) {
      logWarning('Validation error: ${e.message}');
      handleException(e);
      setLoading(false);
      return false;
    } on AuthException catch (e) {
      logWarning('Authentication error: ${e.message}');
      handleException(e);
      setLoading(false);
      return false;
    } catch (e) {
      logError('Unexpected error during signup', e);
      handleException(
        UnexpectedException(
          message: 'An unexpected error occurred during signup',
          originalException: e,
        ),
      );
      setLoading(false);
      return false;
    }
  }

  /// Logout current user
  ///
  /// Clears all authentication data and state
  ///
  /// Returns true if logout successful, false otherwise
  ///
  /// Usage:
  /// ```dart
  /// await authProvider.logout();
  /// // Navigate to login screen
  /// ```
  Future<bool> logout() async {
    try {
      verifyNotDisposed();

      logInfo('Logging out user: ${_currentUser?.username}');
      setLoading(true);

      // Call auth service
      await _authService.logout();

      // Clear state
      _currentUser = null;
      _userRole = null;

      logInfo('Logout successful');
      setLoading(false);
      return true;
    } catch (e) {
      logError('Error during logout', e);
      handleException(
        UnexpectedException(
          message: 'Error during logout',
          originalException: e,
        ),
      );
      setLoading(false);
      return false;
    }
  }

  /// Refresh authentication token
  ///
  /// Should be called when token is about to expire
  ///
  /// Returns new token or null if refresh fails
  ///
  /// Usage:
  /// ```dart
  /// final newToken = await authProvider.refreshToken();
  /// if (newToken == null) {
  ///   // Re-login required
  /// }
  /// ```
  Future<String?> refreshToken() async {
    try {
      verifyNotDisposed();

      logInfo('Refreshing authentication token...');
      setLoading(true);

      final newToken = await _authService.refreshToken();

      if (newToken != null) {
        logInfo('Token refreshed successfully');
      } else {
        logWarning('Token refresh returned null');
      }

      setLoading(false);
      return newToken;
    } catch (e) {
      logError('Error refreshing token', e);
      setLoading(false);
      return null;
    }
  }

  /// Verify if token is still valid
  ///
  /// Returns true if token is valid, false otherwise
  ///
  /// Usage:
  /// ```dart
  /// if (!await authProvider.isTokenValid()) {
  ///   // Show re-login dialog
  /// }
  /// ```
  Future<bool> isTokenValid() async {
    try {
      return await _authService.isTokenValid();
    } catch (e) {
      logError('Error checking token validity', e);
      return false;
    }
  }

  // ==================== User Update Methods ====================

  /// Update current user data
  ///
  /// This is a local update for UI purposes
  /// In production, you would call an API to persist changes
  ///
  /// Usage:
  /// ```dart
  /// authProvider.updateUserData(
  ///   currentUser!.copyWith(fullName: 'Jane Doe')
  /// );
  /// ```
  void updateUserData(User updatedUser) {
    try {
      verifyNotDisposed();

      _currentUser = updatedUser;
      _userRole = updatedUser.role;

      logInfo('User data updated locally');
      safeNotifyListeners();
    } catch (e) {
      logError('Error updating user data', e);
    }
  }

  // ==================== State Management ====================

  /// Reset authentication state
  ///
  /// Clears all auth data (useful on logout or error)
  @override
  void resetState() {
    _currentUser = null;
    _userRole = null;
    super.resetState();
    logInfo('Auth state reset');
  }

  /// Clear current user session
  ///
  /// Without logging out (for errors or session expiry)
  void clearSession() {
    try {
      _currentUser = null;
      _userRole = null;
      safeNotifyListeners();
      logInfo('Session cleared');
    } catch (e) {
      logError('Error clearing session', e);
    }
  }

  @override
  void dispose() {
    logInfo('Disposing AuthProvider...');
    resetState();
    super.dispose();
  }
}
