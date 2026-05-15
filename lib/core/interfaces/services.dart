import '../exceptions/app_exceptions.dart';
import '../../models/user_model.dart';
import '../../models/menu_item_model.dart';
import '../../models/cart_model.dart';
import '../../models/order_model.dart';
import '../../models/address_model.dart';
import '../../models/payment_method_model.dart';

/// Contract for authentication services
///
/// Any authentication implementation should follow this interface
/// to ensure consistent behavior and allow for easy swapping of implementations.
///
/// This follows the Dependency Inversion Principle from SOLID principles.
///
/// Example implementations:
/// - MockAuthService (for testing)
/// - FirebaseAuthService
/// - RestApiAuthService
abstract class IAuthService {
  /// Check if user is currently authenticated
  bool get isAuthenticated;

  /// Get currently logged-in user
  User? get currentUser;

  /// Get authentication token
  String? get authToken;

  /// Initialize the authentication service
  /// Should be called once at app startup
  Future<void> initialize();

  /// Login user with credentials
  ///
  /// Throws [AuthException] if credentials are invalid
  /// Throws [NetworkException] if network operation fails
  /// Throws [ValidationException] if inputs are invalid
  Future<User> login({required String username, required String password});

  /// Register new user
  ///
  /// Throws [AuthException] if registration fails
  /// Throws [ValidationException] if inputs are invalid
  Future<User> signup({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required UserRole role,
  });

  /// Logout current user
  ///
  /// Clears all authentication data and tokens
  Future<void> logout();

  /// Refresh authentication token
  ///
  /// Should be called when token is about to expire
  /// Throws [AuthException] if refresh fails
  Future<String?> refreshToken();

  /// Get current authenticated user
  ///
  /// Throws [AuthException] if not authenticated
  Future<User?> getCurrentUser();

  /// Verify if token is valid
  ///
  /// Returns true if token is valid and not expired
  Future<bool> isTokenValid();
}

/// Contract for menu/product services
///
/// Handles all menu-related operations like fetching products and categories
abstract class IMenuService {
  /// Get all available menu items
  ///
  /// Throws [NetworkException] if fetch fails
  /// Returns cached items if network unavailable
  Future<List<MenuItem>> getAllMenuItems();

  /// Get menu items filtered by category
  ///
  /// Parameters:
  ///   - category: Category name to filter by
  ///
  /// Throws [ValidationException] if category is invalid
  /// Throws [NetworkException] if fetch fails
  Future<List<MenuItem>> getMenuItemsByCategory(String category);

  /// Search menu items by query
  ///
  /// Parameters:
  ///   - query: Search query (searches in name and description)
  ///
  /// Returns items matching the query
  Future<List<MenuItem>> searchMenuItems(String query);

  /// Get details for a specific menu item
  ///
  /// Parameters:
  ///   - itemId: ID of the menu item
  ///
  /// Throws [BusinessException] if item not found
  Future<MenuItem?> getMenuItemDetails(String itemId);

  /// Get all available categories
  Future<List<String>> getCategories();

  /// Refresh menu items from server
  ///
  /// Clears cache and fetches fresh data
  Future<void> refreshMenuItems();
}

/// Contract for cart services
///
/// Handles shopping cart operations
abstract class ICartService {
  /// Get current cart
  ///
  /// Returns current CartItem list
  Future<List<CartItem>> getCart();

  /// Add item to cart
  ///
  /// Parameters:
  ///   - item: MenuItem to add
  ///   - quantity: Number of items (default 1)
  ///
  /// Throws [ValidationException] if quantity is invalid
  Future<void> addToCart({required MenuItem item, required int quantity});

  /// Remove item from cart
  ///
  /// Parameters:
  ///   - itemId: ID of item to remove
  ///
  /// Throws [BusinessException] if item not in cart
  Future<void> removeFromCart(String itemId);

