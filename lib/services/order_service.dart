import 'dart:convert';
import '../models/order_model.dart';
import '../config/constants.dart';
import '../utils/logger.dart';
import 'secure_storage_service.dart';

/// Order Service for managing customer orders
class OrderService {
  static final OrderService _instance = OrderService._internal();
  final SecureStorageService _secureStorage = SecureStorageService();

  final List<Order> _orders = [];

  factory OrderService() {
    return _instance;
  }

  OrderService._internal();

  /// Initialize order service
  Future<void> initialize() async {
    try {
      AppLogger.info('Initializing OrderService');
      // Load saved orders from storage if any
      // This could load from local database or secure storage
    } catch (e) {
      AppLogger.error('Error initializing OrderService: $e');
    }
  }

  /// Create a new order
  Future<Order> createOrder({
    required String userId,
    required List<CartItem> items,
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
      AppLogger.info('Creating new order for user: $userId');

      if (items.isEmpty) {
        throw OrderException('Cart is empty');
      }

      // Calculate totals
      final subtotal = items.fold<double>(
        0,
        (sum, item) => sum + item.totalPrice,
      );
      final total = subtotal + tax + deliveryFee - discount;

      // Validate required fields
      if (customerName.isEmpty || customerPhone.isEmpty) {
        throw OrderException('Customer name and phone are required');
      }

      if (orderType == OrderType.delivery && deliveryAddress == null) {
        throw OrderException(
          'Delivery address is required for delivery orders',
        );
      }

      final order = Order(
        id: _generateOrderId(),
        userId: userId,
        items: items,
        orderType: orderType,
        status: OrderStatus.pending,
        customerName: customerName,
        customerPhone: customerPhone,
        customerEmail: customerEmail,
        deliveryAddress: deliveryAddress,
        subtotal: subtotal,
        tax: tax,
        deliveryFee: deliveryFee,
        discount: discount,
        total: total,
        specialInstructions: specialInstructions,
        createdAt: DateTime.now(),
        isPaid: false,
      );

      _orders.add(order);

      // Save order to storage
      await _saveOrder(order);

      AppLogger.info(
        'Order created successfully: ${order.id} - Total: \$${order.total}',
      );
      return order;
    } catch (e) {
      AppLogger.error('Error creating order: $e');
      rethrow;
    }
  }

  /// Get order by ID
  Future<Order?> getOrderById(String orderId) async {
    try {
      AppLogger.fine('Fetching order: $orderId');
      return _orders.cast<Order?>().firstWhere(
        (order) => order?.id == orderId,
        orElse: () => null,
      );
    } catch (e) {
      AppLogger.error('Error fetching order: $e');
      return null;
    }
  }

  /// Get all orders for a user
  Future<List<Order>> getUserOrders(String userId) async {
    try {
      AppLogger.info('Fetching orders for user: $userId');
      await Future.delayed(const Duration(milliseconds: 300));
      return _orders.where((order) => order.userId == userId).toList();
    } catch (e) {
      AppLogger.error('Error fetching user orders: $e');
      rethrow;
    }
  }

  /// Get pending orders
  Future<List<Order>> getPendingOrders(String userId) async {
    try {
      AppLogger.info('Fetching pending orders for user: $userId');
      return _orders
          .where(
            (order) =>
                order.userId == userId &&
                (order.status == OrderStatus.pending ||
                    order.status == OrderStatus.confirmed ||
                    order.status == OrderStatus.preparing ||
                    order.status == OrderStatus.ready),
          )
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching pending orders: $e');
      rethrow;
    }
  }

  /// Get completed orders
  Future<List<Order>> getCompletedOrders(String userId) async {
    try {
      AppLogger.info('Fetching completed orders for user: $userId');
      return _orders
          .where(
            (order) =>
                order.userId == userId &&
                (order.status == OrderStatus.delivered ||
                    order.status == OrderStatus.cancelled),
          )
          .toList();
    } catch (e) {
      AppLogger.error('Error fetching completed orders: $e');
      rethrow;
    }
  }

