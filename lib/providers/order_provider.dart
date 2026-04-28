import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/order_service.dart';
import '../utils/logger.dart';

/// Order Provider for managing order state
class OrderProvider extends ChangeNotifier {
  final OrderService _orderService;

  final List<CartItem> _cartItems = [];
  List<Order> _userOrders = [];
  List<Order> _pendingOrders = [];
  List<Order> _completedOrders = [];

  Order? _lastOrder;
  String? _errorMessage;
  bool _isLoading = false;

  OrderProvider(this._orderService) {
    _initialize();
  }

  // Getters
  List<CartItem> get cartItems => _cartItems;
  List<Order> get userOrders => _userOrders;
  List<Order> get pendingOrders => _pendingOrders;
  List<Order> get completedOrders => _completedOrders;
  Order? get lastOrder => _lastOrder;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  int get cartItemCount => _cartItems.length;
  double get cartSubtotal =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  /// Initialize provider
  Future<void> _initialize() async {
    try {
      AppLogger.info('Initializing OrderProvider');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error initializing OrderProvider: $e');
    }
  }

  /// Add item to cart
  void addToCart({
    required String menuItemId,
    required String itemName,
    required double itemPrice,
    required String imageUrl,
    int quantity = 1,
  }) {
    try {
      // Check if item already exists in cart
      final existingItemIndex = _cartItems.indexWhere(
        (item) => item.menuItemId == menuItemId,
      );

      if (existingItemIndex != -1) {
        // Item exists, increase quantity
        _cartItems[existingItemIndex].quantity += quantity;
      } else {
        // New item, add to cart
        final cartItem = CartItem(
          id: '${DateTime.now().millisecondsSinceEpoch}_$menuItemId',
          menuItemId: menuItemId,
          itemName: itemName,
          itemPrice: itemPrice,
          imageUrl: imageUrl,
          quantity: quantity,
          addedAt: DateTime.now(),
        );
        _cartItems.add(cartItem);
      }

      _errorMessage = null;
      notifyListeners();
      AppLogger.info('Item added to cart: $itemName (qty: $quantity)');
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      AppLogger.error('Error adding to cart: $e');
    }
  }

  /// Remove item from cart
  void removeFromCart(String cartItemId) {
    try {
      _cartItems.removeWhere((item) => item.id == cartItemId);
      _errorMessage = null;
      notifyListeners();
      AppLogger.info('Item removed from cart');
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      AppLogger.error('Error removing from cart: $e');
    }
  }

  /// Update item quantity
  void updateItemQuantity(String cartItemId, int newQuantity) {
    try {
      if (newQuantity <= 0) {
        removeFromCart(cartItemId);
        return;
      }

      final itemIndex = _cartItems.indexWhere((item) => item.id == cartItemId);
      if (itemIndex != -1) {
        _cartItems[itemIndex].quantity = newQuantity;
        _errorMessage = null;
        notifyListeners();
        AppLogger.info('Item quantity updated');
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      AppLogger.error('Error updating quantity: $e');
    }
  }

  /// Clear cart
  void clearCart() {
    try {
      _cartItems.clear();
      _errorMessage = null;
      notifyListeners();
      AppLogger.info('Cart cleared');
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      AppLogger.error('Error clearing cart: $e');
    }
  }

  /// Place order
  Future<Order?> placeOrder({
    required String userId,
    required String orderType,
    required String customerName,
    required String customerPhone,
    String? customerEmail,
    String? deliveryAddress,
    String? specialInstructions,
    double tax = 0,
    double deliveryFee = 0,
    double discount = 0,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      if (_cartItems.isEmpty) {
        throw OrderException('Cart is empty');
      }

      final order = await _orderService.createOrder(
        userId: userId,
        items: _cartItems,
        orderType: orderType,
        customerName: customerName,
        customerPhone: customerPhone,
        customerEmail: customerEmail,
        deliveryAddress: deliveryAddress,
        specialInstructions: specialInstructions,
        tax: tax,
        deliveryFee: deliveryFee,
        discount: discount,
      );

      _lastOrder = order;
      _userOrders.add(order);
      _cartItems.clear();

      _isLoading = false;
      notifyListeners();
      AppLogger.info('Order placed successfully: ${order.id}');

      return order;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error placing order: $e');
      return null;
    }
  }

  /// Load user orders
  Future<void> loadUserOrders(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _userOrders = await _orderService.getUserOrders(userId);
      _errorMessage = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error loading user orders: $e');
    }
  }

  /// Load pending orders
  Future<void> loadPendingOrders(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _pendingOrders = await _orderService.getPendingOrders(userId);
      _errorMessage = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error loading pending orders: $e');
    }
  }

  /// Load completed orders
  Future<void> loadCompletedOrders(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _completedOrders = await _orderService.getCompletedOrders(userId);
      _errorMessage = null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error loading completed orders: $e');
    }
  }

  /// Cancel order
  Future<bool> cancelOrder(String orderId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _orderService.cancelOrder(orderId);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      AppLogger.error('Error cancelling order: $e');
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

/// Custom exception for order errors
class OrderException implements Exception {
  final String message;
  OrderException(this.message);
  @override
  String toString() => message;
}
