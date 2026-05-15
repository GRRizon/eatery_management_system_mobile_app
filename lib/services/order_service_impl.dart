import 'dart:async';

import '../core/base/base_service.dart';
import '../core/interfaces/services.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';

/// Mock implementation of the IOrderService.
///
/// This service simulates order management operations like placing,
/// tracking, and viewing order history. In a real application, this
/// would interact with a backend API.
class OrderServiceImpl extends BaseService implements IOrderService {
  /// In-memory list of orders to simulate a database.
  final List<Order> _orders = [];

  @override
  String get serviceName => 'OrderService';

  /// Places a new order.
  ///
  /// Simulates creating an order from cart items and returns the created order.
  /// In a real app, this would make an API call to the backend.
  @override
  Future<Order> placeOrder({
    required List<CartItem> items,
    required String deliveryAddress,
    required String paymentMethod,
  }) async {
    verifyInitialized();
    logInfo('Placing a new order...');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    final total = items.fold(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    final newOrder = Order(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_001', // Mock user ID
      items: items,
      totalAmount: total,
      createdAt: DateTime.now(),
      status: OrderStatus.pending,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
    );

    _orders.add(newOrder);
    logInfo('Order placed successfully with ID: ${newOrder.id}');
    return newOrder;
  }

  /// Retrieves the user's order history.
  @override
  Future<List<Order>> getOrderHistory() async {
    verifyInitialized();
    logInfo('Fetching order history...');
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_orders);
  }

  /// Retrieves details for a specific order.
  @override
  Future<Order?> getOrderDetails(String orderId) async {
    verifyInitialized();
    logInfo('Fetching details for order: $orderId');
    await Future.delayed(const Duration(milliseconds: 300));
    return _orders.firstWhere((order) => order.id == orderId);
  }

  /// Cancels an order.
  @override
  Future<void> cancelOrder(String orderId) async {
    verifyInitialized();
    logInfo('Cancelling order: $orderId');
    await Future.delayed(const Duration(milliseconds: 500));
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final order = _orders[orderIndex];
      _orders[orderIndex] = Order(
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
      logInfo('Order $orderId cancelled.');
    }
  }

  /// Simulates real-time order tracking.
  @override
  Stream<Order> trackOrder(String orderId) {
    // This is a simplified stream for demonstration.
    // A real implementation would use WebSockets or push notifications.
    return Stream.periodic(const Duration(seconds: 10), (tick) {
      final order = _orders.firstWhere((o) => o.id == orderId);
      // Simulate status progression
      final statusProgressions = [
        OrderStatus.pending,
        OrderStatus.confirmed,
        OrderStatus.preparing,
        OrderStatus.outForDelivery,
        OrderStatus.delivered,
      ];
      final nextStatus =
          statusProgressions[tick.clamp(0, statusProgressions.length - 1)];
      return Order(
        id: order.id,
        userId: order.userId,
        items: order.items,
        totalAmount: order.totalAmount,
        deliveryAddress: order.deliveryAddress,
        paymentMethod: order.paymentMethod,
        status: nextStatus,
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
    }).take(5);
  }
}