  /// Update item quantity
  ///
  /// Parameters:
  ///   - itemId: ID of item to update
  ///   - quantity: New quantity (0 to remove item)
  ///
  /// Throws [BusinessException] if item not in cart
  /// Throws [ValidationException] if quantity is invalid
  Future<void> updateQuantity({required String itemId, required int quantity});

  /// Clear entire cart
  Future<void> clearCart();

  /// Get cart total price
  ///
  /// Includes all items and optional tax/fees
  Future<double> getCartTotal();
}

/// Contract for order services
///
/// Handles order placement and tracking
abstract class IOrderService {
  /// Place new order from cart
  ///
  /// Parameters:
  ///   - items: List of cart items
  ///   - deliveryAddress: Delivery address
  ///   - paymentMethod: Payment method
  ///
  /// Returns created Order
  /// Throws [ValidationException] if order data is invalid
  /// Throws [NetworkException] if order placement fails
  Future<Order> placeOrder({
    required List<CartItem> items,
    required String deliveryAddress,
    required String paymentMethod,
  });

  /// Get order details
  ///
  /// Parameters:
  ///   - orderId: ID of the order
  ///
  /// Throws [BusinessException] if order not found
  Future<Order?> getOrderDetails(String orderId);

  /// Get user's order history
  ///
  /// Returns list of previous orders
  Future<List<Order>> getOrderHistory();

  /// Cancel order
  ///
  /// Parameters:
  ///   - orderId: ID of order to cancel
  ///
  /// Throws [BusinessException] if order cannot be cancelled
  /// (e.g., already delivered or cancelled)
  Future<void> cancelOrder(String orderId);

  /// Track order status
  ///
  /// Real-time status updates
  /// Returns stream of Order objects with updated status
  Stream<Order> trackOrder(String orderId);
}

/// Contract for user profile services
///
/// Handles user profile updates and settings
abstract class IUserService {
  /// Get user profile
  ///
  /// Returns full user profile with details
  Future<User?> getUserProfile();

  /// Update user profile
  ///
  /// Parameters:
  ///   - user: User object with updated fields
  ///
  /// Throws [ValidationException] if data is invalid
  /// Throws [NetworkException] if update fails
  Future<void> updateProfile(User user);

  /// Update user password
  ///
  /// Parameters:
  ///   - oldPassword: Current password
  ///   - newPassword: New password
  ///
  /// Throws [AuthException] if old password is wrong
  /// Throws [ValidationException] if password is weak
  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  });

  /// Add delivery address
  ///
  /// Parameters:
  ///   - address: Address to add
  ///
  /// Throws [ValidationException] if address is invalid
  Future<void> addAddress(Address address);

  /// Remove delivery address
  ///
  /// Parameters:
  ///   - addressId: ID of address to remove
  Future<void> removeAddress(String addressId);

  /// Add payment method
  ///
  /// Parameters:
  ///   - paymentMethod: Payment method to add
  ///
  /// Throws [ValidationException] if payment method is invalid
  Future<void> addPaymentMethod(PaymentMethod paymentMethod);

  /// Remove payment method
  ///
  /// Parameters:
  ///   - methodId: ID of payment method to remove
  Future<void> removePaymentMethod(String methodId);
}

/// Contract for storage services
///
/// Handles persistent data storage (local and secure)
abstract class IStorageService {
  /// Get value from storage
  ///
  /// Parameters:
  ///   - key: Key to retrieve
  ///
  /// Returns stored value or null if not found
  Future<String?> getValue(String key);

  /// Save value to storage
  ///
  /// Parameters:
  ///   - key: Storage key
  ///   - value: Value to store
  ///
  /// Throws [StorageException] if save fails
  Future<void> setValue(String key, String value);

  /// Delete value from storage
  ///
  /// Parameters:
  ///   - key: Key to delete
  ///
  /// Throws [StorageException] if delete fails
  Future<void> deleteValue(String key);

  /// Clear all storage
  ///
  /// Throws [StorageException] if clear fails
  Future<void> clearAll();
}
