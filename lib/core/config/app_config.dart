/// Comprehensive application configuration and constants
///
/// This file centralizes all application configuration values.
/// Organized by category for easy navigation and maintenance.
///
/// Instead of scattering magic strings and numbers throughout the code,
/// define them here and import as needed.
///
/// Example usage:
/// ```dart
/// import 'config/app_config.dart';
///
/// // Use constants
/// Text('Amount: ${AppConfig.currencySymbol} $amount')
///
/// // With timeouts
/// timeout: AppConfig.apiTimeout,
/// ```
library;

/// Main application configuration
class AppConfig {
  AppConfig._(); // Private constructor to prevent instantiation

  // ==================== App Information ====================

  /// Application name
  static const String appName = 'Eatery Management System';

  /// Application version (follows semantic versioning: Major.Minor.Patch)
  static const String appVersion = '1.0.0';

  /// Build number for tracking releases
  static const int buildNumber = 1;

  // ==================== API Configuration ====================

  /// Base URL for API requests
  /// In production, use environment-specific URLs
  static const String apiBaseUrl = 'https://api.eatery.local/v1';

  /// API request timeout duration
  static const Duration apiTimeout = Duration(seconds: 30);

  /// API connection timeout
  static const Duration connectionTimeout = Duration(seconds: 15);

  /// Maximum retry attempts for failed requests
  static const int maxRetryAttempts = 3;

  /// Delay between retry attempts
  static const Duration retryDelay = Duration(seconds: 2);

  // ==================== Authentication ====================

  /// Token expiry duration (in hours)
  static const int tokenExpiryHours = 24;

  /// Refresh token expiry duration (in days)
  static const int refreshTokenExpiryDays = 30;

  /// Session timeout duration (in minutes of inactivity)
  static const int sessionTimeoutMinutes = 15;

  // ==================== Storage Keys ====================

  /// Key for storing authentication token
  static const String storageKeyAuthToken = 'auth_token';

  /// Key for storing refresh token
  static const String storageKeyRefreshToken = 'refresh_token';

  /// Key for storing user data
  static const String storageKeyUserData = 'user_data';

  /// Key for storing user preferences
  static const String storageKeyUserPreferences = 'user_preferences';

  /// Key for storing last login timestamp
  static const String storageKeyLastLogin = 'last_login';

  // ==================== Pagination ====================

  /// Default number of items per page
  static const int pageSize = 20;

  /// Initial page number (0-based or 1-based depending on API)
  static const int initialPage = 1;

  /// Maximum items to load at once
  static const int maxItemsPerLoad = 100;

  // ==================== Validation ====================

  /// Minimum password length
  static const int minPasswordLength = 6;

  /// Minimum username length
  static const int minUsernameLength = 3;

  /// Maximum username length
  static const int maxUsernameLength = 20;

  /// Minimum OTP length
  static const int otpLength = 6;

  // ==================== Currency & Pricing ====================

  /// Currency symbol for the app
  static const String currencySymbol = '\$';

  /// Number of decimal places for prices
  static const int priceDecimalPlaces = 2;

  /// Decimal separator used in prices
  static const String decimalSeparator = '.';

  /// Tax percentage (in %)
  static const double taxPercentage = 10.0;

  /// Delivery fee
  static const double deliveryFee = 2.99;

  /// Minimum order amount
  static const double minimumOrderAmount = 15.00;

  // ==================== Cache Settings ====================

  /// Menu items cache duration
  static const Duration menuCacheDuration = Duration(hours: 2);

  /// User profile cache duration
  static const Duration profileCacheDuration = Duration(hours: 1);

  /// Order history cache duration
  static const Duration orderCacheDuration = Duration(minutes: 30);

  // ==================== Feature Flags ====================

  /// Enable/disable test mode
  static const bool isTestMode = false;

  /// Enable/disable debug logging
  static const bool enableDebugLogging = true;

  /// Enable/disable analytics
  static const bool enableAnalytics = true;

