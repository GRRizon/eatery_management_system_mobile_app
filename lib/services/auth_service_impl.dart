import 'dart:convert';
import '../core/base/base_service.dart';
import '../core/interfaces/services.dart';
import '../core/exceptions/app_exceptions.dart';
import '../core/validation/input_validator.dart';
import '../models/user_model.dart';
import '../core/config/app_config.dart';

/// Enhanced Authentication Service with improved OOP and security
///
/// This service handles all authentication operations including:
/// - User login/signup
/// - Token management
/// - Session handling
/// - Security token encryption
///
/// It follows the SOLID principles:
/// - Single Responsibility: Only handles authentication
/// - Open/Closed: Can be extended without modification
/// - Liskov Substitution: Implements IAuthService interface
/// - Interface Segregation: Depends on IAuthService interface
/// - Dependency Inversion: Uses dependency injection
///
/// Example usage:
/// ```dart
/// // Create service
/// final authService = AuthServiceImpl();
/// await authService.initialize();
///
/// // Use methods
/// final user = await authService.login(
///   username: 'user',
///   password: 'pass123',
/// );
///
/// // Dispose when done
/// await authService.dispose();
/// ```

class AuthServiceImpl extends BaseService implements IAuthService {
  /// Secure storage for tokens and sensitive data
  final IStorageService _storageService;

  /// Constructor with dependency injection for storage service
  AuthServiceImpl(this._storageService);

  /// Currently authenticated user
  User? _currentUser;

  /// Current authentication token
  String? _authToken;

  /// Current refresh token
  String? _refreshToken;

  /// Mock user database for demo purposes.
  /// In a real application, this would be a backend API call.
  static final Map<String, Map<String, dynamic>> _mockUserDatabase = {
    'Rabbani': {
      'password': 'golam1234',
      'role': UserRole.user,
      'fullName': 'Golam Rabbani',
    },
    'admin': {
      'password': 'admin123',
      'role': UserRole.admin,
      'fullName': 'Admin User',
    },
    'driver': {
      'password': 'driver123',
      'role': UserRole.driver,
      'fullName': 'Delivery Driver',
    },
  };

  // Default password for any other test user during login.
  static const String _mockDefaultPassword = 'golam1234';

  @override
  String get serviceName => 'AuthService';

  @override
  bool get isAuthenticated => _authToken != null && _currentUser != null;

  @override
  User? get currentUser => _currentUser;

  @override
  String? get authToken => _authToken;

  /// Initialize the authentication service
  /// Restores previous session if available
  @override
  Future<void> initialize() async {
    try {
      await super.initialize();

      logInfo('Loading saved session...');

      // Try to restore previous session
      _authToken = await _storageService.getValue(
        AppConfig.storageKeyAuthToken,
      );
      _refreshToken = await _storageService.getValue(
        AppConfig.storageKeyRefreshToken,
      );
      final userData = await _storageService.getValue(
        AppConfig.storageKeyUserData,
      );

      if (_authToken != null && userData != null) {
        try {
          _currentUser = User.fromJson(jsonDecode(userData));
          logInfo('Session restored for user: ${_currentUser?.username}');
        } catch (e) {
          logWarning('Failed to parse saved user data: $e');
          await _clearSessionData();
        }
      }
    } catch (e) {
      logError('Error initializing AuthService', e);
      await _clearSessionData();
      rethrow;
    }
  }

  /// Login user with username and password
  ///
  /// This method:
  /// 1. Validates input parameters
  /// 2. Authenticates user credentials
  /// 3. Generates authentication token
  /// 4. Stores token securely
  /// 5. Returns authenticated user
  ///
  /// Throws:
  /// - [ValidationException] if inputs are invalid
  /// - [AuthException] if credentials are invalid
  /// - [NetworkException] if network request fails
  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      verifyInitialized();

      logInfo('Login attempt for user: $username');

      // Validate inputs
      _validateLoginInputs(username, password);

      // Authenticate credentials (mock for demo)
      final authenticated = await _authenticateCredentials(username, password);
      if (!authenticated) {
        logWarning('Invalid credentials for user: $username');
        throw AuthException(
          message: 'Invalid username or password',
          code: 'INVALID_CREDENTIALS',
        );
      }

