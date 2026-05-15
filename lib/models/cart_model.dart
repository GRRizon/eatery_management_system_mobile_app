import './menu_item_model.dart';

/// Represents an item in the shopping cart
class CartItem {
  final MenuItem menuItem;
  int quantity;

  CartItem({required this.menuItem, required this.quantity});

  // Convenience getters for backward compatibility
  String get id => menuItem.id;
  String get menuItemId => menuItem.id;
  String get name => menuItem.name;
  double get price => menuItem.price;
  String? get imageUrl => menuItem.imageUrl;
  String get itemName => menuItem.name;
  double get itemPrice => menuItem.price;

  /// Calculate the total price for this cart item
  double get totalPrice => menuItem.price * quantity;

  CartItem copyWith({MenuItem? menuItem, int? quantity}) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'CartItem(menuItem: ${menuItem.name}, quantity: $quantity, totalPrice: $totalPrice)';
  }
}

/// Represents the shopping cart
class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;

  Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  Cart copyWith({
    String? id,
    String? userId,
    List<CartItem>? items,
    double? subtotal,
    double? tax,
    double? deliveryFee,
    double? total,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cart(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
