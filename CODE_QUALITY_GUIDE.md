># Code Quality & Best Practices Checklist

## Code Quality Principles

This guide helps you write code that is:
- ✅ **Readable** - Others can understand it easily
- ✅ **Maintainable** - Easy to modify and fix
- ✅ **Testable** - Easy to test
- ✅ **Performant** - Runs efficiently
- ✅ **Secure** - Protects user data

## Before Submitting Code

### 1. Code Readability Checklist

- [ ] **Clear naming**
  ```dart
  // ❌ Bad
  var x = get_d();
  
  // ✅ Good
  var userData = getUserData();
  ```

- [ ] **Comments for complex logic**
  ```dart
  // ✅ Explain WHY, not WHAT (code already shows what)
  // Skip users without email to avoid notification errors
  final validUsers = users.where((u) => u.email != null);
  ```

- [ ] **DRY (Don't Repeat Yourself)**
  ```dart
  // ❌ Bad - code repeated
  authService.login(...);
  // ... 10 lines ...
  menuService.initialize();
  
  authService.logout();
  // ... 10 lines ...
  menuService.dispose();
  
  // ✅ Good - create helper
  Future<void> setupServices() {
    authService.login(...);
    menuService.initialize();
  }
  ```

- [ ] **Short functions** (aim for <50 lines)
  ```dart
  // ❌ Bad - 100+ lines
  Future<void> processComplexOperation() { ... }
  
  // ✅ Good - breaks into steps
  Future<void> main() async {
    await step1();
    await step2();
    await step3();
  }
  ```

- [ ] **Descriptive variable names**
  ```dart
  // ❌ Bad
  final u = user;
  final p = price;
  
  // ✅ Good
  final currentUser = user;
  final totalPrice = price;
  ```

### 2. Error Handling Checklist

- [ ] **Always catch exceptions**
  ```dart
  // ❌ Bad - crashes if error
  await authService.login();
  
  // ✅ Good - handles error
  try {
    await authService.login();
  } on AuthException catch (e) {
    handleError(e);
  } catch (e) {
    handleUnexpectedError(e);
  }
  ```

- [ ] **No silent failures**
  ```dart
  // ❌ Bad - ignores errors
  try {
    await save();
  } catch (e) {}
  
  // ✅ Good - handles errors
  try {
    await save();
  } catch (e) {
    logError('Save failed', e);
    showErrorDialog('Could not save');
  }
  ```

- [ ] **Specific exception types**
  ```dart
  // ❌ Bad - too generic
  } catch (e) {
    showError('Error occurred');
  }
  
  // ✅ Good - specific handling
  } on ValidationException {
    showError('Check your input');
  } on NetworkException {
    showError('Network error - check connection');
  }
  ```

### 3. Null Safety Checklist

- [ ] **Use null-aware operators**
  ```dart
  // ❌ Bad - might crash
  String name = user.name;
  
  // ✅ Good - handles null
  String name = user?.name ?? 'Unknown';
  ```

- [ ] **Null coalescing operator**
  ```dart
  // ❌ Bad
  String? city = user.address?.city;
  if (city == null) city = 'Unknown';
  
  // ✅ Good
  String city = user.address?.city ?? 'Unknown';
  ```

- [ ] **Type checking**
  ```dart
  // ❌ Bad - might throw
  var item = list[0]; // What if list is empty?
  
  // ✅ Good - safe
  final item = list.isNotEmpty ? list[0] : null;
  ```

### 4. Performance Checklist

- [ ] **Avoid rebuilds**
  ```dart
  // ❌ Bad - rebuilds everything
  Consumer<AuthProvider>(
    builder: (context, auth, _) {
      return Column(
        children: [
          ExpensiveWidget(),  // Rebuilds even if auth unchanged
          Text(auth.username),
        ],
      );
    },
  );
  
  // ✅ Good - only rebuilds what changed
  Consumer<AuthProvider>(
    builder: (context, auth, child) {
      return Column(
        children: [
          child!,  // Only parent rebuilds
          Text(auth.username),
        ],
      );
    },
    child: ExpensiveWidget(),
  );
  ```

- [ ] **Use const where possible**
  ```dart
  // ❌ Bad - creates new object every build
  Widget build(BuildContext context) {
    return Text(
      'Hello',
      style: TextStyle(fontSize: 16),
    );
  }
  
  // ✅ Good - reuses const
  const _helloStyle = TextStyle(fontSize: 16);
  
  Widget build(BuildContext context) {
    return Text(
      'Hello',
      style: _helloStyle,
    );
  }
  ```

- [ ] **Lazy initialization**
  ```dart
  // ❌ Bad - loads everything immediately
  class Service {
    final data = loadExpensiveData();
  }
  
  // ✅ Good - loads only when needed
  class Service {
    late final data = loadExpensiveData();
  }
  ```

- [ ] **Avoid infinite loops**
  ```dart
  // ❌ Bad - infinite loop
  Stream<Data> watchData() {
    return Stream.fromFuture(fetchData()); // Creates new stream endlessly
  }
  
  // ✅ Good - finite stream
  Stream<Data> watchData() {
    return Stream.periodic(Duration(seconds: 10), (_) => fetchData())
      .asyncExpand((future) => Stream.fromFuture(future));
  }
  ```

### 5. Testing Checklist

- [ ] **Write testable code**
  ```dart
  // ❌ Bad - hard to test
  class LoginScreen {
    final authService = AuthService(); // Can't replace with mock
  }
  
  // ✅ Good - easy to test
  class LoginScreen {
    final IAuthService authService;
    
    LoginScreen(this.authService);
  }
  ```

- [ ] **Use dependency injection**
  ```dart
  // ✅ Good - can test with mock
  final authProvider = AuthProvider(MockAuthService());
  final authProvider = AuthProvider(RealAuthService());
  ```

- [ ] **Mock external dependencies**
  ```dart
  class MockAuthService implements IAuthService {
    @override
    Future<User> login(...) async {
      return User(id: '1', username: 'test');
    }
  }
  ```

### 6. Documentation Checklist

- [ ] **Document public methods**
  ```dart
  // ✅ Clear documentation
  /// Login user with username and password
  /// 
  /// Returns authenticated user if successful
  /// Throws [AuthException] if credentials invalid
  /// Throws [NetworkException] if network fails
  Future<User> login({
    required String username,
    required String password,
  }) async { ... }
  ```

- [ ] **Document parameters**
  ```dart
  // ✅ Document each parameter
  /// Search for menu items
  /// 
  /// [query] - Search term (searches name and description)
  /// [category] - Optional category filter
  /// [limit] - Maximum results to return (default: 20)
  Future<List<MenuItem>> search({
    required String query,
    String? category,
    int limit = 20,
  }) async { ... }
  ```

- [ ] **Document exceptions**
  ```dart
  // ✅ Document what can be thrown
  /// Places an order
  /// 
  /// Throws [ValidationException] if order data invalid
  /// Throws [NetworkException] if API request fails
  /// Throws [BusinessException] if order rules violated
  Future<Order> placeOrder(OrderData data) async { ... }
  ```

### 7. Security Checklist

- [ ] **No hardcoded credentials**
  ```dart
  // ❌ Bad
  const String apiKey = 'sk_live_abc123';
  
  // ✅ Good - use environment
  final apiKey = String.fromEnvironment('API_KEY');
  ```

- [ ] **No sensitive data in logs**
  ```dart
  // ❌ Bad
  logInfo('Logging in user: $email with password: $password');
  
  // ✅ Good
  logInfo('Logging in user: $email');
  ```

- [ ] **Secure storage for tokens**
  ```dart
  // ❌ Bad
  prefs.setString('token', token);
  
  // ✅ Good
  secureStorage.saveAuthToken(token);
  ```

- [ ] **Validate all input**
  ```dart
  // ❌ Bad
  Future<void> create(String email) {
    saveToDatabase(email);
  }
  
  // ✅ Good
  Future<void> create(String email) {
    if (InputValidator.validateEmail(email) != null) {
      throw ValidationException(message: 'Invalid email');
    }
    saveToDatabase(email);
  }
  ```

### 8. Code Style Checklist

- [ ] **Follow Dart conventions**
  ```dart
  // ✅ Good style
  class UserModel {
    final String id;
    final String username;
    
    UserModel({
      required this.id,
      required this.username,
    });
  }
  ```

- [ ] **Use proper imports**
  ```dart
  // ✅ Good - organized
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  
  import '../models/user.dart';
  import '../services/auth.dart';
  ```

- [ ] **Format code properly**
  ```bash
  # Format code
  flutter format lib/
  
  # Or in VS Code
  Shift + Alt + F
  ```

- [ ] **Fix lint warnings**
  ```bash
  # Check for issues
  flutter analyze
  ```

## Code Review Checklist

When reviewing code, check:

- [ ] Is it readable and understandable?
- [ ] Are there any obvious bugs?
- [ ] Is error handling adequate?
- [ ] Are inputs validated?
- [ ] Is performance reasonable?
- [ ] Does it follow OOP principles?
- [ ] Is it well-documented?
- [ ] Are there any security issues?
- [ ] Does it pass tests?
- [ ] Could it be simpler?

## Refactoring Guide

When to refactor:

- [ ] **Method too long** (>50 lines) → Split into smaller methods
- [ ] **Duplicate code** (appears 3+ times) → Extract to common method
- [ ] **Complex conditions** → Extract to named boolean method
- [ ] **Too many parameters** → Create model class
- [ ] **God object** → Split into separate classes
- [ ] **Hard to test** → Inject dependencies
- [ ] **Poor naming** → Rename clearly
- [ ] **Deep nesting** → Flatten with early returns

## Example Refactoring

### Before (Bad)

```dart
Future<bool> processOrder(String id, double price, String address, 
    String paymentMethod, String cardNumber, String cvv, 
    String expiryDate) async {
  if (id.isEmpty || price <= 0 || address.isEmpty || 
      paymentMethod.isEmpty) {
    return false;
  }
  
  if (paymentMethod == 'card') {
    if (cardNumber.isEmpty || cvv.isEmpty || expiryDate.isEmpty) {
      return false;
    }
    try {
      final response = await http.post(
        Uri.parse('https://api.eatery.local/orders'),
        body: jsonEncode({
          'id': id,
          'price': price,
          'address': address,
          'paymentMethod': paymentMethod,
          'card': {'number': cardNumber, 'cvv': cvv, 'expiry': expiryDate},
        }),
      );
      
      if (response.statusCode == 200) {
        final order = Order.fromJson(jsonDecode(response.body));
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
  
  return false;
}
```

### After (Good)

```dart
// 1. Create data models
class OrderRequest {
  final String id;
  final double price;
  final String address;
  final PaymentInfo payment;
  
  OrderRequest({...});
  
  // Validation in model
  String? validate() {
    if (id.isEmpty) return 'Order ID required';
    if (price <= 0) return 'Invalid price';
    if (address.isEmpty) return 'Address required';
    if (!payment.isValid()) return 'Invalid payment';
    return null;
  }
}

// 2. Create separate payment handler
abstract class PaymentProcessor {
  Future<bool> process(PaymentInfo payment, double amount);
}

class CardPaymentProcessor extends PaymentProcessor {
  @override
  Future<bool> process(PaymentInfo payment, double amount) {
    // Handle card payment
  }
}

// 3. Extract to service
class OrderService {
  final OrderRepository repository;
  final PaymentProcessor paymentProcessor;
  
  OrderService(this.repository, this.paymentProcessor);
  
  /// Place new order
  /// 
  /// Throws [ValidationException] if order invalid
  /// Throws [PaymentException] if payment fails
  Future<Order> placeOrder(OrderRequest order) async {
    // Validate
    final error = order.validate();
    if (error != null) {
      throw ValidationException(message: error);
    }
    
    // Process payment
    final paymentSuccess = await paymentProcessor.process(
      order.payment,
      order.price,
    );
    if (!paymentSuccess) {
      throw PaymentException(message: 'Payment failed');
    }
    
    // Save order
    return await repository.createOrder(order);
  }
}

// 4. Usage is now simple
final order = OrderRequest(...);
final result = await orderService.placeOrder(order);
```

## Performance Optimization Checklist

- [ ] Use `const` constructors
- [ ] Use `const` widgets in static UI
- [ ] Cache expensive computations
- [ ] Use lazy initialization (late final)
- [ ] Avoid rebuilding entire widget tree
- [ ] Use `SliverList` for long lists
- [ ] Use `ListView.builder` for dynamic lists
- [ ] Avoid calculations in build method
- [ ] Use `RepaintBoundary` for complex widgets
- [ ] Profile with DevTools

## Memory Optimization

- [ ] Dispose resources in dispose()
- [ ] Cancel streams and subscriptions
- [ ] Clear large collections
- [ ] Use weak references where appropriate
- [ ] Monitor memory with DevTools

## Common Code Smells

**Smell: Duplicate Code**
- **Fix**: Extract to common method/widget

**Smell: Long Methods**
- **Fix**: Break into smaller, focused methods

**Smell: Large Classes**
- **Fix**: Split into multiple classes (SRP)

**Smell: Many Parameters**
- **Fix**: Create model class to hold related parameters

**Smell: Unclear Names**
- **Fix**: Rename to clearly express intent

**Smell: Deep Nesting**
- **Fix**: Extract methods, use early returns

**Smell: Magic Numbers**
- **Fix**: Create named constants

**Smell: No Error Handling**
- **Fix**: Add try-catch with proper error handling

## Summary

✅ **Write code for humans, not machines**
✅ **Make it readable first, fast second**
✅ **Handle errors gracefully**
✅ **Validate all input**
✅ **Secure sensitive data**
✅ **Test your code**
✅ **Document clearly**
✅ **Keep it simple**

**Remember:** Code is read 10x more often than it's written!
