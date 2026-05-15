# Object-Oriented Programming (OOP) Guide for This Project

## What is OOP?

OOP is a way to organize code by thinking of real-world objects and their interactions.

**Real-World Example:**
```
Car object has:
- Properties: color, brand, speed
- Methods: accelerate(), brake(), turn()

AuthService object has:
- Properties: currentUser, authToken
- Methods: login(), signup(), logout()
```

## OOP Pillars (4 Concepts)

### 1. **Encapsulation** - Hide Details, Show Interface

**Idea:** Hide how things work inside, only expose what's needed.

**Real World:** 
- Car's engine is hidden under the hood
- You just press pedals and turn steering wheel
- You don't need to know how spark plugs work

**Code Example:**

```dart
class User {
  // Private fields (hidden from outside)
  final String _password;
  final String _email;
  
  // Public getters (only reading allowed)
  String get email => _email;
  
  // Private method (only used internally)
  bool _validateEmail(String email) {
    return email.contains('@');
  }
  
  // Public method (used from outside)
  bool isEmailValid() {
    return _validateEmail(_email);
  }
}

// Usage
final user = User(...);
print(user.email); // ✅ Can read
print(user._password); // ❌ Can't access private field
user._validateEmail('test'); // ❌ Can't call private method
```

**Benefits:**
- ✅ Prevents accidental changes
- ✅ Easy to modify internals later
- ✅ Clearer what's safe to use

### 2. **Abstraction** - Define What, Not How

**Idea:** Define interface (what to do), hide implementation (how to do it).

**Real World:**
- You know to use a door: pull or push
- You don't know the mechanism inside

**Code Example:**

```dart
// Abstract interface - says WHAT should exist
abstract class IAuthService {
  Future<User> login({required String username, required String password});
  Future<void> logout();
}

// Implementation 1 - HOW to do it with database
class DatabaseAuthService implements IAuthService {
  @override
  Future<User> login({required String username, required String password}) {
    // Query database
    return User(...);
  }
}

// Implementation 2 - HOW to do it with API
class ApiAuthService implements IAuthService {
  @override
  Future<User> login({required String username, required String password}) {
    // Call API
    return User(...);
  }
}

// Implementation 3 - HOW to do it with mocks (for testing)
class MockAuthService implements IAuthService {
  @override
  Future<User> login({required String username, required String password}) {
    // Return fake user
    return User(...);
  }
}

// Code using this - doesn't care HOW login works
Future<void> authenticate(IAuthService authService) {
  final user = await authService.login(username: 'user', password: 'pass');
  // Works with any implementation!
}
```

**Benefits:**
- ✅ Easy to swap implementations
- ✅ Easy to test (use MockAuthService)
- ✅ Focuses on what matters, not details

### 3. **Inheritance** - Reuse Code

**Idea:** Create a parent class with common code, children extend it.

**Real World:**
- Animal class has: eat(), sleep()
- Dog extends Animal (gets eat(), sleep() for free)
- Dog adds: bark()

**Code Example:**

```dart
// Parent class - common functionality
class BaseService {
  void logInfo(String message) {
    print('[INFO] $message');
  }
  
  void logError(String message, dynamic error) {
    print('[ERROR] $message: $error');
  }
}

// Child class - inherits logging
class AuthService extends BaseService {
  Future<User> login(...) {
    logInfo('Login attempt'); // Inherited method!
    try {
      // ... login code ...
    } catch (e) {
      logError('Login failed', e); // Inherited method!
    }
  }
}

// Another child class - also inherits logging
class MenuService extends BaseService {
  Future<List<MenuItem>> getItems() {
    logInfo('Fetching menu items'); // Same inherited method!
    // ... fetch code ...
  }
}
```

**Benefits:**
- ✅ Write code once, use many times
- ✅ Common functionality in one place
- ✅ Easy to update all services at once

**Avoid:** Don't inherit just to reuse one method. Use composition instead:

```dart
// ❌ Wrong inheritance
class EmailService extends BaseService { ... }

// ✅ Right composition
class EmailService {
  final Logger logger = Logger();
  
  void send(...) {
    logger.info('Sending email');
  }
}
```

### 4. **Polymorphism** - Same Name, Different Behavior

**Idea:** Same method name, different implementations depending on object type.

**Real World:**
- Shape.draw() - works for Circle, Square, Triangle
- Each draws differently, but same method name

**Code Example:**

