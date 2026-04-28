/// Application Constants
class AppConstants {
  // App Information
  static const String appName = 'Eatery Management System';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Fresh coffee, Tasty food.';

  // API Endpoints
  static const String baseUrl = 'https://api.eatery.local/v1';
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/register';
  static const String menuEndpoint = '/menu';
  static const String ordersEndpoint = '/orders';
  static const String userEndpoint = '/user';

  // Timeout Duration
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration debounceDelay = Duration(milliseconds: 500);

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  static const String lastLoginKey = 'last_login';
  static const String cartItemsKey = 'cart_items';
  static const String favoritesKey = 'favorites';
  static const String settingsKey = 'app_settings';

  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;

  // Messages
  static const String welcomeMessage = 'Welcome to Eatery!';
  static const String noInternetMessage = 'No internet connection';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String invalidCredentialsMessage =
      'Invalid username or password';
  static const String successMessage = 'Success!';
  static const String errorMessage = 'An error occurred. Please try again.';

  // Social Media URLs
  static const String facebookUrl = 'https://www.facebook.com/G.R.REZON';
  static const String instagramUrl = 'https://www.instagram.com/g.r.rizon/';
  static const String twitterUrl = 'https://x.com/GR_Rizon';

  // Contact Information
  static const String contactEmail = 'info@eatery.local';
  static const String contactPhone = '+1-800-EATERY';
  static const String businessHours = 'Mon-Sun: 8:00 AM - 10:00 PM';

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 1000);

  // Pagination
  static const int itemsPerPage = 20;
  static const int initialPageNumber = 1;

  // Cache Duration
  static const Duration cacheDuration = Duration(hours: 24);
  static const Duration shortCacheDuration = Duration(hours: 1);
  static const Duration sessionDuration = Duration(hours: 8);
}

/// Regular Expressions
class RegexPatterns {
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern =
      r'^[+]?[(]?[0-9]{1,4}[)]?[-\s.]?[(]?[0-9]{1,4}[)]?[-\s.]?[0-9]{1,9}$';
  static const String passwordPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
  static const String usernamePattern = r'^[a-zA-Z0-9_-]{3,50}$';
  static const String namePattern = r'^[a-zA-Z\s]{2,100}$';
}

/// Order Status
class OrderStatus {
  static const String pending = 'pending';
  static const String confirmed = 'confirmed';
  static const String preparing = 'preparing';
  static const String ready = 'ready';
  static const String delivered = 'delivered';
  static const String cancelled = 'cancelled';
}

/// Order Type
class OrderType {
  static const String delivery = 'Delivery';
  static const String takeaway = 'Takeaway';
  static const String dineIn = 'Dine-in';
}