  /// Enable/disable push notifications
  static const bool enablePushNotifications = true;

  // ==================== UI Configuration ====================

  /// Animation duration for standard transitions
  static const Duration standardAnimationDuration = Duration(milliseconds: 300);

  /// Animation duration for quick transitions
  static const Duration quickAnimationDuration = Duration(milliseconds: 150);

  /// Animation duration for slow transitions
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  /// Standard border radius for UI elements
  static const double standardBorderRadius = 8.0;

  /// Standard padding value
  static const double standardPadding = 16.0;

  /// Standard margin value
  static const double standardMargin = 16.0;

  // ==================== Error Messages ====================

  /// Generic error message
  static const String genericErrorMessage =
      'An error occurred. Please try again.';

  /// Network error message
  static const String networkErrorMessage =
      'Network error. Please check your connection.';

  /// Timeout error message
  static const String timeoutErrorMessage =
      'Request timed out. Please try again.';

  /// Authentication error message
  static const String authErrorMessage =
      'Authentication failed. Please login again.';

  /// Validation error message
  static const String validationErrorMessage =
      'Please check your input and try again.';

  /// Not found error message
  static const String notFoundErrorMessage =
      'The requested item was not found.';

  /// Unauthorized error message
  static const String unauthorizedErrorMessage =
      'You are not authorized to perform this action.';

  /// Server error message
  static const String serverErrorMessage =
      'Server error. Please try again later.';

  // ==================== Success Messages ====================

  /// Generic success message
  static const String successMessage = 'Operation completed successfully.';

  /// Login success message
  static const String loginSuccessMessage = 'Login successful!';

  /// Logout success message
  static const String logoutSuccessMessage = 'Logged out successfully.';

  /// Item added success message
  static const String itemAddedMessage = 'Item added successfully.';

  /// Item updated success message
  static const String itemUpdatedMessage = 'Item updated successfully.';

  /// Item deleted success message
  static const String itemDeletedMessage = 'Item deleted successfully.';

  /// Order placed success message
  static const String orderPlacedMessage = 'Order placed successfully!';

  /// Profile updated success message
  static const String profileUpdatedMessage = 'Profile updated successfully.';

  // ==================== Confirmation Messages ====================

  /// Confirm delete message
  static const String confirmDeleteMessage =
      'Are you sure you want to delete this item?';

  /// Confirm logout message
  static const String confirmLogoutMessage = 'Are you sure you want to logout?';

  /// Confirm order cancellation message
  static const String confirmCancelOrderMessage =
      'Are you sure you want to cancel this order?';
}

/// Product/Menu-related constants
class ProductConfig {
  ProductConfig._();

  /// Available product categories
  static const List<String> categories = [
    'pizza',
    'burgers',
    'pasta',
    'salads',
    'desserts',
    'drinks',
  ];

  /// Default product image URL when no image is available
  static const String defaultProductImage =
      'assets/images/placeholder_product.png';

  /// Minimum product price
  static const double minPrice = 0.99;

  /// Maximum product price
  static const double maxPrice = 999.99;

  /// Default preparation time (in minutes)
  static const int defaultPrepTime = 15;

  /// Popular product badge threshold (number of orders)
  static const int popularBadgeThreshold = 100;

  /// Best seller badge threshold (rating)
  static const double bestSellerThreshold = 4.5;

  /// Product availability status
  static const String statusAvailable = 'available';
  static const String statusUnavailable = 'unavailable';
  static const String statusOutOfStock = 'out_of_stock';
}

/// Order-related constants
class OrderConfig {
  OrderConfig._();

  /// Order status values
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusPreparing = 'preparing';
  static const String statusReady = 'ready';
  static const String statusDelivering = 'delivering';
  static const String statusDelivered = 'delivered';
  static const String statusCancelled = 'cancelled';

  /// Payment methods
  static const String paymentMethodCard = 'card';
  static const String paymentMethodCash = 'cash';
  static const String paymentMethodWallet = 'wallet';
  static const String paymentMethodUpi = 'upi';

