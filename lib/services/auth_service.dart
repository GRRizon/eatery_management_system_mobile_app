import 'dart:convert';
import '../models/user_model.dart';
import '../config/constants.dart';
import '../utils/logger.dart';
import 'secure_storage_service.dart';

/// Authentication Service for managing user authentication
/// This service handles login, signup, logout, and token management
class AuthService {
  static final AuthService _instance = AuthService._internal();
  final SecureStorageService _secureStorage = SecureStorageService();

  // Mock user credentials by role (in production, use backend API)
  static const Map<UserRole, Map<String, String>> _mockCredentials = {
    UserRole.user: {'username': 'Rabbani', 'password': 'golam1234'},
    UserRole.admin: {'username': 'Admin', 'password': 'tasmin1234'},
    UserRole.driver: {'username': 'Mikail', 'password': 'mikail1234'},
  };

  User? _currentUser;
  String? _authToken;

  bool get isAuthenticated => _authToken != null && _currentUser != null;
  User? get currentUser => _currentUser;
  String? get authToken => _authToken;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  /// Initialize auth service by loading saved session
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing AuthService');
      final token = await _secureStorage.getAuthToken();
      final userData = await _secureStorage.getUserData();

      if (token != null && userData != null) {
        _authToken = token;
        _currentUser = User.fromJson(jsonDecode(userData));
        AppLogger.info('Session restored for user: ${_currentUser?.username}');
      }
    } catch (e) {
      AppLogger.error('Error initializing AuthService: $e');
    }
  }

  /// Login user with credentials
  Future<User?> login({
    required String username,
    required String password,
    UserRole role = UserRole.user,
  }) async {
    try {
      AppLogger.info('Attempting login for user: $username');

      // Validate inputs
      if (username.isEmpty || password.isEmpty) {
        throw AuthException(AppConstants.invalidCredentialsMessage);
      }

      // Mock authentication (in production, use backend API)
      final roleCredentials = _mockCredentials[role];
      if (roleCredentials == null ||
          username != roleCredentials['username'] ||
          password != roleCredentials['password']) {
        throw AuthException(AppConstants.invalidCredentialsMessage);
      }

      // Create mock user with the selected role
      final userDetails = _getUserDetailsForRole(role);
      final user = User(
        id: 'user_${role.name}_001',
        username: username,
        email: userDetails['email']!,
        fullName: userDetails['fullName']!,
        phoneNumber: userDetails['phoneNumber']!,
        address: userDetails['address'],
        profileImageUrl: null,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLoginAt: DateTime.now(),
        isActive: true,
        role: role,
      );

      // Generate mock token
      final token = _generateMockToken();

      // Save session
      _authToken = token;
      _currentUser = user;

      await _secureStorage.saveAuthToken(token);
      await _secureStorage.saveUserData(jsonEncode(user.toJson()));
      await _secureStorage.saveBool(AppConstants.isLoggedInKey, true);
      await _secureStorage.saveString(
        AppConstants.lastLoginKey,
        DateTime.now().toIso8601String(),
      );

      AppLogger.info('User logged in successfully: ${user.username}');
      return user;
    } catch (e) {
      AppLogger.error('Login error: $e');
      rethrow;
    }
  }

  /// Get user details based on role
  Map<String, String> _getUserDetailsForRole(UserRole role) {
    switch (role) {
      case UserRole.user:
        return {
          'email': 'rabbani@eatery.local',
          'fullName': 'Golam Rabbani',
          'phoneNumber': '+1-800-EATERY',
          'address': '123 Restaurant Lane, Food City',
        };
      case UserRole.admin:
        return {
          'email': 'admin@eatery.local',
          'fullName': 'Tasmin Admin',
          'phoneNumber': '+1-800-ADMIN',
          'address': '456 Management Blvd, Admin City',
        };
      case UserRole.driver:
        return {
          'email': 'mikail@eatery.local',
          'fullName': 'Mikail Driver',
          'phoneNumber': '+1-800-DRIVER',
          'address': '789 Delivery Street, Driver Town',
        };
    }
  }

  /// Sign up new user
  Future<User?> signup({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    UserRole role = UserRole.user,
  }) async {
    try {
      AppLogger.info('Attempting signup for user: $username');

      // Validate inputs
      if (username.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          fullName.isEmpty ||
          phoneNumber.isEmpty) {
        throw AuthException('All fields are required');
      }

      // In production, send to backend API
      // For now, just create a mock user
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        isActive: true,
        role: role,
      );

      AppLogger.info('User signed up successfully: ${user.username}');
      return user;
    } catch (e) {
      AppLogger.error('Signup error: $e');
      rethrow;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      AppLogger.info('Logging out user: ${_currentUser?.username}');
      _authToken = null;
      _currentUser = null;
      await _secureStorage.clearSessionData();
      AppLogger.info('User logged out successfully');
    } catch (e) {
      AppLogger.error('Logout error: $e');
      rethrow;
    }
  }

  /// Refresh authentication token
  Future<bool> refreshToken() async {
    try {
      AppLogger.info('Refreshing auth token');

      if (_currentUser == null) {
        throw AuthException('No user logged in');
      }

      // Generate new mock token
      final newToken = _generateMockToken();
      _authToken = newToken;

      await _secureStorage.saveAuthToken(newToken);
      AppLogger.info('Token refreshed successfully');
      return true;
    } catch (e) {
      AppLogger.error('Token refresh error: $e');
      return false;
    }
  }

  /// Check if current session is valid
  Future<bool> isSessionValid() async {
    try {
      if (_authToken == null || _currentUser == null) {
        return false;
      }

      // In production, validate token with backend
      return true;
    } catch (e) {
      AppLogger.error('Error checking session validity: $e');
      return false;
    }
  }

  /// Get current user profile
  Future<User?> getCurrentUser() async {
    try {
      if (_currentUser == null) {
        final userData = await _secureStorage.getUserData();
        if (userData != null) {
          _currentUser = User.fromJson(jsonDecode(userData));
        }
      }
      return _currentUser;
    } catch (e) {
      AppLogger.error('Error getting current user: $e');
      return null;
    }
  }

  /// Update user profile
  Future<User?> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? address,
    String? profileImageUrl,
  }) async {
    try {
      if (_currentUser == null) {
        throw AuthException('No user logged in');
      }

      _currentUser = _currentUser!.copyWith(
        fullName: fullName,
        phoneNumber: phoneNumber ?? _currentUser!.phoneNumber,
        address: address ?? _currentUser!.address,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
      );

      await _secureStorage.saveUserData(jsonEncode(_currentUser!.toJson()));
      AppLogger.info('User profile updated: $fullName');
      return _currentUser;
    } catch (e) {
      AppLogger.error('Error updating profile: $e');
      rethrow;
    }
  }

  /// Generate mock authentication token
  String _generateMockToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'mock_token_${_currentUser?.id}_$timestamp';
  }

  /// Clear all auth data
  Future<void> clearAll() async {
    try {
      _authToken = null;
      _currentUser = null;
      await _secureStorage.clearAll();
      AppLogger.info('All auth data cleared');
    } catch (e) {
      AppLogger.error('Error clearing auth data: $e');
      rethrow;
    }
  }
}

/// Custom exception for authentication errors
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
