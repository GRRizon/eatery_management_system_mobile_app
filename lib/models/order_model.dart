import 'cart_model.dart';

/// Represents the status of an order
enum OrderStatus {
  pending,
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

/// Enum for order type
enum OrderType { delivery, pickup, dineIn }

/// Represents a customer order
class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final String deliveryAddress;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;
  final OrderType? orderType;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final double? subtotal;
  final double? tax;
  final double? deliveryFee;
  final double? discount;
  final String? specialInstructions;
  final bool? isPaid;
  final String? notes;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.status = OrderStatus.pending,
    required this.createdAt,
    this.orderType,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.subtotal,
    this.tax,
    this.deliveryFee,
    this.discount,
    this.specialInstructions,
    this.isPaid,
    this.notes,
  });

  // Convenience getters
  String get statusDisplayText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get total => totalAmount;

  @override
  String toString() {
    return 'Order(id: $id, items: ${items.length}, total: $totalAmount, status: $status)';
  }
}