  /// Delivery types
  static const String deliveryTypePickup = 'pickup';
  static const String deliveryTypeDelivery = 'delivery';

  /// Time to auto-cancel unpaid order (in minutes)
  static const int autoCancelTimeMinutes = 15;

  /// Maximum items per order
  static const int maxItemsPerOrder = 50;

  /// Minimum items per order
  static const int minItemsPerOrder = 1;
}

/// User roles and permissions
class UserConfig {
  UserConfig._();

  /// User roles
  static const String roleCustomer = 'customer';
  static const String roleAdmin = 'admin';
  static const String roleDriver = 'driver';

  /// Default user avatar when no profile picture
  static const String defaultAvatarUrl = 'assets/images/placeholder_avatar.png';

  /// Supported user roles list
  static const List<String> supportedRoles = [
    roleCustomer,
    roleAdmin,
    roleDriver,
  ];
}

/// Notification configuration
class NotificationConfig {
  NotificationConfig._();

  /// Notification types
  static const String typeOrderUpdate = 'order_update';
  static const String typePromotion = 'promotion';
  static const String typeSystem = 'system';
  static const String typePayment = 'payment';

  /// Keep notifications for this many days
  static const int notificationRetentionDays = 30;

  /// Maximum notifications to display
  static const int maxNotificationsToDisplay = 50;
}

/// Analytics event names
class AnalyticsConfig {
  AnalyticsConfig._();

  /// Event: User logged in
  static const String eventLogin = 'user_login';

  /// Event: User logged out
  static const String eventLogout = 'user_logout';

  /// Event: User viewed product
  static const String eventProductViewed = 'product_viewed';

  /// Event: User added item to cart
  static const String eventAddToCart = 'add_to_cart';

  /// Event: User removed item from cart
  static const String eventRemoveFromCart = 'remove_from_cart';

  /// Event: User placed order
  static const String eventOrderPlaced = 'order_placed';

  /// Event: User completed order
  static const String eventOrderCompleted = 'order_completed';

  /// Event: User cancelled order
  static const String eventOrderCancelled = 'order_cancelled';

  /// Event: User made payment
  static const String eventPayment = 'payment_made';
}

/// Firebase configuration (if using Firebase)
class FirebaseConfig {
  FirebaseConfig._();

  /// Firebase project ID
  static const String projectId = 'eatery-management-app';

  /// Collections names in Firestore
  static const String usersCollection = 'users';
  static const String ordersCollection = 'orders';
  static const String productsCollection = 'products';
  static const String cartItemsCollection = 'cart_items';
}

/// API Endpoints
class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const String authLogin = '/auth/login';
  static const String authSignup = '/auth/signup';
  static const String authLogout = '/auth/logout';
  static const String authRefreshToken = '/auth/refresh-token';
  static const String authChangePassword = '/auth/change-password';

  // Menu endpoints
  static const String menuItems = '/menu/items';
  static const String menuCategories = '/menu/categories';
  static const String menuSearch = '/menu/search';
  static const String menuItemDetails = '/menu/items/{id}';

  // Order endpoints
  static const String ordersCreate = '/orders';
  static const String ordersHistory = '/orders/history';
  static const String ordersDetails = '/orders/{id}';
  static const String ordersCancel = '/orders/{id}/cancel';
  static const String ordersTrack = '/orders/{id}/track';

  // User endpoints
  static const String userProfile = '/users/profile';
  static const String userUpdate = '/users/profile';
  static const String userAddresses = '/users/addresses';
  static const String userPaymentMethods = '/users/payment-methods';

  // Cart endpoints
  static const String cartGet = '/cart';
  static const String cartAdd = '/cart/items';
  static const String cartUpdate = '/cart/items/{id}';
  static const String cartRemove = '/cart/items/{id}';
  static const String cartClear = '/cart/clear';
}
