# Eatery Management System - Flutter App Development Guide

## Quick Start for Beginners

### What is this project?

This is a **Flutter mobile application** for restaurant management with customer ordering, admin dashboard, and driver delivery tracking.

Think of it like **Uber Eats or Swiggy** - a complete food ordering platform.

## Project Structure Explained

### 📁 `lib/` - Main Application Code

```
lib/
├── core/                    # Core functionality used everywhere
│   ├── base/               # Base classes for services and providers
│   ├── config/             # App configuration and constants
│   ├── exceptions/         # Error handling
│   ├── interfaces/         # Service contracts (like instructions)
│   └── validation/         # Input validation
│
├── models/                 # Data structures (what data looks like)
│   ├── user_model.dart
│   ├── menu_item_model.dart
│   ├── order_model.dart
│   └── cart_model.dart
│
├── services/               # Business logic (how to do things)
│   ├── auth_service_impl.dart     # Login/Signup logic
│   ├── menu_service_impl.dart     # Menu loading logic
│   ├── order_service.dart         # Order placement logic
│   └── secure_storage_service.dart # Save data securely
│
├── providers/              # State management (app state)
│   ├── auth_provider_impl.dart    # Auth state
│   ├── menu_provider.dart         # Menu state
│   └── order_provider.dart        # Order state
│
├── screens/                # UI pages (what users see)
│   ├── auth/              # Login, Signup screens
│   ├── home/              # Home screen
│   ├── menu/              # Menu/Products screen
│   ├── order/             # Orders screen
│   └── profile/           # User profile screen
│
├── widgets/                # Reusable UI components
│   ├── custom/            # Custom widgets
│   ├── dialogs/           # Dialog widgets
│   └── common/            # Common widgets
│
├── utils/                  # Helper functions
│   ├── logger.dart        # Logging
│   └── validators.dart    # Validation
│
└── main.dart              # App entry point

```

### Understanding the Layers

This app uses **MVVM Architecture** with **Provider Pattern**:

```
USER INTERFACE
    ↓ (user clicks button)
SCREEN (Widget)
    ↓ (calls provider)
PROVIDER (State Manager)
    ↓ (calls service)
SERVICE (Business Logic)
    ↓ (processes data)
MODEL (Data Structure)
```

**Example Flow: User Login**

```dart
// 1. User taps "Login" button in LoginScreen (UI Layer)
// 2. Screen calls provider.login() (Provider Layer)
// 3. Provider calls authService.login() (Service Layer)
// 4. Service creates User model and returns it (Model Layer)
// 5. Provider updates UI with new user data
// 6. Screen rebuilds showing "Welcome, User!"
```

## Key Concepts

### 1. Models - Data Structure

Models define what data looks like:

```dart
class User {
  final String id;
  final String username;
  final String email;
  // ... more fields
}

// Models have two important methods:
// - fromJson() - convert from API response
// - toJson() - convert for API request
```

### 2. Services - Business Logic

Services handle the actual work:

```dart
class AuthService {
  // Login logic - validates input, calls API, returns User
  Future<User> login({required String username, required String password})
  
  // Signup logic
  Future<User> signup({...})
  
  // Logout logic
  Future<void> logout()
}
```

**When to use services:**
- API calls
- Database queries
- Complex calculations
- File operations
- Secure storage

### 3. Providers - State Management

Providers manage app state using **ChangeNotifier** from Flutter:

```dart
class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters to access state
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  
  // Methods to change state
  Future<void> login(String username, String password) {
    _isLoading = true;
    notifyListeners(); // Tell UI to rebuild
    
    // ... call service ...
    
    _isLoading = false;
    notifyListeners(); // Tell UI to rebuild again
  }
}
```

**Why use providers?**
- Centralize app state
- Any widget can access state
- Automatic UI updates
- Easy to test

### 4. Screens - User Interface

Screens build the UI and connect to providers:

```dart
class LoginScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Column(
          children: [
            TextField(), // Username input
            TextField(), // Password input
            // Show loading or button
            authProvider.isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    authProvider.login(username, password);
                  },
                  child: Text('Login'),
                ),
            // Show error if exists
            if (authProvider.errorMessage != null)
              Text(authProvider.errorMessage!),
          ],
        );
      },
    );
  }
}
```

## OOP Concepts Used

### 1. **Inheritance** - Extending existing code

```dart
// Base class (parent)
class BaseService {
  void logInfo(String message) {
    print(message);
  }
}

// Child class inherits from parent
class AuthService extends BaseService {
  // Can use logInfo() method from BaseService
}
```

### 2. **Interfaces** - Contracts for implementation

```dart
// Interface (what methods must exist)
abstract class IAuthService {
  Future<User> login({required String username, required String password});
  Future<void> logout();
}

// Implementation (actual code)
class AuthService implements IAuthService {
  @override
  Future<User> login({required String username, required String password}) {
    // Real implementation
  }
}
```

### 3. **Polymorphism** - Multiple forms of same code

```dart
// One method works with different types
printError(AppException error) {
  if (error is AuthException) {
    print("Auth Error: ${error.message}");
  } else if (error is NetworkException) {
    print("Network Error: ${error.message}");
  }
}
```

### 4. **Encapsulation** - Hiding internal details

```dart
class User {
  // Private fields (can't access from outside)
  final String _password;
  
  // Public getter (read-only)
  bool get isPasswordSet => _password.isNotEmpty;
  
  // Private method (only used internally)
  bool _validatePassword(String pass) { ... }
}
```

## Exception Handling

