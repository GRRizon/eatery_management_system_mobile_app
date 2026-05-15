/// Input validation utility for the Eatery Management System
///
/// This file provides a collection of validation functions for common input types.
/// All functions return null if validation passes, or an error message if it fails.
///
/// This follows the common Dart validation pattern where null means valid.
///
/// Example usage:
/// ```dart
/// String? error = InputValidator.validateEmail('user@example.com');
/// if (error == null) {
///   // Email is valid
/// } else {
///   // Show error message
///   print(error); // 'Invalid email format'
/// }
///
/// // Or use with text field
/// TextFormField(
///   validator: (value) => InputValidator.validateEmail(value ?? ''),
/// )
/// ```
library;

class InputValidator {
  // Private constructor to prevent instantiation
  InputValidator._();

  // ==================== Common Patterns ====================

  /// Validate email format
  ///
  /// Checks for:
  /// - Non-empty
  /// - Contains @ symbol
  /// - Has domain after @
  /// - Valid TLD
  ///
  /// Returns error message or null if valid
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    email = email.trim();

    // Regex pattern for email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password strength
  ///
  /// Checks for:
  /// - Minimum 6 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one digit
  /// - At least one special character (!@#$%^&*)
  ///
  /// Returns error message or null if valid
  ///
  /// Note: For real apps, consider using a password strength package
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain an uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain a lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain a number';
    }

    return null;
  }

  /// Validate password match
  ///
  /// Checks if two password strings are identical
  ///
  /// Returns error message or null if valid
  static String? validatePasswordMatch(
    String? password,
    String? confirmPassword,
  ) {
    if (password == null || confirmPassword == null) {
      return 'Both password fields are required';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  // ==================== Username/Name ====================

  /// Validate username
  ///
  /// Checks for:
  /// - Non-empty
  /// - Minimum 3 characters
  /// - Only alphanumeric and underscore
  ///
  /// Returns error message or null if valid
  static String? validateUsername(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username is required';
    }

    username = username.trim();

    if (username.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (username.length > 20) {
      return 'Username must be at most 20 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      return 'Username can only contain letters, numbers, and underscore';
    }

    return null;
  }

  /// Validate full name
  ///
  /// Checks for:
  /// - Non-empty
  /// - Minimum 2 characters
  /// - Only letters and spaces
  ///
  /// Returns error message or null if valid
  static String? validateFullName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Full name is required';
    }

    name = name.trim();

    if (name.length < 2) {
      return 'Full name must be at least 2 characters';
    }

    if (name.length > 50) {
      return 'Full name must be at most 50 characters';
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return 'Full name can only contain letters and spaces';
    }

    return null;
  }

  // ==================== Phone ====================

  /// Validate phone number
  ///
  /// Checks for:
  /// - Non-empty
  /// - Valid format (starts with + or digit)
  /// - 10-15 digits total
  ///
  /// Returns error message or null if valid
  ///
  /// Note: Adjust pattern for your country's phone format
  static String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Phone number is required';
    }

    phone = phone.replaceAll(RegExp(r'[^\d+]'), '');

    if (phone.length < 10 || phone.length > 15) {
      return 'Phone number must be between 10 and 15 digits';
    }

    if (!RegExp(r'^[\d+]+$').hasMatch(phone)) {
      return 'Phone number can only contain digits and + symbol';
    }

    return null;
  }

  // ==================== Address ====================

  /// Validate street address
  ///
  /// Checks for:
  /// - Non-empty
  /// - Minimum 5 characters
  ///
  /// Returns error message or null if valid
  static String? validateStreetAddress(String? address) {
    if (address == null || address.isEmpty) {
      return 'Street address is required';
    }

    address = address.trim();

    if (address.length < 5) {
      return 'Street address must be at least 5 characters';
    }

    if (address.length > 100) {
      return 'Street address must be at most 100 characters';
    }

    return null;
  }

  /// Validate city name
  ///
  /// Checks for:
  /// - Non-empty
  /// - Minimum 2 characters
  /// - Only letters and spaces
  ///
  /// Returns error message or null if valid
  static String? validateCity(String? city) {
    if (city == null || city.isEmpty) {
      return 'City is required';
    }

    city = city.trim();

    if (city.length < 2) {
      return 'City must be at least 2 characters';
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(city)) {
      return 'City can only contain letters and spaces';
    }

    return null;
  }

  /// Validate postal/ZIP code
  ///
  /// Checks for:
  /// - Non-empty
  /// - Valid format (5-10 characters, alphanumeric)
  ///
  /// Returns error message or null if valid
  ///
  /// Note: Adjust pattern for your country's ZIP format
  static String? validateZipCode(String? zipCode) {
    if (zipCode == null || zipCode.isEmpty) {
      return 'ZIP code is required';
    }

    zipCode = zipCode.trim().replaceAll('-', '');

    if (zipCode.length < 5 || zipCode.length > 10) {
      return 'ZIP code must be between 5 and 10 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(zipCode)) {
      return 'ZIP code can only contain letters and numbers';
    }

    return null;
  }

  // ==================== Credit Card ====================

  /// Validate credit card number using Luhn algorithm
  ///
  /// Checks for:
  /// - Valid Luhn checksum
  /// - Correct card length (13-19 digits)
  ///
  /// Returns error message or null if valid
  static String? validateCreditCard(String? cardNumber) {
    if (cardNumber == null || cardNumber.isEmpty) {
      return 'Card number is required';
    }

    cardNumber = cardNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return 'Card number must be between 13 and 19 digits';
    }

    if (!_luhnCheck(cardNumber)) {
      return 'Invalid card number';
    }

    return null;
  }

  /// Validate credit card expiry date
  ///
  /// Format: MM/YY or MM-YY
  ///
  /// Returns error message or null if valid
  static String? validateCreditCardExpiry(String? expiry) {
    if (expiry == null || expiry.isEmpty) {
      return 'Expiry date is required';
    }

    expiry = expiry.replaceAll(RegExp(r'[^\d/]'), '');

    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(expiry)) {
      return 'Expiry date must be in MM/YY format';
    }

    final parts = expiry.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    final year = int.tryParse(parts[1]) ?? 0;

    if (month < 1 || month > 12) {
      return 'Month must be between 01 and 12';
    }

    // Check if card is expired
    final currentYear = DateTime.now().year % 100;
    final currentMonth = DateTime.now().month;

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Card has expired';
    }

    return null;
  }

  /// Validate credit card CVV
  ///
  /// Checks for:
  /// - 3 or 4 digits
  ///
  /// Returns error message or null if valid
  static String? validateCreditCardCVV(String? cvv) {
    if (cvv == null || cvv.isEmpty) {
      return 'CVV is required';
    }

    cvv = cvv.replaceAll(RegExp(r'[^\d]'), '');

    if (cvv.length != 3 && cvv.length != 4) {
      return 'CVV must be 3 or 4 digits';
    }

    return null;
  }

  // ==================== General ====================

  /// Validate non-empty string
  ///
  /// Checks for:
  /// - Non-empty after trimming
  ///
  /// Returns error message or null if valid
  static String? validateRequired(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate numeric value
  ///
  /// Checks if string contains only digits
  ///
  /// Returns error message or null if valid
  static String? validateNumeric(
    String? value, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return '$fieldName must contain only numbers';
    }

    return null;
  }

  /// Validate minimum length
  ///
  /// Returns error message or null if valid
  static String? validateMinLength(
    String? value,
    int minLength, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    return null;
  }

  /// Validate maximum length
  ///
  /// Returns error message or null if valid
  static String? validateMaxLength(
    String? value,
    int maxLength, {
    String fieldName = 'This field',
  }) {
    if (value == null) {
      return null;
    }

    if (value.length > maxLength) {
      return '$fieldName must be at most $maxLength characters';
    }

    return null;
  }

  // ==================== Helper Methods ====================

  /// Luhn algorithm for credit card validation
  /// Used by validateCreditCard
  static bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool isEven = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      isEven = !isEven;
    }

    return sum % 10 == 0;
  }
}
