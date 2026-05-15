import 'dart:async';
import '../core/base/base_provider.dart';
import '../core/exceptions/app_exceptions.dart';
import '../core/interfaces/services.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';

/// Provider for managing order state and operations.
///
/// This provider connects the UI with the [IOrderService] to handle
/// order placement, history, and tracking.
class OrderProviderImpl extends BaseProvider {
  final IOrderService _orderService;
  final IAuthService _authService;

  List<Order> _orderHistory = []; // In-memory cache for order history
  Order? _currentOrder;

  OrderProviderImpl(this._orderService, this._authService) {
    _initialize();
  }

  @override
  String get providerName => 'OrderProvider';

  // ==================== Getters ====================

  /// The user's list of past orders.
  List<Order> get orderHistory => List.unmodifiable(_orderHistory);

  /// The most recently placed or viewed order.
  Order? get currentOrder => _currentOrder;

  // ==================== Initialization ====================

  void _initialize() {
    // Initialize provider
    logInfo('Initializing OrderProviderImpl');
  }

  // ==================== Methods ====================

  /// Places a new order using items from the cart.
  ///
  /// This is the method your "Proceed to Checkout" button will ultimately call.
  ///
  /// Returns `true` if the order was placed successfully.
  Future<bool> placeOrder({
    required List<CartItem> items,
    required String deliveryAddress,
    required String paymentMethod,
  }) async {
    return await _execute(() async {
      if (!_authService.isAuthenticated) {
        throw AuthException(
          message: 'You must be logged in to place an order.',
        );
      }
      if (items.isEmpty) {
        throw ValidationException(message: 'Your cart is empty.');
      }

      logInfo('Placing order...');
      final newOrder = await _orderService.placeOrder(
        items: items,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
      );
      _currentOrder = newOrder;
      _orderHistory.insert(0, newOrder); // Add to top of history
      logInfo('Order placed successfully: ${newOrder.id}');
      safeNotifyListeners();
    });
  }

  /// Fetches the user's order history from the service.
  Future<void> fetchOrderHistory() async {
    await _execute(() async {
      logInfo('Fetching order history...');
      _orderHistory = await _orderService.getOrderHistory();
      safeNotifyListeners();
    });
  }

  /// Cancels an order by its ID.
  Future<bool> cancelOrder(String orderId) async {
    return await _execute(() async {
      logInfo('Cancelling order: $orderId');
      await _orderService.cancelOrder(orderId);

      // Update the order status in the local history list
      final index = _orderHistory.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        final order = _orderHistory[index];
        _orderHistory[index] = Order(
          id: order.id,
          userId: order.userId,
          items: order.items,
          totalAmount: order.totalAmount,
          deliveryAddress: order.deliveryAddress,
          paymentMethod: order.paymentMethod,
          status: OrderStatus.cancelled,
          createdAt: order.createdAt,
          orderType: order.orderType,
          customerName: order.customerName,
          customerPhone: order.customerPhone,
          customerEmail: order.customerEmail,
          subtotal: order.subtotal,
          tax: order.tax,
          deliveryFee: order.deliveryFee,
          discount: order.discount,
          specialInstructions: order.specialInstructions,
          isPaid: order.isPaid,
          notes: order.notes,
        );
        safeNotifyListeners();
      }
      logInfo('Order cancelled successfully: $orderId');
    });
  }

  /// Provides a stream for real-time tracking of an order's status.
  Stream<Order> trackOrder(String orderId) {
    try {
      return _orderService.trackOrder(orderId).handleError((error) {
        handleException(
          UnexpectedException(
            message: 'Failed to track order.',
            originalException: error,
          ),
        );
      });
    } on AppException catch (e) {
      handleException(e);
      return Stream.error(e);
    }
  }

  /// A helper to execute operations with standardized loading and error handling.
  Future<bool> _execute(Future<void> Function() operation) async {
    if (isLoading) return false; // Prevent concurrent operations

    try {
      verifyNotDisposed();
      setLoading(true);
      clearError();

      await operation();

      return true;
    } on AppException catch (e) {
      handleException(e);
      return false;
    } catch (e) {
      handleException(
        UnexpectedException(
          message: 'An unexpected error occurred in the order provider.',
          originalException: e,
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  @override
  void resetState() {
    _orderHistory = [];
    _currentOrder = null;
    super.resetState();
  }
}