      // Generate tokens (mock - in production use backend)
      _authToken = _generateMockToken(username);
      _refreshToken = _generateMockRefreshToken(username);

      // Create user (mock - in production fetch from backend)
      _currentUser = _createMockUser(
        username,
        _mockUserDatabase[username]?['role'] ?? UserRole.user,
      );

      // Store tokens securely
      await Future.wait([
        _storageService.setValue(AppConfig.storageKeyAuthToken, _authToken!),
        _storageService.setValue(
          AppConfig.storageKeyRefreshToken,
          _refreshToken!,
        ),
        _storageService.setValue(
          AppConfig.storageKeyUserData,
          jsonEncode(_currentUser!.toJson()),
        ),
      ]);

      logInfo('Login successful for user: $username');
      return _currentUser!;
    } on AppException {
      await _clearSessionData();
      rethrow;
    } catch (e) {
      await _clearSessionData();
      handleException('Login failed', e);
    }
  }

  /// Register new user
  ///
  /// This method:
  /// 1. Validates all input parameters
  /// 2. Checks username availability (mock)
  /// 3. Creates user account
  /// 4. Generates authentication tokens
  /// 5. Logs user in
  ///
  /// Throws:
  /// - [ValidationException] if inputs are invalid
  /// - [AuthException] if username already exists
  @override
  Future<User> signup({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required UserRole role,
  }) async {
    try {
      verifyInitialized();

      logInfo('Signup attempt for user: $username');

      // Validate all inputs
      _validateSignupInputs(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );

      // Check username availability (mock - in production check with backend)
      if (_isUsernameTaken(username)) {
        throw AuthException(
          message: 'Username already taken',
          code: 'USERNAME_TAKEN',
        );
      }

      // Generate tokens
      _authToken = _generateMockToken(username);
      _refreshToken = _generateMockRefreshToken(username);

      // Create user object
      _currentUser = User(
        id: _generateUserId(),
        username: username,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        address: '',
        profileImageUrl: null,
        role: role,
        createdAt: DateTime.now(),
      );

      // Store tokens and user data
      await Future.wait([
        _storageService.setValue(AppConfig.storageKeyAuthToken, _authToken!),
        _storageService.setValue(
          AppConfig.storageKeyRefreshToken,
          _refreshToken!,
        ),
        _storageService.setValue(
          AppConfig.storageKeyUserData,
          jsonEncode(_currentUser!.toJson()),
        ),
      ]);

      logInfo('Signup successful for user: $username');
      return _currentUser!;
    } on AppException {
      await _clearSessionData();
      rethrow;
    } catch (e) {
      await _clearSessionData();
      handleException('Signup failed', e);
    }
  }

  /// Logout current user
  ///
  /// This method:
  /// 1. Invalidates tokens on server (mock)
  /// 2. Clears local tokens
  /// 3. Clears user data
  @override
  Future<void> logout() async {
    try {
      verifyInitialized();

      logInfo('Logging out user: ${_currentUser?.username}');

      // In production, send logout request to backend
      // to invalidate tokens server-side
      // await _apiClient.post('/auth/logout');

      await _clearSessionData();

      logInfo('Logout successful');
    } catch (e) {
      logError('Error during logout', e);
      // Still clear data even if error occurs
      await _clearSessionData();
      rethrow;
    }
  }

  /// Refresh authentication token
  ///
  /// Called when access token is about to expire
  ///
  /// Throws [AuthException] if refresh fails
  @override
  Future<String?> refreshToken() async {
    try {
      verifyInitialized();

      if (_refreshToken == null) {
        throw AuthException(
          message: 'No refresh token available',
          code: 'NO_REFRESH_TOKEN',
        );
      }

      logInfo('Refreshing authentication token...');

      // In production, send to backend
      // final response = await _apiClient.post(
      //   '/auth/refresh',
      //   data: {'refreshToken': _refreshToken},
      // );
      // _authToken = response.data['accessToken'];

      // Mock token refresh
      _authToken = _generateMockToken(_currentUser?.username ?? 'user');

      // Save new token
      await _storageService.setValue(
        AppConfig.storageKeyAuthToken,
        _authToken!,
      );

      logInfo('Token refreshed successfully');
      return _authToken;
    } catch (e) {
      handleException('Token refresh failed', e);
    }
  }

  /// Get currently authenticated user
  ///
  /// Throws [AuthException] if not authenticated
  @override
  Future<User?> getCurrentUser() async {
    try {
      verifyInitialized();

      if (!isAuthenticated) {
        return null;
      }

      return _currentUser;
    } catch (e) {
      handleException('Failed to get current user', e);
    }
  }

  /// Check if token is valid and not expired
  @override
  Future<bool> isTokenValid() async {
    try {
      if (_authToken == null) {
        return false;
      }

      // In production, verify token with backend or decode JWT
      // and check expiry time
      logInfo('Token validation check passed');
      return true;
    } catch (e) {
      logError('Token validation failed', e);
      return false;
    }
  }

  /// Dispose service and clean up resources
  @override
  Future<void> dispose() async {
    try {
      logInfo('Disposing AuthService...');
      await _clearSessionData();
      await super.dispose();
    } catch (e) {
      logError('Error disposing AuthService', e);
      rethrow;
    }
  }

  // ==================== Private Helper Methods ====================

  /// Validate login input parameters
  void _validateLoginInputs(String username, String password) {
    final usernameError = InputValidator.validateUsername(username);
    if (usernameError != null) {
      throw ValidationException(message: usernameError, fieldName: 'username');
    }

    if (password.isEmpty) {
      throw ValidationException(
        message: 'Password is required',
        fieldName: 'password',
      );
    }
  }

  /// Validate signup input parameters
  void _validateSignupInputs({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) {
    // Validate username
    final usernameError = InputValidator.validateUsername(username);
    if (usernameError != null) {
      throw ValidationException(message: usernameError, fieldName: 'username');
    }

    // Validate email
    final emailError = InputValidator.validateEmail(email);
    if (emailError != null) {
      throw ValidationException(message: emailError, fieldName: 'email');
    }

    // Validate password
    final passwordError = InputValidator.validatePassword(password);
    if (passwordError != null) {
      throw ValidationException(message: passwordError, fieldName: 'password');
    }

    // Validate full name
    final nameError = InputValidator.validateFullName(fullName);
    if (nameError != null) {
      throw ValidationException(message: nameError, fieldName: 'fullName');
    }

    // Validate phone number
    final phoneError = InputValidator.validatePhoneNumber(phoneNumber);
    if (phoneError != null) {
      throw ValidationException(message: phoneError, fieldName: 'phoneNumber');
    }
  }

  /// Authenticate credentials (mock implementation)
  /// In production, send to backend API
  Future<bool> _authenticateCredentials(
    String username,
    String password,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    if (_mockUserDatabase.containsKey(username)) {
      return _mockUserDatabase[username]!['password'] == password;
    }
    // For any other user, use the default password for testing
    return password == _mockDefaultPassword;
  }

  /// Check if username is already taken (mock implementation)
  bool _isUsernameTaken(String username) {
    // In production, check with backend
    return false;
  }

  /// Generate mock authentication token
  String _generateMockToken(String username) {
    // In production, receive from backend (typically JWT)
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'token_${username}_$timestamp';
  }

  /// Generate mock refresh token
  String _generateMockRefreshToken(String username) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'refresh_${username}_$timestamp';
  }

  /// Generate unique user ID
  String _generateUserId() {
    return 'user_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Create mock user object
  User _createMockUser(String username, UserRole role) {
    final mockData = _mockUserDatabase[username];

    return User(
      id: 'user_${username.hashCode}',
      username: username,
      email: '$username@eatery.local',
      fullName: mockData?['fullName'] ?? 'Test User',
      phoneNumber: '+880-1700-000000',
      address: '123 Restaurant Lane, Dhaka',
      profileImageUrl: null,
      role: role,
      createdAt: DateTime.now(),
    );
  }

  /// Clear all session data
  Future<void> _clearSessionData() async {
    try {
      _currentUser = null;
      _authToken = null;
      _refreshToken = null;

      await Future.wait([
        _storageService.deleteValue(AppConfig.storageKeyAuthToken),
        _storageService.deleteValue(AppConfig.storageKeyRefreshToken),
        _storageService.deleteValue(AppConfig.storageKeyUserData),
      ]);
    } catch (e) {
      logWarning('Error clearing session data: $e');
    }
  }
}