  /// Update order status
  Future<Order?> updateOrderStatus(String orderId, String newStatus) async {
    try {
      AppLogger.info('Updating order $orderId status to $newStatus');
      final index = _orders.indexWhere((order) => order.id == orderId);

      if (index == -1) {
        throw OrderException('Order not found');
      }

      final updatedOrder = Order(
        id: _orders[index].id,
        userId: _orders[index].userId,
        items: _orders[index].items,
        orderType: _orders[index].orderType,
        status: newStatus,
        customerName: _orders[index].customerName,
        customerPhone: _orders[index].customerPhone,
        customerEmail: _orders[index].customerEmail,
        deliveryAddress: _orders[index].deliveryAddress,
        subtotal: _orders[index].subtotal,
        tax: _orders[index].tax,
        deliveryFee: _orders[index].deliveryFee,
        discount: _orders[index].discount,
        total: _orders[index].total,
        specialInstructions: _orders[index].specialInstructions,
        createdAt: _orders[index].createdAt,
        completedAt: newStatus == OrderStatus.delivered ? DateTime.now() : null,
        paymentMethod: _orders[index].paymentMethod,
        isPaid: _orders[index].isPaid,
        notes: _orders[index].notes,
      );

      _orders[index] = updatedOrder;
      await _saveOrder(updatedOrder);

      AppLogger.info('Order status updated successfully');
      return updatedOrder;
    } catch (e) {
      AppLogger.error('Error updating order status: $e');
      rethrow;
    }
  }

  /// Mark order as paid
  Future<Order?> markAsPaid(
    String orderId, {
    String paymentMethod = 'Card',
  }) async {
    try {
      AppLogger.info('Marking order $orderId as paid');
      final index = _orders.indexWhere((order) => order.id == orderId);

      if (index == -1) {
        throw OrderException('Order not found');
      }

      final updatedOrder = Order(
        id: _orders[index].id,
        userId: _orders[index].userId,
        items: _orders[index].items,
        orderType: _orders[index].orderType,
        status: _orders[index].status,
        customerName: _orders[index].customerName,
        customerPhone: _orders[index].customerPhone,
        customerEmail: _orders[index].customerEmail,
        deliveryAddress: _orders[index].deliveryAddress,
        subtotal: _orders[index].subtotal,
        tax: _orders[index].tax,
        deliveryFee: _orders[index].deliveryFee,
        discount: _orders[index].discount,
        total: _orders[index].total,
        specialInstructions: _orders[index].specialInstructions,
        createdAt: _orders[index].createdAt,
        completedAt: _orders[index].completedAt,
        paymentMethod: paymentMethod,
        isPaid: true,
        notes: _orders[index].notes,
      );

      _orders[index] = updatedOrder;
      await _saveOrder(updatedOrder);

      AppLogger.info('Order marked as paid');
      return updatedOrder;
    } catch (e) {
      AppLogger.error('Error marking order as paid: $e');
      rethrow;
    }
  }

  /// Cancel order
  Future<Order?> cancelOrder(String orderId, {String reason = ''}) async {
    try {
      AppLogger.info('Cancelling order: $orderId');
      return await updateOrderStatus(orderId, OrderStatus.cancelled);
    } catch (e) {
      AppLogger.error('Error cancelling order: $e');
      rethrow;
    }
  }

  /// Calculate order total
  double calculateTotal({
    required double subtotal,
    double tax = 0,
    double deliveryFee = 0,
    double discount = 0,
  }) {
    return subtotal + tax + deliveryFee - discount;
  }

  /// Calculate tax (e.g., 10% of subtotal)
  double calculateTax(double subtotal, {double taxRate = 0.10}) {
    return subtotal * taxRate;
  }

  /// Get delivery fee based on distance
  double getDeliveryFee({required String orderType}) {
    if (orderType == OrderType.delivery) {
      return 2.50; // Flat fee or calculate based on distance
    }
    return 0;
  }

  /// Generate unique order ID
  String _generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORD$timestamp';
  }

  /// Save order to storage
  Future<void> _saveOrder(Order order) async {
    try {
      final key = '${AppConstants.cartItemsKey}_${order.id}';
      await _secureStorage.saveString(key, jsonEncode(order.toJson()));
    } catch (e) {
      AppLogger.error('Error saving order to storage: $e');
    }
  }

  /// Clear all orders
  void clearOrders() {
    _orders.clear();
    AppLogger.info('All orders cleared');
  }
}

/// Custom exception for order errors
class OrderException implements Exception {
  final String message;

  OrderException(this.message);

  @override
  String toString() => message;
}
