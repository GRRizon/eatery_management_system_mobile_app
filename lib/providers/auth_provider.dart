import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/logger.dart';

/// Auth Provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  User? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  AuthProvider(this._authService, {bool autoInitialize = true}) {
    if (autoInitialize) {
      _initialize();
    }
  }

  // Getters
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get authToken => _authService.authToken;

  /// Initialize provider by checking existing session
  Future<void> _initialize() async {
    try {
      final user = await _authService.getCurrentUser();
      _currentUser = user;
      _isAuthenticated = user != null;
      notifyListeners();
    } catch (e) {
      AppLogger.error('Error initializing AuthProvider: $e');
    }
  }

  /// Login with username and password
  Future<bool> login({
    required String username,
    required String password,
    UserRole role = UserRole.user,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final user = await _authService.login(
        username: username,
        password: password,
        role: role,
      );

      _currentUser = user;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Login error: $e');
      return false;
    }
  }

  /// Sign up new user
  Future<bool> signup({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    UserRole role = UserRole.user,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final user = await _authService.signup(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        role: role,
      );

      _currentUser = user;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Signup error: $e');
      return false;
    }
  }

  /// Logout current user
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.logout();

      _currentUser = null;
      _isAuthenticated = false;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Logout error: $e');
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final user = await _authService.updateProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        address: address,
      );

      _currentUser = user;
      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Profile update error: $e');
      return false;
    }
  }

  /// Refresh authentication token
  Future<void> refreshToken() async {
    try {
      final success = await _authService.refreshToken();
      if (!success) {
        _errorMessage = 'Failed to refresh token';
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      AppLogger.error('Token refresh error: $e');
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Check session validity
  Future<bool> checkSessionValidity() async {
    try {
      return await _authService.isSessionValid();
    } catch (e) {
      AppLogger.error('Error checking session: $e');
      return false;
    }
  }
}