```dart
// Base class
abstract class PaymentMethod {
  Future<void> pay(double amount);
}

// Different implementations
class CardPayment extends PaymentMethod {
  @override
  Future<void> pay(double amount) {
    // Process card payment
    print('Processing card payment: $amount');
  }
}

class CashPayment extends PaymentMethod {
  @override
  Future<void> pay(double amount) {
    // Process cash payment
    print('Cash payment: $amount');
  }
}

class WalletPayment extends PaymentMethod {
  @override
  Future<void> pay(double amount) {
    // Process wallet payment
    print('Wallet payment: $amount');
  }
}

// Polymorphism - same method, different behavior
void processPayment(PaymentMethod payment, double amount) {
  payment.pay(amount); // Calls correct implementation!
}

// Usage
processPayment(CardPayment(), 50);    // Output: "Processing card payment: 50"
processPayment(CashPayment(), 50);    // Output: "Cash payment: 50"
processPayment(WalletPayment(), 50);  // Output: "Wallet payment: 50"
```

**Benefits:**
- ✅ Write general code
- ✅ Easily add new types (new payment method)
- ✅ No need to change existing code

## Architecture Patterns

### SOLID Principles

#### S - Single Responsibility
**Each class does ONE thing well**

```dart
// ❌ WRONG - AuthService does too much
class AuthService {
  Future<void> login(...) { ... }
  Future<void> storeToken(...) { ... }
  Future<void> logAnalytics(...) { ... }
  Future<void> sendNotification(...) { ... }
}

// ✅ RIGHT - Each class has one responsibility
class AuthService {
  Future<User> login(...) { ... }
}

class SecureStorageService {
  Future<void> saveToken(...) { ... }
}

class AnalyticsService {
  void logEvent(String event) { ... }
}

class NotificationService {
  void send(String message) { ... }
}
```

#### O - Open/Closed
**Open for extension, closed for modification**

```dart
// ❌ WRONG - Must modify to add new feature
if (paymentType == 'card') {
  processCard(...);
} else if (paymentType == 'cash') {
  processCash(...);
} else if (paymentType == 'wallet') { // Must add here every time!
  processWallet(...);
}

// ✅ RIGHT - Just add new class
abstract class PaymentProcessor {
  Future<void> process(double amount);
}

class CardProcessor extends PaymentProcessor {
  Future<void> process(double amount) { ... }
}

class CashProcessor extends PaymentProcessor {
  Future<void> process(double amount) { ... }
}

class WalletProcessor extends PaymentProcessor {
  Future<void> process(double amount) { ... }
}

// Same code works for new payment types!
Future<void> pay(PaymentProcessor processor, double amount) {
  processor.process(amount);
}
```

#### L - Liskov Substitution
**Child can replace parent without breaking code**

```dart
// ❌ WRONG - Circle doesn't fit interface
abstract class Shape {
  void setWidth(double w);
  void setHeight(double h);
  double getArea();
}

class Circle extends Shape { // ❌ Circle doesn't have width/height!
  @override
  void setWidth(double w) { throw UnimplementedError(); }
  @override
  void setHeight(double h) { throw UnimplementedError(); }
}

// ✅ RIGHT - Proper interface
abstract class Shape {
  double getArea();
}

class Circle extends Shape {
  final double radius;
  
  @override
  double getArea() => 3.14 * radius * radius;
}

class Rectangle extends Shape {
  final double width, height;
  
  @override
  double getArea() => width * height;
}
```

#### I - Interface Segregation
**Many small interfaces, not one big one**

```dart
// ❌ WRONG - One fat interface
abstract class Vehicle {
  void drive();
  void fly();
  void swim();
}

class Car implements Vehicle {
  @override
  void drive() { ... }
  @override
  void fly() { throw UnimplementedError(); } // Doesn't make sense!
  @override
  void swim() { throw UnimplementedError(); } // Doesn't make sense!
}

// ✅ RIGHT - Separate interfaces
abstract class Drivable {
  void drive();
}

abstract class Flyable {
  void fly();
}

abstract class Swimmable {
  void swim();
}

class Car implements Drivable {
  @override
  void drive() { ... }
}

class Airplane implements Drivable, Flyable {
  @override
  void drive() { ... }
  @override
  void fly() { ... }
}

class Boat implements Swimmable {
  @override
  void swim() { ... }
}
```

#### D - Dependency Inversion
**Depend on abstractions, not concrete classes**