The app has **custom exceptions** for different error types:

```dart
// For validation errors
throw ValidationException(message: 'Email is invalid');

// For authentication errors
throw AuthException(message: 'Invalid credentials');

// For network errors
throw NetworkException(message: 'No internet connection');

// Usage in try-catch
try {
  await login(username, password);
} on ValidationException catch (e) {
  print("Please check your input: ${e.message}");
} on AuthException catch (e) {
  print("Login failed: ${e.message}");
} catch (e) {
  print("Unexpected error: $e");
}
```

## Input Validation

Always validate user input before processing:

```dart
// Use built-in validators
String? emailError = InputValidator.validateEmail('user@example.com');
String? passwordError = InputValidator.validatePassword('pass123');

// Use in TextFormField
TextFormField(
  validator: (value) => InputValidator.validateEmail(value ?? ''),
)
```

## Configuration & Constants

Use `AppConfig` class instead of magic numbers:

```dart
// ❌ Bad - Magic numbers everywhere
const Duration timeout = Duration(seconds: 30);

// ✅ Good - Use configuration
const Duration timeout = AppConfig.apiTimeout;

// Benefits:
// - Easy to change globally
// - Self-documenting
// - Prevents typos
```

## Logging

Always log important events for debugging:

```dart
// In services
logInfo('User logged in');
logWarning('Token about to expire');
logError('API request failed', exception);

// In providers
logInfo('Loading menu items...');

// View logs in console during development
```

## Secure Storage

Never store sensitive data in plain text:

```dart
// ❌ Bad
final token = await storage.getString('token'); // Anyone can read!

// ✅ Good
final token = await secureStorage.getAuthToken(); // Encrypted!
```

## Testing Credentials

For development/testing:
- **Username**: `Rabbani`
- **Password**: `golam1234`

## Common Patterns

### Pattern 1: Loading Data with Error Handling

```dart
Future<void> loadData() async {
  try {
    setLoading(true);
    clearError();
    
    final data = await service.fetchData();
    _data = data;
    
  } on AppException catch (e) {
    handleException(e); // Sets error message
  } finally {
    setLoading(false);
  }
}
```

### Pattern 2: Handling Optional Data

```dart
// Use null-coalescing operator (??)
String name = user?.fullName ?? 'Unknown';

// Use null-conditional operator (?.)
user?.sendEmail();

// Use pattern matching
if (value case final int num when num > 0) {
  print('Positive number: $num');
}
```

### Pattern 3: Async Operations

```dart
// Using async/await (recommended)
final user = await authService.login(...);

// Using then() (older style - avoid)
authService.login(...).then((user) { ... });
```

## Best Practices

### 1. Always Validate Input
```dart
// Validate before processing
if (email.isEmpty) {
  setError('Email is required');
  return;
}
```

### 2. Handle Errors Gracefully
```dart
// Show user-friendly messages
try {
  await operation();
} on NetworkException {
  setError('No internet connection. Please try again.');
} on TimeoutException {
  setError('Request timed out. Please try again.');
} catch (e) {
  setError('An unexpected error occurred');
}
```

### 3. Use Type Safety
```dart
// ❌ Dynamic typing - risky
var user = fetchUser();

// ✅ Explicit typing - safe
User user = await fetchUser();
```

### 4. Write Self-Documenting Code
```dart
// ❌ Unclear
Future<bool> f(String u, String p) => ...

// ✅ Clear
Future<User> login({
  required String username,
  required String password,
}) => ...
```

### 5. Keep Functions Small
```dart
// ❌ Too much in one function (50+ lines)
Future<void> handleComplexOperation() { ... }

// ✅ Break into smaller functions
Future<void> main() async {
  await step1();
  await step2();
  await step3();
}
```

## Running the App

```bash
# Get dependencies
flutter pub get

# Run on emulator/device
flutter run

# Run in release mode (faster)
flutter run --release

# Run with logging
flutter run --verbose
```

## Debugging

### View Logs
```bash
# All logs
flutter logs

# Filter by tag
flutter logs -t MyApp
```

### Use Debugger
```dart
// Add breakpoint - click line number in VS Code
// App will pause at this line when running in debug mode
```

### Print Debugging
```dart
// Quick debug output
print('Debug: $variable');

// Better - use logger
AppLogger.info('User: ${user.username}');
```

## Common Issues & Solutions

### Issue: "Provider not found"
```
Error: Could not find the correct Provider<...>
```
**Solution**: Wrap with MultiProvider in main.dart
```dart
MultiProvider(
  providers: [
    Provider<AuthService>(...),
    ChangeNotifierProvider<AuthProvider>(...),
  ],
  child: MyApp(),
)
```

### Issue: "No internet connection"
**Solution**: Check network connectivity
```dart
// Use connectivity_plus package
final status = await connectivity.checkConnectivity();
if (status == ConnectivityResult.none) {
  setError('No internet connection');
}
```

### Issue: "Token expired"
**Solution**: Implement auto-refresh
```dart
if (isTokenExpired()) {
  final newToken = await refreshToken();
  if (newToken == null) {
    // Show login screen
  }
}
```

## Next Steps

1. **Read the Code**: Open files and understand the flow
2. **Make Small Changes**: Try modifying UI or constants
3. **Add Features**: Build on existing code
4. **Test**: Try different inputs and edge cases
5. **Deploy**: When ready, build for production

## Resources

- [Flutter Docs](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Provider Package](https://pub.dev/packages/provider)
- [Material Design](https://material.io/design)

## Contact

For questions or issues, refer to the code comments and this guide!
