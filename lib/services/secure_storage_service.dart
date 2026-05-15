import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../config/constants.dart';
import '../utils/logger.dart';

/// Secure Storage Service for sensitive data
/// Uses platform-specific secure storage (Keychain on iOS, Keystore on Android)
class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  late final FlutterSecureStorage _storage;

  factory SecureStorageService() {
    return _instance;
  }

  SecureStorageService._internal() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        keyCipherAlgorithm:
            KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
        storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
        resetOnError: true,
      ),
      iOptions: IOSOptions(),
    );
  }

  /// Save user authentication token
  Future<void> saveAuthToken(String token) async {
    try {
      AppLogger.info('Saving authentication token');
      await _storage.write(
        key: AppConstants.userTokenKey,
        value: _encryptToken(token),
      );
    } catch (e) {
      AppLogger.error('Error saving auth token: $e');
      rethrow;
    }
  }

  /// Retrieve user authentication token
  Future<String?> getAuthToken() async {
    try {
      final encryptedToken = await _storage.read(
        key: AppConstants.userTokenKey,
      );
      if (encryptedToken != null) {
        return _decryptToken(encryptedToken);
      }
      return null;
    } catch (e) {
      AppLogger.error('Error retrieving auth token: $e');
      return null;
    }
  }

  /// Save user data as JSON
  Future<void> saveUserData(String jsonData) async {
    try {
      AppLogger.info('Saving user data');
      await _storage.write(key: AppConstants.userDataKey, value: jsonData);
    } catch (e) {
      AppLogger.error('Error saving user data: $e');
      rethrow;
    }
  }

  /// Retrieve user data as JSON
  Future<String?> getUserData() async {
    try {
      return await _storage.read(key: AppConstants.userDataKey);
    } catch (e) {
      AppLogger.error('Error retrieving user data: $e');
      return null;
    }
  }

  /// Save user refresh token
  Future<void> saveRefreshToken(String token) async {
    try {
      AppLogger.info('Saving refresh token');
      await _storage.write(
        key: '${AppConstants.userTokenKey}_refresh',
        value: token,
      );
    } catch (e) {
      AppLogger.error('Error saving refresh token: $e');
      rethrow;
    }
  }

  /// Retrieve user refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: '${AppConstants.userTokenKey}_refresh');
    } catch (e) {
      AppLogger.error('Error retrieving refresh token: $e');
      return null;
    }
  }

  /// Remove authentication token
  Future<void> removeAuthToken() async {
    try {
      AppLogger.info('Removing auth token');
      await delete(AppConstants.userTokenKey);
    } catch (e) {
      AppLogger.error('Error removing auth token: $e');
      rethrow;
    }
  }

  /// Remove refresh token
  Future<void> removeRefreshToken() async {
    try {
      AppLogger.info('Removing refresh token');
      await delete('${AppConstants.userTokenKey}_refresh');
    } catch (e) {
      AppLogger.error('Error removing refresh token: $e');
      rethrow;
    }
  }

  /// Remove user data
  Future<void> removeUserData() async {
    try {
      AppLogger.info('Removing user data');
      await delete(AppConstants.userDataKey);
    } catch (e) {
      AppLogger.error('Error removing user data: $e');
      rethrow;
    }
  }

  /// Save a string value
  Future<void> saveString(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      AppLogger.error('Error saving string for key $key: $e');
      rethrow;
    }
  }

  /// Retrieve a string value
  Future<String?> getString(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      AppLogger.error('Error retrieving string for key $key: $e');
      return null;
    }
  }

  /// Save an integer value
  Future<void> saveInt(String key, int value) async {
    try {
      await _storage.write(key: key, value: value.toString());
    } catch (e) {
      AppLogger.error('Error saving int for key $key: $e');
      rethrow;
    }
  }

  /// Retrieve an integer value
  Future<int?> getInt(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null ? int.parse(value) : null;
    } catch (e) {
      AppLogger.error('Error retrieving int for key $key: $e');
      return null;
    }
  }

  /// Save a boolean value
  Future<void> saveBool(String key, bool value) async {
    try {
      await _storage.write(key: key, value: value.toString());
    } catch (e) {
      AppLogger.error('Error saving bool for key $key: $e');
      rethrow;
    }
  }

  /// Retrieve a boolean value
  Future<bool?> getBool(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null ? value.toLowerCase() == 'true' : null;
    } catch (e) {
      AppLogger.error('Error retrieving bool for key $key: $e');
      return null;
    }
  }

  /// Delete a specific key
  Future<void> delete(String key) async {
    try {
      AppLogger.info('Deleting key: $key');
      await _storage.delete(key: key);
    } catch (e) {
      AppLogger.error('Error deleting key $key: $e');
      rethrow;
    }
  }

  /// Clear all stored data
  Future<void> clearAll() async {
    try {
      AppLogger.info('Clearing all secure storage');
      await _storage.deleteAll();
    } catch (e) {
      AppLogger.error('Error clearing secure storage: $e');
      rethrow;
    }
  }

  /// Check if a key exists
  Future<bool> contains(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      AppLogger.error('Error checking if key exists: $e');
      return false;
    }
  }

  /// Encrypt token using SHA256
  String _encryptToken(String token) {
    return sha256.convert(utf8.encode(token)).toString();
  }

  /// Decrypt token (for this simple implementation, we just return the token)
  /// In production, use proper encryption like AES
  String _decryptToken(String encryptedToken) {
    return encryptedToken;
  }

  /// Clear session data on logout
  Future<void> clearSessionData() async {
    try {
      AppLogger.info('Clearing session data');
      await delete(AppConstants.userTokenKey);
      await delete(AppConstants.userDataKey);
      await delete(AppConstants.isLoggedInKey);
      await delete(AppConstants.lastLoginKey);
    } catch (e) {
      AppLogger.error('Error clearing session data: $e');
      rethrow;
    }
  }
}
