import '../config/constants.dart';

/// Cart Item representing an item in the shopping cart
class CartItem {
  final String id;
  final String menuItemId;
  final String itemName;
  final double itemPrice;
  final String imageUrl;
  int quantity;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.menuItemId,
    required this.itemName,
    required this.itemPrice,
    required this.imageUrl,
    this.quantity = 1,
    required this.addedAt,
  });

  /// Get total price for this cart item
  double get totalPrice => itemPrice * quantity;

  /// Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      menuItemId: json['menuItemId'] as String,
      itemName: json['itemName'] as String,
      itemPrice: (json['itemPrice'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      quantity: json['quantity'] as int? ?? 1,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menuItemId': menuItemId,
      'itemName': itemName,
      'itemPrice': itemPrice,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'CartItem(id: $id, itemName: $itemName, quantity: $quantity, total: \$${totalPrice.toStringAsFixed(2)})';
}

/// Order Model representing a customer order
class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final String orderType; // Delivery, Takeaway, Dine-in
  final String status; // pending, confirmed, preparing, ready, delivered
  final String customerName;
  final String customerPhone;
  final String? customerEmail;
  final String? deliveryAddress;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double discount;
  final double total;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? paymentMethod;
  final bool isPaid;
  final String? notes;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.orderType,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    this.customerEmail,
    this.deliveryAddress,
    required this.subtotal,
    this.tax = 0,
    this.deliveryFee = 0,
    this.discount = 0,
    required this.total,
    this.specialInstructions,
    required this.createdAt,
    this.completedAt,
    this.paymentMethod,
    this.isPaid = false,
    this.notes,
  });

  /// Create Order from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List)
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      orderType: json['orderType'] as String,
      status: json['status'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String,
      customerEmail: json['customerEmail'] as String?,
      deliveryAddress: json['deliveryAddress'] as String?,
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num? ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] as num? ?? 0).toDouble(),
      discount: (json['discount'] as num? ?? 0).toDouble(),
      total: (json['total'] as num).toDouble(),
      specialInstructions: json['specialInstructions'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      paymentMethod: json['paymentMethod'] as String?,
      isPaid: json['isPaid'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'orderType': orderType,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'deliveryAddress': deliveryAddress,
      'subtotal': subtotal,
      'tax': tax,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
      'specialInstructions': specialInstructions,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'notes': notes,
    };
  }

  /// Get order status display text
  String get statusDisplayText {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      default:
        return status;
    }
  }

  /// Check if order is completed
  bool get isCompleted =>
      status == OrderStatus.delivered || status == OrderStatus.cancelled;

  /// Get item count
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  String toString() =>
      'Order(id: $id, status: $status, total: \$${total.toStringAsFixed(2)})';
}
