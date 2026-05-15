# Security Implementation Guide

## Overview

This document explains the security measures implemented in the Eatery Management System and how to maintain them.

## 1. Secure Data Storage

### Problem
Storing sensitive data in plain text exposes the app to attacks if someone gains access to the device.

### Solution
Use **flutter_secure_storage** package:

```dart
// ❌ WRONG - Store token in plain SharedPreferences
await prefs.setString('auth_token', token);

// ✅ CORRECT - Store token in secure storage
await secureStorage.saveAuthToken(token);
```

### Implementation

```dart
class SecureStorageService {
  Future<void> saveAuthToken(String token) async {
    await _storage.write(
      key: 'auth_token',
      value: token,
    );
  }

  Future<String?> getAuthToken() async {
    return await _storage.read(key: 'auth_token');
  }
}
```

### Platform-Specific Encryption
- **iOS**: Keychain (encrypted)
- **Android**: Keystore (encrypted)

## 2. Input Validation

### Problem
Invalid or malicious input can crash the app or expose vulnerabilities.

### Solution
Validate ALL user input before processing:

```dart
// ✅ Always validate
String? emailError = InputValidator.validateEmail(userInput);
if (emailError != null) {
  showError(emailError);
  return;
}
```

### Validation Types

```dart
// Email
"user@example.com" ✅ Valid
"user" ❌ Missing @
"user@" ❌ Missing domain

// Password (must have)
✓ Minimum 6 characters
✓ Uppercase letter
✓ Lowercase letter
✓ Number
✓ Special character

// Phone
"+1234567890" ✅ Valid
"12345" ❌ Too short
"ABCDE" ❌ Not numeric

// Credit card (Luhn algorithm)
"4532015112830366" ✅ Valid
"1111111111111111" ❌ Invalid checksum
```

## 3. Exception Handling

### Problem
Showing raw error messages reveals system details to attackers.

### Solution
Use custom exceptions with user-friendly messages:

```dart
// ❌ WRONG - Exposes system details
catch (e) {
  print(e.toString()); // Might show database errors!
}

// ✅ CORRECT - User-friendly message
catch (e) {
  if (e is AuthException) {
    showError('Invalid username or password');
  } else if (e is NetworkException) {
    showError('Connection failed. Please try again.');
  } else {
    showError('An error occurred. Please try again later.');
  }
}
```

### Exception Types

```dart
// Authentication errors
AuthException("Invalid credentials")

// Network errors  
NetworkException("Connection timeout")

// Validation errors
ValidationException("Email format invalid", fieldName: "email")

// Business logic errors
BusinessException("Item not found")

// General errors
UnexpectedException("Unexpected error")
```

## 4. Token Management

### Problem
If tokens aren't managed properly, attackers can use expired or compromised tokens.

### Solution
Implement secure token handling:

```dart
class AuthService {
  // 1. Store tokens securely
  Future<void> login(...) {
    final token = generateToken();
    await secureStorage.saveAuthToken(token);
  }

  // 2. Add token to API requests
  Future<Response> apiRequest(String endpoint) {
    final token = await secureStorage.getAuthToken();
    return http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  // 3. Refresh expiring tokens
  Future<void> checkTokenExpiry() {
    if (isTokenExpiring()) {
      final newToken = await refreshToken();
      await secureStorage.saveAuthToken(newToken);
    }
  }

  // 4. Clear tokens on logout
  Future<void> logout() {
    await secureStorage.removeAuthToken();
  }
}
```

### Token Lifecycle

```
Create Token (Login)
    ↓
Token Valid (use for API requests)
    ↓
Token About to Expire (refresh automatically)
    ↓
New Token Received (store securely)
    ↓
Old Token Cleared
    ↓
logout() → Clear all tokens
```

## 5. API Security

### Best Practices

```dart
// 1. Always use HTTPS (never HTTP)
const String apiBaseUrl = 'https://api.eatery.local/v1'; // ✅
// const String apiBaseUrl = 'http://api.eatery.local'; // ❌

// 2. Validate SSL certificates
final client = HttpClient()
  ..badCertificateCallback = (cert, host, port) => false; // Don't accept bad certs

// 3. Set appropriate timeouts
static const Duration apiTimeout = Duration(seconds: 30);

// 4. Never log sensitive data
logInfo('User login'); // ✅
logInfo('User: $username, Password: $password'); // ❌ Never!

// 5. Use POST for sensitive data (not GET)
// ❌ WRONG - Password visible in URL
https://api.eatery.local/v1/auth/login?username=user&password=pass

// ✅ CORRECT - Password in request body
POST https://api.eatery.local/v1/auth/login
{
  "username": "user",
  "password": "pass"
}
```

## 6. Authentication Flow

### Login Process

```
User enters credentials
    ↓
Validate locally (format check)
    ↓
Send to backend via HTTPS POST
    ↓
Backend validates against database
    ↓
If valid:
  - Generate JWT token
  - Return token + user data
    ↓
If invalid:
  - Return error
  - Show "Invalid credentials"
    ↓
Store token securely (encrypted)
    ↓
Add token to future API requests
```

### Code Example

```dart
Future<User> login({
  required String username,
  required String password,
}) async {
  // 1. Validate input locally
  if (username.isEmpty || password.isEmpty) {
    throw ValidationException(message: 'All fields required');
  }

  // 2. Send to backend
  final response = await http.post(
    Uri.parse('$apiBaseUrl/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'password': password,
    }),
  );

  // 3. Check response
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final token = data['token'];
    
    // 4. Store token securely
    await secureStorage.saveAuthToken(token);
    
    return User.fromJson(data['user']);
  } else {
    throw AuthException(message: 'Invalid credentials');
  }
}
```