```dart
// ❌ WRONG - Depends on concrete class
class AuthProvider {
  final AuthService authService = AuthService(); // Tightly coupled!
  
  Future<void> login(...) {
    authService.login(...);
  }
}

// ✅ RIGHT - Depends on interface
class AuthProvider {
  final IAuthService authService; // Can be any implementation
  
  AuthProvider(this.authService);
  
  Future<void> login(...) {
    authService.login(...);
  }
}

// Usage - easy to swap implementations
final authProvider = AuthProvider(RealAuthService());
final testAuthProvider = AuthProvider(MockAuthService());
```

## Design Patterns Used

### 1. **Singleton** - Only One Instance

```dart
class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  
  factory AppDatabase() {
    return _instance;
  }
  
  AppDatabase._internal();
}

// Always same instance
final db1 = AppDatabase();
final db2 = AppDatabase();
assert(identical(db1, db2)); // ✅ Same object!
```

### 2. **Factory** - Create Objects

```dart
abstract class Logger {
  void log(String message);
  
  // Factory
  factory Logger(String type) {
    if (type == 'console') {
      return ConsoleLogger();
    } else if (type == 'file') {
      return FileLogger();
    } else {
      return ConsoleLogger(); // Default
    }
  }
}

// Usage
Logger logger = Logger('console'); // Returns ConsoleLogger
Logger logger = Logger('file');    // Returns FileLogger
```

### 3. **Provider** - Share State

```dart
// Widget can access provider state
Consumer<AuthProvider>(
  builder: (context, authProvider, _) {
    if (authProvider.isLoading) {
      return CircularProgressIndicator();
    }
    return Text('User: ${authProvider.currentUser?.name}');
  },
)
```

### 4. **Repository** - Abstraction Over Data

```dart
// Interface
abstract class UserRepository {
  Future<User?> getUser(String id);
  Future<void> saveUser(User user);
}

// Implementation - local storage
class LocalUserRepository implements UserRepository {
  @override
  Future<User?> getUser(String id) {
    // Get from local database
  }
}

// Implementation - remote API
class RemoteUserRepository implements UserRepository {
  @override
  Future<User?> getUser(String id) {
    // Get from API
  }
}

// Usage - doesn't matter where data comes from
Future<void> showUser(UserRepository repo) {
  final user = await repo.getUser('123');
  print(user);
}
```

## Code Organization in This Project

```
Core OOP Principles Applied:
├── Encapsulation
│   └── Private fields (_password, _token)
│   └── Public getters (currentUser, isLoading)
│
├── Abstraction
│   └── Interfaces (IAuthService, IMenuService)
│   └── Base classes (BaseService, BaseProvider)
│
├── Inheritance
│   └── AuthService extends BaseService
│   └── MenuService extends BaseService
│   └── AuthProvider extends BaseProvider
│
└── Polymorphism
    └── Multiple service implementations
    └── Different providers acting as state managers
```

## Common Mistakes to Avoid

### ❌ Mistake 1: Not Using Interfaces

```dart
// WRONG - Hard to test
class Widget {
  final AuthService auth = AuthService();
}

// RIGHT - Easy to test
class Widget {
  final IAuthService auth;
  
  Widget(this.auth);
}
```

### ❌ Mistake 2: God Objects

```dart
// WRONG - One class does everything
class App {
  void login() { ... }
  void fetchMenu() { ... }
  void placeOrder() { ... }
  void sendNotification() { ... }
  void logAnalytics() { ... }
}

// RIGHT - Each class does one thing
class AuthService { void login() { ... } }
class MenuService { void fetchMenu() { ... } }
class OrderService { void placeOrder() { ... } }
class NotificationService { void send() { ... } }
class AnalyticsService { void log() { ... } }
```

### ❌ Mistake 3: Over-Engineering

```dart
// WRONG - Too many layers for simple task
interface -> abstract class -> mixin -> service -> repository -> cache

// RIGHT - Simple when possible
simple function or class
```

## Summary

**OOP Benefits in This Project:**

✅ **Reusable** - Base classes provide common functionality
✅ **Testable** - Interfaces allow mocking
✅ **Maintainable** - Single responsibility principle
✅ **Extensible** - Easy to add new features
✅ **Secure** - Encapsulation hides sensitive data
✅ **Professional** - Industry-standard practices

**Remember:** OOP is about organizing code to match real-world concepts and making code easier to understand, test, and maintain!