## 7. Password Security

### Requirements

Your password must have ALL of:
- ✅ Minimum 6 characters (better: 8+)
- ✅ At least 1 uppercase letter (A-Z)
- ✅ At least 1 lowercase letter (a-z)
- ✅ At least 1 number (0-9)
- ✅ At least 1 special character (!@#$%^&*)

### Examples

```
"Password123!" ✅ Good - meets all requirements
"pass" ❌ Bad - too short
"password" ❌ Bad - no uppercase or number
"PASSWORD" ❌ Bad - no lowercase
"Pass123" ❌ Bad - no special character
```

### Never

```dart
// ❌ NEVER hardcode passwords
const String adminPassword = 'admin123';

// ❌ NEVER log passwords
print('User password: $password');

// ❌ NEVER send in URL
'https://api.com/login?password=pass123'

// ❌ NEVER store plain text
database.insert('password', plainPassword);
```

## 8. Data Encryption

### What to Encrypt

1. **Always Encrypt**
   - Authentication tokens
   - User passwords
   - Personal information (name, email, phone)
   - Payment information
   - API keys

2. **Encrypt if Sensitive**
   - Order history
   - Delivery addresses
   - Preferences

3. **Can be Plain Text**
   - Public app information
   - Menu items
   - UI resources

### Implementation

```dart
// Using crypto package
import 'package:crypto/crypto.dart';

// Hash password
String hashPassword(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}

// Encrypt sensitive data
String encrypt(String data) {
  // In production, use AES or similar
  return base64.encode(utf8.encode(data));
}
```

## 9. Permission Management

### Required Permissions

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.INTERNET" /> ✅
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" /> ✅

<!-- Only if needed -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" /> (for delivery)
<uses-permission android:name="android.permission.CAMERA" /> (for profile picture)
```

### User Consent

Always ask before accessing:
- Location
- Camera
- Contacts
- Photos
- Microphone

```dart
// Ask permission before using
Future<bool> requestLocationPermission() {
  return Permission.location.request().isGranted;
}
```

## 10. Security Checklist

Before deploying to production:

- [ ] Remove debug logging of sensitive data
- [ ] Remove hardcoded credentials
- [ ] Validate all user inputs
- [ ] Use HTTPS only
- [ ] Implement token refresh
- [ ] Clear sensitive data on logout
- [ ] Use secure storage for tokens
- [ ] Handle errors gracefully
- [ ] Keep dependencies updated
- [ ] Test with invalid/malicious input
- [ ] Review all API endpoints
- [ ] Implement rate limiting
- [ ] Add request signing/verification
- [ ] Use SSL certificate pinning
- [ ] Enable code obfuscation
- [ ] Review permissions

## 11. Common Security Mistakes

### ❌ Mistake 1: Storing Passwords

```dart
// WRONG
await storage.setString('password', userPassword);

// RIGHT
final hashedPassword = sha256.convert(utf8.encode(userPassword));
// Send hashedPassword to backend (never the plain password!)
```

### ❌ Mistake 2: Exposing Tokens

```dart
// WRONG
print('Token: $authToken'); // Visible in logs!

// RIGHT
logInfo('User logged in'); // No sensitive data
```

### ❌ Mistake 3: Ignoring Errors

```dart
// WRONG
try {
  await apiCall();
} catch (e) {
  // Ignore - hope it works?
}

// RIGHT
try {
  await apiCall();
} catch (e) {
  handleError(e);
  showErrorToUser(e);
}
```

### ❌ Mistake 4: No Input Validation

```dart
// WRONG
Future<void> createAccount(String email, String password) {
  // What if email is invalid? What if password is weak?
  sendToBackend(email, password);
}

// RIGHT
Future<void> createAccount(String email, String password) {
  // Validate before sending
  if (InputValidator.validateEmail(email) != null) {
    showError('Invalid email');
    return;
  }
  if (InputValidator.validatePassword(password) != null) {
    showError('Password too weak');
    return;
  }
  sendToBackend(email, password);
}
```

### ❌ Mistake 5: Using HTTP Instead of HTTPS

```dart
// WRONG
const String url = 'http://api.eatery.local'; // Unencrypted!

// RIGHT
const String url = 'https://api.eatery.local'; // Encrypted
```

## 12. Security Updates

### Keep Everything Updated

```bash
# Update Flutter
flutter upgrade

# Update dependencies
flutter pub upgrade

# Check for security issues
flutter pub outdated

# Publish analysis
dart analyze
```

### Monitor Packages

- Check pub.dev for security advisories
- Update regularly
- Don't ignore updates for "stable" packages

## 13. Reporting Security Issues

If you find a security vulnerability:

1. **Don't publish publicly**
2. **Email security team** with details
3. **Include proof of concept**
4. **Allow time to fix**
5. **Credit will be given**

## Summary

**Security is not optional!**

Key points:
- ✅ Always validate input
- ✅ Use secure storage for sensitive data
- ✅ Use HTTPS for all communication
- ✅ Manage tokens carefully
- ✅ Handle errors gracefully
- ✅ Keep dependencies updated
- ✅ Log responsibly (no sensitive data)
- ✅ Test with malicious input

Remember: **A hacked app is worse than a slow app!**
